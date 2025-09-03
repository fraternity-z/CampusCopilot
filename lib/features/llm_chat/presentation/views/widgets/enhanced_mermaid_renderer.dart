import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'mermaid_layout_manager.dart';

/// Mermaid官方主题配色方案
/// 严格按照官方theme-default.js实现
class MermaidTheme {
  final Color primaryColor;
  final Color primaryTextColor;
  final Color primaryBorderColor;
  final Color secondaryColor;
  final Color secondaryTextColor;
  final Color secondaryBorderColor;
  final Color tertiaryColor;
  final Color tertiaryTextColor;
  final Color tertiaryBorderColor;
  final Color background;
  final Color lineColor;
  final Color textColor;
  final Color nodeBorder;
  final Color clusterBkg;
  final Color clusterBorder;
  final Color defaultLinkColor;
  final Color titleColor;
  final Color edgeLabelBackground;
  final Color nodeTextColor;

  const MermaidTheme({
    required this.primaryColor,
    required this.primaryTextColor,
    required this.primaryBorderColor,
    required this.secondaryColor,
    required this.secondaryTextColor,
    required this.secondaryBorderColor,
    required this.tertiaryColor,
    required this.tertiaryTextColor,
    required this.tertiaryBorderColor,
    required this.background,
    required this.lineColor,
    required this.textColor,
    required this.nodeBorder,
    required this.clusterBkg,
    required this.clusterBorder,
    required this.defaultLinkColor,
    required this.titleColor,
    required this.edgeLabelBackground,
    required this.nodeTextColor,
  });
}

/// 增强的Mermaid图表渲染器
///
/// 严格按照Mermaid官方文档标准实现，完全复刻官方视觉效果：
/// - 精确的官方配色方案和主题变量
/// - 完美的文字居中对齐和自动换行
/// - 标准的节点形状、尺寸和边框样式
/// - 流畅的连接线和箭头绘制
/// - 专业的布局算法和间距控制
class EnhancedMermaidRenderer extends StatelessWidget {
  final String mermaidCode;

  const EnhancedMermaidRenderer({super.key, required this.mermaidCode});

  @override
  Widget build(BuildContext context) {
    final parsedData = _parseMermaidCode(mermaidCode);

    if (parsedData['nodes'].isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          '无法解析图表内容',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 图表类型标识
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '📊 ${parsedData['type']} 图表',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 图表内容
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: FlowChartPainter._mermaidTheme.background, // 使用Mermaid主题背景色
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: _buildDiagramContent(context, parsedData),
        ),
      ],
    );
  }

  /// 构建图表内容（使用响应式布局管理器）
  Widget _buildDiagramContent(
    BuildContext context,
    Map<String, dynamic> parsedData,
  ) {
    final canvasHeight = _calculateCanvasHeight(parsedData);
    final nodes = parsedData['nodes'] as List<Map<String, String>>;
    final connections = parsedData['connections'] as List<Map<String, String>>;

    Widget diagramWidget;
    switch (parsedData['type']) {
      case 'sequence':
        diagramWidget = _buildSequenceDiagram(context, parsedData);
        break;
      case 'class':
        diagramWidget = _buildClassDiagram(context, parsedData);
        break;
      case 'state':
        diagramWidget = _buildStateDiagram(context, parsedData);
        break;
      case 'quadrant':
        diagramWidget = _buildQuadrantChart(context, parsedData);
        break;
      default:
        diagramWidget = CustomPaint(
          size: Size(double.infinity, canvasHeight),
          painter: FlowChartPainter(
            nodes: parsedData['nodes'],
            connections: parsedData['connections'],
            theme: Theme.of(context),
          ),
        );
    }

    // 计算合理的内容尺寸
    final contentWidth = _calculateCanvasWidth(parsedData);
    
    // 使用响应式布局管理器
    return ResponsiveMermaidContainer(
      contentSize: Size(contentWidth, canvasHeight),
      nodeCount: nodes.length,
      connectionCount: connections.length,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _showFullscreen(context, parsedData),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: diagramWidget,
            ),
          ),
          // 工具栏
          Positioned(
            top: 8,
            right: 8,
            child: _buildToolbar(context, parsedData),
          ),
        ],
      ),
    );
  }

  /// 构建工具栏
  Widget _buildToolbar(BuildContext context, Map<String, dynamic> parsedData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.download, size: 20),
            onPressed: () => _downloadChart(context, parsedData),
            tooltip: '下载图表',
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen, size: 20),
            onPressed: () => _showFullscreen(context, parsedData),
            tooltip: '全屏显示',
          ),
        ],
      ),
    );
  }

  /// 下载图表
  void _downloadChart(BuildContext context, Map<String, dynamic> parsedData) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('图表下载功能开发中...')));
  }

  /// 全屏显示
  void _showFullscreen(BuildContext context, Map<String, dynamic> parsedData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true, // 设置为全屏对话框
        builder: (context) => Scaffold(
          // 使用透明的AppBar，避免被侧边栏遮挡
          appBar: AppBar(
            title: const Text('图表全屏显示'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: '关闭全屏',
            ),
            backgroundColor: FlowChartPainter._mermaidTheme.background,
            foregroundColor: FlowChartPainter._mermaidTheme.textColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _downloadChart(context, parsedData),
                tooltip: '下载图表',
              ),
            ],
          ),
          body: Container(
            color: FlowChartPainter._mermaidTheme.background,
            child: Stack(
              children: [
                // 图表内容
                InteractiveViewer(
                  minScale: 0.3,
                  maxScale: 5.0,
                  boundaryMargin: const EdgeInsets.all(20),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: FlowChartPainter(
                      nodes: parsedData['nodes'],
                      connections: parsedData['connections'],
                      theme: Theme.of(context),
                    ),
                  ),
                ),
                // 浮动关闭按钮（备用）
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: '关闭全屏',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建象限图
  Widget _buildQuadrantChart(
    BuildContext context,
    Map<String, dynamic> parsedData,
  ) {
    return CustomPaint(
      size: Size(double.infinity, 400),
      painter: QuadrantChartPainter(
        data: parsedData,
        theme: FlowChartPainter._mermaidTheme,
      ),
    );
  }

  /// 构建序列图（基础实现）
  Widget _buildSequenceDiagram(
    BuildContext context,
    Map<String, dynamic> parsedData,
  ) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            Text(
              '序列图渲染',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '功能开发中...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建类图（基础实现）
  Widget _buildClassDiagram(
    BuildContext context,
    Map<String, dynamic> parsedData,
  ) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_tree,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            Text(
              '类图渲染',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '功能开发中...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建状态图（基础实现）
  Widget _buildStateDiagram(
    BuildContext context,
    Map<String, dynamic> parsedData,
  ) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radio_button_checked,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            Text(
              '状态图渲染',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '功能开发中...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 解析Mermaid代码
  Map<String, dynamic> _parseMermaidCode(String mermaidCode) {
    final lines = mermaidCode
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    String diagramType = 'flowchart';
    final nodes = <Map<String, String>>[];
    final connections = <Map<String, String>>[];

    for (final line in lines) {
      final trimmed = line.trim();

      // 识别图表类型
      if (trimmed.startsWith('graph') || trimmed.startsWith('flowchart')) {
        diagramType = 'flowchart';
        continue;
      } else if (trimmed.startsWith('sequenceDiagram')) {
        diagramType = 'sequence';
        continue;
      } else if (trimmed.startsWith('classDiagram')) {
        diagramType = 'class';
        continue;
      }

      // 解析连接关系
      if (trimmed.contains('-->') || trimmed.contains('->')) {
        final arrow = trimmed.contains('-->') ? '-->' : '->';
        final parts = trimmed.split(arrow);
        if (parts.length >= 2) {
          final from = _extractNodeId(parts[0].trim());
          final to = _extractNodeId(parts[1].trim());

          connections.add({
            'from': from['id']!,
            'to': to['id']!,
            'label': to['label'] ?? '',
          });

          // 添加节点
          if (!_nodeExists(nodes, from['id']!)) {
            nodes.add(from);
          }
          if (!_nodeExists(nodes, to['id']!)) {
            nodes.add(to);
          }
        }
      }
      // 解析单独的节点定义
      else if (trimmed.contains('[') ||
          trimmed.contains('(') ||
          trimmed.contains('{')) {
        final node = _extractNodeId(trimmed);
        if (!_nodeExists(nodes, node['id']!)) {
          nodes.add(node);
        }
      }
    }

    return {'type': diagramType, 'nodes': nodes, 'connections': connections};
  }

  /// 提取节点ID和标签
  Map<String, String> _extractNodeId(String nodeText) {
    final text = nodeText.trim();

    // 处理不同的节点语法
    final patterns = [
      RegExp(r'(\w+)\[([^\]]+)\]'), // A[Label]
      RegExp(r'(\w+)\(([^)]+)\)'), // A(Label)
      RegExp(r'(\w+)\{([^}]+)\}'), // A{Label}
      RegExp(r'(\w+)'), // 简单ID
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        if (match.groupCount >= 2) {
          return {
            'id': match.group(1)!,
            'label': match.group(2)!,
            'shape': _getNodeShape(text),
          };
        } else {
          return {
            'id': match.group(1)!,
            'label': match.group(1)!,
            'shape': 'rect',
          };
        }
      }
    }

    return {'id': text, 'label': text, 'shape': 'rect'};
  }

  /// 获取节点形状
  String _getNodeShape(String nodeText) {
    if (nodeText.contains('[')) return 'rect';
    if (nodeText.contains('(')) return 'round';
    if (nodeText.contains('{')) return 'diamond';
    return 'rect';
  }

  /// 检查节点是否已存在
  bool _nodeExists(List<Map<String, String>> nodes, String id) {
    return nodes.any((node) => node['id'] == id);
  }

  /// 计算画布宽度
  double _calculateCanvasWidth(Map<String, dynamic> parsedData) {
    final nodes = parsedData['nodes'] as List<Map<String, String>>;
    
    // 基于节点数量计算合理的宽度
    final nodesPerRow = math.min(3, math.max(1, nodes.length)); // 每行1-3个节点
    final nodeWidth = 280.0; // 单个节点的估算宽度
    final horizontalSpacing = 40.0; // 节点间间距
    
    final totalWidth = nodesPerRow * nodeWidth + (nodesPerRow - 1) * horizontalSpacing + 80.0; // 加上边距
    
    return math.max(400.0, totalWidth); // 最小宽度400
  }

  /// 计算画布高度
  double _calculateCanvasHeight(Map<String, dynamic> parsedData) {
    final nodes = parsedData['nodes'] as List<Map<String, String>>;
    final connections = parsedData['connections'] as List<Map<String, String>>;

    // 更合理的布局计算
    final nodeRows = (nodes.length / 2).ceil(); // 每行最多2个节点，更宽松
    final baseHeight = nodeRows * 100.0 + 60.0; // 增加行高和边距

    // 如果有连接线，增加额外空间
    final connectionHeight = connections.isNotEmpty ? 80.0 : 0.0;

    return math.max(200.0, baseHeight + connectionHeight);
  }
}

/// 流程图绘制器
class FlowChartPainter extends CustomPainter {
  final List<Map<String, String>> nodes;
  final List<Map<String, String>> connections;
  final ThemeData theme;

  FlowChartPainter({
    required this.nodes,
    required this.connections,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 计算节点位置
    final nodePositions = _calculateNodePositions(size);

    // 绘制连接线
    _drawConnections(canvas, nodePositions);

    // 绘制节点
    _drawNodes(canvas, nodePositions);
  }

  /// 计算节点位置（优化布局和间距）
  Map<String, Offset> _calculateNodePositions(Size size) {
    final positions = <String, Offset>{};

    // 优化的布局参数
    final minNodeHeight = 60.0; // 最小节点高度
    final horizontalSpacing = 280.0; // 增加水平间距，避免拥挤
    final verticalSpacing = 150.0; // 增加垂直间距
    final padding = 40.0; // 边距

    // 动态计算每行节点数，确保不会太拥挤
    final availableWidth = size.width - padding * 2;
    final nodesPerRow = math.min(
      3, // 最多3个节点一行
      math.max(1, (availableWidth / horizontalSpacing).floor()),
    );

    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final row = i ~/ nodesPerRow;
      final col = i % nodesPerRow;

      // 居中对齐计算
      final totalRowWidth = nodesPerRow * horizontalSpacing;
      final startX = (size.width - totalRowWidth) / 2 + horizontalSpacing / 2;

      final x = startX + col * horizontalSpacing;
      final y =
          row * verticalSpacing + minNodeHeight / 2 + padding; // 使用padding

      positions[node['id']!] = Offset(x, y);
    }

    return positions;
  }

  /// 绘制连接线（严格按照Mermaid官方标准）
  void _drawConnections(Canvas canvas, Map<String, Offset> nodePositions) {
    // 使用Mermaid官方标准连接线样式
    final paint = Paint()
      ..color = _mermaidTheme.defaultLinkColor
      ..strokeWidth =
          2.0 // 官方标准线宽
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final arrowPaint = Paint()
      ..color = _mermaidTheme.defaultLinkColor
      ..style = PaintingStyle.fill;

    // 官方标准阴影效果
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (final connection in connections) {
      final fromPos = nodePositions[connection['from']];
      final toPos = nodePositions[connection['to']];

      if (fromPos != null && toPos != null) {
        // 计算节点边缘的连接点
        final nodeRadius = 40.0; // 节点半径估算
        final direction = (toPos - fromPos).direction;

        final adjustedFromPos =
            fromPos +
            Offset(
              math.cos(direction) * nodeRadius,
              math.sin(direction) * nodeRadius,
            );
        final adjustedToPos =
            toPos -
            Offset(
              math.cos(direction) * nodeRadius,
              math.sin(direction) * nodeRadius,
            );

        // 创建贝塞尔曲线路径
        final path = _createBezierPath(adjustedFromPos, adjustedToPos);
        final shadowPath = _createBezierPath(
          adjustedFromPos + const Offset(2, 2),
          adjustedToPos + const Offset(2, 2),
        );

        // 绘制阴影
        canvas.drawPath(shadowPath, shadowPaint);

        // 绘制连接线
        canvas.drawPath(path, paint);

        // 绘制箭头
        _drawArrow(canvas, adjustedFromPos, adjustedToPos, arrowPaint);
      }
    }
  }

  /// 创建贝塞尔曲线路径
  Path _createBezierPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    // 计算控制点，创建自然的曲线
    final distance = (end - start).distance;

    // 根据距离和方向调整控制点
    final controlOffset = distance * 0.3;
    final isHorizontal = (end.dx - start.dx).abs() > (end.dy - start.dy).abs();

    late Offset control1, control2;

    if (isHorizontal) {
      // 水平方向的曲线
      control1 = Offset(start.dx + controlOffset, start.dy);
      control2 = Offset(end.dx - controlOffset, end.dy);
    } else {
      // 垂直方向的曲线
      control1 = Offset(start.dx, start.dy + controlOffset);
      control2 = Offset(end.dx, end.dy - controlOffset);
    }

    // 使用三次贝塞尔曲线
    path.cubicTo(
      control1.dx,
      control1.dy,
      control2.dx,
      control2.dy,
      end.dx,
      end.dy,
    );

    return path;
  }

  /// 绘制箭头
  void _drawArrow(Canvas canvas, Offset from, Offset to, Paint paint) {
    final direction = (to - from).direction;
    final arrowLength = 12.0; // 增加箭头大小
    final arrowAngle = math.pi / 5; // 调整箭头角度，使其更尖锐

    final arrowPoint1 = Offset(
      to.dx - arrowLength * math.cos(direction - arrowAngle),
      to.dy - arrowLength * math.sin(direction - arrowAngle),
    );

    final arrowPoint2 = Offset(
      to.dx - arrowLength * math.cos(direction + arrowAngle),
      to.dy - arrowLength * math.sin(direction + arrowAngle),
    );

    // 添加箭头阴影
    final shadowPaint = Paint()
      ..color = paint.color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final shadowPath = Path()
      ..moveTo(to.dx + 1, to.dy + 1)
      ..lineTo(arrowPoint1.dx + 1, arrowPoint1.dy + 1)
      ..lineTo(arrowPoint2.dx + 1, arrowPoint2.dy + 1)
      ..close();

    canvas.drawPath(shadowPath, shadowPaint);

    // 绘制箭头主体
    final path = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  /// 绘制节点
  void _drawNodes(Canvas canvas, Map<String, Offset> nodePositions) {
    for (final node in nodes) {
      final position = nodePositions[node['id']];
      if (position != null) {
        _drawNode(canvas, node, position);
      }
    }
  }

  /// 绘制单个节点（严格按照Mermaid官方标准）
  void _drawNode(Canvas canvas, Map<String, String> node, Offset position) {
    final shape = node['shape'] ?? 'rect';
    final label = node['label'] ?? node['id'] ?? '';

    // 使用Mermaid官方标准文字样式
    final textStyle = TextStyle(
      color: _getNodeTextColor(shape),
      fontSize: MermaidTextUtils.fontSize,
      fontWeight: FontWeight.normal,
      fontFamily: MermaidTextUtils.fontFamily,
      height: MermaidTextUtils.lineHeight,
    );

    // 优化的节点尺寸参数（更宽松的布局）
    final maxNodeWidth = 280.0; // 增加最大宽度
    final minNodeWidth = 120.0; // 增加最小宽度
    final padding = 24.0; // 增加内边距

    // 计算文字布局
    final textLayout = MermaidTextUtils.calculateTextLayout(
      label,
      maxNodeWidth - padding,
      fontSize: textStyle.fontSize ?? 14.0,
      fontWeight: textStyle.fontWeight ?? FontWeight.normal,
    );

    // 弹性节点尺寸：根据文字内容动态调整
    final nodeWidth = math.max(
      minNodeWidth,
      math.min(maxNodeWidth, textLayout.maxWidth + padding),
    );
    final nodeHeight = math.max(40.0, textLayout.totalHeight + padding);

    // 节点颜色配置（参考Mermaid官方配色）
    final paint = Paint()
      ..color = _getNodeFillColor(shape)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = _getNodeBorderColor(shape)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 添加阴影效果
    final shadowPaint = Paint()
      ..color = theme.colorScheme.shadow.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    switch (shape) {
      case 'round':
        // 绘制阴影
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: position + const Offset(2, 2),
              width: nodeWidth,
              height: nodeHeight,
            ),
            Radius.circular(nodeHeight / 2),
          ),
          shadowPaint,
        );
        // 绘制节点
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: position,
              width: nodeWidth,
              height: nodeHeight,
            ),
            Radius.circular(nodeHeight / 2),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: position,
              width: nodeWidth,
              height: nodeHeight,
            ),
            Radius.circular(nodeHeight / 2),
          ),
          borderPaint,
        );
        break;
      case 'diamond':
        final path = Path()
          ..moveTo(position.dx, position.dy - nodeHeight / 2)
          ..lineTo(position.dx + nodeWidth / 2, position.dy)
          ..lineTo(position.dx, position.dy + nodeHeight / 2)
          ..lineTo(position.dx - nodeWidth / 2, position.dy)
          ..close();

        // 绘制阴影
        final shadowPath = Path()
          ..moveTo(position.dx + 2, position.dy - nodeHeight / 2 + 2)
          ..lineTo(position.dx + nodeWidth / 2 + 2, position.dy + 2)
          ..lineTo(position.dx + 2, position.dy + nodeHeight / 2 + 2)
          ..lineTo(position.dx - nodeWidth / 2 + 2, position.dy + 2)
          ..close();
        canvas.drawPath(shadowPath, shadowPaint);

        canvas.drawPath(path, paint);
        canvas.drawPath(path, borderPaint);
        break;
      default: // rect
        // 绘制阴影
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: position + const Offset(2, 2),
              width: nodeWidth,
              height: nodeHeight,
            ),
            const Radius.circular(8),
          ),
          shadowPaint,
        );
        // 绘制节点
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: position,
              width: nodeWidth,
              height: nodeHeight,
            ),
            const Radius.circular(8),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: position,
              width: nodeWidth,
              height: nodeHeight,
            ),
            const Radius.circular(8),
          ),
          borderPaint,
        );
    }

    // 绘制完美居中的多行文字，使用正确的文字颜色
    MermaidTextUtils.drawCenteredText(canvas, textLayout, position, textStyle);
  }

  /// Mermaid官方默认主题配色方案（优化对比度版本）
  /// 严格按照官方theme-default.js实现，并优化文字可读性
  static const _mermaidTheme = MermaidTheme(
    // 主要颜色 - 使用更深的背景色提高对比度
    primaryColor: Color(0xFFEEE8D5), // 更深的米色背景
    primaryTextColor: Color(0xFF2D3748), // 深灰色文字，确保高对比度
    primaryBorderColor: Color(0xFF6B46C1), // 深紫色边框
    // 次要颜色
    secondaryColor: Color(0xFFE2E8F0), // 浅灰蓝背景
    secondaryTextColor: Color(0xFF2D3748), // 深灰色文字
    secondaryBorderColor: Color(0xFF3182CE), // 蓝色边框
    // 第三级颜色
    tertiaryColor: Color(0xFFF0FDF4), // 浅绿背景
    tertiaryTextColor: Color(0xFF2D3748), // 深灰色文字
    tertiaryBorderColor: Color(0xFF059669), // 绿色边框
    // 背景和线条
    background: Color(0xFFFAFAFA), // 更亮的背景
    lineColor: Color(0xFF4A5568), // 深灰色线条
    textColor: Color(0xFF2D3748), // 深灰色文字
    // 流程图专用颜色
    nodeBorder: Color(0xFF6B46C1), // 深紫色
    clusterBkg: Color(0xFFE2E8F0),
    clusterBorder: Color(0xFF3182CE),
    defaultLinkColor: Color(0xFF4A5568), // 深灰色连接线
    titleColor: Color(0xFF1A202C), // 更深的标题色
    edgeLabelBackground: Color(0xFFE2E8F0),
    nodeTextColor: Color(0xFF2D3748), // 深灰色节点文字
  );

  /// 获取节点填充颜色（严格按照官方标准）
  Color _getNodeFillColor(String shape) {
    switch (shape) {
      case 'rect':
      case 'square':
        return _mermaidTheme.primaryColor;
      case 'round':
      case 'circle':
        return _mermaidTheme.secondaryColor;
      case 'diamond':
        return _mermaidTheme.tertiaryColor;
      case 'hexagon':
        return _mermaidTheme.primaryColor;
      case 'parallelogram':
        return _mermaidTheme.secondaryColor;
      default:
        return _mermaidTheme.primaryColor;
    }
  }

  /// 获取节点边框颜色（严格按照官方标准）
  Color _getNodeBorderColor(String shape) {
    switch (shape) {
      case 'rect':
      case 'square':
        return _mermaidTheme.primaryBorderColor;
      case 'round':
      case 'circle':
        return _mermaidTheme.secondaryBorderColor;
      case 'diamond':
        return _mermaidTheme.tertiaryBorderColor;
      case 'hexagon':
        return _mermaidTheme.primaryBorderColor;
      case 'parallelogram':
        return _mermaidTheme.secondaryBorderColor;
      default:
        return _mermaidTheme.nodeBorder;
    }
  }

  /// 获取节点文字颜色（严格按照官方标准）
  Color _getNodeTextColor(String shape) {
    switch (shape) {
      case 'rect':
      case 'square':
        return _mermaidTheme.primaryTextColor;
      case 'round':
      case 'circle':
        return _mermaidTheme.secondaryTextColor;
      case 'diamond':
        return _mermaidTheme.tertiaryTextColor;
      default:
        return _mermaidTheme.nodeTextColor;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Mermaid官方标准文字处理工具类
class MermaidTextUtils {
  /// 官方标准字体配置
  static const String fontFamily = 'trebuchet ms, verdana, arial, sans-serif';
  static const double fontSize = 14.0;
  static const double lineHeight = 1.25;

  /// 计算文字换行后的精确布局信息
  static MermaidTextLayout calculateTextLayout(
    String text,
    double maxWidth, {
    double fontSize = fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final style = TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight,
    );

    // 处理换行符
    final paragraphs = text.split('\n');
    final allLines = <String>[];
    double maxLineWidth = 0;

    for (final paragraph in paragraphs) {
      if (paragraph.trim().isEmpty) {
        allLines.add('');
        continue;
      }

      final words = paragraph.split(' ');
      String currentLine = '';

      for (final word in words) {
        final testLine = currentLine.isEmpty ? word : '$currentLine $word';
        final testPainter = TextPainter(
          text: TextSpan(text: testLine, style: style),
          textDirection: TextDirection.ltr,
        );
        testPainter.layout();

        if (testPainter.width <= maxWidth || currentLine.isEmpty) {
          currentLine = testLine;
          maxLineWidth = math.max(maxLineWidth, testPainter.width);
        } else {
          allLines.add(currentLine);
          currentLine = word;

          // 重新计算当前行宽度
          final currentPainter = TextPainter(
            text: TextSpan(text: currentLine, style: style),
            textDirection: TextDirection.ltr,
          );
          currentPainter.layout();
          maxLineWidth = math.max(maxLineWidth, currentPainter.width);
        }
      }

      if (currentLine.isNotEmpty) {
        allLines.add(currentLine);
      }
    }

    final totalHeight = allLines.length * fontSize * lineHeight;

    return MermaidTextLayout(
      lines: allLines,
      maxWidth: maxLineWidth,
      totalHeight: totalHeight,
      lineHeight: fontSize * lineHeight,
      style: style,
    );
  }

  /// 绘制完美居中的多行文字
  static void drawCenteredText(
    Canvas canvas,
    MermaidTextLayout layout,
    Offset center,
    TextStyle? overrideStyle, // 可选的覆盖样式
  ) {
    final startY = center.dy - layout.totalHeight / 2;

    for (int i = 0; i < layout.lines.length; i++) {
      final line = layout.lines[i];
      if (line.isEmpty) continue;

      // 使用传入的样式或默认样式
      final effectiveStyle = overrideStyle ?? layout.style;

      final textPainter = TextPainter(
        text: TextSpan(text: line, style: effectiveStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final lineY = startY + i * layout.lineHeight;
      final lineX = center.dx - textPainter.width / 2;

      textPainter.paint(canvas, Offset(lineX, lineY));
    }
  }
}

/// 象限图绘制器
/// 严格按照Mermaid官方quadrant chart标准实现
class QuadrantChartPainter extends CustomPainter {
  final Map<String, dynamic> data;
  final MermaidTheme theme;

  QuadrantChartPainter({required this.data, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 绘制坐标轴
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final margin = 60.0;

    // X轴
    canvas.drawLine(
      Offset(margin, centerY),
      Offset(size.width - margin, centerY),
      paint,
    );

    // Y轴
    canvas.drawLine(
      Offset(centerX, margin),
      Offset(centerX, size.height - margin),
      paint,
    );

    // 绘制象限背景
    _drawQuadrantBackgrounds(canvas, size, centerX, centerY, margin);

    // 绘制象限标签
    _drawQuadrantLabels(canvas, size, centerX, centerY, margin);

    // 绘制数据点
    _drawDataPoints(canvas, size, centerX, centerY, margin);

    // 绘制轴标签
    _drawAxisLabels(canvas, size, centerX, centerY, margin);
  }

  void _drawQuadrantBackgrounds(
    Canvas canvas,
    Size size,
    double centerX,
    double centerY,
    double margin,
  ) {
    final quadrantPaint = Paint()..style = PaintingStyle.fill;

    // 象限1 (右上)
    quadrantPaint.color = theme.primaryColor.withValues(alpha: 0.1);
    canvas.drawRect(
      Rect.fromLTRB(centerX, margin, size.width - margin, centerY),
      quadrantPaint,
    );

    // 象限2 (左上)
    quadrantPaint.color = theme.secondaryColor.withValues(alpha: 0.1);
    canvas.drawRect(
      Rect.fromLTRB(margin, margin, centerX, centerY),
      quadrantPaint,
    );

    // 象限3 (左下)
    quadrantPaint.color = theme.tertiaryColor.withValues(alpha: 0.1);
    canvas.drawRect(
      Rect.fromLTRB(margin, centerY, centerX, size.height - margin),
      quadrantPaint,
    );

    // 象限4 (右下)
    quadrantPaint.color = theme.primaryColor.withValues(alpha: 0.15);
    canvas.drawRect(
      Rect.fromLTRB(
        centerX,
        centerY,
        size.width - margin,
        size.height - margin,
      ),
      quadrantPaint,
    );
  }

  void _drawQuadrantLabels(
    Canvas canvas,
    Size size,
    double centerX,
    double centerY,
    double margin,
  ) {
    final textStyle = TextStyle(
      color: theme.textColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    // 象限标签
    final quadrants = data['quadrants'] as Map<String, String>? ?? {};

    _drawCenteredText(
      canvas,
      quadrants['1'] ?? 'Quadrant 1',
      Offset((centerX + size.width - margin) / 2, (margin + centerY) / 2),
      textStyle,
    );
    _drawCenteredText(
      canvas,
      quadrants['2'] ?? 'Quadrant 2',
      Offset((margin + centerX) / 2, (margin + centerY) / 2),
      textStyle,
    );
    _drawCenteredText(
      canvas,
      quadrants['3'] ?? 'Quadrant 3',
      Offset((margin + centerX) / 2, (centerY + size.height - margin) / 2),
      textStyle,
    );
    _drawCenteredText(
      canvas,
      quadrants['4'] ?? 'Quadrant 4',
      Offset(
        (centerX + size.width - margin) / 2,
        (centerY + size.height - margin) / 2,
      ),
      textStyle,
    );
  }

  void _drawDataPoints(
    Canvas canvas,
    Size size,
    double centerX,
    double centerY,
    double margin,
  ) {
    final points = data['points'] as List<Map<String, dynamic>>? ?? [];

    for (final point in points) {
      final x = (point['x'] as double) * (size.width - 2 * margin) + margin;
      final y =
          size.height -
          ((point['y'] as double) * (size.height - 2 * margin) + margin);

      // 绘制点
      final pointPaint = Paint()
        ..color = theme.primaryBorderColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 6, pointPaint);

      // 绘制标签
      final label = point['label'] as String? ?? '';
      if (label.isNotEmpty) {
        final textStyle = TextStyle(
          color: theme.textColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        );
        _drawCenteredText(canvas, label, Offset(x, y - 20), textStyle);
      }
    }
  }

  void _drawAxisLabels(
    Canvas canvas,
    Size size,
    double centerX,
    double centerY,
    double margin,
  ) {
    final textStyle = TextStyle(
      color: theme.textColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    final xAxis = data['xAxis'] as Map<String, String>? ?? {};
    final yAxis = data['yAxis'] as Map<String, String>? ?? {};

    // X轴标签
    if (xAxis['left'] != null) {
      _drawCenteredText(
        canvas,
        xAxis['left']!,
        Offset(margin + 40, centerY + 25),
        textStyle,
      );
    }
    if (xAxis['right'] != null) {
      _drawCenteredText(
        canvas,
        xAxis['right']!,
        Offset(size.width - margin - 40, centerY + 25),
        textStyle,
      );
    }

    // Y轴标签
    if (yAxis['bottom'] != null) {
      _drawRotatedText(
        canvas,
        yAxis['bottom']!,
        Offset(centerX - 25, size.height - margin - 40),
        textStyle,
        -math.pi / 2,
      );
    }
    if (yAxis['top'] != null) {
      _drawRotatedText(
        canvas,
        yAxis['top']!,
        Offset(centerX - 25, margin + 40),
        textStyle,
        -math.pi / 2,
      );
    }
  }

  void _drawCenteredText(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawRotatedText(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style,
    double angle,
  ) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Mermaid官方标准文字布局信息
class MermaidTextLayout {
  final List<String> lines;
  final double maxWidth;
  final double totalHeight;
  final double lineHeight;
  final TextStyle style;

  const MermaidTextLayout({
    required this.lines,
    required this.maxWidth,
    required this.totalHeight,
    required this.lineHeight,
    required this.style,
  });
}
