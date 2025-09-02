/// 视觉模型检查工具
/// 
/// 用于判断模型是否支持视觉功能（图片处理）
class VisionModelChecker {
  
  /// 支持视觉功能的模型列表
  static const Set<String> _visionSupportedModels = {
    // OpenAI 模型
    'gpt-4-vision-preview',
    'gpt-4-turbo-vision',
    'gpt-4o',
    'gpt-4o-mini',
    'gpt-4-turbo',
    
    // Google Gemini 模型
    'gemini-1.5-pro',
    'gemini-1.5-flash',
    'gemini-1.0-pro-vision',
    'gemini-pro-vision',
    'gemini-1.5-pro-latest',
    'gemini-1.5-flash-latest',
    
    // Anthropic Claude 模型
    'claude-3-opus-20240229',
    'claude-3-sonnet-20240229',
    'claude-3-haiku-20240307',
    'claude-3-5-sonnet-20241022',
    'claude-3-5-sonnet-20240620',
    'claude-3-5-haiku-20241022',
    
    // 其他视觉模型
    'llava-1.5-7b',
    'llava-1.5-13b',
    'bakllava-1',
    'moondream2',
    'cogvlm-chat-17b',
  };
  
  /// 检查模型是否支持视觉功能
  static bool isVisionModel(String? modelName) {
    if (modelName == null || modelName.isEmpty) return false;
    
    final normalizedModel = modelName.toLowerCase().trim();
    
    // 精确匹配
    if (_visionSupportedModels.contains(normalizedModel)) return true;
    
    // 模糊匹配（包含关键词）
    return _containsVisionKeywords(normalizedModel);
  }
  
  /// 检查模型名称是否包含视觉相关关键词
  static bool _containsVisionKeywords(String modelName) {
    const visionKeywords = [
      'vision',
      'gpt-4o',
      'gemini-1.5',
      'claude-3',
      'llava',
      'cogvlm',
      'moondream',
      'bakllava',
    ];
    
    return visionKeywords.any((keyword) => modelName.contains(keyword));
  }
  
  /// 获取推荐的视觉模型列表
  static List<String> getRecommendedVisionModels() {
    return [
      'gpt-4o',
      'gpt-4o-mini',
      'gemini-1.5-pro',
      'gemini-1.5-flash',
      'claude-3-5-sonnet-20241022',
      'claude-3-haiku-20240307',
    ];
  }
  
  /// 获取不支持视觉的常见模型警告信息
  static String? getVisionWarningMessage(String? modelName) {
    if (modelName == null || modelName.isEmpty) return null;
    if (isVisionModel(modelName)) return null;
    
    final normalizedModel = modelName.toLowerCase().trim();
    
    // 常见的文本模型
    if (normalizedModel.contains('gpt-3.5') || 
        normalizedModel.contains('text-davinci') ||
        normalizedModel.contains('gpt-3')) {
      return '当前模型 $modelName 不支持图片处理，请切换到支持视觉的模型（如 gpt-4o）';
    }
    
    if (normalizedModel.contains('llama') && 
        !normalizedModel.contains('llava')) {
      return '当前模型 $modelName 不支持图片处理，请使用 LLaVA 或其他视觉模型';
    }
    
    return '当前模型可能不支持图片处理，建议使用支持视觉功能的模型';
  }
}
