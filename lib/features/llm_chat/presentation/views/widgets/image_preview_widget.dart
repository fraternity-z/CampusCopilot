import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'image_viewer_screen.dart';

/// 图片预览组件
///
/// 用于在聊天消息中显示图片缩略图，支持：
/// - 显示图片缩略图
/// - 点击放大查看
/// - 显示图片文件信息
/// - 支持多张图片的网格布局
class ImagePreviewWidget extends StatelessWidget {
  final List<String> imageUrls;
  final double thumbnailSize;
  final int maxImagesPerRow;
  final bool showFileInfo;

  const ImagePreviewWidget({
    super.key,
    required this.imageUrls,
    this.thumbnailSize = 120,
    this.maxImagesPerRow = 3,
    this.showFileInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 图片网格
        _buildImageGrid(context),

        // 文件信息（可选）
        if (showFileInfo && imageUrls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '共 ${imageUrls.length} 张图片',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    if (imageUrls.length == 1) {
      // 单张图片
      return _buildSingleImage(context, imageUrls.first, 0);
    } else {
      // 多张图片网格
      return _buildMultipleImages(context);
    }
  }

  Widget _buildSingleImage(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _openImageViewer(context, index),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: thumbnailSize * 2,
          maxHeight: thumbnailSize * 1.5,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildImageWidget(imageUrl),
        ),
      ),
    );
  }

  Widget _buildMultipleImages(BuildContext context) {
    // 计算网格布局
    final itemsPerRow = imageUrls.length > maxImagesPerRow
        ? maxImagesPerRow
        : imageUrls.length;
    final rows = (imageUrls.length / itemsPerRow).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        final startIndex = rowIndex * itemsPerRow;
        final endIndex = (startIndex + itemsPerRow).clamp(0, imageUrls.length);
        final rowImages = imageUrls.sublist(startIndex, endIndex);

        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rows - 1 ? 8 : 0),
          child: Row(
            children: List.generate(rowImages.length, (colIndex) {
              final imageIndex = startIndex + colIndex;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: colIndex < rowImages.length - 1 ? 8 : 0,
                  ),
                  child: _buildThumbnail(
                    context,
                    rowImages[colIndex],
                    imageIndex,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildThumbnail(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _openImageViewer(context, index),
      child: Container(
        height: thumbnailSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImageWidget(imageUrl),

              // 如果是最后一张且还有更多图片，显示数量覆盖层
              if (index == maxImagesPerRow - 1 &&
                  imageUrls.length > maxImagesPerRow)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '+${imageUrls.length - maxImagesPerRow}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    if (imageUrl.startsWith('file://')) {
      // 本地文件
      final filePath = imageUrl.substring(7); // 移除 'file://' 前缀
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    } else if (imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://')) {
      // 网络图片
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      // 其他情况，尝试作为本地文件处理
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 32),
      ),
    );
  }

  void _openImageViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'ImageViewer'),
        builder: (context) =>
            ImageViewerScreen(imageUrls: imageUrls, initialIndex: initialIndex),
      ),
    );
  }
}

/// 聊天消息中的图片卡片组件
class MessageImageCard extends StatelessWidget {
  final String imageUrl;
  final String? fileName;
  final int? fileSize;
  final List<String> allImageUrls;
  final int imageIndex;

  const MessageImageCard({
    super.key,
    required this.imageUrl,
    this.fileName,
    this.fileSize,
    required this.allImageUrls,
    required this.imageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () => _openImageViewer(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片预览区域
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: _buildImageWidget(),
                ),
              ),

              // 文件信息区域
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 文件名
                    Text(
                      fileName ?? _getImageFileName(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // 文件大小和类型标签
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (fileSize != null)
                          Text(
                            _formatFileSize(fileSize!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 10,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'IMAGE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.pink,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imageUrl.startsWith('data:image/')) {
      // Base64 图片
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: 150,
          height: 150,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        );
      } catch (e) {
        return _buildErrorWidget();
      }
    } else if (imageUrl.startsWith('file://')) {
      // 本地文件
      final filePath = imageUrl.substring(7);
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else if (imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://')) {
      // 网络图片
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 150,
            height: 150,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      // 其他情况，尝试作为本地文件处理
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      width: 150,
      height: 150,
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: Colors.grey, size: 32),
            SizedBox(height: 4),
            Text('加载失败', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'ImageViewer'),
        builder: (context) => ImageViewerScreen(
          imageUrls: allImageUrls,
          initialIndex: imageIndex,
        ),
      ),
    );
  }

  String _getImageFileName() {
    if (imageUrl.startsWith('data:image/')) {
      return '图片.jpg';
    } else if (imageUrl.contains('/')) {
      return imageUrl.split('/').last;
    } else {
      return '图片';
    }
  }

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

/// 单张图片预览卡片（带文件信息）- 保留用于其他地方
class ImageAttachmentCard extends StatelessWidget {
  final String imageUrl;
  final String? fileName;
  final int? fileSize;
  final VoidCallback? onTap;

  const ImageAttachmentCard({
    super.key,
    required this.imageUrl,
    this.fileName,
    this.fileSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap ?? () => _openImageViewer(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 图片缩略图
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildThumbnailImage(),
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
                      fileName ?? '图片',
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
                        if (fileSize != null)
                          Text(
                            _formatFileSize(fileSize!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'IMAGE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.pink,
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

              // 操作图标
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

  Widget _buildThumbnailImage() {
    if (imageUrl.startsWith('data:image/')) {
      // Base64 图片
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: 48,
          height: 48,
          errorBuilder: (context, error, stackTrace) =>
              _buildThumbnailErrorWidget(),
        );
      } catch (e) {
        return _buildThumbnailErrorWidget();
      }
    } else if (imageUrl.startsWith('file://')) {
      // 本地文件
      final filePath = imageUrl.substring(7);
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) =>
            _buildThumbnailErrorWidget(),
      );
    } else if (imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://')) {
      // 网络图片
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) =>
            _buildThumbnailErrorWidget(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 48,
            height: 48,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            ),
          );
        },
      );
    } else {
      // 其他情况，尝试作为本地文件处理
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: 48,
        height: 48,
        errorBuilder: (context, error, stackTrace) =>
            _buildThumbnailErrorWidget(),
      );
    }
  }

  Widget _buildThumbnailErrorWidget() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 20),
      ),
    );
  }

  void _openImageViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'ImageViewer'),
        builder: (context) =>
            ImageViewerScreen(imageUrls: [imageUrl], initialIndex: 0),
      ),
    );
  }

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
