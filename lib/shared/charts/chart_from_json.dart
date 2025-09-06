import 'dart:convert';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphic/graphic.dart' as g;

/// 判断一段代码是否为可识别的图表 JSON 规范
bool isChartSpecJson(String code) {
  try {
    final obj = jsonDecode(code);
    if (obj is! Map<String, dynamic>) return false;
    final chart = obj['chart'];
    final data = obj['data'];
    final encode = obj['encode'];
    if (chart is! String) return false;
    if (data is! List) return false;
    if (encode is! Map) return false;
    const supported = {'line', 'bar', 'scatter', 'pie'};
    return supported.contains(chart.toLowerCase());
  } catch (_) {
    return false;
  }
}

/// 预览图表并可导出 PNG
Future<void> showChartPreviewDialog(BuildContext context, String code) {
  Map<String, dynamic> spec;
  try {
    final obj = jsonDecode(code);
    if (obj is! Map<String, dynamic>) {
      throw Exception('JSON 顶层必须是对象');
    }
    spec = obj;
  } catch (e) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('图表 JSON 解析失败'),
        content: Text('$e'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭'))],
      ),
    );
  }

  final repaintKey = GlobalKey();
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final title = spec['title'] as String?;
      final chart = _buildChartFromSpec(spec);
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title ?? '图表预览', style: Theme.of(ctx).textTheme.titleMedium),
                    ),
                    IconButton(
                      tooltip: '保存为 PNG',
                      onPressed: () async {
                        await _exportAsPng(ctx, repaintKey);
                      },
                      icon: const Icon(Icons.download),
                    ),
                    IconButton(
                      tooltip: '关闭',
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: RepaintBoundary(
                    key: repaintKey,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.surface,
                        border: Border.all(color: Theme.of(ctx).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: chart,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildChartFromSpec(Map<String, dynamic> spec) {
  final chartType = (spec['chart'] as String?)?.toLowerCase();
  final data = (spec['data'] as List? ?? const [])
      .whereType<Map>()
      .toList(growable: false);
  final encode = (spec['encode'] as Map? ?? const {})
      .map((k, v) => MapEntry(k.toString(), v));
  final axis = (spec['axis'] as Map?)?.map((k, v) => MapEntry(k.toString(), v));
  final options = (spec['options'] as Map?)?.map((k, v) => MapEntry(k.toString(), v));

  final xField = encode['x'] as String?;
  final yField = encode['y'] as String?;
  final colorField = encode['color'] as String?; // 可选

  final variables = <String, g.Variable>{};
  // 推断字段类型并构造合适的 Variable 泛型
  if (xField != null) {
    final sample = _firstNonNull(data, xField);
    if (sample is num) {
      variables['x'] = g.Variable<Map, num>(accessor: (Map map) {
        final v = map[xField];
        if (v is num) return v;
        if (v is String) {
          final d = num.tryParse(v);
          return d ?? 0;
        }
        return 0;
      });
    } else if (sample is DateTime) {
      variables['x'] = g.Variable<Map, DateTime>(accessor: (Map map) {
        final v = map[xField];
        if (v is DateTime) return v;
        if (v is String) {
          try {
            return DateTime.parse(v);
          } catch (_) {}
        }
        return DateTime.fromMillisecondsSinceEpoch(0);
      });
    } else {
      variables['x'] = g.Variable<Map, String>(accessor: (Map map) {
        final v = map[xField];
        return v?.toString() ?? '';
      });
    }
  }
  if (yField != null) {
    variables['y'] = g.Variable<Map, num>(accessor: (Map map) {
      final v = map[yField];
      if (v is num) return v;
      if (v is String) {
        final d = num.tryParse(v);
        return d ?? 0;
      }
      return 0;
    });
  }
  if (colorField != null) {
    variables['color'] = g.Variable<Map, String>(accessor: (Map map) {
      final v = map[colorField];
      return v?.toString() ?? '';
    });
  }

  List<g.AxisGuide>? axes;
  if (axis != null) {
    final xa = axis['x'];
    final ya = axis['y'];
    axes = [
      if (xa is Map) g.Defaults.horizontalAxis,
      if (ya is Map) g.Defaults.verticalAxis,
    ];
  }

  switch (chartType) {
    case 'line':
      return g.Chart(
        data: data,
        variables: variables,
        marks: [
          g.LineMark(
            shape: g.ShapeEncode(value: g.BasicLineShape(smooth: options?['smooth'] == true)),
            color: colorField != null ? g.ColorEncode(variable: 'color') : null,
          ),
        ],
        axes: axes,
        selections: {'tap': g.PointSelection(dim: g.Dim.x)},
        tooltip: g.TooltipGuide(),
      );
    case 'bar':
      return g.Chart(
        data: data,
        variables: variables,
        marks: [
          g.IntervalMark(
            color: colorField != null ? g.ColorEncode(variable: 'color') : null,
            modifiers: [if (options?['stack'] == true) g.StackModifier()],
          ),
        ],
        axes: axes,
        coord: options?['transpose'] == true ? g.RectCoord(transposed: true) : null,
        selections: {'tap': g.PointSelection(dim: g.Dim.x)},
        tooltip: g.TooltipGuide(),
      );
    case 'scatter':
      return g.Chart(
        data: data,
        variables: variables,
        marks: [
          g.PointMark(
            size: g.SizeEncode(value: 5),
            color: colorField != null ? g.ColorEncode(variable: 'color') : null,
          ),
        ],
        axes: axes,
        selections: {'tap': g.PointSelection(dim: g.Dim.x)},
        tooltip: g.TooltipGuide(),
      );
    case 'pie':
      // 以 x 或 color 为分类，以 y 为数值
      final category = xField ?? colorField;
      if (category == null || yField == null) {
        return _error('饼图需要 encode.x 或 encode.color 作为分类，且需要 encode.y 作为数值');
      }
      return g.Chart(
        data: data,
        variables: {
          'category': g.Variable<Map, String>(accessor: (Map map) {
            final v = map[category];
            return v?.toString() ?? '';
          }),
          'value': g.Variable<Map, num>(accessor: (Map map) {
            final v = map[yField];
            if (v is num) return v;
            if (v is String) {
              final d = num.tryParse(v);
              return d ?? 0;
            }
            return 0;
          }),
        },
        marks: [
          g.IntervalMark(
            position: g.Varset('category') * g.Varset('value'),
            color: g.ColorEncode(variable: 'category'),
          ),
        ],
        coord: g.PolarCoord(transposed: true),
        selections: {'tap': g.PointSelection(dim: g.Dim.x)},
        tooltip: g.TooltipGuide(),
      );
    default:
      return _error('不支持的图表类型: $chartType');
  }
}

Widget _error(String msg) => Center(
      child: Text(msg, style: const TextStyle(color: Colors.redAccent)),
    );

Object? _firstNonNull(List<Map> data, String field) {
  for (final row in data) {
    final v = row[field];
    if (v != null) return v;
  }
  return null;
}

Future<void> _exportAsPng(BuildContext context, GlobalKey repaintKey) async {
  try {
    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) throw Exception('渲染未就绪');
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) throw Exception('PNG 编码失败');
    final bytes = byteData.buffer.asUint8List();

    final location = await getSaveLocation(suggestedName: 'chart.png');
    if (location == null) return; // 用户取消
    final file = XFile.fromData(bytes, mimeType: 'image/png', name: 'chart.png');
    await file.saveTo(location.path);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已保存 chart.png')));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('导出失败：$e')));
    }
  }
}
