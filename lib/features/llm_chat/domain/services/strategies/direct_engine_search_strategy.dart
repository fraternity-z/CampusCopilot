import '../../../../settings/domain/entities/search_config.dart';
import '../web_search_strategy.dart';

/// 直接检索策略（历史实现：通过后端 orchestrator 聚合）。
/// 现已废弃，返回占位错误，提示使用 `AISearchIntegrationService` 的轻量抓取。
class DirectEngineSearchStrategy implements WebSearchStrategy {
  final String orchestratorEndpoint;

  DirectEngineSearchStrategy(this.orchestratorEndpoint);

  @override
  String get id => 'direct_engine';

  @override
  String get label => 'Direct (Engines)';

  @override
  Future<SearchResult> query(
    String userQuery, {
    required WebSearchOptions options,
  }) async {
    return SearchResult(
      query: userQuery,
      items: const [],
      searchTime: 0,
      engine: 'direct',
      error:
          'DirectEngineSearchStrategy 已废弃，请改用轻量抓取 (AISearchIntegrationService)',
    );
  }

  // 已废弃的辅助函数
}
