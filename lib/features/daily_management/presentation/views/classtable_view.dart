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
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        // 根据滑动方向切换周次
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0) {
            // 向右滑动，显示上一周
            _previousWeek();
          } else if (details.primaryVelocity! < 0) {
            // 向左滑动，显示下一周
            _nextWeek();
          }
        }
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左箭头按钮
            IconButton(
              onPressed: _previousWeek,
              icon: const Icon(Icons.chevron_left),
              iconSize: 28,
              color: _currentWeek > 0 ? Theme.of(context).primaryColor : Colors.grey,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
            // 居中显示当前周次 - 下拉按钮样式
            Expanded(
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showWeekPicker(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "第${_currentWeek + 1}周",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 右箭头按钮
            IconButton(
              onPressed: _nextWeek,
              icon: const Icon(Icons.chevron_right),
              iconSize: 28,
              color: _currentWeek < _classTableData!.semesterLength - 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
      ),
    );
  }

  void _previousWeek() {
    if (_currentWeek > 0) {
      setState(() {
        _currentWeek--;
      });
    }
  }

  void _nextWeek() {
    if (_currentWeek < _classTableData!.semesterLength - 1) {
      setState(() {
        _currentWeek++;
      });
    }
  }

  void _showWeekPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("选择周次"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // 增加列数从4到6
                childAspectRatio: 1.0, // 改为正方形
                crossAxisSpacing: 6, // 减少间距
                mainAxisSpacing: 6,
              ),
              itemCount: _classTableData!.semesterLength,
              itemBuilder: (context, index) {
                return Material(
                  color: _currentWeek == index
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        _currentWeek = index;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: _currentWeek == index
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: _currentWeek == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("取消"),
            ),
          ],
        );
      },
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
