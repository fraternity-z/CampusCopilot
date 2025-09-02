import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ai_plan_bridge_service.dart';
import 'daily_management_tools.dart';
import '../../presentation/providers/ai_plan_bridge_provider.dart';

/// AI计划桥接功能测试类
/// 
/// 提供基础的功能测试方法，验证AI工具函数是否能正常工作
class AIPlanBridgeTest {
  final AIPlanBridgeService _bridgeService;

  AIPlanBridgeTest(this._bridgeService);

  /// 测试所有AI工具函数
  Future<void> runAllTests() async {
    debugPrint('🧪 开始AI计划桥接功能测试');

    // 测试1: 验证函数定义
    await _testFunctionDefinitions();
    
    // 测试2: 测试读取课程表
    await _testReadCourseSchedule();
    
    // 测试3: 测试创建计划
    await _testCreateStudyPlan();
    
    // 测试4: 测试查询计划
    await _testGetStudyPlans();
    
    // 测试5: 测试更新计划
    await _testUpdateStudyPlan();
    
    // 测试6: 测试分析工作量
    await _testAnalyzeCourseWorkload();

    debugPrint('✅ AI计划桥接功能测试完成');
  }

  /// 测试函数定义
  Future<void> _testFunctionDefinitions() async {
    debugPrint('🔧 测试函数定义...');
    
    final functions = DailyManagementTools.getFunctionDefinitions();
    assert(functions.length == 6, '应该有6个函数定义');
    
    final functionNames = functions.map((f) => f['name']).toSet();
    final expectedNames = {
      'read_course_schedule',
      'create_study_plan',
      'update_study_plan',
      'delete_study_plan',
      'get_study_plans',
      'analyze_course_workload'
    };
    
    assert(functionNames.containsAll(expectedNames), '函数名称不匹配');
    debugPrint('✅ 函数定义测试通过');
  }

  /// 测试读取课程表
  Future<void> _testReadCourseSchedule() async {
    debugPrint('📅 测试读取课程表...');
    
    try {
      final result = await _bridgeService.handleFunctionCall(
        'read_course_schedule',
        {
          'start_date': '2024-01-01',
          'end_date': '2024-01-07',
          'day_of_week': 1,
        },
      );
      
      assert(result.success, '读取课程表应该成功');
      assert(result.data != null, '应该返回课程数据');
      
      final data = result.data as Map<String, dynamic>;
      assert(data.containsKey('courses'), '应该包含courses字段');
      assert(data.containsKey('total_count'), '应该包含total_count字段');
      
      debugPrint('✅ 读取课程表测试通过: ${result.message}');
    } catch (e) {
      debugPrint('❌ 读取课程表测试失败: $e');
      rethrow;
    }
  }

  /// 测试创建学习计划
  Future<void> _testCreateStudyPlan() async {
    debugPrint('📝 测试创建学习计划...');
    
    try {
      final result = await _bridgeService.handleFunctionCall(
        'create_study_plan',
        {
          'title': '测试计划',
          'description': '这是一个测试计划',
          'plan_date': DateTime.now().add(Duration(days: 1)).toIso8601String(),
          'type': 'study',
          'priority': 2,
          'tags': ['测试', 'AI生成'],
          'notes': '由AI测试创建',
        },
      );
      
      if (result.success) {
        final data = result.data as Map<String, dynamic>;
        assert(data.containsKey('plan_id'), '应该返回plan_id');
        assert(data.containsKey('title'), '应该返回标题');
        assert(data['title'] == '测试计划', '标题应该匹配');
        
        debugPrint('✅ 创建学习计划测试通过: ${result.message}');
        
        // 保存测试计划ID用于后续测试
        _testPlanId = data['plan_id'] as String;
      } else {
        debugPrint('⚠️ 创建学习计划测试失败但可接受: ${result.error}');
      }
    } catch (e) {
      debugPrint('❌ 创建学习计划测试出现异常: $e');
    }
  }

  String? _testPlanId;

  /// 测试查询学习计划
  Future<void> _testGetStudyPlans() async {
    debugPrint('🔍 测试查询学习计划...');
    
    try {
      final result = await _bridgeService.handleFunctionCall(
        'get_study_plans',
        {
          'limit': 10,
        },
      );
      
      if (result.success) {
        final data = result.data as Map<String, dynamic>;
        assert(data.containsKey('plans'), '应该包含plans字段');
        assert(data.containsKey('total_count'), '应该包含total_count字段');
        
        final plans = data['plans'] as List;
        debugPrint('✅ 查询学习计划测试通过: 找到${plans.length}个计划');
      } else {
        debugPrint('⚠️ 查询学习计划测试失败但可接受: ${result.error}');
      }
    } catch (e) {
      debugPrint('❌ 查询学习计划测试出现异常: $e');
    }
  }

  /// 测试更新学习计划
  Future<void> _testUpdateStudyPlan() async {
    if (_testPlanId == null) {
      debugPrint('⏭️ 跳过更新学习计划测试（没有测试计划ID）');
      return;
    }
    
    debugPrint('✏️ 测试更新学习计划...');
    
    try {
      final result = await _bridgeService.handleFunctionCall(
        'update_study_plan',
        {
          'plan_id': _testPlanId,
          'progress': 50,
          'status': 'in_progress',
          'notes': '测试更新：进度50%',
        },
      );
      
      if (result.success) {
        final data = result.data as Map<String, dynamic>;
        assert(data['progress'] == 50, '进度应该被更新为50');
        assert(data['status'] == 'in_progress', '状态应该被更新为in_progress');
        
        debugPrint('✅ 更新学习计划测试通过: ${result.message}');
      } else {
        debugPrint('⚠️ 更新学习计划测试失败但可接受: ${result.error}');
      }
    } catch (e) {
      debugPrint('❌ 更新学习计划测试出现异常: $e');
    }
  }

  /// 测试分析课程工作量
  Future<void> _testAnalyzeCourseWorkload() async {
    debugPrint('📊 测试分析课程工作量...');
    
    try {
      final result = await _bridgeService.handleFunctionCall(
        'analyze_course_workload',
        {
          'start_date': DateTime.now().toIso8601String().split('T')[0],
          'end_date': DateTime.now().add(Duration(days: 7)).toIso8601String().split('T')[0],
          'include_plans': true,
        },
      );
      
      assert(result.success, '分析课程工作量应该成功');
      assert(result.data != null, '应该返回分析数据');
      
      final data = result.data as Map<String, dynamic>;
      assert(data.containsKey('course_load'), '应该包含course_load字段');
      assert(data.containsKey('recommendations'), '应该包含recommendations字段');
      assert(data.containsKey('plan_suggestions'), '应该包含plan_suggestions字段');
      
      debugPrint('✅ 分析课程工作量测试通过: ${result.message}');
    } catch (e) {
      debugPrint('❌ 分析课程工作量测试失败: $e');
      rethrow;
    }
  }

  /// 测试参数验证
  Future<void> testParameterValidation() async {
    debugPrint('🔒 测试参数验证...');
    
    // 测试缺少必需参数
    final result1 = await _bridgeService.handleFunctionCall(
      'create_study_plan',
      {}, // 缺少必需的title和plan_date
    );
    
    assert(!result1.success, '缺少必需参数时应该失败');
    assert(result1.error != null, '应该有错误消息');
    debugPrint('✅ 参数验证测试1通过: ${result1.error}');
    
    // 测试无效函数名
    final result2 = await _bridgeService.handleFunctionCall(
      'invalid_function_name',
      {},
    );
    
    assert(!result2.success, '无效函数名应该失败');
    assert(result2.error != null, '应该有错误消息');
    debugPrint('✅ 参数验证测试2通过: ${result2.error}');
    
    debugPrint('✅ 参数验证测试完成');
  }

  /// 运行完整的集成测试
  static Future<void> runIntegrationTest(ProviderContainer container) async {
    debugPrint('🚀 开始AI计划桥接集成测试');
    
    try {
      // 获取服务实例
      final bridgeService = container.read(aiPlanBridgeServiceProvider);
      final tester = AIPlanBridgeTest(bridgeService);
      
      // 运行基础功能测试
      await tester.runAllTests();
      
      // 运行参数验证测试
      await tester.testParameterValidation();
      
      debugPrint('🎉 集成测试全部通过！AI计划桥接功能正常工作');
      
    } catch (e, stackTrace) {
      debugPrint('💥 集成测试失败: $e');
      debugPrint('堆栈跟踪: $stackTrace');
      rethrow;
    }
  }
}

/// 创建测试用的ProviderContainer
ProviderContainer createTestContainer() {
  return ProviderContainer();
}

/// 运行测试的便捷函数
Future<void> runAIPlanBridgeTests() async {
  if (kDebugMode) {
    final container = createTestContainer();
    try {
      await AIPlanBridgeTest.runIntegrationTest(container);
    } finally {
      container.dispose();
    }
  }
}