/// 聊天消息相关的默认值和常量
/// 
/// 提供统一的常量定义，避免硬编码值，提高性能和可维护性
class ChatMessageDefaults {
  // 私有构造函数，防止实例化
  ChatMessageDefaults._();

  // === 配置常量 ===
  /// 默认上下文窗口大小
  static const int defaultContextWindowSize = 4096;

  /// 默认温度参数
  static const double defaultTemperature = 0.7;

  /// 默认最大token数
  static const int defaultMaxTokens = 2048;

  // === 空列表常量 ===
  /// 空字符串列表（用于图片URL、标签等）
  static const List<String> emptyStringList = <String>[];

  /// 空附件列表
  static const List<FileAttachment> emptyAttachmentList = <FileAttachment>[];

  /// 空知识库ID列表
  static const List<String> emptyKnowledgeBaseIds = <String>[];

  // === 时间格式化常量 ===
  /// 时间差阈值（分钟）
  static const int minuteThreshold = 1;

  /// 时间差阈值（小时）
  static const int hourThreshold = 1;

  /// 时间差阈值（天）
  static const int dayThreshold = 1;

  /// 时间差阈值（周）
  static const int weekThreshold = 7;

  // === 显示文本常量 ===
  /// "刚刚"文本
  static const String justNowText = '刚刚';

  /// "分钟前"文本
  static const String minutesAgoText = '分钟前';

  /// "小时前"文本
  static const String hoursAgoText = '小时前';

  /// "天前"文本
  static const String daysAgoText = '天前';

  /// "刚刚活跃"文本
  static const String justActiveText = '刚刚活跃';

  /// 新对话标题
  static const String newChatTitle = '新对话';

  /// 对话前缀
  static const String chatPrefix = '对话 ';

  // === ID生成相关 ===
  /// ID截取长度
  static const int idSubstringLength = 8;

  // === 缓存相关常量 ===
  /// 时间缓存有效期（毫秒）
  static const int timeCacheValidityMs = 1000; // 1秒

  // === 性能优化相关 ===
  /// 批量操作的默认批次大小
  static const int defaultBatchSize = 50;

  /// 列表操作的性能阈值
  static const int listOperationThreshold = 100;
}

/// 时间缓存管理器
/// 
/// 用于缓存当前时间，避免频繁创建DateTime.now()实例
class TimeCache {
  static DateTime? _cachedTime;
  static int? _cacheTimestamp;

  /// 获取当前时间（带缓存）
  /// 
  /// 在同一毫秒内多次调用会返回相同的DateTime实例
  static DateTime now() {
    final currentMs = DateTime.now().millisecondsSinceEpoch;
    
    if (_cachedTime == null || 
        _cacheTimestamp == null || 
        currentMs - _cacheTimestamp! > ChatMessageDefaults.timeCacheValidityMs) {
      _cachedTime = DateTime.fromMillisecondsSinceEpoch(currentMs);
      _cacheTimestamp = currentMs;
    }
    
    return _cachedTime!;
  }

  /// 清除缓存
  static void clearCache() {
    _cachedTime = null;
    _cacheTimestamp = null;
  }

  /// 获取缓存的时间戳（用于批量操作）
  static DateTime getCachedTimeForBatch() {
    return _cachedTime ?? now();
  }
}
