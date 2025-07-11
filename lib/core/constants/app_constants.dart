/// 应用程序常量定义
///
/// 包含应用中使用的所有常量，确保：
/// - 集中管理配置
/// - 避免魔法数字和字符串
/// - 便于维护和修改
class AppConstants {
  // 私有构造函数，防止实例化
  AppConstants._();

  /// 应用信息
  static const String appName = 'AI Assistant';
  static const String appVersion = '1.0.0';
  static const String appDescription = '模块化跨平台AI助手';

  /// 数据库配置
  static const String databaseName = 'ai_assistant.db';
  static const int databaseVersion = 1;

  /// ObjectBox数据库配置
  static const String objectBoxDirectory = 'objectbox';

  /// SharedPreferences键名
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastSelectedPersona = 'last_selected_persona';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyBackupPath = 'backup_path';
  static const String keyAutoBackup = 'auto_backup';

  /// 聊天配置
  static const int maxChatHistoryLength = 50;
  static const int defaultContextWindowSize = 4096;
  static const double defaultTemperature = 0.7;
  static const int maxTokensPerRequest = 2048;

  /// RAG配置
  static const int embeddingDimensions = 1536; // OpenAI text-embedding-3-small
  static const int maxChunkSize = 1000;
  static const int chunkOverlap = 200;
  static const int maxRetrievedChunks = 5;
  static const double similarityThreshold = 0.7;

  /// 文件处理
  static const List<String> supportedDocumentTypes = [
    'pdf',
    'txt',
    'md',
    'docx',
    'rtf',
  ];
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB

  /// 网络配置
  static const int networkTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const int retryDelaySeconds = 2;

  /// 备份配置
  static const String backupFileExtension = '.aibackup';
  static const int maxBackupFiles = 10;
  static const String backupDateFormat = 'yyyy-MM-dd_HH-mm-ss';

  /// UI配置
  static const double sidebarWidth = 250;
  static const double chatBubbleMaxWidth = 0.7;
  static const int typingAnimationDuration = 1000;

  /// 错误消息
  static const String errorNetworkUnavailable = '网络连接不可用';
  static const String errorInvalidApiKey = 'API密钥无效';
  static const String errorFileNotFound = '文件未找到';
  static const String errorDatabaseConnection = '数据库连接失败';
  static const String errorBackupFailed = '备份失败';
  static const String errorRestoreFailed = '恢复失败';

  /// 成功消息
  static const String successPersonaSaved = '智能体保存成功';
  static const String successBackupCreated = '备份创建成功';
  static const String successDataRestored = '数据恢复成功';
  static const String successFileUploaded = '文件上传成功';

  /// 默认提示词模板
  static const String defaultSystemPrompt = '''
你是一个有用的AI助手。请遵循以下原则：

1. 提供准确、有用的信息
2. 保持友好和专业的语调
3. 如果不确定答案，请诚实说明
4. 根据上下文调整回答的详细程度
5. 优先使用中文回答，除非用户明确要求其他语言

请根据用户的问题提供最佳回答。
''';

  /// AI供应商配置
  static const Map<String, String> aiProviders = {
    'openai': 'OpenAI',
    'google': 'Google Gemini',
    'anthropic': 'Anthropic Claude',
    'deepseek': 'DeepSeek',
    'qwen': '阿里云通义千问',
    'openrouter': 'OpenRouter',
    'ollama': 'Ollama',
  };

  /// 默认模型配置
  static const Map<String, String> defaultModels = {
    'openai': 'gpt-3.5-turbo',
    'google': 'gemini-pro',
    'anthropic': 'claude-3-sonnet-20240229',
    'deepseek': 'deepseek-chat',
    'qwen': 'qwen-turbo',
    'openrouter': 'meta-llama/llama-3.1-8b-instruct:free',
    'ollama': 'llama3.2',
  };

  /// 嵌入模型配置
  static const Map<String, String> embeddingModels = {
    'openai': 'text-embedding-3-small',
    'google': 'embedding-001',
    'deepseek': 'deepseek-embedding',
    'qwen': 'text-embedding-v1',
  };

  /// API兼容性类型
  static const Map<String, String> apiCompatibilityTypes = {
    'openai': 'OpenAI API',
    'gemini': 'Gemini API',
    'anthropic': 'Anthropic API',
    'custom': '自定义API',
  };

  /// 提供商API兼容性映射
  static const Map<String, String> providerCompatibility = {
    'openai': 'openai',
    'google': 'gemini',
    'anthropic': 'anthropic',
    'deepseek': 'openai',
    'qwen': 'openai',
    'openrouter': 'openai',
    'ollama': 'openai',
  };

  /// 提供商默认端点
  static const Map<String, String> providerDefaultEndpoints = {
    'openai': 'https://api.openai.com/v1',
    'google': 'https://generativelanguage.googleapis.com/v1beta',
    'anthropic': 'https://api.anthropic.com',
    'deepseek': 'https://api.deepseek.com',
    'qwen': 'https://dashscope.aliyuncs.com/compatible-mode/v1',
    'openrouter': 'https://openrouter.ai/api/v1',
    'ollama': 'http://localhost:11434/v1',
  };
}

/// 路由常量
class AppRoutes {
  AppRoutes._();

  static const String chat = '/chat';
  static const String personas = '/personas';
  static const String personaCreate = '/personas/create';
  static const String personaEdit = '/personas/edit';
  static const String knowledge = '/knowledge';
  static const String settings = '/settings';
}

/// 动画常量
class AppAnimations {
  AppAnimations._();

  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
}

/// 间距常量
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// 边框半径常量
class AppRadius {
  AppRadius._();

  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double round = 50.0;
}
