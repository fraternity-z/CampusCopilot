import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../domain/entities/knowledge_document.dart';
import '../providers/knowledge_base_provider.dart';

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
    return Scaffold(
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleDocumentAction(value, document),
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
                        title: Text('删除', style: TextStyle(color: Colors.red)),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        final searchQuery = knowledgeState.searchQuery;

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

        if (searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('未找到包含 "$searchQuery" 的文档'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final document = searchResults[index];
            return _buildSearchResultCard(document, searchQuery);
          },
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '索引设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: const Text('文本块大小'),
                  subtitle: const Text('每个文本块的最大字符数'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue: '1000',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                ListTile(
                  title: const Text('重叠大小'),
                  subtitle: const Text('相邻文本块的重叠字符数'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue: '200',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
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
                      initialValue: '5',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                ListTile(
                  title: const Text('相似度阈值'),
                  subtitle: const Text('搜索结果的最小相似度'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      initialValue: '0.7',
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'md', 'docx'],
        allowMultiple: true,
      );

      if (result != null) {
        for (final file in result.files) {
          if (file.path != null) {
            try {
              // 读取文件内容
              final fileContent = await File(file.path!).readAsString();

              // 上传文档
              await ref.read(knowledgeBaseProvider.notifier).uploadDocument(
                    title: file.name,
                    content: fileContent,
                    filePath: file.path!,
                    fileType: file.extension ?? 'unknown',
                    fileSize: file.size,
                  );

              if (!mounted) continue;
              scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('文档 ${file.name} 上传成功')));
            } catch (e) {
              if (!mounted) continue;
              scaffoldMessenger
                  .showSnackBar(SnackBar(content: Text('上传失败: $e')));
            }
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger
          .showSnackBar(const SnackBar(content: Text('文档上传失败')));
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(knowledgeBaseProvider.notifier).reindexDocuments();
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('文档 ${document.title} 重新索引完成')));
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('重新索引失败: $e')));
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
                scaffoldMessenger
                    .showSnackBar(SnackBar(content: Text('删除失败: $e')));
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
                scaffoldMessenger
                    .showSnackBar(const SnackBar(content: Text('索引重建完成')));
              } catch (e) {
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger
                    .showSnackBar(SnackBar(content: Text('重建索引失败: $e')));
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
                scaffoldMessenger
                    .showSnackBar(const SnackBar(content: Text('知识库已清空')));
              } catch (e) {
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger
                    .showSnackBar(SnackBar(content: Text('清空失败: $e')));
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
      case '已完成':
        return Colors.green;
      case '处理中':
        return Colors.orange;
      case '失败':
        return Colors.red;
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
}
