import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 图片查看器屏幕
///
/// 支持功能：
/// - 多图片浏览
/// - 缩放和平移
/// - 保存图片
class ImageViewerScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // 隐藏系统UI，进入全屏模式
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _pageController.dispose();

    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // 隐藏浮动操作按钮
      floatingActionButton: null,
      body: GestureDetector(
        // 添加全局手势检测，支持双击返回
        onDoubleTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            // 图片查看器
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _toggleUI,
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Center(child: _buildImage(widget.imageUrls[index])),
                  ),
                );
              },
            ),

            // 顶部工具栏
            if (_isVisible)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          // 返回按钮 - 增加背景以提高可见性
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const Spacer(),
                          // 页面指示器
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentIndex + 1} / ${widget.imageUrls.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // 更多选项按钮
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onPressed: _showMoreOptions,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // 底部指示器
            if (_isVisible && widget.imageUrls.length > 1)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imageUrls.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentIndex
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建图片组件
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('data:image/')) {
      // Base64 图片
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
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
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else if (imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://')) {
      // 网络图片
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          );
        },
      );
    } else {
      // 其他情况，尝试作为本地文件处理
      return Image.file(
        File(imageUrl),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }
  }

  /// 构建错误组件
  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.white, size: 64),
          SizedBox(height: 16),
          Text('图片加载失败', style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  /// 切换UI显示状态
  void _toggleUI() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  /// 显示更多选项
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('保存图片'),
                onTap: () {
                  Navigator.pop(context);
                  _saveImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 保存图片
  Future<void> _saveImage() async {
    try {
      final currentImageUrl = widget.imageUrls[_currentIndex];

      // 请求存储权限
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('需要存储权限才能保存图片')));
        }
        return;
      }

      // 显示加载提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('正在保存图片...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      Uint8List? imageBytes;

      if (currentImageUrl.startsWith('data:image/')) {
        // Base64 图片
        final base64String = currentImageUrl.split(',')[1];
        imageBytes = base64Decode(base64String);
      } else if (currentImageUrl.startsWith('file://')) {
        // 本地文件
        final filePath = currentImageUrl.substring(7);
        final file = File(filePath);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        }
      } else if (currentImageUrl.startsWith('http')) {
        // 网络图片
        final response = await http.get(Uri.parse(currentImageUrl));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        }
      }

      if (imageBytes == null) {
        throw Exception('无法获取图片数据');
      }

      // 获取下载目录
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('无法获取存储目录');
      }

      // 生成文件名
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'anywherechat_image_$timestamp.png';
      final filePath = '${directory.path}/$fileName';

      // 保存文件
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      // 隐藏加载提示并显示成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('图片已保存到: $filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // 隐藏加载提示并显示错误消息
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
