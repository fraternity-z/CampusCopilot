import 'dart:io';
import '../../shared/utils/debug_log.dart';
import 'package:openai_dart/openai_dart.dart' as openai;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

/// 图片生成服务
///
/// 提供AI图片生成功能，支持：
/// - DALL-E 图片生成
/// - 图片编辑
/// - 图片变体生成
/// - 图片下载和缓存
class ImageGenerationService {
  static final ImageGenerationService _instance =
      ImageGenerationService._internal();
  factory ImageGenerationService() => _instance;
  ImageGenerationService._internal();
  
  openai.OpenAIClient? _client;

  /// 生成图片
  Future<List<GeneratedImageResult>> generateImages({
    required String prompt,
    int count = 1,
    ImageSize size = ImageSize.size1024x1024,
    ImageQuality quality = ImageQuality.standard,
    ImageStyle style = ImageStyle.vivid,
    String? model, // 改为可空，让调用方传递具体模型
    String? apiKey,
    String? baseUrl,
  }) async {
    // 如果没有指定模型，默认使用DALL-E 3
    final finalModel = model ?? 'dall-e-3';
    
    try {
  debugLog(() => '🎨 开始生成图片: $prompt');
  debugLog(() => '🔧 使用端点: ${baseUrl ?? "https://api.openai.com/v1"}');
  debugLog(() => '🤖 模型: $finalModel');

      // 验证参数
      if (prompt.trim().isEmpty) {
        throw ImageGenerationException('提示词不能为空');
      }

      if (count < 1 || count > 10) {
        throw ImageGenerationException('图片数量必须在1-10之间');
      }

      // DALL-E 3 只支持生成1张图片
      if (finalModel == 'dall-e-3' && count > 1) {
        count = 1;
  debugLog(() => '⚠️ DALL-E 3 只支持生成1张图片，已调整为1张');
      }

      // 设置 OpenAI 客户端
      String? finalBaseUrl;
      if (baseUrl != null) {
        // 修复baseUrl重复/v1的问题
        String cleanBaseUrl = baseUrl.trim();
        
        // 移除末尾的斜杠
        if (cleanBaseUrl.endsWith('/')) {
          cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
        }
        
        // 确保以/v1结尾，因为openai_dart需要完整的URL
        if (!cleanBaseUrl.endsWith('/v1')) {
          cleanBaseUrl += '/v1';
        }
        
  finalBaseUrl = cleanBaseUrl;
  debugLog(() => '🔧 设置图像生成 baseUrl: $cleanBaseUrl (原始: $baseUrl)');
      }
      
      _client = openai.OpenAIClient(
        apiKey: apiKey ?? '',
        baseUrl: finalBaseUrl,
      );

      if (_client == null) {
        throw ImageGenerationException('OpenAI客户端未初始化');
      }
      
      // 调用 OpenAI API - 兼容NewAPI等第三方端点
      final request = openai.CreateImageRequest(
        prompt: prompt,
        model: _mapModel(finalModel),
        n: count,
        size: _mapImageSizeToApiEnum(size),
        responseFormat: openai.ImageResponseFormat.url,
        // 根据模型和端点决定是否添加这些参数，以提高NewAPI兼容性
        quality: _shouldUseAdvancedParams(finalModel, baseUrl) 
            ? _mapImageQuality(quality)
            : null,
        style: _shouldUseAdvancedParams(finalModel, baseUrl) 
            ? _mapImageStyle(style)
            : null,
      );
      
      final response = await _client!.createImage(request: request);

  debugLog(() => '✅ 图片生成成功，共${response.data.length}张');

      // 处理响应
      final results = <GeneratedImageResult>[];
      for (int i = 0; i < response.data.length; i++) {
        final imageData = response.data[i];

        if (imageData.url != null) {
          // 下载并缓存图片
          final cachedImage = await _downloadAndCacheImage(
            imageData.url!,
            prompt,
            i,
          );

          results.add(
            GeneratedImageResult(
              url: imageData.url!,
              localPath: cachedImage.path,
              prompt: prompt,
              revisedPrompt: imageData.revisedPrompt,
              size: size,
              quality: quality,
              style: style,
              model: finalModel,
              createdAt: DateTime.now(),
            ),
          );
        }
      }

      return results;
    } catch (e) {
      debugLog(() => '❌ 图片生成失败: $e');

      // 特殊处理NewAPI兼容性错误
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('unsupported') || 
          errorMsg.contains('not supported') ||
          errorMsg.contains('invalid parameter') ||
          errorMsg.contains('bad request')) {
        
        // 如果使用了高级参数且出现错误，尝试使用基础参数重试
        if (_shouldUseAdvancedParams(finalModel, baseUrl)) {
          debugLog(() => '🔄 检测到参数兼容性问题，尝试使用基础参数重试...');
          try {
            final retryRequest = openai.CreateImageRequest(
              prompt: prompt,
              model: _mapModel(finalModel),
              n: count,
              size: _mapImageSizeToApiEnum(size),
              responseFormat: openai.ImageResponseFormat.url,
              // 不使用高级参数重试
            );
            
            final retryResponse = await _client!.createImage(request: retryRequest);
            
            debugLog(() => '✅ 使用基础参数重试成功，共${retryResponse.data.length}张');
            
            // 处理重试成功的响应
            final results = <GeneratedImageResult>[];
            for (int i = 0; i < retryResponse.data.length; i++) {
              final imageData = retryResponse.data[i];

              if (imageData.url != null) {
                final cachedImage = await _downloadAndCacheImage(
                  imageData.url!,
                  prompt,
                  i,
                );

                results.add(
                  GeneratedImageResult(
                    url: imageData.url!,
                    localPath: cachedImage.path,
                    prompt: prompt,
                    revisedPrompt: imageData.revisedPrompt,
                    size: size,
                    quality: ImageQuality.standard, // 使用默认质量
                    style: ImageStyle.natural, // 使用默认风格
                    model: finalModel,
                    createdAt: DateTime.now(),
                  ),
                );
              }
            }
            return results;
          } catch (retryError) {
            debugLog(() => '❌ 重试也失败了: $retryError');
            throw ImageGenerationException('图片生成失败，NewAPI端点可能不支持此模型或参数: $retryError');
          }
        }
      }
      
      if (e is ImageGenerationException) {
        rethrow;
      }
      
      // 提供更详细的错误信息
      if (errorMsg.contains('network') || errorMsg.contains('connection')) {
        throw ImageGenerationException('网络连接失败，请检查网络设置或API端点配置');
      } else if (errorMsg.contains('unauthorized') || errorMsg.contains('401')) {
        throw ImageGenerationException('API密钥无效或权限不足');
      } else if (errorMsg.contains('quota') || errorMsg.contains('limit')) {
        throw ImageGenerationException('API配额不足或达到使用限制');
      } else if (errorMsg.contains('404') || errorMsg.contains('api端点不存在')) {
        final endpointInfo = baseUrl != null ? "当前端点: $baseUrl" : "使用默认OpenAI端点";
        throw ImageGenerationException(
          '图片生成API端点不存在，请检查配置。\n'
          '$endpointInfo\n'
          '如使用NewAPI等第三方网关，请确认：\n'
          '1. 端点地址正确（如：http://your-host/v1）\n'
          '2. 网关支持图片生成功能\n'
          '3. 配置了支持图片生成的模型'
        );
      } else {
        throw ImageGenerationException('图片生成失败: $e');
      }
    }
  }


  /// 下载并缓存图片
  Future<File> _downloadAndCacheImage(
    String url,
    String prompt,
    int index,
  ) async {
    try {
      // 创建缓存目录
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory(path.join(directory.path, 'generated_images'));

      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // 生成文件名
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sanitizedPrompt = prompt
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(' ', '_');
      final fileName = '${timestamp}_${sanitizedPrompt}_$index.png';
      final filePath = path.join(cacheDir.path, fileName);

      // 下载图片
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
          debugLog(() => '📁 图片已缓存: $filePath');
        return file;
      } else {
        throw ImageGenerationException('下载图片失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
  debugLog(() => '❌ 缓存图片失败: $e');
      throw ImageGenerationException('缓存图片失败: $e');
    }
  }

  /// 判断是否应该使用高级参数（quality、style）
  /// NewAPI网关和某些第三方实现可能不支持这些参数
  bool _shouldUseAdvancedParams(String model, String? baseUrl) {
    // 如果是官方OpenAI API，支持所有参数
    if (baseUrl == null || 
        baseUrl.contains('api.openai.com') ||
        baseUrl.contains('openai.azure.com')) {
      return true;
    }
    
    // DALL-E 3模型通常支持这些参数（即使通过NewAPI代理）
    if (model.toLowerCase().contains('dall-e-3') || 
        model.toLowerCase().contains('dalle-3')) {
      return true;
    }
    
    // 对于NewAPI网关和其他第三方端点，根据模型类型判断
    final modelLower = model.toLowerCase();
    
    // 已知支持高级参数的模型
    if (modelLower.contains('dall-e') || 
        modelLower.contains('dalle') ||
        modelLower.contains('midjourney')) {
      return true;
    }
    
    // 对于未知模型或第三方端点，默认不使用高级参数以提高兼容性
  debugLog(() => '🔧 第三方端点检测到，禁用高级参数以提高兼容性: $baseUrl');
    return false;
  }

  /// 映射模型
  openai.CreateImageRequestModel? _mapModel(String model) {
    switch (model.toLowerCase()) {
      case 'dall-e-2':
        return openai.CreateImageRequestModel.model(openai.ImageModels.dallE2);
      case 'dall-e-3':
        return openai.CreateImageRequestModel.model(openai.ImageModels.dallE3);
      default:
        return openai.CreateImageRequestModel.model(openai.ImageModels.dallE3);
    }
  }
  
  /// 映射图片尺寸到API枚举
  openai.ImageSize? _mapImageSizeToApiEnum(ImageSize size) {
    switch (size) {
      case ImageSize.size256x256:
        return openai.ImageSize.v256x256;
      case ImageSize.size512x512:
        return openai.ImageSize.v512x512; 
      case ImageSize.size1024x1024:
        return openai.ImageSize.v1024x1024;
      case ImageSize.size1792x1024:
        return openai.ImageSize.v1792x1024;
      case ImageSize.size1024x1792:
        return openai.ImageSize.v1024x1792;
    }
  }
  
  /// 映射图片质量
  openai.ImageQuality? _mapImageQuality(ImageQuality quality) {
    switch (quality) {
      case ImageQuality.standard:
        return openai.ImageQuality.standard;
      case ImageQuality.hd:
        return openai.ImageQuality.hd;
    }
  }
  
  /// 映射图片风格
  openai.ImageStyle? _mapImageStyle(ImageStyle style) {
    switch (style) {
      case ImageStyle.natural:
        return openai.ImageStyle.natural;
      case ImageStyle.vivid:
        return openai.ImageStyle.vivid;
    }
  }

  /// 清理缓存
  Future<void> clearCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final cacheDir = Directory(path.join(directory.path, 'generated_images'));

      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
  debugLog(() => '🗑️ 图片缓存已清理');
      }
    } catch (e) {
  debugLog(() => '❌ 清理缓存失败: $e');
    }
  }
}

/// 图片尺寸枚举
enum ImageSize {
  size256x256,
  size512x512,
  size1024x1024,
  size1792x1024, // 横向
  size1024x1792, // 纵向
}

/// 图片质量枚举
enum ImageQuality { standard, hd }

/// 图片风格枚举
enum ImageStyle { natural, vivid }

/// 生成的图片结果
class GeneratedImageResult {
  final String url;
  final String localPath;
  final String prompt;
  final String? revisedPrompt;
  final ImageSize size;
  final ImageQuality quality;
  final ImageStyle style;
  final String model;
  final DateTime createdAt;

  GeneratedImageResult({
    required this.url,
    required this.localPath,
    required this.prompt,
    this.revisedPrompt,
    required this.size,
    required this.quality,
    required this.style,
    required this.model,
    required this.createdAt,
  });

  /// 获取尺寸描述
  String get sizeDescription {
    switch (size) {
      case ImageSize.size256x256:
        return '256×256';
      case ImageSize.size512x512:
        return '512×512';
      case ImageSize.size1024x1024:
        return '1024×1024';
      case ImageSize.size1792x1024:
        return '1792×1024';
      case ImageSize.size1024x1792:
        return '1024×1792';
    }
  }

}

/// 图片生成异常
class ImageGenerationException implements Exception {
  final String message;
  ImageGenerationException(this.message);

  @override
  String toString() => 'ImageGenerationException: $message';
}
