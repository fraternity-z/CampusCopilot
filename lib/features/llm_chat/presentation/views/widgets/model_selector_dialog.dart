import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../settings/domain/entities/app_settings.dart';
import '../../../../settings/presentation/providers/settings_provider.dart';

/// AIProvider扩展方法，提供UI相关的辅助功能
extension AIProviderUIHelpers on AIProvider {
  /// 获取提供商图标
  IconData get icon {
    switch (this) {
      case AIProvider.openai:
        return Icons.psychology;
      case AIProvider.gemini:
        return Icons.auto_awesome;
      case AIProvider.claude:
        return Icons.smart_toy;
      case AIProvider.deepseek:
        return Icons.psychology_alt;
      case AIProvider.qwen:
        return Icons.translate;
      case AIProvider.openrouter:
        return Icons.hub;
      case AIProvider.ollama:
        return Icons.computer;
    }
  }

  /// 获取提供商颜色
  Color get color {
    switch (this) {
      case AIProvider.openai:
        return const Color(0xFF10B981);
      case AIProvider.gemini:
        return const Color(0xFF4285F4);
      case AIProvider.claude:
        return const Color(0xFFFF6B35);
      case AIProvider.deepseek:
        return const Color(0xFF9C27B0);
      case AIProvider.qwen:
        return const Color(0xFFF44336);
      case AIProvider.openrouter:
        return const Color(0xFF009688);
      case AIProvider.ollama:
        return const Color(0xFF3F51B5);
    }
  }

  /// 获取提供商名称
  String get displayName {
    switch (this) {
      case AIProvider.openai:
        return 'OpenAI';
      case AIProvider.gemini:
        return 'Google Gemini';
      case AIProvider.claude:
        return 'Anthropic Claude';
      case AIProvider.deepseek:
        return 'DeepSeek';
      case AIProvider.qwen:
        return '阿里云通义千问';
      case AIProvider.openrouter:
        return 'OpenRouter';
      case AIProvider.ollama:
        return 'Ollama';
    }
  }
}

/// 模型选择弹窗
class ModelSelectorDialog extends ConsumerStatefulWidget {
  final List<ModelInfoWithProvider> allModels;
  final ModelInfoWithProvider? currentModel;

  const ModelSelectorDialog({
    super.key,
    required this.allModels,
    this.currentModel,
  });

  @override
  ConsumerState<ModelSelectorDialog> createState() =>
      _ModelSelectorDialogState();
}

class _ModelSelectorDialogState extends ConsumerState<ModelSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<ModelInfoWithProvider> _filteredModels = [];

  @override
  void initState() {
    super.initState();
    _filteredModels = _filterChatModels(widget.allModels);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 过滤出适合聊天的模型
  List<ModelInfoWithProvider> _filterChatModels(
    List<ModelInfoWithProvider> models,
  ) {
    return models.where((model) {
      // 排除嵌入模型类型
      if (model.type.toLowerCase() == 'embedding') {
        return false;
      }

      // 排除名称或ID中包含 "embedding" 的模型（不区分大小写）
      final nameContainsEmbedding = model.name.toLowerCase().contains(
        'embedding',
      );
      final idContainsEmbedding = model.id.toLowerCase().contains('embedding');

      if (nameContainsEmbedding || idContainsEmbedding) {
        return false;
      }

      // 只保留聊天相关的模型类型
      final chatTypes = ['chat', 'multimodal', 'text', 'completion'];
      return chatTypes.contains(model.type.toLowerCase());
    }).toList();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      final chatModels = _filterChatModels(widget.allModels);
      if (query.isEmpty) {
        _filteredModels = chatModels;
      } else {
        _filteredModels = chatModels.where((model) {
          return model.name.toLowerCase().contains(query) ||
              model.id.toLowerCase().contains(query) ||
              model.providerName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 按提供商分组模型
    final groupedModels = <AIProvider, List<ModelInfoWithProvider>>{};
    for (final model in _filteredModels) {
      groupedModels.putIfAbsent(model.provider, () => []).add(model);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '选择AI模型',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        // 实时显示当前模型
                        Consumer(
                          builder: (context, ref, child) {
                            final currentModelAsync = ref.watch(
                              databaseCurrentModelProvider,
                            );
                            return currentModelAsync.when(
                              data: (currentModel) {
                                if (currentModel != null) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        '当前：${currentModel.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              loading: () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    '加载中...',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                              error: (_, __) => const SizedBox.shrink(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainer,
                    ),
                  ),
                ],
              ),
            ),

            // 搜索框
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '搜索模型...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // 模型列表
            Flexible(
              child: widget.allModels.isEmpty
                  ? _buildEmptyState(context)
                  : _buildModelList(context, groupedModels),
            ),

            // 底部操作栏
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/settings/models');
                      },
                      icon: const Icon(Icons.settings, size: 16),
                      label: const Text('管理配置'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.psychology_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '未配置AI模型',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请先配置AI提供商的API密钥和模型列表',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 构建模型列表
  Widget _buildModelList(
    BuildContext context,
    Map<AIProvider, List<ModelInfoWithProvider>> groupedModels,
  ) {
    // 在列表顶层监听一次当前模型，避免每个item都监听
    final currentModelAsync = ref.watch(databaseCurrentModelProvider);
    final currentModelId = currentModelAsync.whenOrNull(data: (m) => m?.id);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: [
        ...groupedModels.entries.map((entry) {
          final provider = entry.key;
          final models = entry.value;
          // 将当前模型ID传递给子组件
          return _buildProviderSection(
            context,
            provider,
            models,
            currentModelId,
          );
        }),
      ],
    );
  }

  /// 构建提供商分组
  Widget _buildProviderSection(
    BuildContext context,
    AIProvider provider,
    List<ModelInfoWithProvider> models,
    String? currentModelId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 提供商标题
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: provider.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(provider.icon, size: 16, color: provider.color),
              ),
              const SizedBox(width: 8),
              Text(
                provider.displayName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: provider.color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: provider.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${models.length}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: provider.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 模型列表
        ...models.map(
          (model) => _buildModelItem(context, model, currentModelId),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  /// 构建模型项
  Widget _buildModelItem(
    BuildContext context,
    ModelInfoWithProvider model,
    String? currentModelId,
  ) {
    // 直接使用传递的currentModelId进行判断，避免重复监听
    final isSelected = model.id == currentModelId;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (!isSelected) {
              // 在异步操作前获取context引用，避免async gap问题
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              try {
                await ref.read(settingsProvider.notifier).switchModel(model.id);
                // 移除不必要的Future.delayed
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('切换模型失败: $e')));
              }

              // 使用提前获取的navigator引用
              navigator.pop();
            } else {
              // 如果已选中，直接关闭弹窗
              Navigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // 选中指示器
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // 模型信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (model.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 2),
                        Text(
                          model.description!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (model.contextWindow != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.memory,
                              size: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatNumber(model.contextWindow!)} tokens',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // 功能标签
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (model.supportsVision) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 10,
                              color: Colors.purple.shade600,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '视觉',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.purple.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (model.supportsFunctionCalling) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.functions,
                              size: 10,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '函数',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 格式化数字
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toString();
  }
}
