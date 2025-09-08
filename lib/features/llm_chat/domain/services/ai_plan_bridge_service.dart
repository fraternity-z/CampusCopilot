import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tools/daily_management_tools.dart';
import '../../../daily_management/domain/entities/plan_entity.dart';
import '../../../daily_management/domain/repositories/plan_repository.dart';

/// AI计划桥接服务
/// 
/// 处理AI函数调用与计划管理系统之间的交互，负责：
/// 1. 解析AI函数调用参数
/// 2. 调用相应的业务逻辑
/// 3. 格式化返回结果
class AIPlanBridgeService {
  final PlanRepository _planRepository;

  AIPlanBridgeService(this._planRepository, Ref ref);

  /// 处理AI函数调用
  Future<FunctionCallResult> handleFunctionCall(
    String functionName,
    Map<String, dynamic> arguments,
  ) async {
    try {
      // 验证函数名称
      if (!DailyManagementTools.isValidFunctionName(functionName)) {
        return FunctionCallResult.failure(
          error: '不支持的函数: $functionName'
        );
      }

      debugPrint('🤖 AI函数调用: $functionName');
      debugPrint('📋 调用参数: $arguments');

      // 根据函数名称路由到具体处理方法
      switch (functionName) {
        case 'read_course_schedule':
          return await _handleReadCourseSchedule(arguments);
        case 'create_study_plan':
          return await _handleCreateStudyPlan(arguments);
        case 'update_study_plan':
          return await _handleUpdateStudyPlan(arguments);
        case 'delete_study_plan':
          return await _handleDeleteStudyPlan(arguments);
        case 'get_study_plans':
          return await _handleGetStudyPlans(arguments);
        case 'analyze_course_workload':
          return await _handleAnalyzeCourseWorkload(arguments);
        default:
          return FunctionCallResult.failure(
            error: '未实现的函数: $functionName'
          );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ AI函数调用失败: $functionName');
      debugPrint('错误详情: $e');
      debugPrint('堆栈跟踪: $stackTrace');
      
      return FunctionCallResult.failure(
        error: '函数执行失败: ${e.toString()}'
      );
    }
  }

  /// 处理读取课程表函数
  Future<FunctionCallResult> _handleReadCourseSchedule(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final startDate = arguments['start_date'] as String?;
      final endDate = arguments['end_date'] as String?;
      final dayOfWeek = arguments['day_of_week'] as int?;

      debugPrint('📅 读取课程表 - 开始日期: $startDate, 结束日期: $endDate, 星期: $dayOfWeek');

      // 解析日期范围
      DateTime startDateTime;
      DateTime endDateTime;
      
      if (startDate != null && endDate != null) {
        try {
          startDateTime = DateTime.parse(startDate);
          endDateTime = DateTime.parse(endDate);
        } catch (e) {
          return FunctionCallResult.failure(error: '日期格式错误，请使用YYYY-MM-DD格式');
        }
      } else {
        // 默认查询本周的课程
        final now = DateTime.now();
        final weekDay = now.weekday;
        startDateTime = now.subtract(Duration(days: weekDay - 1)); // 本周一
        endDateTime = startDateTime.add(Duration(days: 6)); // 本周日
      }

      // 从计划仓库查询课程相关的计划
      var coursePlans = await _planRepository.getPlansByDateRange(startDateTime, endDateTime);
      
      // 过滤出课程类型的计划
      coursePlans = coursePlans.where((plan) => 
        plan.type == PlanType.study || 
        plan.courseId != null ||
        plan.title.toLowerCase().contains('课程') ||
        plan.title.toLowerCase().contains('课') ||
        plan.title.toLowerCase().contains('class') ||
        plan.description?.toLowerCase().contains('课程') == true
      ).toList();

      // 根据星期几过滤
      if (dayOfWeek != null && dayOfWeek >= 1 && dayOfWeek <= 7) {
        coursePlans = coursePlans.where((plan) => 
          plan.planDate.weekday == dayOfWeek
        ).toList();
      }

      // 转换为课程表格式
      final courses = coursePlans.map((plan) => {
        'course_name': plan.title,
        'teacher': _extractTeacher(plan.description),
        'classroom': _extractClassroom(plan.description),
        'time': _formatCourseTime(plan.planDate, plan.startTime, plan.endTime),
        'week_day': plan.planDate.weekday,
        'start_time': plan.startTime?.toString().split(' ')[1].substring(0, 5) ?? 
                     plan.planDate.toString().split(' ')[1].substring(0, 5),
        'end_time': plan.endTime?.toString().split(' ')[1].substring(0, 5) ?? 
                   plan.planDate.add(Duration(hours: 2)).toString().split(' ')[1].substring(0, 5),
        'course_id': plan.courseId,
        'description': plan.description,
        'progress': plan.progress,
        'status': plan.status.value,
        'priority': plan.priority.name,
        'tags': plan.tags,
      }).toList();

      // 按时间排序
      courses.sort((a, b) {
        final dayCompare = (a['week_day'] as int).compareTo(b['week_day'] as int);
        if (dayCompare != 0) return dayCompare;
        return (a['start_time'] as String).compareTo(b['start_time'] as String);
      });

      debugPrint('✅ 成功查询到${courses.length}门课程');

      return FunctionCallResult.success(
        data: {
          'courses': courses,
          'total_count': courses.length,
          'query_params': {
            'start_date': startDateTime.toIso8601String().split('T')[0],
            'end_date': endDateTime.toIso8601String().split('T')[0],
            'day_of_week': dayOfWeek
          },
          'date_range': {
            'start': startDateTime.toIso8601String().split('T')[0],
            'end': endDateTime.toIso8601String().split('T')[0]
          }
        },
        message: '成功获取课程表信息，共${courses.length}门课程'
      );

    } catch (e) {
      debugPrint('❌ 读取课程表失败: $e');
      return FunctionCallResult.failure(error: '读取课程表失败: ${e.toString()}');
    }
  }

  /// 从描述中提取教师信息
  String? _extractTeacher(String? description) {
    if (description == null || description.isEmpty) return null;
    
    // 尝试匹配常见的教师格式
    final teacherPatterns = [
      RegExp(r'教师[：:]\s*([^,，\n]+)'),
      RegExp(r'老师[：:]\s*([^,，\n]+)'),
      RegExp(r'任课教师[：:]\s*([^,，\n]+)'),
      RegExp(r'授课教师[：:]\s*([^,，\n]+)'),
      RegExp(r'([^,，\n]*)[教老]师'),
    ];
    
    for (final pattern in teacherPatterns) {
      final match = pattern.firstMatch(description);
      if (match != null) {
        final teacher = match.group(1)?.trim();
        if (teacher != null && teacher.isNotEmpty) {
          return teacher;
        }
      }
    }
    
    return null;
  }

  /// 从描述中提取教室信息
  String? _extractClassroom(String? description) {
    if (description == null || description.isEmpty) return null;
    
    // 尝试匹配常见的教室格式
    final classroomPatterns = [
      RegExp(r'教室[：:]\s*([^,，\n]+)'),
      RegExp(r'地点[：:]\s*([^,，\n]+)'),
      RegExp(r'上课地点[：:]\s*([^,，\n]+)'),
      RegExp(r'([A-Z]\d+|教学楼[A-Z]\d+|实验楼\d+|[^,，\n]*楼\d+)'),
    ];
    
    for (final pattern in classroomPatterns) {
      final match = pattern.firstMatch(description);
      if (match != null) {
        final classroom = match.group(1)?.trim();
        if (classroom != null && classroom.isNotEmpty) {
          return classroom;
        }
      }
    }
    
    return null;
  }

  /// 格式化课程时间显示
  String _formatCourseTime(DateTime planDate, DateTime? startTime, DateTime? endTime) {
    final weekdays = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekdayName = weekdays[planDate.weekday];
    
    if (startTime != null && endTime != null) {
      final startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
      return '$weekdayName $startTimeStr-$endTimeStr';
    } else {
      // 使用计划日期的时间
      final timeStr = '${planDate.hour.toString().padLeft(2, '0')}:${planDate.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${(planDate.hour + 2).toString().padLeft(2, '0')}:${planDate.minute.toString().padLeft(2, '0')}';
      return '$weekdayName $timeStr-$endTimeStr';
    }
  }

  /// 处理创建学习计划函数
  Future<FunctionCallResult> _handleCreateStudyPlan(
    Map<String, dynamic> arguments,
  ) async {
    try {
      // 验证必需参数
      final title = arguments['title'] as String?;
      final planDateStr = arguments['plan_date'] as String?;

      if (title == null || title.isEmpty) {
        return FunctionCallResult.failure(error: '计划标题不能为空');
      }
      
      if (planDateStr == null) {
        return FunctionCallResult.failure(error: '计划日期不能为空');
      }

      // 解析日期
      DateTime planDate;
      try {
        planDate = DateTime.parse(planDateStr);
      } catch (e) {
        return FunctionCallResult.failure(error: '日期格式错误，请使用YYYY-MM-DDTHH:mm:ss格式');
      }

      // 构建创建请求
      final request = CreatePlanRequest(
        title: title,
        description: arguments['description'] as String?,
        type: _parsePlanType(arguments['type'] as String?),
        priority: _parsePlanPriority(arguments['priority'] as int?),
        planDate: planDate,
        startTime: _parseDateTime(arguments['start_time'] as String?),
        endTime: _parseDateTime(arguments['end_time'] as String?),
        tags: _parseTags(arguments['tags']),
        courseId: arguments['course_id'] as String?,
        notes: arguments['notes'] as String?,
      );

      // 创建计划
      final createdPlan = await _planRepository.createPlan(request);
      
      debugPrint('✅ 成功创建计划: ${createdPlan.title}');

      return FunctionCallResult.success(
        data: {
          'plan_id': createdPlan.id,
          'title': createdPlan.title,
          'type': createdPlan.type.value,
          'priority': createdPlan.priority.level,
          'status': createdPlan.status.value,
          'plan_date': createdPlan.planDate.toIso8601String(),
          'created_at': createdPlan.createdAt.toIso8601String()
        },
        message: '成功创建学习计划: ${createdPlan.title}'
      );

    } catch (e) {
      return FunctionCallResult.failure(error: '创建计划失败: ${e.toString()}');
    }
  }

  /// 处理更新学习计划函数
  Future<FunctionCallResult> _handleUpdateStudyPlan(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final planId = arguments['plan_id'] as String?;
      
      if (planId == null || planId.isEmpty) {
        return FunctionCallResult.failure(error: '计划ID不能为空');
      }

      // 构建更新请求
      final request = UpdatePlanRequest(
        title: arguments['title'] as String?,
        description: arguments['description'] as String?,
        status: _parsePlanStatus(arguments['status'] as String?),
        priority: _parsePlanPriority(arguments['priority'] as int?),
        progress: arguments['progress'] as int?,
        notes: arguments['notes'] as String?,
      );

      // 更新计划
      final updatedPlan = await _planRepository.updatePlan(planId, request);
      
      debugPrint('✅ 成功更新计划: ${updatedPlan.title}');

      return FunctionCallResult.success(
        data: {
          'plan_id': updatedPlan.id,
          'title': updatedPlan.title,
          'status': updatedPlan.status.value,
          'priority': updatedPlan.priority.level,
          'progress': updatedPlan.progress,
          'updated_at': updatedPlan.updatedAt.toIso8601String()
        },
        message: '成功更新学习计划: ${updatedPlan.title}'
      );

    } catch (e) {
      return FunctionCallResult.failure(error: '更新计划失败: ${e.toString()}');
    }
  }

  /// 处理删除学习计划函数
  Future<FunctionCallResult> _handleDeleteStudyPlan(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final planId = arguments['plan_id'] as String?;
      
      if (planId == null || planId.isEmpty) {
        return FunctionCallResult.failure(error: '计划ID不能为空');
      }

      // 先查询计划是否存在
      final existingPlan = await _planRepository.getPlanById(planId);
      if (existingPlan == null) {
        return FunctionCallResult.failure(error: '找不到指定的计划');
      }

      // 删除计划
      await _planRepository.deletePlan(planId);
      
      debugPrint('✅ 成功删除计划: ${existingPlan.title}');

      return FunctionCallResult.success(
        data: {
          'deleted_plan_id': planId,
          'deleted_plan_title': existingPlan.title
        },
        message: '成功删除学习计划: ${existingPlan.title}'
      );

    } catch (e) {
      return FunctionCallResult.failure(error: '删除计划失败: ${e.toString()}');
    }
  }

  /// 处理查询学习计划函数
  Future<FunctionCallResult> _handleGetStudyPlans(
    Map<String, dynamic> arguments,
  ) async {
    try {
      // 解析查询参数
      final status = _parsePlanStatus(arguments['status'] as String?);
      final type = _parsePlanType(arguments['type'] as String?);
      final priority = _parsePlanPriority(arguments['priority'] as int?);
      final startDateStr = arguments['start_date'] as String?;
      final endDateStr = arguments['end_date'] as String?;
      final searchQuery = arguments['search_query'] as String?;
      final limit = arguments['limit'] as int? ?? 20;

      List<PlanEntity> plans;

      // 根据不同条件查询
      if (status != null) {
        plans = await _planRepository.getPlansByStatus(status);
      } else if (arguments['type'] != null) {
        // type 总是非空，所以检查原始参数
        plans = await _planRepository.getPlansByType(type);
      } else if (arguments['priority'] != null) {
        // priority 总是非空，所以检查原始参数
        plans = await _planRepository.getPlansByPriority(priority);
      } else if (startDateStr != null && endDateStr != null) {
        final startDate = DateTime.parse(startDateStr);
        final endDate = DateTime.parse(endDateStr);
        plans = await _planRepository.getPlansByDateRange(startDate, endDate);
      } else if (searchQuery != null) {
        plans = await _planRepository.searchPlans(searchQuery);
      } else {
        plans = await _planRepository.getAllPlans();
      }

      // 应用限制
      if (plans.length > limit) {
        plans = plans.take(limit).toList();
      }

      // 格式化返回数据
      final plansData = plans.map((plan) => {
        'id': plan.id,
        'title': plan.title,
        'description': plan.description,
        'type': plan.type.value,
        'priority': plan.priority.level,
        'status': plan.status.value,
        'plan_date': plan.planDate.toIso8601String(),
        'progress': plan.progress,
        'tags': plan.tags,
        'created_at': plan.createdAt.toIso8601String(),
        'updated_at': plan.updatedAt.toIso8601String()
      }).toList();

      debugPrint('📋 查询到${plans.length}个计划');

      return FunctionCallResult.success(
        data: {
          'plans': plansData,
          'total_count': plans.length,
          'query_params': arguments
        },
        message: '成功查询到${plans.length}个学习计划'
      );

    } catch (e) {
      return FunctionCallResult.failure(error: '查询计划失败: ${e.toString()}');
    }
  }

  /// 处理分析课程工作量函数
  Future<FunctionCallResult> _handleAnalyzeCourseWorkload(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final startDate = arguments['start_date'] as String?;
      final endDate = arguments['end_date'] as String?;

      debugPrint('📊 分析课程工作量 - 时间范围: $startDate 至 $endDate');

      // 解析日期范围
      DateTime startDateTime;
      DateTime endDateTime;
      
      if (startDate != null && endDate != null) {
        startDateTime = DateTime.parse(startDate);
        endDateTime = DateTime.parse(endDate);
      } else {
        startDateTime = DateTime.now();
        endDateTime = startDateTime.add(Duration(days: 7));
      }

      // 获取时间段内的所有计划
      final plans = await _planRepository.getPlansByDateRange(startDateTime, endDateTime);
      
      // 过滤学习相关的计划
      final studyPlans = plans.where((plan) => 
        plan.type == PlanType.study || 
        plan.title.toLowerCase().contains('课程') ||
        plan.title.toLowerCase().contains('学习') ||
        plan.title.toLowerCase().contains('作业') ||
        plan.description?.toLowerCase().contains('课程') == true
      ).toList();

      // 计算工作量统计
      final workloadStats = _calculateWorkloadStats(studyPlans, startDateTime, endDateTime);
      
      // 生成时间分布分析
      final timeDistribution = _analyzeTimeDistribution(studyPlans);
      
      // 生成优化建议
      final recommendations = _generateWorkloadRecommendations(workloadStats, timeDistribution);

      final analysisResult = {
        'time_period': {
          'start_date': startDateTime.toIso8601String().split('T')[0],
          'end_date': endDateTime.toIso8601String().split('T')[0]
        },
        'workload_stats': workloadStats,
        'time_distribution': timeDistribution,
        'recommendations': recommendations,
        'summary': _generateWorkloadSummary(studyPlans.length, workloadStats)
      };

      return FunctionCallResult.success(
        data: analysisResult,
        message: '课程工作量分析完成，共分析${studyPlans.length}个学习计划'
      );
    } catch (e) {
      return FunctionCallResult.failure(error: '分析课程工作量失败: ${e.toString()}');
    }
  }

  // 辅助方法：解析计划类型
  PlanType _parsePlanType(String? typeStr) {
    switch (typeStr) {
      case 'study': return PlanType.study;
      case 'work': return PlanType.work;
      case 'life': return PlanType.life;
      case 'other': return PlanType.other;
      default: return PlanType.study;
    }
  }

  // 辅助方法：解析计划优先级
  PlanPriority _parsePlanPriority(int? priority) {
    switch (priority) {
      case 1: return PlanPriority.low;
      case 2: return PlanPriority.medium;
      case 3: return PlanPriority.high;
      default: return PlanPriority.medium;
    }
  }

  // 辅助方法：解析计划状态
  PlanStatus? _parsePlanStatus(String? statusStr) {
    switch (statusStr) {
      case 'pending': return PlanStatus.pending;
      case 'in_progress': return PlanStatus.inProgress;
      case 'completed': return PlanStatus.completed;
      case 'cancelled': return PlanStatus.cancelled;
      default: return null;
    }
  }

  // 辅助方法：解析日期时间
  DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return null;
    try {
      return DateTime.parse(dateTimeStr);
    } catch (e) {
      return null;
    }
  }

  // 辅助方法：解析标签
  List<String> _parseTags(dynamic tagsData) {
    if (tagsData == null) return [];
    if (tagsData is List) {
      return tagsData.map((tag) => tag.toString()).toList();
    }
    return [];
  }

  /// 计算工作量统计数据
  Map<String, dynamic> _calculateWorkloadStats(
    List<PlanEntity> studyPlans,
    DateTime startDateTime,
    DateTime endDateTime,
  ) {
    // 计算总计划数
    final totalPlans = studyPlans.length;
    
    // 按状态分组统计
    final Map<String, int> statusStats = {};
    for (final plan in studyPlans) {
      final status = plan.status.value;
      statusStats[status] = (statusStats[status] ?? 0) + 1;
    }
    
    // 按优先级分组统计
    final Map<String, int> priorityStats = {};
    for (final plan in studyPlans) {
      final priority = plan.priority.name;
      priorityStats[priority] = (priorityStats[priority] ?? 0) + 1;
    }
    
    // 计算完成度统计
    final completedCount = statusStats['completed'] ?? 0;
    final inProgressCount = statusStats['in_progress'] ?? 0;
    final pendingCount = statusStats['pending'] ?? 0;
    final completionRate = totalPlans > 0 ? (completedCount / totalPlans * 100).round() : 0;
    
    // 计算平均进度
    final totalProgress = studyPlans.fold<int>(0, (sum, plan) => sum + plan.progress);
    final averageProgress = totalPlans > 0 ? (totalProgress / totalPlans).round() : 0;
    
    // 计算时间分布（每日计划数量）
    final Map<String, int> dailyDistribution = {};
    for (final plan in studyPlans) {
      final dateKey = plan.planDate.toIso8601String().split('T')[0];
      dailyDistribution[dateKey] = (dailyDistribution[dateKey] ?? 0) + 1;
    }
    
    return {
      'total_plans': totalPlans,
      'completion_rate': completionRate,
      'average_progress': averageProgress,
      'status_breakdown': {
        'completed': completedCount,
        'in_progress': inProgressCount,
        'pending': pendingCount,
        'cancelled': statusStats['cancelled'] ?? 0,
      },
      'priority_breakdown': {
        'high': priorityStats['high'] ?? 0,
        'medium': priorityStats['medium'] ?? 0,
        'low': priorityStats['low'] ?? 0,
      },
      'daily_distribution': dailyDistribution,
    };
  }

  /// 分析时间分布模式
  Map<String, dynamic> _analyzeTimeDistribution(List<PlanEntity> studyPlans) {
    // 按星期几分组统计
    final Map<int, int> weekdayStats = {};
    final Map<int, List<String>> weekdayPlans = {};
    
    for (final plan in studyPlans) {
      final weekday = plan.planDate.weekday;
      weekdayStats[weekday] = (weekdayStats[weekday] ?? 0) + 1;
      
      if (!weekdayPlans.containsKey(weekday)) {
        weekdayPlans[weekday] = [];
      }
      weekdayPlans[weekday]!.add(plan.title);
    }
    
    // 按时间段分组统计（上午、下午、晚上）
    final Map<String, int> timeSlotStats = {
      'morning': 0,    // 6:00-12:00
      'afternoon': 0,  // 12:00-18:00
      'evening': 0,    // 18:00-22:00
      'night': 0,      // 22:00-6:00
    };
    
    for (final plan in studyPlans) {
      final hour = plan.planDate.hour;
      if (hour >= 6 && hour < 12) {
        timeSlotStats['morning'] = timeSlotStats['morning']! + 1;
      } else if (hour >= 12 && hour < 18) {
        timeSlotStats['afternoon'] = timeSlotStats['afternoon']! + 1;
      } else if (hour >= 18 && hour < 22) {
        timeSlotStats['evening'] = timeSlotStats['evening']! + 1;
      } else {
        timeSlotStats['night'] = timeSlotStats['night']! + 1;
      }
    }
    
    // 找出最繁忙的日期
    String? busiestDay;
    int maxDailyPlans = 0;
    final Map<String, int> dailyCount = {};
    
    for (final plan in studyPlans) {
      final dateKey = plan.planDate.toIso8601String().split('T')[0];
      dailyCount[dateKey] = (dailyCount[dateKey] ?? 0) + 1;
      
      if (dailyCount[dateKey]! > maxDailyPlans) {
        maxDailyPlans = dailyCount[dateKey]!;
        busiestDay = dateKey;
      }
    }
    
    return {
      'weekday_distribution': weekdayStats,
      'time_slot_distribution': timeSlotStats,
      'busiest_day': busiestDay,
      'max_daily_plans': maxDailyPlans,
      'weekday_plan_details': weekdayPlans,
    };
  }

  /// 生成工作量优化建议
  List<String> _generateWorkloadRecommendations(
    Map<String, dynamic> workloadStats,
    Map<String, dynamic> timeDistribution,
  ) {
    final recommendations = <String>[];
    
    // 基于完成率的建议
    final completionRate = workloadStats['completion_rate'] as int;
    if (completionRate < 50) {
      recommendations.add('完成率较低($completionRate%)，建议优化时间管理或降低任务难度');
    } else if (completionRate > 80) {
      recommendations.add('完成率良好($completionRate%)，可以考虑增加挑战性任务');
    }
    
    // 基于进度的建议
    final averageProgress = workloadStats['average_progress'] as int;
    if (averageProgress < 30) {
      recommendations.add('平均进度较慢($averageProgress%)，建议将大任务分解为小任务');
    }
    
    // 基于优先级分布的建议
    final priorityBreakdown = workloadStats['priority_breakdown'] as Map<String, dynamic>;
    final highPriorityCount = priorityBreakdown['high'] as int;
    final totalPlans = workloadStats['total_plans'] as int;
    
    if (totalPlans > 0) {
      final highPriorityRatio = highPriorityCount / totalPlans;
      if (highPriorityRatio > 0.6) {
        recommendations.add('高优先级任务过多(${(highPriorityRatio * 100).round()}%)，建议重新评估任务优先级');
      } else if (highPriorityRatio < 0.2) {
        recommendations.add('缺乏高优先级任务，建议设置核心学习目标');
      }
    }
    
    // 基于时间分布的建议
    final timeSlotStats = timeDistribution['time_slot_distribution'] as Map<String, dynamic>;
    final maxTimeSlot = timeSlotStats.entries.reduce((a, b) => a.value > b.value ? a : b);
    
    if (maxTimeSlot.key == 'night' && maxTimeSlot.value > totalPlans * 0.4) {
      recommendations.add('夜间学习安排过多，建议调整作息时间，将重要任务安排在白天');
    }
    
    if (timeSlotStats['morning']! < totalPlans * 0.2) {
      recommendations.add('建议增加上午时段的学习安排，充分利用高效学习时间');
    }
    
    // 基于工作量集中度的建议
    final busiestDay = timeDistribution['busiest_day'] as String?;
    final maxDailyPlans = timeDistribution['max_daily_plans'] as int;
    
    if (busiestDay != null && maxDailyPlans > 5) {
      recommendations.add('$busiestDay 安排过于密集($maxDailyPlans个任务)，建议分散到其他日期');
    }
    
    // 基于状态分布的建议
    final statusBreakdown = workloadStats['status_breakdown'] as Map<String, dynamic>;
    final pendingCount = statusBreakdown['pending'] as int;
    final inProgressCount = statusBreakdown['in_progress'] as int;
    
    if (inProgressCount > totalPlans * 0.5) {
      recommendations.add('进行中的任务过多，建议先完成部分任务再开始新任务');
    }
    
    if (pendingCount == 0 && totalPlans > 0) {
      recommendations.add('没有待处理任务，建议规划下一阶段的学习内容');
    }
    
    // 如果没有特别的建议，提供通用建议
    if (recommendations.isEmpty) {
      recommendations.add('当前学习安排合理，建议保持现有节奏');
    }
    
    return recommendations;
  }

  /// 生成工作量分析总结
  String _generateWorkloadSummary(int planCount, Map<String, dynamic> workloadStats) {
    final completionRate = workloadStats['completion_rate'] as int;
    final averageProgress = workloadStats['average_progress'] as int;
    final statusBreakdown = workloadStats['status_breakdown'] as Map<String, dynamic>;
    
    final completedCount = statusBreakdown['completed'] as int;
    final inProgressCount = statusBreakdown['in_progress'] as int;
    final pendingCount = statusBreakdown['pending'] as int;
    
    return '分析期间共有$planCount个学习计划，'
        '完成率为$completionRate%，平均进度$averageProgress%。'
        '其中已完成$completedCount个，进行中$inProgressCount个，待处理$pendingCount个任务。';
  }
}