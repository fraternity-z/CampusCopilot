import 'package:flutter/material.dart';

import 'pages/chat_screen_web.dart';
import 'pages/daily_main_screen_web.dart';
import 'pages/settings_home_web.dart';
import 'pages/data_management_web.dart';
import 'side_panel_web.dart';

/// Web 预览版：主壳（顶部工具栏 + 可呼出侧边栏）
class MainShellWeb extends StatefulWidget {
  const MainShellWeb({super.key});

  @override
  State<MainShellWeb> createState() => _MainShellWebState();
}

class _MainShellWebState extends State<MainShellWeb> {
  int _index = 0; // 0: chat, 1: daily, 2: settings, 3: data
  bool _sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ChatScreenWeb(
        onToggleSidebar: () => setState(() => _sidebarOpen = true),
        onOpenDaily: () => setState(() => _index = 1),
        onOpenSettings: () => setState(() => _index = 2),
      ),
      DailyMainScreenWeb(onOpenChat: () => setState(() => _index = 0)),
      const SettingsHomeWeb(),
      const DataManagementWeb(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 主内容
          Positioned.fill(
            child: IndexedStack(index: _index, children: pages),
          ),
          // 侧边遮罩 + 面板
          if (_sidebarOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _sidebarOpen = false),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 360,
              child: SidePanelWeb(
                onClose: () => setState(() => _sidebarOpen = false),
                onNavigate: (idx) {
                  setState(() {
                    _sidebarOpen = false;
                    _index = idx; // 0: chat, 1: daily, 2: settings, 3: data
                  });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
