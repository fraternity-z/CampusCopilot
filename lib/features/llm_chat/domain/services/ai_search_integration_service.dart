import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../settings/domain/entities/search_config.dart';

/// AI搜索集成服务
///
/// 提供网络搜索功能，可以在对话中集成搜索结果
class AISearchIntegrationService {
  static const String _userAgent = 'AnywhereChat/1.0 (AI Assistant)';

  /// 执行AI增强搜索
  Future<AISearchResult> performAISearch({
    required String userQuery,
    int maxResults = 5,
    String? language,
    String? region,
    String engine = 'duckduckgo',
    String? apiKey, // 添加API密钥参数
    bool blacklistEnabled = false,
    List<Pattern>? blacklistPatterns,
  }) async {
    final startTime = DateTime.now();

    try {
      debugPrint('🔍 开始AI搜索: "$userQuery"');

      // 优化搜索查询
      final optimizedQuery = _optimizeQuery(userQuery);
      debugPrint('🔍 优化后查询: "$optimizedQuery"');

      // 根据引擎执行搜索
      SearchResult searchResult;
      switch (engine.toLowerCase()) {
        case 'tavily':
          searchResult = await _searchTavily(
            optimizedQuery,
            maxResults: maxResults,
            apiKey: apiKey,
          );
          break;
        case 'duckduckgo':
          searchResult = await _searchDuckDuckGo(
            optimizedQuery,
            maxResults: maxResults,
          );
          break;
        case 'google':
          searchResult = await _searchGoogle(
            optimizedQuery,
            maxResults: maxResults,
            language: language,
            region: region,
          );
          break;
        case 'bing':
          searchResult = await _searchBing(
            optimizedQuery,
            maxResults: maxResults,
          );
          break;
        default:
          throw Exception('不支持的搜索引擎: $engine');
      }

      if (!searchResult.isSuccess) {
        debugPrint('❌ 搜索失败: ${searchResult.error}');
        return AISearchResult(
          originalQuery: userQuery,
          optimizedQuery: optimizedQuery,
          results: [],
          timestamp: startTime,
          engine: engine,
          error: searchResult.error,
        );
      }

      debugPrint('✅ 搜索成功，找到 ${searchResult.items.length} 个结果');

      // 过滤与排序（含黑名单）
      var processed = _filterAndRankResults(searchResult.items, userQuery);

      if (blacklistEnabled &&
          blacklistPatterns != null &&
          blacklistPatterns.isNotEmpty) {
        processed = _applyBlacklist(processed, blacklistPatterns);
      }

      // 提取相关主题
      final relatedTopics = _extractRelatedTopics(processed);

      return AISearchResult(
        originalQuery: userQuery,
        optimizedQuery: optimizedQuery,
        results: processed,
        relatedTopics: relatedTopics,
        timestamp: startTime,
        engine: engine,
      );
    } catch (e) {
      debugPrint('❌ AI搜索异常: $e');
      return AISearchResult(
        originalQuery: userQuery,
        optimizedQuery: null,
        results: [],
        timestamp: startTime,
        engine: engine,
        error: e.toString(),
      );
    }
  }

  /// 应用黑名单过滤
  List<SearchResultItem> _applyBlacklist(
    List<SearchResultItem> items,
    List<Pattern> patterns,
  ) {
    bool isBlocked(String url) {
      for (final p in patterns) {
        if (p is RegExp) {
          if (p.hasMatch(url)) return true;
        } else {
          final s = p.toString();
          if (url.contains(s)) return true;
        }
      }
      return false;
    }

    return items.where((e) => !isBlocked(e.link)).toList();
  }

  /// 格式化搜索结果为AI上下文
  String formatSearchResultsForAI(AISearchResult searchResult) {
    if (!searchResult.hasResults) {
      return '';
    }

    final buffer = StringBuffer();
    buffer.writeln('## 网络搜索结果');
    buffer.writeln('**搜索查询**: ${searchResult.originalQuery}');
    buffer.writeln('**搜索时间**: ${_formatDateTime(searchResult.timestamp)}');
    buffer.writeln('**搜索引擎**: ${searchResult.engine}');
    buffer.writeln();

    for (int i = 0; i < searchResult.results.length; i++) {
      final result = searchResult.results[i];
      buffer.writeln('### ${i + 1}. ${result.title}');
      buffer.writeln('**链接**: ${result.link}');
      buffer.writeln('**摘要**: ${result.snippet}');

      if (result.publishTime != null) {
        buffer.writeln('**发布时间**: ${_formatDateTime(result.publishTime!)}');
      }

      buffer.writeln();
    }

    if (searchResult.relatedTopics.isNotEmpty) {
      buffer.writeln('**相关主题**: ${searchResult.relatedTopics.join('、')}');
      buffer.writeln();
    }

    buffer.writeln('---');
    buffer.writeln('*请基于以上搜索结果和你的知识为用户提供准确、有用的回答。*');

    return buffer.toString();
  }

  /// 判断是否应该执行搜索
  bool shouldSearch(String userQuery) {
    // 检查查询长度
    if (userQuery.trim().length < 3) {
      return false;
    }

    // 排除简单问候语
    final greetings = [
      'hi',
      'hello',
      '你好',
      '嗨',
      'hey',
      '哈喽',
      'thanks',
      'thank you',
      '谢谢',
      '感谢',
      'bye',
      'goodbye',
      '再见',
      '拜拜',
    ];

    if (greetings.contains(userQuery.trim().toLowerCase())) {
      return false;
    }

    // 检查是否包含时间相关词汇（可能需要最新信息）
    final timeKeywords = [
      '最新',
      '今天',
      '现在',
      '当前',
      '最近',
      '今年',
      'latest',
      'today',
      'now',
      'current',
      'recent',
      '2024',
      '2025',
      'this year',
    ];

    final queryLower = userQuery.toLowerCase();
    for (final keyword in timeKeywords) {
      if (queryLower.contains(keyword)) {
        return true;
      }
    }

    // 检查是否包含事实性查询词汇
    final factualKeywords = [
      '什么是',
      '如何',
      '为什么',
      '在哪里',
      '谁是',
      'what is',
      'how to',
      'why',
      'where',
      'who is',
      '新闻',
      '价格',
      '股票',
      '天气',
      '汇率',
      'news',
      'price',
      'stock',
      'weather',
      'exchange rate',
    ];

    for (final keyword in factualKeywords) {
      if (queryLower.contains(keyword)) {
        return true;
      }
    }

    // 默认不搜索（避免过度搜索）
    return false;
  }

  /// 优化搜索查询
  String _optimizeQuery(String query) {
    // 移除常见的口语化表达
    var optimized = query
        .replaceAll(RegExp(r'请问|你知道|能告诉我|我想知道'), '')
        .replaceAll(RegExp(r'please|can you tell me|i want to know'), '')
        .trim();

    // 限制长度
    if (optimized.length > 100) {
      optimized = optimized.substring(0, 100);
    }

    return optimized.isEmpty ? query : optimized;
  }

  /// 使用Tavily搜索（高质量AI搜索）
  Future<SearchResult> _searchTavily(
    String query, {
    int maxResults = 5,
    String? apiKey,
  }) async {
    final startTime = DateTime.now();

    try {
      // 检查API密钥是否提供
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Tavily API密钥未配置');
      }

      debugPrint('🔍 开始Tavily搜索: "$query"');

      final url = Uri.parse('https://api.tavily.com/search');
      final requestBody = {
        'query': query,
        'max_results': maxResults,
        'search_depth': 'basic',
        'include_answer': true,
        'include_images': false,
        'include_raw_content': false,
        'format_output': false,
      };

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Tavily API请求失败: ${response.statusCode} - ${response.body}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = <SearchResultItem>[];

      // 解析搜索结果
      if (data['results'] is List) {
        final searchResults = data['results'] as List;
        for (final result in searchResults) {
          if (result is Map<String, dynamic>) {
            results.add(
              SearchResultItem(
                title: result['title'] ?? '',
                link: result['url'] ?? '',
                snippet: result['content'] ?? '',
                contentType: 'webpage',
                relevanceScore: (result['score'] as num?)?.toDouble() ?? 0.0,
                metadata: {
                  'favicon': result['favicon'],
                  'published_date': result['published_date'],
                  'raw_content': result['raw_content'],
                },
              ),
            );
          }
        }
      }

      // 添加AI答案作为特殊结果项
      if (data['answer'] != null && data['answer'].toString().isNotEmpty) {
        results.insert(
          0,
          SearchResultItem(
            title: 'Tavily AI 摘要',
            link: 'https://tavily.com',
            snippet: data['answer'],
            contentType: 'ai_answer',
            relevanceScore: 1.0,
          ),
        );
      }

      debugPrint('✅ Tavily搜索成功，找到 ${results.length} 个结果');

      return SearchResult(
        query: query,
        items: results,
        searchTime: DateTime.now().difference(startTime).inMilliseconds,
        engine: 'tavily',
        totalResults: results.length,
      );
    } catch (e) {
      debugPrint('❌ Tavily搜索失败: $e');
      return SearchResult(
        query: query,
        items: [],
        searchTime: DateTime.now().difference(startTime).inMilliseconds,
        engine: 'tavily',
        error: e.toString(),
      );
    }
  }

  /// 使用DuckDuckGo搜索（免费，无需API密钥）
  Future<SearchResult> _searchDuckDuckGo(
    String query, {
    int maxResults = 5,
  }) async {
    final startTime = DateTime.now();

    try {
      // DuckDuckGo Instant Answer API
      final url = Uri.parse('https://api.duckduckgo.com/').replace(
        queryParameters: {
          'q': query,
          'format': 'json',
          'no_html': '1',
          'skip_disambig': '1',
          'no_redirect': '1',
        },
      );

      final response = await http
          .get(
            url,
            headers: {'User-Agent': _userAgent, 'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('DuckDuckGo API请求失败: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = <SearchResultItem>[];

      // 处理直接答案
      if (data['Abstract'] != null && data['Abstract'].toString().isNotEmpty) {
        results.add(
          SearchResultItem(
            title: data['Heading'] ?? 'DuckDuckGo摘要',
            link: data['AbstractURL'] ?? 'https://duckduckgo.com',
            snippet: data['Abstract'],
            displayLink: data['AbstractSource'] ?? 'DuckDuckGo',
            contentType: 'abstract',
          ),
        );
      }

      // 处理相关主题
      if (data['RelatedTopics'] is List) {
        final topics = data['RelatedTopics'] as List;
        for (final topic in topics.take(maxResults - results.length)) {
          if (topic is Map<String, dynamic> && topic['Text'] != null) {
            results.add(
              SearchResultItem(
                title: topic['Text'].toString().split(' - ').first,
                link: topic['FirstURL'] ?? 'https://duckduckgo.com',
                snippet: topic['Text'],
                contentType: 'topic',
              ),
            );
          }
        }
      }

      // 如果没有结果，尝试备用搜索
      if (results.isEmpty) {
        return await _fallbackSearch(query, maxResults: maxResults);
      }

      return SearchResult(
        query: query,
        items: results,
        searchTime: DateTime.now().difference(startTime).inMilliseconds,
        engine: 'duckduckgo',
      );
    } catch (e) {
      debugPrint('❌ DuckDuckGo搜索失败: $e');
      return SearchResult(
        query: query,
        items: [],
        searchTime: DateTime.now().difference(startTime).inMilliseconds,
        engine: 'duckduckgo',
        error: e.toString(),
      );
    }
  }

  /// 备用搜索（模拟搜索结果）
  Future<SearchResult> _fallbackSearch(
    String query, {
    int maxResults = 5,
  }) async {
    // 生成一些模拟搜索结果
    final results = <SearchResultItem>[
      SearchResultItem(
        title: '关于"$query"的相关信息',
        link: 'https://example.com/search?q=${Uri.encodeComponent(query)}',
        snippet: '很抱歉，无法从网络获取最新信息。建议您通过搜索引擎查询"$query"获取最新资讯。',
        contentType: 'fallback',
      ),
    ];

    return SearchResult(
      query: query,
      items: results,
      searchTime: 100,
      engine: 'fallback',
    );
  }

  /// Google搜索（需要API密钥）
  Future<SearchResult> _searchGoogle(
    String query, {
    int maxResults = 5,
    String? language,
    String? region,
  }) async {
    // TODO: 实现Google Custom Search API
    // 需要配置Google Custom Search Engine ID和API Key
    throw UnimplementedError('Google搜索需要API密钥配置');
  }

  /// Bing搜索（需要API密钥）
  Future<SearchResult> _searchBing(String query, {int maxResults = 5}) async {
    // TODO: 实现Bing Search API
    // 需要配置Bing Search API Key
    throw UnimplementedError('Bing搜索需要API密钥配置');
  }

  /// 过滤和排序搜索结果
  List<SearchResultItem> _filterAndRankResults(
    List<SearchResultItem> results,
    String originalQuery,
  ) {
    // 过滤掉内容太短的结果
    final filtered = results
        .where(
          (result) => result.snippet.length > 20 && result.title.isNotEmpty,
        )
        .toList();

    // 简单的相关性排序（可以改进）
    filtered.sort((a, b) {
      final aScore = _calculateRelevanceScore(a, originalQuery);
      final bScore = _calculateRelevanceScore(b, originalQuery);
      return bScore.compareTo(aScore);
    });

    return filtered;
  }

  /// 计算相关性分数
  double _calculateRelevanceScore(SearchResultItem item, String query) {
    var score = 0.0;
    final queryWords = query.toLowerCase().split(' ');
    final titleLower = item.title.toLowerCase();
    final snippetLower = item.snippet.toLowerCase();

    // 标题匹配权重更高
    for (final word in queryWords) {
      if (titleLower.contains(word)) {
        score += 2.0;
      }
      if (snippetLower.contains(word)) {
        score += 1.0;
      }
    }

    // 内容类型加权
    switch (item.contentType) {
      case 'abstract':
        score += 1.0;
        break;
      case 'topic':
        score += 0.5;
        break;
    }

    return score;
  }

  /// 提取相关主题
  List<String> _extractRelatedTopics(List<SearchResultItem> results) {
    final topics = <String>{};

    for (final result in results) {
      // 从标题提取关键词
      final titleWords = result.title
          .replaceAll(RegExp(r'[^\w\s\u4e00-\u9fff]'), '')
          .split(' ')
          .where((word) => word.length > 2)
          .take(3);

      topics.addAll(titleWords);

      if (topics.length >= 10) break;
    }

    return topics.take(5).toList();
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
