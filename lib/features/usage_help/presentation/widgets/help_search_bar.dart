import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/help_provider.dart';

/// 帮助搜索栏组件
class HelpSearchBar extends ConsumerWidget {
  const HelpSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: TextField(
        autofocus: true,
        controller: TextEditingController(text: searchQuery)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: searchQuery.length),
          ),
        decoration: InputDecoration(
          hintText: '搜索帮助内容...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        onSubmitted: (value) {
          // 可以在这里处理搜索提交逻辑
        },
      ),
    );
  }
}
