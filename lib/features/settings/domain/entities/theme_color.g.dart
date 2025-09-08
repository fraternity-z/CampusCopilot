// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeColorSettingsImpl _$$ThemeColorSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$ThemeColorSettingsImpl(
      currentColor:
          $enumDecodeNullable(_$ThemeColorTypeEnumMap, json['currentColor']) ??
              ThemeColorType.purple,
      enableDynamicColor: json['enableDynamicColor'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ThemeColorSettingsImplToJson(
        _$ThemeColorSettingsImpl instance) =>
    <String, dynamic>{
      'currentColor': _$ThemeColorTypeEnumMap[instance.currentColor]!,
      'enableDynamicColor': instance.enableDynamicColor,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

const _$ThemeColorTypeEnumMap = {
  ThemeColorType.red: 'red',
  ThemeColorType.yellow: 'yellow',
  ThemeColorType.blue: 'blue',
  ThemeColorType.green: 'green',
  ThemeColorType.purple: 'purple',
  ThemeColorType.orange: 'orange',
  ThemeColorType.cyan: 'cyan',
  ThemeColorType.indigo: 'indigo',
};
