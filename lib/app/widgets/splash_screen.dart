import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/theme/app_theme.dart';

/// 开屏动画界面
/// 
/// 提供现代化的启动动画，包含：
/// - Logo缩放和淡入动画
/// - 品牌名称打字机效果
/// - 渐变背景动画
/// - 加载指示器
class SplashScreen extends StatefulWidget {
  /// 动画完成后的回调
  final VoidCallback? onAnimationComplete;
  
  /// 动画持续时间（毫秒）
  final Duration animationDuration;

  const SplashScreen({
    super.key,
    this.onAnimationComplete,
    this.animationDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late AnimationController _fadeOutController;
  
  // 是否已经开始淡出
  bool _isFadingOut = false;
  
  // 提前与主动画重叠的淡出时长（更自然的交叉淡出）
  final Duration _fadeOverlap = const Duration(milliseconds: 450);
  
  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: 520),
      vsync: this,
    );

    _startAnimation();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation() async {
    // 启动背景动画
    _backgroundController.repeat();
    
    // 并行启动主要进度动画
    _mainController.forward();

    // 计算淡出开始时间（不能早于0，不能超过主动画时长）
    final overlapMs = _fadeOverlap.inMilliseconds;
    final mainMs = widget.animationDuration.inMilliseconds;
    final startAfter = Duration(milliseconds: (mainMs - overlapMs).clamp(0, mainMs));

    // 提前启动淡出，形成重叠
    await Future.delayed(startAfter, () async {
      if (mounted) {
        setState(() => _isFadingOut = true);
      }
      await _fadeOutController.forward();
    });

    // 确保主动画完成
    if (_mainController.status != AnimationStatus.completed) {
      await _mainController.forward();
    }

    // 回调在交叉淡出完成后触发
    widget.onAnimationComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _fadeOutController,
      builder: (context, child) {
        final fadeValue = _isFadingOut ? (1.0 - _fadeOutController.value) : 1.0;
        final scaleValue = 1.0 + (_fadeOutController.value * 0.04); // 轻微放大后淡出
        return Opacity(
          opacity: fadeValue,
          child: Transform.scale(
            scale: scaleValue,
            filterQuality: FilterQuality.high,
            child: Scaffold(
              backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // 动态渐变背景
                    _buildAnimatedBackground(isDark),
                    
                    // 主要内容
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo动画
                          _buildLogoAnimation(),
                          
                          const SizedBox(height: 32),
                          
                          // 品牌名称动画
                          _buildBrandNameAnimation(),
                          
                          const SizedBox(height: 16),
                          
                          // 副标题动画
                          _buildSubtitleAnimation(),
                          
                          const SizedBox(height: 48),
                          
                          // 加载指示器
                          _buildLoadingIndicator(),
                        ],
                      ),
                    ),
                    
                    // 底部版本信息
                    _buildVersionInfo(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建动态渐变背景
  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        final progress = _backgroundController.value;
        
        return Stack(
          children: [
            // 主背景渐变
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft + 
                         Alignment.lerp(
                           Alignment.topLeft, 
                           Alignment.bottomRight, 
                           progress,
                         )! * 0.3,
                  end: Alignment.bottomRight + 
                       Alignment.lerp(
                         Alignment.bottomRight, 
                         Alignment.topLeft, 
                         progress,
                       )! * 0.3,
                  colors: isDark
                      ? [
                          const Color(0xFF1A1A2E),
                          const Color(0xFF16213E),
                          const Color(0xFF0F3460),
                          const Color(0xFF1A1A40),
                        ]
                      : [
                          const Color(0xFFFFFFFF),
                          const Color(0xFFF8FAFC),
                          const Color(0xFFEDF2F7),
                          const Color(0xFFE2E8F0),
                        ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            // 浮动的装饰元素
            Positioned(
              top: 50 + progress * 20,
              right: 30 + progress * 10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6750A4).withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100 + progress * 15,
              left: 40 + progress * 8,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF764BA2).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200 + progress * 25,
              left: 20 + progress * 12,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF667EEA).withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建Logo动画
  Widget _buildLogoAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 外圈光晕效果
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF6750A4).withValues(alpha: 0.15),
                const Color(0xFF6750A4).withValues(alpha: 0.05),
                Colors.transparent,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
        // 主Logo容器
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
                Color(0xFF6750A4),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6750A4).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 应用图标
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // 如果图标加载失败，使用备用图标
                        return const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 40,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
              // 小装饰点
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
    .animate()
    .fadeIn(
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    )
    .scale(
      begin: const Offset(0.85, 0.85),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutBack,
    )
    .then(delay: const Duration(milliseconds: 100))
    .shake(
      duration: const Duration(milliseconds: 300),
      hz: 2,
      offset: const Offset(0, 2),
    )
    .then(delay: const Duration(milliseconds: 200))
    .shimmer(
      duration: const Duration(milliseconds: 600),
      color: Colors.white.withValues(alpha: 0.4),
    );
  }

  /// 构建品牌名称动画
  Widget _buildBrandNameAnimation() {
    return Text(
      'Campus Copilot',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF1C1B1F),
      ),
    )
    .animate()
    .fadeIn(
      delay: const Duration(milliseconds: 420),
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeOutCubic,
    )
    .slideY(
      begin: 0.25,
      end: 0.0,
      delay: const Duration(milliseconds: 420),
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeOutCubic,
    )
    .then(delay: const Duration(milliseconds: 100))
    .animate(onPlay: (controller) => controller.repeat())
    .shimmer(
      duration: const Duration(milliseconds: 1200),
      color: const Color(0xFF6750A4).withValues(alpha: 0.3),
    );
  }

  /// 构建副标题动画
  Widget _buildSubtitleAnimation() {
    return Text(
      '智能校园助手',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    )
    .animate()
    .fadeIn(
      delay: const Duration(milliseconds: 760),
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
    )
    .slideY(
      begin: 0.22,
      end: 0.0,
      delay: const Duration(milliseconds: 760),
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
    );
  }

  /// 构建加载指示器
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          // 自定义进度条
          Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.5),
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            child: AnimationBuilder(
              animation: _mainController,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _mainController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.5),
                      gradient: AppTheme.primaryGradient,
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 加载文本
          AnimationBuilder(
            animation: _mainController,
            builder: (context, child) {
              final messages = [
                '正在初始化...',
                '加载组件中...',
                '准备就绪...',
              ];
              
              final progress = _mainController.value;
              final messageIndex = (progress * (messages.length - 1)).floor();
              final currentMessage = messages[messageIndex.clamp(0, messages.length - 1)];
              
              return Text(
                currentMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(
      delay: const Duration(milliseconds: 980),
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
    )
    .slideY(
      begin: 0.2,
      end: 0.0,
      delay: const Duration(milliseconds: 980),
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
    );
  }

  /// 构建版本信息
  Widget _buildVersionInfo() {
    return Positioned(
      bottom: 48,
      left: 0,
      right: 0,
      child: Text(
        'v1.0.0',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      )
      .animate()
      .fadeIn(
        delay: const Duration(milliseconds: 1400),
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}

/// AnimationBuilder helper widget
class AnimationBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimationBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}