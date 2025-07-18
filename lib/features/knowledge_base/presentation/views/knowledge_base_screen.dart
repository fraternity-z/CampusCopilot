import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../shared/utils/keyboard_utils.dart';

import '../../domain/entities/knowledge_document.dart';
import '../providers/knowledge_base_provider.dart';
import '../providers/knowledge_base_config_provider.dart';
import '../providers/document_processing_provider.dart';
import '../../data/providers/concurrent_document_processing_provider.dart';
import '../../domain/services/concurrent_document_processing_service.dart';
import '../../../../core/widgets/elegant_notification.dart';
import 'knowledge_base_management_screen.dart';
import '../providers/rag_provider.dart';
import '../../domain/services/vector_search_service.dart';
import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../../core/di/database_providers.dart';
import '../providers/multi_knowledge_base_provider.dart';

/// 知识库管理界面
///
/// 用于管理RAG知识库，包含：
/// - 文档上传和管理
/// - 文档预处理和索引
/// - 知识库搜索测试
/// - 向量数据库管理
class KnowledgeBaseScreen extends ConsumerStatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  ConsumerState<KnowledgeBaseScreen> createState() =>
      _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends ConsumerState<KnowledgeBaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 监听知识库选择变化，重新加载文档
    ref.listen(multiKnowledgeBaseProvider, (previous, next) {
      if (previous?.currentKnowledgeBase?.id != next.currentKnowledgeBase?.id) {
        // 知识库选择发生变化，重新加载文档
        ref.read(knowledgeBaseProvider.notifier).reloadDocuments();
      }
    });

    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('知识库'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.folder), text: '文档'),
              Tab(icon: Icon(Icons.search), text: '搜索'),
              Tab(icon: Icon(Icons.settings), text: '设置'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.library_books),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const KnowledgeBaseManagementScreen(),
                  ),
                );
              },
              tooltip: '知识库管理',
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: _uploadDocument,
              tooltip: '上传文档',
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDocumentsTab(),
            _buildSearchTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  /// 构建文档管理标签页
  Widget _buildDocumentsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final knowledgeState = ref.watch(knowledgeBaseProvider);
        final documents = knowledgeState.documents;

        if (knowledgeState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (knowledgeState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text('加载失败: ${knowledgeState.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(knowledgeBaseProvider),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (documents.isEmpty) {
          return _buildEmptyDocumentsState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(knowledgeBaseProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return _buildDocumentCard(document);
            },
          ),
        );
      },
    );
  }

  /// 构建空文档状态
  Widget _buildEmptyDocumentsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '还没有文档',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '上传文档来构建你的知识库',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _uploadDocument,
            icon: const Icon(Icons.upload_file),
            label: const Text('上传文档'),
          ),
        ],
      ),
    );
  }

  /// 构建文档卡片
  Widget _buildDocumentCard(KnowledgeDocument document) {
    return Consumer(
      builder: (context, ref, child) {
        final processingProgress = ref.watch(
          documentProgressProvider(document.id),
        );
        final processingError = ref.watch(documentErrorProvider(document.id));

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      document.fileTypeIcon,
                      color: _getDocumentColor(document.fileType),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${document.formattedFileSize} • ${document.formattedStatus}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),

                          // 显示处理进度
                          if (processingProgress != null) ...[
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: processingProgress,
                              backgroundColor: Colors.grey[300],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '处理中... ${(processingProgress * 100).toInt()}%',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ],

                          // 显示处理错误
                          if (processingError != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.red[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 16,
                                    color: Colors.red[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '处理失败: $processingError',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) =>
                          _handleDocumentAction(value, document),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'reindex',
                          child: ListTile(
                            leading: Icon(Icons.refresh),
                            title: Text('重新索引'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text(
                              '删除',
                              style: TextStyle(color: Colors.red),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 显示状态标签
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(document.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    document.formattedStatus,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      document.status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(document.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '上传于 ${_formatDate(document.uploadedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建搜索标签页
  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 搜索输入框
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '在知识库中搜索...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _performSearch,
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _performSearch(),
          ),

          const SizedBox(height: 16),

          // 搜索结果
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  /// 构建搜索结果
  Widget _buildSearchResults() {
    return Consumer(
      builder: (context, ref, child) {
        final knowledgeState = ref.watch(knowledgeBaseProvider);
        final searchResults = knowledgeState.searchResults;
        final vectorSearchResults = knowledgeState.vectorSearchResults;
        final searchQuery = knowledgeState.searchQuery;
        final searchTime = knowledgeState.searchTime;

        if (searchQuery.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('输入关键词开始搜索'),
              ],
            ),
          );
        }

        if (knowledgeState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // 优先显示向量搜索结果
        if (vectorSearchResults.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 搜索统计信息
              _buildSearchStats(vectorSearchResults.length, searchTime),
              const SizedBox(height: 16),

              // 向量搜索结果
              Expanded(
                child: ListView.builder(
                  itemCount: vectorSearchResults.length,
                  itemBuilder: (context, index) {
                    final result = vectorSearchResults[index];
                    return _buildVectorSearchResultCard(result, searchQuery);
                  },
                ),
              ),
            ],
          );
        }

        // 回退到文档搜索结果
        if (searchResults.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchStats(searchResults.length, null),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final document = searchResults[index];
                    return _buildSearchResultCard(document, searchQuery);
                  },
                ),
              ),
            ],
          );
        }

        // 无结果
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text('未找到包含 "$searchQuery" 的内容'),
              const SizedBox(height: 8),
              Text(
                '尝试使用不同的关键词或检查拼写',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建搜索结果卡片
  Widget _buildSearchResultCard(KnowledgeDocument document, String query) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  document.fileTypeIcon,
                  color: _getDocumentColor(document.fileType),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    document.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getContentPreview(document.content, query),
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  document.formattedFileSize,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  document.formattedStatus,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getStatusColor(document.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 获取内容预览（高亮搜索词）
  String _getContentPreview(String content, String query) {
    if (content.isEmpty) return '无内容预览';

    final lowerContent = content.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerContent.indexOf(lowerQuery);

    if (index == -1) {
      return content.length > 100 ? '${content.substring(0, 100)}...' : content;
    }

    final start = (index - 50).clamp(0, content.length);
    final end = (index + query.length + 50).clamp(0, content.length);

    String preview = content.substring(start, end);
    if (start > 0) preview = '...$preview';
    if (end < content.length) preview = '$preview...';

    return preview;
  }

  /// 构建设置标签页
  Widget _buildSettingsTab() {
    final configState = ref.watch(knowledgeBaseConfigProvider);
    final currentConfig = configState.currentConfig;
    final embeddingModels = configState.availableEmbeddingModels;

    // 调试信息
    debugPrint('🔧 知识库设置页面状态:');
    debugPrint('  - 当前配置: ${currentConfig?.name ?? '无'}');
    debugPrint('  - 当前嵌入模型: ${currentConfig?.embeddingModelName ?? '无'}');
    debugPrint('  - 可用嵌入模型数量: ${embeddingModels.length}');
    debugPrint('  - 配置加载状态: ${configState.isLoading ? '加载中' : '已完成'}');
    debugPrint('  - 配置错误: ${configState.error ?? '无'}');
    if (embeddingModels.isNotEmpty) {
      debugPrint(
        '  - 可用模型: ${embeddingModels.map((m) => '${m.name}(${m.type})').join(', ')}',
      );
    } else {
      debugPrint('  - ⚠️ 没有可用的嵌入模型！');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 嵌入模型配置
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '嵌入模型配置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.model_training),
                  title: const Text('嵌入模型'),
                  subtitle: Text(
                    embeddingModels.isEmpty
                        ? '请先在模型设置中配置并启用模型'
                        : (currentConfig != null &&
                              currentConfig.embeddingModelName.isNotEmpty)
                        ? '${currentConfig.embeddingModelName} (点击更改)'
                        : '请选择嵌入模型',
                    style: TextStyle(
                      color: embeddingModels.isEmpty
                          ? Theme.of(context).colorScheme.error
                          : (currentConfig != null &&
                                currentConfig.embeddingModelName.isNotEmpty)
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  trailing: Icon(
                    embeddingModels.isEmpty
                        ? Icons.error_outline
                        : Icons.arrow_forward_ios,
                    size: 16,
                    color: embeddingModels.isEmpty
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    debugPrint('🖱️ 点击嵌入模型选择器');
                    debugPrint(
                      '  - embeddingModels.isEmpty: ${embeddingModels.isEmpty}',
                    );
                    debugPrint(
                      '  - embeddingModels.length: ${embeddingModels.length}',
                    );

                    if (embeddingModels.isEmpty) {
                      _showNoModelsDialog();
                    } else {
                      _showEmbeddingModelSelector(embeddingModels);
                    }
                  },
                ),

                if (currentConfig != null && embeddingModels.isNotEmpty) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('模型信息'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('提供商: ${currentConfig.embeddingModelProvider}'),
                        Text('模型ID: ${currentConfig.embeddingModelId}'),
                      ],
                    ),
                  ),
                ],

                // 添加清理按钮
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.cleaning_services,
                    color: Colors.orange,
                  ),
                  title: const Text('强制清理所有配置'),
                  subtitle: const Text('删除所有知识库配置并重新开始'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _forceCleanupAllConfigs,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 分块设置
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '文档分块设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: const Text('分块大小'),
                  subtitle: const Text('每个文本块的最大字符数'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue:
                          currentConfig?.chunkSize.toString() ?? '1000',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) =>
                          _updateChunkSize(int.tryParse(value)),
                    ),
                  ),
                ),

                ListTile(
                  title: const Text('分块重叠'),
                  subtitle: const Text('相邻文本块之间的重叠字符数'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue:
                          currentConfig?.chunkOverlap.toString() ?? '200',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) =>
                          _updateChunkOverlap(int.tryParse(value)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 知识库统计
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '知识库统计',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final statsAsync = ref.watch(
                      unifiedKnowledgeBaseStatsProvider,
                    );

                    return statsAsync.when(
                      data: (stats) => _buildStatsGrid(stats),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text('加载统计信息失败: $error'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 搜索设置
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '搜索设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: const Text('返回结果数'),
                  subtitle: const Text('每次搜索返回的最大结果数'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue:
                          currentConfig?.maxRetrievedChunks.toString() ?? '5',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) =>
                          _updateMaxRetrievedChunks(int.tryParse(value)),
                    ),
                  ),
                ),

                ListTile(
                  title: const Text('相似度阈值'),
                  subtitle: const Text('搜索结果的最小相似度'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue:
                          currentConfig?.similarityThreshold.toString() ??
                          '0.7',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) =>
                          _updateSimilarityThreshold(double.tryParse(value)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '数据库管理',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('重建索引'),
                  subtitle: const Text('重新处理所有文档并建立索引'),
                  onTap: _rebuildIndex,
                ),

                ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Colors.red),
                  title: const Text(
                    '清空知识库',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('删除所有文档和索引数据'),
                  onTap: _clearKnowledgeBase,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 上传文档
  void _uploadDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'txt',
          'md',
          'docx',
          'pptx',
          'xlsx',
          'csv',
          'json',
          'xml',
          'html',
          'htm',
        ],
        allowMultiple: true,
      );

      if (result != null) {
        // 准备文档信息列表
        final documents = <DocumentUploadInfo>[];

        for (final file in result.files) {
          if (file.path != null) {
            final documentId =
                '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
            documents.add(
              DocumentUploadInfo(
                documentId: documentId,
                filePath: file.path!,
                fileType: file.extension ?? 'unknown',
                title: file.name,
                fileSize: file.size,
              ),
            );

            // 先保存文档记录到数据库
            await ref
                .read(knowledgeBaseProvider.notifier)
                .uploadDocument(
                  documentId: documentId, // 传递documentId
                  title: file.name,
                  content: '', // 内容将在处理完成后更新
                  filePath: file.path!,
                  fileType: file.extension ?? 'unknown',
                  fileSize: file.size,
                );
          }
        }

        if (documents.isNotEmpty) {
          // 使用并发文档处理服务处理所有文档
          final concurrentProcessor = ref.read(
            concurrentDocumentProcessingProvider.notifier,
          );

          // 获取当前选中的知识库ID
          final currentKnowledgeBase = ref
              .read(multiKnowledgeBaseProvider)
              .currentKnowledgeBase;
          final targetKnowledgeBaseId =
              currentKnowledgeBase?.id ?? 'default_kb';

          await concurrentProcessor.submitMultipleDocuments(
            documents: documents,
            knowledgeBaseId: targetKnowledgeBaseId,
            chunkSize: 1000,
            chunkOverlap: 200,
          );

          if (!mounted) return;
          ElegantNotification.success(
            context,
            '已提交 ${documents.length} 个文档进行处理',
            duration: const Duration(seconds: 3),
            actionLabel: '查看进度',
            onAction: () {
              // 显示处理进度对话框
              _showProcessingProgressDialog();
            },
            showAtTop: false, // 显示在底部，避免遮挡顶部内容
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ElegantNotification.error(
        context,
        '文档上传失败: $e',
        duration: const Duration(seconds: 4),
        showAtTop: false,
      );
    }
  }

  /// 处理文档操作
  void _handleDocumentAction(String action, KnowledgeDocument document) {
    switch (action) {
      case 'reindex':
        _reindexDocument(document);
        break;
      case 'delete':
        _deleteDocument(document);
        break;
    }
  }

  /// 重新索引文档
  void _reindexDocument(KnowledgeDocument document) async {
    try {
      await ref.read(knowledgeBaseProvider.notifier).reindexDocuments();
      if (!mounted) return;
      ElegantNotification.success(
        context,
        '文档 ${document.title} 重新索引完成',
        duration: const Duration(seconds: 2),
        showAtTop: false,
      );
    } catch (e) {
      if (!mounted) return;
      ElegantNotification.error(
        context,
        '重新索引失败: $e',
        duration: const Duration(seconds: 3),
        showAtTop: false,
      );
    }
  }

  /// 删除文档
  void _deleteDocument(KnowledgeDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除文档'),
        content: Text('确定要删除文档 "${document.title}" 吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await ref
                    .read(knowledgeBaseProvider.notifier)
                    .deleteDocument(document.id);
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('已删除文档: ${document.title}')),
                );
              } catch (e) {
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('删除失败: $e')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 执行搜索
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ref.read(knowledgeBaseProvider.notifier).clearSearch();
      return;
    }

    // 执行搜索
    ref.read(knowledgeBaseProvider.notifier).searchDocuments(query);
  }

  /// 重建索引
  void _rebuildIndex() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重建索引'),
        content: const Text('这将重新处理所有文档并建立索引，可能需要一些时间。确定继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await ref
                    .read(knowledgeBaseProvider.notifier)
                    .reindexDocuments();
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('索引重建完成')),
                );
              } catch (e) {
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('重建索引失败: $e')),
                );
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 清空知识库
  void _clearKnowledgeBase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空知识库'),
        content: const Text('这将删除所有文档和索引数据，此操作无法撤销。确定继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                await ref
                    .read(knowledgeBaseProvider.notifier)
                    .clearAllDocuments();
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('知识库已清空')),
                );
              } catch (e) {
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('清空失败: $e')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 获取文档颜色
  Color _getDocumentColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'txt':
      case 'md':
        return Colors.blue;
      case 'docx':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  /// 获取状态颜色
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
      case '已完成':
        return Colors.green;
      case 'processing':
      case 'saving_chunks':
      case 'generating_embeddings':
      case '处理中':
      case '保存文本块':
      case '生成向量':
        return Colors.orange;
      case 'embedding_failed':
      case 'failed':
      case '向量生成失败':
      case '失败':
        return Colors.red;
      case 'pending':
      case '等待中':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  /// 显示无模型对话框
  void _showNoModelsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('无可用模型'),
        content: const Text('当前没有可用的嵌入模型。请先在设置页面的模型管理中配置并启用至少一个模型。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 导航到模型设置页面
              Navigator.of(context).pushNamed('/settings');
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  /// 显示嵌入模型选择器
  void _showEmbeddingModelSelector(
    List<ModelInfoWithProvider> embeddingModels,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择嵌入模型'),
        content: SizedBox(
          width: double.maxFinite,
          child: embeddingModels.isEmpty
              ? const Text('没有可用的模型，请先在模型设置中配置并启用模型。')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: embeddingModels.length,
                  itemBuilder: (context, index) {
                    final model = embeddingModels[index];
                    return ListTile(
                      leading: _getModelTypeIcon(model.type),
                      title: Text(model.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${model.id} (${_getProviderName(model.id)})'),
                          Text(
                            '类型: ${_getModelTypeName(model.type)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _selectEmbeddingModel(model);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  /// 选择嵌入模型
  void _selectEmbeddingModel(ModelInfoWithProvider model) async {
    try {
      final configNotifier = ref.read(knowledgeBaseConfigProvider.notifier);
      final currentConfig = ref.read(knowledgeBaseConfigProvider).currentConfig;

      // 获取模型的实际提供商信息
      final providerName = await _getActualProviderName(model.id);

      debugPrint('🔧 选择嵌入模型: ${model.name} (${model.id})');
      debugPrint('🏢 提供商: $providerName');

      if (currentConfig != null) {
        // 更新现有配置
        final updatedConfig = currentConfig.copyWith(
          embeddingModelId: model.id,
          embeddingModelName: model.name,
          embeddingModelProvider: providerName,
          updatedAt: DateTime.now(),
        );
        debugPrint('🔄 准备更新配置:');
        debugPrint('  - 原配置: ${currentConfig.embeddingModelName}');
        debugPrint('  - 新配置: ${updatedConfig.embeddingModelName}');

        await configNotifier.updateConfig(updatedConfig);
        debugPrint('✅ 已更新现有配置');

        // 验证更新是否成功
        final newCurrentConfig = ref
            .read(knowledgeBaseConfigProvider)
            .currentConfig;
        debugPrint('🔍 更新后验证:');
        debugPrint('  - 当前配置: ${newCurrentConfig?.embeddingModelName ?? '无'}');
        debugPrint(
          '  - 是否匹配: ${newCurrentConfig?.embeddingModelName == model.name}',
        );
      } else {
        // 创建新配置
        await configNotifier.createConfig(
          name: '默认配置',
          embeddingModelId: model.id,
          embeddingModelName: model.name,
          embeddingModelProvider: providerName,
        );
        debugPrint('✅ 已创建新配置');
      }

      if (mounted) {
        ElegantNotification.success(
          context,
          '已选择嵌入模型: ${model.name} ($providerName)',
          duration: const Duration(seconds: 2),
          showAtTop: false,
        );
      }
    } catch (e) {
      debugPrint('❌ 选择模型失败: $e');
      if (mounted) {
        ElegantNotification.error(
          context,
          '选择模型失败: $e',
          duration: const Duration(seconds: 3),
          showAtTop: false,
        );
      }
    }
  }

  /// 获取模型的实际提供商名称（从数据库配置中查找）
  Future<String> _getActualProviderName(String modelId) async {
    try {
      final database = ref.read(appDatabaseProvider);

      // 获取所有启用的LLM配置
      final allConfigs = await database.getEnabledLlmConfigs();

      // 查找包含该模型的配置
      for (final config in allConfigs) {
        final models = await database.getCustomModelsByConfig(config.id);
        for (final model in models) {
          if (model.modelId == modelId && model.isEnabled) {
            debugPrint('🔍 找到模型 $modelId 属于提供商: ${config.provider}');
            return config.provider;
          }
        }
      }

      // 如果没找到，使用推断方式作为后备
      debugPrint('⚠️ 未在配置中找到模型 $modelId，使用推断方式');
      return _getProviderNameByInference(modelId);
    } catch (e) {
      debugPrint('❌ 获取提供商名称失败: $e');
      return _getProviderNameByInference(modelId);
    }
  }

  /// 通过模型ID推断提供商名称（后备方法）
  String _getProviderNameByInference(String modelId) {
    if (modelId.contains('openai') ||
        modelId.contains('gpt') ||
        modelId.contains('text-embedding')) {
      return 'openai';
    } else if (modelId.contains('google') ||
        modelId.contains('gemini') ||
        modelId.contains('embedding-001')) {
      return 'google';
    } else if (modelId.contains('anthropic') || modelId.contains('claude')) {
      return 'anthropic';
    } else {
      return 'unknown';
    }
  }

  /// 获取提供商名称（保持向后兼容）
  String _getProviderName(String modelId) {
    return _getProviderNameByInference(modelId);
  }

  /// 强制清理所有配置
  void _forceCleanupAllConfigs() async {
    try {
      final configNotifier = ref.read(knowledgeBaseConfigProvider.notifier);

      // 显示确认对话框
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('强制清理所有配置'),
          content: const Text(
            '这将删除所有知识库配置，包括有效的配置。\n\n这是为了解决顽固的配置问题。\n\n确定要继续吗？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('强制清理'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // 调用强制清理方法
        await configNotifier.forceCleanupAllConfigs();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('所有配置已清理完成，请重新配置嵌入模型'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ 强制清理失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('强制清理失败: $e')));
      }
    }
  }

  /// 获取模型类型图标
  Widget _getModelTypeIcon(ModelType type) {
    switch (type) {
      case ModelType.chat:
        return const Icon(Icons.chat, color: Colors.blue, size: 20);
      case ModelType.embedding:
        return const Icon(Icons.text_fields, color: Colors.green, size: 20);
      case ModelType.multimodal:
        return const Icon(Icons.image, color: Colors.purple, size: 20);
      case ModelType.imageGeneration:
        return const Icon(Icons.image, color: Colors.orange, size: 20);
      case ModelType.speech:
        return const Icon(Icons.mic, color: Colors.red, size: 20);
    }
  }

  /// 获取模型类型名称
  String _getModelTypeName(ModelType type) {
    switch (type) {
      case ModelType.chat:
        return '聊天模型';
      case ModelType.embedding:
        return '嵌入模型';
      case ModelType.multimodal:
        return '多模态模型';
      case ModelType.imageGeneration:
        return '图像生成模型';
      case ModelType.speech:
        return '语音模型';
    }
  }

  /// 更新分块大小
  void _updateChunkSize(int? value) {
    if (value != null && value > 0) {
      _updateCurrentConfig((config) => config.copyWith(chunkSize: value));
    }
  }

  /// 更新分块重叠
  void _updateChunkOverlap(int? value) {
    if (value != null && value >= 0) {
      _updateCurrentConfig((config) => config.copyWith(chunkOverlap: value));
    }
  }

  /// 更新最大检索结果数
  void _updateMaxRetrievedChunks(int? value) {
    if (value != null && value > 0) {
      _updateCurrentConfig(
        (config) => config.copyWith(maxRetrievedChunks: value),
      );
    }
  }

  /// 更新相似度阈值
  void _updateSimilarityThreshold(double? value) {
    if (value != null && value >= 0.0 && value <= 1.0) {
      _updateCurrentConfig(
        (config) => config.copyWith(similarityThreshold: value),
      );
    }
  }

  /// 更新当前配置的通用方法
  void _updateCurrentConfig(
    KnowledgeBaseConfig Function(KnowledgeBaseConfig) updater,
  ) {
    final currentConfig = ref.read(knowledgeBaseConfigProvider).currentConfig;
    if (currentConfig != null) {
      final updatedConfig = updater(
        currentConfig,
      ).copyWith(updatedAt: DateTime.now());
      ref
          .read(knowledgeBaseConfigProvider.notifier)
          .updateConfig(updatedConfig);
    }
  }

  /// 构建搜索统计信息
  Widget _buildSearchStats(int resultCount, double? searchTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withAlpha(77),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '找到 $resultCount 个相关结果',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (searchTime != null) ...[
            const SizedBox(width: 16),
            Text(
              '耗时 ${searchTime.toStringAsFixed(0)}ms',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建向量搜索结果卡片
  Widget _buildVectorSearchResultCard(SearchResultItem result, String query) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 相似度和元数据
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getSimilarityColor(result.similarity).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getSimilarityColor(result.similarity),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '相似度 ${(result.similarity * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: _getSimilarityColor(result.similarity),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (result.metadata['searchType'] != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getSearchTypeLabel(
                        result.metadata['searchType'] as String,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  '第${result.chunkIndex + 1}段',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 内容预览
            Text(
              _highlightSearchTerms(result.content, query),
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // 文档来源
            if (result.documentTitle != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.source,
                    size: 14,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '来源: ${result.documentTitle}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // 操作按钮
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _showChunkDetail(result),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('查看详情'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _copyChunkContent(result.content),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('复制'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 获取相似度颜色
  Color _getSimilarityColor(double similarity) {
    if (similarity >= 0.9) return Colors.green;
    if (similarity >= 0.8) return Colors.lightGreen;
    if (similarity >= 0.7) return Colors.orange;
    return Colors.red;
  }

  /// 获取搜索类型标签
  String _getSearchTypeLabel(String searchType) {
    switch (searchType) {
      case 'vector':
        return '向量搜索';
      case 'keyword':
        return '关键词搜索';
      case 'hybrid':
        return '混合搜索';
      default:
        return '未知';
    }
  }

  /// 高亮搜索词
  String _highlightSearchTerms(String content, String query) {
    // 简单实现，实际应该使用RichText来高亮显示
    return content;
  }

  /// 显示文本块详情
  void _showChunkDetail(SearchResultItem result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('文本块详情 (第${result.chunkIndex + 1}段)'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '相似度: ${(result.similarity * 100).toStringAsFixed(2)}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '字符数: ${result.metadata['characterCount'] ?? 'N/A'}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              const Text('内容:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(result.content),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
          TextButton(
            onPressed: () {
              _copyChunkContent(result.content);
              Navigator.of(context).pop();
            },
            child: const Text('复制'),
          ),
        ],
      ),
    );
  }

  /// 复制文本块内容
  void _copyChunkContent(String content) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('内容已复制到剪贴板')));
  }

  /// 构建统计信息网格
  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(
          '总文档数',
          '${stats['totalDocuments'] ?? 0}',
          Icons.description,
          Colors.blue,
        ),
        _buildStatCard(
          '已完成',
          '${stats['completedDocuments'] ?? 0}',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          '文本块数',
          '${stats['totalChunks'] ?? 0}',
          Icons.view_module,
          Colors.orange,
        ),
        _buildStatCard(
          '向量化',
          '${stats['chunksWithEmbeddings'] ?? 0}',
          Icons.scatter_plot,
          Colors.purple,
        ),
      ],
    );
  }

  /// 构建统计卡片
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示处理进度对话框
  void _showProcessingProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => const ProcessingProgressDialog(),
    );
  }
}

/// 处理进度对话框
class ProcessingProgressDialog extends ConsumerWidget {
  const ProcessingProgressDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processingState = ref.watch(concurrentDocumentProcessingProvider);
    final stats = ref.watch(processingStatsProvider);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.blue),
          SizedBox(width: 8),
          Text('文档处理进度'),
        ],
      ),
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 统计信息
            _buildStatsSection(stats),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // 任务列表
            Expanded(
              child: _buildTasksList(processingState.tasks.values.toList()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(concurrentDocumentProcessingProvider.notifier)
                .cleanupCompletedTasks();
          },
          child: const Text('清理已完成'),
        ),
      ],
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('处理统计', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('总任务', '${stats['totalTasks'] ?? 0}'),
              _buildStatItem('处理中', '${stats['processingTasks'] ?? 0}'),
              _buildStatItem('等待中', '${stats['pendingTasks'] ?? 0}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                '已完成',
                '${stats['completedTasks'] ?? 0}',
                Colors.green,
              ),
              _buildStatItem('失败', '${stats['failedTasks'] ?? 0}', Colors.red),
              _buildStatItem(
                '已取消',
                '${stats['cancelledTasks'] ?? 0}',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.blue,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTasksList(List<ConcurrentProcessingTask> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('暂无处理任务'));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(task);
      },
    );
  }

  Widget _buildTaskItem(ConcurrentProcessingTask task) {
    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (task.status) {
      case ConcurrentProcessingTaskStatus.pending:
        statusIcon = Icons.hourglass_empty;
        statusColor = Colors.orange;
        statusText = '等待中';
        break;
      case ConcurrentProcessingTaskStatus.processing:
        statusIcon = Icons.sync;
        statusColor = Colors.blue;
        statusText = '处理中';
        break;
      case ConcurrentProcessingTaskStatus.completed:
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusText = '已完成';
        break;
      case ConcurrentProcessingTaskStatus.failed:
        statusIcon = Icons.error;
        statusColor = Colors.red;
        statusText = '失败';
        break;
      case ConcurrentProcessingTaskStatus.cancelled:
        statusIcon = Icons.cancel;
        statusColor = Colors.grey;
        statusText = '已取消';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(
          task.documentId,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('类型: ${task.fileType}'),
            if (task.status == ConcurrentProcessingTaskStatus.processing)
              LinearProgressIndicator(
                value: task.progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            if (task.error != null)
              Text(
                '错误: ${task.error}',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
        trailing: Text(
          statusText,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
