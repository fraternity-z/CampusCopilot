import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(UIConstants.borderRadius),
              bottomRight: Radius.circular(UIConstants.borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: UIConstants.shadowOpacity),
                blurRadius: UIConstants.shadowBlurRadius,
                offset: UIConstants.shadowOffset,
              ),
            ],
          ),
          child: child,
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
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.smart_toy,
            color: Theme.of(context).colorScheme.primary,
            size: UIConstants.iconSizeXL,
          ),
          const SizedBox(width: UIConstants.spacingM),
          Expanded(
            child: Text(
              'Anywherechat',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 关闭侧边栏按钮
          IconButton(
            icon: const Icon(Icons.close, size: UIConstants.iconSizeLarge),
            onPressed: () {
              ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(true);
            },
            tooltip: '关闭侧边栏',
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: UIConstants.spacingS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              config.icon,
              size: UIConstants.iconSizeMedium,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: UIConstants.spacingXS),
            Text(
              config.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
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
      child: Container(
        color: Colors.black.withValues(alpha: UIConstants.overlayOpacity),
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
        elevation: 4,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          onTap: () {
            ref.read(uiSettingsProvider.notifier).setSidebarCollapsed(false);
          },
          child: Container(
            width: UIConstants.avatarSizeSmall,
            height: UIConstants.avatarSizeSmall,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: UIConstants.borderOpacity),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.menu,
              size: UIConstants.iconSizeSmall + 2,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
