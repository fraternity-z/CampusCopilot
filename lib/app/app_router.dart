import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/utils/debug_log.dart';

import '../shared/widgets/keyboard_dismissible_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'constants/ui_constants.dart';
import 'navigation/sidebar_container.dart';
import 'navigation/assistants_tab.dart';
import 'navigation/topics_tab.dart';
import 'navigation/settings_tab.dart';

import '../features/llm_chat/presentation/views/chat_screen.dart';
import '../features/settings/presentation/views/settings_screen.dart';
import '../features/settings/presentation/views/general_settings_screen.dart';
import '../features/settings/presentation/views/search_settings_screen.dart';
import '../features/settings/presentation/views/appearance_settings_screen.dart';
import '../features/settings/presentation/views/data_management_screen.dart';
import '../features/settings/presentation/views/about_screen.dart';
import '../features/settings/presentation/views/model_management_screen.dart';
import '../features/settings/presentation/views/provider_config_screen.dart';
import '../features/settings/presentation/providers/ui_settings_provider.dart';
import '../features/knowledge_base/presentation/views/knowledge_base_screen.dart';
import '../features/learning_mode/presentation/views/learning_mode_settings_screen.dart';
import '../features/daily_management/presentation/views/daily_dashboard_screen.dart';

/// 侧边栏标签页状态管理
final sidebarTabProvider = StateProvider<SidebarTab>(
  (ref) => SidebarTab.assistants,
);

/// 模型参数设置状态管理
class ModelParameters {
  final double temperature;
  final double maxTokens;
  // 移除 Top-P，避免与部分模型不兼容
  final double contextLength;
  final bool enableMaxTokens;
  // 新增：思考强度与最大思考token设置
  // reasoningEffort: 'auto' | 'low' | 'medium' | 'high'
  final String reasoningEffort;
  final int maxReasoningTokens;

  const ModelParameters({
    this.temperature = 0.7,
    this.maxTokens = 2048,
    // 移除 Top-P 默认值
    this.contextLength = 6, // 初始默认值
    this.enableMaxTokens = true,
    this.reasoningEffort = 'auto',
    this.maxReasoningTokens = 2000,
  });

  ModelParameters copyWith({
    double? temperature,
    double? maxTokens,
    // 移除 Top-P 参数
    double? contextLength,
    bool? enableMaxTokens,
    String? reasoningEffort,
    int? maxReasoningTokens,
  }) {
    return ModelParameters(
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      // 移除 Top-P 写入
      contextLength: contextLength ?? this.contextLength,
      enableMaxTokens: enableMaxTokens ?? this.enableMaxTokens,
      reasoningEffort: reasoningEffort ?? this.reasoningEffort,
      maxReasoningTokens: maxReasoningTokens ?? this.maxReasoningTokens,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'maxTokens': maxTokens,
      // 移除 Top-P 持久化
      'contextLength': contextLength,
      'enableMaxTokens': enableMaxTokens,
      // 兼容：持久化 off/auto/low/medium/high
      'reasoningEffort': reasoningEffort,
      'maxReasoningTokens': maxReasoningTokens,
    };
  }

  /// 从JSON创建实例
  factory ModelParameters.fromJson(Map<String, dynamic> json) {
    return ModelParameters(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['maxTokens'] as num?)?.toDouble() ?? 2048,
      // 移除 Top-P 读取
      contextLength: (json['contextLength'] as num?)?.toDouble() ?? 6,
      enableMaxTokens: json['enableMaxTokens'] as bool? ?? true,
      reasoningEffort: (json['reasoningEffort'] as String?) ?? 'auto',
      maxReasoningTokens: (json['maxReasoningTokens'] as int?) ?? 2000,
    );
  }
}

/// 模型参数状态管理器
class ModelParametersNotifier extends StateNotifier<ModelParameters> {
  ModelParametersNotifier() : super(const ModelParameters()) {
    _loadParameters();
  }

  /// 加载参数
  Future<void> _loadParameters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final parametersJson = prefs.getString('model_parameters');

      if (parametersJson != null) {
        final parametersMap =
            json.decode(parametersJson) as Map<String, dynamic>;
        state = ModelParameters.fromJson(parametersMap);
        debugLog(() =>'📊 模型参数已加载: ${state.toJson()}');
      }
    } catch (e) {
      debugLog(() =>'❌ 加载模型参数失败: $e');
    }
  }

  /// 保存参数
  Future<void> _saveParameters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final parametersJson = json.encode(state.toJson());
      await prefs.setString('model_parameters', parametersJson);
      debugLog(() =>'💾 模型参数已保存: ${state.toJson()}');
    } catch (e) {
      debugLog(() =>'❌ 保存模型参数失败: $e');
    }
  }

  /// 更新温度
  Future<void> updateTemperature(double temperature) async {
    state = state.copyWith(temperature: temperature);
    await _saveParameters();
  }

  /// 更新最大Token数
  Future<void> updateMaxTokens(double maxTokens) async {
    state = state.copyWith(maxTokens: maxTokens);
    await _saveParameters();
  }

  /// 更新Top-P
  // 移除 Top-P 更新方法

  /// 更新上下文长度
  Future<void> updateContextLength(double contextLength) async {
    state = state.copyWith(contextLength: contextLength);
    await _saveParameters();
  }

  /// 更新是否启用最大Token限制
  Future<void> updateEnableMaxTokens(bool enableMaxTokens) async {
    state = state.copyWith(enableMaxTokens: enableMaxTokens);
    await _saveParameters();
  }

  /// 更新思考强度（支持 off/auto/low/medium/high）
  Future<void> updateReasoningEffort(String effort) async {
    // 容错：未知值时回退 auto
    final allowed = {'off', 'auto', 'low', 'medium', 'high'};
    final next = allowed.contains(effort) ? effort : 'auto';
    state = state.copyWith(reasoningEffort: next);
    await _saveParameters();
  }

  /// 更新最大思考token
  Future<void> updateMaxReasoningTokens(int value) async {
    state = state.copyWith(maxReasoningTokens: value);
    await _saveParameters();
  }

  /// 重置参数
  Future<void> resetParameters() async {
    state = const ModelParameters();
    await _saveParameters();
  }
}

final modelParametersProvider =
    StateNotifierProvider<ModelParametersNotifier, ModelParameters>((ref) {
      return ModelParametersNotifier();
    });

/// 代码块设置状态管理
class CodeBlockSettings {
  final bool enableCodeEditing;
  final bool enableLineNumbers;
  final bool enableCodeFolding;
  final bool enableCodeWrapping;
  final bool defaultCollapseCodeBlocks;
  final double? maxCodeBlockHeight;

  const CodeBlockSettings({
    this.enableCodeEditing = true,
    this.enableLineNumbers = true,
    this.enableCodeFolding = true,
    this.enableCodeWrapping = true,
    this.defaultCollapseCodeBlocks = false,
    this.maxCodeBlockHeight = 600,
  });

  CodeBlockSettings copyWith({
    bool? enableCodeEditing,
    bool? enableLineNumbers,
    bool? enableCodeFolding,
    bool? enableCodeWrapping,
    bool? defaultCollapseCodeBlocks,
    double? maxCodeBlockHeight,
  }) {
    return CodeBlockSettings(
      enableCodeEditing: enableCodeEditing ?? this.enableCodeEditing,
      enableLineNumbers: enableLineNumbers ?? this.enableLineNumbers,
      enableCodeFolding: enableCodeFolding ?? this.enableCodeFolding,
      enableCodeWrapping: enableCodeWrapping ?? this.enableCodeWrapping,
      defaultCollapseCodeBlocks:
          defaultCollapseCodeBlocks ?? this.defaultCollapseCodeBlocks,
      maxCodeBlockHeight: maxCodeBlockHeight ?? this.maxCodeBlockHeight,
    );
  }
}

final codeBlockSettingsProvider = StateProvider<CodeBlockSettings>((ref) {
  return const CodeBlockSettings();
});

/// 常规设置状态管理
class GeneralSettings {
  final bool enableMarkdownRendering;
  final bool enableAutoSave;
  final bool enableNotifications;
  final String language;
  final String mathEngine;

  const GeneralSettings({
    this.enableMarkdownRendering = true,
    this.enableAutoSave = true,
    this.enableNotifications = true,
    this.language = 'zh-CN',
    this.mathEngine = 'katex',
  });

  GeneralSettings copyWith({
    bool? enableMarkdownRendering,
    bool? enableAutoSave,
    bool? enableNotifications,
    String? language,
    String? mathEngine,
  }) {
    return GeneralSettings(
      enableMarkdownRendering:
          enableMarkdownRendering ?? this.enableMarkdownRendering,
      enableAutoSave: enableAutoSave ?? this.enableAutoSave,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      language: language ?? this.language,
      mathEngine: mathEngine ?? this.mathEngine,
    );
  }
}

final generalSettingsProvider = StateProvider<GeneralSettings>((ref) {
  return const GeneralSettings();
});

/// 侧边栏折叠状态管理
final sidebarModelParamsExpandedProvider = StateProvider<bool>((ref) => false);
final sidebarCodeBlockExpandedProvider = StateProvider<bool>((ref) => false);
final sidebarGeneralExpandedProvider = StateProvider<bool>((ref) => false);

/// 应用路由配置
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/chat',
    debugLogDiagnostics: true,
    routes: [
      // Shell路由 - 提供统一的导航框架
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // LLM聊天功能
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),

          // 日常管理
          GoRoute(
            path: '/daily',
            name: 'daily',
            builder: (context, state) => const DailyDashboardScreen(),
          ),

          // 知识库
          GoRoute(
            path: '/knowledge',
            name: 'knowledge',
            builder: (context, state) => const KnowledgeBaseScreen(),
          ),

          // 设置
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              // 常规设置
              GoRoute(
                path: 'general',
                name: 'general-settings',
                builder: (context, state) => const GeneralSettingsScreen(),
              ),
              // AI 搜索设置
              GoRoute(
                path: 'search',
                name: 'search-settings',
                builder: (context, state) => const SearchSettingsScreen(),
              ),
              // 模型管理
              GoRoute(
                path: 'models',
                name: 'model-management',
                builder: (context, state) => const ModelManagementScreen(),
                routes: [
                  GoRoute(
                    path: 'provider/:providerId',
                    name: 'provider-config',
                    builder: (context, state) {
                      final providerId = state.pathParameters['providerId']!;
                      return ProviderConfigScreen(providerId: providerId);
                    },
                  ),
                ],
              ),
              // 外观设置
              GoRoute(
                path: 'appearance',
                name: 'appearance-settings',
                builder: (context, state) => const AppearanceSettingsScreen(),
              ),
              // 学习模式设置
              GoRoute(
                path: 'learning-mode',
                name: 'learning-mode-settings',
                builder: (context, state) => const LearningModeSettingsScreen(),
              ),
              // 数据管理
              GoRoute(
                path: 'data',
                name: 'data-management',
                builder: (context, state) => const DataManagementScreen(),
              ),
              // 关于
              GoRoute(
                path: 'about',
                name: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // 错误页面
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

/// 主要的Shell布局，包含侧边栏导航
class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  bool _hasModalRoute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateModalRouteState();
    });
  }

  void _updateModalRouteState() {
    final newState = Navigator.of(context).canPop();
    if (newState != _hasModalRoute) {
      setState(() {
        _hasModalRoute = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);

    return KeyboardSafeWrapper(
      child: Scaffold(
        body: Stack(
          children: [
            widget.child,
            if (!isCollapsed) ...[
              const SidebarOverlay(),
              const NavigationSidebar(),
            ],
          ],
        ),
      ),
    );
  }
}

/// 侧边导航栏
class NavigationSidebar extends ConsumerWidget {
  const NavigationSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(sidebarTabProvider);

    return SidebarContainer(
      child: Column(
        children: [
          const SidebarHeader(),
          SidebarTabBar(
            selectedTab: selectedTab,
            onTabSelected: (tab) {
              ref.read(sidebarTabProvider.notifier).state = tab;
            },
          ),
          Expanded(child: _buildTabContent(selectedTab)),
        ],
      ),
    );
  }

  /// 构建标签页内容
  Widget _buildTabContent(SidebarTab selectedTab) {
    return IndexedStack(
      index: selectedTab.index,
      children: const [AssistantsTab(), TopicsTab(), SettingsTab()],
    );
  }
}

/// 错误页面
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('错误')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('页面加载失败', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? '未知错误',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
