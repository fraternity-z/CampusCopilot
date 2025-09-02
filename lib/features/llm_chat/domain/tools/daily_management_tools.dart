
/// AI日常管理工具函数定义
/// 
/// 为AI提供与学生课程表和计划管理系统交互的函数调用接口
class DailyManagementTools {
  /// 获取所有可用的AI工具函数定义
  static List<Map<String, dynamic>> getFunctionDefinitions() {
    return [
      _getReadCourseScheduleDefinition(),
      _getCreateStudyPlanDefinition(),
      _getUpdatePlanDefinition(),
      _getDeletePlanDefinition(),
      _getGetPlansDefinition(),
      _getAnalyzeCourseWorkloadDefinition(),
    ];
  }

  /// 读取课程表函数定义
  static Map<String, dynamic> _getReadCourseScheduleDefinition() {
    return {
      "name": "read_course_schedule",
      "description": "读取学生的课程表信息，获取指定日期范围内的所有课程安排",
      "parameters": {
        "type": "object",
        "properties": {
          "start_date": {
            "type": "string",
            "format": "date",
            "description": "开始日期，格式：YYYY-MM-DD，默认为今天"
          },
          "end_date": {
            "type": "string", 
            "format": "date",
            "description": "结束日期，格式：YYYY-MM-DD，默认为一周后"
          },
          "day_of_week": {
            "type": "integer",
            "minimum": 1,
            "maximum": 7,
            "description": "查询指定星期几的课程，1=周一，7=周日，不填则查询所有"
          }
        },
        "required": []
      }
    };
  }

  /// 创建学习计划函数定义
  static Map<String, dynamic> _getCreateStudyPlanDefinition() {
    return {
      "name": "create_study_plan",
      "description": "根据课程信息创建学习计划，支持单个计划或基于课程表批量生成",
      "parameters": {
        "type": "object",
        "properties": {
          "title": {
            "type": "string",
            "description": "计划标题，必填"
          },
          "description": {
            "type": "string",
            "description": "计划详细描述"
          },
          "plan_date": {
            "type": "string",
            "format": "date-time",
            "description": "计划执行日期，格式：YYYY-MM-DDTHH:mm:ss"
          },
          "type": {
            "type": "string",
            "enum": ["study", "work", "life", "other"],
            "description": "计划类型：study=学习，work=工作，life=生活，other=其他"
          },
          "priority": {
            "type": "integer",
            "minimum": 1,
            "maximum": 3,
            "description": "优先级：1=低，2=中，3=高"
          },
          "start_time": {
            "type": "string",
            "format": "date-time", 
            "description": "开始时间"
          },
          "end_time": {
            "type": "string",
            "format": "date-time",
            "description": "结束时间"
          },
          "course_id": {
            "type": "string",
            "description": "关联的课程ID"
          },
          "tags": {
            "type": "array",
            "items": {
              "type": "string"
            },
            "description": "计划标签列表"
          },
          "notes": {
            "type": "string",
            "description": "备注信息"
          }
        },
        "required": ["title", "plan_date"]
      }
    };
  }

  /// 更新计划函数定义
  static Map<String, dynamic> _getUpdatePlanDefinition() {
    return {
      "name": "update_study_plan",
      "description": "更新现有学习计划的信息，包括状态、进度、内容等",
      "parameters": {
        "type": "object",
        "properties": {
          "plan_id": {
            "type": "string",
            "description": "计划ID，必填"
          },
          "title": {
            "type": "string",
            "description": "新的计划标题"
          },
          "description": {
            "type": "string",
            "description": "新的计划描述"
          },
          "status": {
            "type": "string",
            "enum": ["pending", "in_progress", "completed", "cancelled"],
            "description": "计划状态：pending=待处理，in_progress=进行中，completed=已完成，cancelled=已取消"
          },
          "priority": {
            "type": "integer",
            "minimum": 1,
            "maximum": 3,
            "description": "优先级：1=低，2=中，3=高"
          },
          "progress": {
            "type": "integer",
            "minimum": 0,
            "maximum": 100,
            "description": "完成进度百分比"
          },
          "notes": {
            "type": "string",
            "description": "备注信息"
          }
        },
        "required": ["plan_id"]
      }
    };
  }

  /// 删除计划函数定义
  static Map<String, dynamic> _getDeletePlanDefinition() {
    return {
      "name": "delete_study_plan",
      "description": "删除指定的学习计划",
      "parameters": {
        "type": "object",
        "properties": {
          "plan_id": {
            "type": "string",
            "description": "要删除的计划ID，必填"
          }
        },
        "required": ["plan_id"]
      }
    };
  }

  /// 查询计划函数定义
  static Map<String, dynamic> _getGetPlansDefinition() {
    return {
      "name": "get_study_plans",
      "description": "查询学习计划，支持多种筛选条件",
      "parameters": {
        "type": "object",
        "properties": {
          "status": {
            "type": "string",
            "enum": ["pending", "in_progress", "completed", "cancelled"],
            "description": "按状态筛选"
          },
          "type": {
            "type": "string",
            "enum": ["study", "work", "life", "other"],
            "description": "按类型筛选"
          },
          "priority": {
            "type": "integer",
            "minimum": 1,
            "maximum": 3,
            "description": "按优先级筛选"
          },
          "start_date": {
            "type": "string",
            "format": "date",
            "description": "计划日期范围开始"
          },
          "end_date": {
            "type": "string",
            "format": "date",
            "description": "计划日期范围结束"
          },
          "search_query": {
            "type": "string",
            "description": "搜索关键词，会在标题、描述、标签中查找"
          },
          "limit": {
            "type": "integer",
            "minimum": 1,
            "maximum": 100,
            "description": "返回结果数量限制，默认20"
          }
        },
        "required": []
      }
    };
  }

  /// 分析课程工作量函数定义
  static Map<String, dynamic> _getAnalyzeCourseWorkloadDefinition() {
    return {
      "name": "analyze_course_workload",
      "description": "分析学生的课程安排和学习负担，提供时间管理建议",
      "parameters": {
        "type": "object", 
        "properties": {
          "start_date": {
            "type": "string",
            "format": "date",
            "description": "分析开始日期"
          },
          "end_date": {
            "type": "string",
            "format": "date", 
            "description": "分析结束日期"
          },
          "include_plans": {
            "type": "boolean",
            "description": "是否包含现有计划在分析中，默认true"
          }
        },
        "required": []
      }
    };
  }

  /// 验证函数名称是否有效
  static bool isValidFunctionName(String functionName) {
    final validFunctions = {
      'read_course_schedule',
      'create_study_plan', 
      'update_study_plan',
      'delete_study_plan',
      'get_study_plans',
      'analyze_course_workload'
    };
    return validFunctions.contains(functionName);
  }

  /// 获取函数说明
  static String getFunctionDescription(String functionName) {
    final descriptions = {
      'read_course_schedule': '读取课程表信息',
      'create_study_plan': '创建学习计划',
      'update_study_plan': '更新学习计划',
      'delete_study_plan': '删除学习计划', 
      'get_study_plans': '查询学习计划',
      'analyze_course_workload': '分析课程工作量'
    };
    return descriptions[functionName] ?? '未知函数';
  }
}

/// AI工具函数调用结果
class FunctionCallResult {
  final bool success;
  final dynamic data;
  final String? error;
  final String? message;

  const FunctionCallResult({
    required this.success,
    this.data,
    this.error,
    this.message,
  });

  factory FunctionCallResult.success({dynamic data, String? message}) {
    return FunctionCallResult(
      success: true,
      data: data,
      message: message,
    );
  }

  factory FunctionCallResult.failure({required String error}) {
    return FunctionCallResult(
      success: false,
      error: error,
    );
  }

  /// 转换为JSON格式，用于AI响应
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'error': error,
      'message': message,
    };
  }
}

/// 函数调用参数验证错误
class FunctionCallValidationException implements Exception {
  final String message;
  final String functionName;
  final Map<String, dynamic>? invalidParams;

  const FunctionCallValidationException({
    required this.message,
    required this.functionName,
    this.invalidParams,
  });

  @override
  String toString() => 'FunctionCallValidationException: $message (function: $functionName)';
}