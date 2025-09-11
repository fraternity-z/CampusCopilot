import 'package:flutter/material.dart';

import 'pages/chat_screen_web.dart';
import 'pages/daily_main_screen_web.dart';
import 'pages/settings_home_web.dart';
import 'pages/data_management_web.dart';

/// Web 预览版：主壳（模拟原项目的侧边导航与页面切换）
class MainShellWeb extends StatefulWidget {
  const MainShellWeb({super.key});

  @override
  State<MainShellWeb> createState() => _MainShellWebState();
}

class _MainShellWebState extends State<MainShellWeb> {
  int _index = 0; // 0: chat, 1: daily, 2: settings, 3: data
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ChatScreenWeb(
        onOpenDaily: () => setState(() => _index = 1),
        onOpenSettings: () => setState(() => _index = 2),
      ),
      DailyMainScreenWeb(onOpenChat: () => setState(() => _index = 0)),
      const SettingsHomeWeb(),
      const DataManagementWeb(),
    ];

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: IndexedStack(index: _index, children: pages)),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final items = [
      _NavItem(Icons.chat_bubble_outline, Icons.chat_bubble, '对话'),
      _NavItem(Icons.today_outlined, Icons.today, '日常'),
      _NavItem(Icons.settings_outlined, Icons.settings, '设置'),
      _NavItem(Icons.storage_outlined, Icons.storage, '数据'),
    ];

    final width = _sidebarCollapsed ? 72.0 : 260.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // 头部
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                    ]),
                  ),
                ),
                if (!_sidebarCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('AnywhereChat',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
                IconButton(
                  tooltip: _sidebarCollapsed ? '展开侧边栏' : '折叠侧边栏',
                  icon: Icon(_sidebarCollapsed ? Icons.menu : Icons.menu_open),
                  onPressed: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
                ),
              ],
            ),
          ),

          // 导航项
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => _sideItem(context, items[i], i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(BuildContext context, _NavItem item, int i) {
    final selected = i == _index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: selected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _index = i),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(selected ? item.activeIcon : item.icon,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                if (!_sidebarCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurface)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  _NavItem(this.icon, this.activeIcon, this.label);
}
