import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../../domain/entities/app_settings.dart' as app_settings;

/// 外观设置页面
class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('外观设置'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildThemeSection(context, ref),
          const SizedBox(height: 16),
          _buildLanguageSection(context, ref),
          const SizedBox(height: 16),
          _buildAnimationSection(context, ref),
          const SizedBox(height: 16),
          _buildDisplaySection(context, ref),
        ],
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
                            .updateThemeMode(value);
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

  /// 语言设置区域
  Widget _buildLanguageSection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '语言设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ListTile(
              title: const Text('界面语言'),
              subtitle: Text(_getLanguageName(ref.watch(settingsProvider).language)),
              trailing: DropdownButton<String>(
                value: ref.watch(settingsProvider).language,
                items: const [
                  DropdownMenuItem(value: 'zh', child: Text('中文')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier).updateLanguage(value);
                  }
                },
              ),
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

            ListTile(
              title: const Text('字体大小'),
              subtitle: const Text('调整界面字体大小'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showFontSizeSettings(context),
              contentPadding: EdgeInsets.zero,
            ),

            const Divider(),

            ListTile(
              title: const Text('界面密度'),
              subtitle: const Text('调整界面元素间距'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDensitySettings(context),
              contentPadding: EdgeInsets.zero,
            ),
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

  /// 显示字体大小设置
  void _showFontSizeSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('字体大小'),
        content: const Text('字体大小设置功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  /// 显示界面密度设置
  void _showDensitySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('界面密度'),
        content: const Text('界面密度设置功能开发中...'),
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

  String _getLanguageName(String code) {
    switch (code) {
      case 'zh':
        return '中文';
      case 'en':
        return 'English';
      default:
        return '未知';
    }
  }
}
