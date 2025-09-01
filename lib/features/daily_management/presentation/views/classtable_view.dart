// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:flutter/material.dart';
import 'package:ai_assistant/repository/logger.dart';
import 'package:ai_assistant/model/xidian_ids/classtable.dart';
import 'package:ai_assistant/repository/xidian_ids/classtable_session.dart';
import 'package:ai_assistant/repository/xidian_ids/ids_session.dart';
import 'login_view.dart';

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
    // 检查登录状态，只有登录成功才自动加载课程表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkLoginAndLoad();
      }
    });
  }
  
  Future<void> _checkLoginAndLoad() async {
    // 检查真正的登录状态
    log.info("[ClassTableView] Current loginState: $loginState, offline: $offline");
    
    if (loginState == IDSLoginState.success) {
      // 已登录，优先从缓存加载课程表
      log.info("User logged in, loading class table from cache first");
      await _loadClassTableFromCache();
    } else {
      // 未登录，显示登录提示
      log.info("User not logged in (loginState: $loginState), showing login prompt");
      if (mounted) {
        _showMessage("请先登录后再查看课程表");
      }
    }
  }

  /// 从缓存加载课程表，如果缓存不存在则从网络获取
  Future<void> _loadClassTableFromCache() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // 使用新的缓存管理器
      ClassTableFile classTableFile = ClassTableFile();
      ClassTableData data = await classTableFile.getClassTableWithCache();
      
      if (mounted) {
        setState(() {
          _classTableData = data;
          _isLoading = false;
        });
        log.info("[ClassTableView] Class table loaded successfully");
      }
    } catch (e) {
      log.error("[ClassTableView] Failed to load class table: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage = "获取课程表失败：$e";
        if (e.toString().contains("Offline mode")) {
          errorMessage = "网络连接异常，请检查登录状态后重试";
        }
        _showMessage(errorMessage);
      }
    }
  }

  /// 从网络强制刷新课程表
  Future<void> _loadClassTableFromNetwork({bool showSuccessMessage = true}) async {
    if (!mounted) return;
    
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // 使用新的缓存管理器强制刷新
      ClassTableFile classTableFile = ClassTableFile();
      ClassTableData data = await classTableFile.getClassTableWithCache(forceRefresh: true);

      if (mounted) {
        setState(() {
          _classTableData = data;
          _isLoading = false;
        });
        if (showSuccessMessage) {
          _showMessage("课程表刷新成功");
        }
      }
    } catch (e) {
      log.error("Failed to refresh class table from network", e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage = "刷新课程表失败：$e";
        if (e.toString().contains("Offline mode")) {
          errorMessage = "网络连接异常，请检查登录状态后重试";
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
      return Scaffold(
        appBar: AppBar(
          title: const Text("课程表"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                loginState == IDSLoginState.success 
                    ? "暂无课程表数据" 
                    : "请先登录后查看课程表",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              if (loginState == IDSLoginState.success)
                ElevatedButton(
                  onPressed: () => _loadClassTableFromNetwork(),
                  child: const Text("加载课程表"),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    ).then((result) {
                      // 登录成功后自动刷新
                      if (result == true && mounted) {
                        _checkLoginAndLoad();
                      }
                    });
                  },
                  child: const Text("前往登录"),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("课程表"),
        actions: [
          IconButton(
            onPressed: () => _loadClassTableFromNetwork(),
            icon: const Icon(Icons.refresh),
            tooltip: "刷新课程表",
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
