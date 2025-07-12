import 'package:flutter/material.dart';

/// 带动画效果的标题组件
/// 
/// 当标题发生变化时，会显示平滑的淡入淡出动画
class AnimatedTitleWidget extends StatefulWidget {
  final String title;
  final TextStyle? style;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedTitleWidget({
    super.key,
    required this.title,
    this.style,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<AnimatedTitleWidget> createState() => _AnimatedTitleWidgetState();
}

class _AnimatedTitleWidgetState extends State<AnimatedTitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String _currentTitle = '';
  String _nextTitle = '';
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    _currentTitle = widget.title;
    _controller.value = 1.0; // 初始状态为完全显示
  }

  @override
  void didUpdateWidget(AnimatedTitleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.title != widget.title && !_isAnimating) {
      _animateToNewTitle(widget.title);
    }
  }

  void _animateToNewTitle(String newTitle) {
    if (_currentTitle == newTitle) return;
    
    setState(() {
      _isAnimating = true;
      _nextTitle = newTitle;
    });

    // 淡出当前标题
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentTitle = _nextTitle;
        });
        // 淡入新标题
        _controller.forward().then((_) {
          if (mounted) {
            setState(() {
              _isAnimating = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Text(
            _currentTitle,
            style: widget.style,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

/// 带滑动效果的标题组件
/// 
/// 新标题从右侧滑入，旧标题向左侧滑出
class SlidingTitleWidget extends StatefulWidget {
  final String title;
  final TextStyle? style;
  final Duration animationDuration;
  final Curve animationCurve;

  const SlidingTitleWidget({
    super.key,
    required this.title,
    this.style,
    this.animationDuration = const Duration(milliseconds: 400),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<SlidingTitleWidget> createState() => _SlidingTitleWidgetState();
}

class _SlidingTitleWidgetState extends State<SlidingTitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String _currentTitle = '';
  String _nextTitle = '';
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // 从右侧开始
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    _currentTitle = widget.title;
    _controller.value = 1.0; // 初始状态为完全显示
  }

  @override
  void didUpdateWidget(SlidingTitleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.title != widget.title && !_isAnimating) {
      _animateToNewTitle(widget.title);
    }
  }

  void _animateToNewTitle(String newTitle) {
    if (_currentTitle == newTitle) return;
    
    setState(() {
      _isAnimating = true;
      _nextTitle = newTitle;
    });

    // 重置动画并开始新的动画
    _controller.reset();
    setState(() {
      _currentTitle = _nextTitle;
    });
    _controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                _currentTitle,
                style: widget.style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
