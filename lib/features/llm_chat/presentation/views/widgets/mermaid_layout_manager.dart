import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../repository/logger.dart';

/// Mermaid图表响应式布局管理器
/// 
/// 功能特性：
/// - 智能尺寸计算，避免图表超出边界
/// - 响应式适配不同屏幕尺寸
/// - 动态间距控制，防止与下方内容重合
/// - 保持低耦合性，不影响原有渲染逻辑
class MermaidLayoutManager {
  /// 计算最优的图表显示尺寸
  /// 
  /// [screenSize] 屏幕尺寸
  /// [contentSize] 图表内容原始尺寸
  /// [nodeCount] 节点数量，用于复杂度评估
  /// [connectionCount] 连接线数量
  static MermaidDisplayConfig calculateOptimalSize({
    required Size screenSize,
    required Size contentSize,
    required int nodeCount,
    required int connectionCount,
  }) {
    // 屏幕安全区域配置
    final safeAreaConfig = _calculateSafeArea(screenSize);
    
    // 内容复杂度评估
    final complexityFactor = _calculateComplexityFactor(nodeCount, connectionCount);
    
    // 基础尺寸计算
    final baseSize = _calculateBaseSize(safeAreaConfig, complexityFactor);
    
    // 应用内容比例约束
    final constrainedSize = _applyContentConstraints(baseSize, contentSize);
    
    // 计算最终显示配置
    return MermaidDisplayConfig(
      displaySize: constrainedSize,
      containerPadding: safeAreaConfig.containerPadding,
      bottomMargin: safeAreaConfig.bottomMargin,
      scalingFactor: constrainedSize.width / contentSize.width,
      allowFullscreen: _shouldAllowFullscreen(constrainedSize, contentSize),
      showScrollHint: _shouldShowScrollHint(constrainedSize, contentSize),
    );
  }
  
  /// 计算屏幕安全区域配置
  static _SafeAreaConfig _calculateSafeArea(Size screenSize) {
    final width = screenSize.width;
    final height = screenSize.height;
    
    // 根据屏幕尺寸分类
    final isSmallScreen = width < 600;
    final isMediumScreen = width >= 600 && width < 1200;
    
    // 动态计算安全边距
    final horizontalMargin = isSmallScreen ? 16.0 : (isMediumScreen ? 24.0 : 32.0);
    final verticalMargin = isSmallScreen ? 12.0 : 16.0;
    
    // 最大可用区域（保留足够空间给其他UI元素）
    final maxWidth = width - (horizontalMargin * 2);
    final maxHeight = math.min(
      height * 0.7, // 增加到70%，给图表更多空间
      isSmallScreen ? 350.0 : (isMediumScreen ? 450.0 : 600.0),
    );
    
    return _SafeAreaConfig(
      maxSize: Size(maxWidth, maxHeight),
      containerPadding: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
        vertical: verticalMargin,
      ),
      bottomMargin: verticalMargin * 1.5, // 与下方内容的间距
    );
  }
  
  /// 计算内容复杂度因子
  static double _calculateComplexityFactor(int nodeCount, int connectionCount) {
    // 基于节点和连接数量评估图表复杂度
    final nodeComplexity = math.min(nodeCount / 8.0, 1.0); // 降低节点复杂度阈值
    final connectionComplexity = math.min(connectionCount / 12.0, 1.0); // 降低连接复杂度阈值
    
    // 综合复杂度评分，对简单图表更友好
    final rawComplexity = nodeComplexity * 0.6 + connectionComplexity * 0.4;
    
    // 确保即使简单图表也有合理的大小
    return math.max(0.5, rawComplexity); // 最小50%大小，而不是20%
  }
  
  /// 计算基础显示尺寸
  static Size _calculateBaseSize(
    _SafeAreaConfig safeArea,
    double complexityFactor,
  ) {
    // 基础尺寸 = 最大可用尺寸 * 复杂度因子
    final baseWidth = safeArea.maxSize.width;
    final baseHeight = safeArea.maxSize.height * complexityFactor;
    
    return Size(baseWidth, baseHeight);
  }
  
  /// 应用内容比例约束
  static Size _applyContentConstraints(Size baseSize, Size contentSize) {
    if (contentSize.width <= 0 || contentSize.height <= 0) {
      return baseSize;
    }
    
    // 如果内容尺寸比基础尺寸小，优先使用内容尺寸（避免过度放大）
    final useContentWidth = contentSize.width < baseSize.width;
    final useContentHeight = contentSize.height < baseSize.height;
    
    if (useContentWidth && useContentHeight) {
      // 内容比基础尺寸小，直接使用内容尺寸
      return contentSize;
    }
    
    // 计算内容的宽高比
    final contentAspectRatio = contentSize.width / contentSize.height;
    final baseAspectRatio = baseSize.width / baseSize.height;
    
    // 根据宽高比调整尺寸，保持内容不变形
    if (contentAspectRatio > baseAspectRatio) {
      // 内容更宽，以宽度为准
      final adjustedHeight = baseSize.width / contentAspectRatio;
      return Size(baseSize.width, math.min(adjustedHeight, baseSize.height));
    } else {
      // 内容更高，以高度为准
      final adjustedWidth = baseSize.height * contentAspectRatio;
      return Size(math.min(adjustedWidth, baseSize.width), baseSize.height);
    }
  }
  
  /// 判断是否应该允许全屏显示
  static bool _shouldAllowFullscreen(Size displaySize, Size contentSize) {
    // 如果内容明显无法正常显示，才建议全屏（更宽松的条件）
    if (contentSize.width == double.infinity || contentSize.height == double.infinity) {
      return false; // 无限大尺寸不需要全屏提示
    }
    
    final widthRatio = displaySize.width / contentSize.width;
    final heightRatio = displaySize.height / contentSize.height;
    
    // 只有当内容真的很大时才提示全屏
    return widthRatio < 0.5 || heightRatio < 0.5;
  }
  
  /// 判断是否应该显示滚动提示
  static bool _shouldShowScrollHint(Size displaySize, Size contentSize) {
    // 更宽松的滚动提示条件，只有当内容确实过大时才提示
    if (contentSize.width == double.infinity || contentSize.height == double.infinity) {
      return false; // 无限大尺寸不显示滚动提示
    }
    
    return contentSize.width > displaySize.width * 1.5 ||
           contentSize.height > displaySize.height * 1.5;
  }
}

/// 安全区域配置
class _SafeAreaConfig {
  final Size maxSize;
  final EdgeInsets containerPadding;
  final double bottomMargin;
  
  const _SafeAreaConfig({
    required this.maxSize,
    required this.containerPadding,
    required this.bottomMargin,
  });
}

/// Mermaid图表显示配置
class MermaidDisplayConfig {
  /// 最终显示尺寸
  final Size displaySize;
  
  /// 容器内边距
  final EdgeInsets containerPadding;
  
  /// 底部间距（与下方内容的间距）
  final double bottomMargin;
  
  /// 缩放因子
  final double scalingFactor;
  
  /// 是否允许全屏显示
  final bool allowFullscreen;
  
  /// 是否显示滚动提示
  final bool showScrollHint;
  
  const MermaidDisplayConfig({
    required this.displaySize,
    required this.containerPadding,
    required this.bottomMargin,
    required this.scalingFactor,
    required this.allowFullscreen,
    required this.showScrollHint,
  });
  
  /// 获取容器的总高度（包含边距）
  double get totalHeight {
    return displaySize.height + containerPadding.vertical + bottomMargin;
  }
  
  /// 判断是否需要缩放显示
  bool get needsScaling {
    return scalingFactor < 0.95; // 只有当需要明显缩小时才缩放，避免微小缩放造成模糊
  }
  
  /// 生成调试信息
  String toDebugString() {
    return '''
MermaidDisplayConfig:
  displaySize: ${displaySize.width.toStringAsFixed(1)} x ${displaySize.height.toStringAsFixed(1)}
  scalingFactor: ${scalingFactor.toStringAsFixed(2)}
  totalHeight: ${totalHeight.toStringAsFixed(1)}
  allowFullscreen: $allowFullscreen
  showScrollHint: $showScrollHint
  needsScaling: $needsScaling
''';
  }
}

/// 响应式Mermaid容器Widget
/// 
/// 使用布局管理器提供的配置来优化显示效果
class ResponsiveMermaidContainer extends StatelessWidget {
  final Widget child;
  final Size contentSize;
  final int nodeCount;
  final int connectionCount;
  final bool debugMode;
  
  const ResponsiveMermaidContainer({
    super.key,
    required this.child,
    required this.contentSize,
    required this.nodeCount,
    required this.connectionCount,
    this.debugMode = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // 计算最优显示配置
    final config = MermaidLayoutManager.calculateOptimalSize(
      screenSize: screenSize,
      contentSize: contentSize,
      nodeCount: nodeCount,
      connectionCount: connectionCount,
    );
    
    // 调试信息输出
    if (debugMode) {
      log.debug('Mermaid Layout Debug:\n${config.toDebugString()}');
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: config.bottomMargin),
      padding: config.containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主要内容区域
          Container(
            width: double.infinity,
            height: config.displaySize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: config.needsScaling
                    ? Transform.scale(
                        scale: config.scalingFactor,
                        child: child,
                      )
                    : child,
              ),
            ),
          ),
          
          // 操作提示区域
          if (config.allowFullscreen || config.showScrollHint)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (config.showScrollHint)
                    Flexible(
                      child: Text(
                        '💡 图表较大，建议点击放大查看',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  if (config.allowFullscreen)
                    Icon(
                      Icons.fullscreen,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
