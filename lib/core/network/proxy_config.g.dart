// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProxyConfigImpl _$$ProxyConfigImplFromJson(Map<String, dynamic> json) =>
    _$ProxyConfigImpl(
      mode: $enumDecodeNullable(_$ProxyModeEnumMap, json['mode']) ??
          ProxyMode.none,
      type: $enumDecodeNullable(_$ProxyTypeEnumMap, json['type']) ??
          ProxyType.http,
      host: json['host'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? ProxyConstants.defaultHttpPort,
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$$ProxyConfigImplToJson(_$ProxyConfigImpl instance) =>
    <String, dynamic>{
      'mode': _$ProxyModeEnumMap[instance.mode]!,
      'type': _$ProxyTypeEnumMap[instance.type]!,
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
    };

const _$ProxyModeEnumMap = {
  ProxyMode.none: 'none',
  ProxyMode.system: 'system',
  ProxyMode.custom: 'custom',
};

const _$ProxyTypeEnumMap = {
  ProxyType.http: 'http',
  ProxyType.https: 'https',
  ProxyType.socks5: 'socks5',
};
