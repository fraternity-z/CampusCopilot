import 'package:flutter/material.dart';
import 'daily_overview_page_web.dart';

/// Web 预览版：日常管理主界面
/// 不依赖登录/网络/数据库，仅展示页面结构与交互。
class DailyMainScreenWeb extends StatefulWidget {
  const DailyMainScreenWeb({super.key});

  @override
  State<DailyMainScreenWeb> createState() => _DailyMainScreenWebState();
}

class _DailyMainScreenWebState extends State<DailyMainScreenWeb> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? '日常' : '个人信息'),
        centerTitle: true,
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: const [
          DailyOverviewPageWeb(),
          _ProfileViewWeb(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          if (_currentIndex != i) _controller.jumpToPage(i);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: '总览'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '个人信息'),
        ],
      ),
    );
  }
}

class _ProfileViewWeb extends StatelessWidget {
  const _ProfileViewWeb();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48, color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 12),
                Text('个人信息（Web 预览）', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '此页面为预览版，不包含登录/注销等功能。',
                  style: Theme.of(context).textTheme.bodyMedium,
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

