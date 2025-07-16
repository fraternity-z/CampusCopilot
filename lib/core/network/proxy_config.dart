import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxy_config.freezed.dart';
part 'proxy_config.g.dart';

/// 代理常量定义
class ProxyConstants {
  ProxyConstants._();

  static const int defaultHttpPort = 8080;
  static const int defaultHttpsPort = 443;
  static const int defaultSocks5Port = 1080;
  static const int minPort = 1;
  static const int maxPort = 65535;
}

/// 代理模式枚举
enum ProxyMode {
  /// 不使用代理（直连）
  none,

  /// 使用系统代理
  system,

  /// 使用自定义代理
  custom,
}

/// 代理类型枚举
enum ProxyType {
  /// HTTP代理
  http,

  /// HTTPS代理
  https,

  /// SOCKS5代理
  socks5,
}

/// 代理配置实体
@freezed
class ProxyConfig with _$ProxyConfig {
  const factory ProxyConfig({
    /// 代理模式
    @Default(ProxyMode.none) ProxyMode mode,

    /// 代理类型（仅在自定义模式下使用）
    @Default(ProxyType.http) ProxyType type,

    /// 代理服务器地址
    @Default('') String host,

    /// 代理服务器端口
    @Default(ProxyConstants.defaultHttpPort) int port,

    /// 用户名（可选，用于需要认证的代理）
    @Default('') String username,

    /// 密码（可选，用于需要认证的代理）
    @Default('') String password,
  }) = _ProxyConfig;

  factory ProxyConfig.fromJson(Map<String, dynamic> json) =>
      _$ProxyConfigFromJson(json);
}

/// 代理配置扩展方法
extension ProxyConfigExtension on ProxyConfig {
  /// 是否启用代理
  bool get isEnabled => mode != ProxyMode.none;

  /// 是否为自定义代理
  bool get isCustom => mode == ProxyMode.custom;

  /// 是否需要认证
  bool get requiresAuth => username.isNotEmpty && password.isNotEmpty;

  /// 获取代理URL字符串
  String get proxyUrl {
    if (!isCustom || host.isEmpty) return '';

    // 对于HttpClient的findProxy，SOCKS5也使用PROXY前缀
    // 实际的协议区分在连接时处理
    final auth = requiresAuth ? '$username:$password@' : '';
    return '$auth$host:$port';
  }

  /// 获取代理协议字符串（用于findProxy）
  String get proxyProtocol {
    switch (type) {
      case ProxyType.socks5:
        return 'SOCKS5';
      case ProxyType.http:
      case ProxyType.https:
        return 'PROXY';
    }
  }

  /// 端口是否有效
  bool get isPortValid =>
      port >= ProxyConstants.minPort && port <= ProxyConstants.maxPort;

  /// 验证配置是否有效
  bool get isValid {
    switch (mode) {
      case ProxyMode.none:
      case ProxyMode.system:
        return true;
      case ProxyMode.custom:
        return host.isNotEmpty && isPortValid;
    }
  }

  /// 获取默认端口
  int get defaultPort {
    switch (type) {
      case ProxyType.http:
        return ProxyConstants.defaultHttpPort;
      case ProxyType.https:
        return ProxyConstants.defaultHttpsPort;
      case ProxyType.socks5:
        return ProxyConstants.defaultSocks5Port;
    }
  }
}

/// 代理模式扩展
extension ProxyModeExtension on ProxyMode {
  /// 获取显示名称
  String get displayName {
    switch (this) {
      case ProxyMode.none:
        return '不使用代理';
      case ProxyMode.system:
        return '使用系统代理';
      case ProxyMode.custom:
        return '自定义代理';
    }
  }

  /// 获取描述
  String get description {
    switch (this) {
      case ProxyMode.none:
        return '直接连接，不使用任何代理';
      case ProxyMode.system:
        return '自动检测并使用系统代理设置';
      case ProxyMode.custom:
        return '使用手动配置的代理服务器';
    }
  }
}

/// 代理类型扩展
extension ProxyTypeExtension on ProxyType {
  /// 获取显示名称
  String get displayName {
    switch (this) {
      case ProxyType.http:
        return 'HTTP';
      case ProxyType.https:
        return 'HTTPS';
      case ProxyType.socks5:
        return 'SOCKS5';
    }
  }
}
