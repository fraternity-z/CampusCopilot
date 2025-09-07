import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/keyboard_utils.dart';
import '../../../../shared/theme/color_theme.dart';

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
            _buildColorThemeSection(context, ref),
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
          ],
        ),
      ),
    );
  }

  /// 颜色主题设置区域
  Widget _buildColorThemeSection(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.color_lens,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '颜色主题',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 颜色主题选择器
            _ColorThemeSelector(),
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

/// 可展开的颜色主题选择器
class _ColorThemeSelector extends ConsumerStatefulWidget {
  const _ColorThemeSelector();

  @override
  ConsumerState<_ColorThemeSelector> createState() => _ColorThemeSelectorState();
}

class _ColorThemeSelectorState extends ConsumerState<_ColorThemeSelector>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currentColorTheme = settings.colorTheme;
    final currentColor = ColorThemeConfig.getPreviewColor(currentColorTheme);
    final currentColorName = ColorThemeConfig.getDisplayName(currentColorTheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主题选择器标题和按钮
        Row(
          children: [
            Text(
              '主色调',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            _buildCurrentThemeButton(context, currentColor, currentColorName),
          ],
        ),

        // 展开的颜色选项
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(
                maxWidth: 240, // 进一步减小最大宽度
              ),
              child: _buildColorGrid(context, currentColorTheme),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建当前主题按钮
  Widget _buildCurrentThemeButton(BuildContext context, Color currentColor, String currentColorName) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _isExpanded 
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isExpanded 
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 0.8,
          ),
          boxShadow: _isExpanded ? [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentColor.withValues(alpha: 0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              currentColorName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建颜色网格
  Widget _buildColorGrid(BuildContext context, AppColorTheme currentColorTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择主色调',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: ColorThemeConfig.getAllThemes().length,
            itemBuilder: (context, index) {
              final colorTheme = ColorThemeConfig.getAllThemes()[index];
              final isSelected = currentColorTheme == colorTheme;
              final color = ColorThemeConfig.getPreviewColor(colorTheme);
              final colorName = ColorThemeConfig.getDisplayName(colorTheme);

              return GestureDetector(
                onTap: () {
                  ref.read(settingsProvider.notifier).updateColorTheme(colorTheme);
                  // 移除自动收起，保持展开状态便于连续选择
                },
                child: Tooltip(
                  message: colorName,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                            width: isSelected ? 2.5 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                            if (isSelected)
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
