/// 知识库备份相关的数据实体定义
library;

/// 知识库备份结果
class KnowledgeBackupResult {
  final bool success;
  final String backupPath;
  final String knowledgeBaseId;
  final int documentCount;
  final int chunkCount;
  final double backupSize; // MB
  final Duration duration;
  final Map<String, dynamic>? manifest;
  final String? error;

  const KnowledgeBackupResult({
    required this.success,
    required this.backupPath,
    required this.knowledgeBaseId,
    required this.documentCount,
    required this.chunkCount,
    required this.backupSize,
    required this.duration,
    this.manifest,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'backupPath': backupPath,
    'knowledgeBaseId': knowledgeBaseId,
    'documentCount': documentCount,
    'chunkCount': chunkCount,
    'backupSize': backupSize,
    'duration': duration.inMilliseconds,
    'manifest': manifest,
    'error': error,
  };

  factory KnowledgeBackupResult.fromJson(Map<String, dynamic> json) =>
      KnowledgeBackupResult(
        success: json['success'] as bool,
        backupPath: json['backupPath'] as String,
        knowledgeBaseId: json['knowledgeBaseId'] as String,
        documentCount: json['documentCount'] as int,
        chunkCount: json['chunkCount'] as int,
        backupSize: (json['backupSize'] as num).toDouble(),
        duration: Duration(milliseconds: json['duration'] as int),
        manifest: json['manifest'] as Map<String, dynamic>?,
        error: json['error'] as String?,
      );
}

/// 知识库恢复结果
class KnowledgeRestoreResult {
  final bool success;
  final String knowledgeBaseId;
  final int documentCount;
  final int chunkCount;
  final bool vectorRestored;
  final Duration duration;
  final String? error;

  const KnowledgeRestoreResult({
    required this.success,
    required this.knowledgeBaseId,
    required this.documentCount,
    required this.chunkCount,
    required this.vectorRestored,
    required this.duration,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'knowledgeBaseId': knowledgeBaseId,
    'documentCount': documentCount,
    'chunkCount': chunkCount,
    'vectorRestored': vectorRestored,
    'duration': duration.inMilliseconds,
    'error': error,
  };

  factory KnowledgeRestoreResult.fromJson(Map<String, dynamic> json) =>
      KnowledgeRestoreResult(
        success: json['success'] as bool,
        knowledgeBaseId: json['knowledgeBaseId'] as String,
        documentCount: json['documentCount'] as int,
        chunkCount: json['chunkCount'] as int,
        vectorRestored: json['vectorRestored'] as bool,
        duration: Duration(milliseconds: json['duration'] as int),
        error: json['error'] as String?,
      );
}

/// 知识库备份信息
class KnowledgeBackupInfo {
  final String backupPath;
  final String knowledgeBaseId;
  final String knowledgeBaseName;
  final int documentCount;
  final int chunkCount;
  final double backupSize; // MB
  final bool hasVectors;
  final DateTime createdAt;
  final String version;

  const KnowledgeBackupInfo({
    required this.backupPath,
    required this.knowledgeBaseId,
    required this.knowledgeBaseName,
    required this.documentCount,
    required this.chunkCount,
    required this.backupSize,
    required this.hasVectors,
    required this.createdAt,
    required this.version,
  });

  factory KnowledgeBackupInfo.fromManifest(
    Map<String, dynamic> manifest,
    String backupPath,
  ) {
    final kbData = manifest['knowledgeBase'] as Map<String, dynamic>;

    return KnowledgeBackupInfo(
      backupPath: backupPath,
      knowledgeBaseId: kbData['id'] as String,
      knowledgeBaseName: kbData['name'] as String,
      documentCount: manifest['documentCount'] as int,
      chunkCount: manifest['chunkCount'] as int,
      backupSize: 0.0, // 需要计算
      hasVectors: manifest['hasVectors'] as bool? ?? false,
      createdAt: DateTime.parse(manifest['createdAt'] as String),
      version: manifest['version'] as String? ?? '1.0',
    );
  }

  Map<String, dynamic> toJson() => {
    'backupPath': backupPath,
    'knowledgeBaseId': knowledgeBaseId,
    'knowledgeBaseName': knowledgeBaseName,
    'documentCount': documentCount,
    'chunkCount': chunkCount,
    'backupSize': backupSize,
    'hasVectors': hasVectors,
    'createdAt': createdAt.toIso8601String(),
    'version': version,
  };

  factory KnowledgeBackupInfo.fromJson(Map<String, dynamic> json) =>
      KnowledgeBackupInfo(
        backupPath: json['backupPath'] as String,
        knowledgeBaseId: json['knowledgeBaseId'] as String,
        knowledgeBaseName: json['knowledgeBaseName'] as String,
        documentCount: json['documentCount'] as int,
        chunkCount: json['chunkCount'] as int,
        backupSize: (json['backupSize'] as num).toDouble(),
        hasVectors: json['hasVectors'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        version: json['version'] as String,
      );
}

/// 知识库备份验证结果
class KnowledgeBackupValidation {
  final bool isValid;
  final String? error;
  final int? documentCount;
  final int? chunkCount;
  final double? backupSize; // MB

  const KnowledgeBackupValidation({
    required this.isValid,
    this.error,
    this.documentCount,
    this.chunkCount,
    this.backupSize,
  });

  Map<String, dynamic> toJson() => {
    'isValid': isValid,
    'error': error,
    'documentCount': documentCount,
    'chunkCount': chunkCount,
    'backupSize': backupSize,
  };

  factory KnowledgeBackupValidation.fromJson(Map<String, dynamic> json) =>
      KnowledgeBackupValidation(
        isValid: json['isValid'] as bool,
        error: json['error'] as String?,
        documentCount: json['documentCount'] as int?,
        chunkCount: json['chunkCount'] as int?,
        backupSize: json['backupSize'] != null
            ? (json['backupSize'] as num).toDouble()
            : null,
      );
}

/// 备份配置选项
class KnowledgeBackupOptions {
  final bool includeVectors;
  final bool includeDocuments;
  final bool compressBackup;
  final String? encryptionKey;
  final List<String>? excludeDocumentTypes;

  const KnowledgeBackupOptions({
    this.includeVectors = true,
    this.includeDocuments = true,
    this.compressBackup = false,
    this.encryptionKey,
    this.excludeDocumentTypes,
  });

  Map<String, dynamic> toJson() => {
    'includeVectors': includeVectors,
    'includeDocuments': includeDocuments,
    'compressBackup': compressBackup,
    'encryptionKey': encryptionKey,
    'excludeDocumentTypes': excludeDocumentTypes,
  };

  factory KnowledgeBackupOptions.fromJson(Map<String, dynamic> json) =>
      KnowledgeBackupOptions(
        includeVectors: json['includeVectors'] as bool? ?? true,
        includeDocuments: json['includeDocuments'] as bool? ?? true,
        compressBackup: json['compressBackup'] as bool? ?? false,
        encryptionKey: json['encryptionKey'] as String?,
        excludeDocumentTypes: (json['excludeDocumentTypes'] as List?)
            ?.cast<String>(),
      );
}

/// 恢复配置选项
class KnowledgeRestoreOptions {
  final bool restoreVectors;
  final bool overwriteExisting;
  final String? targetKnowledgeBaseId;
  final String? decryptionKey;
  final bool skipInvalidDocuments;

  const KnowledgeRestoreOptions({
    this.restoreVectors = true,
    this.overwriteExisting = false,
    this.targetKnowledgeBaseId,
    this.decryptionKey,
    this.skipInvalidDocuments = true,
  });

  Map<String, dynamic> toJson() => {
    'restoreVectors': restoreVectors,
    'overwriteExisting': overwriteExisting,
    'targetKnowledgeBaseId': targetKnowledgeBaseId,
    'decryptionKey': decryptionKey,
    'skipInvalidDocuments': skipInvalidDocuments,
  };

  factory KnowledgeRestoreOptions.fromJson(Map<String, dynamic> json) =>
      KnowledgeRestoreOptions(
        restoreVectors: json['restoreVectors'] as bool? ?? true,
        overwriteExisting: json['overwriteExisting'] as bool? ?? false,
        targetKnowledgeBaseId: json['targetKnowledgeBaseId'] as String?,
        decryptionKey: json['decryptionKey'] as String?,
        skipInvalidDocuments: json['skipInvalidDocuments'] as bool? ?? true,
      );
}
