import 'dart:convert';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import '../../../../settings/domain/entities/search_config.dart';

/// 轻量直接检索（无浏览器）
/// 注意：抗反爬能力弱，仅适合作为移动端应急方案
class LightweightDirectFetcher {
  static const _userAgent =
      'AnywhereChat/1.0 (Mobile Lightweight Fetcher; +https://example.com)';

  static Future<SearchResult> searchViaHttp(
    String query, {
    required List<String> engines,
    int maxResults = 5,
    String? language,
    String? region,
  }) async {
    final start = DateTime.now();
    final items = <SearchResultItem>[];

    // 简化：仅实现 Google/Bing 的公共 HTML 结果抓取（可能受限/不稳定）
    final used = engines.isEmpty ? ['google'] : engines;
    final perEngine = (maxResults / used.length).ceil();

    for (final engine in used) {
      try {
        final serp = await _fetchSerpHtml(engine, query, perEngine);
        items.addAll(serp);
      } catch (_) {
        // 忽略单引擎失败
      }
    }

    return SearchResult(
      query: query,
      items: items,
      searchTime: DateTime.now().difference(start).inMilliseconds,
      engine: 'lightweight',
      totalResults: items.length,
    );
  }

  static Future<List<SearchResultItem>> _fetchSerpHtml(
    String engine,
    String query,
    int maxResults,
  ) async {
    final q = Uri.encodeComponent(query);
    late Uri url;
    if (engine == 'google') {
      url = Uri.parse('https://www.google.com/search?q=$q');
    } else if (engine == 'bing') {
      url = Uri.parse('https://www.bing.com/search?q=$q');
    } else if (engine == 'baidu') {
      url = Uri.parse('https://www.baidu.com/s?wd=$q');
    } else {
      url = Uri.parse('https://duckduckgo.com/?q=$q');
    }

    final resp = await http
        .get(
          url,
          headers: {
            'User-Agent': _userAgent,
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (resp.statusCode != 200) return [];

    final doc = html_parser.parse(utf8.decode(resp.bodyBytes));
    final results = <SearchResultItem>[];

    if (engine == 'google') {
      final nodes = doc.querySelectorAll('a h3');
      for (final h3 in nodes) {
        if (results.length >= maxResults) break;
        final a = h3.parent;
        final href = a?.attributes['href'] ?? '';
        final title = h3.text.trim();
        if (href.isNotEmpty && title.isNotEmpty) {
          results.add(SearchResultItem(title: title, link: href, snippet: ''));
        }
      }
    } else if (engine == 'bing') {
      final nodes = doc.querySelectorAll('li.b_algo h2 a');
      for (final a in nodes) {
        if (results.length >= maxResults) break;
        final href = a.attributes['href'] ?? '';
        final title = a.text.trim();
        if (href.isNotEmpty && title.isNotEmpty) {
          results.add(SearchResultItem(title: title, link: href, snippet: ''));
        }
      }
    } else if (engine == 'baidu') {
      final nodes = doc.querySelectorAll(
        'div.result h3 a, div.c-container h3 a',
      );
      for (final a in nodes) {
        if (results.length >= maxResults) break;
        final href = a.attributes['href'] ?? '';
        final title = a.text.trim();
        if (href.isNotEmpty && title.isNotEmpty) {
          results.add(SearchResultItem(title: title, link: href, snippet: ''));
        }
      }
    }

    return results;
  }
}
