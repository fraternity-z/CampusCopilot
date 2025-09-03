import '../../../../shared/utils/debug_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tools/daily_management_tools.dart';
import 'package:ai_assistant/features/daily_management/domain/entities/plan_entity.dart';
import 'package:ai_assistant/features/daily_management/domain/repositories/plan_repository.dart';
import 'package:ai_assistant/repository/classtable_cache_manager.dart';
import 'package:intl/intl.dart';

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

  debugLog(() => '🤖 AI函数调用: $functionName');
  debugLog(() => '📋 调用参数: $arguments');

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
  debugLog(() => '❌ AI函数调用失败: $functionName');
  debugLog(() => '错误详情: $e');
  debugLog(() => '堆栈跟踪: $stackTrace');
      
      return FunctionCallResult.failure(
        error: '函数执行失败: ${e.toString()}'
      );
    }
  }

  /// 处理读取课程表函数
  Future<FunctionCallResult> _handleReadCourseSchedule(Map<String, dynamic> arguments) async {
    try {
      // 定义课程标签正则表达式
      final courseTagsRegex = RegExp(
        r'(课程|上课|教学|实验|讲座|研讨|考试|测验|作业|课堂)',
        caseSensitive: false,
      );
      // 解析参数
      DateTime? startDate;
      DateTime? endDate;
      
      // 解析日期范围
      if (arguments['date_range'] != null) {
        final dateRangeStr = arguments['date_range'] as String;
        final dates = dateRangeStr.split('至');
        if (dates.length == 2) {
          try {
            startDate = DateTime.parse(dates[0].trim());
            endDate = DateTime.parse(dates[1].trim());
          } catch (e) {
            debugLog(() => '日期解析错误: $e');
          }
        }
      }
      
      // 如果没有指定日期范围，默认为本周
      if (startDate == null || endDate == null) {
        final now = DateTime.now();
        final weekday = now.weekday;
        startDate = now.subtract(Duration(days: weekday - 1));
        endDate = startDate.add(Duration(days: 6));
      }
      
      // 解析星期几筛选
      List<int>? weekdayFilter;
      if (arguments['weekday'] != null) {
        final weekdayStr = arguments['weekday'] as String;
        weekdayFilter = _parseWeekday(weekdayStr);
      }
      
      // 首先尝试从缓存读取真实的课程表数据
      final cachedClassTable = await ClassTableCacheManager.loadClassTable();
      
      if (cachedClassTable != null && cachedClassTable.timeArrangement.isNotEmpty) {
        // 计算当前是第几周
        DateTime termStart;
        try {
          termStart = DateTime.parse(cachedClassTable.termStartDay);
        } catch (e) {
          // 如果解析失败，使用默认值
          termStart = DateTime.now().subtract(Duration(days: 30));
        }
        
        final daysSinceStart = startDate.difference(termStart).inDays;
        final currentWeek = (daysSinceStart / 7).floor();
        
        // 转换缓存的课程表数据为AI格式
        final courses = <Map<String, dynamic>>[];
        
        for (final timeArrangement in cachedClassTable.timeArrangement) {
          // 检查是否在当前周有课
          if (currentWeek >= 0 && 
              currentWeek < timeArrangement.weekList.length && 
              timeArrangement.weekList[currentWeek]) {
            
            // 过滤星期
            if (weekdayFilter != null && !weekdayFilter.contains(timeArrangement.day)) {
              continue;
            }
            
            // 获取课程详情
            final classDetail = cachedClassTable.getClassDetail(timeArrangement);
            
            // 计算具体日期
            final courseDate = startDate.add(Duration(days: timeArrangement.day - 1));
            
            // 如果课程日期不在查询范围内，跳过
            if (courseDate.isBefore(startDate) || courseDate.isAfter(endDate)) {
              continue;
            }
            
            courses.add({
              'course_name': classDetail.name,
              'teacher': timeArrangement.teacher ?? '',
              'classroom': timeArrangement.classroom ?? '',
              'time': '${_getTimeFromIndex(timeArrangement.start, true)}-${_getTimeFromIndex(timeArrangement.stop, false)}',
              'week_day': timeArrangement.day,
              'start_time': _getTimeFromIndex(timeArrangement.start, true),
              'end_time': _getTimeFromIndex(timeArrangement.stop, false),
              'course_id': '${classDetail.code ?? classDetail.name}_${timeArrangement.day}_${timeArrangement.start}',
              'description': '${classDetail.name}课程，教师：${timeArrangement.teacher ?? "未知"}，地点：${timeArrangement.classroom ?? "未知"}，第${timeArrangement.start}-${timeArrangement.stop}节',
              'progress': 0,
              'status': 'pending',
              'priority': 'high',
              'tags': ['课程', '正式课表'],
              'course_code': classDetail.code,
              'course_number': classDetail.number,
              'section_start': timeArrangement.start,
              'section_end': timeArrangement.stop,
              'current_week': currentWeek + 1,
            });
          }
        }
        
        // 如果有真实课程数据，返回
        if (courses.isNotEmpty) {
          // 按星期和时间排序
          courses.sort((a, b) {
            final dayCompare = (a['week_day'] as int).compareTo(b['week_day'] as int);
            if (dayCompare != 0) return dayCompare;
            return (a['section_start'] as int).compareTo(b['section_start'] as int);
          });
          
          final result = {
            'success': true,
            'message': '成功获取课程表（真实数据）',
            'data': {
              'start_date': DateFormat('yyyy-MM-dd').format(startDate),
              'end_date': DateFormat('yyyy-MM-dd').format(endDate),
              'semester_code': cachedClassTable.semesterCode,
              'current_week': currentWeek + 1,
              'total_courses': courses.length,
              'courses': courses,
            }
          };
          
          return FunctionCallResult.success(
            data: result
          );
        }
      }
      
      // 如果没有缓存数据，尝试从计划仓库查询
      final plans = await _planRepository.getPlansByDateRange(
        startDate,
        endDate,
      );
      
      // 筛选课程计划
      final coursePlans = plans.where((plan) {
        // 如果有星期筛选，应用筛选
        if (weekdayFilter != null && !weekdayFilter.contains(plan.planDate.weekday)) {
          return false;
        }
        
        // 检查是否包含课程相关标签
        final tags = plan.tags;
        final description = plan.description ?? '';
        return tags.any((tag) => 
          tag.contains('课程') || 
          tag.contains('课表') || 
          tag.contains('上课')
        ) || (description.isNotEmpty && courseTagsRegex.hasMatch(description));
      }).toList();
      
      if (coursePlans.isEmpty) {
        // 返回示例课程表数据
        final sampleCourses = _generateSampleCourseSchedule(startDate, endDate);
        
        final result = {
          'success': true,
          'message': '已获取本周课程表（示例数据）',
          'data': {
            'start_date': DateFormat('yyyy-MM-dd').format(startDate),
            'end_date': DateFormat('yyyy-MM-dd').format(endDate),
            'total_courses': sampleCourses.length,
            'courses': sampleCourses,
          }
        };
        
        return FunctionCallResult.success(
          data: result
        );
      }
      
      // 转换为课程格式
      final courses = coursePlans.map((plan) {
        // 从计划描述中提取课程信息
        final teacher = _extractTeacher(plan.description ?? '');
        final classroom = _extractClassroom(plan.description ?? '');
        final time = _formatCourseTime(plan);
        
        return {
          'id': plan.id,
          'name': plan.title,
          'teacher': teacher,
          'classroom': classroom,
          'time': time,
          'week_day': plan.planDate.weekday,
          'start_time': DateFormat('HH:mm').format(plan.planDate),
          'end_time': plan.endTime != null 
              ? DateFormat('HH:mm').format(plan.endTime!)
              : DateFormat('HH:mm').format(plan.planDate.add(Duration(hours: 2))),
          'course_id': plan.id,
          'description': plan.description,
          'progress': plan.progress,
          'status': plan.status.value,
          'priority': plan.priority.name,
          'tags': plan.tags,
        };
      }).toList();
      
      final result = {
        'success': true,
        'message': '成功获取课程表',
        'data': {
          'start_date': DateFormat('yyyy-MM-dd').format(startDate),
          'end_date': DateFormat('yyyy-MM-dd').format(endDate),
          'total_courses': courses.length,
          'courses': courses,
        }
      };
      
      return FunctionCallResult.success(
        data: result
      );
      
    } catch (e) {
      return FunctionCallResult.failure(
        error: '获取课程表失败: $e'
      );
    }
  }

  /// 解析星期参数
  List<int>? _parseWeekday(String? weekdayStr) {
    if (weekdayStr == null || weekdayStr.isEmpty) return null;
    
    // 映射星期名称到数字
    final weekdayMap = {
      '星期一': 1, '周一': 1, 'Monday': 1,
      '星期二': 2, '周二': 2, 'Tuesday': 2,
      '星期三': 3, '周三': 3, 'Wednesday': 3,
      '星期四': 4, '周四': 4, 'Thursday': 4,
      '星期五': 5, '周五': 5, 'Friday': 5,
      '星期六': 6, '周六': 6, 'Saturday': 6,
      '星期日': 7, '周日': 7, 'Sunday': 7,
    };
    
    // 尝试解析为数字
    final weekday = int.tryParse(weekdayStr);
    if (weekday != null && weekday >= 1 && weekday <= 7) {
      return [weekday];
    }
    
    // 尝试匹配星期名称
    for (final entry in weekdayMap.entries) {
      if (weekdayStr.contains(entry.key)) {
        return [entry.value];
      }
    }
    
    return null;
  }
  
  
  /// 根据节次索引获取时间
  String _getTimeFromIndex(int index, bool isStart) {
    // 时间安排表：偶数索引是开始时间，奇数索引是结束时间
    final timeList = [
      "08:30", "09:15",  // 第1节
      "09:20", "10:05",  // 第2节
      "10:25", "11:10",  // 第3节
      "11:15", "12:00",  // 第4节
      "14:00", "14:45",  // 第5节
      "14:50", "15:35",  // 第6节
      "15:55", "16:40",  // 第7节
      "16:45", "17:30",  // 第8节
      "19:00", "19:45",  // 第9节
      "19:55", "20:35",  // 第10节
      "20:40", "21:25",  // 第11节
    ];
    
    // 节次从1开始，需要转换为数组索引
    final timeIndex = isStart ? (index - 1) * 2 : (index - 1) * 2 + 1;
    
    if (timeIndex >= 0 && timeIndex < timeList.length) {
      return timeList[timeIndex];
    }
    
    return isStart ? '08:30' : '10:10';
  }
  
  /// 格式化课程时间
  String _formatCourseTime(PlanEntity plan) {
    final startTime = DateFormat('HH:mm').format(plan.planDate);
    final endTime = plan.endTime != null 
        ? DateFormat('HH:mm').format(plan.endTime!)
        : DateFormat('HH:mm').format(plan.planDate.add(Duration(hours: 2)));
    
    return '$startTime-$endTime';
  }
  
  /// 从描述中提取教师信息
  String? _extractTeacher(String? description) {
    if (description == null || description.isEmpty) return null;
    
    // 尝试匹配常见的教师格式
    final teacherPatterns = [
      RegExp(r'教师[：::\s]*([^,，\n]+)'),
      RegExp(r'老师[：::\s]*([^,，\n]+)'),
      RegExp(r'任课教师[：::\s]*([^,，\n]+)'),
      RegExp(r'授课教师[：::\s]*([^,，\n]+)'),
    ];
    
    for (final pattern in teacherPatterns) {
      final match = pattern.firstMatch(description);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    
    return null;
  }
  
  /// 从描述中提取教室信息
  String? _extractClassroom(String? description) {
    if (description == null || description.isEmpty) return null;
    
    // 尝试匹配常见的教室格式
    final classroomPatterns = [
      RegExp(r'教室[：::\s]*([^,，\n]+)'),
      RegExp(r'地点[：::\s]*([^,，\n]+)'),
      RegExp(r'上课地点[：::\s]*([^,，\n]+)'),
      RegExp(r'([A-Z]\d{3,4}[室]?)'), // 匹配如B203室
    ];
    
    for (final pattern in classroomPatterns) {
      final match = pattern.firstMatch(description);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    
    return null;
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

      // 解析开始时间和结束时间
      DateTime? startTime = _parseDateTime(arguments['start_time'] as String?);
      DateTime? endTime = _parseDateTime(arguments['end_time'] as String?);
      
      debugLog(() => '🕐 解析到的开始时间: $startTime');
      debugLog(() => '🕐 解析到的结束时间: $endTime');
      
      // 如果提供了开始时间，但没有提供计划日期的具体时间，则使用开始时间作为计划日期
      if (startTime != null) {
        // 如果计划日期只包含日期部分，则与开始时间合并
        if (planDate.hour == 0 && planDate.minute == 0 && planDate.second == 0) {
          planDate = DateTime(
            planDate.year,
            planDate.month, 
            planDate.day,
            startTime.hour,
            startTime.minute,
            startTime.second,
          );
          debugLog(() => '📅 计划日期已更新为包含开始时间: $planDate');
        }
      }

      // 构建创建请求
      final request = CreatePlanRequest(
        title: title,
        description: arguments['description'] as String?,
        type: _parsePlanType(arguments['type'] as String?),
        priority: _parsePlanPriority(arguments['priority'] as int?),
        planDate: planDate,
        startTime: startTime,
        endTime: endTime,
        tags: _parseTags(arguments['tags']),
        courseId: arguments['course_id'] as String?,
        notes: arguments['notes'] as String?,
      );

      // 创建计划
      final createdPlan = await _planRepository.createPlan(request);
      
  debugLog(() => '✅ 成功创建计划: ${createdPlan.title}');

      return FunctionCallResult.success(
        data: {
          'plan_id': createdPlan.id,
          'title': createdPlan.title,
          'type': createdPlan.type.value,
          'priority': createdPlan.priority.level,
          'status': createdPlan.status.value,
          'plan_date': createdPlan.planDate.toIso8601String(),
          'start_time': createdPlan.startTime?.toIso8601String(),
          'end_time': createdPlan.endTime?.toIso8601String(),
          'tags': createdPlan.tags,
          'course_id': createdPlan.courseId,
          'notes': createdPlan.notes,
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
      
  debugLog(() => '✅ 成功更新计划: ${updatedPlan.title}');

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
      debugLog(() => '🗑️ 开始智能删除计划，参数: $arguments');
      
      List<PlanEntity> plansToDelete = [];
      
      // 如果提供了具体的计划ID，直接删除该计划
      final planId = arguments['plan_id'] as String?;
      if (planId != null && planId.isNotEmpty) {
        final existingPlan = await _planRepository.getPlanById(planId);
        if (existingPlan != null) {
          plansToDelete.add(existingPlan);
        } else {
          return FunctionCallResult.failure(error: '找不到指定的计划，ID: $planId');
        }
      } 
      // 删除所有计划
      else if (arguments['delete_all'] == true) {
        plansToDelete = await _planRepository.getAllPlans();
        debugLog(() => '🔥 执行删除所有计划操作，共${plansToDelete.length}个计划');
      }
      // 按条件查询要删除的计划
      else {
        // 按状态筛选
        if (arguments['status'] != null) {
          final status = _parsePlanStatus(arguments['status'] as String);
          if (status != null) {
            plansToDelete = await _planRepository.getPlansByStatus(status);
          }
        }
        // 按类型筛选
        else if (arguments['type'] != null) {
          final type = _parsePlanType(arguments['type'] as String);
          plansToDelete = await _planRepository.getPlansByType(type);
        }
        // 按日期范围筛选
        else if (arguments['date_range'] != null) {
          final dateRange = arguments['date_range'] as Map<String, dynamic>;
          final startDate = DateTime.parse(dateRange['start_date']);
          final endDate = DateTime.parse(dateRange['end_date']);
          plansToDelete = await _planRepository.getPlansByDateRange(startDate, endDate);
        }
        // 按标题匹配筛选
        else if (arguments['title_contains'] != null) {
          final titleQuery = arguments['title_contains'] as String;
          plansToDelete = await _planRepository.searchPlans(titleQuery);
        }
        // 如果没有指定条件，默认删除所有学习类型的计划
        else {
          plansToDelete = await _planRepository.getPlansByType(PlanType.study);
          debugLog(() => '📚 默认删除所有学习类型计划，共${plansToDelete.length}个');
        }
      }

      // 如果没有找到要删除的计划
      if (plansToDelete.isEmpty) {
        return FunctionCallResult.success(
          data: {
            'deleted_count': 0,
            'message': '未找到符合条件的计划'
          },
          message: '未找到符合条件的计划需要删除'
        );
      }

      // 执行批量删除
      debugLog(() => '⚡ 开始执行批量删除，共${plansToDelete.length}个计划');
      final deletedPlans = <Map<String, dynamic>>[];
      
      for (final plan in plansToDelete) {
        try {
          await _planRepository.deletePlan(plan.id);
          deletedPlans.add({
            'id': plan.id,
            'title': plan.title,
            'type': plan.type.value,
            'status': plan.status.value,
          });
          debugLog(() => '✅ 已删除: ${plan.title}');
        } catch (e) {
          debugLog(() => '❌ 删除失败: ${plan.title}, 错误: $e');
        }
      }

      debugLog(() => '🎉 批量删除完成，成功删除${deletedPlans.length}个计划');

      return FunctionCallResult.success(
        data: {
          'deleted_count': deletedPlans.length,
          'total_found': plansToDelete.length,
          'deleted_plans': deletedPlans,
          'deletion_confirmed': true
        },
        message: '成功删除${deletedPlans.length}个学习计划'
      );

    } catch (e) {
      debugLog(() => '❌ 智能删除计划时发生异常: $e');
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

  debugLog(() => '📋 查询到${plans.length}个计划');

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

  debugLog(() => '📊 分析课程工作量 - 时间范围: $startDate 至 $endDate');

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

  /// 生成示例课程表数据
  List<Map<String, dynamic>> _generateSampleCourseSchedule(DateTime startDate, DateTime endDate) {
    final courses = <Map<String, dynamic>>[];
    
    // 示例课程数据
    final sampleCourses = [
      {
        'name': '高等数学',
        'teacher': '张教授',
        'classroom': '教学楼A301',
        'day': 1, // 周一
        'start': '08:00',
        'end': '09:40',
      },
      {
        'name': '大学英语',
        'teacher': '李老师',
        'classroom': '教学楼B205',
        'day': 1,
        'start': '10:00',
        'end': '11:40',
      },
      {
        'name': '数据结构',
        'teacher': '王教授',
        'classroom': '实验楼C401',
        'day': 2, // 周二
        'start': '14:00',
        'end': '15:40',
      },
      {
        'name': '计算机网络',
        'teacher': '刘老师',
        'classroom': '教学楼A502',
        'day': 2,
        'start': '16:00',
        'end': '17:40',
      },
      {
        'name': '操作系统',
        'teacher': '陈教授',
        'classroom': '教学楼B301',
        'day': 3, // 周三
        'start': '08:00',
        'end': '09:40',
      },
      {
        'name': '数据库原理',
        'teacher': '赵老师',
        'classroom': '实验楼C302',
        'day': 3,
        'start': '14:00',
        'end': '15:40',
      },
      {
        'name': '软件工程',
        'teacher': '周教授',
        'classroom': '教学楼A401',
        'day': 4, // 周四
        'start': '10:00',
        'end': '11:40',
      },
      {
        'name': '人工智能导论',
        'teacher': '吴老师',
        'classroom': '教学楼B403',
        'day': 4,
        'start': '14:00',
        'end': '15:40',
      },
      {
        'name': '线性代数',
        'teacher': '郑教授',
        'classroom': '教学楼A201',
        'day': 5, // 周五
        'start': '08:00',
        'end': '09:40',
      },
      {
        'name': '概率论与数理统计',
        'teacher': '孙老师',
        'classroom': '教学楼B302',
        'day': 5,
        'start': '10:00',
        'end': '11:40',
      },
    ];
    
    // 根据日期范围生成课程
    for (final courseData in sampleCourses) {
      // 计算课程的具体日期
      final weekday = courseData['day'] as int;
      final courseDate = _getDateForWeekday(startDate, endDate, weekday);
      
      if (courseDate != null && courseDate.isAfter(startDate.subtract(Duration(days: 1))) 
          && courseDate.isBefore(endDate.add(Duration(days: 1)))) {
        courses.add({
          'course_name': courseData['name'],
          'teacher': courseData['teacher'],
          'classroom': courseData['classroom'],
          'time': '周${_getWeekdayName(weekday)} ${courseData['start']}-${courseData['end']}',
          'week_day': weekday,
          'start_time': courseData['start'],
          'end_time': courseData['end'],
          'course_id': 'sample_${courseData['name']}_$weekday',
          'description': '${courseData['name']}课程，教师：${courseData['teacher']}，地点：${courseData['classroom']}',
          'progress': 0,
          'status': 'pending',
          'priority': 'high',
          'tags': ['课程', '示例数据'],
          'is_sample': true, // 标记为示例数据
        });
      }
    }
    
    return courses;
  }
  
  /// 获取指定星期几对应的日期
  DateTime? _getDateForWeekday(DateTime startDate, DateTime endDate, int targetWeekday) {
    DateTime current = startDate;
    while (current.isBefore(endDate.add(Duration(days: 1)))) {
      if (current.weekday == targetWeekday) {
        return current;
      }
      current = current.add(Duration(days: 1));
    }
    return null;
  }
  
  /// 获取星期几的中文名称
  String _getWeekdayName(int weekday) {
    final weekdays = ['一', '二', '三', '四', '五', '六', '日'];
    if (weekday >= 1 && weekday <= 7) {
      return weekdays[weekday - 1];
    }
    return '';
  }
}