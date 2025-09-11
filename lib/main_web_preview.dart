import 'package:flutter/material.dart';

import 'web_preview/web_shell.dart';
import 'web_preview/pages/daily_main_screen_web.dart';
import 'web_preview/pages/daily_overview_page_web.dart';
import 'web_preview/pages/plan_list_page_web.dart';
import 'web_preview/pages/create_plan_page_web.dart';
import 'web_preview/pages/classtable_view_web.dart';
import 'web_preview/pages/chat_screen_web.dart';
import 'web_preview/pages/settings_tab_web.dart';
import 'web_preview/pages/data_management_web.dart';
import 'web_preview/pages/markdown_preview_web.dart';
import 'web_preview/pages/model_selector_dialog_web.dart';
import 'web_preview/pages/chat_action_menu_web.dart';
import 'web_preview/pages/chart_builder_dialog_web.dart';
import 'web_preview/pages/thinking_chain_preview_web.dart';
import 'web_preview/pages/streaming_message_preview_web.dart';
import 'features/settings/presentation/views/about_screen.dart';

/// 独立的 Web 预览入口
/// 使用“页面橱窗（gallery）”展示项目主要页面的 Web 兼容版。
void main() => runApp(const _WebPreviewApp());

class _WebPreviewApp extends StatelessWidget {
  const _WebPreviewApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Web 预览',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // 默认直接进入模拟的主壳，保持与原项目“侧边栏+内容区”的切换方式一致
      home: const MainShellWeb(),
      // 仍保留橱窗页的路由入口，便于查看单页演示
      routes: {
        '/gallery': (_) => const _GalleryHome(),
      },
    );
  }
}

class _GalleryHome extends StatelessWidget {
  const _GalleryHome();

  @override
  Widget build(BuildContext context) {
    final items = <_GalleryItem>[
      _GalleryItem('聊天（Web 预览）', const ChatScreenWeb()),
      _GalleryItem('设置（Web 预览）', const SettingsTabWeb()),
      _GalleryItem('日常管理（主界面）', const DailyMainScreenWeb()),
      _GalleryItem('日常总览', const DailyOverviewPageWeb()),
      _GalleryItem('计划列表', const PlanListPageWeb()),
      _GalleryItem('创建计划', const CreatePlanPageWeb()),
      _GalleryItem('课程表', const ClassTableViewWeb()),
      _GalleryItem('数据管理（Web 预览）', const DataManagementWeb()),
      _GalleryItem('Markdown 渲染（Web 预览）', const MarkdownPreviewWeb()),
      _GalleryItem('模型选择对话框（Web 预览）', const ModelSelectorDialogWebPage()),
      _GalleryItem('聊天操作菜单（Web 预览）', const ChatActionMenuWebPage()),
      _GalleryItem('图表构建器（Web 预览）', const ChartBuilderDialogWebPage()),
      _GalleryItem('思维链预览（Web）', const ThinkingChainPreviewWeb()),
      _GalleryItem('流式消息预览（Web）', const StreamingMessagePreviewWeb()),
      _GalleryItem('关于（原页面）', const AboutScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('页面橱窗（Web 预览）')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => item.page),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GalleryItem {
  final String title;
  final Widget page;
  const _GalleryItem(this.title, this.page);
}
