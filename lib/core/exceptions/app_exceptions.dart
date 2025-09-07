/// 应用程序异常定义
///
/// 定义了应用中可能出现的各种异常类型，
/// 提供统一的错误处理机制，便于：
/// - 错误分类和处理
/// - 用户友好的错误提示
/// - 错误日志记录
/// - 调试和维护
library;

/// 基础应用异常
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// 网络相关异常
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.connectionTimeout() {
    return const NetworkException('网络连接超时，请检查网络设置', code: 'NETWORK_TIMEOUT');
  }

  factory NetworkException.noInternet() {
    return const NetworkException('无网络连接，请检查网络设置', code: 'NO_INTERNET');
  }

  factory NetworkException.serverError(int statusCode) {
    return NetworkException(
      '服务器错误 ($statusCode)',
      code: 'SERVER_ERROR_$statusCode',
    );
  }
}

/// API相关异常
class ApiException extends AppException {
  const ApiException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ApiException.invalidApiKey() {
    return const ApiException('API密钥无效，请检查配置', code: 'INVALID_API_KEY');
  }

  factory ApiException.quotaExceeded() {
    return const ApiException('API配额已用完，请检查账户余额', code: 'QUOTA_EXCEEDED');
  }

  factory ApiException.rateLimitExceeded() {
    return const ApiException('API调用频率超限，请稍后重试', code: 'RATE_LIMIT_EXCEEDED');
  }

  factory ApiException.modelNotFound(String model) {
    return ApiException('模型 "$model" 不存在或不可用', code: 'MODEL_NOT_FOUND');
  }
}

/// 数据库相关异常
class DatabaseException extends AppException {
  const DatabaseException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DatabaseException.connectionFailed() {
    return const DatabaseException('数据库连接失败', code: 'DB_CONNECTION_FAILED');
  }

  factory DatabaseException.migrationFailed() {
    return const DatabaseException('数据库迁移失败', code: 'DB_MIGRATION_FAILED');
  }

  factory DatabaseException.queryFailed(String query) {
    return DatabaseException('数据库查询失败: $query', code: 'DB_QUERY_FAILED');
  }
}

/// 文件操作相关异常
class FileException extends AppException {
  const FileException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory FileException.notFound(String path) {
    return FileException('文件未找到: $path', code: 'FILE_NOT_FOUND');
  }

  factory FileException.accessDenied(String path) {
    return FileException('文件访问被拒绝: $path', code: 'FILE_ACCESS_DENIED');
  }

  factory FileException.unsupportedFormat(String format) {
    return FileException('不支持的文件格式: $format', code: 'UNSUPPORTED_FORMAT');
  }

  factory FileException.fileTooLarge(int size, int maxSize) {
    return FileException(
      '文件过大: $size字节，最大允许$maxSize字节',
      code: 'FILE_TOO_LARGE',
    );
  }
}

/// 备份恢复相关异常
class BackupException extends AppException {
  const BackupException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory BackupException.createFailed() {
    return const BackupException('创建备份失败', code: 'BACKUP_CREATE_FAILED');
  }

  factory BackupException.restoreFailed() {
    return const BackupException('恢复备份失败', code: 'BACKUP_RESTORE_FAILED');
  }

  factory BackupException.invalidBackupFile() {
    return const BackupException('无效的备份文件', code: 'INVALID_BACKUP_FILE');
  }

  factory BackupException.corruptedBackup() {
    return const BackupException('备份文件已损坏', code: 'CORRUPTED_BACKUP');
  }
}

/// 智能体相关异常
class PersonaException extends AppException {
  const PersonaException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory PersonaException.notFound(String id) {
    return PersonaException('智能体未找到: $id', code: 'PERSONA_NOT_FOUND');
  }

  factory PersonaException.invalidConfiguration() {
    return const PersonaException('智能体配置无效', code: 'INVALID_PERSONA_CONFIG');
  }

  factory PersonaException.duplicateName(String name) {
    return PersonaException('智能体名称已存在: $name', code: 'DUPLICATE_PERSONA_NAME');
  }
}

/// 知识库相关异常
class KnowledgeBaseException extends AppException {
  const KnowledgeBaseException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory KnowledgeBaseException.embeddingFailed() {
    return const KnowledgeBaseException('生成文档嵌入向量失败', code: 'EMBEDDING_FAILED');
  }

  factory KnowledgeBaseException.indexingFailed() {
    return const KnowledgeBaseException('文档索引失败', code: 'INDEXING_FAILED');
  }

  factory KnowledgeBaseException.searchFailed() {
    return const KnowledgeBaseException('知识库搜索失败', code: 'SEARCH_FAILED');
  }
}

/// Minecraft相关异常
class MinecraftException extends AppException {
  const MinecraftException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory MinecraftException.connectionFailed() {
    return const MinecraftException(
      'RCON连接失败，请检查服务器配置',
      code: 'RCON_CONNECTION_FAILED',
    );
  }

  factory MinecraftException.authenticationFailed() {
    return const MinecraftException('RCON认证失败，请检查密码', code: 'RCON_AUTH_FAILED');
  }

  factory MinecraftException.commandFailed(String command) {
    return MinecraftException('命令执行失败: $command', code: 'COMMAND_FAILED');
  }
}

/// 验证相关异常
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.required(String field) {
    return ValidationException('$field 是必填项', code: 'FIELD_REQUIRED');
  }

  factory ValidationException.invalidFormat(String field) {
    return ValidationException('$field 格式无效', code: 'INVALID_FORMAT');
  }

  factory ValidationException.tooShort(String field, int minLength) {
    return ValidationException(
      '$field 长度不能少于 $minLength 个字符',
      code: 'TOO_SHORT',
    );
  }

  factory ValidationException.tooLong(String field, int maxLength) {
    return ValidationException(
      '$field 长度不能超过 $maxLength 个字符',
      code: 'TOO_LONG',
    );
  }
}

/// 聊天会话相关异常
class ChatSessionException extends AppException {
  const ChatSessionException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ChatSessionException.notFound(String sessionId) {
    return ChatSessionException('会话不存在: $sessionId', code: 'SESSION_NOT_FOUND');
  }

  factory ChatSessionException.archived(String sessionId) {
    return ChatSessionException('会话已归档，无法操作: $sessionId', code: 'SESSION_ARCHIVED');
  }

  factory ChatSessionException.invalidState(String reason) {
    return ChatSessionException('会话状态无效: $reason', code: 'INVALID_SESSION_STATE');
  }

  factory ChatSessionException.createFailed() {
    return const ChatSessionException('创建会话失败', code: 'SESSION_CREATE_FAILED');
  }
}