import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:campus_copilot/core/constants/app_constants.dart';
import 'package:campus_copilot/features/llm_chat/data/providers/llm_provider_factory.dart';
import 'package:campus_copilot/features/llm_chat/domain/providers/llm_provider.dart';
import 'package:campus_copilot/features/llm_chat/domain/entities/chat_message.dart';
import 'package:campus_copilot/shared/charts/chart_from_json.dart';
import 'package:campus_copilot/features/settings/presentation/providers/settings_provider.dart';
import 'package:campus_copilot/features/llm_chat/presentation/providers/chat_provider.dart';
import 'package:campus_copilot/features/llm_chat/domain/usecases/chat_service.dart';


/// 图表绘制对话框
///
/// 功能：
/// - 输入说明文字
/// - 上传图片/文件（文本类文件内容会拼接进提示；图片将作为多模态输入一并发送给AI）
/// - 一键“AI解析”为规范JSON
/// - 预览绘制图表，并可下载PNG
class ChartBuilderDialog extends ConsumerStatefulWidget {
  const ChartBuilderDialog({super.key});

  @override
  ConsumerState<ChartBuilderDialog> createState() => _ChartBuilderDialogState();
}

class _ChartBuilderDialogState extends ConsumerState<ChartBuilderDialog> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _jsonController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  final List<PlatformFile> _files = [];
  final List<XFile> _images = [];

  bool _parsing = false;
  String? _error;

  @override
  void dispose() {
    _inputController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 标题栏
              Row(
                children: [
                  const Icon(Icons.insert_chart_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '图表绘制',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _parsing ? null : _onParseByAI,
                    icon: _parsing
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(_parsing ? '解析中…' : 'AI解析'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _onPreview,
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('预览绘制'),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 主体区域：左右分栏
              Expanded(
                child: Row(
                  children: [
                    // 左：输入与附件
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildAttachToolbar(context),
                          const SizedBox(height: 8),
                          Expanded(
                            child: TextField(
                              controller: _inputController,
                              maxLines: null,
                              expands: true,
                              decoration: InputDecoration(
                                labelText: '输入文字（可描述数据结构、字段含义、期望图表类型等）',
                                hintText: '例如：使用日期为X轴，销量为Y轴，按城市分组的柱状图…',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildAttachmentsList(context),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 右：JSON 输出区
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.code, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '图表 JSON（可直接编辑）',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Text(
                                _isJsonValid()
                                    ? '已通过规范校验'
                                    : '未通过规范校验',
                                style: TextStyle(
                                  color: _isJsonValid()
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: TextField(
                              controller: _jsonController,
                              maxLines: null,
                              expands: true,
                              style: const TextStyle(fontFamily: 'monospace'),
                              decoration: InputDecoration(
                                hintText: '{\n  "chart": "line", ...\n}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== UI 构建 ========== //

  Widget _buildAttachToolbar(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.attach_file),
          label: const Text('添加文件'),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.image_outlined),
          label: const Text('添加图片'),
        ),
        const Spacer(),
        Tooltip(
          message: '提示：文本类文件会读取内容并参与AI解析；图片将作为多模态输入传给AI。',
          child: const Icon(Icons.info_outline, size: 16),
        ),
      ],
    );
  }

  Widget _buildAttachmentsList(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline.withAlpha(40);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: outline),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_files.isEmpty && _images.isEmpty)
            Text(
              '未添加附件',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          if (_files.isNotEmpty) ...[
            Text('文件 (${_files.length})', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _files
                  .map((f) => Chip(
                        label: Text(
                          f.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onDeleted: () {
                          setState(() => _files.remove(f));
                        },
                      ))
                  .toList(),
            ),
          ],
          if (_images.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('图片 (${_images.length})', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _images
                  .map((img) => Chip(
                        label: Text(
                          img.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onDeleted: () {
                          setState(() => _images.remove(img));
                        },
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ========== 行为逻辑 ========== //

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    setState(() {
      _files.addAll(result.files);
    });
  }

  Future<void> _pickImages() async {
    final result = await _imagePicker.pickMultiImage();
    if (result.isEmpty) return;
    setState(() {
      _images.addAll(result);
    });
  }

  bool _isJsonValid() {
    final text = _jsonController.text.trim();
    if (text.isEmpty) return false;
    return isChartSpecJson(text);
  }

  Future<void> _onPreview() async {
    final code = _jsonController.text.trim();
    if (!isChartSpecJson(code)) {
      setState(() {
        _error = 'JSON 未通过图表规范校验，请检查必填字段（chart/data/encode）。';
      });
      return;
    }
    setState(() => _error = null);
    await showChartPreviewDialog(context, code);
  }

  Future<void> _onParseByAI() async {
    if (_parsing) return;
    setState(() {
      _parsing = true;
      _error = null;
    });

    try {
      // 1) 使用当前对话的 LLM 配置（与聊天页完全一致）
      final chatState = ref.read(chatProvider);
      final session = chatState.currentSession;
      
      if (session == null) {
        // 无活动会话：使用对话页模型选择器的当前 Provider 与模型
        final providerType = await ref.read(databaseCurrentProviderProvider.future);
        if (providerType == null) {
          throw Exception('未发现可用的AI提供商，请在设置中配置 API Key');
        }
        
        // 获取对话页模型选择器对应的配置
        final settings = ref.read(settingsProvider);
        final selected = await ref.read(databaseCurrentModelProvider.future);
        final fallbackLlm = LlmProviderFactory.createProviderFromSettings(providerType, settings);
        if (!mounted) return;
        await _runChartParseWithLlm(
          context: context,
          llm: fallbackLlm,
          preferredModelId: selected?.id,
        );
        return;
      }
      
      // 有活动会话：使用会话的LLM配置
      final chatService = ref.read(chatServiceProvider);
      final llmConfigData = await chatService.getSessionLlmConfig(session.id);
      if (llmConfigData.apiKey.isEmpty) {
        throw Exception('当前对话使用的AI提供商未配置 API Key，请先在设置中完成配置');
      }
      final llm = LlmProviderFactory.createProvider(llmConfigData.toLlmConfig());

      // 2) 组装提示
      final buffer = StringBuffer();
      final userInput = _inputController.text.trim();
      if (userInput.isNotEmpty) {
        buffer.writeln('【用户说明】');
        buffer.writeln(userInput);
        buffer.writeln();
      }

      // 文本类文件加入上下文（限制体积）
      const maxBytes = 200 * 1024; // 200KB 上限
      for (final f in _files) {
        final path = f.path;
        if (path == null) continue;
        final ext = (f.extension ?? '').toLowerCase();
        if (['txt', 'md', 'csv', 'json'].contains(ext)) {
          try {
            final file = File(path);
            if (await file.exists()) {
              final len = await file.length();
              if (len <= maxBytes) {
                final text = await file.readAsString();
                buffer.writeln('【附件(${f.name})】');
                buffer.writeln('```\n$text\n```');
                buffer.writeln();
              } else {
                buffer.writeln('【附件(${f.name})已跳过：文件过大，仅支持≤200KB的文本文件】');
              }
            }
          } catch (_) {}
        } else {
          buffer.writeln('【附件(${f.name})】非文本类型，当前版本不直接解析内容');
        }
      }

      // 图片：多模态输入，直接随消息发送
      if (_images.isNotEmpty) {
        buffer.writeln('【图片】本次共选择 ${_images.length} 张，将作为多模态输入一并发送给AI。');
      }

      // 3) 调用模型：要求仅输出一个 chart-json 规范对象
      final imageDataUrls = await _encodeImagesAsDataUrls(_images);

      final userMessage = ChatMessageFactory.create(
        content:
            '''请依据以下资料，生成一个符合"图表 JSON 规范（chart-json）"的单一 JSON 对象。\n要求：\n- 仅输出一个 JSON 对象，不要输出解释或多余文本；\n- 推荐使用 `chart-json` 规范字段：chart/title/data/encode/axis/options；\n- data 中字段与 encode 对应；\n$buffer''',
        chatSessionId: 'chart_builder',
        isFromUser: true,
        imageUrls: imageDataUrls,
      );

      final messages = <ChatMessage>[userMessage];

      // 专用系统提示：仅为该弹窗服务，强调输出标准格式
    const chartSystemPrompt =
        '你是图表数据结构助手。严格按照“图表 JSON 规范（chart-json）”只输出一个 JSON 对象，不能输出解释或代码围栏。\n'
        '必须字段：chart、data、encode；可选字段：title、axis、options。\n'
        'encode 内只能是字段名映射，例如 {"x":"时间","y":"数值","color":"系列"}。\n'
        'bar/line/scatter 必须提供 encode.x 和 encode.y；如有多系列，用 encode.color 指定系列字段。\n'
        '规范示例（注意仅供参考，不要原样照抄数据）：\n'
        '{\n'
        '  "chart": "bar",\n'
        '  "title": "季度销量对比",\n'
        '  "data": [\n'
        '    {"x": "Q1", "y": 227.8, "s": "Tokyo"},\n'
        '    {"x": "Q2", "y": 449.2, "s": "Tokyo"},\n'
        '    {"x": "Q1", "y": 260.9, "s": "New York"}\n'
        '  ],\n'
        '  "encode": {"x": "x", "y": "y", "color": "s"},\n'
        '  "axis": {"x": {"title": "Quarter"}, "y": {"title": "Values"}},\n'
        '  "options": {"smooth": false, "stack": false, "transpose": false}\n'
        '}\n'
        '务必只输出一个 JSON 对象，且各字段含义与示例一致。';

      final result = await llm.generateChat(
        messages,
        options: ChatOptions(
          // 使用专用系统提示 + 默认提示（默认包含完整规范，增强约束）
          systemPrompt: '$chartSystemPrompt\n\n${AppConstants.defaultSystemPrompt}',
          maxTokens: 1200,
          temperature: 0.3,
        ),
      );

      final content = result.content.trim();
      final extracted = _extractFirstJsonBlock(content);
      if (extracted == null) {
        throw Exception('未从AI响应中提取到有效的JSON。');
      }
      if (!isChartSpecJson(extracted)) {
        throw Exception('提取到的JSON未通过图表规范校验，请尝试补充更明确的数据与需求。');
      }

      setState(() {
        _jsonController.text = _prettifyJson(extracted);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _parsing = false);
    }
  }

  /// 使用指定 LLM 执行解析流程（用于无活动会话时的兜底路径）
  Future<void> _runChartParseWithLlm({
    required BuildContext context,
    required LlmProvider llm,
    String? preferredModelId,
  }) async {
    // 组装提示内容
    final buffer = StringBuffer();
    final userInput = _inputController.text.trim();
    if (userInput.isNotEmpty) {
      buffer.writeln('【用户说明】');
      buffer.writeln(userInput);
      buffer.writeln();
    }

    // 文本类文件加入上下文（限制体积）
    const maxBytes = 200 * 1024;
    for (final f in _files) {
      final path = f.path;
      if (path == null) continue;
      final ext = (f.extension ?? '').toLowerCase();
      if (['txt', 'md', 'csv', 'json'].contains(ext)) {
        try {
          final file = File(path);
          if (await file.exists()) {
            final len = await file.length();
            if (len <= maxBytes) {
              final text = await file.readAsString();
              buffer.writeln('【附件(${f.name})】');
              buffer.writeln('```\n$text\n```');
              buffer.writeln();
            } else {
              buffer.writeln('【附件(${f.name})已跳过：文件过大，仅支持≤200KB的文本文件】');
            }
          }
        } catch (_) {}
      } else {
        buffer.writeln('【附件(${f.name})】非文本类型，当前版本不直接解析内容');
      }
    }

    if (_images.isNotEmpty) {
      buffer.writeln('【图片】本次共选择 ${_images.length} 张，将作为多模态输入一并发送给AI。');
    }

    // 构造消息
    final imageDataUrls = await _encodeImagesAsDataUrls(_images);
    final userMessage = ChatMessageFactory.create(
      content:
          '请依据以下资料，生成一个符合"图表 JSON 规范（chart-json）"的单一 JSON 对象。\n'
          '要求：\n'
          '- 仅输出一个 JSON 对象，不要输出解释或多余文本；\n'
          '- 推荐使用 chart/title/data/encode/axis/options 字段；\n'
          '- data 中字段与 encode 对应；\n'
          '$buffer',
      chatSessionId: 'chart_builder',
      isFromUser: true,
      imageUrls: imageDataUrls,
    );
    final messages = <ChatMessage>[userMessage];

    const chartSystemPrompt = '你是一个图表数据结构助手。请严格按照"图表 JSON 规范（chart-json）"只输出一个 JSON 对象，'
        '禁止输出任何解释、代码围栏或额外文本。仅使用字段：chart/title/data/encode/axis/options。';

    // 调用模型
    final result = await llm.generateChat(
      messages,
      options: ChatOptions(
        systemPrompt: '$chartSystemPrompt\n\n${AppConstants.defaultSystemPrompt}',
        maxTokens: 1200,
        temperature: 0.3,
        model: preferredModelId,
      ),
    );

    // 解析返回
    final content = result.content.trim();
    final extracted = _extractFirstJsonBlock(content);
    if (extracted == null) {
      throw Exception('未从AI响应中提取到有效的JSON');
    }
    if (!isChartSpecJson(extracted)) {
      throw Exception('提取到的JSON未通过图表规范校验，请尝试补充更明确的数据与需求。');
    }

    setState(() {
      _jsonController.text = _prettifyJson(extracted);
    });
  }

  // ========== 工具方法 ========== //

  Future<List<String>> _encodeImagesAsDataUrls(List<XFile> images) async {
    final List<String> urls = [];
    for (final img in images) {
      try {
        final bytes = await img.readAsBytes();
        final b64 = base64Encode(bytes);
        final mime = _guessMimeType(img.name);
        urls.add('data:$mime;base64,$b64');
      } catch (_) {}
    }
    return urls;
  }

  String _guessMimeType(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.jpg') || p.endsWith('.jpeg')) return 'image/jpeg';
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.webp')) return 'image/webp';
    if (p.endsWith('.gif')) return 'image/gif';
    if (p.endsWith('.bmp')) return 'image/bmp';
    return 'image/png';
  }

  String? _extractFirstJsonBlock(String text) {
    // 优先匹配 ```chart-json ... ``` 或 ```json ... ```
    final codeFence = RegExp(r"```(chart-json|json)\s*\n([\s\S]*?)```", multiLine: true);
    final m = codeFence.firstMatch(text);
    if (m != null && m.groupCount >= 2) {
      return m.group(2)?.trim();
    }
    // 退化：尝试查找第一个看似 JSON 对象的部分
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start >= 0 && end > start) {
      final candidate = text.substring(start, end + 1).trim();
      try {
        jsonDecode(candidate);
        return candidate;
      } catch (_) {}
    }
    return null;
  }

  String _prettifyJson(String compact) {
    try {
      final obj = jsonDecode(compact);
      final encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(obj);
    } catch (_) {
      return compact;
    }
  }
}
