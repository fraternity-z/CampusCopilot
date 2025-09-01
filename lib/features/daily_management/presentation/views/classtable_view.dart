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
    return Column(
      children: [
        // 顶部星期行
        _buildWeekHeader(),
        // 课程表主体
        Expanded(
          child: _buildTimeTableGrid(),
        ),
      ],
    );
  }

  Widget _buildWeekHeader() {
    const weekDays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final now = DateTime.now();
    final today = now.weekday - 1; // DateTime.weekday 返回1-7，我们需要0-6
    
    return Container(
      height: 50,
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          // 左上角空白区域
          SizedBox(
            width: 50,
            child: Center(
              child: Text(
                '${now.month}月',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          // 星期标题
          ...List.generate(7, (index) {
            final isToday = index == today;
            return Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: isToday ? BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weekDays[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isToday ? Colors.white : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${_getDateForWeekDay(index)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  int _getDateForWeekDay(int weekDayIndex) {
    final now = DateTime.now();
    final currentWeekDay = now.weekday - 1; // 0-6
    final daysFromMonday = weekDayIndex - currentWeekDay;
    final targetDate = now.add(Duration(days: daysFromMonday));
    return targetDate.day;
  }

  Widget _buildTimeTableGrid() {
    return Container(
      color: Colors.grey[100],
      child: Row(
        children: [
          // 左侧时间列
          _buildTimeColumn(),
          // 课程网格
          Expanded(
            child: _buildCoursesGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn() {
    return Container(
      width: 50,
      color: Theme.of(context).cardColor,
      child: Column(
        children: List.generate(11, (period) { // 改为11节课
          return Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${period + 1}',
                      style: const TextStyle(
                        fontSize: 12, // 减小字体
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_getTimeRange(period).isNotEmpty && !_getTimeRange(period).contains('休')) // 只在有时间且非休息时显示
                      Text(
                        _getTimeRange(period).replaceAll('\n', ' '), // 改为单行显示
                        style: TextStyle(
                          fontSize: 7, // 更小的字体
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCoursesGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7天
        childAspectRatio: 0.7,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: 7 * 11, // 7天 * 11节课
      itemBuilder: (context, index) {
        int day = index % 7;
        int period = index ~/ 7;
        
        List<TimeArrangement> classes = _getClassesForDayAndPeriod(day, period);
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!, width: 0.5),
          ),
          child: classes.isEmpty 
            ? const SizedBox() 
            : _buildClassCard(classes.first),
        );
      },
    );
  }

  Widget _buildClassCard(TimeArrangement arrangement) {
    ClassDetail classDetail = _classTableData!.getClassDetail(arrangement);
    
    // 根据课程名称生成颜色
    Color cardColor = _getClassColor(classDetail.name);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据可用空间调整字体大小
        double fontSize = constraints.maxHeight > 60 ? 10 : 8;
        double classroomFontSize = constraints.maxHeight > 60 ? 8 : 7;
        
        return Container(
          margin: const EdgeInsets.all(1),
          padding: EdgeInsets.all(constraints.maxHeight > 60 ? 4 : 2),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  classDetail.name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1, // 减小行高
                  ),
                  maxLines: constraints.maxHeight > 60 ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (arrangement.classroom != null && constraints.maxHeight > 40) ...[
                const SizedBox(height: 1),
                Flexible(
                  child: Text(
                    arrangement.classroom!,
                    style: TextStyle(
                      fontSize: classroomFontSize,
                      color: Colors.white70,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getTimeRange(int period) {
    // 根据 classtable.dart 中的时间定义，每两个时间为一节课
    // 索引: 0-1=第1节课, 2-3=第2节课, 4-5=第3节课, 6-7=第4节课
    // 8-9=第5节课, 10-11=第6节课, 12-13=第7节课, 14-15=第8节课
    // 16-17=第9节课, 18-19=第10节课, 20-21=第11节课
    const times = [
      "08:30", "09:15", "09:20", "10:05", "10:25", "11:10", "11:15", "12:00",
      "14:00", "14:45", "14:50", "15:35", "15:55", "16:40", "16:45", "17:30",
      "19:00", "19:45", "19:55", "20:35", "20:40", "21:25",
    ];
    
    if (period < 0 || period >= 11) return ''; // 只有11节课
    
    int startIndex = period * 2;
    if (startIndex >= times.length) return '';
    
    return times[startIndex];
  }

  Color _getClassColor(String className) {
    // 根据课程名称哈希生成颜色
    final colors = [
      Colors.pink[300]!,
      Colors.blue[300]!,
      Colors.green[300]!,
      Colors.orange[300]!,
      Colors.purple[300]!,
      Colors.teal[300]!,
      Colors.indigo[300]!,
      Colors.red[300]!,
      Colors.cyan[300]!,
      Colors.amber[300]!,
    ];
    
    int hash = className.hashCode;
    return colors[hash.abs() % colors.length];
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

}
