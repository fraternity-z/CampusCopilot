import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../settings/domain/entities/search_config.dart';
import '../web_search_strategy.dart';

/// 直接检索策略（通过后端 orchestrator 聚合多个搜索引擎与页面抓取）
///
/// - 支持按引擎并行搜索（google/bing/baidu/searxng/exa/bocha ...）
/// - 支持将自然语言查询分解为多个关键词/子查询（由后端处理或本地简单拆分）
class DirectEngineSearchStrategy implements WebSearchStrategy {
  final String orchestratorEndpoint;

  DirectEngineSearchStrategy(this.orchestratorEndpoint)
    : assert(orchestratorEndpoint.isNotEmpty);

  @override
  String get id => 'direct_engine';

  @override
  String get label => 'Direct (Engines)';

  @override
  Future<SearchResult> query(
    String userQuery, {
    required WebSearchOptions options,
  }) async {
    final start = DateTime.now();
    try {
      final engines = options.engines.isEmpty ? ['google'] : options.engines;

      // 关键词分解：简单规则先行，复杂版本可交给后端或 LLM 扩展
      final List<String> subQueries = options.enableQueryDecomposition
          ? _decomposeQuery(userQuery)
          : [userQuery];

      final uri = Uri.parse('$orchestratorEndpoint/search');
      final payload = {
        'query': userQuery,
        'subQueries': subQueries,
        'engines': engines,
        'maxResults': options.maxResults,
        'language': options.language,
        'region': options.region,
      };

      final resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 20));

      if (resp.statusCode != 200) {
        throw Exception('orchestrator 请求失败: ${resp.statusCode} - ${resp.body}');
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final List<SearchResultItem> items = [];
      if (data['results'] is List) {
        for (final r in (data['results'] as List)) {
          if (r is Map<String, dynamic>) {
            items.add(
              SearchResultItem(
                title: r['title'] ?? '',
                link: r['url'] ?? '',
                snippet: r['snippet'] ?? (r['extracted_text'] ?? ''),
                displayLink: r['displayLink'],
                thumbnail: r['favicon'],
                publishTime: r['publishedAt'] != null
                    ? DateTime.tryParse(r['publishedAt'])
                    : null,
                contentType: r['contentType'] ?? 'webpage',
                relevanceScore: (r['score'] as num?)?.toDouble() ?? 0.0,
                metadata: {'engine': r['engine'], 'favicon': r['favicon']},
              ),
            );
          }
        }
      }

      return SearchResult(
        query: userQuery,
        items: items,
        searchTime: DateTime.now().difference(start).inMilliseconds,
        engine: 'direct',
        totalResults: items.length,
      );
    } catch (e) {
      return SearchResult(
        query: userQuery,
        items: const [],
        searchTime: DateTime.now().difference(start).inMilliseconds,
        engine: 'direct',
        error: e.toString(),
      );
    }
  }

  List<String> _decomposeQuery(String query) {
    final normalized = query
        .replaceAll(RegExp(r'[\u3002\uff1f\uff01,;\n]'), ' ')
        .trim();
    // 简易规则：按空格与停用词切分，过滤长度过短词，保留原句兜底
    final words = normalized.split(RegExp(r'\s+'));
    final stop = <String>{'的', '了', '和', '与', '以及', 'the', 'a', 'of', 'to'};
    final tokens = words
        .where((w) => w.length >= 2 && !stop.contains(w.toLowerCase()))
        .toList();
    final unique = <String>{...tokens};
    final sub = unique.take(6).toList();
    if (!sub.contains(query)) sub.add(query);
    return sub;
  }
}
