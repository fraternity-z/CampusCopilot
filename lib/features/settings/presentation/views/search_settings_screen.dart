import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/search_settings_section.dart';

/// AI 搜索设置页面（与常规设置并列）
class SearchSettingsScreen extends ConsumerWidget {
  const SearchSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 搜索设置'), elevation: 0),
      body: Container(
        // 使用主题背景，适配深/浅色
        color: Theme.of(context).colorScheme.surface,
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SearchSettingsSection(),
          ),
        ),
      ),
    );
  }
}
