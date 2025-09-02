import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/keyboard_utils.dart';

import '../providers/general_settings_provider.dart';
import '../../../../core/network/proxy_config.dart';

/// 常规设置页面
class GeneralSettingsScreen extends ConsumerWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(generalSettingsProvider);
    final availableModelsAsync = ref.watch(availableChatModelsProvider);

    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(title: const Text('常规设置'), elevation: 0),
        body: Container(
          // 使用主题背景，适配深/浅色
          color: Theme.of(context).colorScheme.surface,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 话题自动命名设置
              _buildTopicNamingSection(
                context,
                ref,
                settingsState,
                availableModelsAsync,
              ),
              const SizedBox(height: 16),
              // 代理服务设置
              _buildProxySection(context, ref, settingsState),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建话题自动命名设置区域
  Widget _buildTopicNamingSection(
    BuildContext context,
    WidgetRef ref,
    GeneralSettingsState settingsState,
    AsyncValue<List<dynamic>> availableModelsAsync,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // 使用主题表面色
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // 使用主题描边色
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '话题自动命名',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 功能开关
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '启用自动命名',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '在新对话收到第一个回复后自动生成话题标题',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settingsState.autoTopicNamingEnabled,
                  onChanged: settingsState.isLoading
                      ? null
                      : (value) {
                          ref
                              .read(generalSettingsProvider.notifier)
                              .setAutoTopicNamingEnabled(value);
                        },
                ),
              ],
            ),

            // 模型选择（仅在启用时显示）
            if (settingsState.autoTopicNamingEnabled) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              _buildModelSelector(
                context,
                ref,
                settingsState,
                availableModelsAsync,
              ),
            ],

            // 说明文字
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '注意：启用此功能会产生额外的模型调用费用。每个对话仅会调用一次自动命名。',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  /// 构建模型选择器
  Widget _buildModelSelector(
    BuildContext context,
    WidgetRef ref,
    GeneralSettingsState settingsState,
    AsyncValue<List<dynamic>> availableModelsAsync,
  ) {
    return availableModelsAsync.when(
      data: (models) {
        // 去重模型列表
        final uniqueModels = {
          for (var model in models) model.id: model
        }.values.toList();
        
        // 检查当前选中的值是否存在于可用模型中
        final currentValue = settingsState.autoTopicNamingModelId;
        final isCurrentValueValid = currentValue == null || 
            uniqueModels.any((model) => model.id == currentValue);
        
        // 如果当前值无效，异步重置为null
        if (!isCurrentValueValid) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(generalSettingsProvider.notifier)
                .setAutoTopicNamingModelId(null);
          });
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '命名模型',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: isCurrentValueValid ? currentValue : null,
              decoration: const InputDecoration(
                hintText: '选择用于生成话题名称的模型',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('请选择模型'),
                ),
                // 使用去重后的模型列表
                ...uniqueModels.map((model) {
                  // 构建显示文本
                  String displayText = model.name;
                  if (model.modelId != model.name) {
                    displayText += ' (${model.modelId})';
                  }
                  if (model.isBuiltIn) {
                    displayText += ' [内置]';
                  }

                  return DropdownMenuItem<String>(
                    value: model.id,
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 14,
                        color: model.isBuiltIn
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: settingsState.isLoading
                  ? null
                  : (value) {
                      ref
                          .read(generalSettingsProvider.notifier)
                          .setAutoTopicNamingModelId(value);
                    },
            ),
            const SizedBox(height: 8),
            Text(
              '建议选择响应速度快、成本较低的模型',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '加载模型列表失败: $error',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }

  /// 构建代理服务设置区域
  Widget _buildProxySection(
    BuildContext context,
    WidgetRef ref,
    GeneralSettingsState settingsState,
  ) {
    final proxyConfig = settingsState.proxyConfig;

    return Container(
      decoration: BoxDecoration(
        // 使用主题表面色
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // 使用主题描边色
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.vpn_lock,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '代理服务',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 代理模式选择
            _buildProxyModeSelector(context, ref, proxyConfig),

            // 自定义代理配置
            if (proxyConfig.mode == ProxyMode.custom) ...[
              const SizedBox(height: 16),
              _buildCustomProxyConfig(context, ref, proxyConfig),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建代理模式选择器
  Widget _buildProxyModeSelector(
    BuildContext context,
    WidgetRef ref,
    ProxyConfig proxyConfig,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '代理模式',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _ProxyModeRadioGroup(
          selectedMode: proxyConfig.mode,
          onModeChanged: (mode) {
            final newConfig = proxyConfig.copyWith(mode: mode);
            ref
                .read(generalSettingsProvider.notifier)
                .setProxyConfig(newConfig);
          },
        ),
      ],
    );
  }

  /// 构建自定义代理配置
  Widget _buildCustomProxyConfig(
    BuildContext context,
    WidgetRef ref,
    ProxyConfig proxyConfig,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 代理类型选择
        Text(
          '代理类型',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<ProxyType>(
          initialValue: proxyConfig.type,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: ProxyType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              final newConfig = proxyConfig.copyWith(type: value);
              ref
                  .read(generalSettingsProvider.notifier)
                  .setProxyConfig(newConfig);
            }
          },
        ),
        const SizedBox(height: 16),

        // 服务器地址和端口
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: proxyConfig.host,
                decoration: const InputDecoration(
                  labelText: '服务器地址',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (value) {
                  final newConfig = proxyConfig.copyWith(host: value);
                  ref
                      .read(generalSettingsProvider.notifier)
                      .setProxyConfig(newConfig);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: proxyConfig.port.toString(),
                decoration: const InputDecoration(
                  labelText: '端口',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final port = int.tryParse(value) ?? 8080;
                  final newConfig = proxyConfig.copyWith(port: port);
                  ref
                      .read(generalSettingsProvider.notifier)
                      .setProxyConfig(newConfig);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 认证信息（可选）
        Text(
          '认证信息（可选）',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: proxyConfig.username,
          decoration: const InputDecoration(
            labelText: '用户名',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onChanged: (value) {
            final newConfig = proxyConfig.copyWith(username: value);
            ref
                .read(generalSettingsProvider.notifier)
                .setProxyConfig(newConfig);
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: proxyConfig.password,
          decoration: const InputDecoration(
            labelText: '密码',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          obscureText: true,
          onChanged: (value) {
            final newConfig = proxyConfig.copyWith(password: value);
            ref
                .read(generalSettingsProvider.notifier)
                .setProxyConfig(newConfig);
          },
        ),
      ],
    );
  }
}

/// 代理模式单选按钮组组件
class _ProxyModeRadioGroup extends StatelessWidget {
  final ProxyMode selectedMode;
  final ValueChanged<ProxyMode> onModeChanged;

  const _ProxyModeRadioGroup({
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ProxyMode.values.map((mode) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selectedMode == mode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              width: selectedMode == mode ? 2 : 1,
            ),
            color: selectedMode == mode
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedMode == mode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                color: selectedMode == mode
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              child: selectedMode == mode
                  ? Icon(
                      Icons.circle,
                      size: 10,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
            ),
            title: Text(
              mode.displayName,
              style: TextStyle(
                fontWeight: selectedMode == mode
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: selectedMode == mode
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
            subtitle: Text(
              mode.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: selectedMode == mode
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () => onModeChanged(mode),
          ),
        );
      }).toList(),
    );
  }
}
