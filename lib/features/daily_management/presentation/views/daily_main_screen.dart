import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'daily_overview_page.dart';
import 'profile_view.dart';

/// 日常管理主界面
/// 
/// 使用底部导航栏切换两个页面：
/// - 总览页面：课程表和计划表
/// - 个人信息页面
class DailyMainScreen extends ConsumerStatefulWidget {
  const DailyMainScreen({super.key});

  @override
  ConsumerState<DailyMainScreen> createState() => _DailyMainScreenState();
}

class _DailyMainScreenState extends ConsumerState<DailyMainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // 避免在构建阶段触发 setState；仅通过 PageView 的 onPageChanged 同步状态
    if (_currentIndex == index) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0 ? '日常' : '个人信息',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () => context.go('/chat'),
            tooltip: '返回对话',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // 改进滑动物理效果
        children: [
          const DailyOverviewPage() // 总览页面
            .animate(target: _currentIndex == 0 ? 1 : 0)
            .fadeIn(duration: 300.ms, curve: Curves.easeInOut)
            .slideX(begin: _currentIndex == 0 ? 0 : 0.3, duration: 300.ms),
          const ProfileView() // 个人信息页面
            .animate(target: _currentIndex == 1 ? 1 : 0)
            .fadeIn(duration: 300.ms, curve: Curves.easeInOut)
            .slideX(begin: _currentIndex == 1 ? 0 : -0.3, duration: 300.ms),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.surface,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomBarBubble(
          selectedIndex: _currentIndex,
          items: [
            BottomBarItem(
              iconBuilder: (color) => Icon(
                _currentIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
                color: color,
                size: 26,
              ),
            ),
            BottomBarItem(
              iconBuilder: (color) => Icon(
                _currentIndex == 1 ? Icons.person : Icons.person_outline,
                color: color,
                size: 26,
              ),
            ),
          ],
          onSelect: (index) {
            _onTabTapped(index);
          },
        ),
      ),
    );
  }
}
