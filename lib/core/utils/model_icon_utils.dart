import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/settings/domain/entities/app_settings.dart';

/// 模型厂商枚举（基于实际模型厂商，而非API提供商）
enum ModelVendor {
  openai,      // OpenAI (GPT系列、o1等)
  google,      // Google (Gemini系列)
  anthropic,   // Anthropic (Claude系列)
  deepseek,    // DeepSeek (DeepSeek系列)
  qwen,        // 阿里云 (通义千问系列)
  meta,        // Meta (Llama系列)
  mistral,     // Mistral AI
  midjourney,  // Midjourney (图像生成)
  grok,        // xAI Grok
  doubao,      // 字节跳动豆包
  ollama,      // 本地Ollama
}

/// 模型图标工具类
///
/// 提供AI模型对应的SVG图标和相关UI辅助功能
/// 主要根据模型名称来确定对应的厂商logo
class ModelIconUtils {
  

  /// 获取模型厂商对应的SVG图标路径
  static String? getSvgPath(ModelVendor vendor) {
    switch (vendor) {
      case ModelVendor.openai:
        return 'assets/logos/openai.svg';
      case ModelVendor.google:
        return 'assets/logos/Gemini.svg';
      case ModelVendor.anthropic:
        return 'assets/logos/claude.svg';
      case ModelVendor.deepseek:
        return 'assets/logos/deepseek.svg';
      case ModelVendor.qwen:
        return 'assets/logos/QWen.svg';
      case ModelVendor.meta:
      case ModelVendor.mistral:
        return 'assets/logos/Ollama.svg'; // 开源模型使用Ollama图标
      case ModelVendor.midjourney:
        return 'assets/logos/MidJourney.svg';
      case ModelVendor.grok:
        return 'assets/logos/Grok.svg';
      case ModelVendor.doubao:
        return 'assets/logos/doubao.svg';
      case ModelVendor.ollama:
        return 'assets/logos/Ollama.svg';
    }
  }
  
  /// 兼容旧版本的方法 - 根据AIProvider获取SVG路径
  static String? getSvgPathFromProvider(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
      case AIProvider.openaiResponses:
        return 'assets/logos/openai.svg';
      case AIProvider.gemini:
        return 'assets/logos/Gemini.svg';
      case AIProvider.claude:
        return 'assets/logos/claude.svg';
      case AIProvider.deepseek:
        return 'assets/logos/deepseek.svg';
      case AIProvider.qwen:
        return 'assets/logos/QWen.svg';
      case AIProvider.ollama:
        return 'assets/logos/Ollama.svg';
      case AIProvider.openrouter:
        return 'assets/logos/OpenRouter.svg'; 
    }
  }

  /// 获取备用Material Design图标（当SVG不可用时）
  static IconData getFallbackIcon(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return Icons.psychology;
      case AIProvider.openaiResponses:
        return Icons.psychology_alt;
      case AIProvider.gemini:
        return Icons.auto_awesome;
      case AIProvider.claude:
        return Icons.smart_toy;
      case AIProvider.deepseek:
        return Icons.psychology_alt;
      case AIProvider.qwen:
        return Icons.translate;
      case AIProvider.openrouter:
        return Icons.hub;
      case AIProvider.ollama:
        return Icons.computer;
    }
  }

  /// 获取提供商对应的品牌颜色
  static Color getColor(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return const Color(0xFF10B981);
      case AIProvider.openaiResponses:
        return const Color(0xFF059669);
      case AIProvider.gemini:
        return const Color(0xFF4285F4);
      case AIProvider.claude:
        return const Color(0xFFFF6B35);
      case AIProvider.deepseek:
        return const Color(0xFF9C27B0);
      case AIProvider.qwen:
        return const Color(0xFFF44336);
      case AIProvider.openrouter:
        return const Color(0xFF009688);
      case AIProvider.ollama:
        return const Color(0xFF3F51B5);
    }
  }

  /// 根据模型名称构建图标组件（主要方法）
  /// 
  /// 优先使用SVG图标，保持原始颜色，如果不存在则使用Material Design图标
  static Widget buildModelIcon(
    String? modelName, {
    double size = 24.0,
    Color? color,
    AIProvider? fallbackProvider,
  }) {
    final vendor = getVendorFromModelName(modelName);
    
    if (vendor != null) {
      final svgPath = getSvgPath(vendor);
      if (svgPath != null) {
        return SvgPicture.asset(
          svgPath,
          width: size,
          height: size,
          // 不使用colorFilter，保持SVG原始颜色
          colorFilter: color != null 
              ? ColorFilter.mode(color, BlendMode.srcIn)
              : null,
        );
      }
    }
    
    // 如果无法从模型名称识别，回退到提供商图标
    if (fallbackProvider != null) {
      return buildProviderIcon(fallbackProvider, size: size, color: color);
    }
    
    // 最后的默认图标
    return Icon(
      Icons.psychology_outlined,
      size: size,
      color: color ?? Colors.grey,
    );
  }

  /// 构建AI提供商图标组件（兼容方法）
  /// 
  /// 优先使用SVG图标，保持原始颜色，如果不存在则使用Material Design图标
  static Widget buildProviderIcon(
    AIProvider provider, {
    double size = 24.0,
    Color? color,
  }) {
    final svgPath = getSvgPathFromProvider(provider);
    
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath,
        width: size,
        height: size,
        // 如果指定了颜色则使用，否则保持SVG原色
        colorFilter: color != null 
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );
    } else {
      // 使用备用Material Design图标，使用灰色
      return Icon(
        getFallbackIcon(provider),
        size: size,
        color: color ?? Colors.grey,
      );
    }
  }

  /// 根据模型名称构建圆形头像（主要方法）
  static Widget buildModelAvatar(
    String? modelName, {
    double radius = 20.0,
    Color? backgroundColor,
    AIProvider? fallbackProvider,
  }) {
    final vendor = getVendorFromModelName(modelName);
    
    if (vendor != null) {
    } else if (fallbackProvider != null) {
    } else {
    }
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.withValues(alpha: 0.1),
      child: buildModelIcon(
        modelName,
        size: radius * 1.2,
        color: null, // 保持SVG原色
        fallbackProvider: fallbackProvider,
      ),
    );
  }

  /// 构建圆形的AI提供商头像（兼容方法）
  static Widget buildProviderAvatar(
    AIProvider provider, {
    double radius = 20.0,
    Color? backgroundColor,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.withValues(alpha: 0.1),
      child: buildProviderIcon(
        provider,
        size: radius * 1.2,
        color: null, // 保持SVG原色
      ),
    );
  }
  
  /// 获取模型厂商对应的颜色
  static Color getVendorColor(ModelVendor vendor) {
    switch (vendor) {
      case ModelVendor.openai:
        return const Color(0xFF10B981);
      case ModelVendor.google:
        return const Color(0xFF4285F4);
      case ModelVendor.anthropic:
        return const Color(0xFFFF6B35);
      case ModelVendor.deepseek:
        return const Color(0xFF9C27B0);
      case ModelVendor.qwen:
        return const Color(0xFFF44336);
      case ModelVendor.meta:
        return const Color(0xFF1877F2);
      case ModelVendor.mistral:
        return const Color(0xFFFF7000);
      case ModelVendor.midjourney:
        return const Color(0xFF9333EA);
      case ModelVendor.grok:
        return const Color(0xFF1DA1F2);
      case ModelVendor.doubao:
        return const Color(0xFF00D4AA);
      case ModelVendor.ollama:
        return const Color(0xFF3F51B5);
    }
  }

  /// 根据模型名称识别对应的模型厂商
  /// 
  /// 这是核心方法，根据具体的模型名称来判断应该使用哪个厂商的logo
  static ModelVendor? getVendorFromModelName(String? modelName) {
    if (modelName == null || modelName.isEmpty) return null;
    
    final modelLower = modelName.toLowerCase();
    
    // OpenAI模型 (GPT系列、o1系列等)
    if (modelLower.contains('gpt') || 
        modelLower.contains('o1') || 
        modelLower.contains('text-davinci') ||
        modelLower.contains('text-curie') ||
        modelLower.contains('text-babbage') ||
        modelLower.contains('text-ada')) {
      return ModelVendor.openai;
    }
    
    // Google Gemini系列
    if (modelLower.contains('gemini') || 
        modelLower.contains('bard')) {
      return ModelVendor.google;
    }
    
    // Anthropic Claude系列
    if (modelLower.contains('claude')) {
      return ModelVendor.anthropic;
    }
    
    // DeepSeek系列
    if (modelLower.contains('deepseek')) {
      return ModelVendor.deepseek;
    }
    
    // 阿里云通义千问系列
    if (modelLower.contains('qwen') || 
        modelLower.contains('通义') || 
        modelLower.contains('tongyi')) {
      return ModelVendor.qwen;
    }
    
    // Meta Llama系列
    if (modelLower.contains('llama') || 
        modelLower.contains('code-llama')) {
      return ModelVendor.meta;
    }
    
    // Mistral AI系列
    if (modelLower.contains('mistral') || 
        modelLower.contains('mixtral')) {
      return ModelVendor.mistral;
    }
    
    // Midjourney系列
    if (modelLower.contains('midjourney') || 
        modelLower.contains('mj')) {
      return ModelVendor.midjourney;
    }
    
    // xAI Grok系列
    if (modelLower.contains('grok')) {
      return ModelVendor.grok;
    }
    
    // 字节跳动豆包系列
    if (modelLower.contains('doubao') || 
        modelLower.contains('豆包')) {
      return ModelVendor.doubao;
    }
    
    return null;
  }
  
  /// 兼容方法：根据模型名称猜测对应的AI提供商（用于旧代码兼容）
  static AIProvider? guessProviderFromModel(String? modelName) {
    final vendor = getVendorFromModelName(modelName);
    if (vendor == null) return null;
    
    switch (vendor) {
      case ModelVendor.openai:
        return AIProvider.openai;
      case ModelVendor.google:
        return AIProvider.gemini;
      case ModelVendor.anthropic:
        return AIProvider.claude;
      case ModelVendor.deepseek:
        return AIProvider.deepseek;
      case ModelVendor.qwen:
        return AIProvider.qwen;
      case ModelVendor.meta:
      case ModelVendor.mistral:
      case ModelVendor.ollama:
        return AIProvider.ollama;
      default:
        return null;
    }
  }

  /// 获取提供商的显示名称
  static String getProviderDisplayName(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return 'OpenAI';
      case AIProvider.openaiResponses:
        return 'OpenAI Responses';
      case AIProvider.gemini:
        return 'Google Gemini';
      case AIProvider.claude:
        return 'Anthropic Claude';
      case AIProvider.deepseek:
        return 'DeepSeek';
      case AIProvider.qwen:
        return '通义千问';
      case AIProvider.openrouter:
        return 'OpenRouter';
      case AIProvider.ollama:
        return 'Ollama';
    }
  }
}