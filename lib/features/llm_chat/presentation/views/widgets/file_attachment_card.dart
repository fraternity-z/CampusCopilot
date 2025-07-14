import 'package:flutter/material.dart';
import '../../../domain/entities/chat_message.dart';

/// 文件附件卡片组件
///
/// 用于在聊天消息中显示文件附件信息，包括：
/// - 文件图标（根据文件类型）
/// - 文件名
/// - 文件大小
/// - 文件类型
class FileAttachmentCard extends StatelessWidget {
  final FileAttachment attachment;
  final VoidCallback? onTap;

  const FileAttachmentCard({super.key, required this.attachment, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 文件图标
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getFileTypeColor(
                    attachment.fileType,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFileTypeIcon(attachment.fileType),
                  color: _getFileTypeColor(attachment.fileType),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // 文件信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 文件名
                    Text(
                      attachment.fileName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 文件大小和类型
                    Row(
                      children: [
                        Text(
                          _formatFileSize(attachment.fileSize),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getFileTypeColor(
                              attachment.fileType,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            attachment.fileType.toUpperCase(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getFileTypeColor(attachment.fileType),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 操作图标（可选）
              if (onTap != null)
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 根据文件类型获取图标
  IconData _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'md':
        return Icons.article;
      case 'html':
        return Icons.web;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
        return Icons.audio_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// 根据文件类型获取颜色
  Color _getFileTypeColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'txt':
        return Colors.green;
      case 'md':
        return Colors.orange;
      case 'html':
        return Colors.purple;
      case 'xls':
      case 'xlsx':
        return Colors.teal;
      case 'ppt':
      case 'pptx':
        return Colors.deepOrange;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.brown;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Colors.pink;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
        return Colors.indigo;
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  /// 格式化文件大小
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
