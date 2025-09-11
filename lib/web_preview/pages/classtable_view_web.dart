import 'package:flutter/material.dart';

/// Web 预览版：课程表（静态示意）
class ClassTableViewWeb extends StatelessWidget {
  const ClassTableViewWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('课程表（Web 预览）')),
      body: Column(children: [
        _weekHeader(context),
        const Divider(height: 1),
        Expanded(child: _grid(context)),
      ]),
    );
  }

  Widget _weekHeader(BuildContext context) {
    final weekDays = const ['一','二','三','四','五','六','日'];
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      child: Row(children: [
        const SizedBox(width: 40),
        ...List.generate(7, (i) => Expanded(child: Center(child: Text('周${weekDays[i]}', style: const TextStyle(fontWeight: FontWeight.w600))))),
      ]),
    );
  }

  Widget _grid(BuildContext context) {
    // 简化为 6 节课 × 7 天
    final rows = 6;
    final cols = 7;
    return Row(children: [
      // 左侧节次
      SizedBox(
        width: 40,
        child: Column(children: List.generate(rows, (r) => Expanded(child: Center(child: Text('${r+1}'))))),
      ),
      // 网格
      Expanded(
        child: Column(
          children: List.generate(rows, (r) => Expanded(
            child: Row(children: List.generate(cols, (c) => Expanded(
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _sampleCourse(r, c),
              ),
            ))),
          )),
        ),
      ),
    ]);
  }

  Widget _sampleCourse(int r, int c) {
    // 简单填充几门示意课程
    final map = {
      const (0, 0): ('高数', Colors.blue),
      const (1, 2): ('英语', Colors.green),
      const (2, 4): ('计网', Colors.orange),
      const (3, 1): ('数据结构', Colors.purple),
    };
    for (final entry in map.entries) {
      if (entry.key.$1 == r && entry.key.$2 == c) {
        return Center(child: Text(entry.value.$1, style: TextStyle(color: entry.value.$2)));
      }
    }
    return const SizedBox.shrink();
  }
}

