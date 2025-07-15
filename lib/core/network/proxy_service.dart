import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'dio_client.dart';
import 'proxy_config.dart';
import '../../features/settings/presentation/providers/general_settings_provider.dart';

/// 代理服务
/// 
/// 负责监听代理配置变化并更新网络客户端
class ProxyService {
  final DioClient _dioClient;
  
  ProxyService(this._dioClient);
  
  /// 更新代理配置
  void updateProxyConfig(ProxyConfig config) {
    _dioClient.updateProxyConfig(config);
    
    if (kDebugMode) {
      debugPrint('🌐 代理服务已更新配置: ${config.mode.displayName}');
    }
  }
  
  /// 获取当前代理配置
  ProxyConfig get currentConfig => _dioClient.proxyConfig;
}

/// 代理服务Provider
final proxyServiceProvider = Provider<ProxyService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProxyService(dioClient);
});

/// 代理配置监听Provider
/// 
/// 监听常规设置中的代理配置变化，并自动更新代理服务
final proxyConfigWatcherProvider = Provider<void>((ref) {
  final proxyService = ref.watch(proxyServiceProvider);
  final generalSettings = ref.watch(generalSettingsProvider);
  
  // 当代理配置发生变化时，更新代理服务
  ref.listen(generalSettingsProvider.select((state) => state.proxyConfig), 
    (previous, next) {
      if (previous != next) {
        proxyService.updateProxyConfig(next);
      }
    },
  );
  
  // 初始化时设置代理配置
  if (!generalSettings.isLoading) {
    proxyService.updateProxyConfig(generalSettings.proxyConfig);
  }
});
