import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/theme_color.dart';
import '../providers/theme_color_provider.dart';

/// 主题颜色选择器
class ThemeColorPicker extends ConsumerStatefulWidget {
  const ThemeColorPicker({super.key});

  @override
  ConsumerState<ThemeColorPicker> createState() => _ThemeColorPickerState();
}

class _ThemeColorPickerState extends ConsumerState<ThemeColorPicker>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
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
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorSettings = ref.watch(themeColorProvider);
    final colorNotifier = ref.read(themeColorProvider.notifier);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.color_lens,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '主题颜色',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                // 圆形颜色选择器
                GestureDetector(
                  onTap: () {
                    // 点击外部区域收起
                    if (_isExpanded) {
                      _collapse();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: _buildCircularColorPicker(context, ref, colorSettings, colorNotifier),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建圆形颜色选择器
  Widget _buildCircularColorPicker(
    BuildContext context,
    WidgetRef ref,
    ThemeColorSettings colorSettings,
    ThemeColorNotifier colorNotifier,
  ) {
    return SizedBox(
      width: 250, // 为展开选项预留空间
      height: 32,
      child: Stack(
        clipBehavior: Clip.none, // 允许内容溢出
        children: [
          // 主圆形按钮
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                _toggleExpanded();
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorSettings.currentColor.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorSettings.currentColor.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          
          // 展开的颜色选项
          if (_isExpanded) // 只在展开时渲染
            Positioned(
              right: 40,
              top: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    alignment: Alignment.centerRight,
                    child: Opacity(
                      opacity: _animation.value,
                      child: _buildExpandedColorOptions(
                        context, ref, colorSettings, colorNotifier
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 构建展开的颜色选项
  Widget _buildExpandedColorOptions(
    BuildContext context,
    WidgetRef ref,
    ThemeColorSettings colorSettings,
    ThemeColorNotifier colorNotifier,
  ) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ThemeColorType.values.map((colorType) {
          final isSelected = colorSettings.currentColor == colorType;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () async {
                // 添加触觉反馈
                HapticFeedback.lightImpact();
                await colorNotifier.updateCurrentColor(colorType);
                
                // 收起选择器
                _collapse();
                
                // 显示切换成功提示
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('已切换到${colorType.displayName}主题'),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                }
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorType.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: isSelected ? 2 : 0,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

}
