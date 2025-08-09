// no-op imports for this factory
import '../web_search_strategy.dart';
import 'tavily_search_strategy.dart';
import 'direct_engine_search_strategy.dart';

/// 简易策略工厂：根据来源字符串或设置生成策略实例
class WebSearchStrategyFactory {
  /// 创建策略
  /// source: 'model_native' | 'tavily' | 'direct'
  static WebSearchStrategy create(
    String source, {
    String? tavilyApiKey,
    String? orchestratorEndpoint,
  }) {
    switch (source.toLowerCase()) {
      case 'tavily':
        return TavilySearchStrategy(tavilyApiKey ?? '');
      case 'direct':
      case 'direct_engine':
        return DirectEngineSearchStrategy(
          orchestratorEndpoint ?? 'http://localhost:8080',
        );
      case 'model_native':
      default:
        // 先占位，用 direct 兜底；后续补充 ModelNative 策略
        return DirectEngineSearchStrategy(
          orchestratorEndpoint ?? 'http://localhost:8080',
        );
    }
  }
}
