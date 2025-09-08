// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_assistant/repository/logger.dart';
import 'package:ai_assistant/model/xidian_ids/classtable.dart';
import 'package:ai_assistant/repository/xidian_ids/classtable_session.dart';
import 'package:ai_assistant/repository/xidian_ids/ids_session.dart';
import 'login_view.dart';
import 'class_organized_data.dart';
import 'class_card.dart';

// 从traintime_pda复制的常量
// 时间列宽度
// 顶部日期行高度

// 颜色列表
const List<MaterialColor> _colorList = [
  Colors.pink,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.amber,
];

class ClassTableView extends StatefulWidget {
  const ClassTableView({super.key});

  @override
  State<ClassTableView> createState() => _ClassTableViewState();
}

class _ClassTableViewState extends State<ClassTableView> {
  ClassTableData? _classTableData;
  bool _isLoading = false;
  int _currentWeek = 0; // 默认为0，后续会根据实际情况设置
  
  // 从traintime_pda复制的辅助方法
  double get _leftRow => 50.0;
  // 课程区域的宽度（不包括时间列）
  double get _courseAreaWidth => MediaQuery.of(context).size.width - _leftRow;
  double get _blockWidth => _courseAreaWidth / 7;
  
  // 修复高度计算 - 使用固定的可用高度
  double get _availableHeight {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = kToolbarHeight;
    final weekSelectorHeight = 56.0;
    final weekHeaderHeight = 50.0;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return screenHeight - appBarHeight - weekSelectorHeight - weekHeaderHeight - statusBarHeight - bottomPadding - 20; // 20为额外边距
  }
  
  double _blockHeight(double count) => count * _availableHeight / 61;
  
  /// 计算当前是学期的第几周（0-based）
  int get _getCurrentWeekIndex {
    if (_classTableData == null || _classTableData!.termStartDay.isEmpty) {
      return -1; // 无法确定，返回-1表示不高亮
    }
    
    try {
      DateTime termStart = DateTime.parse(_classTableData!.termStartDay);
      DateTime now = DateTime.now();
      
      // 计算从学期开始到现在的天数
      int daysDiff = now.difference(termStart).inDays;
      
      // 计算当前是第几周（0-based）
      int currentWeek = daysDiff ~/ 7;
      
      // 确保在有效范围内
      if (currentWeek < 0 || currentWeek >= _classTableData!.semesterLength) {
        return -1; // 超出学期范围，不高亮
      }
      
      return currentWeek;
    } catch (e) {
      log.error("Error calculating current week: $e");
      return -1;
    }
  }

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
        // 课程表主体 - 加入滚动容器
        Expanded(
          child: SingleChildScrollView(
            child: _buildTimeTableGrid(),
          ),
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
          // 左上角美化月份显示
          Container(
            width: 50,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 2),
                Text(
                  '${now.month}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  '月',
                  style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 星期标题
          ...List.generate(7, (index) {
            // 只有当显示的周次是当前周，且今天是对应星期时才高亮
            final isCurrentWeek = _currentWeek == _getCurrentWeekIndex;
            final isToday = index == today && isCurrentWeek;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                decoration: isToday ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ) : BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weekDays[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isToday ? Colors.white : Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: isToday ? BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ) : null,
                        child: Text(
                          '${_getDateForWeekDay(index)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.white : Theme.of(context).primaryColor,
                            fontFamily: 'monospace',
                          ),
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
    if (_classTableData == null || _classTableData!.termStartDay.isEmpty) {
      // 如果没有课程表数据，返回当前日期
      final now = DateTime.now();
      final currentWeekDay = now.weekday - 1; // 0-6
      final daysFromMonday = weekDayIndex - currentWeekDay;
      final targetDate = now.add(Duration(days: daysFromMonday));
      return targetDate.day;
    }
    
    try {
      // 根据学期开始日期和当前选中的周次计算日期
      DateTime termStart = DateTime.parse(_classTableData!.termStartDay);
      
      // 计算目标周的星期一
      DateTime targetWeekMonday = termStart.add(Duration(days: _currentWeek * 7));
      
      // 计算目标日期
      DateTime targetDate = targetWeekMonday.add(Duration(days: weekDayIndex));
      
      return targetDate.day;
    } catch (e) {
      log.error("Error calculating date for week day: $e");
      // 如果出错，回退到原来的逻辑
      final now = DateTime.now();
      final currentWeekDay = now.weekday - 1; // 0-6
      final daysFromMonday = weekDayIndex - currentWeekDay;
      final targetDate = now.add(Duration(days: daysFromMonday));
      return targetDate.day;
    }
  }

  Widget _buildTimeTableGrid() {
    return Container(
      color: Colors.grey[100],
      child: Row(
        children: [
          // 左侧时间列
          _buildTimeColumn(),
          // 课程网格 - 使用traintime_pda的Stack布局
          Expanded(
            child: _buildStackBasedCourseGrid(),
          ),
        ],
      ),
    );
  }
  
  /// 使用traintime_pda的Stack布局方式
  Widget _buildStackBasedCourseGrid() {
    List<Widget> allCourseCards = [];
    
    // 为每一天生成课程卡片
    for (int dayIndex = 1; dayIndex <= 7; dayIndex++) {
      List<ClassOrgainzedData> arrangedEvents = _getArrangement(
        weekIndex: _currentWeek, 
        dayIndex: dayIndex
      );
      
      for (var courseData in arrangedEvents) {
        allCourseCards.add(
          Positioned(
            top: _blockHeight(courseData.start),
            height: _blockHeight(courseData.stop - courseData.start),
            left: _blockWidth * (dayIndex - 1), // 移除_leftRow，课程区域从0开始
            width: _blockWidth,
            child: SizedBox(
              width: double.infinity, // 充满整个宽度
              height: double.infinity, // 充满整个高度
              child: ClassCard(detail: courseData),
            ),
          ),
        );
      }
    }
    
    return SizedBox(
      width: _courseAreaWidth, // 限制课程区域宽度
      height: _availableHeight,
      child: Stack(
        children: [
          // 背景网格
          Row(
            children: List.generate(7, (dayIndex) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey[200]!, 
                        width: dayIndex == 6 ? 0 : 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: _buildBackgroundTimeBlocks(),
                  ),
                ),
              );
            }),
          ),
          // 课程卡片
          ...allCourseCards,
        ],
      ),
    );
  }

  Widget _buildTimeColumn() {
    // 按照traintime_pda的设计，时间列也需要对应时间块系统
    return Container(
      width: 50,
      height: _availableHeight, // 固定高度
      color: Theme.of(context).cardColor,
      child: Column(
        children: _buildTimeSlots(),
      ),
    );
  }
  
  List<Widget> _buildTimeSlots() {
    List<Widget> timeSlots = [];
    
    // 按照traintime_pda的时间块系统构建时间列
    for (int index = 0; index < 13; index++) {
      double blockCount = (index != 4 && index != 9) ? 5 : 3; // 休息时间是3个块，课程时间是5个块
      
      late int courseNumber;
      late String timeText;
      
      if ([0, 1, 2, 3].contains(index)) {
        courseNumber = index + 1; // 1-4节
        timeText = _getCourseTimeText(courseNumber);
      } else if (index == 4) {
        courseNumber = -1; // 午休
        timeText = '午休';
      } else if ([5, 6, 7, 8].contains(index)) {
        courseNumber = index; // 5-8节
        timeText = _getCourseTimeText(courseNumber);
      } else if (index == 9) {
        courseNumber = -2; // 晚休
        timeText = '晚休';
      } else {
        courseNumber = index - 1; // 9-11节
        timeText = _getCourseTimeText(courseNumber);
      }
      
      timeSlots.add(
        Expanded(
          flex: blockCount.toInt(),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _buildTimeSlotContent(courseNumber, timeText),
            ),
          ),
        ),
      );
    }
    
    return timeSlots;
  }
  
  Widget _buildTimeSlotContent(int courseNumber, String timeText) {
    if (courseNumber == -1 || courseNumber == -2) {
      // 休息时间
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            timeText,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      // 正常课程时间 - 美化时钟样式
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '$courseNumber',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (timeText.isNotEmpty) ...[
                const SizedBox(height: 1),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 6,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }
  
  String _getCourseTimeText(int courseNumber) {
    // 返回课程时间文本
    const times = [
      "", // 0占位
      "08:30\n09:15", // 1
      "09:20\n10:05", // 2
      "10:25\n11:10", // 3
      "11:15\n12:00", // 4
      "14:00\n14:45", // 5
      "14:50\n15:35", // 6
      "15:55\n16:40", // 7
      "16:45\n17:30", // 8
      "19:00\n19:45", // 9
      "19:55\n20:35", // 10
      "20:40\n21:25", // 11
    ];
    
    if (courseNumber > 0 && courseNumber < times.length) {
      return times[courseNumber];
    }
    return '';
  }
  
  /// 从 traintime_pda 复制的核心方法
  /// [weekIndex] start from 0 while [dayIndex] start from 1
  List<ClassOrgainzedData> _getArrangement({
    required int weekIndex,
    required int dayIndex,
  }) {
    if (_classTableData == null) return [];
    
    /// Fetch all class in this range.
    List<ClassOrgainzedData> events = [];

    for (final i in _classTableData!.timeArrangement) {
      if (i.weekList.length > weekIndex &&
          i.weekList[weekIndex] &&
          i.day == dayIndex) {
        ClassDetail classDetail = _classTableData!.getClassDetail(i);
        events.add(
          ClassOrgainzedData.fromTimeArrangement(
            i,
            _colorList[_classTableData!.timeArrangement.indexOf(i) % _colorList.length],
            classDetail.name,
          ),
        );
      }
    }

    /// Sort it with the ascending order of start time.
    events.sort((a, b) => a.start.compareTo(b.start));

    /// The arrangement to use - 处理重叠课程
    List<ClassOrgainzedData> arrangedEvents = [];

    for (final event in events) {
      final startTime = event.start;
      final endTime = event.stop;

      var eventIndex = -1;
      final arrangeEventLen = arrangedEvents.length;

      for (var i = 0; i < arrangeEventLen; i++) {
        final arrangedEventStart = arrangedEvents[i].start;
        final arrangedEventEnd = arrangedEvents[i].stop;

        if (_checkIsOverlapping(
          arrangedEventStart,
          arrangedEventEnd,
          startTime,
          endTime,
        )) {
          eventIndex = i;
          break;
        }
      }

      if (eventIndex == -1) {
        arrangedEvents.add(event);
      } else {
        final arrangedEventData = arrangedEvents[eventIndex];

        final arrangedEventStart = arrangedEventData.start;
        final arrangedEventEnd = arrangedEventData.stop;

        final startDuration = math.min(startTime, arrangedEventStart);
        final endDuration = math.max(endTime, arrangedEventEnd);

        bool shouldNew =
            (event.stop - event.start) >=
            (arrangedEventData.stop - arrangedEventData.start);

        final top = startDuration;
        final bottom = endDuration;

        final newEvent = ClassOrgainzedData(
          start: top,
          stop: bottom,
          data: [...arrangedEventData.data, ...event.data],
          color: shouldNew ? event.color : arrangedEventData.color,
          name: shouldNew ? event.name : arrangedEventData.name,
          place: shouldNew ? event.place : arrangedEventData.place,
        );

        arrangedEvents[eventIndex] = newEvent;
      }
    }

    return arrangedEvents;
  }
  
  bool _checkIsOverlapping(
    double eStart1,
    double eEnd1,
    double eStart2,
    double eEnd2,
  ) =>
      (eStart1 >= eStart2 && eStart1 < eEnd2) ||
      (eEnd1 > eStart2 && eEnd1 <= eEnd2) ||
      (eStart2 >= eStart1 && eStart2 < eEnd1) ||
      (eEnd2 > eStart1 && eEnd2 <= eEnd1);


  
  List<Widget> _buildBackgroundTimeBlocks() {
    List<Widget> blocks = [];
    
    // 按照时间列的结构构建背景块
    for (int index = 0; index < 13; index++) {
      int blockCount = (index != 4 && index != 9) ? 5 : 3;
      
      blocks.add(
        Expanded(
          flex: blockCount,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!, 
                  width: index == 3 || index == 8 || index == 12 ? 1.0 : 0.5, // 大课间休息粗线
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return blocks;
  }

  





}
