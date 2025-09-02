// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

import 'package:ai_assistant/model/xidian_ids/classtable.dart';
import 'package:ai_assistant/repository/xidian_ids/classtable_session.dart';

class ClassStatus {
  final String courseName;
  final String? classroom;
  final String? teacher;
  final String timeRange;
  
  ClassStatus({
    required this.courseName,
    this.classroom,
    this.teacher,
    required this.timeRange,
  });
}

class DailyClassStatus {
  final ClassStatus? currentClass;
  final ClassStatus? nextClass;
  final bool hasClassToday;
  final String statusText;
  
  DailyClassStatus({
    this.currentClass,
    this.nextClass,
    required this.hasClassToday,
    required this.statusText,
  });
  
  static DailyClassStatus empty() {
    return DailyClassStatus(
      hasClassToday: false,
      statusText: '今日暂无课程安排',
    );
  }
}

/// 课程状态计算服务
/// 
/// 提供当前课程状态的计算功能，支持伪实时更新
class ClassStatusService {
  /// 课程时间对照表 - 与classtable_view.dart保持一致
  static const List<String> _courseTimes = [
    "", // 0占位
    "08:30-09:15", // 1
    "09:20-10:05", // 2
    "10:25-11:10", // 3
    "11:15-12:00", // 4
    "14:00-14:45", // 5
    "14:50-15:35", // 6
    "15:55-16:40", // 7
    "16:45-17:30", // 8
    "19:00-19:45", // 9
    "19:55-20:35", // 10
    "20:40-21:25", // 11
  ];
  
  /// 计算当天课程状态
  /// 
  /// 根据当前时间和课程表数据计算当前课程和下节课信息
  static Future<DailyClassStatus> calculateTodayStatus() async {
    try {
      ClassTableFile classTableFile = ClassTableFile();
      ClassTableData data = await classTableFile.getClassTableWithCache();
      
      return _calculateStatusFromData(data);
    } catch (e) {
      return DailyClassStatus.empty();
    }
  }
  
  /// 从课程表数据计算状态
  static DailyClassStatus _calculateStatusFromData(ClassTableData data) {
    final now = DateTime.now();
    final currentWeek = _getCurrentWeekIndex(data, now);
    final currentDay = now.weekday; // 1-7 (Monday-Sunday)
    
    // 如果无法确定当前周或者不在学期范围内，返回空状态
    if (currentWeek < 0 || currentWeek >= data.semesterLength) {
      return DailyClassStatus.empty();
    }
    
    // 获取今天的所有课程
    List<_CourseInfo> todayCourses = _getTodayCourses(data, currentWeek, currentDay);
    
    if (todayCourses.isEmpty) {
      return DailyClassStatus.empty();
    }
    
    // 按开始时间排序
    todayCourses.sort((a, b) => a.startPeriod.compareTo(b.startPeriod));
    
    // 计算当前时间对应的课程节次
    int currentPeriod = _getCurrentPeriod(now);
    
    ClassStatus? currentClass;
    ClassStatus? nextClass;
    
    // 查找当前课程和下节课
    for (int i = 0; i < todayCourses.length; i++) {
      final course = todayCourses[i];
      
      // 判断是否为当前课程
      if (currentPeriod > 0 && currentPeriod >= course.startPeriod && currentPeriod <= course.endPeriod) {
        currentClass = ClassStatus(
          courseName: course.name,
          classroom: course.classroom,
          teacher: course.teacher,
          timeRange: _getTimeRangeText(course.startPeriod, course.endPeriod),
        );
      }
    }
    
    // 查找下节课 - 分情况处理
    if (currentPeriod == -999) {
      // 当天课程全部结束，尝试找明天第一节课
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowWeek = _getCurrentWeekIndex(data, tomorrow);
      final tomorrowDay = tomorrow.weekday;
      
      if (tomorrowWeek >= 0 && tomorrowWeek < data.semesterLength) {
        List<_CourseInfo> tomorrowCourses = _getTodayCourses(data, tomorrowWeek, tomorrowDay);
        if (tomorrowCourses.isNotEmpty) {
          tomorrowCourses.sort((a, b) => a.startPeriod.compareTo(b.startPeriod));
          final firstTomorrowClass = tomorrowCourses.first;
          nextClass = ClassStatus(
            courseName: "${firstTomorrowClass.name} (明日)",
            classroom: firstTomorrowClass.classroom,
            teacher: firstTomorrowClass.teacher,
            timeRange: _getTimeRangeText(firstTomorrowClass.startPeriod, firstTomorrowClass.endPeriod),
          );
        }
      }
    } else {
      // 查找今天剩余的课程
      for (final course in todayCourses) {
        // 如果当前时间早于课程开始时间，或者是课间时间且课程还未开始
        bool isNextClass = false;
        
        if (currentPeriod == -1) {
          // 早于第一节课，第一节课就是下节课
          isNextClass = true;
        } else if (currentPeriod > 0) {
          // 正在上课，查找下一个课程
          isNextClass = course.startPeriod > currentPeriod;
        } else if (currentPeriod < 0 && currentPeriod != -999) {
          // 在课间时间，查找下一个课程
          int lastFinishedPeriod = -currentPeriod;
          isNextClass = course.startPeriod > lastFinishedPeriod;
        }
        
        if (isNextClass) {
          nextClass = ClassStatus(
            courseName: course.name,
            classroom: course.classroom,
            teacher: course.teacher,
            timeRange: _getTimeRangeText(course.startPeriod, course.endPeriod),
          );
          break; // 找到第一个未来的课程就退出
        }
      }
    }
    
    String statusText = _generateStatusText(currentClass, nextClass, todayCourses.isNotEmpty);
    
    return DailyClassStatus(
      currentClass: currentClass,
      nextClass: nextClass,
      hasClassToday: todayCourses.isNotEmpty,
      statusText: statusText,
    );
  }
  
  /// 获取今天的所有课程
  static List<_CourseInfo> _getTodayCourses(ClassTableData data, int currentWeek, int currentDay) {
    List<_CourseInfo> courses = [];
    
    for (final arrangement in data.timeArrangement) {
      // 检查是否在当前周且是今天
      if (arrangement.weekList.length > currentWeek &&
          arrangement.weekList[currentWeek] &&
          arrangement.day == currentDay) {
        
        ClassDetail classDetail = data.getClassDetail(arrangement);
        courses.add(_CourseInfo(
          name: classDetail.name,
          teacher: arrangement.teacher,
          classroom: arrangement.classroom,
          startPeriod: arrangement.start,
          endPeriod: arrangement.stop,
        ));
      }
    }
    
    return courses;
  }
  
  /// 计算当前时间对应的课程节次
  /// 返回值：
  /// - 正数(1-11)：表示正在上第几节课
  /// - 负数：表示不在上课时间，但可以用于判断下节课
  /// - -1：早于第1节课开始时间
  /// - -999：晚于最后一节课结束时间
  static int _getCurrentPeriod(DateTime now) {
    final hour = now.hour;
    final minute = now.minute;
    final currentMinutes = hour * 60 + minute;
    
    // 定义各节课的时间范围（分钟）
    final periodTimes = [
      null, // 0占位
      [8 * 60 + 30, 9 * 60 + 15], // 1: 08:30-09:15
      [9 * 60 + 20, 10 * 60 + 5], // 2: 09:20-10:05
      [10 * 60 + 25, 11 * 60 + 10], // 3: 10:25-11:10
      [11 * 60 + 15, 12 * 60], // 4: 11:15-12:00
      [14 * 60, 14 * 60 + 45], // 5: 14:00-14:45
      [14 * 60 + 50, 15 * 60 + 35], // 6: 14:50-15:35
      [15 * 60 + 55, 16 * 60 + 40], // 7: 15:55-16:40
      [16 * 60 + 45, 17 * 60 + 30], // 8: 16:45-17:30
      [19 * 60, 19 * 60 + 45], // 9: 19:00-19:45
      [19 * 60 + 55, 20 * 60 + 35], // 10: 19:55-20:35
      [20 * 60 + 40, 21 * 60 + 25], // 11: 20:40-21:25
    ];
    
    // 检查是否正在上课
    for (int i = 1; i < periodTimes.length; i++) {
      final timeRange = periodTimes[i];
      if (timeRange != null && 
          currentMinutes >= timeRange[0] && 
          currentMinutes <= timeRange[1]) {
        return i; // 正在上第i节课
      }
    }
    
    // 不在上课时间，判断时间位置
    // 如果早于第1节课开始时间
    if (currentMinutes < periodTimes[1]![0]) {
      return -1;
    }
    
    // 如果晚于最后一节课结束时间
    if (currentMinutes > periodTimes[11]![1]) {
      return -999;
    }
    
    // 在课间时间，返回刚刚结束的课程节次的负数
    for (int i = 1; i < periodTimes.length; i++) {
      final timeRange = periodTimes[i];
      if (timeRange != null && currentMinutes > timeRange[1]) {
        // 检查是否在下一节课开始之前
        if (i + 1 < periodTimes.length) {
          final nextTimeRange = periodTimes[i + 1];
          if (nextTimeRange != null && currentMinutes < nextTimeRange[0]) {
            return -i; // 在第i节课和第i+1节课之间的课间时间
          }
        }
      }
    }
    
    return -1; // 默认返回
  }
  
  /// 获取时间范围文本
  static String _getTimeRangeText(int startPeriod, int endPeriod) {
    if (startPeriod == endPeriod) {
      return "第$startPeriod节 ${_courseTimes[startPeriod]}";
    } else {
      final startTime = _courseTimes[startPeriod].split('-')[0];
      final endTime = _courseTimes[endPeriod].split('-')[1];
      return "第$startPeriod-$endPeriod节 $startTime-$endTime";
    }
  }
  
  /// 生成状态文本
  static String _generateStatusText(ClassStatus? currentClass, ClassStatus? nextClass, bool hasClassToday) {
    if (currentClass != null) {
      return "正在上课：${currentClass.courseName}";
    } else if (nextClass != null) {
      if (nextClass.courseName.contains("(明日)")) {
        return "今日课程已结束，明日：${nextClass.courseName.replaceAll(" (明日)", "")}";
      } else {
        return "下节课：${nextClass.courseName}";
      }
    } else if (hasClassToday) {
      return "今日课程已结束";
    } else {
      return "今日暂无课程安排";
    }
  }
  
  /// 计算当前是学期的第几周（0-based）
  static int _getCurrentWeekIndex(ClassTableData data, DateTime now) {
    if (data.termStartDay.isEmpty) {
      return -1; // 无法确定，返回-1表示不高亮
    }
    
    try {
      DateTime termStart = DateTime.parse(data.termStartDay);
      
      // 计算从学期开始到现在的天数
      int daysDiff = now.difference(termStart).inDays;
      
      // 计算当前是第几周（0-based）
      int currentWeek = daysDiff ~/ 7;
      
      // 确保在有效范围内
      if (currentWeek < 0 || currentWeek >= data.semesterLength) {
        return -1; // 超出学期范围
      }
      
      return currentWeek;
    } catch (e) {
      return -1;
    }
  }
}

/// 内部课程信息类
class _CourseInfo {
  final String name;
  final String? teacher;
  final String? classroom;
  final int startPeriod;
  final int endPeriod;
  
  _CourseInfo({
    required this.name,
    this.teacher,
    this.classroom,
    required this.startPeriod,
    required this.endPeriod,
  });
}