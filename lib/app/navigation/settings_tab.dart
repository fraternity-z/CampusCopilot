import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/ui_constants.dart';
import '../app_router.dart';

/// 设置标签页组件
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(UIConstants.spacingL),
      children: [
        // 模型参数折叠栏
        _buildCollapsibleSection(
          context,
          ref,
          title: '模型参数',
          icon: Icons.tune,
          isExpanded: ref.watch(sidebarModelParamsExpandedProvider),
          onToggle: () {
            ref.read(sidebarModelParamsExpandedProvider.notifier).state = !ref
                .read(sidebarModelParamsExpandedProvider);
          },
          content: _buildModelParametersContent(context, ref),
        ),

        const SizedBox(height: UIConstants.spacingM),

        // 代码块设置折叠栏
        _buildCollapsibleSection(
          context,
          ref,
          title: '代码块设置',
          icon: Icons.code,
          isExpanded: ref.watch(sidebarCodeBlockExpandedProvider),
          onToggle: () {
            ref.read(sidebarCodeBlockExpandedProvider.notifier).state = !ref
                .read(sidebarCodeBlockExpandedProvider);
          },
          content: _buildCodeBlockSettingsContent(context, ref),
        ),

        const SizedBox(height: UIConstants.spacingM),

        // 常规设置折叠栏
        _buildCollapsibleSection(
          context,
          ref,
          title: '常规设置',
          icon: Icons.settings,
          isExpanded: ref.watch(sidebarGeneralExpandedProvider),
          onToggle: () {
            ref.read(sidebarGeneralExpandedProvider.notifier).state = !ref.read(
              sidebarGeneralExpandedProvider,
            );
          },
          content: _buildGeneralSettingsContent(context, ref),
        ),

        const SizedBox(height: UIConstants.spacingXL),

        // 重置所有设置按钮
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showResetSettingsDialog(context, ref),
            child: const Text('重置所有设置'),
          ),
        ),
      ],
    );
  }

  /// 构建可折叠区域
  Widget _buildCollapsibleSection(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outline.withValues(alpha: UIConstants.borderOpacity),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
            child: Container(
              padding: const EdgeInsets.all(UIConstants.spacingM),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: UIConstants.iconSizeMedium,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: UIConstants.spacingM),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(UIConstants.spacingM),
              child: content,
            ),
          ],
        ],
      ),
    );
  }

  /// 构建模型参数内容
  Widget _buildModelParametersContent(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(modelParametersProvider);

    return Column(
      children: [
        // 思考强度
        Row(
          children: [
            const Icon(Icons.psychology, size: 18),
            const SizedBox(width: 8),
            Text('思考强度', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: UIConstants.spacingS),
        Wrap(
          spacing: 8,
          children: [
            for (final level in const ['auto', 'low', 'medium', 'high'])
              ChoiceChip(
                label: Text(level.toUpperCase()),
                selected: parameters.reasoningEffort == level,
                onSelected: (_) {
                  ref
                      .read(modelParametersProvider.notifier)
                      .updateReasoningEffort(level);
                },
              ),
          ],
        ),
        const SizedBox(height: UIConstants.spacingM),
        // 最大思考Tokens
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '最大思考Tokens',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '${parameters.maxReasoningTokens}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Slider(
          value: parameters.maxReasoningTokens.toDouble(),
          min: 0,
          max: 8000,
          divisions: 80,
          onChanged: (v) => ref
              .read(modelParametersProvider.notifier)
              .updateMaxReasoningTokens(v.round()),
        ),
        const SizedBox(height: UIConstants.spacingL),
        _buildParameterSlider(
          context,
          label: '温度 (Temperature)',
          value: parameters.temperature,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          onChanged: (value) {
            ref.read(modelParametersProvider.notifier).updateTemperature(value);
          },
        ),
        const SizedBox(height: UIConstants.spacingL),
        // 已移除 Top-P，避免与部分模型不兼容
        // 新增：上下文窗口（影响历史消息条数）
        _buildParameterSlider(
          context,
          label: '上下文窗口（消息数）',
          value: parameters.contextLength,
          min: 0,
          max: 20,
          divisions: 20,
          onChanged: (value) {
            ref
                .read(modelParametersProvider.notifier)
                .updateContextLength(value);
          },
        ),
        if (parameters.enableMaxTokens) ...[
          const SizedBox(height: UIConstants.spacingL),
          _buildParameterSlider(
            context,
            label: '最大Token数',
            value: parameters.maxTokens,
            min: 100,
            max: 4000,
            divisions: 39,
            onChanged: (value) {
              ref.read(modelParametersProvider.notifier).updateMaxTokens(value);
            },
          ),
        ],
        const SizedBox(height: UIConstants.spacingM),
        SwitchListTile(
          title: const Text('启用最大Token限制'),
          value: parameters.enableMaxTokens,
          onChanged: (value) {
            ref
                .read(modelParametersProvider.notifier)
                .updateEnableMaxTokens(value);
          },
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: UIConstants.spacingS),
        Text(
          '提示：开启“AI搜索”按钮可在对话中自动拼接联网结果；思考强度适用于 o1/o3/DeepSeek-R1 等推理模型。',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// 构建代码块设置内容
  Widget _buildCodeBlockSettingsContent(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(codeBlockSettingsProvider);

    return Column(
      children: [
        // 数学引擎选择（KaTeX/MathJax）存到 GeneralSettings
        Consumer(
          builder: (context, ref, _) {
            final general = ref.watch(generalSettingsProvider);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('数学渲染引擎'),
                    DropdownButton<String>(
                      value: general.mathEngine,
                      items: const [
                        DropdownMenuItem(value: 'katex', child: Text('KaTeX')),
                        DropdownMenuItem(
                          value: 'mathjax',
                          child: Text('MathJax'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        ref.read(generalSettingsProvider.notifier).state =
                            general.copyWith(mathEngine: v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: UIConstants.spacingM),
              ],
            );
          },
        ),
        SwitchListTile(
          title: const Text('启用代码编辑'),
          subtitle: const Text('允许编辑代码块内容'),
          value: settings.enableCodeEditing,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableCodeEditing: value);
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('显示行号'),
          subtitle: const Text('在代码块左侧显示行号'),
          value: settings.enableLineNumbers,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableLineNumbers: value);
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('启用代码折叠'),
          subtitle: const Text('长代码块可以折叠显示'),
          value: settings.enableCodeFolding,
          onChanged: (value) {
            ref.read(codeBlockSettingsProvider.notifier).state = settings
                .copyWith(enableCodeFolding: value);
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  /// 构建常规设置内容
  Widget _buildGeneralSettingsContent(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(generalSettingsProvider);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('启用Markdown渲染'),
          subtitle: const Text('渲染消息中的Markdown格式'),
          value: settings.enableMarkdownRendering,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(enableMarkdownRendering: value);
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('自动保存'),
          subtitle: const Text('自动保存聊天记录'),
          value: settings.enableAutoSave,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(enableAutoSave: value);
          },
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: const Text('启用通知'),
          subtitle: const Text('接收系统通知'),
          value: settings.enableNotifications,
          onChanged: (value) {
            ref.read(generalSettingsProvider.notifier).state = settings
                .copyWith(enableNotifications: value);
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  /// 构建参数滑块
  Widget _buildParameterSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              value.toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// 显示重置设置对话框
  void _showResetSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有设置到默认值吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 重置所有设置
              ref.read(modelParametersProvider.notifier).resetParameters();
              ref.read(codeBlockSettingsProvider.notifier).state =
                  const CodeBlockSettings();
              ref.read(generalSettingsProvider.notifier).state =
                  const GeneralSettings();
            },
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }
}

// 这些 provider 需要从 app_router.dart 中导入
final sidebarModelParamsExpandedProvider = StateProvider<bool>((ref) => false);
final sidebarCodeBlockExpandedProvider = StateProvider<bool>((ref) => false);
final sidebarGeneralExpandedProvider = StateProvider<bool>((ref) => false);

// ModelParameters / CodeBlockSettings / GeneralSettings 的 Provider
// 统一在 app_router.dart 定义并持久化，这里仅使用

// 这些类从 app_router.dart 导入使用，避免重复定义
// ModelParametersNotifier 与 CodeBlockSettings 均由 app_router.dart 提供

// GeneralSettings 从 app_router.dart 导入
