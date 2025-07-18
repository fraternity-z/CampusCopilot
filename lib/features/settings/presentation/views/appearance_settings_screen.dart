import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/keyboard_utils.dart';

import '../providers/settings_provider.dart';
import '../../domain/entities/app_settings.dart' as app_settings;

/// 外观设置页面
class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(title: const Text('外观设置'), elevation: 0),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildThemeSection(context, ref),
            const SizedBox(height: 16),
            _buildAnimationSection(context, ref),
            const SizedBox(height: 16),
            _buildDisplaySection(context, ref),
            const SizedBox(height: 16),
            _buildThinkingChainSection(context, ref),
          ],
        ),
      ),
    );
  }

  /// 主题设置区域
  Widget _buildThemeSection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '主题设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 主题模式选择
            Consumer(
              builder: (context, ref, child) {
                final settings = ref.watch(settingsProvider);
                final currentTheme = _getThemeModeString(settings.themeMode);

                return ListTile(
                  title: const Text('主题模式'),
                  subtitle: Text(currentTheme),
                  trailing: DropdownButton<String>(
                    value: currentTheme,
                    items: const [
                      DropdownMenuItem(value: '跟随系统', child: Text('跟随系统')),
                      DropdownMenuItem(value: '浅色', child: Text('浅色')),
                      DropdownMenuItem(value: '深色', child: Text('深色')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .updateThemeMode(_getThemeModeFromString(value));
                      }
                    },
                  ),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),

            const Divider(),

            // 主题预览
            ListTile(
              title: const Text('主题预览'),
              subtitle: const Text('查看不同主题的效果'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemePreview(context),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 动画设置区域
  Widget _buildAnimationSection(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.animation,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '动画效果',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('启用界面动画'),
              subtitle: const Text('为获得更流畅的体验，请启用动画'),
              value: settings.enableAnimations,
              onChanged: (value) {
                notifier.updateEnableAnimations(value);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示设置区域
  Widget _buildDisplaySection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.display_settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '显示设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Remove ListTile for '字体大小'
          ],
        ),
      ),
    );
  }

  /// 思考链设置区域
  Widget _buildThinkingChainSection(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final thinkingChainSettings = settings.thinkingChainSettings;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '思考链显示',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            SwitchListTile(
              title: const Text('显示AI思考过程'),
              subtitle: const Text('显示AI模型的思考链，帮助理解推理过程'),
              value: thinkingChainSettings.showThinkingChain,
              onChanged: (value) {
                notifier.updateThinkingChainSettings(
                  thinkingChainSettings.copyWith(showThinkingChain: value),
                );
              },
              contentPadding: EdgeInsets.zero,
            ),

            if (thinkingChainSettings.showThinkingChain) ...[
              const Divider(),

              SwitchListTile(
                title: const Text('启用思考链动画'),
                subtitle: const Text('显示打字机效果的思考链动画'),
                value: thinkingChainSettings.enableAnimation,
                onChanged: (value) {
                  notifier.updateThinkingChainSettings(
                    thinkingChainSettings.copyWith(enableAnimation: value),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),

              if (thinkingChainSettings.enableAnimation) ...[
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('动画速度'),
                  subtitle: Text(
                    '当前: ${thinkingChainSettings.animationSpeed}ms/字符',
                  ),
                  trailing: SizedBox(
                    width: 150,
                    child: Slider(
                      value: thinkingChainSettings.animationSpeed.toDouble(),
                      min: 10,
                      max: 200,
                      divisions: 19,
                      label: '${thinkingChainSettings.animationSpeed}ms',
                      onChanged: (value) {
                        notifier.updateThinkingChainSettings(
                          thinkingChainSettings.copyWith(
                            animationSpeed: value.round(),
                          ),
                        );
                      },
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ],

              const Divider(),

              SwitchListTile(
                title: const Text('自动折叠长内容'),
                subtitle: const Text('长思考链内容将自动折叠，可点击展开'),
                value: thinkingChainSettings.autoCollapseOnLongContent,
                onChanged: (value) {
                  notifier.updateThinkingChainSettings(
                    thinkingChainSettings.copyWith(
                      autoCollapseOnLongContent: value,
                    ),
                  );
                },
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 8),

              ListTile(
                title: const Text('显示长度限制'),
                subtitle: Text(
                  '超过 ${thinkingChainSettings.maxDisplayLength} 字符时${thinkingChainSettings.autoCollapseOnLongContent ? "自动折叠" : "截断显示"}',
                ),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: thinkingChainSettings.maxDisplayLength.toDouble(),
                    min: 500,
                    max: 5000,
                    divisions: 18,
                    label: '${thinkingChainSettings.maxDisplayLength}字符',
                    onChanged: (value) {
                      notifier.updateThinkingChainSettings(
                        thinkingChainSettings.copyWith(
                          maxDisplayLength: value.round(),
                        ),
                      );
                    },
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 显示主题预览
  void _showThemePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('主题预览'),
        content: const Text('主题预览功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 将ThemeMode转换为字符串
  String _getThemeModeString(app_settings.ThemeMode themeMode) {
    switch (themeMode) {
      case app_settings.ThemeMode.light:
        return '浅色';
      case app_settings.ThemeMode.dark:
        return '深色';
      case app_settings.ThemeMode.system:
        return '跟随系统';
    }
  }

  /// 将字符串转换为ThemeMode
  app_settings.ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case '浅色':
        return app_settings.ThemeMode.light;
      case '深色':
        return app_settings.ThemeMode.dark;
      case '跟随系统':
      default:
        return app_settings.ThemeMode.system;
    }
  }
}
