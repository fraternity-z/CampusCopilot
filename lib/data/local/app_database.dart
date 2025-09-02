import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
import 'tables/knowledge_bases_table.dart';
import 'tables/custom_models_table.dart';
import 'tables/general_settings_table.dart';
import 'tables/plans_table.dart';

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
    KnowledgeBasesTable,
    KnowledgeDocumentsTable,
    KnowledgeChunksTable,
    KnowledgeBaseConfigsTable,
    CustomModelsTable,
    GeneralSettingsTable,
    PlansTable,
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
  int get schemaVersion => 2; // 增加版本号以支持增量迁移

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertDefaultData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 智能迁移策略：支持增量迁移和开发阶段重建
        if (from == 1 && to == 2) {
          // 版本1到2的增量迁移
          await _migrateFromV1ToV2(m);
        } else {
          // 开发阶段：如果版本差异较大，询问是否重建
          // 生产环境：应该实现具体的迁移逻辑
          await _handleComplexMigration(m, from, to);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        await customStatement('PRAGMA optimize');
      },
    );
  }

  /// 插入默认数据
  Future<void> _insertDefaultData() async {
    // 插入默认LLM配置示例（仅作为模板，默认禁用）
    await into(llmConfigsTable).insert(
      LlmConfigsTableCompanion.insert(
        id: 'default-openai',
        name: 'OpenAI 配置模板',
        provider: 'openai',
        apiKey: '',
        defaultModel: const Value(''), // 不设置默认模型
        defaultEmbeddingModel: const Value(''), // 不设置默认嵌入模型
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEnabled: const Value(false), // 默认禁用，需要用户配置
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

  // ==================== 知识库相关查询 ====================

  /// 获取所有知识库
  Future<List<KnowledgeBasesTableData>> getAllKnowledgeBases() {
    return (select(knowledgeBasesTable)
          ..where((t) => t.isEnabled.equals(true))
          ..orderBy([
            (t) => OrderingTerm.desc(t.isDefault), // 默认知识库优先
            (t) => OrderingTerm.desc(t.updatedAt), // 按更新时间排序
          ]))
        .get();
  }

  /// 获取默认知识库
  Future<KnowledgeBasesTableData?> getDefaultKnowledgeBase() async {
    final result =
        await (select(knowledgeBasesTable)
              ..where((t) => t.isDefault.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return result;
  }

  /// 根据ID获取知识库
  Future<KnowledgeBasesTableData?> getKnowledgeBaseById(String id) async {
    return await (select(
      knowledgeBasesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// 创建知识库
  Future<void> createKnowledgeBase(KnowledgeBasesTableCompanion knowledgeBase) {
    return into(knowledgeBasesTable).insert(knowledgeBase);
  }

  /// 更新知识库
  Future<void> updateKnowledgeBase(
    String id,
    KnowledgeBasesTableCompanion knowledgeBase,
  ) {
    return (update(
      knowledgeBasesTable,
    )..where((t) => t.id.equals(id))).write(knowledgeBase);
  }

  /// 删除知识库
  Future<int> deleteKnowledgeBase(String id) {
    return (delete(knowledgeBasesTable)..where((t) => t.id.equals(id))).go();
  }

  /// 更新知识库统计信息
  Future<void> updateKnowledgeBaseStats(String knowledgeBaseId) async {
    // 统计文档数量
    final docCount =
        await (selectOnly(knowledgeDocumentsTable)
              ..addColumns([knowledgeDocumentsTable.id.count()])
              ..where(
                knowledgeDocumentsTable.knowledgeBaseId.equals(knowledgeBaseId),
              ))
            .getSingle();

    // 统计文本块数量
    final chunkCount =
        await (selectOnly(knowledgeChunksTable)
              ..addColumns([knowledgeChunksTable.id.count()])
              ..where(
                knowledgeChunksTable.knowledgeBaseId.equals(knowledgeBaseId),
              ))
            .getSingle();

    // 更新统计信息
    await (update(
      knowledgeBasesTable,
    )..where((t) => t.id.equals(knowledgeBaseId))).write(
      KnowledgeBasesTableCompanion(
        documentCount: Value(
          docCount.read(knowledgeDocumentsTable.id.count()) ?? 0,
        ),
        chunkCount: Value(
          chunkCount.read(knowledgeChunksTable.id.count()) ?? 0,
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ==================== 知识库文档相关查询 ====================

  /// 获取所有知识库文档
  Future<List<KnowledgeDocumentsTableData>> getAllKnowledgeDocuments() {
    return (select(
      knowledgeDocumentsTable,
    )..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)])).get();
  }

  /// 根据知识库ID获取文档
  Future<List<KnowledgeDocumentsTableData>> getDocumentsByKnowledgeBase(
    String knowledgeBaseId,
  ) {
    return (select(knowledgeDocumentsTable)
          ..where((t) => t.knowledgeBaseId.equals(knowledgeBaseId))
          ..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)]))
        .get();
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

  /// 根据ID列表获取文档
  Future<List<KnowledgeDocumentsTableData>> getDocumentsByIds(
    List<String> ids,
  ) {
    if (ids.isEmpty) return Future.value([]);
    return (select(
      knowledgeDocumentsTable,
    )..where((t) => t.id.isIn(ids))).get();
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

  /// 根据知识库ID获取所有文本块
  Future<List<KnowledgeChunksTableData>> getChunksByKnowledgeBase(
    String knowledgeBaseId,
  ) {
    return (select(knowledgeChunksTable)
          ..where((t) => t.knowledgeBaseId.equals(knowledgeBaseId))
          ..orderBy([(t) => OrderingTerm.asc(t.chunkIndex)]))
        .get();
  }

  /// 根据知识库ID获取有嵌入向量的文本块（用于向量搜索）
  Future<List<KnowledgeChunksTableData>> getEmbeddedChunksByKnowledgeBase(
    String knowledgeBaseId,
  ) {
    return (select(knowledgeChunksTable)
          ..where(
            (t) =>
                t.knowledgeBaseId.equals(knowledgeBaseId) &
                t.embedding.isNotNull(),
          )
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

  /// 清理文本块的嵌入向量（设为null）
  Future<void> clearChunkEmbedding(String chunkId) {
    return (update(knowledgeChunksTable)..where((t) => t.id.equals(chunkId)))
        .write(const KnowledgeChunksTableCompanion(embedding: Value(null)));
  }

  /// 获取所有有嵌入向量的文本块
  Future<List<KnowledgeChunksTableData>> getChunksWithEmbeddings() {
    return (select(
      knowledgeChunksTable,
    )..where((t) => t.embedding.isNotNull())).get();
  }

  /// 获取所有有嵌入向量的文本块（别名方法，用于智能检索）
  Future<List<KnowledgeChunksTableData>> getAllChunksWithEmbeddings() {
    return getChunksWithEmbeddings();
  }

  /// 搜索相似文本块（基于内容的简单搜索，后续会被向量搜索替换）
  Future<List<KnowledgeChunksTableData>> searchChunks(String query) {
    final lowerQuery = query.toLowerCase();
    return (select(
      knowledgeChunksTable,
    )..where((t) => t.content.lower().contains(lowerQuery))).get();
  }

  /// 在指定知识库中搜索文本块
  Future<List<KnowledgeChunksTableData>> searchChunksByKnowledgeBase(
    String query,
    String knowledgeBaseId,
  ) {
    final lowerQuery = query.toLowerCase();
    return (select(knowledgeChunksTable)..where(
          (t) =>
              t.knowledgeBaseId.equals(knowledgeBaseId) &
              t.content.lower().contains(lowerQuery),
        ))
        .get();
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

  // ---------- 常规设置管理 ----------

  /// 获取设置值
  Future<String?> getSetting(String key) async {
    final result = await (select(
      generalSettingsTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  /// 设置值
  Future<void> setSetting(String key, String value) async {
    await into(generalSettingsTable).insertOnConflictUpdate(
      GeneralSettingsTableCompanion.insert(
        key: key,
        value: value,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// 删除设置
  Future<void> deleteSetting(String key) async {
    await (delete(generalSettingsTable)..where((t) => t.key.equals(key))).go();
  }

  /// 获取所有设置
  Future<Map<String, String>> getAllSettings() async {
    final results = await select(generalSettingsTable).get();
    return {for (final result in results) result.key: result.value};
  }

  // ==================== 计划管理相关查询 ====================

  /// 获取所有计划
  Future<List<PlansTableData>> getAllPlans() {
    return (select(plansTable)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// 根据ID获取计划
  Future<PlansTableData?> getPlanById(int id) {
    return (select(plansTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// 创建计划
  Future<int> createPlan(PlansTableCompanion plan) {
    return into(plansTable).insert(plan);
  }

  /// 更新计划
  Future<int> updatePlan(int id, PlansTableCompanion plan) {
    return (update(plansTable)..where((t) => t.id.equals(id))).write(plan);
  }

  /// 删除计划
  Future<int> deletePlan(int id) {
    return (delete(plansTable)..where((t) => t.id.equals(id))).go();
  }

  /// 批量删除计划
  Future<void> deletePlans(List<int> ids) async {
    if (ids.isEmpty) return;
    await (delete(plansTable)..where((t) => t.id.isIn(ids))).go();
  }

  /// 根据状态获取计划
  Future<List<PlansTableData>> getPlansByStatus(String status) {
    return (select(plansTable)
          ..where((t) => t.status.equals(status))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// 根据日期获取计划
  Future<List<PlansTableData>> getPlansByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return (select(plansTable)
          ..where((t) => t.planDate.isBiggerOrEqualValue(startOfDay) & 
                        t.planDate.isSmallerThanValue(endOfDay))
          ..orderBy([(t) => OrderingTerm.asc(t.startTime)]))
        .get();
  }

  /// 搜索计划
  Future<List<PlansTableData>> searchPlans(String query) {
    final lowerQuery = query.toLowerCase();
    return (select(plansTable)..where(
          (t) =>
              t.title.lower().contains(lowerQuery) |
              t.description.lower().contains(lowerQuery) |
              t.tags.contains(query),
        ))
        .get();
  }

  /// 更新计划状态
  Future<int> updatePlanStatus(int id, String status) {
    final now = DateTime.now();
    final updates = PlansTableCompanion(
      status: Value(status),
      updatedAt: Value(now),
    );
    
    // 如果是完成状态，设置完成时间
    if (status == 'completed') {
      final updatesWithCompletion = updates.copyWith(
        completedAt: Value(now),
        progress: const Value(100),
      );
      return (update(plansTable)..where((t) => t.id.equals(id)))
          .write(updatesWithCompletion);
    }
    
    return (update(plansTable)..where((t) => t.id.equals(id))).write(updates);
  }

  /// 更新计划进度
  Future<int> updatePlanProgress(int id, int progress) {
    final now = DateTime.now();
    final updates = PlansTableCompanion(
      progress: Value(progress),
      updatedAt: Value(now),
    );
    
    // 如果进度达到100%，自动设为完成状态
    if (progress >= 100) {
      final updatesWithCompletion = updates.copyWith(
        status: const Value('completed'),
        completedAt: Value(now),
      );
      return (update(plansTable)..where((t) => t.id.equals(id)))
          .write(updatesWithCompletion);
    }
    
    return (update(plansTable)..where((t) => t.id.equals(id))).write(updates);
  }

  /// 版本1到2的增量迁移
  Future<void> _migrateFromV1ToV2(Migrator m) async {
    // 在版本1到2之间，如果没有结构变化，可以直接创建新表
    // 这里可以添加具体的迁移逻辑，比如添加新列、索引等
    await m.createAll();
  }

  /// 手动重置数据库（用于开发调试或用户主动重置）
  Future<void> resetDatabase() async {
    await transaction(() async {
      // 删除所有表
      await customStatement('DROP TABLE IF EXISTS llm_configs_table');
      await customStatement('DROP TABLE IF EXISTS personas_table');
      await customStatement('DROP TABLE IF EXISTS persona_groups_table');
      await customStatement('DROP TABLE IF EXISTS chat_sessions_table');
      await customStatement('DROP TABLE IF EXISTS chat_messages_table');
      await customStatement('DROP TABLE IF EXISTS knowledge_bases_table');
      await customStatement('DROP TABLE IF EXISTS knowledge_documents_table');
      await customStatement('DROP TABLE IF EXISTS knowledge_chunks_table');
      await customStatement('DROP TABLE IF EXISTS knowledge_base_configs_table');
      await customStatement('DROP TABLE IF EXISTS custom_models_table');
      await customStatement('DROP TABLE IF EXISTS general_settings_table');
      await customStatement('DROP TABLE IF EXISTS plans_table');

      // 重新创建所有表
      await customStatement('''
        CREATE TABLE llm_configs_table (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          provider TEXT NOT NULL,
          apiKey TEXT,
          defaultModel TEXT,
          defaultEmbeddingModel TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isEnabled INTEGER NOT NULL DEFAULT 0,
          isCustomProvider INTEGER NOT NULL DEFAULT 0,
          baseUrl TEXT,
          customHeaders TEXT,
          timeout INTEGER,
          maxRetries INTEGER,
          rateLimitRequests INTEGER,
          rateLimitWindowMs INTEGER
        )
      ''');

      await customStatement('''
        CREATE TABLE personas_table (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          systemPrompt TEXT,
          apiConfigId TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          category TEXT,
          isDefault INTEGER NOT NULL DEFAULT 0,
          usageCount INTEGER NOT NULL DEFAULT 0,
          lastUsedAt TEXT,
          tags TEXT,
          isEnabled INTEGER NOT NULL DEFAULT 1
        )
      ''');

      await customStatement('''
        CREATE TABLE persona_groups_table (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isExpanded INTEGER NOT NULL DEFAULT 1
        )
      ''');

      await customStatement('''
        CREATE TABLE chat_sessions_table (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          personaId TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isArchived INTEGER NOT NULL DEFAULT 0,
          lastMessageAt TEXT,
          messageCount INTEGER NOT NULL DEFAULT 0
        )
      ''');

      await customStatement('''
        CREATE TABLE chat_messages_table (
          id TEXT PRIMARY KEY,
          chatSessionId TEXT NOT NULL,
          role TEXT NOT NULL,
          content TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          status TEXT NOT NULL DEFAULT 'sent',
          metadata TEXT,
          FOREIGN KEY (chatSessionId) REFERENCES chat_sessions_table (id) ON DELETE CASCADE
        )
      ''');

      await customStatement('''
        CREATE TABLE knowledge_bases_table (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          embeddingModel TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isEnabled INTEGER NOT NULL DEFAULT 1,
          isDefault INTEGER NOT NULL DEFAULT 0,
          documentCount INTEGER NOT NULL DEFAULT 0,
          chunkCount INTEGER NOT NULL DEFAULT 0,
          metadata TEXT
        )
      ''');

      await customStatement('''
        CREATE TABLE knowledge_documents_table (
          id TEXT PRIMARY KEY,
          knowledgeBaseId TEXT NOT NULL,
          fileName TEXT NOT NULL,
          filePath TEXT,
          fileSize INTEGER,
          mimeType TEXT,
          uploadedAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          status TEXT NOT NULL DEFAULT 'processing',
          checksum TEXT,
          metadata TEXT,
          FOREIGN KEY (knowledgeBaseId) REFERENCES knowledge_bases_table (id) ON DELETE CASCADE
        )
      ''');

      await customStatement('''
        CREATE TABLE knowledge_chunks_table (
          id TEXT PRIMARY KEY,
          documentId TEXT NOT NULL,
          knowledgeBaseId TEXT NOT NULL,
          content TEXT NOT NULL,
          embedding TEXT,
          chunkIndex INTEGER NOT NULL,
          metadata TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          FOREIGN KEY (documentId) REFERENCES knowledge_documents_table (id) ON DELETE CASCADE,
          FOREIGN KEY (knowledgeBaseId) REFERENCES knowledge_bases_table (id) ON DELETE CASCADE
        )
      ''');

      await customStatement('''
        CREATE TABLE knowledge_base_configs_table (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          chunkSize INTEGER NOT NULL DEFAULT 1000,
          chunkOverlap INTEGER NOT NULL DEFAULT 200,
          embeddingModel TEXT,
          similarityThreshold REAL NOT NULL DEFAULT 0.7,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isDefault INTEGER NOT NULL DEFAULT 0,
          metadata TEXT
        )
      ''');

      await customStatement('''
        CREATE TABLE custom_models_table (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          provider TEXT NOT NULL,
          modelId TEXT NOT NULL,
          contextWindow INTEGER,
          maxTokens INTEGER,
          supportsFunctionCalling INTEGER NOT NULL DEFAULT 0,
          supportsVision INTEGER NOT NULL DEFAULT 0,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          isEnabled INTEGER NOT NULL DEFAULT 1,
          configId TEXT,
          metadata TEXT
        )
      ''');

      await customStatement('''
        CREATE TABLE general_settings_table (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

      await customStatement('''
        CREATE TABLE plans_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          planDate TEXT NOT NULL,
          startTime TEXT,
          endTime TEXT,
          status TEXT NOT NULL DEFAULT 'pending',
          priority TEXT NOT NULL DEFAULT 'medium',
          progress INTEGER NOT NULL DEFAULT 0,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          completedAt TEXT,
          tags TEXT,
          reminderTime TEXT
        )
      ''');

      // 创建索引
      await customStatement('CREATE INDEX idx_personas_category ON personas_table(category)');
      await customStatement('CREATE INDEX idx_personas_isDefault ON personas_table(isDefault)');
      await customStatement('CREATE INDEX idx_chat_sessions_personaId ON chat_sessions_table(personaId)');
      await customStatement('CREATE INDEX idx_chat_sessions_updatedAt ON chat_sessions_table(updatedAt)');
      await customStatement('CREATE INDEX idx_chat_messages_sessionId ON chat_messages_table(chatSessionId)');
      await customStatement('CREATE INDEX idx_knowledge_documents_baseId ON knowledge_documents_table(knowledgeBaseId)');
      await customStatement('CREATE INDEX idx_knowledge_chunks_documentId ON knowledge_chunks_table(documentId)');
      await customStatement('CREATE INDEX idx_knowledge_chunks_baseId ON knowledge_chunks_table(knowledgeBaseId)');
      await customStatement('CREATE INDEX idx_custom_models_provider ON custom_models_table(provider)');
      await customStatement('CREATE INDEX idx_plans_date ON plans_table(planDate)');
      await customStatement('CREATE INDEX idx_plans_status ON plans_table(status)');

      // 插入默认数据
      await _insertDefaultData();
    });
  }

  /// 处理复杂的迁移情况
  Future<void> _handleComplexMigration(Migrator m, int from, int to) async {
    // 检查是否是开发环境（通过环境变量或其他方式）
    const isDevelopment = bool.fromEnvironment('dart.vm.product') == false;

    if (isDevelopment && from < to) {
      // 开发环境：重建数据库但保留重要数据
      await transaction(() async {
        // 备份重要数据（如果需要）
        final settings = await customSelect('SELECT * FROM general_settings_table').get();
        final personas = await customSelect('SELECT * FROM personas_table WHERE isDefault = 1').get();

        // 删除所有表
        await customStatement('DROP TABLE IF EXISTS llm_configs_table');
        await customStatement('DROP TABLE IF EXISTS personas_table');
        await customStatement('DROP TABLE IF EXISTS persona_groups_table');
        await customStatement('DROP TABLE IF EXISTS chat_sessions_table');
        await customStatement('DROP TABLE IF EXISTS chat_messages_table');
        await customStatement('DROP TABLE IF EXISTS knowledge_bases_table');
        await customStatement('DROP TABLE IF EXISTS knowledge_documents_table');
        await customStatement('DROP TABLE IF EXISTS knowledge_chunks_table');
        await customStatement('DROP TABLE IF EXISTS knowledge_base_configs_table');
        await customStatement('DROP TABLE IF EXISTS custom_models_table');
        await customStatement('DROP TABLE IF EXISTS general_settings_table');
        await customStatement('DROP TABLE IF EXISTS plans_table');

        // 重新创建所有表
        await m.createAll();

        // 恢复重要数据
        if (settings.isNotEmpty) {
          for (final setting in settings) {
            await customInsert(
              'INSERT OR REPLACE INTO general_settings_table (key, value, updatedAt) VALUES (?, ?, ?)',
              variables: [
                Variable<String>(setting.data['key']),
                Variable<String>(setting.data['value']),
                Variable<DateTime>(DateTime.now()),
              ],
            );
          }
        }

        // 恢复默认智能体
        if (personas.isNotEmpty) {
          for (final persona in personas) {
            await customInsert(
              'INSERT OR IGNORE INTO personas_table (id, name, description, systemPrompt, apiConfigId, createdAt, updatedAt, category, isDefault) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
              variables: [
                Variable<String>(persona.data['id']),
                Variable<String>(persona.data['name']),
                Variable<String>(persona.data['description']),
                Variable<String>(persona.data['systemPrompt']),
                Variable<String>(persona.data['apiConfigId']),
                Variable<DateTime>(DateTime.parse(persona.data['createdAt'])),
                Variable<DateTime>(DateTime.now()),
                Variable<String>(persona.data['category']),
                Variable<bool>(persona.data['isDefault'] == 1),
              ],
            );
          }
        }

        // 重新插入默认数据
        await _insertDefaultData();
      });
    } else {
      // 生产环境：抛出错误，需要手动处理迁移
      throw Exception(
        '不支持从版本 $from 迁移到版本 $to。'
        '请联系开发团队获取支持，或手动备份数据后重新安装应用。'
      );
    }
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
