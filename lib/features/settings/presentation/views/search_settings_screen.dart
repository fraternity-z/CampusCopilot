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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          ),
        ),
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
