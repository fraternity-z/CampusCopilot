// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HelpSection _$HelpSectionFromJson(Map<String, dynamic> json) {
  return _HelpSection.fromJson(json);
}

/// @nodoc
mixin _$HelpSection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<HelpItem> get items => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HelpSectionCopyWith<HelpSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpSectionCopyWith<$Res> {
  factory $HelpSectionCopyWith(
          HelpSection value, $Res Function(HelpSection) then) =
      _$HelpSectionCopyWithImpl<$Res, HelpSection>;
  @useResult
  $Res call(
      {String id,
      String title,
      String icon,
      String description,
      List<HelpItem> items,
      List<String> tags,
      int order});
}

/// @nodoc
class _$HelpSectionCopyWithImpl<$Res, $Val extends HelpSection>
    implements $HelpSectionCopyWith<$Res> {
  _$HelpSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? icon = null,
    Object? description = null,
    Object? items = null,
    Object? tags = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HelpItem>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpSectionImplCopyWith<$Res>
    implements $HelpSectionCopyWith<$Res> {
  factory _$$HelpSectionImplCopyWith(
          _$HelpSectionImpl value, $Res Function(_$HelpSectionImpl) then) =
      __$$HelpSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String icon,
      String description,
      List<HelpItem> items,
      List<String> tags,
      int order});
}

/// @nodoc
class __$$HelpSectionImplCopyWithImpl<$Res>
    extends _$HelpSectionCopyWithImpl<$Res, _$HelpSectionImpl>
    implements _$$HelpSectionImplCopyWith<$Res> {
  __$$HelpSectionImplCopyWithImpl(
      _$HelpSectionImpl _value, $Res Function(_$HelpSectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? icon = null,
    Object? description = null,
    Object? items = null,
    Object? tags = null,
    Object? order = null,
  }) {
    return _then(_$HelpSectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HelpItem>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HelpSectionImpl implements _HelpSection {
  const _$HelpSectionImpl(
      {required this.id,
      required this.title,
      required this.icon,
      required this.description,
      required final List<HelpItem> items,
      final List<String> tags = const [],
      this.order = 0})
      : _items = items,
        _tags = tags;

  factory _$HelpSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$HelpSectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String icon;
  @override
  final String description;
  final List<HelpItem> _items;
  @override
  List<HelpItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int order;

  @override
  String toString() {
    return 'HelpSection(id: $id, title: $title, icon: $icon, description: $description, items: $items, tags: $tags, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      icon,
      description,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_tags),
      order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpSectionImplCopyWith<_$HelpSectionImpl> get copyWith =>
      __$$HelpSectionImplCopyWithImpl<_$HelpSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HelpSectionImplToJson(
      this,
    );
  }
}

abstract class _HelpSection implements HelpSection {
  const factory _HelpSection(
      {required final String id,
      required final String title,
      required final String icon,
      required final String description,
      required final List<HelpItem> items,
      final List<String> tags,
      final int order}) = _$HelpSectionImpl;

  factory _HelpSection.fromJson(Map<String, dynamic> json) =
      _$HelpSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get icon;
  @override
  String get description;
  @override
  List<HelpItem> get items;
  @override
  List<String> get tags;
  @override
  int get order;
  @override
  @JsonKey(ignore: true)
  _$$HelpSectionImplCopyWith<_$HelpSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HelpItem _$HelpItemFromJson(Map<String, dynamic> json) {
  return _HelpItem.fromJson(json);
}

/// @nodoc
mixin _$HelpItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  HelpItemType get type => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<HelpStep> get steps => throw _privateConstructorUsedError;
  List<String> get relatedItems => throw _privateConstructorUsedError;
  bool get isFrequentlyUsed => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HelpItemCopyWith<HelpItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpItemCopyWith<$Res> {
  factory $HelpItemCopyWith(HelpItem value, $Res Function(HelpItem) then) =
      _$HelpItemCopyWithImpl<$Res, HelpItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      HelpItemType type,
      List<String> tags,
      List<HelpStep> steps,
      List<String> relatedItems,
      bool isFrequentlyUsed,
      int viewCount});
}

/// @nodoc
class _$HelpItemCopyWithImpl<$Res, $Val extends HelpItem>
    implements $HelpItemCopyWith<$Res> {
  _$HelpItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? tags = null,
    Object? steps = null,
    Object? relatedItems = null,
    Object? isFrequentlyUsed = null,
    Object? viewCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as HelpItemType,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<HelpStep>,
      relatedItems: null == relatedItems
          ? _value.relatedItems
          : relatedItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFrequentlyUsed: null == isFrequentlyUsed
          ? _value.isFrequentlyUsed
          : isFrequentlyUsed // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpItemImplCopyWith<$Res>
    implements $HelpItemCopyWith<$Res> {
  factory _$$HelpItemImplCopyWith(
          _$HelpItemImpl value, $Res Function(_$HelpItemImpl) then) =
      __$$HelpItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      HelpItemType type,
      List<String> tags,
      List<HelpStep> steps,
      List<String> relatedItems,
      bool isFrequentlyUsed,
      int viewCount});
}

/// @nodoc
class __$$HelpItemImplCopyWithImpl<$Res>
    extends _$HelpItemCopyWithImpl<$Res, _$HelpItemImpl>
    implements _$$HelpItemImplCopyWith<$Res> {
  __$$HelpItemImplCopyWithImpl(
      _$HelpItemImpl _value, $Res Function(_$HelpItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? type = null,
    Object? tags = null,
    Object? steps = null,
    Object? relatedItems = null,
    Object? isFrequentlyUsed = null,
    Object? viewCount = null,
  }) {
    return _then(_$HelpItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as HelpItemType,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<HelpStep>,
      relatedItems: null == relatedItems
          ? _value._relatedItems
          : relatedItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFrequentlyUsed: null == isFrequentlyUsed
          ? _value.isFrequentlyUsed
          : isFrequentlyUsed // ignore: cast_nullable_to_non_nullable
              as bool,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HelpItemImpl implements _HelpItem {
  const _$HelpItemImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.type,
      final List<String> tags = const [],
      final List<HelpStep> steps = const [],
      final List<String> relatedItems = const [],
      this.isFrequentlyUsed = false,
      this.viewCount = 0})
      : _tags = tags,
        _steps = steps,
        _relatedItems = relatedItems;

  factory _$HelpItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HelpItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final HelpItemType type;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<HelpStep> _steps;
  @override
  @JsonKey()
  List<HelpStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  final List<String> _relatedItems;
  @override
  @JsonKey()
  List<String> get relatedItems {
    if (_relatedItems is EqualUnmodifiableListView) return _relatedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedItems);
  }

  @override
  @JsonKey()
  final bool isFrequentlyUsed;
  @override
  @JsonKey()
  final int viewCount;

  @override
  String toString() {
    return 'HelpItem(id: $id, title: $title, content: $content, type: $type, tags: $tags, steps: $steps, relatedItems: $relatedItems, isFrequentlyUsed: $isFrequentlyUsed, viewCount: $viewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            const DeepCollectionEquality()
                .equals(other._relatedItems, _relatedItems) &&
            (identical(other.isFrequentlyUsed, isFrequentlyUsed) ||
                other.isFrequentlyUsed == isFrequentlyUsed) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      type,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_steps),
      const DeepCollectionEquality().hash(_relatedItems),
      isFrequentlyUsed,
      viewCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpItemImplCopyWith<_$HelpItemImpl> get copyWith =>
      __$$HelpItemImplCopyWithImpl<_$HelpItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HelpItemImplToJson(
      this,
    );
  }
}

abstract class _HelpItem implements HelpItem {
  const factory _HelpItem(
      {required final String id,
      required final String title,
      required final String content,
      required final HelpItemType type,
      final List<String> tags,
      final List<HelpStep> steps,
      final List<String> relatedItems,
      final bool isFrequentlyUsed,
      final int viewCount}) = _$HelpItemImpl;

  factory _HelpItem.fromJson(Map<String, dynamic> json) =
      _$HelpItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  HelpItemType get type;
  @override
  List<String> get tags;
  @override
  List<HelpStep> get steps;
  @override
  List<String> get relatedItems;
  @override
  bool get isFrequentlyUsed;
  @override
  int get viewCount;
  @override
  @JsonKey(ignore: true)
  _$$HelpItemImplCopyWith<_$HelpItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HelpStep _$HelpStepFromJson(Map<String, dynamic> json) {
  return _HelpStep.fromJson(json);
}

/// @nodoc
mixin _$HelpStep {
  int get step => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HelpStepCopyWith<HelpStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpStepCopyWith<$Res> {
  factory $HelpStepCopyWith(HelpStep value, $Res Function(HelpStep) then) =
      _$HelpStepCopyWithImpl<$Res, HelpStep>;
  @useResult
  $Res call(
      {int step,
      String title,
      String description,
      String? imageUrl,
      List<String> tips});
}

/// @nodoc
class _$HelpStepCopyWithImpl<$Res, $Val extends HelpStep>
    implements $HelpStepCopyWith<$Res> {
  _$HelpStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? tips = null,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tips: null == tips
          ? _value.tips
          : tips // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpStepImplCopyWith<$Res>
    implements $HelpStepCopyWith<$Res> {
  factory _$$HelpStepImplCopyWith(
          _$HelpStepImpl value, $Res Function(_$HelpStepImpl) then) =
      __$$HelpStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int step,
      String title,
      String description,
      String? imageUrl,
      List<String> tips});
}

/// @nodoc
class __$$HelpStepImplCopyWithImpl<$Res>
    extends _$HelpStepCopyWithImpl<$Res, _$HelpStepImpl>
    implements _$$HelpStepImplCopyWith<$Res> {
  __$$HelpStepImplCopyWithImpl(
      _$HelpStepImpl _value, $Res Function(_$HelpStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? tips = null,
  }) {
    return _then(_$HelpStepImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tips: null == tips
          ? _value._tips
          : tips // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HelpStepImpl implements _HelpStep {
  const _$HelpStepImpl(
      {required this.step,
      required this.title,
      required this.description,
      this.imageUrl,
      final List<String> tips = const []})
      : _tips = tips;

  factory _$HelpStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$HelpStepImplFromJson(json);

  @override
  final int step;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? imageUrl;
  final List<String> _tips;
  @override
  @JsonKey()
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  @override
  String toString() {
    return 'HelpStep(step: $step, title: $title, description: $description, imageUrl: $imageUrl, tips: $tips)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpStepImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tips, _tips));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, step, title, description,
      imageUrl, const DeepCollectionEquality().hash(_tips));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpStepImplCopyWith<_$HelpStepImpl> get copyWith =>
      __$$HelpStepImplCopyWithImpl<_$HelpStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HelpStepImplToJson(
      this,
    );
  }
}

abstract class _HelpStep implements HelpStep {
  const factory _HelpStep(
      {required final int step,
      required final String title,
      required final String description,
      final String? imageUrl,
      final List<String> tips}) = _$HelpStepImpl;

  factory _HelpStep.fromJson(Map<String, dynamic> json) =
      _$HelpStepImpl.fromJson;

  @override
  int get step;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  List<String> get tips;
  @override
  @JsonKey(ignore: true)
  _$$HelpStepImplCopyWith<_$HelpStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
