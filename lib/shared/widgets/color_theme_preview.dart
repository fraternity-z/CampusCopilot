import 'package:flutter/material.dart';
import '../theme/color_theme.dart';

/// 颜色主题预览组件
/// 
/// 展示不同颜色主题的效果，便于用户选择
class ColorThemePreview extends StatelessWidget {
  final AppColorTheme colorTheme;
  final VoidCallback? onTap;
  final bool isSelected;

  const ColorThemePreview({
    super.key,
    required this.colorTheme,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    final secondaryColor = ColorThemeConfig.getSecondaryColor(colorTheme);
    final gradient = ColorThemeConfig.getPrimaryGradient(colorTheme);
    final themeName = ColorThemeConfig.getDisplayName(colorTheme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 主题名称
            Text(
              themeName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryColor : null,
              ),
            ),
            const SizedBox(height: 6),

            // 颜色预览
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 主色
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 2,
                          )
                        : Border.all(
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.6),
                            width: 1,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                            ? primaryColor.withValues(alpha: 0.6)
                            : primaryColor.withValues(alpha: 0.3),
                        blurRadius: isSelected ? 4 : 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        )
                      : null,
                ),

                // 次要色
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: secondaryColor.withValues(alpha: 0.2),
                        blurRadius: 1,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // 渐变预览
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 4),

            // 示例按钮
            ElevatedButton(
              onPressed: null, // 禁用状态仅用于预览
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              ),
              child: Text(
                '示例',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 所有颜色主题的网格预览
class ColorThemeGrid extends StatelessWidget {
  final AppColorTheme selectedTheme;
  final ValueChanged<AppColorTheme>? onThemeChanged;

  const ColorThemeGrid({
    super.key,
    required this.selectedTheme,
    this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: ColorThemeConfig.getAllThemes().length,
      itemBuilder: (context, index) {
        final theme = ColorThemeConfig.getAllThemes()[index];
        return ColorThemePreview(
          colorTheme: theme,
          isSelected: theme == selectedTheme,
          onTap: () => onThemeChanged?.call(theme),
        );
      },
    );
  }
}
