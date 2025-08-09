import '../../../settings/domain/entities/search_config.dart';

/// Web 联网搜索策略接口
///
/// 通过策略化的方式对接不同的联网路径：
/// - 模型内置联网（OpenAI/Gemini/Claude 等）
/// - 第三方 API（如 Tavily）
/// - 直接检索（通过后端 orchestrator 抓取真实 SERP 与正文）
abstract class WebSearchStrategy {
  /// 策略 ID（例如：'model_native' | 'tavily' | 'direct_engine'）
  String get id;

  /// 策略显示名称（用于 UI）
  String get label;

  /// 执行查询
  Future<SearchResult> query(
    String userQuery, {
    required WebSearchOptions options,
  });
}

/// 搜索选项（统一传递给各策略）
class WebSearchOptions {
  /// 使用的搜索引擎（direct 模式可包含多个，如 ['google','bing']）
  final List<String> engines;

  /// 期望最大结果数（每引擎、每子查询的上限，由策略自行约束）
  final int maxResults;

  /// 语言与地区
  final String? language;
  final String? region;

  /// 是否启用关键词分解与并行搜索
  final bool enableQueryDecomposition;

  /// orchestrator 地址（direct 策略使用）
  final String? orchestratorEndpoint;

  /// 自定义附加参数（供个别策略使用）
  final Map<String, dynamic>? extra;

  const WebSearchOptions({
    required this.engines,
    this.maxResults = 5,
    this.language,
    this.region,
    this.enableQueryDecomposition = true,
    this.orchestratorEndpoint,
    this.extra,
  });
}
