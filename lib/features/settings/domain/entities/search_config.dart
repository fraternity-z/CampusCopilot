/// 搜索配置实体
class SearchConfig {
  /// 是否启用搜索功能
  final bool searchEnabled;

  /// 启用的搜索引擎列表
  final List<String> enabledEngines;

  /// 默认搜索引擎
  final String defaultEngine;

  /// 搜索API密钥（如果需要）
  final String? apiKey;

  /// 搜索结果数量限制
  final int maxResults;

  /// 搜索超时时间（秒）
  final int timeoutSeconds;

  /// 搜索语言偏好
  final String language;

  /// 搜索地区偏好
  final String region;

  /// 是否启用安全搜索
  final bool safeSearch;

  /// 自定义搜索引擎配置
  final Map<String, SearchEngineConfig> customEngines;

  /// 是否启用搜索结果黑名单
  final bool blacklistEnabled;

  /// 黑名单规则（按行分隔；支持简单域名或正则，以 /pattern/ 标识）
  final String blacklistRules;

  const SearchConfig({
    this.searchEnabled = false,
    this.enabledEngines = const ['google'],
    this.defaultEngine = 'google',
    this.apiKey,
    this.maxResults = 5,
    this.timeoutSeconds = 10,
    this.language = 'zh-CN',
    this.region = 'CN',
    this.safeSearch = true,
    this.customEngines = const {},
    this.blacklistEnabled = false,
    this.blacklistRules = '',
  });

  SearchConfig copyWith({
    bool? searchEnabled,
    List<String>? enabledEngines,
    String? defaultEngine,
    String? apiKey,
    int? maxResults,
    int? timeoutSeconds,
    String? language,
    String? region,
    bool? safeSearch,
    Map<String, SearchEngineConfig>? customEngines,
    bool? blacklistEnabled,
    String? blacklistRules,
  }) {
    return SearchConfig(
      searchEnabled: searchEnabled ?? this.searchEnabled,
      enabledEngines: enabledEngines ?? this.enabledEngines,
      defaultEngine: defaultEngine ?? this.defaultEngine,
      apiKey: apiKey ?? this.apiKey,
      maxResults: maxResults ?? this.maxResults,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      language: language ?? this.language,
      region: region ?? this.region,
      safeSearch: safeSearch ?? this.safeSearch,
      customEngines: customEngines ?? this.customEngines,
      blacklistEnabled: blacklistEnabled ?? this.blacklistEnabled,
      blacklistRules: blacklistRules ?? this.blacklistRules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchEnabled': searchEnabled,
      'enabledEngines': enabledEngines,
      'defaultEngine': defaultEngine,
      'apiKey': apiKey,
      'maxResults': maxResults,
      'timeoutSeconds': timeoutSeconds,
      'language': language,
      'region': region,
      'safeSearch': safeSearch,
      'customEngines': customEngines.map((k, v) => MapEntry(k, v.toJson())),
      'blacklistEnabled': blacklistEnabled,
      'blacklistRules': blacklistRules,
    };
  }

  factory SearchConfig.fromJson(Map<String, dynamic> json) {
    return SearchConfig(
      searchEnabled: json['searchEnabled'] ?? false,
      enabledEngines: List<String>.from(json['enabledEngines'] ?? ['google']),
      defaultEngine: json['defaultEngine'] ?? 'google',
      apiKey: json['apiKey'],
      maxResults: json['maxResults'] ?? 5,
      timeoutSeconds: json['timeoutSeconds'] ?? 10,
      language: json['language'] ?? 'zh-CN',
      region: json['region'] ?? 'CN',
      safeSearch: json['safeSearch'] ?? true,
      customEngines: (json['customEngines'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, SearchEngineConfig.fromJson(v)),
      ),
      blacklistEnabled: json['blacklistEnabled'] ?? false,
      blacklistRules: json['blacklistRules'] ?? '',
    );
  }
}

/// 搜索引擎配置
class SearchEngineConfig {
  /// 搜索引擎名称
  final String name;

  /// 搜索引擎显示名称
  final String displayName;

  /// API端点
  final String apiEndpoint;

  /// API密钥
  final String? apiKey;

  /// 是否启用
  final bool enabled;

  /// 请求头
  final Map<String, String> headers;

  /// 请求参数模板
  final Map<String, dynamic> paramTemplate;

  const SearchEngineConfig({
    required this.name,
    required this.displayName,
    required this.apiEndpoint,
    this.apiKey,
    this.enabled = true,
    this.headers = const {},
    this.paramTemplate = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'apiEndpoint': apiEndpoint,
      'apiKey': apiKey,
      'enabled': enabled,
      'headers': headers,
      'paramTemplate': paramTemplate,
    };
  }

  factory SearchEngineConfig.fromJson(Map<String, dynamic> json) {
    return SearchEngineConfig(
      name: json['name'],
      displayName: json['displayName'],
      apiEndpoint: json['apiEndpoint'],
      apiKey: json['apiKey'],
      enabled: json['enabled'] ?? true,
      headers: Map<String, String>.from(json['headers'] ?? {}),
      paramTemplate: Map<String, dynamic>.from(json['paramTemplate'] ?? {}),
    );
  }
}

/// 搜索结果实体
class SearchResult {
  /// 搜索查询
  final String query;

  /// 搜索结果列表
  final List<SearchResultItem> items;

  /// 搜索耗时（毫秒）
  final int searchTime;

  /// 搜索引擎
  final String engine;

  /// 错误信息
  final String? error;

  /// 是否有更多结果
  final bool hasMore;

  /// 总结果数（估算）
  final int? totalResults;

  const SearchResult({
    required this.query,
    required this.items,
    required this.searchTime,
    required this.engine,
    this.error,
    this.hasMore = false,
    this.totalResults,
  });

  /// 是否搜索成功
  bool get isSuccess => error == null && items.isNotEmpty;

  /// 是否有结果
  bool get hasResults => items.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'items': items.map((e) => e.toJson()).toList(),
      'searchTime': searchTime,
      'engine': engine,
      'error': error,
      'hasMore': hasMore,
      'totalResults': totalResults,
    };
  }

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      query: json['query'],
      items: (json['items'] as List)
          .map((e) => SearchResultItem.fromJson(e))
          .toList(),
      searchTime: json['searchTime'],
      engine: json['engine'],
      error: json['error'],
      hasMore: json['hasMore'] ?? false,
      totalResults: json['totalResults'],
    );
  }
}

/// 搜索结果项
class SearchResultItem {
  /// 标题
  final String title;

  /// 链接
  final String link;

  /// 摘要
  final String snippet;

  /// 显示链接
  final String? displayLink;

  /// 缩略图
  final String? thumbnail;

  /// 发布时间
  final DateTime? publishTime;

  /// 内容类型
  final String contentType;

  /// 相关性评分
  final double relevanceScore;

  /// 附加元数据
  final Map<String, dynamic> metadata;

  const SearchResultItem({
    required this.title,
    required this.link,
    required this.snippet,
    this.displayLink,
    this.thumbnail,
    this.publishTime,
    this.contentType = 'webpage',
    this.relevanceScore = 0.0,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'snippet': snippet,
      'displayLink': displayLink,
      'thumbnail': thumbnail,
      'publishTime': publishTime?.toIso8601String(),
      'contentType': contentType,
      'relevanceScore': relevanceScore,
      'metadata': metadata,
    };
  }

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      title: json['title'],
      link: json['link'],
      snippet: json['snippet'],
      displayLink: json['displayLink'],
      thumbnail: json['thumbnail'],
      publishTime: json['publishTime'] != null
          ? DateTime.parse(json['publishTime'])
          : null,
      contentType: json['contentType'] ?? 'webpage',
      relevanceScore: (json['relevanceScore'] ?? 0.0).toDouble(),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// AI搜索结果（用于AI上下文）
class AISearchResult {
  /// 原始搜索查询
  final String originalQuery;

  /// 优化后的搜索查询
  final String? optimizedQuery;

  /// 搜索结果
  final List<SearchResultItem> results;

  /// 搜索摘要（AI生成）
  final String? summary;

  /// 相关主题
  final List<String> relatedTopics;

  /// 搜索时间戳
  final DateTime timestamp;

  /// 搜索引擎
  final String engine;

  /// 错误信息
  final String? error;

  const AISearchResult({
    required this.originalQuery,
    this.optimizedQuery,
    required this.results,
    this.summary,
    this.relatedTopics = const [],
    required this.timestamp,
    required this.engine,
    this.error,
  });

  /// 是否搜索成功
  bool get isSuccess => error == null;

  /// 是否有结果
  bool get hasResults => results.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'originalQuery': originalQuery,
      'optimizedQuery': optimizedQuery,
      'results': results.map((e) => e.toJson()).toList(),
      'summary': summary,
      'relatedTopics': relatedTopics,
      'timestamp': timestamp.toIso8601String(),
      'engine': engine,
      'error': error,
    };
  }

  factory AISearchResult.fromJson(Map<String, dynamic> json) {
    return AISearchResult(
      originalQuery: json['originalQuery'],
      optimizedQuery: json['optimizedQuery'],
      results: (json['results'] as List)
          .map((e) => SearchResultItem.fromJson(e))
          .toList(),
      summary: json['summary'],
      relatedTopics: List<String>.from(json['relatedTopics'] ?? []),
      timestamp: DateTime.parse(json['timestamp']),
      engine: json['engine'],
      error: json['error'],
    );
  }
}
