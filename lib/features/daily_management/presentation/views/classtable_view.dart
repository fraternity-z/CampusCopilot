// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:ai_assistant/repository/logger.dart';
import 'package:ai_assistant/model/xidian_ids/classtable.dart';
import 'package:ai_assistant/repository/xidian_ids/classtable_session.dart';
import 'package:ai_assistant/repository/preference.dart' as preference;

class ClassTableView extends StatefulWidget {
  const ClassTableView({super.key});

  @override
  State<ClassTableView> createState() => _ClassTableViewState();
}

class _ClassTableViewState extends State<ClassTableView> {
  ClassTableData? _classTableData;
  bool _isLoading = false;
  int _currentWeek = 1;

  @override
  void initState() {
    super.initState();
    // 延迟加载，避免在initState中使用context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadClassTable();
      }
    });
  }

  Future<void> _loadClassTable() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      ClassTableFile classTableFile = ClassTableFile();
      // 根据用户类型选择获取方式
      bool isPostGraduate = preference.getBool(preference.Preference.role);
      ClassTableData data;
      
      if (isPostGraduate) {
        log.info("Loading class table for postgraduate");
        data = await classTableFile.getYjspt();
      } else {
        log.info("Loading class table for undergraduate");
        data = await classTableFile.getEhall();
      }

      if (mounted) {
        setState(() {
          _classTableData = data;
          _isLoading = false;
        });
        _showMessage("课程表获取成功");
      }
    } catch (e) {
      log.error("Failed to load class table", e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage = "获取课程表失败：$e";
        if (e.toString().contains("Offline mode")) {
          errorMessage = "网络连接异常，请检查登录状态后重试";
        } else if (e.toString().contains("request cancelled")) {
          errorMessage = "请求被取消，请重新登录后重试";
        }
        _showMessage(errorMessage);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_classTableData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("暂无课程表数据"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadClassTable,
              child: const Text("重新加载"),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("课程表"),
        actions: [
          IconButton(
            onPressed: _loadClassTable,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // 周选择器
          _buildWeekSelector(),
          // 课程表主体
          Expanded(
            child: _buildClassTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _classTableData!.semesterLength,
        itemBuilder: (context, index) {
          return Container(
            width: 50,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentWeek == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                foregroundColor: _currentWeek == index
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _currentWeek = index;
                });
              },
              child: Text("${index + 1}"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClassTable() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7天
        childAspectRatio: 0.8,
      ),
      itemCount: 7 * 12, // 7天 * 12节课
      itemBuilder: (context, index) {
        int day = index % 7;
        int period = index ~/ 7;

        List<TimeArrangement> classes = _getClassesForDayAndPeriod(day, period);

        return Card(
          margin: const EdgeInsets.all(2),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDayName(day),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${period + 1}",
                  style: const TextStyle(fontSize: 10),
                ),
                if (classes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, classIndex) {
                        TimeArrangement arrangement = classes[classIndex];
                        ClassDetail classDetail = _classTableData!.getClassDetail(arrangement);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                classDetail.name,
                                style: const TextStyle(fontSize: 10),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (arrangement.classroom != null)
                                Text(
                                  arrangement.classroom!,
                                  style: const TextStyle(fontSize: 8),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<TimeArrangement> _getClassesForDayAndPeriod(int day, int period) {
    if (_classTableData == null) return [];

    return _classTableData!.timeArrangement.where((arrangement) {
      return arrangement.day == day &&
             arrangement.start <= period &&
             arrangement.stop > period &&
             arrangement.weekList[_currentWeek];
    }).toList();
  }

  String _getDayName(int day) {
    const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return days[day];
  }
}
