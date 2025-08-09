import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../settings/domain/entities/search_config.dart';
import '../web_search_strategy.dart';

/// 轻量封装 Tavily 搜索（保持与现有实现一致的输出结构）
class TavilySearchStrategy implements WebSearchStrategy {
  final String apiKey;

  TavilySearchStrategy(this.apiKey);

  @override
  String get id => 'tavily';

  @override
  String get label => 'Tavily (API)';

  @override
  Future<SearchResult> query(
    String userQuery, {
    required WebSearchOptions options,
  }) async {
    final start = DateTime.now();
    try {
      if (apiKey.isEmpty) {
        throw Exception('Tavily API 密钥未配置');
      }

      final url = Uri.parse('https://api.tavily.com/search');
      final body = {
        'query': userQuery,
        'max_results': options.maxResults,
        'search_depth': 'basic',
        'include_answer': true,
        'include_images': false,
        'include_raw_content': false,
        'format_output': false,
      };

      final resp = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (resp.statusCode != 200) {
        throw Exception('Tavily 请求失败: ${resp.statusCode} - ${resp.body}');
      }

      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = <SearchResultItem>[];
      if (data['results'] is List) {
        for (final r in (data['results'] as List)) {
          if (r is Map<String, dynamic>) {
            results.add(
              SearchResultItem(
                title: r['title'] ?? '',
                link: r['url'] ?? '',
                snippet: r['content'] ?? '',
                contentType: 'webpage',
                relevanceScore: (r['score'] as num?)?.toDouble() ?? 0.0,
                metadata: {
                  'favicon': r['favicon'],
                  'published_date': r['published_date'],
                },
              ),
            );
          }
        }
      }

      if (data['answer'] != null && data['answer'].toString().isNotEmpty) {
        results.insert(
          0,
          const SearchResultItem(
            title: 'Tavily AI 摘要',
            link: 'https://tavily.com',
            snippet: '（由 Tavily 生成的摘要，详见来源）',
            contentType: 'ai_answer',
            relevanceScore: 1.0,
          ),
        );
      }

      return SearchResult(
        query: userQuery,
        items: results,
        searchTime: DateTime.now().difference(start).inMilliseconds,
        engine: 'tavily',
        totalResults: results.length,
      );
    } catch (e) {
      return SearchResult(
        query: userQuery,
        items: const [],
        searchTime: DateTime.now().difference(start).inMilliseconds,
        engine: 'tavily',
        error: e.toString(),
      );
    }
  }
}
