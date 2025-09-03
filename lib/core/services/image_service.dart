import 'dart:io';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../shared/utils/debug_log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// 图片处理服务
///
/// 提供图片选择、压缩、存储和转换功能
class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();

  /// 从相册选择图片
  Future<List<ImageResult>> pickImagesFromGallery({
    int maxImages = 5,
    int? imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1080,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (images.length > maxImages) {
        debugLog(() =>'选择的图片数量超过限制，只处理前$maxImages张');
        return await _processImages(images.take(maxImages).toList());
      }

      return await _processImages(images);
    } catch (e) {
      debugLog(() =>'从相册选择图片失败: $e');
      throw ImageServiceException('选择图片失败: $e');
    }
  }

  /// 拍摄照片
  Future<ImageResult?> capturePhoto({
    int? imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1080,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) return null;

      final results = await _processImages([image]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      debugLog(() =>'拍摄照片失败: $e');
      throw ImageServiceException('拍摄照片失败: $e');
    }
  }

  /// 从相册选择单张图片
  Future<ImageResult?> pickSingleImageFromGallery({
    int? imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1080,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image == null) return null;

      final results = await _processImages([image]);
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      debugLog(() =>'选择图片失败: $e');
      throw ImageServiceException('选择图片失败: $e');
    }
  }

  /// 处理单个XFile图片（公共方法）
  Future<ImageResult> processImageFromXFile(XFile image) async {
    return await _processImage(image);
  }

  /// 处理图片列表
  Future<List<ImageResult>> _processImages(List<XFile> images) async {
    final List<ImageResult> results = [];

    for (final image in images) {
      try {
        final result = await _processImage(image);
        results.add(result);
      } catch (e) {
        debugLog(() =>'处理图片失败: ${image.name}, 错误: $e');
        // 继续处理其他图片，不因为单张图片失败而中断
      }
    }

    return results;
  }

  /// 处理单张图片
  Future<ImageResult> _processImage(XFile image) async {
    // 读取图片数据
    final bytes = await image.readAsBytes();
    final originalSize = bytes.length;

    // 获取图片信息
    final fileName = path.basename(image.path);
    final fileExtension = path.extension(image.path).toLowerCase();

    // 生成唯一文件名
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFileName = '${timestamp}_$fileName';

    // 保存到应用目录
    final savedPath = await _saveImageToAppDirectory(bytes, uniqueFileName);

    // 转换为Base64（用于API调用）
    final base64String = await _convertToBase64(bytes, fileExtension);

    // 创建缩略图（用于UI显示）
    final thumbnailBytes = await _createThumbnail(bytes);

    return ImageResult(
      originalPath: image.path,
      savedPath: savedPath,
      fileName: fileName,
      uniqueFileName: uniqueFileName,
      fileExtension: fileExtension,
      originalSize: originalSize,
      compressedSize: bytes.length,
      base64String: base64String,
      thumbnailBytes: thumbnailBytes,
      width: null, // 可以后续添加图片尺寸检测
      height: null,
    );
  }

  /// 保存图片到应用目录
  Future<String> _saveImageToAppDirectory(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(directory.path, 'images'));

      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final file = File(path.join(imagesDir.path, fileName));
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      debugLog(() =>'保存图片失败: $e');
      throw ImageServiceException('保存图片失败: $e');
    }
  }

  /// 转换为Base64格式
  Future<String> _convertToBase64(Uint8List bytes, String extension) async {
    try {
      // 确定MIME类型
      String mimeType;
      switch (extension) {
        case '.jpg':
        case '.jpeg':
          mimeType = 'image/jpeg';
          break;
        case '.png':
          mimeType = 'image/png';
          break;
        case '.gif':
          mimeType = 'image/gif';
          break;
        case '.webp':
          mimeType = 'image/webp';
          break;
        default:
          mimeType = 'image/jpeg';
      }

      final base64 = base64Encode(bytes);
      return 'data:$mimeType;base64,$base64';
    } catch (e) {
      debugLog(() =>'转换Base64失败: $e');
      throw ImageServiceException('转换图片格式失败: $e');
    }
  }

  /// 创建缩略图
  Future<Uint8List> _createThumbnail(Uint8List bytes) async {
    // 这里可以使用image包进行缩略图生成
    // 暂时返回原图，后续可以优化
    return bytes;
  }

  /// 清理临时文件
  Future<void> cleanupTempFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(directory.path, 'images'));

      if (await imagesDir.exists()) {
        final files = await imagesDir.list().toList();
        final now = DateTime.now();

        for (final file in files) {
          if (file is File) {
            final stat = await file.stat();
            final age = now.difference(stat.modified);

            // 删除7天前的文件
            if (age.inDays > 7) {
              await file.delete();
              debugLog(() =>'删除过期图片文件: ${file.path}');
            }
          }
        }
      }
    } catch (e) {
      debugLog(() =>'清理临时文件失败: $e');
    }
  }
}

/// 图片处理结果
class ImageResult {
  final String originalPath;
  final String savedPath;
  final String fileName;
  final String uniqueFileName;
  final String fileExtension;
  final int originalSize;
  final int compressedSize;
  final String base64String;
  final Uint8List thumbnailBytes;
  final int? width;
  final int? height;

  ImageResult({
    required this.originalPath,
    required this.savedPath,
    required this.fileName,
    required this.uniqueFileName,
    required this.fileExtension,
    required this.originalSize,
    required this.compressedSize,
    required this.base64String,
    required this.thumbnailBytes,
    this.width,
    this.height,
  });

  /// 获取文件大小描述
  String get sizeDescription {
    if (originalSize < 1024) {
      return '${originalSize}B';
    } else if (originalSize < 1024 * 1024) {
      return '${(originalSize / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(originalSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  /// 是否已压缩
  bool get isCompressed => compressedSize < originalSize;

  /// 压缩率
  double get compressionRatio {
    if (originalSize == 0) return 0;
    return (originalSize - compressedSize) / originalSize;
  }
}

/// 图片服务异常
class ImageServiceException implements Exception {
  final String message;
  ImageServiceException(this.message);

  @override
  String toString() => 'ImageServiceException: $message';
}
