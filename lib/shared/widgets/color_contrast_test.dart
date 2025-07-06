import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'modern_persona_card.dart';
import 'modern_settings_widgets.dart';

/// 颜色对比度测试页面
class ColorContrastTestPage extends StatefulWidget {
  const ColorContrastTestPage({super.key});

  @override
  State<ColorContrastTestPage> createState() => _ColorContrastTestPageState();
}

class _ColorContrastTestPageState extends State<ColorContrastTestPage> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('颜色对比度测试')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: [
          // 颜色系统展示
          _buildColorSystemSection(),

          const SizedBox(height: AppTheme.spacingL),

          // 智能体卡片测试
          _buildPersonaCardSection(),

          const SizedBox(height: AppTheme.spacingL),

          // 设置组件测试
          _buildSettingsSection(),

          const SizedBox(height: AppTheme.spacingL),

          // 文字对比度测试
          _buildTextContrastSection(),
        ],
      ),
    );
  }

  Widget _buildColorSystemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '颜色系统',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spacingM),

        // 主色调
        _buildColorCard(
          '主色调',
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.onPrimary,
        ),

        // 主色容器
        _buildColorCard(
          '主色容器',
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context).colorScheme.onPrimaryContainer,
        ),

        // 次色调
        _buildColorCard(
          '次色调',
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.onSecondary,
        ),

        // 次色容器
        _buildColorCard(
          '次色容器',
          Theme.of(context).colorScheme.secondaryContainer,
          Theme.of(context).colorScheme.onSecondaryContainer,
        ),

        // 表面色
        _buildColorCard(
          '表面色',
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.onSurface,
        ),

        // 表面变体
        _buildColorCard(
          '表面变体',
          Theme.of(context).colorScheme.surfaceContainerHighest,
          Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildColorCard(String title, Color backgroundColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  '这是示例文字，用于测试颜色对比度是否足够清晰可读。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  '背景色: ${backgroundColor.toARGB32().toRadixString(16).toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.6),
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  '文字色: ${textColor.toARGB32().toRadixString(16).toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor.withValues(alpha: 0.6),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '智能体卡片测试',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spacingM),

        // 未选中状态
        ModernPersonaCard(
          name: '普通智能体',
          description: '这是一个未选中状态的智能体卡片，用于测试文字对比度。',
          tags: const ['测试', '对比度', '可读性'],
          usageCount: 42,
          lastUsed: DateTime.now(),
          isSelected: false,
        ),

        // 选中状态
        ModernPersonaCard(
          name: '选中智能体',
          description: '这是一个选中状态的智能体卡片，用于测试文字对比度。背景是浅紫色，文字应该是深色以确保可读性。',
          tags: const ['选中', '对比度', '测试'],
          usageCount: 88,
          lastUsed: DateTime.now(),
          isSelected: true,
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '设置组件测试',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spacingM),

        ModernSettingsGroup(
          title: '对比度测试',
          subtitle: '测试设置组件的文字对比度',
          children: [
            ModernSwitchSettingsItem(
              title: '开关设置',
              subtitle: '这是一个开关设置项，用于测试文字对比度',
              leading: const Icon(Icons.contrast),
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),

            ModernSettingsItem(
              title: '普通设置项',
              subtitle: '这是一个普通设置项，用于测试文字对比度',
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextContrastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '文字对比度测试',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spacingM),

        // 不同透明度的文字测试
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '主色容器背景上的文字测试',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                '100% 不透明度：这是完全不透明的文字，应该具有最高的对比度。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                '80% 透明度：这是80%透明度的文字，用于次要信息显示。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                '60% 透明度：这是60%透明度的文字，用于辅助信息显示。',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppTheme.spacingM),

        // 普通表面上的文字测试
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '普通表面背景上的文字测试',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                '100% 不透明度：这是完全不透明的文字，应该具有最高的对比度。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                '80% 透明度：这是80%透明度的文字，用于次要信息显示。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                '60% 透明度：这是60%透明度的文字，用于辅助信息显示。',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
