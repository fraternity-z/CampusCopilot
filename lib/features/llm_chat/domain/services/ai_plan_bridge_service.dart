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
    // TODO: 实现课程表读取逻辑
    // 当前返回模拟数据，后续需要集成实际的课程表服务
    
    final startDate = arguments['start_date'] as String?;
    final endDate = arguments['end_date'] as String?;
    final dayOfWeek = arguments['day_of_week'] as int?;

    debugPrint('📅 读取课程表 - 开始日期: $startDate, 结束日期: $endDate, 星期: $dayOfWeek');

    // 模拟课程数据
    final mockCourses = [
      {
        'course_name': '高等数学',
        'teacher': '张教授',
        'classroom': '教学楼A101',
        'time': '周一 08:00-09:40',
        'week_day': 1,
        'start_time': '08:00',
        'end_time': '09:40'
      },
      {
        'course_name': '英语',
        'teacher': '李老师', 
        'classroom': '教学楼B201',
        'time': '周三 14:00-15:40',
        'week_day': 3,
        'start_time': '14:00',
        'end_time': '15:40'
      }
    ];

    // 根据参数过滤
    var filteredCourses = mockCourses;
    if (dayOfWeek != null) {
      filteredCourses = mockCourses.where((course) => 
        course['week_day'] == dayOfWeek
      ).toList();
    }

    return FunctionCallResult.success(
      data: {
        'courses': filteredCourses,
        'total_count': filteredCourses.length,
        'query_params': {
          'start_date': startDate,
          'end_date': endDate,
          'day_of_week': dayOfWeek
        }
      },
      message: '成功获取课程表信息，共${filteredCourses.length}门课程'
    );
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
    // TODO: 实现课程工作量分析逻辑
    // 当前返回模拟分析结果
    
    final startDate = arguments['start_date'] as String?;
    final endDate = arguments['end_date'] as String?;

    debugPrint('📊 分析课程工作量 - 时间范围: $startDate 至 $endDate');

    // 模拟分析结果
    final analysisResult = {
      'time_period': {
        'start_date': startDate ?? DateTime.now().toIso8601String().split('T')[0],
        'end_date': endDate ?? DateTime.now().add(Duration(days: 7)).toIso8601String().split('T')[0]
      },
      'course_load': {
        'total_hours': 20,
        'busy_days': ['周一', '周三', '周五'],
        'free_time_slots': [
          {'day': '周二', 'time': '14:00-16:00'},
          {'day': '周四', 'time': '10:00-12:00'}
        ]
      },
      'recommendations': [
        '建议在周二下午安排复习时间',
        '周四上午适合完成作业',
        '周末可以进行深度学习'
      ],
      'plan_suggestions': [
        {
          'title': '高等数学复习',
          'recommended_time': '周二 14:00-16:00',
          'priority': 'high'
        },
        {
          'title': '英语作业完成',
          'recommended_time': '周四 10:00-12:00', 
          'priority': 'medium'
        }
      ]
    };

    return FunctionCallResult.success(
      data: analysisResult,
      message: '课程工作量分析完成，发现2个空闲时间段可用于学习规划'
    );
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
}