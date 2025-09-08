// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_color.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThemeColorSettings _$ThemeColorSettingsFromJson(Map<String, dynamic> json) {
  return _ThemeColorSettings.fromJson(json);
}

/// @nodoc
mixin _$ThemeColorSettings {
  /// 当前选择的颜色主题
  ThemeColorType get currentColor => throw _privateConstructorUsedError;

  /// 是否启用动态颜色（Material You）
  bool get enableDynamicColor => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeColorSettingsCopyWith<ThemeColorSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeColorSettingsCopyWith<$Res> {
  factory $ThemeColorSettingsCopyWith(
          ThemeColorSettings value, $Res Function(ThemeColorSettings) then) =
      _$ThemeColorSettingsCopyWithImpl<$Res, ThemeColorSettings>;
  @useResult
  $Res call(
      {ThemeColorType currentColor,
      bool enableDynamicColor,
      DateTime? lastUpdated});
}

/// @nodoc
class _$ThemeColorSettingsCopyWithImpl<$Res, $Val extends ThemeColorSettings>
    implements $ThemeColorSettingsCopyWith<$Res> {
  _$ThemeColorSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentColor = null,
    Object? enableDynamicColor = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      currentColor: null == currentColor
          ? _value.currentColor
          : currentColor // ignore: cast_nullable_to_non_nullable
              as ThemeColorType,
      enableDynamicColor: null == enableDynamicColor
          ? _value.enableDynamicColor
          : enableDynamicColor // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeColorSettingsImplCopyWith<$Res>
    implements $ThemeColorSettingsCopyWith<$Res> {
  factory _$$ThemeColorSettingsImplCopyWith(_$ThemeColorSettingsImpl value,
          $Res Function(_$ThemeColorSettingsImpl) then) =
      __$$ThemeColorSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeColorType currentColor,
      bool enableDynamicColor,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$ThemeColorSettingsImplCopyWithImpl<$Res>
    extends _$ThemeColorSettingsCopyWithImpl<$Res, _$ThemeColorSettingsImpl>
    implements _$$ThemeColorSettingsImplCopyWith<$Res> {
  __$$ThemeColorSettingsImplCopyWithImpl(_$ThemeColorSettingsImpl _value,
      $Res Function(_$ThemeColorSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentColor = null,
    Object? enableDynamicColor = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$ThemeColorSettingsImpl(
      currentColor: null == currentColor
          ? _value.currentColor
          : currentColor // ignore: cast_nullable_to_non_nullable
              as ThemeColorType,
      enableDynamicColor: null == enableDynamicColor
          ? _value.enableDynamicColor
          : enableDynamicColor // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeColorSettingsImpl implements _ThemeColorSettings {
  const _$ThemeColorSettingsImpl(
      {this.currentColor = ThemeColorType.purple,
      this.enableDynamicColor = false,
      this.lastUpdated});

  factory _$ThemeColorSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeColorSettingsImplFromJson(json);

  /// 当前选择的颜色主题
  @override
  @JsonKey()
  final ThemeColorType currentColor;

  /// 是否启用动态颜色（Material You）
  @override
  @JsonKey()
  final bool enableDynamicColor;

  /// 最后更新时间
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'ThemeColorSettings(currentColor: $currentColor, enableDynamicColor: $enableDynamicColor, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeColorSettingsImpl &&
            (identical(other.currentColor, currentColor) ||
                other.currentColor == currentColor) &&
            (identical(other.enableDynamicColor, enableDynamicColor) ||
                other.enableDynamicColor == enableDynamicColor) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentColor, enableDynamicColor, lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeColorSettingsImplCopyWith<_$ThemeColorSettingsImpl> get copyWith =>
      __$$ThemeColorSettingsImplCopyWithImpl<_$ThemeColorSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeColorSettingsImplToJson(
      this,
    );
  }
}

abstract class _ThemeColorSettings implements ThemeColorSettings {
  const factory _ThemeColorSettings(
      {final ThemeColorType currentColor,
      final bool enableDynamicColor,
      final DateTime? lastUpdated}) = _$ThemeColorSettingsImpl;

  factory _ThemeColorSettings.fromJson(Map<String, dynamic> json) =
      _$ThemeColorSettingsImpl.fromJson;

  @override

  /// 当前选择的颜色主题
  ThemeColorType get currentColor;
  @override

  /// 是否启用动态颜色（Material You）
  bool get enableDynamicColor;
  @override

  /// 最后更新时间
  DateTime? get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$ThemeColorSettingsImplCopyWith<_$ThemeColorSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
