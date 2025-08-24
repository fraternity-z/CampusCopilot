import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../../settings/domain/entities/search_config.dart';

/// 增强型直接搜索引擎爬取器
/// 基于Cherry Studio方案，具备强反反爬能力和智能内容提取
class LightweightDirectFetcher {
  // 真实浏览器User-Agent池
  static const List<String> _userAgents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Safari/605.1.15',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  ];

  // 搜索引擎配置
  static const Map<String, SearchEngineConfig> _engineConfigs = {
    'google': SearchEngineConfig(
      name: 'Google',
      urlTemplate: 'https://www.google.com/search?q=%s&hl=%l',
      selectors: [
        '#search .MjjYud', // 2024年最新结构
        '#search .g',      // 备用选择器
        '.g',              // 传统选择器
      ],
      titleSelector: 'h3',
      linkSelector: 'a',
      snippetSelector: '.VwiC3b, .s3v9rd, .st',
      needsWait: true,
    ),
    'bing': SearchEngineConfig(
      name: 'Bing',
      urlTemplate: 'https://cn.bing.com/search?q=%s&form=QBRE&qs=n',
      selectors: [
        '#b_results .b_algo',           // 主要选择器
        '#b_results li.b_algo',         // 备用选择器1
        '#b_results .b_algoheader',     // 新版结构
        '.b_algo',                      // 简化选择器
        '[data-priority]',              // 通用数据属性
      ],
      titleSelector: 'h2 a, h3 a, .b_algoheader a',
      linkSelector: 'h2 a, h3 a, .b_algoheader a',
      snippetSelector: '.b_caption p, .b_snippet, .b_paractl, .b_dList, .b_lineclamp4',
      needsWait: false,
    ),
    'baidu': SearchEngineConfig(
      name: '百度',
      urlTemplate: 'https://www.baidu.com/s?wd=%s',
      selectors: [
        '#content_left .result',
        '#content_left .c-container',
      ],
      titleSelector: 'h3 a',
      linkSelector: 'h3 a',
      snippetSelector: '.c-abstract, .c-span9',
      needsWait: false,
    ),
  };

  static Future<SearchResult> searchViaHttp(
    String query, {
    required List<String> engines,
    int maxResults = 5,
    String? language,
    String? region,
  }) async {
    final start = DateTime.now();
    final items = <SearchResultItem>[];

    debugPrint('🔍 开始增强型直接搜索: "$query"');
    debugPrint('🔧 使用引擎: ${engines.join(", ")}');

    final used = engines.isEmpty ? ['google'] : engines;
    final perEngine = (maxResults / used.length).ceil();

    // 并发搜索多个引擎
    final futures = used.map((engine) => 
      _searchSingleEngine(engine, query, perEngine, language ?? 'zh')
    ).toList();
    
    final results = await Future.wait(futures);
    
    for (final result in results) {
      items.addAll(result);
    }

    // 去重和排序
    final deduped = _deduplicateAndRank(items, query);
    final limited = deduped.take(maxResults).toList();

    debugPrint('✅ 搜索完成，总计获得 ${limited.length} 个结果');

    return SearchResult(
      query: query,
      items: limited,
      searchTime: DateTime.now().difference(start).inMilliseconds,
      engine: 'enhanced_direct',
      totalResults: limited.length,
    );
  }

  static Future<List<SearchResultItem>> _searchSingleEngine(
    String engine,
    String query,
    int maxResults,
    String language,
  ) async {
    try {
      final config = _engineConfigs[engine];
      if (config == null) {
        debugPrint('❌ 不支持的搜索引擎: $engine');
        return [];
      }

      debugPrint('🔍 开始搜索 ${config.name}: "$query"');

      // 构造搜索URL
      final encodedQuery = Uri.encodeComponent(query);
      final url = config.urlTemplate
          .replaceAll('%s', encodedQuery)
          .replaceAll('%l', language);
      
      debugPrint('🔗 搜索URL: $url');

      // 获取随机User-Agent
      final userAgent = _userAgents[Random().nextInt(_userAgents.length)];

      // 添加随机延时防止被检测
      await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 200));

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': userAgent,
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
          'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
          'Accept-Encoding': 'gzip, deflate',
          'DNT': '1',
          'Connection': 'keep-alive',
          'Upgrade-Insecure-Requests': '1',
          'Sec-Fetch-Dest': 'document',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'none',
          'Cache-Control': 'max-age=0',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        debugPrint('❌ ${config.name}搜索失败: HTTP ${response.statusCode}');
        return [];
      }

      // 安全处理响应编码
      String responseBody;
      try {
        // 检查Content-Type头部中的字符集
        final contentType = response.headers['content-type'] ?? '';
        final hasGbk = contentType.toLowerCase().contains('gbk') || contentType.toLowerCase().contains('gb2312');
        
        debugPrint('📄 Content-Type: $contentType');
        debugPrint('📦 Content-Encoding: ${response.headers['content-encoding'] ?? 'none'}');
        debugPrint('📏 Content-Length: ${response.bodyBytes.length}');
        
        // 直接使用response.body，让http包自动处理编码和解压
        responseBody = response.body;
        
        // 如果response.body为空或明显是乱码，尝试手动处理
        if (responseBody.isEmpty || responseBody.contains('�') || responseBody.length < 100) {
          debugPrint('⚠️ response.body异常，尝试手动解码');
          
          // 尝试手动解压和解码
          List<int> decodedBytes = response.bodyBytes;
          final contentEncoding = response.headers['content-encoding']?.toLowerCase();
          
          if (contentEncoding == 'gzip') {
            decodedBytes = GZipCodec().decode(response.bodyBytes);
          } else if (contentEncoding == 'deflate') {
            decodedBytes = ZLibCodec().decode(response.bodyBytes);
          } else if (contentEncoding == 'br') {
            // Brotli压缩不支持，直接使用原始字节
            debugPrint('⚠️ 检测到Brotli压缩，但不支持解压，使用原始字节');
            decodedBytes = response.bodyBytes;
          }
          
          // 根据Content-Type选择编码
          if (hasGbk) {
            // 对于中文站点，可能使用GBK编码，这里简化处理为UTF-8
            responseBody = utf8.decode(decodedBytes, allowMalformed: true);
          } else {
            responseBody = utf8.decode(decodedBytes, allowMalformed: true);
          }
        }
        
        debugPrint('✅ 响应解码成功，内容长度: ${responseBody.length}');
        
      } catch (e) {
        debugPrint('❌ 响应解码失败: $e，使用原始response.body');
        responseBody = response.body;
      }

      // 解析HTML
      final doc = html_parser.parse(responseBody);
      final items = await _parseSearchResults(doc, config, maxResults);

      debugPrint('✅ ${config.name}搜索成功，找到 ${items.length} 个结果');
      return items;

    } catch (e) {
      debugPrint('❌ $engine 搜索异常: $e');
      return [];
    }
  }

  static Future<List<SearchResultItem>> _parseSearchResults(
    dom.Document doc,
    SearchEngineConfig config,
    int maxResults,
  ) async {
    final results = <SearchResultItem>[];

    // 尝试多个选择器
    for (final selector in config.selectors) {
      final items = doc.querySelectorAll(selector);
      debugPrint('🔍 尝试选择器: $selector (找到${items.length}项)');
      
      if (items.isNotEmpty) {
        debugPrint('🎯 使用选择器成功: $selector (找到${items.length}项)');
        
        for (final item in items) {
          if (results.length >= maxResults) break;
          
          final searchItem = _extractItemData(item, config);
          if (searchItem != null && _isValidResult(searchItem)) {
            results.add(searchItem);
            debugPrint('✅ 提取结果: ${searchItem.title}');
          } else {
            debugPrint('❌ 无效结果或提取失败');
          }
        }
        
        if (results.isNotEmpty) break; // 找到结果就停止尝试其他选择器
      }
    }
    
    // 如果所有选择器都没找到结果，输出HTML片段供调试
    if (results.isEmpty && kDebugMode) {
      final html = doc.body?.outerHtml ?? 'No body';
      final bodyText = html.length > 1000 ? html.substring(0, 1000) : html;
      debugPrint('🔍 未找到搜索结果，HTML片段: $bodyText...');
    }

    return results;
  }

  static SearchResultItem? _extractItemData(
    dom.Element item,
    SearchEngineConfig config,
  ) {
    try {
      // 提取标题和链接
      final titleElement = item.querySelector(config.titleSelector);
      final linkElement = item.querySelector(config.linkSelector);
      
      // 调试输出
      if (kDebugMode) {
        debugPrint('🔍 处理搜索项:');
        debugPrint('  - 标题元素: ${titleElement?.outerHtml ?? "未找到"}');
        debugPrint('  - 链接元素: ${linkElement?.outerHtml ?? "未找到"}');
      }
      
      if (titleElement == null || linkElement == null) {
        debugPrint('❌ 缺少标题或链接元素');
        return null;
      }

      var title = titleElement.text.trim();
      var link = linkElement.attributes['href'] ?? '';

      debugPrint('📝 提取数据: 标题="$title", 链接="$link"');
      
      if (title.isEmpty || link.isEmpty) {
        debugPrint('❌ 标题或链接为空');
        return null;
      }

      // 处理相对链接和特殊URL格式
      link = _normalizeUrl(link);
      if (!_isValidUrl(link)) return null;

      // 提取摘要
      var snippet = '';
      final snippetElement = item.querySelector(config.snippetSelector);
      if (snippetElement != null) {
        snippet = snippetElement.text.trim();
      }

      // 清理标题和摘要
      title = _cleanText(title);
      snippet = _cleanText(snippet);

      return SearchResultItem(
        title: title,
        link: link,
        snippet: snippet,
        displayLink: _extractDomain(link),
        contentType: 'webpage',
        relevanceScore: _calculateInitialScore(title, snippet),
        metadata: {
          'engine': config.name,
          'extracted_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('⚠️ 提取搜索项数据失败: $e');
      return null;
    }
  }

  static String _normalizeUrl(String url) {
    // 处理Google的重定向URL
    if (url.startsWith('/url?')) {
      final uri = Uri.parse('https://www.google.com$url');
      return uri.queryParameters['url'] ?? url;
    }
    
    // 处理百度的重定向URL
    if (url.startsWith('/link?')) {
      final uri = Uri.parse('https://www.baidu.com$url');
      return uri.queryParameters['url'] ?? url;
    }

    // 确保是完整URL
    if (url.startsWith('http')) {
      return url;
    } else if (url.startsWith('//')) {
      return 'https:$url';
    } else if (url.startsWith('/')) {
      return 'https://www.google.com$url'; // 备用处理
    }

    return url;
  }

  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             uri.host.isNotEmpty &&
             !uri.host.contains('google.com/search') &&
             !uri.host.contains('bing.com/search') &&
             !uri.host.contains('baidu.com/s');
    } catch (e) {
      return false;
    }
  }

  static String _extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  static String _cleanText(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')  // 合并多个空白字符
        .replaceAll(RegExp(r'[\r\n]+'), ' ')  // 移除换行符
        .trim();
  }

  static double _calculateInitialScore(String title, String snippet) {
    var score = 1.0;
    
    // 根据标题长度调整分数
    if (title.length > 10 && title.length < 100) {
      score += 0.3;
    }
    
    // 根据摘要质量调整分数
    if (snippet.length > 50 && snippet.length < 300) {
      score += 0.2;
    }
    
    return score;
  }

  static bool _isValidResult(SearchResultItem item) {
    // 过滤掉无效结果
    if (item.title.length < 3 || item.link.length < 10) return false;
    
    // 过滤掉明显的垃圾链接
    final spamPatterns = [
      'javascript:',
      'mailto:',
      'tel:',
      '#',
    ];
    
    for (final pattern in spamPatterns) {
      if (item.link.toLowerCase().contains(pattern)) return false;
    }
    
    return true;
  }

  static List<SearchResultItem> _deduplicateAndRank(
    List<SearchResultItem> items,
    String query,
  ) {
    // 按URL去重
    final seen = <String>{};
    final unique = <SearchResultItem>[];
    
    for (final item in items) {
      final normalizedUrl = item.link.split('?')[0].split('#')[0]; // 移除查询参数和fragment
      if (!seen.contains(normalizedUrl)) {
        seen.add(normalizedUrl);
        
        // 重新计算相关性分数
        final updatedItem = SearchResultItem(
          title: item.title,
          link: item.link,
          snippet: item.snippet,
          displayLink: item.displayLink,
          contentType: item.contentType,
          relevanceScore: _calculateRelevanceScore(item, query),
          metadata: item.metadata,
        );
        
        unique.add(updatedItem);
      }
    }
    
    // 按相关性分数排序
    unique.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return unique;
  }

  static double _calculateRelevanceScore(SearchResultItem item, String query) {
    var score = 0.0;
    final queryWords = query.toLowerCase().split(RegExp(r'\s+'));
    final titleLower = item.title.toLowerCase();
    final snippetLower = item.snippet.toLowerCase();

    // 标题匹配权重
    for (final word in queryWords) {
      if (word.length < 2) continue;
      
      if (titleLower.contains(word)) {
        score += 3.0; // 标题匹配权重最高
      }
      if (snippetLower.contains(word)) {
        score += 1.0; // 摘要匹配次之
      }
    }

    // 完整查询匹配
    if (titleLower.contains(query.toLowerCase())) {
      score += 5.0;
    }
    if (snippetLower.contains(query.toLowerCase())) {
      score += 2.0;
    }

    // 质量因子
    if (item.snippet.length > 50) score += 0.5;
    if (item.title.length > 10 && item.title.length < 80) score += 0.3;

    return score;
  }
}

/// 搜索引擎配置类
class SearchEngineConfig {
  final String name;
  final String urlTemplate;
  final List<String> selectors;
  final String titleSelector;
  final String linkSelector;
  final String snippetSelector;
  final bool needsWait;

  const SearchEngineConfig({
    required this.name,
    required this.urlTemplate,
    required this.selectors,
    required this.titleSelector,
    required this.linkSelector,
    required this.snippetSelector,
    this.needsWait = false,
  });
}
