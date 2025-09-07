import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/ui_constants.dart';
import '../../features/settings/presentation/providers/ui_settings_provider.dart';

/// 侧边栏容器组件
/// 
/// 负责侧边栏的布局、动画和手势处理
class SidebarContainer extends ConsumerWidget {
  final Widget child;

  const SidebarContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth > 600 
        ? UIConstants.sidebarWidth 
        : screenWidth * UIConstants.sidebarWidthMobile;

    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        // 添加左滑手势关闭侧边栏
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -UIConstants.swipeVelocityThreshold) {
            ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(true);
          }
        },
        child: AnimatedContainer(
          duration: UIConstants.animationDuration,
          curve: UIConstants.defaultCurve,
          width: sidebarWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(UIConstants.borderRadius * 1.5),
              bottomRight: Radius.circular(UIConstants.borderRadius * 1.5),
            ),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: UIConstants.shadowBlurRadius * 1.5,
                offset: const Offset(2, 0),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: UIConstants.shadowOpacity * 0.3),
                blurRadius: UIConstants.shadowBlurRadius,
                offset: UIConstants.shadowOffset,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(UIConstants.borderRadius * 1.5),
              bottomRight: Radius.circular(UIConstants.borderRadius * 1.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 侧边栏头部组件
class SidebarHeader extends ConsumerWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: UIConstants.headerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingL,
        vertical: UIConstants.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
            Theme.of(context).colorScheme.surface,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Campus Copilot',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '智能助手',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 关闭侧边栏按钮
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: UIConstants.iconSizeLarge,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(true);
              },
              tooltip: '关闭侧边栏',
            ),
          ),
        ],
      ),
    );
  }
}

/// 侧边栏标签栏组件
class SidebarTabBar extends ConsumerWidget {
  final SidebarTab selectedTab;
  final Function(SidebarTab) onTabSelected;

  const SidebarTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacingS),
      child: Row(
        children: SidebarTab.values.map((tab) {
          return Expanded(
            child: _SidebarTab(
              tab: tab,
              isSelected: tab == selectedTab,
              onTap: () => onTabSelected(tab),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 单个侧边栏标签组件
class _SidebarTab extends StatelessWidget {
  final SidebarTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarTab({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = SidebarTabConfig.getConfig(tab);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius * 1.5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              vertical: UIConstants.spacingS + 2,
              horizontal: UIConstants.spacingXS,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius * 1.5),
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                      ],
                    )
                  : null,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildTabIcon(context, config, isSelected),
                ),
                const SizedBox(height: UIConstants.spacingXS + 2),
                Text(
                  config.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: -0.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTabIcon(
  BuildContext context,
  TabConfig config,
  bool isSelected,
) {
  final Color color = isSelected
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.onSurfaceVariant;

  // 优先使用配置中的 asset；若为空且为助手页签，使用默认 assistant.svg
  final String? assetPath = config.asset ??
      (config.label == '助手' ? 'assets/logos/assistant.svg' : null);

  if (assetPath != null) {
    return SvgPicture.asset(
      assetPath,
      width: UIConstants.iconSizeMedium,
      height: UIConstants.iconSizeMedium,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  return Icon(
    config.icon,
    size: UIConstants.iconSizeMedium,
    color: color,
  );
}

/// 侧边栏浮层背景
class SidebarOverlay extends ConsumerWidget {
  const SidebarOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(true);
      },
      child: AnimatedContainer(
        duration: UIConstants.animationDuration,
        curve: UIConstants.defaultCurve,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withValues(alpha: UIConstants.overlayOpacity * 1.2),
              Colors.black.withValues(alpha: UIConstants.overlayOpacity * 0.6),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

/// 侧边栏展开按钮
class SidebarExpandButton extends ConsumerWidget {
  const SidebarExpandButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(
        top: UIConstants.spacingS,
        left: UIConstants.spacingS,
      ),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius * 1.5),
        shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(UIConstants.borderRadius * 1.5),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(UIConstants.borderRadius * 1.5),
            onTap: () {
              ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(false);
            },
            child: Container(
              width: UIConstants.avatarSizeSmall + 4,
              height: UIConstants.avatarSizeSmall + 4,
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(UIConstants.borderRadius),
                ),
                child: Icon(
                  Icons.menu_rounded,
                  size: UIConstants.iconSizeSmall + 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
