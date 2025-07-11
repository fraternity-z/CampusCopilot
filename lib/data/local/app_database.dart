import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../core/constants/app_constants.dart';
import 'tables/llm_configs_table.dart';
import 'tables/personas_table.dart';
import 'tables/persona_groups_table.dart';
import 'tables/chat_sessions_table.dart';
import 'tables/chat_messages_table.dart';
import 'tables/knowledge_documents_table.dart';
import 'tables/knowledge_chunks_table.dart';
import 'tables/knowledge_base_configs_table.dart';
import 'tables/custom_models_table.dart';

part 'app_database.g.dart';

/// 应用主数据库
///
/// 使用Drift ORM管理所有结构化数据，包括：
/// - LLM配置
/// - 智能体管理
/// - 聊天会话和消息
/// - 知识库文档
@DriftDatabase(
  tables: [
    LlmConfigsTable,
    PersonasTable,
    PersonaGroupsTable,
    ChatSessionsTable,
    ChatMessagesTable,
    KnowledgeDocumentsTable,
    KnowledgeChunksTable,
    KnowledgeBaseConfigsTable,
    CustomModelsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()) {
    // 预编译常用查询，减少运行期生成对象的开销
    _enabledPersonasQuery = (select(personasTable)
      ..where((t) => t.isEnabled.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)]));

    _activeSessionsQuery = (select(chatSessionsTable)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]));
  }

  // ---------- 内存缓存 ----------
  final Map<String, PersonasTableData> _personaCache = {};

  // ---------- 预编译查询 ----------
  late final SimpleSelectStatement<$PersonasTableTable, PersonasTableData>
  _enabledPersonasQuery;
  late final SimpleSelectStatement<
    $ChatSessionsTableTable,
    ChatSessionsTableData
  >
  _activeSessionsQuery;

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertDefaultData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 使用事务包裹所有迁移，防止中途失败导致部分状态
        await transaction(() async {
          if (from < 2) {
            await m.createTable(personaGroupsTable);
            await m.createTable(customModelsTable);
          }
          if (from < 3) {
            try {
              await m.addColumn(customModelsTable, customModelsTable.configId);
            } catch (_) {
              await m.createTable(customModelsTable);
            }
          }
          if (from < 4) {
            try {
              await m.addColumn(
                chatMessagesTable,
                chatMessagesTable.thinkingContent,
              );
              await m.addColumn(
                chatMessagesTable,
                chatMessagesTable.thinkingComplete,
              );
              await m.addColumn(chatMessagesTable, chatMessagesTable.modelName);
            } catch (e) {
              debugPrint('Failed to add thinking chain columns: $e');
            }
          }
          if (from < 5) {
            try {
              await m.createTable(knowledgeBaseConfigsTable);
            } catch (e) {
              debugPrint('Failed to create knowledge base configs table: $e');
            }
          }
          if (from < 6) {
            try {
              // 添加自定义提供商支持字段
              await m.addColumn(
                llmConfigsTable,
                llmConfigsTable.isCustomProvider,
              );
              await m.addColumn(
                llmConfigsTable,
                llmConfigsTable.apiCompatibilityType,
              );
              await m.addColumn(
                llmConfigsTable,
                llmConfigsTable.customProviderName,
              );
              await m.addColumn(
                llmConfigsTable,
                llmConfigsTable.customProviderDescription,
              );
              await m.addColumn(
                llmConfigsTable,
                llmConfigsTable.customProviderIcon,
              );
            } catch (e) {
              debugPrint('Failed to add custom provider columns: $e');
            }
          }
        });
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        await customStatement('PRAGMA optimize');
      },
    );
  }

  /// 插入默认数据
  Future<void> _insertDefaultData() async {
    // 插入默认LLM配置示例
    await into(llmConfigsTable).insert(
      LlmConfigsTableCompanion.insert(
        id: 'default-openai',
        name: 'OpenAI 配置',
        provider: 'openai',
        apiKey: '',
        defaultModel: Value('gpt-3.5-turbo'),
        defaultEmbeddingModel: Value('text-embedding-3-small'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEnabled: const Value(false), // 默认禁用，需要用户配置API密钥
      ),
    );

    // 插入默认智能体
    await into(personasTable).insert(
      PersonasTableCompanion.insert(
        id: 'default-assistant',
        name: '通用助手',
        description: '一个友好的通用AI助手，可以帮助回答各种问题',
        systemPrompt: AppConstants.defaultSystemPrompt,
        apiConfigId: 'default-openai',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: Value('assistant'),
        isDefault: Value(true),
      ),
    );
  }

  // ==================== LLM配置相关查询 ====================

  /// 获取所有LLM配置
  Future<List<LlmConfigsTableData>> getAllLlmConfigs() {
    return select(llmConfigsTable).get();
  }

  /// 获取启用的LLM配置
  Future<List<LlmConfigsTableData>> getEnabledLlmConfigs() {
    return (select(
      llmConfigsTable,
    )..where((t) => t.isEnabled.equals(true))).get();
  }

  /// 根据ID获取LLM配置
  Future<LlmConfigsTableData?> getLlmConfigById(String id) {
    return (select(
      llmConfigsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 插入或更新LLM配置
  Future<void> upsertLlmConfig(LlmConfigsTableCompanion config) {
    return into(llmConfigsTable).insertOnConflictUpdate(config);
  }

  /// 删除LLM配置
  Future<int> deleteLlmConfig(String id) {
    return (delete(llmConfigsTable)..where((t) => t.id.equals(id))).go();
  }

  /// 获取内置提供商配置
  Future<List<LlmConfigsTableData>> getBuiltinProviderConfigs() {
    return (select(
      llmConfigsTable,
    )..where((t) => t.isCustomProvider.equals(false))).get();
  }

  /// 获取自定义提供商配置
  Future<List<LlmConfigsTableData>> getCustomProviderConfigs() {
    return (select(
      llmConfigsTable,
    )..where((t) => t.isCustomProvider.equals(true))).get();
  }

  /// 根据提供商类型获取配置
  Future<List<LlmConfigsTableData>> getLlmConfigsByProvider(String provider) {
    return (select(
      llmConfigsTable,
    )..where((t) => t.provider.equals(provider))).get();
  }

  /// 获取第一个（任意）LLM配置，作为备用选项
  Future<LlmConfigsTableData?> getFirstLlmConfig() {
    return (select(llmConfigsTable)..limit(1)).getSingleOrNull();
  }

  // ==================== 智能体相关查询 ====================

  /// 获取所有智能体
  Future<List<PersonasTableData>> getAllPersonas() {
    return (select(
      personasTable,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)])).get();
  }

  /// 获取启用的智能体（使用预编译查询）
  Future<List<PersonasTableData>> getEnabledPersonas() {
    return _enabledPersonasQuery.get();
  }

  /// 根据ID获取智能体
  Future<PersonasTableData?> getPersonaById(String id) {
    return (select(
      personasTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 获取默认智能体
  Future<PersonasTableData?> getDefaultPersona() {
    return (select(
      personasTable,
    )..where((t) => t.isDefault.equals(true))).getSingleOrNull();
  }

  /// 搜索智能体
  Future<List<PersonasTableData>> searchPersonas(String query) {
    final lowerQuery = query.toLowerCase();
    return (select(personasTable)..where(
          (t) =>
              t.name.lower().contains(lowerQuery) |
              t.description.lower().contains(lowerQuery) |
              t.tags.contains(query),
        ))
        .get();
  }

  /// 插入或更新智能体
  Future<void> upsertPersona(PersonasTableCompanion persona) async {
    await into(personasTable).insertOnConflictUpdate(persona);
    if (persona.id.present) _clearPersonaCache(persona.id.value);
  }

  /// 删除智能体
  Future<int> deletePersona(String id) {
    return (delete(personasTable)..where((t) => t.id.equals(id))).go();
  }

  /// 更新智能体使用统计
  Future<void> updatePersonaUsage(String id) async {
    final persona = await getPersonaById(id);
    if (persona != null) {
      await (update(personasTable)..where((t) => t.id.equals(id))).write(
        PersonasTableCompanion(
          usageCount: Value(persona.usageCount + 1),
          lastUsedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // ==================== 助手分组相关查询 ====================

  /// 获取所有分组
  Future<List<PersonaGroupsTableData>> getAllPersonaGroups() {
    return select(personaGroupsTable).get();
  }

  /// 创建或更新分组
  Future<void> upsertPersonaGroup(PersonaGroupsTableCompanion group) {
    return into(personaGroupsTable).insertOnConflictUpdate(group);
  }

  /// 删除分组
  Future<int> deletePersonaGroup(String id) {
    return (delete(personaGroupsTable)..where((t) => t.id.equals(id))).go();
  }

  // ==================== 数据统计查询 ====================

  /// 获取聊天会话总数
  Future<int> getChatSessionCount() async {
    final count = chatSessionsTable.id.count();
    final query = selectOnly(chatSessionsTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// 获取消息总数
  Future<int> getMessageCount() async {
    final count = chatMessagesTable.id.count();
    final query = selectOnly(chatMessagesTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// 获取智能体总数
  Future<int> getPersonaCount() async {
    final count = personasTable.id.count();
    final query = selectOnly(personasTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// 获取知识库文档总数
  Future<int> getKnowledgeDocumentCount() async {
    final count = knowledgeDocumentsTable.id.count();
    final query = selectOnly(knowledgeDocumentsTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ==================== 聊天会话相关查询 ====================

  /// 获取所有聊天会话
  Future<List<ChatSessionsTableData>> getAllChatSessions() {
    return (select(
      chatSessionsTable,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
  }

  /// 获取活跃的聊天会话（使用预编译查询）
  Future<List<ChatSessionsTableData>> getActiveChatSessions() {
    return _activeSessionsQuery.get();
  }

  /// 根据智能体ID获取聊天会话
  Future<List<ChatSessionsTableData>> getChatSessionsByPersona(
    String personaId,
  ) {
    return (select(chatSessionsTable)
          ..where((t) => t.personaId.equals(personaId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// 根据ID获取聊天会话
  Future<ChatSessionsTableData?> getChatSessionById(String id) {
    return (select(
      chatSessionsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 插入或更新聊天会话
  Future<void> upsertChatSession(ChatSessionsTableCompanion session) {
    return into(chatSessionsTable).insertOnConflictUpdate(session);
  }

  /// 删除聊天会话
  Future<int> deleteChatSession(String id) async {
    // 先删除相关消息
    await (delete(
      chatMessagesTable,
    )..where((t) => t.chatSessionId.equals(id))).go();
    // 再删除会话
    return (delete(chatSessionsTable)..where((t) => t.id.equals(id))).go();
  }

  // ==================== 聊天消息相关查询 ====================

  /// 根据会话ID获取消息
  Future<List<ChatMessagesTableData>> getMessagesBySession(String sessionId) {
    return (select(chatMessagesTable)
          ..where((t) => t.chatSessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
  }

  /// 获取会话的最新消息
  Future<List<ChatMessagesTableData>> getRecentMessages(
    String sessionId,
    int limit,
  ) {
    return (select(chatMessagesTable)
          ..where((t) => t.chatSessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  /// 插入消息
  Future<void> insertMessage(ChatMessagesTableCompanion message) {
    return into(chatMessagesTable).insert(message);
  }

  /// 更新消息状态
  Future<void> updateMessageStatus(String messageId, String status) {
    return (update(chatMessagesTable)..where((t) => t.id.equals(messageId)))
        .write(ChatMessagesTableCompanion(status: Value(status)));
  }

  /// 删除消息
  Future<int> deleteMessage(String id) {
    return (delete(chatMessagesTable)..where((t) => t.id.equals(id))).go();
  }

  // ==================== 知识库文档相关查询 ====================

  /// 获取所有知识库文档
  Future<List<KnowledgeDocumentsTableData>> getAllKnowledgeDocuments() {
    return (select(
      knowledgeDocumentsTable,
    )..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)])).get();
  }

  /// 根据状态获取文档
  Future<List<KnowledgeDocumentsTableData>> getDocumentsByStatus(
    String status,
  ) {
    return (select(knowledgeDocumentsTable)
          ..where((t) => t.status.equals(status))
          ..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)]))
        .get();
  }

  /// 插入或更新知识库文档
  Future<void> upsertKnowledgeDocument(
    KnowledgeDocumentsTableCompanion document,
  ) {
    return into(knowledgeDocumentsTable).insertOnConflictUpdate(document);
  }

  /// 删除知识库文档
  Future<int> deleteKnowledgeDocument(String id) {
    return (delete(
      knowledgeDocumentsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  // ==================== 自定义模型相关查询 ====================

  /// 获取所有自定义模型
  Future<List<CustomModelsTableData>> getAllCustomModels() {
    return select(customModelsTable).get();
  }

  /// 根据提供商获取自定义模型
  Future<List<CustomModelsTableData>> getCustomModelsByProvider(
    String provider,
  ) {
    return (select(
      customModelsTable,
    )..where((t) => t.provider.equals(provider))).get();
  }

  /// 获取启用的自定义模型
  Future<List<CustomModelsTableData>> getEnabledCustomModels() {
    return (select(
      customModelsTable,
    )..where((t) => t.isEnabled.equals(true))).get();
  }

  /// 根据ID获取自定义模型
  Future<CustomModelsTableData?> getCustomModelById(String id) {
    return (select(
      customModelsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 插入或更新自定义模型
  Future<void> upsertCustomModel(CustomModelsTableCompanion model) {
    return into(customModelsTable).insertOnConflictUpdate(model);
  }

  /// 删除自定义模型
  Future<int> deleteCustomModel(String id) {
    return (delete(customModelsTable)..where((t) => t.id.equals(id))).go();
  }

  /// 批量插入内置模型
  Future<void> insertBuiltInModels(List<CustomModelsTableCompanion> models) {
    return batch((batch) {
      batch.insertAllOnConflictUpdate(customModelsTable, models);
    });
  }

  /// 根据配置ID获取自定义模型
  Future<List<CustomModelsTableData>> getCustomModelsByConfig(String configId) {
    return (select(
      customModelsTable,
    )..where((t) => t.configId.equals(configId))).get();
  }

  // ==================== 知识库配置相关查询 ====================

  /// 获取所有知识库配置
  Future<List<KnowledgeBaseConfigsTableData>> getAllKnowledgeBaseConfigs() {
    return (select(
      knowledgeBaseConfigsTable,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
  }

  /// 获取默认知识库配置
  Future<KnowledgeBaseConfigsTableData?> getDefaultKnowledgeBaseConfig() {
    return (select(
      knowledgeBaseConfigsTable,
    )..where((t) => t.isDefault.equals(true))).getSingleOrNull();
  }

  /// 根据ID获取知识库配置
  Future<KnowledgeBaseConfigsTableData?> getKnowledgeBaseConfigById(String id) {
    return (select(
      knowledgeBaseConfigsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 插入或更新知识库配置
  Future<void> upsertKnowledgeBaseConfig(
    KnowledgeBaseConfigsTableCompanion config,
  ) {
    return into(knowledgeBaseConfigsTable).insertOnConflictUpdate(config);
  }

  /// 删除知识库配置
  Future<int> deleteKnowledgeBaseConfig(String id) {
    return (delete(
      knowledgeBaseConfigsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// 设置默认知识库配置
  Future<void> setDefaultKnowledgeBaseConfig(String configId) async {
    // 先取消所有默认配置
    await (update(knowledgeBaseConfigsTable)).write(
      const KnowledgeBaseConfigsTableCompanion(
        isDefault: Value(false),
        updatedAt: Value.absent(),
      ),
    );

    // 设置新的默认配置
    await (update(
      knowledgeBaseConfigsTable,
    )..where((t) => t.id.equals(configId))).write(
      KnowledgeBaseConfigsTableCompanion(
        isDefault: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ==================== 知识库文本块相关查询 ====================

  /// 获取文档的所有文本块
  Future<List<KnowledgeChunksTableData>> getChunksByDocument(
    String documentId,
  ) {
    return (select(knowledgeChunksTable)
          ..where((t) => t.documentId.equals(documentId))
          ..orderBy([(t) => OrderingTerm.asc(t.chunkIndex)]))
        .get();
  }

  /// 插入文本块
  Future<void> insertKnowledgeChunk(KnowledgeChunksTableCompanion chunk) {
    return into(knowledgeChunksTable).insert(chunk);
  }

  /// 批量插入文本块
  Future<void> insertKnowledgeChunks(
    List<KnowledgeChunksTableCompanion> chunks,
  ) {
    return batch((batch) {
      batch.insertAll(knowledgeChunksTable, chunks);
    });
  }

  /// 删除文档的所有文本块
  Future<int> deleteChunksByDocument(String documentId) {
    return (delete(
      knowledgeChunksTable,
    )..where((t) => t.documentId.equals(documentId))).go();
  }

  /// 更新文本块的嵌入向量
  Future<void> updateChunkEmbedding(String chunkId, String embedding) {
    return (update(knowledgeChunksTable)..where((t) => t.id.equals(chunkId)))
        .write(KnowledgeChunksTableCompanion(embedding: Value(embedding)));
  }

  /// 获取所有有嵌入向量的文本块
  Future<List<KnowledgeChunksTableData>> getChunksWithEmbeddings() {
    return (select(
      knowledgeChunksTable,
    )..where((t) => t.embedding.isNotNull())).get();
  }

  /// 搜索相似文本块（基于内容的简单搜索，后续会被向量搜索替换）
  Future<List<KnowledgeChunksTableData>> searchChunks(String query) {
    final lowerQuery = query.toLowerCase();
    return (select(
      knowledgeChunksTable,
    )..where((t) => t.content.lower().contains(lowerQuery))).get();
  }

  // ---------- 新增分页、计数优化 ----------
  /// 分页获取会话消息
  Future<List<ChatMessagesTableData>> getMessagesBySessionPaged(
    String sessionId, {
    int offset = 0,
    int limit = 50,
  }) {
    return (select(chatMessagesTable)
          ..where((t) => t.chatSessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)])
          ..limit(limit, offset: offset))
        .get();
  }

  /// 获取会话消息数量（仅返回计数）
  Future<int> getMessageCountBySession(String sessionId) async {
    final countExp = chatMessagesTable.id.count();
    final query = selectOnly(chatMessagesTable)
      ..addColumns([countExp])
      ..where(chatMessagesTable.chatSessionId.equals(sessionId));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  // ---------- 批量操作 ----------
  /// 批量更新多条消息状态
  Future<void> updateMultipleMessageStatus(
    List<String> messageIds,
    String status,
  ) async {
    await batch((batch) {
      for (final id in messageIds) {
        batch.update(
          chatMessagesTable,
          ChatMessagesTableCompanion(status: Value(status)),
          where: (t) => t.id.equals(id),
        );
      }
    });
  }

  /// 批量删除会话及其消息
  Future<void> deleteChatSessionBatch(List<String> sessionIds) async {
    await transaction(() async {
      // 先删除消息
      for (final sId in sessionIds) {
        await (delete(
          chatMessagesTable,
        )..where((t) => t.chatSessionId.equals(sId))).go();
      }
      // 再删除会话
      await batch((b) {
        for (final sId in sessionIds) {
          b.deleteWhere(chatSessionsTable, (t) => t.id.equals(sId));
        }
      });
    });
  }

  /// 分批插入知识库文本块，避免一次性事务过大
  Future<void> insertKnowledgeChunksBatch(
    List<KnowledgeChunksTableCompanion> chunks, {
    int batchSize = 100,
  }) async {
    for (var i = 0; i < chunks.length; i += batchSize) {
      final sub = chunks.skip(i).take(batchSize).toList();
      await batch((b) {
        b.insertAll(knowledgeChunksTable, sub);
      });
    }
  }

  // ---------- 缓存辅助 ----------
  Future<PersonasTableData?> getPersonaByIdCached(String id) async {
    if (_personaCache.containsKey(id)) return _personaCache[id];
    final persona = await getPersonaById(id);
    if (persona != null) _personaCache[id] = persona;
    return persona;
  }

  void _clearPersonaCache([String? id]) {
    if (id != null) {
      _personaCache.remove(id);
    } else {
      _personaCache.clear();
    }
  }

  // ---------- 流式查询 ----------
  Stream<List<ChatMessagesTableData>> watchMessagesBySession(String sessionId) {
    return (select(chatMessagesTable)
          ..where((t) => t.chatSessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .watch();
  }

  // ---------- 优化搜索 ----------
  Future<List<PersonasTableData>> searchPersonasOptimized(String query) {
    if (query.length < 2) return Future.value([]);
    final lower = query.toLowerCase();
    return (select(personasTable)
          ..where(
            (t) =>
                t.name.lower().contains(lower) |
                t.description.lower().contains(lower),
          )
          ..limit(20))
        .get();
  }

  Future<List<KnowledgeChunksTableData>> searchChunksOptimized(
    String query, {
    int limit = 10,
  }) {
    if (query.length < 3) return Future.value([]);
    final lower = query.toLowerCase();
    return (select(knowledgeChunksTable)
          ..where((t) => t.content.lower().contains(lower))
          ..limit(limit))
        .get();
  }

  // ---------- 仪表盘统计 ----------
  Future<Map<String, int>> getDashboardStatsBatch() async {
    final results = await Future.wait([
      getChatSessionCount(),
      getMessageCount(),
      getPersonaCount(),
      getKnowledgeDocumentCount(),
    ]);
    return {
      'sessions': results[0],
      'messages': results[1],
      'personas': results[2],
      'documents': results[3],
    };
  }
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(
      file,
      setup: (db) {
        db.execute('PRAGMA journal_mode=WAL');
        db.execute('PRAGMA synchronous=NORMAL');
        db.execute('PRAGMA cache_size=10000');
        db.execute('PRAGMA temp_store=MEMORY');
        db.execute('PRAGMA mmap_size=134217728'); // 128MB
      },
    );
  });
}
