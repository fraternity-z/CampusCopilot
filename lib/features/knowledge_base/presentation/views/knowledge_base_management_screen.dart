import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/keyboard_utils.dart';

import '../providers/multi_knowledge_base_provider.dart';
import '../providers/knowledge_base_config_provider.dart';
import '../../domain/entities/knowledge_base.dart';
import '../widgets/system_status_widget.dart';
import 'knowledge_base_create_dialog.dart';
import 'knowledge_base_edit_dialog.dart';
import 'knowledge_base_config_create_dialog.dart';

/// 知识库管理界面
class KnowledgeBaseManagementScreen extends ConsumerStatefulWidget {
  const KnowledgeBaseManagementScreen({super.key});

  @override
  ConsumerState<KnowledgeBaseManagementScreen> createState() =>
      _KnowledgeBaseManagementScreenState();
}

class _KnowledgeBaseManagementScreenState
    extends ConsumerState<KnowledgeBaseManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final multiKbState = ref.watch(multiKnowledgeBaseProvider);

    return GestureDetector(
      onTap: () {
        // 点击空白处收起键盘
        KeyboardUtils.hideKeyboard(context);
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('知识库管理'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(multiKnowledgeBaseProvider.notifier).reload();
              },
            ),
          ],
        ),
        body: multiKbState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : multiKbState.error != null
            ? _buildErrorView(multiKbState.error!)
            : _buildMainContent(multiKbState.knowledgeBases),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateDialog(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text('加载失败', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(multiKnowledgeBaseProvider.notifier).reload();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<KnowledgeBase> knowledgeBases) {
    return Column(
      children: [
        // 系统状态监控组件
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SystemStatusWidget(
            showDetails: false,
            onTap: () => SystemStatusDialog.show(context),
          ),
        ),
        // 知识库列表
        Expanded(child: _buildKnowledgeBaseList(knowledgeBases)),
      ],
    );
  }

  Widget _buildKnowledgeBaseList(List<KnowledgeBase> knowledgeBases) {
    if (knowledgeBases.isEmpty) {
      return _buildEmptyView();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: knowledgeBases.length,
      itemBuilder: (context, index) {
        final knowledgeBase = knowledgeBases[index];
        return _buildKnowledgeBaseCard(knowledgeBase);
      },
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('暂无知识库', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            '点击右下角的 + 按钮创建您的第一个知识库',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeBaseCard(KnowledgeBase knowledgeBase) {
    final currentKb = ref
        .watch(multiKnowledgeBaseProvider)
        .currentKnowledgeBase;
    final isSelected = currentKb?.id == knowledgeBase.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: knowledgeBase.getColor(),
          child: Icon(knowledgeBase.getIcon(), color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                knowledgeBase.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (knowledgeBase.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '默认',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                  ),
                ),
              ),
            if (!knowledgeBase.isEnabled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '已禁用',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (knowledgeBase.description != null) ...[
              const SizedBox(height: 4),
              Text(knowledgeBase.description!),
            ],
            const SizedBox(height: 4),
            Text(
              knowledgeBase.getStatusDescription(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '创建时间: ${_formatDate(knowledgeBase.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, knowledgeBase),
          itemBuilder: (context) => [
            if (!isSelected)
              const PopupMenuItem(
                value: 'select',
                child: ListTile(
                  leading: Icon(Icons.check_circle_outline),
                  title: Text('选择'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('编辑'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('刷新统计'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (!knowledgeBase.isDefault)
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
        onTap: () {
          if (!isSelected) {
            ref
                .read(multiKnowledgeBaseProvider.notifier)
                .selectKnowledgeBase(knowledgeBase.id);
          }
        },
      ),
    );
  }

  void _handleMenuAction(String action, KnowledgeBase knowledgeBase) {
    switch (action) {
      case 'select':
        ref
            .read(multiKnowledgeBaseProvider.notifier)
            .selectKnowledgeBase(knowledgeBase.id);
        break;
      case 'edit':
        _showEditDialog(knowledgeBase);
        break;
      case 'refresh':
        ref
            .read(multiKnowledgeBaseProvider.notifier)
            .refreshStats(knowledgeBase.id);
        break;
      case 'delete':
        _showDeleteConfirmDialog(knowledgeBase);
        break;
    }
  }

  void _showCreateDialog() {
    final configState = ref.read(knowledgeBaseConfigProvider);

    // 如果没有配置，先提示用户创建配置
    if (configState.configs.isEmpty) {
      _showNoConfigDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const KnowledgeBaseCreateDialog(),
    );
  }

  void _showNoConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('需要先创建知识库配置'),
        content: const Text(
          '创建知识库前，需要先配置嵌入模型。您可以：\n\n'
          '1. 直接创建知识库配置（如果已有LLM配置）\n'
          '2. 先到设置页面配置LLM提供商和模型',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showConfigCreateDialog();
            },
            child: const Text('创建配置'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 导航到设置页面
              Navigator.of(context).pushNamed('/settings');
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  void _showConfigCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => const KnowledgeBaseConfigCreateDialog(),
    );
  }

  void _showEditDialog(KnowledgeBase knowledgeBase) {
    showDialog(
      context: context,
      builder: (context) =>
          KnowledgeBaseEditDialog(knowledgeBase: knowledgeBase),
    );
  }

  void _showDeleteConfirmDialog(KnowledgeBase knowledgeBase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text(
          '确定要删除知识库 "${knowledgeBase.name}" 吗？\n\n此操作将删除该知识库中的所有文档和数据，且无法恢复。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(multiKnowledgeBaseProvider.notifier)
                  .deleteKnowledgeBase(knowledgeBase.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
