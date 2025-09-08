import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

/// 现代化知识库文档卡片
class ModernKnowledgeCard extends StatefulWidget {
  final String title;
  final String fileType;
  final int fileSize;
  final String status;
  final DateTime uploadedAt;
  final double? processingProgress;
  final String? errorMessage;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onReprocess;

  const ModernKnowledgeCard({
    super.key,
    required this.title,
    required this.fileType,
    required this.fileSize,
    required this.status,
    required this.uploadedAt,
    this.processingProgress,
    this.errorMessage,
    this.onTap,
    this.onDelete,
    this.onReprocess,
  });

  @override
  State<ModernKnowledgeCard> createState() => _ModernKnowledgeCardState();
}

class _ModernKnowledgeCardState extends State<ModernKnowledgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _controller.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _controller.reverse();
            },
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 1,
                  ),
                  boxShadow: _isHovered
                      ? AppTheme.elevatedShadow
                      : AppTheme.cardShadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 头部：文件图标、标题、操作按钮
                      Row(
                        children: [
                          _buildFileIcon(),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppTheme.spacingXS),
                                Text(
                                  '${_formatFileSize(widget.fileSize)} • ${widget.fileType.toUpperCase()}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          _buildActionButtons(),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingM),

                      // 状态指示器
                      _buildStatusIndicator(),

                      // 处理进度
                      if (widget.processingProgress != null) ...[
                        const SizedBox(height: AppTheme.spacingM),
                        _buildProgressIndicator(),
                      ],

                      // 错误信息
                      if (widget.errorMessage != null) ...[
                        const SizedBox(height: AppTheme.spacingM),
                        _buildErrorMessage(),
                      ],

                      const SizedBox(height: AppTheme.spacingM),

                      // 底部信息
                      Row(
                        children: [
                          Icon(
                            Icons.upload_file,
                            size: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: AppTheme.spacingXS),
                          Text(
                            '上传于 ${_formatUploadTime()}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileIcon() {
    IconData iconData;
    Color iconColor;

    switch (widget.fileType.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'txt':
        iconData = Icons.text_snippet;
        iconColor = Colors.green;
        break;
      case 'md':
        iconData = Icons.code;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onReprocess != null && widget.status == 'error')
          IconButton(
            onPressed: widget.onReprocess,
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: '重新处理',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        if (widget.onDelete != null) ...[
          const SizedBox(width: AppTheme.spacingXS),
          IconButton(
            onPressed: widget.onDelete,
            icon: const Icon(Icons.delete, size: 20),
            tooltip: '删除',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (widget.status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = '已完成';
        break;
      case 'processing':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = '处理中';
        break;
      case 'error':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = '处理失败';
        break;
      case 'pending':
        statusColor = Colors.grey;
        statusIcon = Icons.schedule;
        statusText = '等待处理';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = widget.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: AppTheme.spacingXS),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '处理进度',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '${(widget.processingProgress! * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusXS),
          child: LinearProgressIndicator(
            value: widget.processingProgress,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              widget.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String _formatUploadTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.uploadedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}

/// 拖拽上传区域
class DragDropUploadArea extends StatefulWidget {
  final VoidCallback? onTap;
  final Function(List<String>)? onFilesDropped;
  final bool isUploading;
  final String title;
  final String subtitle;

  const DragDropUploadArea({
    super.key,
    this.onTap,
    this.onFilesDropped,
    this.isUploading = false,
    this.title = '拖拽文件到此处',
    this.subtitle = '或点击选择文件',
  });

  @override
  State<DragDropUploadArea> createState() => _DragDropUploadAreaState();
}

class _DragDropUploadAreaState extends State<DragDropUploadArea> {
  final bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isUploading ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 200,
        decoration: BoxDecoration(
          color: _isDragOver
              ? Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: _isDragOver
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: _isDragOver ? 2 : 1,
            style: BorderStyle.solid,
          ),
        ),
        child: widget.isUploading ? _buildUploadingState() : _buildIdleState(),
      ),
    );
  }

  Widget _buildIdleState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Icon(
            Icons.cloud_upload,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(
          widget.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(
          '支持 PDF、DOC、DOCX、TXT、MD 格式',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.3),
          highlightColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.cloud_upload,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(
          '正在上传...',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.spacingS),
        const CircularProgressIndicator(),
      ],
    );
  }
}
