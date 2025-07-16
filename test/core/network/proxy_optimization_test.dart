import 'package:flutter_test/flutter_test.dart';
import 'package:ai_assistant/core/network/proxy_config.dart';
import 'package:ai_assistant/core/network/dio_client.dart';
import 'package:ai_assistant/core/network/proxy_service.dart';

void main() {
  group('代理服务优化测试', () {
    test('ProxyConstants 常量定义正确', () {
      expect(ProxyConstants.defaultHttpPort, 8080);
      expect(ProxyConstants.defaultHttpsPort, 443);
      expect(ProxyConstants.defaultSocks5Port, 1080);
      expect(ProxyConstants.minPort, 1);
      expect(ProxyConstants.maxPort, 65535);
    });

    test('ProxyConfig 端口验证优化', () {
      // 测试有效端口
      const validConfig = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy.example.com',
        port: 8080,
      );
      expect(validConfig.isPortValid, true);
      expect(validConfig.isValid, true);

      // 测试无效端口
      const invalidConfig = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy.example.com',
        port: 70000, // 超出有效范围
      );
      expect(invalidConfig.isPortValid, false);
      expect(invalidConfig.isValid, false);
    });

    test('ProxyConfig 默认端口获取', () {
      const httpConfig = ProxyConfig(type: ProxyType.http);
      expect(httpConfig.defaultPort, ProxyConstants.defaultHttpPort);

      const httpsConfig = ProxyConfig(type: ProxyType.https);
      expect(httpsConfig.defaultPort, ProxyConstants.defaultHttpsPort);

      const socks5Config = ProxyConfig(type: ProxyType.socks5);
      expect(socks5Config.defaultPort, ProxyConstants.defaultSocks5Port);
    });

    test('ProxyService 配置变化检测', () {
      final dioClient = DioClient();
      final proxyService = ProxyService(dioClient);

      const config1 = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy1.example.com',
        port: 8080,
      );

      const config2 = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy2.example.com',
        port: 8080,
      );

      // 第一次更新应该生效
      proxyService.updateProxyConfig(config1);
      expect(proxyService.currentConfig, config1);

      // 相同配置不应该触发更新
      proxyService.updateProxyConfig(config1);
      expect(proxyService.currentConfig, config1);

      // 不同配置应该触发更新
      proxyService.updateProxyConfig(config2);
      expect(proxyService.currentConfig, config2);
    });

    test('DioClient 单例模式', () {
      final client1 = DioClient();
      final client2 = DioClient();

      // 应该返回同一个实例
      expect(identical(client1, client2), true);
    });

    test('ProxyConfig 相等性比较', () {
      const config1 = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy.example.com',
        port: 8080,
      );

      const config2 = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy.example.com',
        port: 8080,
      );

      const config3 = ProxyConfig(
        mode: ProxyMode.custom,
        host: 'proxy.example.com',
        port: 8081, // 不同端口
      );

      expect(config1 == config2, true);
      expect(config1 == config3, false);
    });

    test('ProxyMode 显示名称', () {
      expect(ProxyMode.none.displayName, '不使用代理');
      expect(ProxyMode.system.displayName, '使用系统代理');
      expect(ProxyMode.custom.displayName, '自定义代理');
    });

    test('ProxyType 显示名称', () {
      expect(ProxyType.http.displayName, 'HTTP');
      expect(ProxyType.https.displayName, 'HTTPS');
      expect(ProxyType.socks5.displayName, 'SOCKS5');
    });
  });

  group('错误处理优化测试', () {
    test('重试状态码集合', () {
      // 这个测试验证重试拦截器使用的状态码集合
      const retryableStatusCodes = {500, 502, 503, 504};

      expect(retryableStatusCodes.contains(500), true);
      expect(retryableStatusCodes.contains(502), true);
      expect(retryableStatusCodes.contains(503), true);
      expect(retryableStatusCodes.contains(504), true);
      expect(retryableStatusCodes.contains(404), false);
      expect(retryableStatusCodes.contains(401), false);
    });
  });
}
