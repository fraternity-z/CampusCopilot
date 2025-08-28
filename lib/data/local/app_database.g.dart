// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LlmConfigsTableTable extends LlmConfigsTable
    with TableInfo<$LlmConfigsTableTable, LlmConfigsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LlmConfigsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
      'api_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
      'base_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultModelMeta =
      const VerificationMeta('defaultModel');
  @override
  late final GeneratedColumn<String> defaultModel = GeneratedColumn<String>(
      'default_model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultEmbeddingModelMeta =
      const VerificationMeta('defaultEmbeddingModel');
  @override
  late final GeneratedColumn<String> defaultEmbeddingModel =
      GeneratedColumn<String>('default_embedding_model', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _extraParamsMeta =
      const VerificationMeta('extraParams');
  @override
  late final GeneratedColumn<String> extraParams = GeneratedColumn<String>(
      'extra_params', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isCustomProviderMeta =
      const VerificationMeta('isCustomProvider');
  @override
  late final GeneratedColumn<bool> isCustomProvider = GeneratedColumn<bool>(
      'is_custom_provider', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_custom_provider" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _apiCompatibilityTypeMeta =
      const VerificationMeta('apiCompatibilityType');
  @override
  late final GeneratedColumn<String> apiCompatibilityType =
      GeneratedColumn<String>('api_compatibility_type', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('openai'));
  static const VerificationMeta _customProviderNameMeta =
      const VerificationMeta('customProviderName');
  @override
  late final GeneratedColumn<String> customProviderName =
      GeneratedColumn<String>('custom_provider_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customProviderDescriptionMeta =
      const VerificationMeta('customProviderDescription');
  @override
  late final GeneratedColumn<String> customProviderDescription =
      GeneratedColumn<String>('custom_provider_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customProviderIconMeta =
      const VerificationMeta('customProviderIcon');
  @override
  late final GeneratedColumn<String> customProviderIcon =
      GeneratedColumn<String>('custom_provider_icon', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        provider,
        apiKey,
        baseUrl,
        defaultModel,
        defaultEmbeddingModel,
        organizationId,
        projectId,
        extraParams,
        createdAt,
        updatedAt,
        isEnabled,
        isCustomProvider,
        apiCompatibilityType,
        customProviderName,
        customProviderDescription,
        customProviderIcon
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'llm_configs_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LlmConfigsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    } else if (isInserting) {
      context.missing(_apiKeyMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(_baseUrlMeta,
          baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta));
    }
    if (data.containsKey('default_model')) {
      context.handle(
          _defaultModelMeta,
          defaultModel.isAcceptableOrUnknown(
              data['default_model']!, _defaultModelMeta));
    }
    if (data.containsKey('default_embedding_model')) {
      context.handle(
          _defaultEmbeddingModelMeta,
          defaultEmbeddingModel.isAcceptableOrUnknown(
              data['default_embedding_model']!, _defaultEmbeddingModelMeta));
    }
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('extra_params')) {
      context.handle(
          _extraParamsMeta,
          extraParams.isAcceptableOrUnknown(
              data['extra_params']!, _extraParamsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('is_custom_provider')) {
      context.handle(
          _isCustomProviderMeta,
          isCustomProvider.isAcceptableOrUnknown(
              data['is_custom_provider']!, _isCustomProviderMeta));
    }
    if (data.containsKey('api_compatibility_type')) {
      context.handle(
          _apiCompatibilityTypeMeta,
          apiCompatibilityType.isAcceptableOrUnknown(
              data['api_compatibility_type']!, _apiCompatibilityTypeMeta));
    }
    if (data.containsKey('custom_provider_name')) {
      context.handle(
          _customProviderNameMeta,
          customProviderName.isAcceptableOrUnknown(
              data['custom_provider_name']!, _customProviderNameMeta));
    }
    if (data.containsKey('custom_provider_description')) {
      context.handle(
          _customProviderDescriptionMeta,
          customProviderDescription.isAcceptableOrUnknown(
              data['custom_provider_description']!,
              _customProviderDescriptionMeta));
    }
    if (data.containsKey('custom_provider_icon')) {
      context.handle(
          _customProviderIconMeta,
          customProviderIcon.isAcceptableOrUnknown(
              data['custom_provider_icon']!, _customProviderIconMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LlmConfigsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LlmConfigsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url']),
      defaultModel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_model']),
      defaultEmbeddingModel: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_embedding_model']),
      organizationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}organization_id']),
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      extraParams: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_params']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      isCustomProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_custom_provider'])!,
      apiCompatibilityType: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}api_compatibility_type'])!,
      customProviderName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_provider_name']),
      customProviderDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}custom_provider_description']),
      customProviderIcon: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_provider_icon']),
    );
  }

  @override
  $LlmConfigsTableTable createAlias(String alias) {
    return $LlmConfigsTableTable(attachedDatabase, alias);
  }
}

class LlmConfigsTableData extends DataClass
    implements Insertable<LlmConfigsTableData> {
  /// 配置唯一标识符
  final String id;

  /// 配置名称
  final String name;

  /// 提供商类型 (openai, google, anthropic)
  final String provider;

  /// API密钥
  final String apiKey;

  /// 基础URL（可选，用于代理）
  final String? baseUrl;

  /// 默认聊天模型
  final String? defaultModel;

  /// 默认嵌入模型
  final String? defaultEmbeddingModel;

  /// 组织ID（OpenAI专用）
  final String? organizationId;

  /// 项目ID（某些供应商）
  final String? projectId;

  /// 额外配置参数（JSON格式）
  final String? extraParams;

  /// 创建时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime updatedAt;

  /// 是否启用
  final bool isEnabled;

  /// 是否为自定义提供商
  final bool isCustomProvider;

  /// API兼容性类型 (openai, gemini, anthropic, custom)
  final String apiCompatibilityType;

  /// 自定义提供商显示名称
  final String? customProviderName;

  /// 自定义提供商描述
  final String? customProviderDescription;

  /// 自定义提供商图标（可选）
  final String? customProviderIcon;
  const LlmConfigsTableData(
      {required this.id,
      required this.name,
      required this.provider,
      required this.apiKey,
      this.baseUrl,
      this.defaultModel,
      this.defaultEmbeddingModel,
      this.organizationId,
      this.projectId,
      this.extraParams,
      required this.createdAt,
      required this.updatedAt,
      required this.isEnabled,
      required this.isCustomProvider,
      required this.apiCompatibilityType,
      this.customProviderName,
      this.customProviderDescription,
      this.customProviderIcon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['provider'] = Variable<String>(provider);
    map['api_key'] = Variable<String>(apiKey);
    if (!nullToAbsent || baseUrl != null) {
      map['base_url'] = Variable<String>(baseUrl);
    }
    if (!nullToAbsent || defaultModel != null) {
      map['default_model'] = Variable<String>(defaultModel);
    }
    if (!nullToAbsent || defaultEmbeddingModel != null) {
      map['default_embedding_model'] = Variable<String>(defaultEmbeddingModel);
    }
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || extraParams != null) {
      map['extra_params'] = Variable<String>(extraParams);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_custom_provider'] = Variable<bool>(isCustomProvider);
    map['api_compatibility_type'] = Variable<String>(apiCompatibilityType);
    if (!nullToAbsent || customProviderName != null) {
      map['custom_provider_name'] = Variable<String>(customProviderName);
    }
    if (!nullToAbsent || customProviderDescription != null) {
      map['custom_provider_description'] =
          Variable<String>(customProviderDescription);
    }
    if (!nullToAbsent || customProviderIcon != null) {
      map['custom_provider_icon'] = Variable<String>(customProviderIcon);
    }
    return map;
  }

  LlmConfigsTableCompanion toCompanion(bool nullToAbsent) {
    return LlmConfigsTableCompanion(
      id: Value(id),
      name: Value(name),
      provider: Value(provider),
      apiKey: Value(apiKey),
      baseUrl: baseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUrl),
      defaultModel: defaultModel == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultModel),
      defaultEmbeddingModel: defaultEmbeddingModel == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultEmbeddingModel),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      extraParams: extraParams == null && nullToAbsent
          ? const Value.absent()
          : Value(extraParams),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isEnabled: Value(isEnabled),
      isCustomProvider: Value(isCustomProvider),
      apiCompatibilityType: Value(apiCompatibilityType),
      customProviderName: customProviderName == null && nullToAbsent
          ? const Value.absent()
          : Value(customProviderName),
      customProviderDescription:
          customProviderDescription == null && nullToAbsent
              ? const Value.absent()
              : Value(customProviderDescription),
      customProviderIcon: customProviderIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(customProviderIcon),
    );
  }

  factory LlmConfigsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LlmConfigsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      provider: serializer.fromJson<String>(json['provider']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      baseUrl: serializer.fromJson<String?>(json['baseUrl']),
      defaultModel: serializer.fromJson<String?>(json['defaultModel']),
      defaultEmbeddingModel:
          serializer.fromJson<String?>(json['defaultEmbeddingModel']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      extraParams: serializer.fromJson<String?>(json['extraParams']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isCustomProvider: serializer.fromJson<bool>(json['isCustomProvider']),
      apiCompatibilityType:
          serializer.fromJson<String>(json['apiCompatibilityType']),
      customProviderName:
          serializer.fromJson<String?>(json['customProviderName']),
      customProviderDescription:
          serializer.fromJson<String?>(json['customProviderDescription']),
      customProviderIcon:
          serializer.fromJson<String?>(json['customProviderIcon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'provider': serializer.toJson<String>(provider),
      'apiKey': serializer.toJson<String>(apiKey),
      'baseUrl': serializer.toJson<String?>(baseUrl),
      'defaultModel': serializer.toJson<String?>(defaultModel),
      'defaultEmbeddingModel':
          serializer.toJson<String?>(defaultEmbeddingModel),
      'organizationId': serializer.toJson<String?>(organizationId),
      'projectId': serializer.toJson<String?>(projectId),
      'extraParams': serializer.toJson<String?>(extraParams),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isCustomProvider': serializer.toJson<bool>(isCustomProvider),
      'apiCompatibilityType': serializer.toJson<String>(apiCompatibilityType),
      'customProviderName': serializer.toJson<String?>(customProviderName),
      'customProviderDescription':
          serializer.toJson<String?>(customProviderDescription),
      'customProviderIcon': serializer.toJson<String?>(customProviderIcon),
    };
  }

  LlmConfigsTableData copyWith(
          {String? id,
          String? name,
          String? provider,
          String? apiKey,
          Value<String?> baseUrl = const Value.absent(),
          Value<String?> defaultModel = const Value.absent(),
          Value<String?> defaultEmbeddingModel = const Value.absent(),
          Value<String?> organizationId = const Value.absent(),
          Value<String?> projectId = const Value.absent(),
          Value<String?> extraParams = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isEnabled,
          bool? isCustomProvider,
          String? apiCompatibilityType,
          Value<String?> customProviderName = const Value.absent(),
          Value<String?> customProviderDescription = const Value.absent(),
          Value<String?> customProviderIcon = const Value.absent()}) =>
      LlmConfigsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        provider: provider ?? this.provider,
        apiKey: apiKey ?? this.apiKey,
        baseUrl: baseUrl.present ? baseUrl.value : this.baseUrl,
        defaultModel:
            defaultModel.present ? defaultModel.value : this.defaultModel,
        defaultEmbeddingModel: defaultEmbeddingModel.present
            ? defaultEmbeddingModel.value
            : this.defaultEmbeddingModel,
        organizationId:
            organizationId.present ? organizationId.value : this.organizationId,
        projectId: projectId.present ? projectId.value : this.projectId,
        extraParams: extraParams.present ? extraParams.value : this.extraParams,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isEnabled: isEnabled ?? this.isEnabled,
        isCustomProvider: isCustomProvider ?? this.isCustomProvider,
        apiCompatibilityType: apiCompatibilityType ?? this.apiCompatibilityType,
        customProviderName: customProviderName.present
            ? customProviderName.value
            : this.customProviderName,
        customProviderDescription: customProviderDescription.present
            ? customProviderDescription.value
            : this.customProviderDescription,
        customProviderIcon: customProviderIcon.present
            ? customProviderIcon.value
            : this.customProviderIcon,
      );
  LlmConfigsTableData copyWithCompanion(LlmConfigsTableCompanion data) {
    return LlmConfigsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      provider: data.provider.present ? data.provider.value : this.provider,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      defaultModel: data.defaultModel.present
          ? data.defaultModel.value
          : this.defaultModel,
      defaultEmbeddingModel: data.defaultEmbeddingModel.present
          ? data.defaultEmbeddingModel.value
          : this.defaultEmbeddingModel,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      extraParams:
          data.extraParams.present ? data.extraParams.value : this.extraParams,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isCustomProvider: data.isCustomProvider.present
          ? data.isCustomProvider.value
          : this.isCustomProvider,
      apiCompatibilityType: data.apiCompatibilityType.present
          ? data.apiCompatibilityType.value
          : this.apiCompatibilityType,
      customProviderName: data.customProviderName.present
          ? data.customProviderName.value
          : this.customProviderName,
      customProviderDescription: data.customProviderDescription.present
          ? data.customProviderDescription.value
          : this.customProviderDescription,
      customProviderIcon: data.customProviderIcon.present
          ? data.customProviderIcon.value
          : this.customProviderIcon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LlmConfigsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('provider: $provider, ')
          ..write('apiKey: $apiKey, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('defaultModel: $defaultModel, ')
          ..write('defaultEmbeddingModel: $defaultEmbeddingModel, ')
          ..write('organizationId: $organizationId, ')
          ..write('projectId: $projectId, ')
          ..write('extraParams: $extraParams, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustomProvider: $isCustomProvider, ')
          ..write('apiCompatibilityType: $apiCompatibilityType, ')
          ..write('customProviderName: $customProviderName, ')
          ..write('customProviderDescription: $customProviderDescription, ')
          ..write('customProviderIcon: $customProviderIcon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      provider,
      apiKey,
      baseUrl,
      defaultModel,
      defaultEmbeddingModel,
      organizationId,
      projectId,
      extraParams,
      createdAt,
      updatedAt,
      isEnabled,
      isCustomProvider,
      apiCompatibilityType,
      customProviderName,
      customProviderDescription,
      customProviderIcon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LlmConfigsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.provider == this.provider &&
          other.apiKey == this.apiKey &&
          other.baseUrl == this.baseUrl &&
          other.defaultModel == this.defaultModel &&
          other.defaultEmbeddingModel == this.defaultEmbeddingModel &&
          other.organizationId == this.organizationId &&
          other.projectId == this.projectId &&
          other.extraParams == this.extraParams &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isEnabled == this.isEnabled &&
          other.isCustomProvider == this.isCustomProvider &&
          other.apiCompatibilityType == this.apiCompatibilityType &&
          other.customProviderName == this.customProviderName &&
          other.customProviderDescription == this.customProviderDescription &&
          other.customProviderIcon == this.customProviderIcon);
}

class LlmConfigsTableCompanion extends UpdateCompanion<LlmConfigsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> provider;
  final Value<String> apiKey;
  final Value<String?> baseUrl;
  final Value<String?> defaultModel;
  final Value<String?> defaultEmbeddingModel;
  final Value<String?> organizationId;
  final Value<String?> projectId;
  final Value<String?> extraParams;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isEnabled;
  final Value<bool> isCustomProvider;
  final Value<String> apiCompatibilityType;
  final Value<String?> customProviderName;
  final Value<String?> customProviderDescription;
  final Value<String?> customProviderIcon;
  final Value<int> rowid;
  const LlmConfigsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.provider = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.defaultModel = const Value.absent(),
    this.defaultEmbeddingModel = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.extraParams = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustomProvider = const Value.absent(),
    this.apiCompatibilityType = const Value.absent(),
    this.customProviderName = const Value.absent(),
    this.customProviderDescription = const Value.absent(),
    this.customProviderIcon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LlmConfigsTableCompanion.insert({
    required String id,
    required String name,
    required String provider,
    required String apiKey,
    this.baseUrl = const Value.absent(),
    this.defaultModel = const Value.absent(),
    this.defaultEmbeddingModel = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.extraParams = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isEnabled = const Value.absent(),
    this.isCustomProvider = const Value.absent(),
    this.apiCompatibilityType = const Value.absent(),
    this.customProviderName = const Value.absent(),
    this.customProviderDescription = const Value.absent(),
    this.customProviderIcon = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        provider = Value(provider),
        apiKey = Value(apiKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<LlmConfigsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? provider,
    Expression<String>? apiKey,
    Expression<String>? baseUrl,
    Expression<String>? defaultModel,
    Expression<String>? defaultEmbeddingModel,
    Expression<String>? organizationId,
    Expression<String>? projectId,
    Expression<String>? extraParams,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isEnabled,
    Expression<bool>? isCustomProvider,
    Expression<String>? apiCompatibilityType,
    Expression<String>? customProviderName,
    Expression<String>? customProviderDescription,
    Expression<String>? customProviderIcon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (provider != null) 'provider': provider,
      if (apiKey != null) 'api_key': apiKey,
      if (baseUrl != null) 'base_url': baseUrl,
      if (defaultModel != null) 'default_model': defaultModel,
      if (defaultEmbeddingModel != null)
        'default_embedding_model': defaultEmbeddingModel,
      if (organizationId != null) 'organization_id': organizationId,
      if (projectId != null) 'project_id': projectId,
      if (extraParams != null) 'extra_params': extraParams,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isCustomProvider != null) 'is_custom_provider': isCustomProvider,
      if (apiCompatibilityType != null)
        'api_compatibility_type': apiCompatibilityType,
      if (customProviderName != null)
        'custom_provider_name': customProviderName,
      if (customProviderDescription != null)
        'custom_provider_description': customProviderDescription,
      if (customProviderIcon != null)
        'custom_provider_icon': customProviderIcon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LlmConfigsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? provider,
      Value<String>? apiKey,
      Value<String?>? baseUrl,
      Value<String?>? defaultModel,
      Value<String?>? defaultEmbeddingModel,
      Value<String?>? organizationId,
      Value<String?>? projectId,
      Value<String?>? extraParams,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isEnabled,
      Value<bool>? isCustomProvider,
      Value<String>? apiCompatibilityType,
      Value<String?>? customProviderName,
      Value<String?>? customProviderDescription,
      Value<String?>? customProviderIcon,
      Value<int>? rowid}) {
    return LlmConfigsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      defaultModel: defaultModel ?? this.defaultModel,
      defaultEmbeddingModel:
          defaultEmbeddingModel ?? this.defaultEmbeddingModel,
      organizationId: organizationId ?? this.organizationId,
      projectId: projectId ?? this.projectId,
      extraParams: extraParams ?? this.extraParams,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustomProvider: isCustomProvider ?? this.isCustomProvider,
      apiCompatibilityType: apiCompatibilityType ?? this.apiCompatibilityType,
      customProviderName: customProviderName ?? this.customProviderName,
      customProviderDescription:
          customProviderDescription ?? this.customProviderDescription,
      customProviderIcon: customProviderIcon ?? this.customProviderIcon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (defaultModel.present) {
      map['default_model'] = Variable<String>(defaultModel.value);
    }
    if (defaultEmbeddingModel.present) {
      map['default_embedding_model'] =
          Variable<String>(defaultEmbeddingModel.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (extraParams.present) {
      map['extra_params'] = Variable<String>(extraParams.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isCustomProvider.present) {
      map['is_custom_provider'] = Variable<bool>(isCustomProvider.value);
    }
    if (apiCompatibilityType.present) {
      map['api_compatibility_type'] =
          Variable<String>(apiCompatibilityType.value);
    }
    if (customProviderName.present) {
      map['custom_provider_name'] = Variable<String>(customProviderName.value);
    }
    if (customProviderDescription.present) {
      map['custom_provider_description'] =
          Variable<String>(customProviderDescription.value);
    }
    if (customProviderIcon.present) {
      map['custom_provider_icon'] = Variable<String>(customProviderIcon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LlmConfigsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('provider: $provider, ')
          ..write('apiKey: $apiKey, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('defaultModel: $defaultModel, ')
          ..write('defaultEmbeddingModel: $defaultEmbeddingModel, ')
          ..write('organizationId: $organizationId, ')
          ..write('projectId: $projectId, ')
          ..write('extraParams: $extraParams, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustomProvider: $isCustomProvider, ')
          ..write('apiCompatibilityType: $apiCompatibilityType, ')
          ..write('customProviderName: $customProviderName, ')
          ..write('customProviderDescription: $customProviderDescription, ')
          ..write('customProviderIcon: $customProviderIcon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonasTableTable extends PersonasTable
    with TableInfo<$PersonasTableTable, PersonasTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonasTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _systemPromptMeta =
      const VerificationMeta('systemPrompt');
  @override
  late final GeneratedColumn<String> systemPrompt = GeneratedColumn<String>(
      'system_prompt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apiConfigIdMeta =
      const VerificationMeta('apiConfigId');
  @override
  late final GeneratedColumn<String> apiConfigId = GeneratedColumn<String>(
      'api_config_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('assistant'));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _usageCountMeta =
      const VerificationMeta('usageCount');
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
      'usage_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumn<String> config = GeneratedColumn<String>(
      'config', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _capabilitiesMeta =
      const VerificationMeta('capabilities');
  @override
  late final GeneratedColumn<String> capabilities = GeneratedColumn<String>(
      'capabilities', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        systemPrompt,
        apiConfigId,
        createdAt,
        updatedAt,
        lastUsedAt,
        category,
        tags,
        avatar,
        isDefault,
        isEnabled,
        usageCount,
        config,
        capabilities,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personas_table';
  @override
  VerificationContext validateIntegrity(Insertable<PersonasTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('system_prompt')) {
      context.handle(
          _systemPromptMeta,
          systemPrompt.isAcceptableOrUnknown(
              data['system_prompt']!, _systemPromptMeta));
    } else if (isInserting) {
      context.missing(_systemPromptMeta);
    }
    if (data.containsKey('api_config_id')) {
      context.handle(
          _apiConfigIdMeta,
          apiConfigId.isAcceptableOrUnknown(
              data['api_config_id']!, _apiConfigIdMeta));
    } else if (isInserting) {
      context.missing(_apiConfigIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('usage_count')) {
      context.handle(
          _usageCountMeta,
          usageCount.isAcceptableOrUnknown(
              data['usage_count']!, _usageCountMeta));
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config']!, _configMeta));
    }
    if (data.containsKey('capabilities')) {
      context.handle(
          _capabilitiesMeta,
          capabilities.isAcceptableOrUnknown(
              data['capabilities']!, _capabilitiesMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonasTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonasTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      systemPrompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_prompt'])!,
      apiConfigId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_config_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      usageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage_count'])!,
      config: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config']),
      capabilities: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}capabilities'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
    );
  }

  @override
  $PersonasTableTable createAlias(String alias) {
    return $PersonasTableTable(attachedDatabase, alias);
  }
}

class PersonasTableData extends DataClass
    implements Insertable<PersonasTableData> {
  /// 智能体唯一标识符
  final String id;

  /// 智能体名称
  final String name;

  /// 智能体描述
  final String description;

  /// 系统提示词
  final String systemPrompt;

  /// 关联的API配置ID
  final String apiConfigId;

  /// 创建时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime updatedAt;

  /// 最后使用时间
  final DateTime? lastUsedAt;

  /// 智能体类型/分类
  final String category;

  /// 智能体标签（JSON数组格式）
  final String tags;

  /// 智能体头像/图标URL
  final String? avatar;

  /// 是否为默认智能体
  final bool isDefault;

  /// 是否启用
  final bool isEnabled;

  /// 使用次数统计
  final int usageCount;

  /// 智能体配置（JSON格式）
  final String? config;

  /// 智能体能力列表（JSON格式）
  final String capabilities;

  /// 元数据（JSON格式）
  final String? metadata;
  const PersonasTableData(
      {required this.id,
      required this.name,
      required this.description,
      required this.systemPrompt,
      required this.apiConfigId,
      required this.createdAt,
      required this.updatedAt,
      this.lastUsedAt,
      required this.category,
      required this.tags,
      this.avatar,
      required this.isDefault,
      required this.isEnabled,
      required this.usageCount,
      this.config,
      required this.capabilities,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['system_prompt'] = Variable<String>(systemPrompt);
    map['api_config_id'] = Variable<String>(apiConfigId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['category'] = Variable<String>(category);
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || config != null) {
      map['config'] = Variable<String>(config);
    }
    map['capabilities'] = Variable<String>(capabilities);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  PersonasTableCompanion toCompanion(bool nullToAbsent) {
    return PersonasTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      systemPrompt: Value(systemPrompt),
      apiConfigId: Value(apiConfigId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      category: Value(category),
      tags: Value(tags),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      isDefault: Value(isDefault),
      isEnabled: Value(isEnabled),
      usageCount: Value(usageCount),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
      capabilities: Value(capabilities),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory PersonasTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonasTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      systemPrompt: serializer.fromJson<String>(json['systemPrompt']),
      apiConfigId: serializer.fromJson<String>(json['apiConfigId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      category: serializer.fromJson<String>(json['category']),
      tags: serializer.fromJson<String>(json['tags']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      config: serializer.fromJson<String?>(json['config']),
      capabilities: serializer.fromJson<String>(json['capabilities']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'systemPrompt': serializer.toJson<String>(systemPrompt),
      'apiConfigId': serializer.toJson<String>(apiConfigId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'category': serializer.toJson<String>(category),
      'tags': serializer.toJson<String>(tags),
      'avatar': serializer.toJson<String?>(avatar),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'usageCount': serializer.toJson<int>(usageCount),
      'config': serializer.toJson<String?>(config),
      'capabilities': serializer.toJson<String>(capabilities),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  PersonasTableData copyWith(
          {String? id,
          String? name,
          String? description,
          String? systemPrompt,
          String? apiConfigId,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastUsedAt = const Value.absent(),
          String? category,
          String? tags,
          Value<String?> avatar = const Value.absent(),
          bool? isDefault,
          bool? isEnabled,
          int? usageCount,
          Value<String?> config = const Value.absent(),
          String? capabilities,
          Value<String?> metadata = const Value.absent()}) =>
      PersonasTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        apiConfigId: apiConfigId ?? this.apiConfigId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        category: category ?? this.category,
        tags: tags ?? this.tags,
        avatar: avatar.present ? avatar.value : this.avatar,
        isDefault: isDefault ?? this.isDefault,
        isEnabled: isEnabled ?? this.isEnabled,
        usageCount: usageCount ?? this.usageCount,
        config: config.present ? config.value : this.config,
        capabilities: capabilities ?? this.capabilities,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  PersonasTableData copyWithCompanion(PersonasTableCompanion data) {
    return PersonasTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      systemPrompt: data.systemPrompt.present
          ? data.systemPrompt.value
          : this.systemPrompt,
      apiConfigId:
          data.apiConfigId.present ? data.apiConfigId.value : this.apiConfigId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      category: data.category.present ? data.category.value : this.category,
      tags: data.tags.present ? data.tags.value : this.tags,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      usageCount:
          data.usageCount.present ? data.usageCount.value : this.usageCount,
      config: data.config.present ? data.config.value : this.config,
      capabilities: data.capabilities.present
          ? data.capabilities.value
          : this.capabilities,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonasTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('apiConfigId: $apiConfigId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('avatar: $avatar, ')
          ..write('isDefault: $isDefault, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('usageCount: $usageCount, ')
          ..write('config: $config, ')
          ..write('capabilities: $capabilities, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      systemPrompt,
      apiConfigId,
      createdAt,
      updatedAt,
      lastUsedAt,
      category,
      tags,
      avatar,
      isDefault,
      isEnabled,
      usageCount,
      config,
      capabilities,
      metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonasTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.systemPrompt == this.systemPrompt &&
          other.apiConfigId == this.apiConfigId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastUsedAt == this.lastUsedAt &&
          other.category == this.category &&
          other.tags == this.tags &&
          other.avatar == this.avatar &&
          other.isDefault == this.isDefault &&
          other.isEnabled == this.isEnabled &&
          other.usageCount == this.usageCount &&
          other.config == this.config &&
          other.capabilities == this.capabilities &&
          other.metadata == this.metadata);
}

class PersonasTableCompanion extends UpdateCompanion<PersonasTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> systemPrompt;
  final Value<String> apiConfigId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastUsedAt;
  final Value<String> category;
  final Value<String> tags;
  final Value<String?> avatar;
  final Value<bool> isDefault;
  final Value<bool> isEnabled;
  final Value<int> usageCount;
  final Value<String?> config;
  final Value<String> capabilities;
  final Value<String?> metadata;
  final Value<int> rowid;
  const PersonasTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.apiConfigId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.avatar = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.config = const Value.absent(),
    this.capabilities = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonasTableCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String systemPrompt,
    required String apiConfigId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastUsedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.tags = const Value.absent(),
    this.avatar = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.config = const Value.absent(),
    this.capabilities = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        systemPrompt = Value(systemPrompt),
        apiConfigId = Value(apiConfigId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PersonasTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? systemPrompt,
    Expression<String>? apiConfigId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastUsedAt,
    Expression<String>? category,
    Expression<String>? tags,
    Expression<String>? avatar,
    Expression<bool>? isDefault,
    Expression<bool>? isEnabled,
    Expression<int>? usageCount,
    Expression<String>? config,
    Expression<String>? capabilities,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (apiConfigId != null) 'api_config_id': apiConfigId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (category != null) 'category': category,
      if (tags != null) 'tags': tags,
      if (avatar != null) 'avatar': avatar,
      if (isDefault != null) 'is_default': isDefault,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (usageCount != null) 'usage_count': usageCount,
      if (config != null) 'config': config,
      if (capabilities != null) 'capabilities': capabilities,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonasTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? systemPrompt,
      Value<String>? apiConfigId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastUsedAt,
      Value<String>? category,
      Value<String>? tags,
      Value<String?>? avatar,
      Value<bool>? isDefault,
      Value<bool>? isEnabled,
      Value<int>? usageCount,
      Value<String?>? config,
      Value<String>? capabilities,
      Value<String?>? metadata,
      Value<int>? rowid}) {
    return PersonasTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      apiConfigId: apiConfigId ?? this.apiConfigId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      avatar: avatar ?? this.avatar,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
      usageCount: usageCount ?? this.usageCount,
      config: config ?? this.config,
      capabilities: capabilities ?? this.capabilities,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (systemPrompt.present) {
      map['system_prompt'] = Variable<String>(systemPrompt.value);
    }
    if (apiConfigId.present) {
      map['api_config_id'] = Variable<String>(apiConfigId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(config.value);
    }
    if (capabilities.present) {
      map['capabilities'] = Variable<String>(capabilities.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonasTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('apiConfigId: $apiConfigId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('category: $category, ')
          ..write('tags: $tags, ')
          ..write('avatar: $avatar, ')
          ..write('isDefault: $isDefault, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('usageCount: $usageCount, ')
          ..write('config: $config, ')
          ..write('capabilities: $capabilities, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonaGroupsTableTable extends PersonaGroupsTable
    with TableInfo<$PersonaGroupsTableTable, PersonaGroupsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonaGroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persona_groups_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PersonaGroupsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonaGroupsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonaGroupsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonaGroupsTableTable createAlias(String alias) {
    return $PersonaGroupsTableTable(attachedDatabase, alias);
  }
}

class PersonaGroupsTableData extends DataClass
    implements Insertable<PersonaGroupsTableData> {
  /// 分组唯一ID
  final String id;

  /// 分组名称
  final String name;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const PersonaGroupsTableData(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonaGroupsTableCompanion toCompanion(bool nullToAbsent) {
    return PersonaGroupsTableCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonaGroupsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonaGroupsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonaGroupsTableData copyWith(
          {String? id,
          String? name,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PersonaGroupsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PersonaGroupsTableData copyWithCompanion(PersonaGroupsTableCompanion data) {
    return PersonaGroupsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonaGroupsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonaGroupsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonaGroupsTableCompanion
    extends UpdateCompanion<PersonaGroupsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PersonaGroupsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonaGroupsTableCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PersonaGroupsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonaGroupsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PersonaGroupsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonaGroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatSessionsTableTable extends ChatSessionsTable
    with TableInfo<$ChatSessionsTableTable, ChatSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<String> personaId = GeneratedColumn<String>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _messageCountMeta =
      const VerificationMeta('messageCount');
  @override
  late final GeneratedColumn<int> messageCount = GeneratedColumn<int>(
      'message_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalTokensMeta =
      const VerificationMeta('totalTokens');
  @override
  late final GeneratedColumn<int> totalTokens = GeneratedColumn<int>(
      'total_tokens', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumn<String> config = GeneratedColumn<String>(
      'config', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        personaId,
        createdAt,
        updatedAt,
        isArchived,
        isPinned,
        tags,
        messageCount,
        totalTokens,
        config,
        metadata
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_sessions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChatSessionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('message_count')) {
      context.handle(
          _messageCountMeta,
          messageCount.isAcceptableOrUnknown(
              data['message_count']!, _messageCountMeta));
    }
    if (data.containsKey('total_tokens')) {
      context.handle(
          _totalTokensMeta,
          totalTokens.isAcceptableOrUnknown(
              data['total_tokens']!, _totalTokensMeta));
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config']!, _configMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatSessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatSessionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}persona_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      messageCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}message_count'])!,
      totalTokens: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_tokens'])!,
      config: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
    );
  }

  @override
  $ChatSessionsTableTable createAlias(String alias) {
    return $ChatSessionsTableTable(attachedDatabase, alias);
  }
}

class ChatSessionsTableData extends DataClass
    implements Insertable<ChatSessionsTableData> {
  /// 会话唯一标识符
  final String id;

  /// 会话标题
  final String title;

  /// 关联的智能体ID
  final String personaId;

  /// 会话创建时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime updatedAt;

  /// 会话是否已归档
  final bool isArchived;

  /// 会话是否置顶
  final bool isPinned;

  /// 会话标签（JSON数组格式）
  final String tags;

  /// 消息总数
  final int messageCount;

  /// 总token使用量
  final int totalTokens;

  /// 会话配置（JSON格式）
  final String? config;

  /// 会话元数据（JSON格式）
  final String? metadata;
  const ChatSessionsTableData(
      {required this.id,
      required this.title,
      required this.personaId,
      required this.createdAt,
      required this.updatedAt,
      required this.isArchived,
      required this.isPinned,
      required this.tags,
      required this.messageCount,
      required this.totalTokens,
      this.config,
      this.metadata});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['persona_id'] = Variable<String>(personaId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['tags'] = Variable<String>(tags);
    map['message_count'] = Variable<int>(messageCount);
    map['total_tokens'] = Variable<int>(totalTokens);
    if (!nullToAbsent || config != null) {
      map['config'] = Variable<String>(config);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  ChatSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return ChatSessionsTableCompanion(
      id: Value(id),
      title: Value(title),
      personaId: Value(personaId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
      isPinned: Value(isPinned),
      tags: Value(tags),
      messageCount: Value(messageCount),
      totalTokens: Value(totalTokens),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory ChatSessionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      personaId: serializer.fromJson<String>(json['personaId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      tags: serializer.fromJson<String>(json['tags']),
      messageCount: serializer.fromJson<int>(json['messageCount']),
      totalTokens: serializer.fromJson<int>(json['totalTokens']),
      config: serializer.fromJson<String?>(json['config']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'personaId': serializer.toJson<String>(personaId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isPinned': serializer.toJson<bool>(isPinned),
      'tags': serializer.toJson<String>(tags),
      'messageCount': serializer.toJson<int>(messageCount),
      'totalTokens': serializer.toJson<int>(totalTokens),
      'config': serializer.toJson<String?>(config),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  ChatSessionsTableData copyWith(
          {String? id,
          String? title,
          String? personaId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isArchived,
          bool? isPinned,
          String? tags,
          int? messageCount,
          int? totalTokens,
          Value<String?> config = const Value.absent(),
          Value<String?> metadata = const Value.absent()}) =>
      ChatSessionsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        personaId: personaId ?? this.personaId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isArchived: isArchived ?? this.isArchived,
        isPinned: isPinned ?? this.isPinned,
        tags: tags ?? this.tags,
        messageCount: messageCount ?? this.messageCount,
        totalTokens: totalTokens ?? this.totalTokens,
        config: config.present ? config.value : this.config,
        metadata: metadata.present ? metadata.value : this.metadata,
      );
  ChatSessionsTableData copyWithCompanion(ChatSessionsTableCompanion data) {
    return ChatSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      tags: data.tags.present ? data.tags.value : this.tags,
      messageCount: data.messageCount.present
          ? data.messageCount.value
          : this.messageCount,
      totalTokens:
          data.totalTokens.present ? data.totalTokens.value : this.totalTokens,
      config: data.config.present ? data.config.value : this.config,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('personaId: $personaId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('isPinned: $isPinned, ')
          ..write('tags: $tags, ')
          ..write('messageCount: $messageCount, ')
          ..write('totalTokens: $totalTokens, ')
          ..write('config: $config, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, personaId, createdAt, updatedAt,
      isArchived, isPinned, tags, messageCount, totalTokens, config, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatSessionsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.personaId == this.personaId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived &&
          other.isPinned == this.isPinned &&
          other.tags == this.tags &&
          other.messageCount == this.messageCount &&
          other.totalTokens == this.totalTokens &&
          other.config == this.config &&
          other.metadata == this.metadata);
}

class ChatSessionsTableCompanion
    extends UpdateCompanion<ChatSessionsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> personaId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<bool> isPinned;
  final Value<String> tags;
  final Value<int> messageCount;
  final Value<int> totalTokens;
  final Value<String?> config;
  final Value<String?> metadata;
  final Value<int> rowid;
  const ChatSessionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.personaId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.tags = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.totalTokens = const Value.absent(),
    this.config = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatSessionsTableCompanion.insert({
    required String id,
    required String title,
    required String personaId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.tags = const Value.absent(),
    this.messageCount = const Value.absent(),
    this.totalTokens = const Value.absent(),
    this.config = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        personaId = Value(personaId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ChatSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? personaId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<bool>? isPinned,
    Expression<String>? tags,
    Expression<int>? messageCount,
    Expression<int>? totalTokens,
    Expression<String>? config,
    Expression<String>? metadata,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (personaId != null) 'persona_id': personaId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (isPinned != null) 'is_pinned': isPinned,
      if (tags != null) 'tags': tags,
      if (messageCount != null) 'message_count': messageCount,
      if (totalTokens != null) 'total_tokens': totalTokens,
      if (config != null) 'config': config,
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatSessionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? personaId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isArchived,
      Value<bool>? isPinned,
      Value<String>? tags,
      Value<int>? messageCount,
      Value<int>? totalTokens,
      Value<String?>? config,
      Value<String?>? metadata,
      Value<int>? rowid}) {
    return ChatSessionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      personaId: personaId ?? this.personaId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      messageCount: messageCount ?? this.messageCount,
      totalTokens: totalTokens ?? this.totalTokens,
      config: config ?? this.config,
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<String>(personaId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (messageCount.present) {
      map['message_count'] = Variable<int>(messageCount.value);
    }
    if (totalTokens.present) {
      map['total_tokens'] = Variable<int>(totalTokens.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(config.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('personaId: $personaId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('isPinned: $isPinned, ')
          ..write('tags: $tags, ')
          ..write('messageCount: $messageCount, ')
          ..write('totalTokens: $totalTokens, ')
          ..write('config: $config, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTableTable extends ChatMessagesTable
    with TableInfo<$ChatMessagesTableTable, ChatMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isFromUserMeta =
      const VerificationMeta('isFromUser');
  @override
  late final GeneratedColumn<bool> isFromUser = GeneratedColumn<bool>(
      'is_from_user', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_from_user" IN (0, 1))'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _chatSessionIdMeta =
      const VerificationMeta('chatSessionId');
  @override
  late final GeneratedColumn<String> chatSessionId = GeneratedColumn<String>(
      'chat_session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('text'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('sent'));
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentMessageIdMeta =
      const VerificationMeta('parentMessageId');
  @override
  late final GeneratedColumn<String> parentMessageId = GeneratedColumn<String>(
      'parent_message_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tokenCountMeta =
      const VerificationMeta('tokenCount');
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
      'token_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _thinkingContentMeta =
      const VerificationMeta('thinkingContent');
  @override
  late final GeneratedColumn<String> thinkingContent = GeneratedColumn<String>(
      'thinking_content', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _thinkingCompleteMeta =
      const VerificationMeta('thinkingComplete');
  @override
  late final GeneratedColumn<bool> thinkingComplete = GeneratedColumn<bool>(
      'thinking_complete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("thinking_complete" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlsMeta =
      const VerificationMeta('imageUrls');
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
      'image_urls', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        content,
        isFromUser,
        timestamp,
        chatSessionId,
        type,
        status,
        metadata,
        parentMessageId,
        tokenCount,
        thinkingContent,
        thinkingComplete,
        modelName,
        imageUrls
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ChatMessagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_from_user')) {
      context.handle(
          _isFromUserMeta,
          isFromUser.isAcceptableOrUnknown(
              data['is_from_user']!, _isFromUserMeta));
    } else if (isInserting) {
      context.missing(_isFromUserMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('chat_session_id')) {
      context.handle(
          _chatSessionIdMeta,
          chatSessionId.isAcceptableOrUnknown(
              data['chat_session_id']!, _chatSessionIdMeta));
    } else if (isInserting) {
      context.missing(_chatSessionIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('parent_message_id')) {
      context.handle(
          _parentMessageIdMeta,
          parentMessageId.isAcceptableOrUnknown(
              data['parent_message_id']!, _parentMessageIdMeta));
    }
    if (data.containsKey('token_count')) {
      context.handle(
          _tokenCountMeta,
          tokenCount.isAcceptableOrUnknown(
              data['token_count']!, _tokenCountMeta));
    }
    if (data.containsKey('thinking_content')) {
      context.handle(
          _thinkingContentMeta,
          thinkingContent.isAcceptableOrUnknown(
              data['thinking_content']!, _thinkingContentMeta));
    }
    if (data.containsKey('thinking_complete')) {
      context.handle(
          _thinkingCompleteMeta,
          thinkingComplete.isAcceptableOrUnknown(
              data['thinking_complete']!, _thinkingCompleteMeta));
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    }
    if (data.containsKey('image_urls')) {
      context.handle(_imageUrlsMeta,
          imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessagesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      isFromUser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_from_user'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      chatSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chat_session_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      parentMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}parent_message_id']),
      tokenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}token_count']),
      thinkingContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}thinking_content']),
      thinkingComplete: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}thinking_complete'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name']),
      imageUrls: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_urls'])!,
    );
  }

  @override
  $ChatMessagesTableTable createAlias(String alias) {
    return $ChatMessagesTableTable(attachedDatabase, alias);
  }
}

class ChatMessagesTableData extends DataClass
    implements Insertable<ChatMessagesTableData> {
  /// 消息唯一标识符
  final String id;

  /// 消息内容
  final String content;

  /// 是否来自用户（false表示来自AI）
  final bool isFromUser;

  /// 消息创建时间
  final DateTime timestamp;

  /// 关联的聊天会话ID
  final String chatSessionId;

  /// 消息类型 (text, image, file, system, error)
  final String type;

  /// 消息状态 (sending, sent, failed, read)
  final String status;

  /// 消息元数据（JSON格式）
  final String? metadata;

  /// 父消息ID（用于回复功能）
  final String? parentMessageId;

  /// 消息使用的token数量
  final int? tokenCount;

  /// 思考链内容（AI思考过程）
  final String? thinkingContent;

  /// 思考链是否完整
  final bool thinkingComplete;

  /// 使用的模型名称（用于特殊处理）
  final String? modelName;

  /// 图片URL列表（JSON格式存储）
  final String imageUrls;
  const ChatMessagesTableData(
      {required this.id,
      required this.content,
      required this.isFromUser,
      required this.timestamp,
      required this.chatSessionId,
      required this.type,
      required this.status,
      this.metadata,
      this.parentMessageId,
      this.tokenCount,
      this.thinkingContent,
      required this.thinkingComplete,
      this.modelName,
      required this.imageUrls});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['is_from_user'] = Variable<bool>(isFromUser);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['chat_session_id'] = Variable<String>(chatSessionId);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    if (!nullToAbsent || parentMessageId != null) {
      map['parent_message_id'] = Variable<String>(parentMessageId);
    }
    if (!nullToAbsent || tokenCount != null) {
      map['token_count'] = Variable<int>(tokenCount);
    }
    if (!nullToAbsent || thinkingContent != null) {
      map['thinking_content'] = Variable<String>(thinkingContent);
    }
    map['thinking_complete'] = Variable<bool>(thinkingComplete);
    if (!nullToAbsent || modelName != null) {
      map['model_name'] = Variable<String>(modelName);
    }
    map['image_urls'] = Variable<String>(imageUrls);
    return map;
  }

  ChatMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesTableCompanion(
      id: Value(id),
      content: Value(content),
      isFromUser: Value(isFromUser),
      timestamp: Value(timestamp),
      chatSessionId: Value(chatSessionId),
      type: Value(type),
      status: Value(status),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      parentMessageId: parentMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentMessageId),
      tokenCount: tokenCount == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenCount),
      thinkingContent: thinkingContent == null && nullToAbsent
          ? const Value.absent()
          : Value(thinkingContent),
      thinkingComplete: Value(thinkingComplete),
      modelName: modelName == null && nullToAbsent
          ? const Value.absent()
          : Value(modelName),
      imageUrls: Value(imageUrls),
    );
  }

  factory ChatMessagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      isFromUser: serializer.fromJson<bool>(json['isFromUser']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      chatSessionId: serializer.fromJson<String>(json['chatSessionId']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      parentMessageId: serializer.fromJson<String?>(json['parentMessageId']),
      tokenCount: serializer.fromJson<int?>(json['tokenCount']),
      thinkingContent: serializer.fromJson<String?>(json['thinkingContent']),
      thinkingComplete: serializer.fromJson<bool>(json['thinkingComplete']),
      modelName: serializer.fromJson<String?>(json['modelName']),
      imageUrls: serializer.fromJson<String>(json['imageUrls']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'isFromUser': serializer.toJson<bool>(isFromUser),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'chatSessionId': serializer.toJson<String>(chatSessionId),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'metadata': serializer.toJson<String?>(metadata),
      'parentMessageId': serializer.toJson<String?>(parentMessageId),
      'tokenCount': serializer.toJson<int?>(tokenCount),
      'thinkingContent': serializer.toJson<String?>(thinkingContent),
      'thinkingComplete': serializer.toJson<bool>(thinkingComplete),
      'modelName': serializer.toJson<String?>(modelName),
      'imageUrls': serializer.toJson<String>(imageUrls),
    };
  }

  ChatMessagesTableData copyWith(
          {String? id,
          String? content,
          bool? isFromUser,
          DateTime? timestamp,
          String? chatSessionId,
          String? type,
          String? status,
          Value<String?> metadata = const Value.absent(),
          Value<String?> parentMessageId = const Value.absent(),
          Value<int?> tokenCount = const Value.absent(),
          Value<String?> thinkingContent = const Value.absent(),
          bool? thinkingComplete,
          Value<String?> modelName = const Value.absent(),
          String? imageUrls}) =>
      ChatMessagesTableData(
        id: id ?? this.id,
        content: content ?? this.content,
        isFromUser: isFromUser ?? this.isFromUser,
        timestamp: timestamp ?? this.timestamp,
        chatSessionId: chatSessionId ?? this.chatSessionId,
        type: type ?? this.type,
        status: status ?? this.status,
        metadata: metadata.present ? metadata.value : this.metadata,
        parentMessageId: parentMessageId.present
            ? parentMessageId.value
            : this.parentMessageId,
        tokenCount: tokenCount.present ? tokenCount.value : this.tokenCount,
        thinkingContent: thinkingContent.present
            ? thinkingContent.value
            : this.thinkingContent,
        thinkingComplete: thinkingComplete ?? this.thinkingComplete,
        modelName: modelName.present ? modelName.value : this.modelName,
        imageUrls: imageUrls ?? this.imageUrls,
      );
  ChatMessagesTableData copyWithCompanion(ChatMessagesTableCompanion data) {
    return ChatMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      isFromUser:
          data.isFromUser.present ? data.isFromUser.value : this.isFromUser,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      chatSessionId: data.chatSessionId.present
          ? data.chatSessionId.value
          : this.chatSessionId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      parentMessageId: data.parentMessageId.present
          ? data.parentMessageId.value
          : this.parentMessageId,
      tokenCount:
          data.tokenCount.present ? data.tokenCount.value : this.tokenCount,
      thinkingContent: data.thinkingContent.present
          ? data.thinkingContent.value
          : this.thinkingContent,
      thinkingComplete: data.thinkingComplete.present
          ? data.thinkingComplete.value
          : this.thinkingComplete,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesTableData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('isFromUser: $isFromUser, ')
          ..write('timestamp: $timestamp, ')
          ..write('chatSessionId: $chatSessionId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('metadata: $metadata, ')
          ..write('parentMessageId: $parentMessageId, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('thinkingContent: $thinkingContent, ')
          ..write('thinkingComplete: $thinkingComplete, ')
          ..write('modelName: $modelName, ')
          ..write('imageUrls: $imageUrls')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      content,
      isFromUser,
      timestamp,
      chatSessionId,
      type,
      status,
      metadata,
      parentMessageId,
      tokenCount,
      thinkingContent,
      thinkingComplete,
      modelName,
      imageUrls);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessagesTableData &&
          other.id == this.id &&
          other.content == this.content &&
          other.isFromUser == this.isFromUser &&
          other.timestamp == this.timestamp &&
          other.chatSessionId == this.chatSessionId &&
          other.type == this.type &&
          other.status == this.status &&
          other.metadata == this.metadata &&
          other.parentMessageId == this.parentMessageId &&
          other.tokenCount == this.tokenCount &&
          other.thinkingContent == this.thinkingContent &&
          other.thinkingComplete == this.thinkingComplete &&
          other.modelName == this.modelName &&
          other.imageUrls == this.imageUrls);
}

class ChatMessagesTableCompanion
    extends UpdateCompanion<ChatMessagesTableData> {
  final Value<String> id;
  final Value<String> content;
  final Value<bool> isFromUser;
  final Value<DateTime> timestamp;
  final Value<String> chatSessionId;
  final Value<String> type;
  final Value<String> status;
  final Value<String?> metadata;
  final Value<String?> parentMessageId;
  final Value<int?> tokenCount;
  final Value<String?> thinkingContent;
  final Value<bool> thinkingComplete;
  final Value<String?> modelName;
  final Value<String> imageUrls;
  final Value<int> rowid;
  const ChatMessagesTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.isFromUser = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.chatSessionId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.metadata = const Value.absent(),
    this.parentMessageId = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.thinkingContent = const Value.absent(),
    this.thinkingComplete = const Value.absent(),
    this.modelName = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesTableCompanion.insert({
    required String id,
    required String content,
    required bool isFromUser,
    required DateTime timestamp,
    required String chatSessionId,
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.metadata = const Value.absent(),
    this.parentMessageId = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.thinkingContent = const Value.absent(),
    this.thinkingComplete = const Value.absent(),
    this.modelName = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        content = Value(content),
        isFromUser = Value(isFromUser),
        timestamp = Value(timestamp),
        chatSessionId = Value(chatSessionId);
  static Insertable<ChatMessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<bool>? isFromUser,
    Expression<DateTime>? timestamp,
    Expression<String>? chatSessionId,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? metadata,
    Expression<String>? parentMessageId,
    Expression<int>? tokenCount,
    Expression<String>? thinkingContent,
    Expression<bool>? thinkingComplete,
    Expression<String>? modelName,
    Expression<String>? imageUrls,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (isFromUser != null) 'is_from_user': isFromUser,
      if (timestamp != null) 'timestamp': timestamp,
      if (chatSessionId != null) 'chat_session_id': chatSessionId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (metadata != null) 'metadata': metadata,
      if (parentMessageId != null) 'parent_message_id': parentMessageId,
      if (tokenCount != null) 'token_count': tokenCount,
      if (thinkingContent != null) 'thinking_content': thinkingContent,
      if (thinkingComplete != null) 'thinking_complete': thinkingComplete,
      if (modelName != null) 'model_name': modelName,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? content,
      Value<bool>? isFromUser,
      Value<DateTime>? timestamp,
      Value<String>? chatSessionId,
      Value<String>? type,
      Value<String>? status,
      Value<String?>? metadata,
      Value<String?>? parentMessageId,
      Value<int?>? tokenCount,
      Value<String?>? thinkingContent,
      Value<bool>? thinkingComplete,
      Value<String?>? modelName,
      Value<String>? imageUrls,
      Value<int>? rowid}) {
    return ChatMessagesTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      chatSessionId: chatSessionId ?? this.chatSessionId,
      type: type ?? this.type,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      tokenCount: tokenCount ?? this.tokenCount,
      thinkingContent: thinkingContent ?? this.thinkingContent,
      thinkingComplete: thinkingComplete ?? this.thinkingComplete,
      modelName: modelName ?? this.modelName,
      imageUrls: imageUrls ?? this.imageUrls,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isFromUser.present) {
      map['is_from_user'] = Variable<bool>(isFromUser.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (chatSessionId.present) {
      map['chat_session_id'] = Variable<String>(chatSessionId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (parentMessageId.present) {
      map['parent_message_id'] = Variable<String>(parentMessageId.value);
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
    }
    if (thinkingContent.present) {
      map['thinking_content'] = Variable<String>(thinkingContent.value);
    }
    if (thinkingComplete.present) {
      map['thinking_complete'] = Variable<bool>(thinkingComplete.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('isFromUser: $isFromUser, ')
          ..write('timestamp: $timestamp, ')
          ..write('chatSessionId: $chatSessionId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('metadata: $metadata, ')
          ..write('parentMessageId: $parentMessageId, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('thinkingContent: $thinkingContent, ')
          ..write('thinkingComplete: $thinkingComplete, ')
          ..write('modelName: $modelName, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeBasesTableTable extends KnowledgeBasesTable
    with TableInfo<$KnowledgeBasesTableTable, KnowledgeBasesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeBasesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _configIdMeta =
      const VerificationMeta('configId');
  @override
  late final GeneratedColumn<String> configId = GeneratedColumn<String>(
      'config_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentCountMeta =
      const VerificationMeta('documentCount');
  @override
  late final GeneratedColumn<int> documentCount = GeneratedColumn<int>(
      'document_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _chunkCountMeta =
      const VerificationMeta('chunkCount');
  @override
  late final GeneratedColumn<int> chunkCount = GeneratedColumn<int>(
      'chunk_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        icon,
        color,
        configId,
        documentCount,
        chunkCount,
        isDefault,
        isEnabled,
        createdAt,
        updatedAt,
        lastUsedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_bases_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeBasesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('config_id')) {
      context.handle(_configIdMeta,
          configId.isAcceptableOrUnknown(data['config_id']!, _configIdMeta));
    } else if (isInserting) {
      context.missing(_configIdMeta);
    }
    if (data.containsKey('document_count')) {
      context.handle(
          _documentCountMeta,
          documentCount.isAcceptableOrUnknown(
              data['document_count']!, _documentCountMeta));
    }
    if (data.containsKey('chunk_count')) {
      context.handle(
          _chunkCountMeta,
          chunkCount.isAcceptableOrUnknown(
              data['chunk_count']!, _chunkCountMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeBasesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeBasesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      configId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config_id'])!,
      documentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}document_count'])!,
      chunkCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunk_count'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
    );
  }

  @override
  $KnowledgeBasesTableTable createAlias(String alias) {
    return $KnowledgeBasesTableTable(attachedDatabase, alias);
  }
}

class KnowledgeBasesTableData extends DataClass
    implements Insertable<KnowledgeBasesTableData> {
  /// 知识库唯一标识符
  final String id;

  /// 知识库名称
  final String name;

  /// 知识库描述
  final String? description;

  /// 知识库图标（可选）
  final String? icon;

  /// 知识库颜色（可选）
  final String? color;

  /// 关联的配置ID（引用knowledge_base_configs_table.id）
  final String configId;

  /// 文档数量
  final int documentCount;

  /// 文本块数量
  final int chunkCount;

  /// 是否为默认知识库
  final bool isDefault;

  /// 是否启用
  final bool isEnabled;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 最后使用时间
  final DateTime? lastUsedAt;
  const KnowledgeBasesTableData(
      {required this.id,
      required this.name,
      this.description,
      this.icon,
      this.color,
      required this.configId,
      required this.documentCount,
      required this.chunkCount,
      required this.isDefault,
      required this.isEnabled,
      required this.createdAt,
      required this.updatedAt,
      this.lastUsedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['config_id'] = Variable<String>(configId);
    map['document_count'] = Variable<int>(documentCount);
    map['chunk_count'] = Variable<int>(chunkCount);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    return map;
  }

  KnowledgeBasesTableCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeBasesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      configId: Value(configId),
      documentCount: Value(documentCount),
      chunkCount: Value(chunkCount),
      isDefault: Value(isDefault),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
    );
  }

  factory KnowledgeBasesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeBasesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      configId: serializer.fromJson<String>(json['configId']),
      documentCount: serializer.fromJson<int>(json['documentCount']),
      chunkCount: serializer.fromJson<int>(json['chunkCount']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
      'configId': serializer.toJson<String>(configId),
      'documentCount': serializer.toJson<int>(documentCount),
      'chunkCount': serializer.toJson<int>(chunkCount),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
    };
  }

  KnowledgeBasesTableData copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> icon = const Value.absent(),
          Value<String?> color = const Value.absent(),
          String? configId,
          int? documentCount,
          int? chunkCount,
          bool? isDefault,
          bool? isEnabled,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastUsedAt = const Value.absent()}) =>
      KnowledgeBasesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        configId: configId ?? this.configId,
        documentCount: documentCount ?? this.documentCount,
        chunkCount: chunkCount ?? this.chunkCount,
        isDefault: isDefault ?? this.isDefault,
        isEnabled: isEnabled ?? this.isEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
      );
  KnowledgeBasesTableData copyWithCompanion(KnowledgeBasesTableCompanion data) {
    return KnowledgeBasesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      configId: data.configId.present ? data.configId.value : this.configId,
      documentCount: data.documentCount.present
          ? data.documentCount.value
          : this.documentCount,
      chunkCount:
          data.chunkCount.present ? data.chunkCount.value : this.chunkCount,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeBasesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('configId: $configId, ')
          ..write('documentCount: $documentCount, ')
          ..write('chunkCount: $chunkCount, ')
          ..write('isDefault: $isDefault, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      icon,
      color,
      configId,
      documentCount,
      chunkCount,
      isDefault,
      isEnabled,
      createdAt,
      updatedAt,
      lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeBasesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.configId == this.configId &&
          other.documentCount == this.documentCount &&
          other.chunkCount == this.chunkCount &&
          other.isDefault == this.isDefault &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class KnowledgeBasesTableCompanion
    extends UpdateCompanion<KnowledgeBasesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> icon;
  final Value<String?> color;
  final Value<String> configId;
  final Value<int> documentCount;
  final Value<int> chunkCount;
  final Value<bool> isDefault;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastUsedAt;
  final Value<int> rowid;
  const KnowledgeBasesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.configId = const Value.absent(),
    this.documentCount = const Value.absent(),
    this.chunkCount = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeBasesTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    required String configId,
    this.documentCount = const Value.absent(),
    this.chunkCount = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastUsedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        configId = Value(configId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<KnowledgeBasesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<String>? configId,
    Expression<int>? documentCount,
    Expression<int>? chunkCount,
    Expression<bool>? isDefault,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastUsedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (configId != null) 'config_id': configId,
      if (documentCount != null) 'document_count': documentCount,
      if (chunkCount != null) 'chunk_count': chunkCount,
      if (isDefault != null) 'is_default': isDefault,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeBasesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? icon,
      Value<String?>? color,
      Value<String>? configId,
      Value<int>? documentCount,
      Value<int>? chunkCount,
      Value<bool>? isDefault,
      Value<bool>? isEnabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastUsedAt,
      Value<int>? rowid}) {
    return KnowledgeBasesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      configId: configId ?? this.configId,
      documentCount: documentCount ?? this.documentCount,
      chunkCount: chunkCount ?? this.chunkCount,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (configId.present) {
      map['config_id'] = Variable<String>(configId.value);
    }
    if (documentCount.present) {
      map['document_count'] = Variable<int>(documentCount.value);
    }
    if (chunkCount.present) {
      map['chunk_count'] = Variable<int>(chunkCount.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeBasesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('configId: $configId, ')
          ..write('documentCount: $documentCount, ')
          ..write('chunkCount: $chunkCount, ')
          ..write('isDefault: $isDefault, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeDocumentsTableTable extends KnowledgeDocumentsTable
    with TableInfo<$KnowledgeDocumentsTableTable, KnowledgeDocumentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeDocumentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _knowledgeBaseIdMeta =
      const VerificationMeta('knowledgeBaseId');
  @override
  late final GeneratedColumn<String> knowledgeBaseId = GeneratedColumn<String>(
      'knowledge_base_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileHashMeta =
      const VerificationMeta('fileHash');
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
      'file_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chunksMeta = const VerificationMeta('chunks');
  @override
  late final GeneratedColumn<int> chunks = GeneratedColumn<int>(
      'chunks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _indexProgressMeta =
      const VerificationMeta('indexProgress');
  @override
  late final GeneratedColumn<double> indexProgress = GeneratedColumn<double>(
      'index_progress', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _uploadedAtMeta =
      const VerificationMeta('uploadedAt');
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
      'uploaded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _processedAtMeta =
      const VerificationMeta('processedAt');
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
      'processed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _metadataMeta =
      const VerificationMeta('metadata');
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
      'metadata', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        knowledgeBaseId,
        name,
        type,
        size,
        filePath,
        fileHash,
        chunks,
        status,
        indexProgress,
        uploadedAt,
        processedAt,
        metadata,
        errorMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_documents_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeDocumentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('knowledge_base_id')) {
      context.handle(
          _knowledgeBaseIdMeta,
          knowledgeBaseId.isAcceptableOrUnknown(
              data['knowledge_base_id']!, _knowledgeBaseIdMeta));
    } else if (isInserting) {
      context.missing(_knowledgeBaseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(_fileHashMeta,
          fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta));
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('chunks')) {
      context.handle(_chunksMeta,
          chunks.isAcceptableOrUnknown(data['chunks']!, _chunksMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('index_progress')) {
      context.handle(
          _indexProgressMeta,
          indexProgress.isAcceptableOrUnknown(
              data['index_progress']!, _indexProgressMeta));
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
          _uploadedAtMeta,
          uploadedAt.isAcceptableOrUnknown(
              data['uploaded_at']!, _uploadedAtMeta));
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
          _processedAtMeta,
          processedAt.isAcceptableOrUnknown(
              data['processed_at']!, _processedAtMeta));
    }
    if (data.containsKey('metadata')) {
      context.handle(_metadataMeta,
          metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeDocumentsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeDocumentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      knowledgeBaseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}knowledge_base_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_hash'])!,
      chunks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunks'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      indexProgress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}index_progress'])!,
      uploadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}uploaded_at'])!,
      processedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}processed_at']),
      metadata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata']),
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
    );
  }

  @override
  $KnowledgeDocumentsTableTable createAlias(String alias) {
    return $KnowledgeDocumentsTableTable(attachedDatabase, alias);
  }
}

class KnowledgeDocumentsTableData extends DataClass
    implements Insertable<KnowledgeDocumentsTableData> {
  /// 文档唯一标识符
  final String id;

  /// 所属知识库ID（引用knowledge_bases_table.id）
  final String knowledgeBaseId;

  /// 文档名称
  final String name;

  /// 文档类型 (pdf, txt, md, docx, etc.)
  final String type;

  /// 文件大小（字节）
  final int size;

  /// 文档路径
  final String filePath;

  /// 文档哈希值（用于去重）
  final String fileHash;

  /// 文本块数量
  final int chunks;

  /// 处理状态 (pending, processing, completed, failed)
  final String status;

  /// 索引进度 (0.0 - 1.0)
  final double indexProgress;

  /// 上传时间
  final DateTime uploadedAt;

  /// 最后处理时间
  final DateTime? processedAt;

  /// 文档元数据（JSON格式）
  final String? metadata;

  /// 错误信息（如果处理失败）
  final String? errorMessage;
  const KnowledgeDocumentsTableData(
      {required this.id,
      required this.knowledgeBaseId,
      required this.name,
      required this.type,
      required this.size,
      required this.filePath,
      required this.fileHash,
      required this.chunks,
      required this.status,
      required this.indexProgress,
      required this.uploadedAt,
      this.processedAt,
      this.metadata,
      this.errorMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['knowledge_base_id'] = Variable<String>(knowledgeBaseId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['size'] = Variable<int>(size);
    map['file_path'] = Variable<String>(filePath);
    map['file_hash'] = Variable<String>(fileHash);
    map['chunks'] = Variable<int>(chunks);
    map['status'] = Variable<String>(status);
    map['index_progress'] = Variable<double>(indexProgress);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  KnowledgeDocumentsTableCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeDocumentsTableCompanion(
      id: Value(id),
      knowledgeBaseId: Value(knowledgeBaseId),
      name: Value(name),
      type: Value(type),
      size: Value(size),
      filePath: Value(filePath),
      fileHash: Value(fileHash),
      chunks: Value(chunks),
      status: Value(status),
      indexProgress: Value(indexProgress),
      uploadedAt: Value(uploadedAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory KnowledgeDocumentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeDocumentsTableData(
      id: serializer.fromJson<String>(json['id']),
      knowledgeBaseId: serializer.fromJson<String>(json['knowledgeBaseId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      size: serializer.fromJson<int>(json['size']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      chunks: serializer.fromJson<int>(json['chunks']),
      status: serializer.fromJson<String>(json['status']),
      indexProgress: serializer.fromJson<double>(json['indexProgress']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'knowledgeBaseId': serializer.toJson<String>(knowledgeBaseId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'size': serializer.toJson<int>(size),
      'filePath': serializer.toJson<String>(filePath),
      'fileHash': serializer.toJson<String>(fileHash),
      'chunks': serializer.toJson<int>(chunks),
      'status': serializer.toJson<String>(status),
      'indexProgress': serializer.toJson<double>(indexProgress),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
      'metadata': serializer.toJson<String?>(metadata),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  KnowledgeDocumentsTableData copyWith(
          {String? id,
          String? knowledgeBaseId,
          String? name,
          String? type,
          int? size,
          String? filePath,
          String? fileHash,
          int? chunks,
          String? status,
          double? indexProgress,
          DateTime? uploadedAt,
          Value<DateTime?> processedAt = const Value.absent(),
          Value<String?> metadata = const Value.absent(),
          Value<String?> errorMessage = const Value.absent()}) =>
      KnowledgeDocumentsTableData(
        id: id ?? this.id,
        knowledgeBaseId: knowledgeBaseId ?? this.knowledgeBaseId,
        name: name ?? this.name,
        type: type ?? this.type,
        size: size ?? this.size,
        filePath: filePath ?? this.filePath,
        fileHash: fileHash ?? this.fileHash,
        chunks: chunks ?? this.chunks,
        status: status ?? this.status,
        indexProgress: indexProgress ?? this.indexProgress,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        processedAt: processedAt.present ? processedAt.value : this.processedAt,
        metadata: metadata.present ? metadata.value : this.metadata,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
      );
  KnowledgeDocumentsTableData copyWithCompanion(
      KnowledgeDocumentsTableCompanion data) {
    return KnowledgeDocumentsTableData(
      id: data.id.present ? data.id.value : this.id,
      knowledgeBaseId: data.knowledgeBaseId.present
          ? data.knowledgeBaseId.value
          : this.knowledgeBaseId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      size: data.size.present ? data.size.value : this.size,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      chunks: data.chunks.present ? data.chunks.value : this.chunks,
      status: data.status.present ? data.status.value : this.status,
      indexProgress: data.indexProgress.present
          ? data.indexProgress.value
          : this.indexProgress,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
      processedAt:
          data.processedAt.present ? data.processedAt.value : this.processedAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeDocumentsTableData(')
          ..write('id: $id, ')
          ..write('knowledgeBaseId: $knowledgeBaseId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('size: $size, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('chunks: $chunks, ')
          ..write('status: $status, ')
          ..write('indexProgress: $indexProgress, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('metadata: $metadata, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      knowledgeBaseId,
      name,
      type,
      size,
      filePath,
      fileHash,
      chunks,
      status,
      indexProgress,
      uploadedAt,
      processedAt,
      metadata,
      errorMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeDocumentsTableData &&
          other.id == this.id &&
          other.knowledgeBaseId == this.knowledgeBaseId &&
          other.name == this.name &&
          other.type == this.type &&
          other.size == this.size &&
          other.filePath == this.filePath &&
          other.fileHash == this.fileHash &&
          other.chunks == this.chunks &&
          other.status == this.status &&
          other.indexProgress == this.indexProgress &&
          other.uploadedAt == this.uploadedAt &&
          other.processedAt == this.processedAt &&
          other.metadata == this.metadata &&
          other.errorMessage == this.errorMessage);
}

class KnowledgeDocumentsTableCompanion
    extends UpdateCompanion<KnowledgeDocumentsTableData> {
  final Value<String> id;
  final Value<String> knowledgeBaseId;
  final Value<String> name;
  final Value<String> type;
  final Value<int> size;
  final Value<String> filePath;
  final Value<String> fileHash;
  final Value<int> chunks;
  final Value<String> status;
  final Value<double> indexProgress;
  final Value<DateTime> uploadedAt;
  final Value<DateTime?> processedAt;
  final Value<String?> metadata;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const KnowledgeDocumentsTableCompanion({
    this.id = const Value.absent(),
    this.knowledgeBaseId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.size = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.chunks = const Value.absent(),
    this.status = const Value.absent(),
    this.indexProgress = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeDocumentsTableCompanion.insert({
    required String id,
    required String knowledgeBaseId,
    required String name,
    required String type,
    required int size,
    required String filePath,
    required String fileHash,
    this.chunks = const Value.absent(),
    this.status = const Value.absent(),
    this.indexProgress = const Value.absent(),
    required DateTime uploadedAt,
    this.processedAt = const Value.absent(),
    this.metadata = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        knowledgeBaseId = Value(knowledgeBaseId),
        name = Value(name),
        type = Value(type),
        size = Value(size),
        filePath = Value(filePath),
        fileHash = Value(fileHash),
        uploadedAt = Value(uploadedAt);
  static Insertable<KnowledgeDocumentsTableData> custom({
    Expression<String>? id,
    Expression<String>? knowledgeBaseId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? size,
    Expression<String>? filePath,
    Expression<String>? fileHash,
    Expression<int>? chunks,
    Expression<String>? status,
    Expression<double>? indexProgress,
    Expression<DateTime>? uploadedAt,
    Expression<DateTime>? processedAt,
    Expression<String>? metadata,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeBaseId != null) 'knowledge_base_id': knowledgeBaseId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (size != null) 'size': size,
      if (filePath != null) 'file_path': filePath,
      if (fileHash != null) 'file_hash': fileHash,
      if (chunks != null) 'chunks': chunks,
      if (status != null) 'status': status,
      if (indexProgress != null) 'index_progress': indexProgress,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (processedAt != null) 'processed_at': processedAt,
      if (metadata != null) 'metadata': metadata,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeDocumentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? knowledgeBaseId,
      Value<String>? name,
      Value<String>? type,
      Value<int>? size,
      Value<String>? filePath,
      Value<String>? fileHash,
      Value<int>? chunks,
      Value<String>? status,
      Value<double>? indexProgress,
      Value<DateTime>? uploadedAt,
      Value<DateTime?>? processedAt,
      Value<String?>? metadata,
      Value<String?>? errorMessage,
      Value<int>? rowid}) {
    return KnowledgeDocumentsTableCompanion(
      id: id ?? this.id,
      knowledgeBaseId: knowledgeBaseId ?? this.knowledgeBaseId,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      chunks: chunks ?? this.chunks,
      status: status ?? this.status,
      indexProgress: indexProgress ?? this.indexProgress,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      processedAt: processedAt ?? this.processedAt,
      metadata: metadata ?? this.metadata,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (knowledgeBaseId.present) {
      map['knowledge_base_id'] = Variable<String>(knowledgeBaseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (chunks.present) {
      map['chunks'] = Variable<int>(chunks.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (indexProgress.present) {
      map['index_progress'] = Variable<double>(indexProgress.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeDocumentsTableCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeBaseId: $knowledgeBaseId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('size: $size, ')
          ..write('filePath: $filePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('chunks: $chunks, ')
          ..write('status: $status, ')
          ..write('indexProgress: $indexProgress, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('metadata: $metadata, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeChunksTableTable extends KnowledgeChunksTable
    with TableInfo<$KnowledgeChunksTableTable, KnowledgeChunksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeChunksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _knowledgeBaseIdMeta =
      const VerificationMeta('knowledgeBaseId');
  @override
  late final GeneratedColumn<String> knowledgeBaseId = GeneratedColumn<String>(
      'knowledge_base_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
      'document_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chunkIndexMeta =
      const VerificationMeta('chunkIndex');
  @override
  late final GeneratedColumn<int> chunkIndex = GeneratedColumn<int>(
      'chunk_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _characterCountMeta =
      const VerificationMeta('characterCount');
  @override
  late final GeneratedColumn<int> characterCount = GeneratedColumn<int>(
      'character_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tokenCountMeta =
      const VerificationMeta('tokenCount');
  @override
  late final GeneratedColumn<int> tokenCount = GeneratedColumn<int>(
      'token_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _embeddingMeta =
      const VerificationMeta('embedding');
  @override
  late final GeneratedColumn<String> embedding = GeneratedColumn<String>(
      'embedding', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        knowledgeBaseId,
        documentId,
        content,
        chunkIndex,
        characterCount,
        tokenCount,
        embedding,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_chunks_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeChunksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('knowledge_base_id')) {
      context.handle(
          _knowledgeBaseIdMeta,
          knowledgeBaseId.isAcceptableOrUnknown(
              data['knowledge_base_id']!, _knowledgeBaseIdMeta));
    } else if (isInserting) {
      context.missing(_knowledgeBaseIdMeta);
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('chunk_index')) {
      context.handle(
          _chunkIndexMeta,
          chunkIndex.isAcceptableOrUnknown(
              data['chunk_index']!, _chunkIndexMeta));
    } else if (isInserting) {
      context.missing(_chunkIndexMeta);
    }
    if (data.containsKey('character_count')) {
      context.handle(
          _characterCountMeta,
          characterCount.isAcceptableOrUnknown(
              data['character_count']!, _characterCountMeta));
    } else if (isInserting) {
      context.missing(_characterCountMeta);
    }
    if (data.containsKey('token_count')) {
      context.handle(
          _tokenCountMeta,
          tokenCount.isAcceptableOrUnknown(
              data['token_count']!, _tokenCountMeta));
    } else if (isInserting) {
      context.missing(_tokenCountMeta);
    }
    if (data.containsKey('embedding')) {
      context.handle(_embeddingMeta,
          embedding.isAcceptableOrUnknown(data['embedding']!, _embeddingMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeChunksTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeChunksTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      knowledgeBaseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}knowledge_base_id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      chunkIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunk_index'])!,
      characterCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}character_count'])!,
      tokenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}token_count'])!,
      embedding: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}embedding']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $KnowledgeChunksTableTable createAlias(String alias) {
    return $KnowledgeChunksTableTable(attachedDatabase, alias);
  }
}

class KnowledgeChunksTableData extends DataClass
    implements Insertable<KnowledgeChunksTableData> {
  /// 文本块唯一标识符
  final String id;

  /// 所属知识库ID（引用knowledge_bases_table.id）
  final String knowledgeBaseId;

  /// 所属文档ID
  final String documentId;

  /// 文本块内容
  final String content;

  /// 文本块在文档中的序号
  final int chunkIndex;

  /// 文本块的字符数
  final int characterCount;

  /// 文本块的token数
  final int tokenCount;

  /// 嵌入向量（JSON格式存储）
  final String? embedding;

  /// 创建时间
  final DateTime createdAt;
  const KnowledgeChunksTableData(
      {required this.id,
      required this.knowledgeBaseId,
      required this.documentId,
      required this.content,
      required this.chunkIndex,
      required this.characterCount,
      required this.tokenCount,
      this.embedding,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['knowledge_base_id'] = Variable<String>(knowledgeBaseId);
    map['document_id'] = Variable<String>(documentId);
    map['content'] = Variable<String>(content);
    map['chunk_index'] = Variable<int>(chunkIndex);
    map['character_count'] = Variable<int>(characterCount);
    map['token_count'] = Variable<int>(tokenCount);
    if (!nullToAbsent || embedding != null) {
      map['embedding'] = Variable<String>(embedding);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  KnowledgeChunksTableCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeChunksTableCompanion(
      id: Value(id),
      knowledgeBaseId: Value(knowledgeBaseId),
      documentId: Value(documentId),
      content: Value(content),
      chunkIndex: Value(chunkIndex),
      characterCount: Value(characterCount),
      tokenCount: Value(tokenCount),
      embedding: embedding == null && nullToAbsent
          ? const Value.absent()
          : Value(embedding),
      createdAt: Value(createdAt),
    );
  }

  factory KnowledgeChunksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeChunksTableData(
      id: serializer.fromJson<String>(json['id']),
      knowledgeBaseId: serializer.fromJson<String>(json['knowledgeBaseId']),
      documentId: serializer.fromJson<String>(json['documentId']),
      content: serializer.fromJson<String>(json['content']),
      chunkIndex: serializer.fromJson<int>(json['chunkIndex']),
      characterCount: serializer.fromJson<int>(json['characterCount']),
      tokenCount: serializer.fromJson<int>(json['tokenCount']),
      embedding: serializer.fromJson<String?>(json['embedding']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'knowledgeBaseId': serializer.toJson<String>(knowledgeBaseId),
      'documentId': serializer.toJson<String>(documentId),
      'content': serializer.toJson<String>(content),
      'chunkIndex': serializer.toJson<int>(chunkIndex),
      'characterCount': serializer.toJson<int>(characterCount),
      'tokenCount': serializer.toJson<int>(tokenCount),
      'embedding': serializer.toJson<String?>(embedding),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  KnowledgeChunksTableData copyWith(
          {String? id,
          String? knowledgeBaseId,
          String? documentId,
          String? content,
          int? chunkIndex,
          int? characterCount,
          int? tokenCount,
          Value<String?> embedding = const Value.absent(),
          DateTime? createdAt}) =>
      KnowledgeChunksTableData(
        id: id ?? this.id,
        knowledgeBaseId: knowledgeBaseId ?? this.knowledgeBaseId,
        documentId: documentId ?? this.documentId,
        content: content ?? this.content,
        chunkIndex: chunkIndex ?? this.chunkIndex,
        characterCount: characterCount ?? this.characterCount,
        tokenCount: tokenCount ?? this.tokenCount,
        embedding: embedding.present ? embedding.value : this.embedding,
        createdAt: createdAt ?? this.createdAt,
      );
  KnowledgeChunksTableData copyWithCompanion(
      KnowledgeChunksTableCompanion data) {
    return KnowledgeChunksTableData(
      id: data.id.present ? data.id.value : this.id,
      knowledgeBaseId: data.knowledgeBaseId.present
          ? data.knowledgeBaseId.value
          : this.knowledgeBaseId,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      content: data.content.present ? data.content.value : this.content,
      chunkIndex:
          data.chunkIndex.present ? data.chunkIndex.value : this.chunkIndex,
      characterCount: data.characterCount.present
          ? data.characterCount.value
          : this.characterCount,
      tokenCount:
          data.tokenCount.present ? data.tokenCount.value : this.tokenCount,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeChunksTableData(')
          ..write('id: $id, ')
          ..write('knowledgeBaseId: $knowledgeBaseId, ')
          ..write('documentId: $documentId, ')
          ..write('content: $content, ')
          ..write('chunkIndex: $chunkIndex, ')
          ..write('characterCount: $characterCount, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('embedding: $embedding, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, knowledgeBaseId, documentId, content,
      chunkIndex, characterCount, tokenCount, embedding, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeChunksTableData &&
          other.id == this.id &&
          other.knowledgeBaseId == this.knowledgeBaseId &&
          other.documentId == this.documentId &&
          other.content == this.content &&
          other.chunkIndex == this.chunkIndex &&
          other.characterCount == this.characterCount &&
          other.tokenCount == this.tokenCount &&
          other.embedding == this.embedding &&
          other.createdAt == this.createdAt);
}

class KnowledgeChunksTableCompanion
    extends UpdateCompanion<KnowledgeChunksTableData> {
  final Value<String> id;
  final Value<String> knowledgeBaseId;
  final Value<String> documentId;
  final Value<String> content;
  final Value<int> chunkIndex;
  final Value<int> characterCount;
  final Value<int> tokenCount;
  final Value<String?> embedding;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const KnowledgeChunksTableCompanion({
    this.id = const Value.absent(),
    this.knowledgeBaseId = const Value.absent(),
    this.documentId = const Value.absent(),
    this.content = const Value.absent(),
    this.chunkIndex = const Value.absent(),
    this.characterCount = const Value.absent(),
    this.tokenCount = const Value.absent(),
    this.embedding = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeChunksTableCompanion.insert({
    required String id,
    required String knowledgeBaseId,
    required String documentId,
    required String content,
    required int chunkIndex,
    required int characterCount,
    required int tokenCount,
    this.embedding = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        knowledgeBaseId = Value(knowledgeBaseId),
        documentId = Value(documentId),
        content = Value(content),
        chunkIndex = Value(chunkIndex),
        characterCount = Value(characterCount),
        tokenCount = Value(tokenCount),
        createdAt = Value(createdAt);
  static Insertable<KnowledgeChunksTableData> custom({
    Expression<String>? id,
    Expression<String>? knowledgeBaseId,
    Expression<String>? documentId,
    Expression<String>? content,
    Expression<int>? chunkIndex,
    Expression<int>? characterCount,
    Expression<int>? tokenCount,
    Expression<String>? embedding,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (knowledgeBaseId != null) 'knowledge_base_id': knowledgeBaseId,
      if (documentId != null) 'document_id': documentId,
      if (content != null) 'content': content,
      if (chunkIndex != null) 'chunk_index': chunkIndex,
      if (characterCount != null) 'character_count': characterCount,
      if (tokenCount != null) 'token_count': tokenCount,
      if (embedding != null) 'embedding': embedding,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeChunksTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? knowledgeBaseId,
      Value<String>? documentId,
      Value<String>? content,
      Value<int>? chunkIndex,
      Value<int>? characterCount,
      Value<int>? tokenCount,
      Value<String?>? embedding,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return KnowledgeChunksTableCompanion(
      id: id ?? this.id,
      knowledgeBaseId: knowledgeBaseId ?? this.knowledgeBaseId,
      documentId: documentId ?? this.documentId,
      content: content ?? this.content,
      chunkIndex: chunkIndex ?? this.chunkIndex,
      characterCount: characterCount ?? this.characterCount,
      tokenCount: tokenCount ?? this.tokenCount,
      embedding: embedding ?? this.embedding,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (knowledgeBaseId.present) {
      map['knowledge_base_id'] = Variable<String>(knowledgeBaseId.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (chunkIndex.present) {
      map['chunk_index'] = Variable<int>(chunkIndex.value);
    }
    if (characterCount.present) {
      map['character_count'] = Variable<int>(characterCount.value);
    }
    if (tokenCount.present) {
      map['token_count'] = Variable<int>(tokenCount.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<String>(embedding.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeChunksTableCompanion(')
          ..write('id: $id, ')
          ..write('knowledgeBaseId: $knowledgeBaseId, ')
          ..write('documentId: $documentId, ')
          ..write('content: $content, ')
          ..write('chunkIndex: $chunkIndex, ')
          ..write('characterCount: $characterCount, ')
          ..write('tokenCount: $tokenCount, ')
          ..write('embedding: $embedding, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnowledgeBaseConfigsTableTable extends KnowledgeBaseConfigsTable
    with
        TableInfo<$KnowledgeBaseConfigsTableTable,
            KnowledgeBaseConfigsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnowledgeBaseConfigsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _embeddingModelIdMeta =
      const VerificationMeta('embeddingModelId');
  @override
  late final GeneratedColumn<String> embeddingModelId = GeneratedColumn<String>(
      'embedding_model_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _embeddingModelNameMeta =
      const VerificationMeta('embeddingModelName');
  @override
  late final GeneratedColumn<String> embeddingModelName =
      GeneratedColumn<String>('embedding_model_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _embeddingModelProviderMeta =
      const VerificationMeta('embeddingModelProvider');
  @override
  late final GeneratedColumn<String> embeddingModelProvider =
      GeneratedColumn<String>('embedding_model_provider', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _embeddingDimensionMeta =
      const VerificationMeta('embeddingDimension');
  @override
  late final GeneratedColumn<int> embeddingDimension = GeneratedColumn<int>(
      'embedding_dimension', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _chunkSizeMeta =
      const VerificationMeta('chunkSize');
  @override
  late final GeneratedColumn<int> chunkSize = GeneratedColumn<int>(
      'chunk_size', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _chunkOverlapMeta =
      const VerificationMeta('chunkOverlap');
  @override
  late final GeneratedColumn<int> chunkOverlap = GeneratedColumn<int>(
      'chunk_overlap', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(200));
  static const VerificationMeta _maxRetrievedChunksMeta =
      const VerificationMeta('maxRetrievedChunks');
  @override
  late final GeneratedColumn<int> maxRetrievedChunks = GeneratedColumn<int>(
      'max_retrieved_chunks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _similarityThresholdMeta =
      const VerificationMeta('similarityThreshold');
  @override
  late final GeneratedColumn<double> similarityThreshold =
      GeneratedColumn<double>('similarity_threshold', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.3));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        embeddingModelId,
        embeddingModelName,
        embeddingModelProvider,
        embeddingDimension,
        chunkSize,
        chunkOverlap,
        maxRetrievedChunks,
        similarityThreshold,
        isDefault,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'knowledge_base_configs_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<KnowledgeBaseConfigsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('embedding_model_id')) {
      context.handle(
          _embeddingModelIdMeta,
          embeddingModelId.isAcceptableOrUnknown(
              data['embedding_model_id']!, _embeddingModelIdMeta));
    } else if (isInserting) {
      context.missing(_embeddingModelIdMeta);
    }
    if (data.containsKey('embedding_model_name')) {
      context.handle(
          _embeddingModelNameMeta,
          embeddingModelName.isAcceptableOrUnknown(
              data['embedding_model_name']!, _embeddingModelNameMeta));
    } else if (isInserting) {
      context.missing(_embeddingModelNameMeta);
    }
    if (data.containsKey('embedding_model_provider')) {
      context.handle(
          _embeddingModelProviderMeta,
          embeddingModelProvider.isAcceptableOrUnknown(
              data['embedding_model_provider']!, _embeddingModelProviderMeta));
    } else if (isInserting) {
      context.missing(_embeddingModelProviderMeta);
    }
    if (data.containsKey('embedding_dimension')) {
      context.handle(
          _embeddingDimensionMeta,
          embeddingDimension.isAcceptableOrUnknown(
              data['embedding_dimension']!, _embeddingDimensionMeta));
    }
    if (data.containsKey('chunk_size')) {
      context.handle(_chunkSizeMeta,
          chunkSize.isAcceptableOrUnknown(data['chunk_size']!, _chunkSizeMeta));
    }
    if (data.containsKey('chunk_overlap')) {
      context.handle(
          _chunkOverlapMeta,
          chunkOverlap.isAcceptableOrUnknown(
              data['chunk_overlap']!, _chunkOverlapMeta));
    }
    if (data.containsKey('max_retrieved_chunks')) {
      context.handle(
          _maxRetrievedChunksMeta,
          maxRetrievedChunks.isAcceptableOrUnknown(
              data['max_retrieved_chunks']!, _maxRetrievedChunksMeta));
    }
    if (data.containsKey('similarity_threshold')) {
      context.handle(
          _similarityThresholdMeta,
          similarityThreshold.isAcceptableOrUnknown(
              data['similarity_threshold']!, _similarityThresholdMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnowledgeBaseConfigsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnowledgeBaseConfigsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      embeddingModelId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}embedding_model_id'])!,
      embeddingModelName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}embedding_model_name'])!,
      embeddingModelProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}embedding_model_provider'])!,
      embeddingDimension: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}embedding_dimension']),
      chunkSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunk_size'])!,
      chunkOverlap: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunk_overlap'])!,
      maxRetrievedChunks: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}max_retrieved_chunks'])!,
      similarityThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}similarity_threshold'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $KnowledgeBaseConfigsTableTable createAlias(String alias) {
    return $KnowledgeBaseConfigsTableTable(attachedDatabase, alias);
  }
}

class KnowledgeBaseConfigsTableData extends DataClass
    implements Insertable<KnowledgeBaseConfigsTableData> {
  /// 配置唯一标识符
  final String id;

  /// 配置名称
  final String name;

  /// 嵌入模型ID
  final String embeddingModelId;

  /// 嵌入模型名称
  final String embeddingModelName;

  /// 嵌入模型提供商
  final String embeddingModelProvider;

  /// 嵌入向量维度
  final int? embeddingDimension;

  /// 分块大小
  final int chunkSize;

  /// 分块重叠
  final int chunkOverlap;

  /// 最大检索结果数
  final int maxRetrievedChunks;

  /// 相似度阈值
  final double similarityThreshold;

  /// 是否为默认配置
  final bool isDefault;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const KnowledgeBaseConfigsTableData(
      {required this.id,
      required this.name,
      required this.embeddingModelId,
      required this.embeddingModelName,
      required this.embeddingModelProvider,
      this.embeddingDimension,
      required this.chunkSize,
      required this.chunkOverlap,
      required this.maxRetrievedChunks,
      required this.similarityThreshold,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['embedding_model_id'] = Variable<String>(embeddingModelId);
    map['embedding_model_name'] = Variable<String>(embeddingModelName);
    map['embedding_model_provider'] = Variable<String>(embeddingModelProvider);
    if (!nullToAbsent || embeddingDimension != null) {
      map['embedding_dimension'] = Variable<int>(embeddingDimension);
    }
    map['chunk_size'] = Variable<int>(chunkSize);
    map['chunk_overlap'] = Variable<int>(chunkOverlap);
    map['max_retrieved_chunks'] = Variable<int>(maxRetrievedChunks);
    map['similarity_threshold'] = Variable<double>(similarityThreshold);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KnowledgeBaseConfigsTableCompanion toCompanion(bool nullToAbsent) {
    return KnowledgeBaseConfigsTableCompanion(
      id: Value(id),
      name: Value(name),
      embeddingModelId: Value(embeddingModelId),
      embeddingModelName: Value(embeddingModelName),
      embeddingModelProvider: Value(embeddingModelProvider),
      embeddingDimension: embeddingDimension == null && nullToAbsent
          ? const Value.absent()
          : Value(embeddingDimension),
      chunkSize: Value(chunkSize),
      chunkOverlap: Value(chunkOverlap),
      maxRetrievedChunks: Value(maxRetrievedChunks),
      similarityThreshold: Value(similarityThreshold),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KnowledgeBaseConfigsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnowledgeBaseConfigsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      embeddingModelId: serializer.fromJson<String>(json['embeddingModelId']),
      embeddingModelName:
          serializer.fromJson<String>(json['embeddingModelName']),
      embeddingModelProvider:
          serializer.fromJson<String>(json['embeddingModelProvider']),
      embeddingDimension: serializer.fromJson<int?>(json['embeddingDimension']),
      chunkSize: serializer.fromJson<int>(json['chunkSize']),
      chunkOverlap: serializer.fromJson<int>(json['chunkOverlap']),
      maxRetrievedChunks: serializer.fromJson<int>(json['maxRetrievedChunks']),
      similarityThreshold:
          serializer.fromJson<double>(json['similarityThreshold']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'embeddingModelId': serializer.toJson<String>(embeddingModelId),
      'embeddingModelName': serializer.toJson<String>(embeddingModelName),
      'embeddingModelProvider':
          serializer.toJson<String>(embeddingModelProvider),
      'embeddingDimension': serializer.toJson<int?>(embeddingDimension),
      'chunkSize': serializer.toJson<int>(chunkSize),
      'chunkOverlap': serializer.toJson<int>(chunkOverlap),
      'maxRetrievedChunks': serializer.toJson<int>(maxRetrievedChunks),
      'similarityThreshold': serializer.toJson<double>(similarityThreshold),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KnowledgeBaseConfigsTableData copyWith(
          {String? id,
          String? name,
          String? embeddingModelId,
          String? embeddingModelName,
          String? embeddingModelProvider,
          Value<int?> embeddingDimension = const Value.absent(),
          int? chunkSize,
          int? chunkOverlap,
          int? maxRetrievedChunks,
          double? similarityThreshold,
          bool? isDefault,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      KnowledgeBaseConfigsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        embeddingModelId: embeddingModelId ?? this.embeddingModelId,
        embeddingModelName: embeddingModelName ?? this.embeddingModelName,
        embeddingModelProvider:
            embeddingModelProvider ?? this.embeddingModelProvider,
        embeddingDimension: embeddingDimension.present
            ? embeddingDimension.value
            : this.embeddingDimension,
        chunkSize: chunkSize ?? this.chunkSize,
        chunkOverlap: chunkOverlap ?? this.chunkOverlap,
        maxRetrievedChunks: maxRetrievedChunks ?? this.maxRetrievedChunks,
        similarityThreshold: similarityThreshold ?? this.similarityThreshold,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  KnowledgeBaseConfigsTableData copyWithCompanion(
      KnowledgeBaseConfigsTableCompanion data) {
    return KnowledgeBaseConfigsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      embeddingModelId: data.embeddingModelId.present
          ? data.embeddingModelId.value
          : this.embeddingModelId,
      embeddingModelName: data.embeddingModelName.present
          ? data.embeddingModelName.value
          : this.embeddingModelName,
      embeddingModelProvider: data.embeddingModelProvider.present
          ? data.embeddingModelProvider.value
          : this.embeddingModelProvider,
      embeddingDimension: data.embeddingDimension.present
          ? data.embeddingDimension.value
          : this.embeddingDimension,
      chunkSize: data.chunkSize.present ? data.chunkSize.value : this.chunkSize,
      chunkOverlap: data.chunkOverlap.present
          ? data.chunkOverlap.value
          : this.chunkOverlap,
      maxRetrievedChunks: data.maxRetrievedChunks.present
          ? data.maxRetrievedChunks.value
          : this.maxRetrievedChunks,
      similarityThreshold: data.similarityThreshold.present
          ? data.similarityThreshold.value
          : this.similarityThreshold,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeBaseConfigsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('embeddingModelId: $embeddingModelId, ')
          ..write('embeddingModelName: $embeddingModelName, ')
          ..write('embeddingModelProvider: $embeddingModelProvider, ')
          ..write('embeddingDimension: $embeddingDimension, ')
          ..write('chunkSize: $chunkSize, ')
          ..write('chunkOverlap: $chunkOverlap, ')
          ..write('maxRetrievedChunks: $maxRetrievedChunks, ')
          ..write('similarityThreshold: $similarityThreshold, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      embeddingModelId,
      embeddingModelName,
      embeddingModelProvider,
      embeddingDimension,
      chunkSize,
      chunkOverlap,
      maxRetrievedChunks,
      similarityThreshold,
      isDefault,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnowledgeBaseConfigsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.embeddingModelId == this.embeddingModelId &&
          other.embeddingModelName == this.embeddingModelName &&
          other.embeddingModelProvider == this.embeddingModelProvider &&
          other.embeddingDimension == this.embeddingDimension &&
          other.chunkSize == this.chunkSize &&
          other.chunkOverlap == this.chunkOverlap &&
          other.maxRetrievedChunks == this.maxRetrievedChunks &&
          other.similarityThreshold == this.similarityThreshold &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KnowledgeBaseConfigsTableCompanion
    extends UpdateCompanion<KnowledgeBaseConfigsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> embeddingModelId;
  final Value<String> embeddingModelName;
  final Value<String> embeddingModelProvider;
  final Value<int?> embeddingDimension;
  final Value<int> chunkSize;
  final Value<int> chunkOverlap;
  final Value<int> maxRetrievedChunks;
  final Value<double> similarityThreshold;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KnowledgeBaseConfigsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.embeddingModelId = const Value.absent(),
    this.embeddingModelName = const Value.absent(),
    this.embeddingModelProvider = const Value.absent(),
    this.embeddingDimension = const Value.absent(),
    this.chunkSize = const Value.absent(),
    this.chunkOverlap = const Value.absent(),
    this.maxRetrievedChunks = const Value.absent(),
    this.similarityThreshold = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnowledgeBaseConfigsTableCompanion.insert({
    required String id,
    required String name,
    required String embeddingModelId,
    required String embeddingModelName,
    required String embeddingModelProvider,
    this.embeddingDimension = const Value.absent(),
    this.chunkSize = const Value.absent(),
    this.chunkOverlap = const Value.absent(),
    this.maxRetrievedChunks = const Value.absent(),
    this.similarityThreshold = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        embeddingModelId = Value(embeddingModelId),
        embeddingModelName = Value(embeddingModelName),
        embeddingModelProvider = Value(embeddingModelProvider),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<KnowledgeBaseConfigsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? embeddingModelId,
    Expression<String>? embeddingModelName,
    Expression<String>? embeddingModelProvider,
    Expression<int>? embeddingDimension,
    Expression<int>? chunkSize,
    Expression<int>? chunkOverlap,
    Expression<int>? maxRetrievedChunks,
    Expression<double>? similarityThreshold,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (embeddingModelId != null) 'embedding_model_id': embeddingModelId,
      if (embeddingModelName != null)
        'embedding_model_name': embeddingModelName,
      if (embeddingModelProvider != null)
        'embedding_model_provider': embeddingModelProvider,
      if (embeddingDimension != null) 'embedding_dimension': embeddingDimension,
      if (chunkSize != null) 'chunk_size': chunkSize,
      if (chunkOverlap != null) 'chunk_overlap': chunkOverlap,
      if (maxRetrievedChunks != null)
        'max_retrieved_chunks': maxRetrievedChunks,
      if (similarityThreshold != null)
        'similarity_threshold': similarityThreshold,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnowledgeBaseConfigsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? embeddingModelId,
      Value<String>? embeddingModelName,
      Value<String>? embeddingModelProvider,
      Value<int?>? embeddingDimension,
      Value<int>? chunkSize,
      Value<int>? chunkOverlap,
      Value<int>? maxRetrievedChunks,
      Value<double>? similarityThreshold,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return KnowledgeBaseConfigsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      embeddingModelId: embeddingModelId ?? this.embeddingModelId,
      embeddingModelName: embeddingModelName ?? this.embeddingModelName,
      embeddingModelProvider:
          embeddingModelProvider ?? this.embeddingModelProvider,
      embeddingDimension: embeddingDimension ?? this.embeddingDimension,
      chunkSize: chunkSize ?? this.chunkSize,
      chunkOverlap: chunkOverlap ?? this.chunkOverlap,
      maxRetrievedChunks: maxRetrievedChunks ?? this.maxRetrievedChunks,
      similarityThreshold: similarityThreshold ?? this.similarityThreshold,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (embeddingModelId.present) {
      map['embedding_model_id'] = Variable<String>(embeddingModelId.value);
    }
    if (embeddingModelName.present) {
      map['embedding_model_name'] = Variable<String>(embeddingModelName.value);
    }
    if (embeddingModelProvider.present) {
      map['embedding_model_provider'] =
          Variable<String>(embeddingModelProvider.value);
    }
    if (embeddingDimension.present) {
      map['embedding_dimension'] = Variable<int>(embeddingDimension.value);
    }
    if (chunkSize.present) {
      map['chunk_size'] = Variable<int>(chunkSize.value);
    }
    if (chunkOverlap.present) {
      map['chunk_overlap'] = Variable<int>(chunkOverlap.value);
    }
    if (maxRetrievedChunks.present) {
      map['max_retrieved_chunks'] = Variable<int>(maxRetrievedChunks.value);
    }
    if (similarityThreshold.present) {
      map['similarity_threshold'] = Variable<double>(similarityThreshold.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnowledgeBaseConfigsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('embeddingModelId: $embeddingModelId, ')
          ..write('embeddingModelName: $embeddingModelName, ')
          ..write('embeddingModelProvider: $embeddingModelProvider, ')
          ..write('embeddingDimension: $embeddingDimension, ')
          ..write('chunkSize: $chunkSize, ')
          ..write('chunkOverlap: $chunkOverlap, ')
          ..write('maxRetrievedChunks: $maxRetrievedChunks, ')
          ..write('similarityThreshold: $similarityThreshold, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomModelsTableTable extends CustomModelsTable
    with TableInfo<$CustomModelsTableTable, CustomModelsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomModelsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelIdMeta =
      const VerificationMeta('modelId');
  @override
  late final GeneratedColumn<String> modelId = GeneratedColumn<String>(
      'model_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _configIdMeta =
      const VerificationMeta('configId');
  @override
  late final GeneratedColumn<String> configId = GeneratedColumn<String>(
      'config_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contextWindowMeta =
      const VerificationMeta('contextWindow');
  @override
  late final GeneratedColumn<int> contextWindow = GeneratedColumn<int>(
      'context_window', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _maxOutputTokensMeta =
      const VerificationMeta('maxOutputTokens');
  @override
  late final GeneratedColumn<int> maxOutputTokens = GeneratedColumn<int>(
      'max_output_tokens', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _supportsStreamingMeta =
      const VerificationMeta('supportsStreaming');
  @override
  late final GeneratedColumn<bool> supportsStreaming = GeneratedColumn<bool>(
      'supports_streaming', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("supports_streaming" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _supportsFunctionCallingMeta =
      const VerificationMeta('supportsFunctionCalling');
  @override
  late final GeneratedColumn<bool> supportsFunctionCalling =
      GeneratedColumn<bool>('supports_function_calling', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("supports_function_calling" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _supportsVisionMeta =
      const VerificationMeta('supportsVision');
  @override
  late final GeneratedColumn<bool> supportsVision = GeneratedColumn<bool>(
      'supports_vision', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("supports_vision" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _inputPriceMeta =
      const VerificationMeta('inputPrice');
  @override
  late final GeneratedColumn<double> inputPrice = GeneratedColumn<double>(
      'input_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _outputPriceMeta =
      const VerificationMeta('outputPrice');
  @override
  late final GeneratedColumn<double> outputPrice = GeneratedColumn<double>(
      'output_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('USD'));
  static const VerificationMeta _capabilitiesMeta =
      const VerificationMeta('capabilities');
  @override
  late final GeneratedColumn<String> capabilities = GeneratedColumn<String>(
      'capabilities', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isBuiltInMeta =
      const VerificationMeta('isBuiltIn');
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
      'is_built_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_built_in" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        modelId,
        configId,
        provider,
        description,
        type,
        contextWindow,
        maxOutputTokens,
        supportsStreaming,
        supportsFunctionCalling,
        supportsVision,
        inputPrice,
        outputPrice,
        currency,
        capabilities,
        isBuiltIn,
        isEnabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_models_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CustomModelsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('model_id')) {
      context.handle(_modelIdMeta,
          modelId.isAcceptableOrUnknown(data['model_id']!, _modelIdMeta));
    } else if (isInserting) {
      context.missing(_modelIdMeta);
    }
    if (data.containsKey('config_id')) {
      context.handle(_configIdMeta,
          configId.isAcceptableOrUnknown(data['config_id']!, _configIdMeta));
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('context_window')) {
      context.handle(
          _contextWindowMeta,
          contextWindow.isAcceptableOrUnknown(
              data['context_window']!, _contextWindowMeta));
    }
    if (data.containsKey('max_output_tokens')) {
      context.handle(
          _maxOutputTokensMeta,
          maxOutputTokens.isAcceptableOrUnknown(
              data['max_output_tokens']!, _maxOutputTokensMeta));
    }
    if (data.containsKey('supports_streaming')) {
      context.handle(
          _supportsStreamingMeta,
          supportsStreaming.isAcceptableOrUnknown(
              data['supports_streaming']!, _supportsStreamingMeta));
    }
    if (data.containsKey('supports_function_calling')) {
      context.handle(
          _supportsFunctionCallingMeta,
          supportsFunctionCalling.isAcceptableOrUnknown(
              data['supports_function_calling']!,
              _supportsFunctionCallingMeta));
    }
    if (data.containsKey('supports_vision')) {
      context.handle(
          _supportsVisionMeta,
          supportsVision.isAcceptableOrUnknown(
              data['supports_vision']!, _supportsVisionMeta));
    }
    if (data.containsKey('input_price')) {
      context.handle(
          _inputPriceMeta,
          inputPrice.isAcceptableOrUnknown(
              data['input_price']!, _inputPriceMeta));
    }
    if (data.containsKey('output_price')) {
      context.handle(
          _outputPriceMeta,
          outputPrice.isAcceptableOrUnknown(
              data['output_price']!, _outputPriceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('capabilities')) {
      context.handle(
          _capabilitiesMeta,
          capabilities.isAcceptableOrUnknown(
              data['capabilities']!, _capabilitiesMeta));
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
          _isBuiltInMeta,
          isBuiltIn.isAcceptableOrUnknown(
              data['is_built_in']!, _isBuiltInMeta));
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomModelsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomModelsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      modelId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_id'])!,
      configId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config_id']),
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      contextWindow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}context_window']),
      maxOutputTokens: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_output_tokens']),
      supportsStreaming: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}supports_streaming'])!,
      supportsFunctionCalling: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}supports_function_calling'])!,
      supportsVision: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}supports_vision'])!,
      inputPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}input_price']),
      outputPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}output_price']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      capabilities: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}capabilities']),
      isBuiltIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_built_in'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomModelsTableTable createAlias(String alias) {
    return $CustomModelsTableTable(attachedDatabase, alias);
  }
}

class CustomModelsTableData extends DataClass
    implements Insertable<CustomModelsTableData> {
  /// 模型唯一标识符
  final String id;

  /// 模型名称
  final String name;

  /// 模型ID（API调用时使用）
  final String modelId;

  /// 所属 LLM 配置 ID（llm_configs_table.id）
  /// 为空表示旧数据或与具体配置无关
  final String? configId;

  /// 所属提供商 (openai, google, anthropic)
  final String provider;

  /// 模型描述
  final String? description;

  /// 模型类型 (chat, embedding, multimodal)
  final String type;

  /// 上下文窗口大小
  final int? contextWindow;

  /// 最大输出token数
  final int? maxOutputTokens;

  /// 是否支持流式响应
  final bool supportsStreaming;

  /// 是否支持函数调用
  final bool supportsFunctionCalling;

  /// 是否支持视觉输入
  final bool supportsVision;

  /// 输入token价格（每1K token）
  final double? inputPrice;

  /// 输出token价格（每1K token）
  final double? outputPrice;

  /// 货币单位
  final String currency;

  /// 模型能力标签（JSON格式）
  final String? capabilities;

  /// 是否为内置模型
  final bool isBuiltIn;

  /// 是否启用
  final bool isEnabled;

  /// 创建时间
  final DateTime createdAt;

  /// 最后更新时间
  final DateTime updatedAt;
  const CustomModelsTableData(
      {required this.id,
      required this.name,
      required this.modelId,
      this.configId,
      required this.provider,
      this.description,
      required this.type,
      this.contextWindow,
      this.maxOutputTokens,
      required this.supportsStreaming,
      required this.supportsFunctionCalling,
      required this.supportsVision,
      this.inputPrice,
      this.outputPrice,
      required this.currency,
      this.capabilities,
      required this.isBuiltIn,
      required this.isEnabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['model_id'] = Variable<String>(modelId);
    if (!nullToAbsent || configId != null) {
      map['config_id'] = Variable<String>(configId);
    }
    map['provider'] = Variable<String>(provider);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || contextWindow != null) {
      map['context_window'] = Variable<int>(contextWindow);
    }
    if (!nullToAbsent || maxOutputTokens != null) {
      map['max_output_tokens'] = Variable<int>(maxOutputTokens);
    }
    map['supports_streaming'] = Variable<bool>(supportsStreaming);
    map['supports_function_calling'] = Variable<bool>(supportsFunctionCalling);
    map['supports_vision'] = Variable<bool>(supportsVision);
    if (!nullToAbsent || inputPrice != null) {
      map['input_price'] = Variable<double>(inputPrice);
    }
    if (!nullToAbsent || outputPrice != null) {
      map['output_price'] = Variable<double>(outputPrice);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || capabilities != null) {
      map['capabilities'] = Variable<String>(capabilities);
    }
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomModelsTableCompanion toCompanion(bool nullToAbsent) {
    return CustomModelsTableCompanion(
      id: Value(id),
      name: Value(name),
      modelId: Value(modelId),
      configId: configId == null && nullToAbsent
          ? const Value.absent()
          : Value(configId),
      provider: Value(provider),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      contextWindow: contextWindow == null && nullToAbsent
          ? const Value.absent()
          : Value(contextWindow),
      maxOutputTokens: maxOutputTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(maxOutputTokens),
      supportsStreaming: Value(supportsStreaming),
      supportsFunctionCalling: Value(supportsFunctionCalling),
      supportsVision: Value(supportsVision),
      inputPrice: inputPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(inputPrice),
      outputPrice: outputPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(outputPrice),
      currency: Value(currency),
      capabilities: capabilities == null && nullToAbsent
          ? const Value.absent()
          : Value(capabilities),
      isBuiltIn: Value(isBuiltIn),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CustomModelsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomModelsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      modelId: serializer.fromJson<String>(json['modelId']),
      configId: serializer.fromJson<String?>(json['configId']),
      provider: serializer.fromJson<String>(json['provider']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      contextWindow: serializer.fromJson<int?>(json['contextWindow']),
      maxOutputTokens: serializer.fromJson<int?>(json['maxOutputTokens']),
      supportsStreaming: serializer.fromJson<bool>(json['supportsStreaming']),
      supportsFunctionCalling:
          serializer.fromJson<bool>(json['supportsFunctionCalling']),
      supportsVision: serializer.fromJson<bool>(json['supportsVision']),
      inputPrice: serializer.fromJson<double?>(json['inputPrice']),
      outputPrice: serializer.fromJson<double?>(json['outputPrice']),
      currency: serializer.fromJson<String>(json['currency']),
      capabilities: serializer.fromJson<String?>(json['capabilities']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'modelId': serializer.toJson<String>(modelId),
      'configId': serializer.toJson<String?>(configId),
      'provider': serializer.toJson<String>(provider),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'contextWindow': serializer.toJson<int?>(contextWindow),
      'maxOutputTokens': serializer.toJson<int?>(maxOutputTokens),
      'supportsStreaming': serializer.toJson<bool>(supportsStreaming),
      'supportsFunctionCalling':
          serializer.toJson<bool>(supportsFunctionCalling),
      'supportsVision': serializer.toJson<bool>(supportsVision),
      'inputPrice': serializer.toJson<double?>(inputPrice),
      'outputPrice': serializer.toJson<double?>(outputPrice),
      'currency': serializer.toJson<String>(currency),
      'capabilities': serializer.toJson<String?>(capabilities),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CustomModelsTableData copyWith(
          {String? id,
          String? name,
          String? modelId,
          Value<String?> configId = const Value.absent(),
          String? provider,
          Value<String?> description = const Value.absent(),
          String? type,
          Value<int?> contextWindow = const Value.absent(),
          Value<int?> maxOutputTokens = const Value.absent(),
          bool? supportsStreaming,
          bool? supportsFunctionCalling,
          bool? supportsVision,
          Value<double?> inputPrice = const Value.absent(),
          Value<double?> outputPrice = const Value.absent(),
          String? currency,
          Value<String?> capabilities = const Value.absent(),
          bool? isBuiltIn,
          bool? isEnabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CustomModelsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        modelId: modelId ?? this.modelId,
        configId: configId.present ? configId.value : this.configId,
        provider: provider ?? this.provider,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        contextWindow:
            contextWindow.present ? contextWindow.value : this.contextWindow,
        maxOutputTokens: maxOutputTokens.present
            ? maxOutputTokens.value
            : this.maxOutputTokens,
        supportsStreaming: supportsStreaming ?? this.supportsStreaming,
        supportsFunctionCalling:
            supportsFunctionCalling ?? this.supportsFunctionCalling,
        supportsVision: supportsVision ?? this.supportsVision,
        inputPrice: inputPrice.present ? inputPrice.value : this.inputPrice,
        outputPrice: outputPrice.present ? outputPrice.value : this.outputPrice,
        currency: currency ?? this.currency,
        capabilities:
            capabilities.present ? capabilities.value : this.capabilities,
        isBuiltIn: isBuiltIn ?? this.isBuiltIn,
        isEnabled: isEnabled ?? this.isEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CustomModelsTableData copyWithCompanion(CustomModelsTableCompanion data) {
    return CustomModelsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      modelId: data.modelId.present ? data.modelId.value : this.modelId,
      configId: data.configId.present ? data.configId.value : this.configId,
      provider: data.provider.present ? data.provider.value : this.provider,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      contextWindow: data.contextWindow.present
          ? data.contextWindow.value
          : this.contextWindow,
      maxOutputTokens: data.maxOutputTokens.present
          ? data.maxOutputTokens.value
          : this.maxOutputTokens,
      supportsStreaming: data.supportsStreaming.present
          ? data.supportsStreaming.value
          : this.supportsStreaming,
      supportsFunctionCalling: data.supportsFunctionCalling.present
          ? data.supportsFunctionCalling.value
          : this.supportsFunctionCalling,
      supportsVision: data.supportsVision.present
          ? data.supportsVision.value
          : this.supportsVision,
      inputPrice:
          data.inputPrice.present ? data.inputPrice.value : this.inputPrice,
      outputPrice:
          data.outputPrice.present ? data.outputPrice.value : this.outputPrice,
      currency: data.currency.present ? data.currency.value : this.currency,
      capabilities: data.capabilities.present
          ? data.capabilities.value
          : this.capabilities,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomModelsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modelId: $modelId, ')
          ..write('configId: $configId, ')
          ..write('provider: $provider, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('contextWindow: $contextWindow, ')
          ..write('maxOutputTokens: $maxOutputTokens, ')
          ..write('supportsStreaming: $supportsStreaming, ')
          ..write('supportsFunctionCalling: $supportsFunctionCalling, ')
          ..write('supportsVision: $supportsVision, ')
          ..write('inputPrice: $inputPrice, ')
          ..write('outputPrice: $outputPrice, ')
          ..write('currency: $currency, ')
          ..write('capabilities: $capabilities, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      modelId,
      configId,
      provider,
      description,
      type,
      contextWindow,
      maxOutputTokens,
      supportsStreaming,
      supportsFunctionCalling,
      supportsVision,
      inputPrice,
      outputPrice,
      currency,
      capabilities,
      isBuiltIn,
      isEnabled,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomModelsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.modelId == this.modelId &&
          other.configId == this.configId &&
          other.provider == this.provider &&
          other.description == this.description &&
          other.type == this.type &&
          other.contextWindow == this.contextWindow &&
          other.maxOutputTokens == this.maxOutputTokens &&
          other.supportsStreaming == this.supportsStreaming &&
          other.supportsFunctionCalling == this.supportsFunctionCalling &&
          other.supportsVision == this.supportsVision &&
          other.inputPrice == this.inputPrice &&
          other.outputPrice == this.outputPrice &&
          other.currency == this.currency &&
          other.capabilities == this.capabilities &&
          other.isBuiltIn == this.isBuiltIn &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomModelsTableCompanion
    extends UpdateCompanion<CustomModelsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> modelId;
  final Value<String?> configId;
  final Value<String> provider;
  final Value<String?> description;
  final Value<String> type;
  final Value<int?> contextWindow;
  final Value<int?> maxOutputTokens;
  final Value<bool> supportsStreaming;
  final Value<bool> supportsFunctionCalling;
  final Value<bool> supportsVision;
  final Value<double?> inputPrice;
  final Value<double?> outputPrice;
  final Value<String> currency;
  final Value<String?> capabilities;
  final Value<bool> isBuiltIn;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CustomModelsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.modelId = const Value.absent(),
    this.configId = const Value.absent(),
    this.provider = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.contextWindow = const Value.absent(),
    this.maxOutputTokens = const Value.absent(),
    this.supportsStreaming = const Value.absent(),
    this.supportsFunctionCalling = const Value.absent(),
    this.supportsVision = const Value.absent(),
    this.inputPrice = const Value.absent(),
    this.outputPrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.capabilities = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomModelsTableCompanion.insert({
    required String id,
    required String name,
    required String modelId,
    this.configId = const Value.absent(),
    required String provider,
    this.description = const Value.absent(),
    required String type,
    this.contextWindow = const Value.absent(),
    this.maxOutputTokens = const Value.absent(),
    this.supportsStreaming = const Value.absent(),
    this.supportsFunctionCalling = const Value.absent(),
    this.supportsVision = const Value.absent(),
    this.inputPrice = const Value.absent(),
    this.outputPrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.capabilities = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.isEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        modelId = Value(modelId),
        provider = Value(provider),
        type = Value(type),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CustomModelsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? modelId,
    Expression<String>? configId,
    Expression<String>? provider,
    Expression<String>? description,
    Expression<String>? type,
    Expression<int>? contextWindow,
    Expression<int>? maxOutputTokens,
    Expression<bool>? supportsStreaming,
    Expression<bool>? supportsFunctionCalling,
    Expression<bool>? supportsVision,
    Expression<double>? inputPrice,
    Expression<double>? outputPrice,
    Expression<String>? currency,
    Expression<String>? capabilities,
    Expression<bool>? isBuiltIn,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (modelId != null) 'model_id': modelId,
      if (configId != null) 'config_id': configId,
      if (provider != null) 'provider': provider,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (contextWindow != null) 'context_window': contextWindow,
      if (maxOutputTokens != null) 'max_output_tokens': maxOutputTokens,
      if (supportsStreaming != null) 'supports_streaming': supportsStreaming,
      if (supportsFunctionCalling != null)
        'supports_function_calling': supportsFunctionCalling,
      if (supportsVision != null) 'supports_vision': supportsVision,
      if (inputPrice != null) 'input_price': inputPrice,
      if (outputPrice != null) 'output_price': outputPrice,
      if (currency != null) 'currency': currency,
      if (capabilities != null) 'capabilities': capabilities,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomModelsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? modelId,
      Value<String?>? configId,
      Value<String>? provider,
      Value<String?>? description,
      Value<String>? type,
      Value<int?>? contextWindow,
      Value<int?>? maxOutputTokens,
      Value<bool>? supportsStreaming,
      Value<bool>? supportsFunctionCalling,
      Value<bool>? supportsVision,
      Value<double?>? inputPrice,
      Value<double?>? outputPrice,
      Value<String>? currency,
      Value<String?>? capabilities,
      Value<bool>? isBuiltIn,
      Value<bool>? isEnabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CustomModelsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      modelId: modelId ?? this.modelId,
      configId: configId ?? this.configId,
      provider: provider ?? this.provider,
      description: description ?? this.description,
      type: type ?? this.type,
      contextWindow: contextWindow ?? this.contextWindow,
      maxOutputTokens: maxOutputTokens ?? this.maxOutputTokens,
      supportsStreaming: supportsStreaming ?? this.supportsStreaming,
      supportsFunctionCalling:
          supportsFunctionCalling ?? this.supportsFunctionCalling,
      supportsVision: supportsVision ?? this.supportsVision,
      inputPrice: inputPrice ?? this.inputPrice,
      outputPrice: outputPrice ?? this.outputPrice,
      currency: currency ?? this.currency,
      capabilities: capabilities ?? this.capabilities,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (modelId.present) {
      map['model_id'] = Variable<String>(modelId.value);
    }
    if (configId.present) {
      map['config_id'] = Variable<String>(configId.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (contextWindow.present) {
      map['context_window'] = Variable<int>(contextWindow.value);
    }
    if (maxOutputTokens.present) {
      map['max_output_tokens'] = Variable<int>(maxOutputTokens.value);
    }
    if (supportsStreaming.present) {
      map['supports_streaming'] = Variable<bool>(supportsStreaming.value);
    }
    if (supportsFunctionCalling.present) {
      map['supports_function_calling'] =
          Variable<bool>(supportsFunctionCalling.value);
    }
    if (supportsVision.present) {
      map['supports_vision'] = Variable<bool>(supportsVision.value);
    }
    if (inputPrice.present) {
      map['input_price'] = Variable<double>(inputPrice.value);
    }
    if (outputPrice.present) {
      map['output_price'] = Variable<double>(outputPrice.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (capabilities.present) {
      map['capabilities'] = Variable<String>(capabilities.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomModelsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modelId: $modelId, ')
          ..write('configId: $configId, ')
          ..write('provider: $provider, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('contextWindow: $contextWindow, ')
          ..write('maxOutputTokens: $maxOutputTokens, ')
          ..write('supportsStreaming: $supportsStreaming, ')
          ..write('supportsFunctionCalling: $supportsFunctionCalling, ')
          ..write('supportsVision: $supportsVision, ')
          ..write('inputPrice: $inputPrice, ')
          ..write('outputPrice: $outputPrice, ')
          ..write('currency: $currency, ')
          ..write('capabilities: $capabilities, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeneralSettingsTableTable extends GeneralSettingsTable
    with TableInfo<$GeneralSettingsTableTable, GeneralSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneralSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [key, value, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'general_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<GeneralSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  GeneralSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneralSettingsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $GeneralSettingsTableTable createAlias(String alias) {
    return $GeneralSettingsTableTable(attachedDatabase, alias);
  }
}

class GeneralSettingsTableData extends DataClass
    implements Insertable<GeneralSettingsTableData> {
  /// 设置键名（主键）
  final String key;

  /// 设置值（JSON字符串）
  final String value;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const GeneralSettingsTableData(
      {required this.key,
      required this.value,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GeneralSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return GeneralSettingsTableCompanion(
      key: Value(key),
      value: Value(value),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GeneralSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneralSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GeneralSettingsTableData copyWith(
          {String? key,
          String? value,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      GeneralSettingsTableData(
        key: key ?? this.key,
        value: value ?? this.value,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  GeneralSettingsTableData copyWithCompanion(
      GeneralSettingsTableCompanion data) {
    return GeneralSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneralSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneralSettingsTableData &&
          other.key == this.key &&
          other.value == this.value &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GeneralSettingsTableCompanion
    extends UpdateCompanion<GeneralSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GeneralSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeneralSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<GeneralSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeneralSettingsTableCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return GeneralSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneralSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $McpServersTableTable extends McpServersTable
    with TableInfo<$McpServersTableTable, McpServersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McpServersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
      'base_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _headersMeta =
      const VerificationMeta('headers');
  @override
  late final GeneratedColumn<String> headers = GeneratedColumn<String>(
      'headers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeoutMeta =
      const VerificationMeta('timeout');
  @override
  late final GeneratedColumn<int> timeout = GeneratedColumn<int>(
      'timeout', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _longRunningMeta =
      const VerificationMeta('longRunning');
  @override
  late final GeneratedColumn<bool> longRunning = GeneratedColumn<bool>(
      'long_running', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("long_running" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _disabledMeta =
      const VerificationMeta('disabled');
  @override
  late final GeneratedColumn<bool> disabled = GeneratedColumn<bool>(
      'disabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("disabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
      'client_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientSecretMeta =
      const VerificationMeta('clientSecret');
  @override
  late final GeneratedColumn<String> clientSecret = GeneratedColumn<String>(
      'client_secret', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorizationEndpointMeta =
      const VerificationMeta('authorizationEndpoint');
  @override
  late final GeneratedColumn<String> authorizationEndpoint =
      GeneratedColumn<String>('authorization_endpoint', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tokenEndpointMeta =
      const VerificationMeta('tokenEndpoint');
  @override
  late final GeneratedColumn<String> tokenEndpoint = GeneratedColumn<String>(
      'token_endpoint', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isConnectedMeta =
      const VerificationMeta('isConnected');
  @override
  late final GeneratedColumn<bool> isConnected = GeneratedColumn<bool>(
      'is_connected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_connected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastConnectedMeta =
      const VerificationMeta('lastConnected');
  @override
  late final GeneratedColumn<DateTime> lastConnected =
      GeneratedColumn<DateTime>('last_connected', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        baseUrl,
        type,
        headers,
        timeout,
        longRunning,
        disabled,
        error,
        clientId,
        clientSecret,
        authorizationEndpoint,
        tokenEndpoint,
        isConnected,
        lastConnected,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcp_servers';
  @override
  VerificationContext validateIntegrity(
      Insertable<McpServersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(_baseUrlMeta,
          baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta));
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('headers')) {
      context.handle(_headersMeta,
          headers.isAcceptableOrUnknown(data['headers']!, _headersMeta));
    }
    if (data.containsKey('timeout')) {
      context.handle(_timeoutMeta,
          timeout.isAcceptableOrUnknown(data['timeout']!, _timeoutMeta));
    }
    if (data.containsKey('long_running')) {
      context.handle(
          _longRunningMeta,
          longRunning.isAcceptableOrUnknown(
              data['long_running']!, _longRunningMeta));
    }
    if (data.containsKey('disabled')) {
      context.handle(_disabledMeta,
          disabled.isAcceptableOrUnknown(data['disabled']!, _disabledMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    }
    if (data.containsKey('client_secret')) {
      context.handle(
          _clientSecretMeta,
          clientSecret.isAcceptableOrUnknown(
              data['client_secret']!, _clientSecretMeta));
    }
    if (data.containsKey('authorization_endpoint')) {
      context.handle(
          _authorizationEndpointMeta,
          authorizationEndpoint.isAcceptableOrUnknown(
              data['authorization_endpoint']!, _authorizationEndpointMeta));
    }
    if (data.containsKey('token_endpoint')) {
      context.handle(
          _tokenEndpointMeta,
          tokenEndpoint.isAcceptableOrUnknown(
              data['token_endpoint']!, _tokenEndpointMeta));
    }
    if (data.containsKey('is_connected')) {
      context.handle(
          _isConnectedMeta,
          isConnected.isAcceptableOrUnknown(
              data['is_connected']!, _isConnectedMeta));
    }
    if (data.containsKey('last_connected')) {
      context.handle(
          _lastConnectedMeta,
          lastConnected.isAcceptableOrUnknown(
              data['last_connected']!, _lastConnectedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  McpServersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return McpServersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      headers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}headers']),
      timeout: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timeout']),
      longRunning: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}long_running'])!,
      disabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}disabled'])!,
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_id']),
      clientSecret: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_secret']),
      authorizationEndpoint: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}authorization_endpoint']),
      tokenEndpoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_endpoint']),
      isConnected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_connected'])!,
      lastConnected: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_connected']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $McpServersTableTable createAlias(String alias) {
    return $McpServersTableTable(attachedDatabase, alias);
  }
}

class McpServersTableData extends DataClass
    implements Insertable<McpServersTableData> {
  /// 服务器唯一标识
  final String id;

  /// 服务器名称
  final String name;

  /// 服务器基础URL
  final String baseUrl;

  /// 传输协议类型 (sse, streamableHttp)
  final String type;

  /// 自定义HTTP Headers (JSON格式存储)
  final String? headers;

  /// 连接超时时间(秒)
  final int? timeout;

  /// 是否为长时间运行的服务
  final bool longRunning;

  /// 是否禁用
  final bool disabled;

  /// 错误信息
  final String? error;

  /// OAuth客户端ID
  final String? clientId;

  /// OAuth客户端密钥 (加密存储)
  final String? clientSecret;

  /// OAuth授权端点
  final String? authorizationEndpoint;

  /// OAuth Token端点
  final String? tokenEndpoint;

  /// 是否已连接
  final bool isConnected;

  /// 上次连接时间
  final DateTime? lastConnected;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const McpServersTableData(
      {required this.id,
      required this.name,
      required this.baseUrl,
      required this.type,
      this.headers,
      this.timeout,
      required this.longRunning,
      required this.disabled,
      this.error,
      this.clientId,
      this.clientSecret,
      this.authorizationEndpoint,
      this.tokenEndpoint,
      required this.isConnected,
      this.lastConnected,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['base_url'] = Variable<String>(baseUrl);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || headers != null) {
      map['headers'] = Variable<String>(headers);
    }
    if (!nullToAbsent || timeout != null) {
      map['timeout'] = Variable<int>(timeout);
    }
    map['long_running'] = Variable<bool>(longRunning);
    map['disabled'] = Variable<bool>(disabled);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    if (!nullToAbsent || clientSecret != null) {
      map['client_secret'] = Variable<String>(clientSecret);
    }
    if (!nullToAbsent || authorizationEndpoint != null) {
      map['authorization_endpoint'] = Variable<String>(authorizationEndpoint);
    }
    if (!nullToAbsent || tokenEndpoint != null) {
      map['token_endpoint'] = Variable<String>(tokenEndpoint);
    }
    map['is_connected'] = Variable<bool>(isConnected);
    if (!nullToAbsent || lastConnected != null) {
      map['last_connected'] = Variable<DateTime>(lastConnected);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  McpServersTableCompanion toCompanion(bool nullToAbsent) {
    return McpServersTableCompanion(
      id: Value(id),
      name: Value(name),
      baseUrl: Value(baseUrl),
      type: Value(type),
      headers: headers == null && nullToAbsent
          ? const Value.absent()
          : Value(headers),
      timeout: timeout == null && nullToAbsent
          ? const Value.absent()
          : Value(timeout),
      longRunning: Value(longRunning),
      disabled: Value(disabled),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      clientSecret: clientSecret == null && nullToAbsent
          ? const Value.absent()
          : Value(clientSecret),
      authorizationEndpoint: authorizationEndpoint == null && nullToAbsent
          ? const Value.absent()
          : Value(authorizationEndpoint),
      tokenEndpoint: tokenEndpoint == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenEndpoint),
      isConnected: Value(isConnected),
      lastConnected: lastConnected == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnected),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory McpServersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return McpServersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      type: serializer.fromJson<String>(json['type']),
      headers: serializer.fromJson<String?>(json['headers']),
      timeout: serializer.fromJson<int?>(json['timeout']),
      longRunning: serializer.fromJson<bool>(json['longRunning']),
      disabled: serializer.fromJson<bool>(json['disabled']),
      error: serializer.fromJson<String?>(json['error']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      clientSecret: serializer.fromJson<String?>(json['clientSecret']),
      authorizationEndpoint:
          serializer.fromJson<String?>(json['authorizationEndpoint']),
      tokenEndpoint: serializer.fromJson<String?>(json['tokenEndpoint']),
      isConnected: serializer.fromJson<bool>(json['isConnected']),
      lastConnected: serializer.fromJson<DateTime?>(json['lastConnected']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'type': serializer.toJson<String>(type),
      'headers': serializer.toJson<String?>(headers),
      'timeout': serializer.toJson<int?>(timeout),
      'longRunning': serializer.toJson<bool>(longRunning),
      'disabled': serializer.toJson<bool>(disabled),
      'error': serializer.toJson<String?>(error),
      'clientId': serializer.toJson<String?>(clientId),
      'clientSecret': serializer.toJson<String?>(clientSecret),
      'authorizationEndpoint':
          serializer.toJson<String?>(authorizationEndpoint),
      'tokenEndpoint': serializer.toJson<String?>(tokenEndpoint),
      'isConnected': serializer.toJson<bool>(isConnected),
      'lastConnected': serializer.toJson<DateTime?>(lastConnected),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  McpServersTableData copyWith(
          {String? id,
          String? name,
          String? baseUrl,
          String? type,
          Value<String?> headers = const Value.absent(),
          Value<int?> timeout = const Value.absent(),
          bool? longRunning,
          bool? disabled,
          Value<String?> error = const Value.absent(),
          Value<String?> clientId = const Value.absent(),
          Value<String?> clientSecret = const Value.absent(),
          Value<String?> authorizationEndpoint = const Value.absent(),
          Value<String?> tokenEndpoint = const Value.absent(),
          bool? isConnected,
          Value<DateTime?> lastConnected = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      McpServersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        baseUrl: baseUrl ?? this.baseUrl,
        type: type ?? this.type,
        headers: headers.present ? headers.value : this.headers,
        timeout: timeout.present ? timeout.value : this.timeout,
        longRunning: longRunning ?? this.longRunning,
        disabled: disabled ?? this.disabled,
        error: error.present ? error.value : this.error,
        clientId: clientId.present ? clientId.value : this.clientId,
        clientSecret:
            clientSecret.present ? clientSecret.value : this.clientSecret,
        authorizationEndpoint: authorizationEndpoint.present
            ? authorizationEndpoint.value
            : this.authorizationEndpoint,
        tokenEndpoint:
            tokenEndpoint.present ? tokenEndpoint.value : this.tokenEndpoint,
        isConnected: isConnected ?? this.isConnected,
        lastConnected:
            lastConnected.present ? lastConnected.value : this.lastConnected,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  McpServersTableData copyWithCompanion(McpServersTableCompanion data) {
    return McpServersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      type: data.type.present ? data.type.value : this.type,
      headers: data.headers.present ? data.headers.value : this.headers,
      timeout: data.timeout.present ? data.timeout.value : this.timeout,
      longRunning:
          data.longRunning.present ? data.longRunning.value : this.longRunning,
      disabled: data.disabled.present ? data.disabled.value : this.disabled,
      error: data.error.present ? data.error.value : this.error,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      clientSecret: data.clientSecret.present
          ? data.clientSecret.value
          : this.clientSecret,
      authorizationEndpoint: data.authorizationEndpoint.present
          ? data.authorizationEndpoint.value
          : this.authorizationEndpoint,
      tokenEndpoint: data.tokenEndpoint.present
          ? data.tokenEndpoint.value
          : this.tokenEndpoint,
      isConnected:
          data.isConnected.present ? data.isConnected.value : this.isConnected,
      lastConnected: data.lastConnected.present
          ? data.lastConnected.value
          : this.lastConnected,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('McpServersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('type: $type, ')
          ..write('headers: $headers, ')
          ..write('timeout: $timeout, ')
          ..write('longRunning: $longRunning, ')
          ..write('disabled: $disabled, ')
          ..write('error: $error, ')
          ..write('clientId: $clientId, ')
          ..write('clientSecret: $clientSecret, ')
          ..write('authorizationEndpoint: $authorizationEndpoint, ')
          ..write('tokenEndpoint: $tokenEndpoint, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastConnected: $lastConnected, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      baseUrl,
      type,
      headers,
      timeout,
      longRunning,
      disabled,
      error,
      clientId,
      clientSecret,
      authorizationEndpoint,
      tokenEndpoint,
      isConnected,
      lastConnected,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is McpServersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.baseUrl == this.baseUrl &&
          other.type == this.type &&
          other.headers == this.headers &&
          other.timeout == this.timeout &&
          other.longRunning == this.longRunning &&
          other.disabled == this.disabled &&
          other.error == this.error &&
          other.clientId == this.clientId &&
          other.clientSecret == this.clientSecret &&
          other.authorizationEndpoint == this.authorizationEndpoint &&
          other.tokenEndpoint == this.tokenEndpoint &&
          other.isConnected == this.isConnected &&
          other.lastConnected == this.lastConnected &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class McpServersTableCompanion extends UpdateCompanion<McpServersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> baseUrl;
  final Value<String> type;
  final Value<String?> headers;
  final Value<int?> timeout;
  final Value<bool> longRunning;
  final Value<bool> disabled;
  final Value<String?> error;
  final Value<String?> clientId;
  final Value<String?> clientSecret;
  final Value<String?> authorizationEndpoint;
  final Value<String?> tokenEndpoint;
  final Value<bool> isConnected;
  final Value<DateTime?> lastConnected;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const McpServersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.headers = const Value.absent(),
    this.timeout = const Value.absent(),
    this.longRunning = const Value.absent(),
    this.disabled = const Value.absent(),
    this.error = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientSecret = const Value.absent(),
    this.authorizationEndpoint = const Value.absent(),
    this.tokenEndpoint = const Value.absent(),
    this.isConnected = const Value.absent(),
    this.lastConnected = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  McpServersTableCompanion.insert({
    required String id,
    required String name,
    required String baseUrl,
    required String type,
    this.headers = const Value.absent(),
    this.timeout = const Value.absent(),
    this.longRunning = const Value.absent(),
    this.disabled = const Value.absent(),
    this.error = const Value.absent(),
    this.clientId = const Value.absent(),
    this.clientSecret = const Value.absent(),
    this.authorizationEndpoint = const Value.absent(),
    this.tokenEndpoint = const Value.absent(),
    this.isConnected = const Value.absent(),
    this.lastConnected = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        baseUrl = Value(baseUrl),
        type = Value(type);
  static Insertable<McpServersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? baseUrl,
    Expression<String>? type,
    Expression<String>? headers,
    Expression<int>? timeout,
    Expression<bool>? longRunning,
    Expression<bool>? disabled,
    Expression<String>? error,
    Expression<String>? clientId,
    Expression<String>? clientSecret,
    Expression<String>? authorizationEndpoint,
    Expression<String>? tokenEndpoint,
    Expression<bool>? isConnected,
    Expression<DateTime>? lastConnected,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (baseUrl != null) 'base_url': baseUrl,
      if (type != null) 'type': type,
      if (headers != null) 'headers': headers,
      if (timeout != null) 'timeout': timeout,
      if (longRunning != null) 'long_running': longRunning,
      if (disabled != null) 'disabled': disabled,
      if (error != null) 'error': error,
      if (clientId != null) 'client_id': clientId,
      if (clientSecret != null) 'client_secret': clientSecret,
      if (authorizationEndpoint != null)
        'authorization_endpoint': authorizationEndpoint,
      if (tokenEndpoint != null) 'token_endpoint': tokenEndpoint,
      if (isConnected != null) 'is_connected': isConnected,
      if (lastConnected != null) 'last_connected': lastConnected,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  McpServersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? baseUrl,
      Value<String>? type,
      Value<String?>? headers,
      Value<int?>? timeout,
      Value<bool>? longRunning,
      Value<bool>? disabled,
      Value<String?>? error,
      Value<String?>? clientId,
      Value<String?>? clientSecret,
      Value<String?>? authorizationEndpoint,
      Value<String?>? tokenEndpoint,
      Value<bool>? isConnected,
      Value<DateTime?>? lastConnected,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return McpServersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      type: type ?? this.type,
      headers: headers ?? this.headers,
      timeout: timeout ?? this.timeout,
      longRunning: longRunning ?? this.longRunning,
      disabled: disabled ?? this.disabled,
      error: error ?? this.error,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      authorizationEndpoint:
          authorizationEndpoint ?? this.authorizationEndpoint,
      tokenEndpoint: tokenEndpoint ?? this.tokenEndpoint,
      isConnected: isConnected ?? this.isConnected,
      lastConnected: lastConnected ?? this.lastConnected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (headers.present) {
      map['headers'] = Variable<String>(headers.value);
    }
    if (timeout.present) {
      map['timeout'] = Variable<int>(timeout.value);
    }
    if (longRunning.present) {
      map['long_running'] = Variable<bool>(longRunning.value);
    }
    if (disabled.present) {
      map['disabled'] = Variable<bool>(disabled.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (clientSecret.present) {
      map['client_secret'] = Variable<String>(clientSecret.value);
    }
    if (authorizationEndpoint.present) {
      map['authorization_endpoint'] =
          Variable<String>(authorizationEndpoint.value);
    }
    if (tokenEndpoint.present) {
      map['token_endpoint'] = Variable<String>(tokenEndpoint.value);
    }
    if (isConnected.present) {
      map['is_connected'] = Variable<bool>(isConnected.value);
    }
    if (lastConnected.present) {
      map['last_connected'] = Variable<DateTime>(lastConnected.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McpServersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('type: $type, ')
          ..write('headers: $headers, ')
          ..write('timeout: $timeout, ')
          ..write('longRunning: $longRunning, ')
          ..write('disabled: $disabled, ')
          ..write('error: $error, ')
          ..write('clientId: $clientId, ')
          ..write('clientSecret: $clientSecret, ')
          ..write('authorizationEndpoint: $authorizationEndpoint, ')
          ..write('tokenEndpoint: $tokenEndpoint, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastConnected: $lastConnected, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $McpConnectionsTableTable extends McpConnectionsTable
    with TableInfo<$McpConnectionsTableTable, McpConnectionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McpConnectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mcp_servers (id) ON DELETE CASCADE'));
  static const VerificationMeta _isConnectedMeta =
      const VerificationMeta('isConnected');
  @override
  late final GeneratedColumn<bool> isConnected = GeneratedColumn<bool>(
      'is_connected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_connected" IN (0, 1))'));
  static const VerificationMeta _lastCheckMeta =
      const VerificationMeta('lastCheck');
  @override
  late final GeneratedColumn<DateTime> lastCheck = GeneratedColumn<DateTime>(
      'last_check', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _latencyMeta =
      const VerificationMeta('latency');
  @override
  late final GeneratedColumn<int> latency = GeneratedColumn<int>(
      'latency', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serverNameMeta =
      const VerificationMeta('serverName');
  @override
  late final GeneratedColumn<String> serverName = GeneratedColumn<String>(
      'server_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serverVersionMeta =
      const VerificationMeta('serverVersion');
  @override
  late final GeneratedColumn<String> serverVersion = GeneratedColumn<String>(
      'server_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _protocolVersionMeta =
      const VerificationMeta('protocolVersion');
  @override
  late final GeneratedColumn<String> protocolVersion = GeneratedColumn<String>(
      'protocol_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _toolsCountMeta =
      const VerificationMeta('toolsCount');
  @override
  late final GeneratedColumn<int> toolsCount = GeneratedColumn<int>(
      'tools_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _resourcesCountMeta =
      const VerificationMeta('resourcesCount');
  @override
  late final GeneratedColumn<int> resourcesCount = GeneratedColumn<int>(
      'resources_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _promptsCountMeta =
      const VerificationMeta('promptsCount');
  @override
  late final GeneratedColumn<int> promptsCount = GeneratedColumn<int>(
      'prompts_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        isConnected,
        lastCheck,
        latency,
        error,
        serverName,
        serverVersion,
        protocolVersion,
        toolsCount,
        resourcesCount,
        promptsCount,
        recordedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcp_connections';
  @override
  VerificationContext validateIntegrity(
      Insertable<McpConnectionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('is_connected')) {
      context.handle(
          _isConnectedMeta,
          isConnected.isAcceptableOrUnknown(
              data['is_connected']!, _isConnectedMeta));
    } else if (isInserting) {
      context.missing(_isConnectedMeta);
    }
    if (data.containsKey('last_check')) {
      context.handle(_lastCheckMeta,
          lastCheck.isAcceptableOrUnknown(data['last_check']!, _lastCheckMeta));
    } else if (isInserting) {
      context.missing(_lastCheckMeta);
    }
    if (data.containsKey('latency')) {
      context.handle(_latencyMeta,
          latency.isAcceptableOrUnknown(data['latency']!, _latencyMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('server_name')) {
      context.handle(
          _serverNameMeta,
          serverName.isAcceptableOrUnknown(
              data['server_name']!, _serverNameMeta));
    }
    if (data.containsKey('server_version')) {
      context.handle(
          _serverVersionMeta,
          serverVersion.isAcceptableOrUnknown(
              data['server_version']!, _serverVersionMeta));
    }
    if (data.containsKey('protocol_version')) {
      context.handle(
          _protocolVersionMeta,
          protocolVersion.isAcceptableOrUnknown(
              data['protocol_version']!, _protocolVersionMeta));
    }
    if (data.containsKey('tools_count')) {
      context.handle(
          _toolsCountMeta,
          toolsCount.isAcceptableOrUnknown(
              data['tools_count']!, _toolsCountMeta));
    }
    if (data.containsKey('resources_count')) {
      context.handle(
          _resourcesCountMeta,
          resourcesCount.isAcceptableOrUnknown(
              data['resources_count']!, _resourcesCountMeta));
    }
    if (data.containsKey('prompts_count')) {
      context.handle(
          _promptsCountMeta,
          promptsCount.isAcceptableOrUnknown(
              data['prompts_count']!, _promptsCountMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  McpConnectionsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return McpConnectionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      isConnected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_connected'])!,
      lastCheck: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_check'])!,
      latency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}latency']),
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
      serverName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_name']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_version']),
      protocolVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}protocol_version']),
      toolsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tools_count']),
      resourcesCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}resources_count']),
      promptsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prompts_count']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
    );
  }

  @override
  $McpConnectionsTableTable createAlias(String alias) {
    return $McpConnectionsTableTable(attachedDatabase, alias);
  }
}

class McpConnectionsTableData extends DataClass
    implements Insertable<McpConnectionsTableData> {
  /// 连接记录ID
  final int id;

  /// 服务器ID (外键)
  final String serverId;

  /// 是否连接
  final bool isConnected;

  /// 最后检查时间
  final DateTime lastCheck;

  /// 连接延迟 (毫秒)
  final int? latency;

  /// 错误信息
  final String? error;

  /// 服务器名称
  final String? serverName;

  /// 服务器版本
  final String? serverVersion;

  /// 协议版本
  final String? protocolVersion;

  /// 工具数量
  final int? toolsCount;

  /// 资源数量
  final int? resourcesCount;

  /// 提示数量
  final int? promptsCount;

  /// 记录时间
  final DateTime recordedAt;
  const McpConnectionsTableData(
      {required this.id,
      required this.serverId,
      required this.isConnected,
      required this.lastCheck,
      this.latency,
      this.error,
      this.serverName,
      this.serverVersion,
      this.protocolVersion,
      this.toolsCount,
      this.resourcesCount,
      this.promptsCount,
      required this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<String>(serverId);
    map['is_connected'] = Variable<bool>(isConnected);
    map['last_check'] = Variable<DateTime>(lastCheck);
    if (!nullToAbsent || latency != null) {
      map['latency'] = Variable<int>(latency);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || serverName != null) {
      map['server_name'] = Variable<String>(serverName);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<String>(serverVersion);
    }
    if (!nullToAbsent || protocolVersion != null) {
      map['protocol_version'] = Variable<String>(protocolVersion);
    }
    if (!nullToAbsent || toolsCount != null) {
      map['tools_count'] = Variable<int>(toolsCount);
    }
    if (!nullToAbsent || resourcesCount != null) {
      map['resources_count'] = Variable<int>(resourcesCount);
    }
    if (!nullToAbsent || promptsCount != null) {
      map['prompts_count'] = Variable<int>(promptsCount);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  McpConnectionsTableCompanion toCompanion(bool nullToAbsent) {
    return McpConnectionsTableCompanion(
      id: Value(id),
      serverId: Value(serverId),
      isConnected: Value(isConnected),
      lastCheck: Value(lastCheck),
      latency: latency == null && nullToAbsent
          ? const Value.absent()
          : Value(latency),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      serverName: serverName == null && nullToAbsent
          ? const Value.absent()
          : Value(serverName),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      protocolVersion: protocolVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolVersion),
      toolsCount: toolsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(toolsCount),
      resourcesCount: resourcesCount == null && nullToAbsent
          ? const Value.absent()
          : Value(resourcesCount),
      promptsCount: promptsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(promptsCount),
      recordedAt: Value(recordedAt),
    );
  }

  factory McpConnectionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return McpConnectionsTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      isConnected: serializer.fromJson<bool>(json['isConnected']),
      lastCheck: serializer.fromJson<DateTime>(json['lastCheck']),
      latency: serializer.fromJson<int?>(json['latency']),
      error: serializer.fromJson<String?>(json['error']),
      serverName: serializer.fromJson<String?>(json['serverName']),
      serverVersion: serializer.fromJson<String?>(json['serverVersion']),
      protocolVersion: serializer.fromJson<String?>(json['protocolVersion']),
      toolsCount: serializer.fromJson<int?>(json['toolsCount']),
      resourcesCount: serializer.fromJson<int?>(json['resourcesCount']),
      promptsCount: serializer.fromJson<int?>(json['promptsCount']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String>(serverId),
      'isConnected': serializer.toJson<bool>(isConnected),
      'lastCheck': serializer.toJson<DateTime>(lastCheck),
      'latency': serializer.toJson<int?>(latency),
      'error': serializer.toJson<String?>(error),
      'serverName': serializer.toJson<String?>(serverName),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'protocolVersion': serializer.toJson<String?>(protocolVersion),
      'toolsCount': serializer.toJson<int?>(toolsCount),
      'resourcesCount': serializer.toJson<int?>(resourcesCount),
      'promptsCount': serializer.toJson<int?>(promptsCount),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  McpConnectionsTableData copyWith(
          {int? id,
          String? serverId,
          bool? isConnected,
          DateTime? lastCheck,
          Value<int?> latency = const Value.absent(),
          Value<String?> error = const Value.absent(),
          Value<String?> serverName = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<String?> protocolVersion = const Value.absent(),
          Value<int?> toolsCount = const Value.absent(),
          Value<int?> resourcesCount = const Value.absent(),
          Value<int?> promptsCount = const Value.absent(),
          DateTime? recordedAt}) =>
      McpConnectionsTableData(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        isConnected: isConnected ?? this.isConnected,
        lastCheck: lastCheck ?? this.lastCheck,
        latency: latency.present ? latency.value : this.latency,
        error: error.present ? error.value : this.error,
        serverName: serverName.present ? serverName.value : this.serverName,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        protocolVersion: protocolVersion.present
            ? protocolVersion.value
            : this.protocolVersion,
        toolsCount: toolsCount.present ? toolsCount.value : this.toolsCount,
        resourcesCount:
            resourcesCount.present ? resourcesCount.value : this.resourcesCount,
        promptsCount:
            promptsCount.present ? promptsCount.value : this.promptsCount,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  McpConnectionsTableData copyWithCompanion(McpConnectionsTableCompanion data) {
    return McpConnectionsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      isConnected:
          data.isConnected.present ? data.isConnected.value : this.isConnected,
      lastCheck: data.lastCheck.present ? data.lastCheck.value : this.lastCheck,
      latency: data.latency.present ? data.latency.value : this.latency,
      error: data.error.present ? data.error.value : this.error,
      serverName:
          data.serverName.present ? data.serverName.value : this.serverName,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      protocolVersion: data.protocolVersion.present
          ? data.protocolVersion.value
          : this.protocolVersion,
      toolsCount:
          data.toolsCount.present ? data.toolsCount.value : this.toolsCount,
      resourcesCount: data.resourcesCount.present
          ? data.resourcesCount.value
          : this.resourcesCount,
      promptsCount: data.promptsCount.present
          ? data.promptsCount.value
          : this.promptsCount,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('McpConnectionsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastCheck: $lastCheck, ')
          ..write('latency: $latency, ')
          ..write('error: $error, ')
          ..write('serverName: $serverName, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('toolsCount: $toolsCount, ')
          ..write('resourcesCount: $resourcesCount, ')
          ..write('promptsCount: $promptsCount, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      serverId,
      isConnected,
      lastCheck,
      latency,
      error,
      serverName,
      serverVersion,
      protocolVersion,
      toolsCount,
      resourcesCount,
      promptsCount,
      recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is McpConnectionsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.isConnected == this.isConnected &&
          other.lastCheck == this.lastCheck &&
          other.latency == this.latency &&
          other.error == this.error &&
          other.serverName == this.serverName &&
          other.serverVersion == this.serverVersion &&
          other.protocolVersion == this.protocolVersion &&
          other.toolsCount == this.toolsCount &&
          other.resourcesCount == this.resourcesCount &&
          other.promptsCount == this.promptsCount &&
          other.recordedAt == this.recordedAt);
}

class McpConnectionsTableCompanion
    extends UpdateCompanion<McpConnectionsTableData> {
  final Value<int> id;
  final Value<String> serverId;
  final Value<bool> isConnected;
  final Value<DateTime> lastCheck;
  final Value<int?> latency;
  final Value<String?> error;
  final Value<String?> serverName;
  final Value<String?> serverVersion;
  final Value<String?> protocolVersion;
  final Value<int?> toolsCount;
  final Value<int?> resourcesCount;
  final Value<int?> promptsCount;
  final Value<DateTime> recordedAt;
  const McpConnectionsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.isConnected = const Value.absent(),
    this.lastCheck = const Value.absent(),
    this.latency = const Value.absent(),
    this.error = const Value.absent(),
    this.serverName = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.toolsCount = const Value.absent(),
    this.resourcesCount = const Value.absent(),
    this.promptsCount = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  McpConnectionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    required bool isConnected,
    required DateTime lastCheck,
    this.latency = const Value.absent(),
    this.error = const Value.absent(),
    this.serverName = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.toolsCount = const Value.absent(),
    this.resourcesCount = const Value.absent(),
    this.promptsCount = const Value.absent(),
    this.recordedAt = const Value.absent(),
  })  : serverId = Value(serverId),
        isConnected = Value(isConnected),
        lastCheck = Value(lastCheck);
  static Insertable<McpConnectionsTableData> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<bool>? isConnected,
    Expression<DateTime>? lastCheck,
    Expression<int>? latency,
    Expression<String>? error,
    Expression<String>? serverName,
    Expression<String>? serverVersion,
    Expression<String>? protocolVersion,
    Expression<int>? toolsCount,
    Expression<int>? resourcesCount,
    Expression<int>? promptsCount,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (isConnected != null) 'is_connected': isConnected,
      if (lastCheck != null) 'last_check': lastCheck,
      if (latency != null) 'latency': latency,
      if (error != null) 'error': error,
      if (serverName != null) 'server_name': serverName,
      if (serverVersion != null) 'server_version': serverVersion,
      if (protocolVersion != null) 'protocol_version': protocolVersion,
      if (toolsCount != null) 'tools_count': toolsCount,
      if (resourcesCount != null) 'resources_count': resourcesCount,
      if (promptsCount != null) 'prompts_count': promptsCount,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  McpConnectionsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverId,
      Value<bool>? isConnected,
      Value<DateTime>? lastCheck,
      Value<int?>? latency,
      Value<String?>? error,
      Value<String?>? serverName,
      Value<String?>? serverVersion,
      Value<String?>? protocolVersion,
      Value<int?>? toolsCount,
      Value<int?>? resourcesCount,
      Value<int?>? promptsCount,
      Value<DateTime>? recordedAt}) {
    return McpConnectionsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      isConnected: isConnected ?? this.isConnected,
      lastCheck: lastCheck ?? this.lastCheck,
      latency: latency ?? this.latency,
      error: error ?? this.error,
      serverName: serverName ?? this.serverName,
      serverVersion: serverVersion ?? this.serverVersion,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      toolsCount: toolsCount ?? this.toolsCount,
      resourcesCount: resourcesCount ?? this.resourcesCount,
      promptsCount: promptsCount ?? this.promptsCount,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (isConnected.present) {
      map['is_connected'] = Variable<bool>(isConnected.value);
    }
    if (lastCheck.present) {
      map['last_check'] = Variable<DateTime>(lastCheck.value);
    }
    if (latency.present) {
      map['latency'] = Variable<int>(latency.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (serverName.present) {
      map['server_name'] = Variable<String>(serverName.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<String>(serverVersion.value);
    }
    if (protocolVersion.present) {
      map['protocol_version'] = Variable<String>(protocolVersion.value);
    }
    if (toolsCount.present) {
      map['tools_count'] = Variable<int>(toolsCount.value);
    }
    if (resourcesCount.present) {
      map['resources_count'] = Variable<int>(resourcesCount.value);
    }
    if (promptsCount.present) {
      map['prompts_count'] = Variable<int>(promptsCount.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McpConnectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('isConnected: $isConnected, ')
          ..write('lastCheck: $lastCheck, ')
          ..write('latency: $latency, ')
          ..write('error: $error, ')
          ..write('serverName: $serverName, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('toolsCount: $toolsCount, ')
          ..write('resourcesCount: $resourcesCount, ')
          ..write('promptsCount: $promptsCount, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $McpToolsTableTable extends McpToolsTable
    with TableInfo<$McpToolsTableTable, McpToolsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McpToolsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mcp_servers (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputSchemaMeta =
      const VerificationMeta('inputSchema');
  @override
  late final GeneratedColumn<String> inputSchema = GeneratedColumn<String>(
      'input_schema', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, serverId, name, description, inputSchema, cachedAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcp_tools';
  @override
  VerificationContext validateIntegrity(Insertable<McpToolsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('input_schema')) {
      context.handle(
          _inputSchemaMeta,
          inputSchema.isAcceptableOrUnknown(
              data['input_schema']!, _inputSchemaMeta));
    } else if (isInserting) {
      context.missing(_inputSchemaMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  McpToolsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return McpToolsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      inputSchema: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_schema'])!,
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
    );
  }

  @override
  $McpToolsTableTable createAlias(String alias) {
    return $McpToolsTableTable(attachedDatabase, alias);
  }
}

class McpToolsTableData extends DataClass
    implements Insertable<McpToolsTableData> {
  /// 工具记录ID
  final int id;

  /// 服务器ID (外键)
  final String serverId;

  /// 工具名称
  final String name;

  /// 工具描述
  final String description;

  /// 输入模式 (JSON格式存储)
  final String inputSchema;

  /// 缓存时间
  final DateTime cachedAt;

  /// 过期时间
  final DateTime expiresAt;
  const McpToolsTableData(
      {required this.id,
      required this.serverId,
      required this.name,
      required this.description,
      required this.inputSchema,
      required this.cachedAt,
      required this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<String>(serverId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['input_schema'] = Variable<String>(inputSchema);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  McpToolsTableCompanion toCompanion(bool nullToAbsent) {
    return McpToolsTableCompanion(
      id: Value(id),
      serverId: Value(serverId),
      name: Value(name),
      description: Value(description),
      inputSchema: Value(inputSchema),
      cachedAt: Value(cachedAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory McpToolsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return McpToolsTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      inputSchema: serializer.fromJson<String>(json['inputSchema']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String>(serverId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'inputSchema': serializer.toJson<String>(inputSchema),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  McpToolsTableData copyWith(
          {int? id,
          String? serverId,
          String? name,
          String? description,
          String? inputSchema,
          DateTime? cachedAt,
          DateTime? expiresAt}) =>
      McpToolsTableData(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        name: name ?? this.name,
        description: description ?? this.description,
        inputSchema: inputSchema ?? this.inputSchema,
        cachedAt: cachedAt ?? this.cachedAt,
        expiresAt: expiresAt ?? this.expiresAt,
      );
  McpToolsTableData copyWithCompanion(McpToolsTableCompanion data) {
    return McpToolsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      inputSchema:
          data.inputSchema.present ? data.inputSchema.value : this.inputSchema,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('McpToolsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('inputSchema: $inputSchema, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, serverId, name, description, inputSchema, cachedAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is McpToolsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.description == this.description &&
          other.inputSchema == this.inputSchema &&
          other.cachedAt == this.cachedAt &&
          other.expiresAt == this.expiresAt);
}

class McpToolsTableCompanion extends UpdateCompanion<McpToolsTableData> {
  final Value<int> id;
  final Value<String> serverId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> inputSchema;
  final Value<DateTime> cachedAt;
  final Value<DateTime> expiresAt;
  const McpToolsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.inputSchema = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  McpToolsTableCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    required String name,
    required String description,
    required String inputSchema,
    this.cachedAt = const Value.absent(),
    required DateTime expiresAt,
  })  : serverId = Value(serverId),
        name = Value(name),
        description = Value(description),
        inputSchema = Value(inputSchema),
        expiresAt = Value(expiresAt);
  static Insertable<McpToolsTableData> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? inputSchema,
    Expression<DateTime>? cachedAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (inputSchema != null) 'input_schema': inputSchema,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  McpToolsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverId,
      Value<String>? name,
      Value<String>? description,
      Value<String>? inputSchema,
      Value<DateTime>? cachedAt,
      Value<DateTime>? expiresAt}) {
    return McpToolsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      description: description ?? this.description,
      inputSchema: inputSchema ?? this.inputSchema,
      cachedAt: cachedAt ?? this.cachedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (inputSchema.present) {
      map['input_schema'] = Variable<String>(inputSchema.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McpToolsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('inputSchema: $inputSchema, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $McpCallHistoryTableTable extends McpCallHistoryTable
    with TableInfo<$McpCallHistoryTableTable, McpCallHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McpCallHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mcp_servers (id) ON DELETE CASCADE'));
  static const VerificationMeta _toolNameMeta =
      const VerificationMeta('toolName');
  @override
  late final GeneratedColumn<String> toolName = GeneratedColumn<String>(
      'tool_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _argumentsMeta =
      const VerificationMeta('arguments');
  @override
  late final GeneratedColumn<String> arguments = GeneratedColumn<String>(
      'arguments', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _calledAtMeta =
      const VerificationMeta('calledAt');
  @override
  late final GeneratedColumn<DateTime> calledAt = GeneratedColumn<DateTime>(
      'called_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
      'error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isSuccessMeta =
      const VerificationMeta('isSuccess');
  @override
  late final GeneratedColumn<bool> isSuccess = GeneratedColumn<bool>(
      'is_success', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_success" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        toolName,
        arguments,
        calledAt,
        result,
        error,
        duration,
        isSuccess
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcp_call_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<McpCallHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('tool_name')) {
      context.handle(_toolNameMeta,
          toolName.isAcceptableOrUnknown(data['tool_name']!, _toolNameMeta));
    } else if (isInserting) {
      context.missing(_toolNameMeta);
    }
    if (data.containsKey('arguments')) {
      context.handle(_argumentsMeta,
          arguments.isAcceptableOrUnknown(data['arguments']!, _argumentsMeta));
    } else if (isInserting) {
      context.missing(_argumentsMeta);
    }
    if (data.containsKey('called_at')) {
      context.handle(_calledAtMeta,
          calledAt.isAcceptableOrUnknown(data['called_at']!, _calledAtMeta));
    } else if (isInserting) {
      context.missing(_calledAtMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    }
    if (data.containsKey('error')) {
      context.handle(
          _errorMeta, error.isAcceptableOrUnknown(data['error']!, _errorMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('is_success')) {
      context.handle(_isSuccessMeta,
          isSuccess.isAcceptableOrUnknown(data['is_success']!, _isSuccessMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  McpCallHistoryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return McpCallHistoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      toolName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tool_name'])!,
      arguments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arguments'])!,
      calledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}called_at'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result']),
      error: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration']),
      isSuccess: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_success'])!,
    );
  }

  @override
  $McpCallHistoryTableTable createAlias(String alias) {
    return $McpCallHistoryTableTable(attachedDatabase, alias);
  }
}

class McpCallHistoryTableData extends DataClass
    implements Insertable<McpCallHistoryTableData> {
  /// 调用记录ID
  final String id;

  /// 服务器ID (外键)
  final String serverId;

  /// 工具名称
  final String toolName;

  /// 调用参数 (JSON格式存储)
  final String arguments;

  /// 调用时间
  final DateTime calledAt;

  /// 执行结果 (JSON格式存储)
  final String? result;

  /// 错误信息
  final String? error;

  /// 执行时长 (毫秒)
  final int? duration;

  /// 是否成功
  final bool isSuccess;
  const McpCallHistoryTableData(
      {required this.id,
      required this.serverId,
      required this.toolName,
      required this.arguments,
      required this.calledAt,
      this.result,
      this.error,
      this.duration,
      required this.isSuccess});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['server_id'] = Variable<String>(serverId);
    map['tool_name'] = Variable<String>(toolName);
    map['arguments'] = Variable<String>(arguments);
    map['called_at'] = Variable<DateTime>(calledAt);
    if (!nullToAbsent || result != null) {
      map['result'] = Variable<String>(result);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    map['is_success'] = Variable<bool>(isSuccess);
    return map;
  }

  McpCallHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return McpCallHistoryTableCompanion(
      id: Value(id),
      serverId: Value(serverId),
      toolName: Value(toolName),
      arguments: Value(arguments),
      calledAt: Value(calledAt),
      result:
          result == null && nullToAbsent ? const Value.absent() : Value(result),
      error:
          error == null && nullToAbsent ? const Value.absent() : Value(error),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      isSuccess: Value(isSuccess),
    );
  }

  factory McpCallHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return McpCallHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      toolName: serializer.fromJson<String>(json['toolName']),
      arguments: serializer.fromJson<String>(json['arguments']),
      calledAt: serializer.fromJson<DateTime>(json['calledAt']),
      result: serializer.fromJson<String?>(json['result']),
      error: serializer.fromJson<String?>(json['error']),
      duration: serializer.fromJson<int?>(json['duration']),
      isSuccess: serializer.fromJson<bool>(json['isSuccess']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String>(serverId),
      'toolName': serializer.toJson<String>(toolName),
      'arguments': serializer.toJson<String>(arguments),
      'calledAt': serializer.toJson<DateTime>(calledAt),
      'result': serializer.toJson<String?>(result),
      'error': serializer.toJson<String?>(error),
      'duration': serializer.toJson<int?>(duration),
      'isSuccess': serializer.toJson<bool>(isSuccess),
    };
  }

  McpCallHistoryTableData copyWith(
          {String? id,
          String? serverId,
          String? toolName,
          String? arguments,
          DateTime? calledAt,
          Value<String?> result = const Value.absent(),
          Value<String?> error = const Value.absent(),
          Value<int?> duration = const Value.absent(),
          bool? isSuccess}) =>
      McpCallHistoryTableData(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        toolName: toolName ?? this.toolName,
        arguments: arguments ?? this.arguments,
        calledAt: calledAt ?? this.calledAt,
        result: result.present ? result.value : this.result,
        error: error.present ? error.value : this.error,
        duration: duration.present ? duration.value : this.duration,
        isSuccess: isSuccess ?? this.isSuccess,
      );
  McpCallHistoryTableData copyWithCompanion(McpCallHistoryTableCompanion data) {
    return McpCallHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      toolName: data.toolName.present ? data.toolName.value : this.toolName,
      arguments: data.arguments.present ? data.arguments.value : this.arguments,
      calledAt: data.calledAt.present ? data.calledAt.value : this.calledAt,
      result: data.result.present ? data.result.value : this.result,
      error: data.error.present ? data.error.value : this.error,
      duration: data.duration.present ? data.duration.value : this.duration,
      isSuccess: data.isSuccess.present ? data.isSuccess.value : this.isSuccess,
    );
  }

  @override
  String toString() {
    return (StringBuffer('McpCallHistoryTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('toolName: $toolName, ')
          ..write('arguments: $arguments, ')
          ..write('calledAt: $calledAt, ')
          ..write('result: $result, ')
          ..write('error: $error, ')
          ..write('duration: $duration, ')
          ..write('isSuccess: $isSuccess')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, toolName, arguments, calledAt,
      result, error, duration, isSuccess);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is McpCallHistoryTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.toolName == this.toolName &&
          other.arguments == this.arguments &&
          other.calledAt == this.calledAt &&
          other.result == this.result &&
          other.error == this.error &&
          other.duration == this.duration &&
          other.isSuccess == this.isSuccess);
}

class McpCallHistoryTableCompanion
    extends UpdateCompanion<McpCallHistoryTableData> {
  final Value<String> id;
  final Value<String> serverId;
  final Value<String> toolName;
  final Value<String> arguments;
  final Value<DateTime> calledAt;
  final Value<String?> result;
  final Value<String?> error;
  final Value<int?> duration;
  final Value<bool> isSuccess;
  final Value<int> rowid;
  const McpCallHistoryTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.toolName = const Value.absent(),
    this.arguments = const Value.absent(),
    this.calledAt = const Value.absent(),
    this.result = const Value.absent(),
    this.error = const Value.absent(),
    this.duration = const Value.absent(),
    this.isSuccess = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  McpCallHistoryTableCompanion.insert({
    required String id,
    required String serverId,
    required String toolName,
    required String arguments,
    required DateTime calledAt,
    this.result = const Value.absent(),
    this.error = const Value.absent(),
    this.duration = const Value.absent(),
    this.isSuccess = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        serverId = Value(serverId),
        toolName = Value(toolName),
        arguments = Value(arguments),
        calledAt = Value(calledAt);
  static Insertable<McpCallHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? toolName,
    Expression<String>? arguments,
    Expression<DateTime>? calledAt,
    Expression<String>? result,
    Expression<String>? error,
    Expression<int>? duration,
    Expression<bool>? isSuccess,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (toolName != null) 'tool_name': toolName,
      if (arguments != null) 'arguments': arguments,
      if (calledAt != null) 'called_at': calledAt,
      if (result != null) 'result': result,
      if (error != null) 'error': error,
      if (duration != null) 'duration': duration,
      if (isSuccess != null) 'is_success': isSuccess,
      if (rowid != null) 'rowid': rowid,
    });
  }

  McpCallHistoryTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? serverId,
      Value<String>? toolName,
      Value<String>? arguments,
      Value<DateTime>? calledAt,
      Value<String?>? result,
      Value<String?>? error,
      Value<int?>? duration,
      Value<bool>? isSuccess,
      Value<int>? rowid}) {
    return McpCallHistoryTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      toolName: toolName ?? this.toolName,
      arguments: arguments ?? this.arguments,
      calledAt: calledAt ?? this.calledAt,
      result: result ?? this.result,
      error: error ?? this.error,
      duration: duration ?? this.duration,
      isSuccess: isSuccess ?? this.isSuccess,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (toolName.present) {
      map['tool_name'] = Variable<String>(toolName.value);
    }
    if (arguments.present) {
      map['arguments'] = Variable<String>(arguments.value);
    }
    if (calledAt.present) {
      map['called_at'] = Variable<DateTime>(calledAt.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (isSuccess.present) {
      map['is_success'] = Variable<bool>(isSuccess.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McpCallHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('toolName: $toolName, ')
          ..write('arguments: $arguments, ')
          ..write('calledAt: $calledAt, ')
          ..write('result: $result, ')
          ..write('error: $error, ')
          ..write('duration: $duration, ')
          ..write('isSuccess: $isSuccess, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $McpResourcesTableTable extends McpResourcesTable
    with TableInfo<$McpResourcesTableTable, McpResourcesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McpResourcesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mcp_servers (id) ON DELETE CASCADE'));
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, serverId, uri, name, description, mimeType, cachedAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcp_resources';
  @override
  VerificationContext validateIntegrity(
      Insertable<McpResourcesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  McpResourcesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return McpResourcesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
    );
  }

  @override
  $McpResourcesTableTable createAlias(String alias) {
    return $McpResourcesTableTable(attachedDatabase, alias);
  }
}

class McpResourcesTableData extends DataClass
    implements Insertable<McpResourcesTableData> {
  /// 资源记录ID
  final int id;

  /// 服务器ID (外键)
  final String serverId;

  /// 资源URI
  final String uri;

  /// 资源名称
  final String name;

  /// 资源描述
  final String? description;

  /// MIME类型
  final String? mimeType;

  /// 缓存时间
  final DateTime cachedAt;

  /// 过期时间
  final DateTime expiresAt;
  const McpResourcesTableData(
      {required this.id,
      required this.serverId,
      required this.uri,
      required this.name,
      this.description,
      this.mimeType,
      required this.cachedAt,
      required this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<String>(serverId);
    map['uri'] = Variable<String>(uri);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  McpResourcesTableCompanion toCompanion(bool nullToAbsent) {
    return McpResourcesTableCompanion(
      id: Value(id),
      serverId: Value(serverId),
      uri: Value(uri),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      cachedAt: Value(cachedAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory McpResourcesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return McpResourcesTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      uri: serializer.fromJson<String>(json['uri']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String>(serverId),
      'uri': serializer.toJson<String>(uri),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'mimeType': serializer.toJson<String?>(mimeType),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  McpResourcesTableData copyWith(
          {int? id,
          String? serverId,
          String? uri,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          DateTime? cachedAt,
          DateTime? expiresAt}) =>
      McpResourcesTableData(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        uri: uri ?? this.uri,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        cachedAt: cachedAt ?? this.cachedAt,
        expiresAt: expiresAt ?? this.expiresAt,
      );
  McpResourcesTableData copyWithCompanion(McpResourcesTableCompanion data) {
    return McpResourcesTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      uri: data.uri.present ? data.uri.value : this.uri,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('McpResourcesTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('uri: $uri, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mimeType: $mimeType, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, serverId, uri, name, description, mimeType, cachedAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is McpResourcesTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.uri == this.uri &&
          other.name == this.name &&
          other.description == this.description &&
          other.mimeType == this.mimeType &&
          other.cachedAt == this.cachedAt &&
          other.expiresAt == this.expiresAt);
}

class McpResourcesTableCompanion
    extends UpdateCompanion<McpResourcesTableData> {
  final Value<int> id;
  final Value<String> serverId;
  final Value<String> uri;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> mimeType;
  final Value<DateTime> cachedAt;
  final Value<DateTime> expiresAt;
  const McpResourcesTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.uri = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  McpResourcesTableCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    required String uri,
    required String name,
    this.description = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.cachedAt = const Value.absent(),
    required DateTime expiresAt,
  })  : serverId = Value(serverId),
        uri = Value(uri),
        name = Value(name),
        expiresAt = Value(expiresAt);
  static Insertable<McpResourcesTableData> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? uri,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? mimeType,
    Expression<DateTime>? cachedAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (uri != null) 'uri': uri,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (mimeType != null) 'mime_type': mimeType,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  McpResourcesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverId,
      Value<String>? uri,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? mimeType,
      Value<DateTime>? cachedAt,
      Value<DateTime>? expiresAt}) {
    return McpResourcesTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      uri: uri ?? this.uri,
      name: name ?? this.name,
      description: description ?? this.description,
      mimeType: mimeType ?? this.mimeType,
      cachedAt: cachedAt ?? this.cachedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McpResourcesTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('uri: $uri, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('mimeType: $mimeType, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $McpOAuthTokensTableTable extends McpOAuthTokensTable
    with TableInfo<$McpOAuthTokensTableTable, McpOAuthTokensTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McpOAuthTokensTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES mcp_servers (id) ON DELETE CASCADE'));
  static const VerificationMeta _accessTokenMeta =
      const VerificationMeta('accessToken');
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
      'access_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tokenTypeMeta =
      const VerificationMeta('tokenType');
  @override
  late final GeneratedColumn<String> tokenType = GeneratedColumn<String>(
      'token_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _scopesMeta = const VerificationMeta('scopes');
  @override
  late final GeneratedColumn<String> scopes = GeneratedColumn<String>(
      'scopes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        serverId,
        accessToken,
        refreshToken,
        tokenType,
        expiresAt,
        scopes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcp_oauth_tokens';
  @override
  VerificationContext validateIntegrity(
      Insertable<McpOAuthTokensTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('access_token')) {
      context.handle(
          _accessTokenMeta,
          accessToken.isAcceptableOrUnknown(
              data['access_token']!, _accessTokenMeta));
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    }
    if (data.containsKey('token_type')) {
      context.handle(_tokenTypeMeta,
          tokenType.isAcceptableOrUnknown(data['token_type']!, _tokenTypeMeta));
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('scopes')) {
      context.handle(_scopesMeta,
          scopes.isAcceptableOrUnknown(data['scopes']!, _scopesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId};
  @override
  McpOAuthTokensTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return McpOAuthTokensTableData(
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      accessToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_token'])!,
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token']),
      tokenType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_type']),
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      scopes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scopes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $McpOAuthTokensTableTable createAlias(String alias) {
    return $McpOAuthTokensTableTable(attachedDatabase, alias);
  }
}

class McpOAuthTokensTableData extends DataClass
    implements Insertable<McpOAuthTokensTableData> {
  /// 服务器ID (外键)
  final String serverId;

  /// 访问令牌 (加密存储)
  final String accessToken;

  /// 刷新令牌 (加密存储)
  final String? refreshToken;

  /// 令牌类型
  final String? tokenType;

  /// 过期时间
  final DateTime? expiresAt;

  /// 权限范围
  final String? scopes;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const McpOAuthTokensTableData(
      {required this.serverId,
      required this.accessToken,
      this.refreshToken,
      this.tokenType,
      this.expiresAt,
      this.scopes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['access_token'] = Variable<String>(accessToken);
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    if (!nullToAbsent || tokenType != null) {
      map['token_type'] = Variable<String>(tokenType);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || scopes != null) {
      map['scopes'] = Variable<String>(scopes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  McpOAuthTokensTableCompanion toCompanion(bool nullToAbsent) {
    return McpOAuthTokensTableCompanion(
      serverId: Value(serverId),
      accessToken: Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      tokenType: tokenType == null && nullToAbsent
          ? const Value.absent()
          : Value(tokenType),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      scopes:
          scopes == null && nullToAbsent ? const Value.absent() : Value(scopes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory McpOAuthTokensTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return McpOAuthTokensTableData(
      serverId: serializer.fromJson<String>(json['serverId']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      tokenType: serializer.fromJson<String?>(json['tokenType']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      scopes: serializer.fromJson<String?>(json['scopes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'accessToken': serializer.toJson<String>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'tokenType': serializer.toJson<String?>(tokenType),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'scopes': serializer.toJson<String?>(scopes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  McpOAuthTokensTableData copyWith(
          {String? serverId,
          String? accessToken,
          Value<String?> refreshToken = const Value.absent(),
          Value<String?> tokenType = const Value.absent(),
          Value<DateTime?> expiresAt = const Value.absent(),
          Value<String?> scopes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      McpOAuthTokensTableData(
        serverId: serverId ?? this.serverId,
        accessToken: accessToken ?? this.accessToken,
        refreshToken:
            refreshToken.present ? refreshToken.value : this.refreshToken,
        tokenType: tokenType.present ? tokenType.value : this.tokenType,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        scopes: scopes.present ? scopes.value : this.scopes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  McpOAuthTokensTableData copyWithCompanion(McpOAuthTokensTableCompanion data) {
    return McpOAuthTokensTableData(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      accessToken:
          data.accessToken.present ? data.accessToken.value : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      tokenType: data.tokenType.present ? data.tokenType.value : this.tokenType,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      scopes: data.scopes.present ? data.scopes.value : this.scopes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('McpOAuthTokensTableData(')
          ..write('serverId: $serverId, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenType: $tokenType, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('scopes: $scopes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serverId, accessToken, refreshToken,
      tokenType, expiresAt, scopes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is McpOAuthTokensTableData &&
          other.serverId == this.serverId &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.tokenType == this.tokenType &&
          other.expiresAt == this.expiresAt &&
          other.scopes == this.scopes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class McpOAuthTokensTableCompanion
    extends UpdateCompanion<McpOAuthTokensTableData> {
  final Value<String> serverId;
  final Value<String> accessToken;
  final Value<String?> refreshToken;
  final Value<String?> tokenType;
  final Value<DateTime?> expiresAt;
  final Value<String?> scopes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const McpOAuthTokensTableCompanion({
    this.serverId = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.tokenType = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.scopes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  McpOAuthTokensTableCompanion.insert({
    required String serverId,
    required String accessToken,
    this.refreshToken = const Value.absent(),
    this.tokenType = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.scopes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : serverId = Value(serverId),
        accessToken = Value(accessToken);
  static Insertable<McpOAuthTokensTableData> custom({
    Expression<String>? serverId,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<String>? tokenType,
    Expression<DateTime>? expiresAt,
    Expression<String>? scopes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (tokenType != null) 'token_type': tokenType,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (scopes != null) 'scopes': scopes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  McpOAuthTokensTableCompanion copyWith(
      {Value<String>? serverId,
      Value<String>? accessToken,
      Value<String?>? refreshToken,
      Value<String?>? tokenType,
      Value<DateTime?>? expiresAt,
      Value<String?>? scopes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return McpOAuthTokensTableCompanion(
      serverId: serverId ?? this.serverId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
      scopes: scopes ?? this.scopes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (tokenType.present) {
      map['token_type'] = Variable<String>(tokenType.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (scopes.present) {
      map['scopes'] = Variable<String>(scopes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McpOAuthTokensTableCompanion(')
          ..write('serverId: $serverId, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('tokenType: $tokenType, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('scopes: $scopes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LlmConfigsTableTable llmConfigsTable =
      $LlmConfigsTableTable(this);
  late final $PersonasTableTable personasTable = $PersonasTableTable(this);
  late final $PersonaGroupsTableTable personaGroupsTable =
      $PersonaGroupsTableTable(this);
  late final $ChatSessionsTableTable chatSessionsTable =
      $ChatSessionsTableTable(this);
  late final $ChatMessagesTableTable chatMessagesTable =
      $ChatMessagesTableTable(this);
  late final $KnowledgeBasesTableTable knowledgeBasesTable =
      $KnowledgeBasesTableTable(this);
  late final $KnowledgeDocumentsTableTable knowledgeDocumentsTable =
      $KnowledgeDocumentsTableTable(this);
  late final $KnowledgeChunksTableTable knowledgeChunksTable =
      $KnowledgeChunksTableTable(this);
  late final $KnowledgeBaseConfigsTableTable knowledgeBaseConfigsTable =
      $KnowledgeBaseConfigsTableTable(this);
  late final $CustomModelsTableTable customModelsTable =
      $CustomModelsTableTable(this);
  late final $GeneralSettingsTableTable generalSettingsTable =
      $GeneralSettingsTableTable(this);
  late final $McpServersTableTable mcpServersTable =
      $McpServersTableTable(this);
  late final $McpConnectionsTableTable mcpConnectionsTable =
      $McpConnectionsTableTable(this);
  late final $McpToolsTableTable mcpToolsTable = $McpToolsTableTable(this);
  late final $McpCallHistoryTableTable mcpCallHistoryTable =
      $McpCallHistoryTableTable(this);
  late final $McpResourcesTableTable mcpResourcesTable =
      $McpResourcesTableTable(this);
  late final $McpOAuthTokensTableTable mcpOAuthTokensTable =
      $McpOAuthTokensTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        llmConfigsTable,
        personasTable,
        personaGroupsTable,
        chatSessionsTable,
        chatMessagesTable,
        knowledgeBasesTable,
        knowledgeDocumentsTable,
        knowledgeChunksTable,
        knowledgeBaseConfigsTable,
        customModelsTable,
        generalSettingsTable,
        mcpServersTable,
        mcpConnectionsTable,
        mcpToolsTable,
        mcpCallHistoryTable,
        mcpResourcesTable,
        mcpOAuthTokensTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('mcp_servers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mcp_connections', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mcp_servers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mcp_tools', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mcp_servers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mcp_call_history', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mcp_servers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mcp_resources', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('mcp_servers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('mcp_oauth_tokens', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$LlmConfigsTableTableCreateCompanionBuilder = LlmConfigsTableCompanion
    Function({
  required String id,
  required String name,
  required String provider,
  required String apiKey,
  Value<String?> baseUrl,
  Value<String?> defaultModel,
  Value<String?> defaultEmbeddingModel,
  Value<String?> organizationId,
  Value<String?> projectId,
  Value<String?> extraParams,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isEnabled,
  Value<bool> isCustomProvider,
  Value<String> apiCompatibilityType,
  Value<String?> customProviderName,
  Value<String?> customProviderDescription,
  Value<String?> customProviderIcon,
  Value<int> rowid,
});
typedef $$LlmConfigsTableTableUpdateCompanionBuilder = LlmConfigsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> provider,
  Value<String> apiKey,
  Value<String?> baseUrl,
  Value<String?> defaultModel,
  Value<String?> defaultEmbeddingModel,
  Value<String?> organizationId,
  Value<String?> projectId,
  Value<String?> extraParams,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isEnabled,
  Value<bool> isCustomProvider,
  Value<String> apiCompatibilityType,
  Value<String?> customProviderName,
  Value<String?> customProviderDescription,
  Value<String?> customProviderIcon,
  Value<int> rowid,
});

class $$LlmConfigsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LlmConfigsTableTable> {
  $$LlmConfigsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultModel => $composableBuilder(
      column: $table.defaultModel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultEmbeddingModel => $composableBuilder(
      column: $table.defaultEmbeddingModel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extraParams => $composableBuilder(
      column: $table.extraParams, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustomProvider => $composableBuilder(
      column: $table.isCustomProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiCompatibilityType => $composableBuilder(
      column: $table.apiCompatibilityType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customProviderName => $composableBuilder(
      column: $table.customProviderName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customProviderDescription => $composableBuilder(
      column: $table.customProviderDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customProviderIcon => $composableBuilder(
      column: $table.customProviderIcon,
      builder: (column) => ColumnFilters(column));
}

class $$LlmConfigsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LlmConfigsTableTable> {
  $$LlmConfigsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultModel => $composableBuilder(
      column: $table.defaultModel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultEmbeddingModel => $composableBuilder(
      column: $table.defaultEmbeddingModel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraParams => $composableBuilder(
      column: $table.extraParams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustomProvider => $composableBuilder(
      column: $table.isCustomProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiCompatibilityType => $composableBuilder(
      column: $table.apiCompatibilityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customProviderName => $composableBuilder(
      column: $table.customProviderName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customProviderDescription => $composableBuilder(
      column: $table.customProviderDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customProviderIcon => $composableBuilder(
      column: $table.customProviderIcon,
      builder: (column) => ColumnOrderings(column));
}

class $$LlmConfigsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LlmConfigsTableTable> {
  $$LlmConfigsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get defaultModel => $composableBuilder(
      column: $table.defaultModel, builder: (column) => column);

  GeneratedColumn<String> get defaultEmbeddingModel => $composableBuilder(
      column: $table.defaultEmbeddingModel, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get extraParams => $composableBuilder(
      column: $table.extraParams, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isCustomProvider => $composableBuilder(
      column: $table.isCustomProvider, builder: (column) => column);

  GeneratedColumn<String> get apiCompatibilityType => $composableBuilder(
      column: $table.apiCompatibilityType, builder: (column) => column);

  GeneratedColumn<String> get customProviderName => $composableBuilder(
      column: $table.customProviderName, builder: (column) => column);

  GeneratedColumn<String> get customProviderDescription => $composableBuilder(
      column: $table.customProviderDescription, builder: (column) => column);

  GeneratedColumn<String> get customProviderIcon => $composableBuilder(
      column: $table.customProviderIcon, builder: (column) => column);
}

class $$LlmConfigsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LlmConfigsTableTable,
    LlmConfigsTableData,
    $$LlmConfigsTableTableFilterComposer,
    $$LlmConfigsTableTableOrderingComposer,
    $$LlmConfigsTableTableAnnotationComposer,
    $$LlmConfigsTableTableCreateCompanionBuilder,
    $$LlmConfigsTableTableUpdateCompanionBuilder,
    (
      LlmConfigsTableData,
      BaseReferences<_$AppDatabase, $LlmConfigsTableTable, LlmConfigsTableData>
    ),
    LlmConfigsTableData,
    PrefetchHooks Function()> {
  $$LlmConfigsTableTableTableManager(
      _$AppDatabase db, $LlmConfigsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LlmConfigsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LlmConfigsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LlmConfigsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String> apiKey = const Value.absent(),
            Value<String?> baseUrl = const Value.absent(),
            Value<String?> defaultModel = const Value.absent(),
            Value<String?> defaultEmbeddingModel = const Value.absent(),
            Value<String?> organizationId = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> extraParams = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<bool> isCustomProvider = const Value.absent(),
            Value<String> apiCompatibilityType = const Value.absent(),
            Value<String?> customProviderName = const Value.absent(),
            Value<String?> customProviderDescription = const Value.absent(),
            Value<String?> customProviderIcon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LlmConfigsTableCompanion(
            id: id,
            name: name,
            provider: provider,
            apiKey: apiKey,
            baseUrl: baseUrl,
            defaultModel: defaultModel,
            defaultEmbeddingModel: defaultEmbeddingModel,
            organizationId: organizationId,
            projectId: projectId,
            extraParams: extraParams,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isEnabled: isEnabled,
            isCustomProvider: isCustomProvider,
            apiCompatibilityType: apiCompatibilityType,
            customProviderName: customProviderName,
            customProviderDescription: customProviderDescription,
            customProviderIcon: customProviderIcon,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String provider,
            required String apiKey,
            Value<String?> baseUrl = const Value.absent(),
            Value<String?> defaultModel = const Value.absent(),
            Value<String?> defaultEmbeddingModel = const Value.absent(),
            Value<String?> organizationId = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String?> extraParams = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isEnabled = const Value.absent(),
            Value<bool> isCustomProvider = const Value.absent(),
            Value<String> apiCompatibilityType = const Value.absent(),
            Value<String?> customProviderName = const Value.absent(),
            Value<String?> customProviderDescription = const Value.absent(),
            Value<String?> customProviderIcon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LlmConfigsTableCompanion.insert(
            id: id,
            name: name,
            provider: provider,
            apiKey: apiKey,
            baseUrl: baseUrl,
            defaultModel: defaultModel,
            defaultEmbeddingModel: defaultEmbeddingModel,
            organizationId: organizationId,
            projectId: projectId,
            extraParams: extraParams,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isEnabled: isEnabled,
            isCustomProvider: isCustomProvider,
            apiCompatibilityType: apiCompatibilityType,
            customProviderName: customProviderName,
            customProviderDescription: customProviderDescription,
            customProviderIcon: customProviderIcon,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LlmConfigsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LlmConfigsTableTable,
    LlmConfigsTableData,
    $$LlmConfigsTableTableFilterComposer,
    $$LlmConfigsTableTableOrderingComposer,
    $$LlmConfigsTableTableAnnotationComposer,
    $$LlmConfigsTableTableCreateCompanionBuilder,
    $$LlmConfigsTableTableUpdateCompanionBuilder,
    (
      LlmConfigsTableData,
      BaseReferences<_$AppDatabase, $LlmConfigsTableTable, LlmConfigsTableData>
    ),
    LlmConfigsTableData,
    PrefetchHooks Function()>;
typedef $$PersonasTableTableCreateCompanionBuilder = PersonasTableCompanion
    Function({
  required String id,
  required String name,
  required String description,
  required String systemPrompt,
  required String apiConfigId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastUsedAt,
  Value<String> category,
  Value<String> tags,
  Value<String?> avatar,
  Value<bool> isDefault,
  Value<bool> isEnabled,
  Value<int> usageCount,
  Value<String?> config,
  Value<String> capabilities,
  Value<String?> metadata,
  Value<int> rowid,
});
typedef $$PersonasTableTableUpdateCompanionBuilder = PersonasTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> systemPrompt,
  Value<String> apiConfigId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastUsedAt,
  Value<String> category,
  Value<String> tags,
  Value<String?> avatar,
  Value<bool> isDefault,
  Value<bool> isEnabled,
  Value<int> usageCount,
  Value<String?> config,
  Value<String> capabilities,
  Value<String?> metadata,
  Value<int> rowid,
});

class $$PersonasTableTableFilterComposer
    extends Composer<_$AppDatabase, $PersonasTableTable> {
  $$PersonasTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiConfigId => $composableBuilder(
      column: $table.apiConfigId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get capabilities => $composableBuilder(
      column: $table.capabilities, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));
}

class $$PersonasTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonasTableTable> {
  $$PersonasTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiConfigId => $composableBuilder(
      column: $table.apiConfigId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get capabilities => $composableBuilder(
      column: $table.capabilities,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$PersonasTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonasTableTable> {
  $$PersonasTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => column);

  GeneratedColumn<String> get apiConfigId => $composableBuilder(
      column: $table.apiConfigId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
      column: $table.usageCount, builder: (column) => column);

  GeneratedColumn<String> get config =>
      $composableBuilder(column: $table.config, builder: (column) => column);

  GeneratedColumn<String> get capabilities => $composableBuilder(
      column: $table.capabilities, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$PersonasTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonasTableTable,
    PersonasTableData,
    $$PersonasTableTableFilterComposer,
    $$PersonasTableTableOrderingComposer,
    $$PersonasTableTableAnnotationComposer,
    $$PersonasTableTableCreateCompanionBuilder,
    $$PersonasTableTableUpdateCompanionBuilder,
    (
      PersonasTableData,
      BaseReferences<_$AppDatabase, $PersonasTableTable, PersonasTableData>
    ),
    PersonasTableData,
    PrefetchHooks Function()> {
  $$PersonasTableTableTableManager(_$AppDatabase db, $PersonasTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonasTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonasTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonasTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> systemPrompt = const Value.absent(),
            Value<String> apiConfigId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<String?> config = const Value.absent(),
            Value<String> capabilities = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonasTableCompanion(
            id: id,
            name: name,
            description: description,
            systemPrompt: systemPrompt,
            apiConfigId: apiConfigId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
            category: category,
            tags: tags,
            avatar: avatar,
            isDefault: isDefault,
            isEnabled: isEnabled,
            usageCount: usageCount,
            config: config,
            capabilities: capabilities,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String systemPrompt,
            required String apiConfigId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<int> usageCount = const Value.absent(),
            Value<String?> config = const Value.absent(),
            Value<String> capabilities = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonasTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            systemPrompt: systemPrompt,
            apiConfigId: apiConfigId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
            category: category,
            tags: tags,
            avatar: avatar,
            isDefault: isDefault,
            isEnabled: isEnabled,
            usageCount: usageCount,
            config: config,
            capabilities: capabilities,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonasTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonasTableTable,
    PersonasTableData,
    $$PersonasTableTableFilterComposer,
    $$PersonasTableTableOrderingComposer,
    $$PersonasTableTableAnnotationComposer,
    $$PersonasTableTableCreateCompanionBuilder,
    $$PersonasTableTableUpdateCompanionBuilder,
    (
      PersonasTableData,
      BaseReferences<_$AppDatabase, $PersonasTableTable, PersonasTableData>
    ),
    PersonasTableData,
    PrefetchHooks Function()>;
typedef $$PersonaGroupsTableTableCreateCompanionBuilder
    = PersonaGroupsTableCompanion Function({
  required String id,
  required String name,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PersonaGroupsTableTableUpdateCompanionBuilder
    = PersonaGroupsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PersonaGroupsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PersonaGroupsTableTable> {
  $$PersonaGroupsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PersonaGroupsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonaGroupsTableTable> {
  $$PersonaGroupsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonaGroupsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonaGroupsTableTable> {
  $$PersonaGroupsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonaGroupsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonaGroupsTableTable,
    PersonaGroupsTableData,
    $$PersonaGroupsTableTableFilterComposer,
    $$PersonaGroupsTableTableOrderingComposer,
    $$PersonaGroupsTableTableAnnotationComposer,
    $$PersonaGroupsTableTableCreateCompanionBuilder,
    $$PersonaGroupsTableTableUpdateCompanionBuilder,
    (
      PersonaGroupsTableData,
      BaseReferences<_$AppDatabase, $PersonaGroupsTableTable,
          PersonaGroupsTableData>
    ),
    PersonaGroupsTableData,
    PrefetchHooks Function()> {
  $$PersonaGroupsTableTableTableManager(
      _$AppDatabase db, $PersonaGroupsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonaGroupsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonaGroupsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonaGroupsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonaGroupsTableCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonaGroupsTableCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonaGroupsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonaGroupsTableTable,
    PersonaGroupsTableData,
    $$PersonaGroupsTableTableFilterComposer,
    $$PersonaGroupsTableTableOrderingComposer,
    $$PersonaGroupsTableTableAnnotationComposer,
    $$PersonaGroupsTableTableCreateCompanionBuilder,
    $$PersonaGroupsTableTableUpdateCompanionBuilder,
    (
      PersonaGroupsTableData,
      BaseReferences<_$AppDatabase, $PersonaGroupsTableTable,
          PersonaGroupsTableData>
    ),
    PersonaGroupsTableData,
    PrefetchHooks Function()>;
typedef $$ChatSessionsTableTableCreateCompanionBuilder
    = ChatSessionsTableCompanion Function({
  required String id,
  required String title,
  required String personaId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isArchived,
  Value<bool> isPinned,
  Value<String> tags,
  Value<int> messageCount,
  Value<int> totalTokens,
  Value<String?> config,
  Value<String?> metadata,
  Value<int> rowid,
});
typedef $$ChatSessionsTableTableUpdateCompanionBuilder
    = ChatSessionsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> personaId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isArchived,
  Value<bool> isPinned,
  Value<String> tags,
  Value<int> messageCount,
  Value<int> totalTokens,
  Value<String?> config,
  Value<String?> metadata,
  Value<int> rowid,
});

class $$ChatSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChatSessionsTableTable> {
  $$ChatSessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personaId => $composableBuilder(
      column: $table.personaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get messageCount => $composableBuilder(
      column: $table.messageCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTokens => $composableBuilder(
      column: $table.totalTokens, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));
}

class $$ChatSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatSessionsTableTable> {
  $$ChatSessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personaId => $composableBuilder(
      column: $table.personaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get messageCount => $composableBuilder(
      column: $table.messageCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTokens => $composableBuilder(
      column: $table.totalTokens, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));
}

class $$ChatSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatSessionsTableTable> {
  $$ChatSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get personaId =>
      $composableBuilder(column: $table.personaId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get messageCount => $composableBuilder(
      column: $table.messageCount, builder: (column) => column);

  GeneratedColumn<int> get totalTokens => $composableBuilder(
      column: $table.totalTokens, builder: (column) => column);

  GeneratedColumn<String> get config =>
      $composableBuilder(column: $table.config, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$ChatSessionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatSessionsTableTable,
    ChatSessionsTableData,
    $$ChatSessionsTableTableFilterComposer,
    $$ChatSessionsTableTableOrderingComposer,
    $$ChatSessionsTableTableAnnotationComposer,
    $$ChatSessionsTableTableCreateCompanionBuilder,
    $$ChatSessionsTableTableUpdateCompanionBuilder,
    (
      ChatSessionsTableData,
      BaseReferences<_$AppDatabase, $ChatSessionsTableTable,
          ChatSessionsTableData>
    ),
    ChatSessionsTableData,
    PrefetchHooks Function()> {
  $$ChatSessionsTableTableTableManager(
      _$AppDatabase db, $ChatSessionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatSessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatSessionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> personaId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> messageCount = const Value.absent(),
            Value<int> totalTokens = const Value.absent(),
            Value<String?> config = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatSessionsTableCompanion(
            id: id,
            title: title,
            personaId: personaId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isArchived: isArchived,
            isPinned: isPinned,
            tags: tags,
            messageCount: messageCount,
            totalTokens: totalTokens,
            config: config,
            metadata: metadata,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String personaId,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isArchived = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> messageCount = const Value.absent(),
            Value<int> totalTokens = const Value.absent(),
            Value<String?> config = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatSessionsTableCompanion.insert(
            id: id,
            title: title,
            personaId: personaId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isArchived: isArchived,
            isPinned: isPinned,
            tags: tags,
            messageCount: messageCount,
            totalTokens: totalTokens,
            config: config,
            metadata: metadata,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatSessionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatSessionsTableTable,
    ChatSessionsTableData,
    $$ChatSessionsTableTableFilterComposer,
    $$ChatSessionsTableTableOrderingComposer,
    $$ChatSessionsTableTableAnnotationComposer,
    $$ChatSessionsTableTableCreateCompanionBuilder,
    $$ChatSessionsTableTableUpdateCompanionBuilder,
    (
      ChatSessionsTableData,
      BaseReferences<_$AppDatabase, $ChatSessionsTableTable,
          ChatSessionsTableData>
    ),
    ChatSessionsTableData,
    PrefetchHooks Function()>;
typedef $$ChatMessagesTableTableCreateCompanionBuilder
    = ChatMessagesTableCompanion Function({
  required String id,
  required String content,
  required bool isFromUser,
  required DateTime timestamp,
  required String chatSessionId,
  Value<String> type,
  Value<String> status,
  Value<String?> metadata,
  Value<String?> parentMessageId,
  Value<int?> tokenCount,
  Value<String?> thinkingContent,
  Value<bool> thinkingComplete,
  Value<String?> modelName,
  Value<String> imageUrls,
  Value<int> rowid,
});
typedef $$ChatMessagesTableTableUpdateCompanionBuilder
    = ChatMessagesTableCompanion Function({
  Value<String> id,
  Value<String> content,
  Value<bool> isFromUser,
  Value<DateTime> timestamp,
  Value<String> chatSessionId,
  Value<String> type,
  Value<String> status,
  Value<String?> metadata,
  Value<String?> parentMessageId,
  Value<int?> tokenCount,
  Value<String?> thinkingContent,
  Value<bool> thinkingComplete,
  Value<String?> modelName,
  Value<String> imageUrls,
  Value<int> rowid,
});

class $$ChatMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFromUser => $composableBuilder(
      column: $table.isFromUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chatSessionId => $composableBuilder(
      column: $table.chatSessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentMessageId => $composableBuilder(
      column: $table.parentMessageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thinkingContent => $composableBuilder(
      column: $table.thinkingContent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get thinkingComplete => $composableBuilder(
      column: $table.thinkingComplete,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrls => $composableBuilder(
      column: $table.imageUrls, builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFromUser => $composableBuilder(
      column: $table.isFromUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chatSessionId => $composableBuilder(
      column: $table.chatSessionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentMessageId => $composableBuilder(
      column: $table.parentMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thinkingContent => $composableBuilder(
      column: $table.thinkingContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get thinkingComplete => $composableBuilder(
      column: $table.thinkingComplete,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelName => $composableBuilder(
      column: $table.modelName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrls => $composableBuilder(
      column: $table.imageUrls, builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isFromUser => $composableBuilder(
      column: $table.isFromUser, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get chatSessionId => $composableBuilder(
      column: $table.chatSessionId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get parentMessageId => $composableBuilder(
      column: $table.parentMessageId, builder: (column) => column);

  GeneratedColumn<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => column);

  GeneratedColumn<String> get thinkingContent => $composableBuilder(
      column: $table.thinkingContent, builder: (column) => column);

  GeneratedColumn<bool> get thinkingComplete => $composableBuilder(
      column: $table.thinkingComplete, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);
}

class $$ChatMessagesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesTableTable,
    ChatMessagesTableData,
    $$ChatMessagesTableTableFilterComposer,
    $$ChatMessagesTableTableOrderingComposer,
    $$ChatMessagesTableTableAnnotationComposer,
    $$ChatMessagesTableTableCreateCompanionBuilder,
    $$ChatMessagesTableTableUpdateCompanionBuilder,
    (
      ChatMessagesTableData,
      BaseReferences<_$AppDatabase, $ChatMessagesTableTable,
          ChatMessagesTableData>
    ),
    ChatMessagesTableData,
    PrefetchHooks Function()> {
  $$ChatMessagesTableTableTableManager(
      _$AppDatabase db, $ChatMessagesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<bool> isFromUser = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> chatSessionId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<String?> parentMessageId = const Value.absent(),
            Value<int?> tokenCount = const Value.absent(),
            Value<String?> thinkingContent = const Value.absent(),
            Value<bool> thinkingComplete = const Value.absent(),
            Value<String?> modelName = const Value.absent(),
            Value<String> imageUrls = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesTableCompanion(
            id: id,
            content: content,
            isFromUser: isFromUser,
            timestamp: timestamp,
            chatSessionId: chatSessionId,
            type: type,
            status: status,
            metadata: metadata,
            parentMessageId: parentMessageId,
            tokenCount: tokenCount,
            thinkingContent: thinkingContent,
            thinkingComplete: thinkingComplete,
            modelName: modelName,
            imageUrls: imageUrls,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String content,
            required bool isFromUser,
            required DateTime timestamp,
            required String chatSessionId,
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<String?> parentMessageId = const Value.absent(),
            Value<int?> tokenCount = const Value.absent(),
            Value<String?> thinkingContent = const Value.absent(),
            Value<bool> thinkingComplete = const Value.absent(),
            Value<String?> modelName = const Value.absent(),
            Value<String> imageUrls = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesTableCompanion.insert(
            id: id,
            content: content,
            isFromUser: isFromUser,
            timestamp: timestamp,
            chatSessionId: chatSessionId,
            type: type,
            status: status,
            metadata: metadata,
            parentMessageId: parentMessageId,
            tokenCount: tokenCount,
            thinkingContent: thinkingContent,
            thinkingComplete: thinkingComplete,
            modelName: modelName,
            imageUrls: imageUrls,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesTableTable,
    ChatMessagesTableData,
    $$ChatMessagesTableTableFilterComposer,
    $$ChatMessagesTableTableOrderingComposer,
    $$ChatMessagesTableTableAnnotationComposer,
    $$ChatMessagesTableTableCreateCompanionBuilder,
    $$ChatMessagesTableTableUpdateCompanionBuilder,
    (
      ChatMessagesTableData,
      BaseReferences<_$AppDatabase, $ChatMessagesTableTable,
          ChatMessagesTableData>
    ),
    ChatMessagesTableData,
    PrefetchHooks Function()>;
typedef $$KnowledgeBasesTableTableCreateCompanionBuilder
    = KnowledgeBasesTableCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String?> icon,
  Value<String?> color,
  required String configId,
  Value<int> documentCount,
  Value<int> chunkCount,
  Value<bool> isDefault,
  Value<bool> isEnabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastUsedAt,
  Value<int> rowid,
});
typedef $$KnowledgeBasesTableTableUpdateCompanionBuilder
    = KnowledgeBasesTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> icon,
  Value<String?> color,
  Value<String> configId,
  Value<int> documentCount,
  Value<int> chunkCount,
  Value<bool> isDefault,
  Value<bool> isEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastUsedAt,
  Value<int> rowid,
});

class $$KnowledgeBasesTableTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeBasesTableTable> {
  $$KnowledgeBasesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configId => $composableBuilder(
      column: $table.configId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get documentCount => $composableBuilder(
      column: $table.documentCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chunkCount => $composableBuilder(
      column: $table.chunkCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));
}

class $$KnowledgeBasesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeBasesTableTable> {
  $$KnowledgeBasesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configId => $composableBuilder(
      column: $table.configId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get documentCount => $composableBuilder(
      column: $table.documentCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chunkCount => $composableBuilder(
      column: $table.chunkCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));
}

class $$KnowledgeBasesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeBasesTableTable> {
  $$KnowledgeBasesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get configId =>
      $composableBuilder(column: $table.configId, builder: (column) => column);

  GeneratedColumn<int> get documentCount => $composableBuilder(
      column: $table.documentCount, builder: (column) => column);

  GeneratedColumn<int> get chunkCount => $composableBuilder(
      column: $table.chunkCount, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);
}

class $$KnowledgeBasesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeBasesTableTable,
    KnowledgeBasesTableData,
    $$KnowledgeBasesTableTableFilterComposer,
    $$KnowledgeBasesTableTableOrderingComposer,
    $$KnowledgeBasesTableTableAnnotationComposer,
    $$KnowledgeBasesTableTableCreateCompanionBuilder,
    $$KnowledgeBasesTableTableUpdateCompanionBuilder,
    (
      KnowledgeBasesTableData,
      BaseReferences<_$AppDatabase, $KnowledgeBasesTableTable,
          KnowledgeBasesTableData>
    ),
    KnowledgeBasesTableData,
    PrefetchHooks Function()> {
  $$KnowledgeBasesTableTableTableManager(
      _$AppDatabase db, $KnowledgeBasesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeBasesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeBasesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeBasesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String> configId = const Value.absent(),
            Value<int> documentCount = const Value.absent(),
            Value<int> chunkCount = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeBasesTableCompanion(
            id: id,
            name: name,
            description: description,
            icon: icon,
            color: color,
            configId: configId,
            documentCount: documentCount,
            chunkCount: chunkCount,
            isDefault: isDefault,
            isEnabled: isEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> color = const Value.absent(),
            required String configId,
            Value<int> documentCount = const Value.absent(),
            Value<int> chunkCount = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeBasesTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            icon: icon,
            color: color,
            configId: configId,
            documentCount: documentCount,
            chunkCount: chunkCount,
            isDefault: isDefault,
            isEnabled: isEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastUsedAt: lastUsedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KnowledgeBasesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KnowledgeBasesTableTable,
    KnowledgeBasesTableData,
    $$KnowledgeBasesTableTableFilterComposer,
    $$KnowledgeBasesTableTableOrderingComposer,
    $$KnowledgeBasesTableTableAnnotationComposer,
    $$KnowledgeBasesTableTableCreateCompanionBuilder,
    $$KnowledgeBasesTableTableUpdateCompanionBuilder,
    (
      KnowledgeBasesTableData,
      BaseReferences<_$AppDatabase, $KnowledgeBasesTableTable,
          KnowledgeBasesTableData>
    ),
    KnowledgeBasesTableData,
    PrefetchHooks Function()>;
typedef $$KnowledgeDocumentsTableTableCreateCompanionBuilder
    = KnowledgeDocumentsTableCompanion Function({
  required String id,
  required String knowledgeBaseId,
  required String name,
  required String type,
  required int size,
  required String filePath,
  required String fileHash,
  Value<int> chunks,
  Value<String> status,
  Value<double> indexProgress,
  required DateTime uploadedAt,
  Value<DateTime?> processedAt,
  Value<String?> metadata,
  Value<String?> errorMessage,
  Value<int> rowid,
});
typedef $$KnowledgeDocumentsTableTableUpdateCompanionBuilder
    = KnowledgeDocumentsTableCompanion Function({
  Value<String> id,
  Value<String> knowledgeBaseId,
  Value<String> name,
  Value<String> type,
  Value<int> size,
  Value<String> filePath,
  Value<String> fileHash,
  Value<int> chunks,
  Value<String> status,
  Value<double> indexProgress,
  Value<DateTime> uploadedAt,
  Value<DateTime?> processedAt,
  Value<String?> metadata,
  Value<String?> errorMessage,
  Value<int> rowid,
});

class $$KnowledgeDocumentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeDocumentsTableTable> {
  $$KnowledgeDocumentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get knowledgeBaseId => $composableBuilder(
      column: $table.knowledgeBaseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileHash => $composableBuilder(
      column: $table.fileHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chunks => $composableBuilder(
      column: $table.chunks, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get indexProgress => $composableBuilder(
      column: $table.indexProgress, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));
}

class $$KnowledgeDocumentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeDocumentsTableTable> {
  $$KnowledgeDocumentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get knowledgeBaseId => $composableBuilder(
      column: $table.knowledgeBaseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileHash => $composableBuilder(
      column: $table.fileHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chunks => $composableBuilder(
      column: $table.chunks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get indexProgress => $composableBuilder(
      column: $table.indexProgress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadata => $composableBuilder(
      column: $table.metadata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$KnowledgeDocumentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeDocumentsTableTable> {
  $$KnowledgeDocumentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get knowledgeBaseId => $composableBuilder(
      column: $table.knowledgeBaseId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get chunks =>
      $composableBuilder(column: $table.chunks, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get indexProgress => $composableBuilder(
      column: $table.indexProgress, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);
}

class $$KnowledgeDocumentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeDocumentsTableTable,
    KnowledgeDocumentsTableData,
    $$KnowledgeDocumentsTableTableFilterComposer,
    $$KnowledgeDocumentsTableTableOrderingComposer,
    $$KnowledgeDocumentsTableTableAnnotationComposer,
    $$KnowledgeDocumentsTableTableCreateCompanionBuilder,
    $$KnowledgeDocumentsTableTableUpdateCompanionBuilder,
    (
      KnowledgeDocumentsTableData,
      BaseReferences<_$AppDatabase, $KnowledgeDocumentsTableTable,
          KnowledgeDocumentsTableData>
    ),
    KnowledgeDocumentsTableData,
    PrefetchHooks Function()> {
  $$KnowledgeDocumentsTableTableTableManager(
      _$AppDatabase db, $KnowledgeDocumentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeDocumentsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeDocumentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeDocumentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> knowledgeBaseId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> size = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> fileHash = const Value.absent(),
            Value<int> chunks = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> indexProgress = const Value.absent(),
            Value<DateTime> uploadedAt = const Value.absent(),
            Value<DateTime?> processedAt = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeDocumentsTableCompanion(
            id: id,
            knowledgeBaseId: knowledgeBaseId,
            name: name,
            type: type,
            size: size,
            filePath: filePath,
            fileHash: fileHash,
            chunks: chunks,
            status: status,
            indexProgress: indexProgress,
            uploadedAt: uploadedAt,
            processedAt: processedAt,
            metadata: metadata,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String knowledgeBaseId,
            required String name,
            required String type,
            required int size,
            required String filePath,
            required String fileHash,
            Value<int> chunks = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> indexProgress = const Value.absent(),
            required DateTime uploadedAt,
            Value<DateTime?> processedAt = const Value.absent(),
            Value<String?> metadata = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeDocumentsTableCompanion.insert(
            id: id,
            knowledgeBaseId: knowledgeBaseId,
            name: name,
            type: type,
            size: size,
            filePath: filePath,
            fileHash: fileHash,
            chunks: chunks,
            status: status,
            indexProgress: indexProgress,
            uploadedAt: uploadedAt,
            processedAt: processedAt,
            metadata: metadata,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KnowledgeDocumentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $KnowledgeDocumentsTableTable,
        KnowledgeDocumentsTableData,
        $$KnowledgeDocumentsTableTableFilterComposer,
        $$KnowledgeDocumentsTableTableOrderingComposer,
        $$KnowledgeDocumentsTableTableAnnotationComposer,
        $$KnowledgeDocumentsTableTableCreateCompanionBuilder,
        $$KnowledgeDocumentsTableTableUpdateCompanionBuilder,
        (
          KnowledgeDocumentsTableData,
          BaseReferences<_$AppDatabase, $KnowledgeDocumentsTableTable,
              KnowledgeDocumentsTableData>
        ),
        KnowledgeDocumentsTableData,
        PrefetchHooks Function()>;
typedef $$KnowledgeChunksTableTableCreateCompanionBuilder
    = KnowledgeChunksTableCompanion Function({
  required String id,
  required String knowledgeBaseId,
  required String documentId,
  required String content,
  required int chunkIndex,
  required int characterCount,
  required int tokenCount,
  Value<String?> embedding,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$KnowledgeChunksTableTableUpdateCompanionBuilder
    = KnowledgeChunksTableCompanion Function({
  Value<String> id,
  Value<String> knowledgeBaseId,
  Value<String> documentId,
  Value<String> content,
  Value<int> chunkIndex,
  Value<int> characterCount,
  Value<int> tokenCount,
  Value<String?> embedding,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$KnowledgeChunksTableTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeChunksTableTable> {
  $$KnowledgeChunksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get knowledgeBaseId => $composableBuilder(
      column: $table.knowledgeBaseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chunkIndex => $composableBuilder(
      column: $table.chunkIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get characterCount => $composableBuilder(
      column: $table.characterCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get embedding => $composableBuilder(
      column: $table.embedding, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$KnowledgeChunksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeChunksTableTable> {
  $$KnowledgeChunksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get knowledgeBaseId => $composableBuilder(
      column: $table.knowledgeBaseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chunkIndex => $composableBuilder(
      column: $table.chunkIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get characterCount => $composableBuilder(
      column: $table.characterCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get embedding => $composableBuilder(
      column: $table.embedding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$KnowledgeChunksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeChunksTableTable> {
  $$KnowledgeChunksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get knowledgeBaseId => $composableBuilder(
      column: $table.knowledgeBaseId, builder: (column) => column);

  GeneratedColumn<String> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get chunkIndex => $composableBuilder(
      column: $table.chunkIndex, builder: (column) => column);

  GeneratedColumn<int> get characterCount => $composableBuilder(
      column: $table.characterCount, builder: (column) => column);

  GeneratedColumn<int> get tokenCount => $composableBuilder(
      column: $table.tokenCount, builder: (column) => column);

  GeneratedColumn<String> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$KnowledgeChunksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeChunksTableTable,
    KnowledgeChunksTableData,
    $$KnowledgeChunksTableTableFilterComposer,
    $$KnowledgeChunksTableTableOrderingComposer,
    $$KnowledgeChunksTableTableAnnotationComposer,
    $$KnowledgeChunksTableTableCreateCompanionBuilder,
    $$KnowledgeChunksTableTableUpdateCompanionBuilder,
    (
      KnowledgeChunksTableData,
      BaseReferences<_$AppDatabase, $KnowledgeChunksTableTable,
          KnowledgeChunksTableData>
    ),
    KnowledgeChunksTableData,
    PrefetchHooks Function()> {
  $$KnowledgeChunksTableTableTableManager(
      _$AppDatabase db, $KnowledgeChunksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeChunksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeChunksTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeChunksTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> knowledgeBaseId = const Value.absent(),
            Value<String> documentId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> chunkIndex = const Value.absent(),
            Value<int> characterCount = const Value.absent(),
            Value<int> tokenCount = const Value.absent(),
            Value<String?> embedding = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeChunksTableCompanion(
            id: id,
            knowledgeBaseId: knowledgeBaseId,
            documentId: documentId,
            content: content,
            chunkIndex: chunkIndex,
            characterCount: characterCount,
            tokenCount: tokenCount,
            embedding: embedding,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String knowledgeBaseId,
            required String documentId,
            required String content,
            required int chunkIndex,
            required int characterCount,
            required int tokenCount,
            Value<String?> embedding = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeChunksTableCompanion.insert(
            id: id,
            knowledgeBaseId: knowledgeBaseId,
            documentId: documentId,
            content: content,
            chunkIndex: chunkIndex,
            characterCount: characterCount,
            tokenCount: tokenCount,
            embedding: embedding,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KnowledgeChunksTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $KnowledgeChunksTableTable,
        KnowledgeChunksTableData,
        $$KnowledgeChunksTableTableFilterComposer,
        $$KnowledgeChunksTableTableOrderingComposer,
        $$KnowledgeChunksTableTableAnnotationComposer,
        $$KnowledgeChunksTableTableCreateCompanionBuilder,
        $$KnowledgeChunksTableTableUpdateCompanionBuilder,
        (
          KnowledgeChunksTableData,
          BaseReferences<_$AppDatabase, $KnowledgeChunksTableTable,
              KnowledgeChunksTableData>
        ),
        KnowledgeChunksTableData,
        PrefetchHooks Function()>;
typedef $$KnowledgeBaseConfigsTableTableCreateCompanionBuilder
    = KnowledgeBaseConfigsTableCompanion Function({
  required String id,
  required String name,
  required String embeddingModelId,
  required String embeddingModelName,
  required String embeddingModelProvider,
  Value<int?> embeddingDimension,
  Value<int> chunkSize,
  Value<int> chunkOverlap,
  Value<int> maxRetrievedChunks,
  Value<double> similarityThreshold,
  Value<bool> isDefault,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$KnowledgeBaseConfigsTableTableUpdateCompanionBuilder
    = KnowledgeBaseConfigsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> embeddingModelId,
  Value<String> embeddingModelName,
  Value<String> embeddingModelProvider,
  Value<int?> embeddingDimension,
  Value<int> chunkSize,
  Value<int> chunkOverlap,
  Value<int> maxRetrievedChunks,
  Value<double> similarityThreshold,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$KnowledgeBaseConfigsTableTableFilterComposer
    extends Composer<_$AppDatabase, $KnowledgeBaseConfigsTableTable> {
  $$KnowledgeBaseConfigsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get embeddingModelId => $composableBuilder(
      column: $table.embeddingModelId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get embeddingModelName => $composableBuilder(
      column: $table.embeddingModelName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get embeddingModelProvider => $composableBuilder(
      column: $table.embeddingModelProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get embeddingDimension => $composableBuilder(
      column: $table.embeddingDimension,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chunkSize => $composableBuilder(
      column: $table.chunkSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chunkOverlap => $composableBuilder(
      column: $table.chunkOverlap, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxRetrievedChunks => $composableBuilder(
      column: $table.maxRetrievedChunks,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get similarityThreshold => $composableBuilder(
      column: $table.similarityThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$KnowledgeBaseConfigsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KnowledgeBaseConfigsTableTable> {
  $$KnowledgeBaseConfigsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get embeddingModelId => $composableBuilder(
      column: $table.embeddingModelId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get embeddingModelName => $composableBuilder(
      column: $table.embeddingModelName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get embeddingModelProvider => $composableBuilder(
      column: $table.embeddingModelProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get embeddingDimension => $composableBuilder(
      column: $table.embeddingDimension,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chunkSize => $composableBuilder(
      column: $table.chunkSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chunkOverlap => $composableBuilder(
      column: $table.chunkOverlap,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxRetrievedChunks => $composableBuilder(
      column: $table.maxRetrievedChunks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get similarityThreshold => $composableBuilder(
      column: $table.similarityThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$KnowledgeBaseConfigsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnowledgeBaseConfigsTableTable> {
  $$KnowledgeBaseConfigsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get embeddingModelId => $composableBuilder(
      column: $table.embeddingModelId, builder: (column) => column);

  GeneratedColumn<String> get embeddingModelName => $composableBuilder(
      column: $table.embeddingModelName, builder: (column) => column);

  GeneratedColumn<String> get embeddingModelProvider => $composableBuilder(
      column: $table.embeddingModelProvider, builder: (column) => column);

  GeneratedColumn<int> get embeddingDimension => $composableBuilder(
      column: $table.embeddingDimension, builder: (column) => column);

  GeneratedColumn<int> get chunkSize =>
      $composableBuilder(column: $table.chunkSize, builder: (column) => column);

  GeneratedColumn<int> get chunkOverlap => $composableBuilder(
      column: $table.chunkOverlap, builder: (column) => column);

  GeneratedColumn<int> get maxRetrievedChunks => $composableBuilder(
      column: $table.maxRetrievedChunks, builder: (column) => column);

  GeneratedColumn<double> get similarityThreshold => $composableBuilder(
      column: $table.similarityThreshold, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KnowledgeBaseConfigsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnowledgeBaseConfigsTableTable,
    KnowledgeBaseConfigsTableData,
    $$KnowledgeBaseConfigsTableTableFilterComposer,
    $$KnowledgeBaseConfigsTableTableOrderingComposer,
    $$KnowledgeBaseConfigsTableTableAnnotationComposer,
    $$KnowledgeBaseConfigsTableTableCreateCompanionBuilder,
    $$KnowledgeBaseConfigsTableTableUpdateCompanionBuilder,
    (
      KnowledgeBaseConfigsTableData,
      BaseReferences<_$AppDatabase, $KnowledgeBaseConfigsTableTable,
          KnowledgeBaseConfigsTableData>
    ),
    KnowledgeBaseConfigsTableData,
    PrefetchHooks Function()> {
  $$KnowledgeBaseConfigsTableTableTableManager(
      _$AppDatabase db, $KnowledgeBaseConfigsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnowledgeBaseConfigsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$KnowledgeBaseConfigsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnowledgeBaseConfigsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> embeddingModelId = const Value.absent(),
            Value<String> embeddingModelName = const Value.absent(),
            Value<String> embeddingModelProvider = const Value.absent(),
            Value<int?> embeddingDimension = const Value.absent(),
            Value<int> chunkSize = const Value.absent(),
            Value<int> chunkOverlap = const Value.absent(),
            Value<int> maxRetrievedChunks = const Value.absent(),
            Value<double> similarityThreshold = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeBaseConfigsTableCompanion(
            id: id,
            name: name,
            embeddingModelId: embeddingModelId,
            embeddingModelName: embeddingModelName,
            embeddingModelProvider: embeddingModelProvider,
            embeddingDimension: embeddingDimension,
            chunkSize: chunkSize,
            chunkOverlap: chunkOverlap,
            maxRetrievedChunks: maxRetrievedChunks,
            similarityThreshold: similarityThreshold,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String embeddingModelId,
            required String embeddingModelName,
            required String embeddingModelProvider,
            Value<int?> embeddingDimension = const Value.absent(),
            Value<int> chunkSize = const Value.absent(),
            Value<int> chunkOverlap = const Value.absent(),
            Value<int> maxRetrievedChunks = const Value.absent(),
            Value<double> similarityThreshold = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              KnowledgeBaseConfigsTableCompanion.insert(
            id: id,
            name: name,
            embeddingModelId: embeddingModelId,
            embeddingModelName: embeddingModelName,
            embeddingModelProvider: embeddingModelProvider,
            embeddingDimension: embeddingDimension,
            chunkSize: chunkSize,
            chunkOverlap: chunkOverlap,
            maxRetrievedChunks: maxRetrievedChunks,
            similarityThreshold: similarityThreshold,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KnowledgeBaseConfigsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $KnowledgeBaseConfigsTableTable,
        KnowledgeBaseConfigsTableData,
        $$KnowledgeBaseConfigsTableTableFilterComposer,
        $$KnowledgeBaseConfigsTableTableOrderingComposer,
        $$KnowledgeBaseConfigsTableTableAnnotationComposer,
        $$KnowledgeBaseConfigsTableTableCreateCompanionBuilder,
        $$KnowledgeBaseConfigsTableTableUpdateCompanionBuilder,
        (
          KnowledgeBaseConfigsTableData,
          BaseReferences<_$AppDatabase, $KnowledgeBaseConfigsTableTable,
              KnowledgeBaseConfigsTableData>
        ),
        KnowledgeBaseConfigsTableData,
        PrefetchHooks Function()>;
typedef $$CustomModelsTableTableCreateCompanionBuilder
    = CustomModelsTableCompanion Function({
  required String id,
  required String name,
  required String modelId,
  Value<String?> configId,
  required String provider,
  Value<String?> description,
  required String type,
  Value<int?> contextWindow,
  Value<int?> maxOutputTokens,
  Value<bool> supportsStreaming,
  Value<bool> supportsFunctionCalling,
  Value<bool> supportsVision,
  Value<double?> inputPrice,
  Value<double?> outputPrice,
  Value<String> currency,
  Value<String?> capabilities,
  Value<bool> isBuiltIn,
  Value<bool> isEnabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CustomModelsTableTableUpdateCompanionBuilder
    = CustomModelsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> modelId,
  Value<String?> configId,
  Value<String> provider,
  Value<String?> description,
  Value<String> type,
  Value<int?> contextWindow,
  Value<int?> maxOutputTokens,
  Value<bool> supportsStreaming,
  Value<bool> supportsFunctionCalling,
  Value<bool> supportsVision,
  Value<double?> inputPrice,
  Value<double?> outputPrice,
  Value<String> currency,
  Value<String?> capabilities,
  Value<bool> isBuiltIn,
  Value<bool> isEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CustomModelsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CustomModelsTableTable> {
  $$CustomModelsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configId => $composableBuilder(
      column: $table.configId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get contextWindow => $composableBuilder(
      column: $table.contextWindow, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxOutputTokens => $composableBuilder(
      column: $table.maxOutputTokens,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get supportsStreaming => $composableBuilder(
      column: $table.supportsStreaming,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get supportsFunctionCalling => $composableBuilder(
      column: $table.supportsFunctionCalling,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get supportsVision => $composableBuilder(
      column: $table.supportsVision,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get inputPrice => $composableBuilder(
      column: $table.inputPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get outputPrice => $composableBuilder(
      column: $table.outputPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get capabilities => $composableBuilder(
      column: $table.capabilities, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
      column: $table.isBuiltIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CustomModelsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomModelsTableTable> {
  $$CustomModelsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelId => $composableBuilder(
      column: $table.modelId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configId => $composableBuilder(
      column: $table.configId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get contextWindow => $composableBuilder(
      column: $table.contextWindow,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxOutputTokens => $composableBuilder(
      column: $table.maxOutputTokens,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get supportsStreaming => $composableBuilder(
      column: $table.supportsStreaming,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get supportsFunctionCalling => $composableBuilder(
      column: $table.supportsFunctionCalling,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get supportsVision => $composableBuilder(
      column: $table.supportsVision,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get inputPrice => $composableBuilder(
      column: $table.inputPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get outputPrice => $composableBuilder(
      column: $table.outputPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get capabilities => $composableBuilder(
      column: $table.capabilities,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
      column: $table.isBuiltIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomModelsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomModelsTableTable> {
  $$CustomModelsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get modelId =>
      $composableBuilder(column: $table.modelId, builder: (column) => column);

  GeneratedColumn<String> get configId =>
      $composableBuilder(column: $table.configId, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get contextWindow => $composableBuilder(
      column: $table.contextWindow, builder: (column) => column);

  GeneratedColumn<int> get maxOutputTokens => $composableBuilder(
      column: $table.maxOutputTokens, builder: (column) => column);

  GeneratedColumn<bool> get supportsStreaming => $composableBuilder(
      column: $table.supportsStreaming, builder: (column) => column);

  GeneratedColumn<bool> get supportsFunctionCalling => $composableBuilder(
      column: $table.supportsFunctionCalling, builder: (column) => column);

  GeneratedColumn<bool> get supportsVision => $composableBuilder(
      column: $table.supportsVision, builder: (column) => column);

  GeneratedColumn<double> get inputPrice => $composableBuilder(
      column: $table.inputPrice, builder: (column) => column);

  GeneratedColumn<double> get outputPrice => $composableBuilder(
      column: $table.outputPrice, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get capabilities => $composableBuilder(
      column: $table.capabilities, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomModelsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomModelsTableTable,
    CustomModelsTableData,
    $$CustomModelsTableTableFilterComposer,
    $$CustomModelsTableTableOrderingComposer,
    $$CustomModelsTableTableAnnotationComposer,
    $$CustomModelsTableTableCreateCompanionBuilder,
    $$CustomModelsTableTableUpdateCompanionBuilder,
    (
      CustomModelsTableData,
      BaseReferences<_$AppDatabase, $CustomModelsTableTable,
          CustomModelsTableData>
    ),
    CustomModelsTableData,
    PrefetchHooks Function()> {
  $$CustomModelsTableTableTableManager(
      _$AppDatabase db, $CustomModelsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomModelsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomModelsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomModelsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> modelId = const Value.absent(),
            Value<String?> configId = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int?> contextWindow = const Value.absent(),
            Value<int?> maxOutputTokens = const Value.absent(),
            Value<bool> supportsStreaming = const Value.absent(),
            Value<bool> supportsFunctionCalling = const Value.absent(),
            Value<bool> supportsVision = const Value.absent(),
            Value<double?> inputPrice = const Value.absent(),
            Value<double?> outputPrice = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> capabilities = const Value.absent(),
            Value<bool> isBuiltIn = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomModelsTableCompanion(
            id: id,
            name: name,
            modelId: modelId,
            configId: configId,
            provider: provider,
            description: description,
            type: type,
            contextWindow: contextWindow,
            maxOutputTokens: maxOutputTokens,
            supportsStreaming: supportsStreaming,
            supportsFunctionCalling: supportsFunctionCalling,
            supportsVision: supportsVision,
            inputPrice: inputPrice,
            outputPrice: outputPrice,
            currency: currency,
            capabilities: capabilities,
            isBuiltIn: isBuiltIn,
            isEnabled: isEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String modelId,
            Value<String?> configId = const Value.absent(),
            required String provider,
            Value<String?> description = const Value.absent(),
            required String type,
            Value<int?> contextWindow = const Value.absent(),
            Value<int?> maxOutputTokens = const Value.absent(),
            Value<bool> supportsStreaming = const Value.absent(),
            Value<bool> supportsFunctionCalling = const Value.absent(),
            Value<bool> supportsVision = const Value.absent(),
            Value<double?> inputPrice = const Value.absent(),
            Value<double?> outputPrice = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> capabilities = const Value.absent(),
            Value<bool> isBuiltIn = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomModelsTableCompanion.insert(
            id: id,
            name: name,
            modelId: modelId,
            configId: configId,
            provider: provider,
            description: description,
            type: type,
            contextWindow: contextWindow,
            maxOutputTokens: maxOutputTokens,
            supportsStreaming: supportsStreaming,
            supportsFunctionCalling: supportsFunctionCalling,
            supportsVision: supportsVision,
            inputPrice: inputPrice,
            outputPrice: outputPrice,
            currency: currency,
            capabilities: capabilities,
            isBuiltIn: isBuiltIn,
            isEnabled: isEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomModelsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomModelsTableTable,
    CustomModelsTableData,
    $$CustomModelsTableTableFilterComposer,
    $$CustomModelsTableTableOrderingComposer,
    $$CustomModelsTableTableAnnotationComposer,
    $$CustomModelsTableTableCreateCompanionBuilder,
    $$CustomModelsTableTableUpdateCompanionBuilder,
    (
      CustomModelsTableData,
      BaseReferences<_$AppDatabase, $CustomModelsTableTable,
          CustomModelsTableData>
    ),
    CustomModelsTableData,
    PrefetchHooks Function()>;
typedef $$GeneralSettingsTableTableCreateCompanionBuilder
    = GeneralSettingsTableCompanion Function({
  required String key,
  required String value,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$GeneralSettingsTableTableUpdateCompanionBuilder
    = GeneralSettingsTableCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$GeneralSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GeneralSettingsTableTable> {
  $$GeneralSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$GeneralSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneralSettingsTableTable> {
  $$GeneralSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$GeneralSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneralSettingsTableTable> {
  $$GeneralSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GeneralSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GeneralSettingsTableTable,
    GeneralSettingsTableData,
    $$GeneralSettingsTableTableFilterComposer,
    $$GeneralSettingsTableTableOrderingComposer,
    $$GeneralSettingsTableTableAnnotationComposer,
    $$GeneralSettingsTableTableCreateCompanionBuilder,
    $$GeneralSettingsTableTableUpdateCompanionBuilder,
    (
      GeneralSettingsTableData,
      BaseReferences<_$AppDatabase, $GeneralSettingsTableTable,
          GeneralSettingsTableData>
    ),
    GeneralSettingsTableData,
    PrefetchHooks Function()> {
  $$GeneralSettingsTableTableTableManager(
      _$AppDatabase db, $GeneralSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneralSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneralSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneralSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GeneralSettingsTableCompanion(
            key: key,
            value: value,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GeneralSettingsTableCompanion.insert(
            key: key,
            value: value,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GeneralSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $GeneralSettingsTableTable,
        GeneralSettingsTableData,
        $$GeneralSettingsTableTableFilterComposer,
        $$GeneralSettingsTableTableOrderingComposer,
        $$GeneralSettingsTableTableAnnotationComposer,
        $$GeneralSettingsTableTableCreateCompanionBuilder,
        $$GeneralSettingsTableTableUpdateCompanionBuilder,
        (
          GeneralSettingsTableData,
          BaseReferences<_$AppDatabase, $GeneralSettingsTableTable,
              GeneralSettingsTableData>
        ),
        GeneralSettingsTableData,
        PrefetchHooks Function()>;
typedef $$McpServersTableTableCreateCompanionBuilder = McpServersTableCompanion
    Function({
  required String id,
  required String name,
  required String baseUrl,
  required String type,
  Value<String?> headers,
  Value<int?> timeout,
  Value<bool> longRunning,
  Value<bool> disabled,
  Value<String?> error,
  Value<String?> clientId,
  Value<String?> clientSecret,
  Value<String?> authorizationEndpoint,
  Value<String?> tokenEndpoint,
  Value<bool> isConnected,
  Value<DateTime?> lastConnected,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$McpServersTableTableUpdateCompanionBuilder = McpServersTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> baseUrl,
  Value<String> type,
  Value<String?> headers,
  Value<int?> timeout,
  Value<bool> longRunning,
  Value<bool> disabled,
  Value<String?> error,
  Value<String?> clientId,
  Value<String?> clientSecret,
  Value<String?> authorizationEndpoint,
  Value<String?> tokenEndpoint,
  Value<bool> isConnected,
  Value<DateTime?> lastConnected,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$McpServersTableTableReferences extends BaseReferences<
    _$AppDatabase, $McpServersTableTable, McpServersTableData> {
  $$McpServersTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$McpConnectionsTableTable,
      List<McpConnectionsTableData>> _mcpConnectionsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mcpConnectionsTable,
          aliasName: $_aliasNameGenerator(
              db.mcpServersTable.id, db.mcpConnectionsTable.serverId));

  $$McpConnectionsTableTableProcessedTableManager get mcpConnectionsTableRefs {
    final manager =
        $$McpConnectionsTableTableTableManager($_db, $_db.mcpConnectionsTable)
            .filter((f) => f.serverId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mcpConnectionsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$McpToolsTableTable, List<McpToolsTableData>>
      _mcpToolsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.mcpToolsTable,
              aliasName: $_aliasNameGenerator(
                  db.mcpServersTable.id, db.mcpToolsTable.serverId));

  $$McpToolsTableTableProcessedTableManager get mcpToolsTableRefs {
    final manager = $$McpToolsTableTableTableManager($_db, $_db.mcpToolsTable)
        .filter((f) => f.serverId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_mcpToolsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$McpCallHistoryTableTable,
      List<McpCallHistoryTableData>> _mcpCallHistoryTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mcpCallHistoryTable,
          aliasName: $_aliasNameGenerator(
              db.mcpServersTable.id, db.mcpCallHistoryTable.serverId));

  $$McpCallHistoryTableTableProcessedTableManager get mcpCallHistoryTableRefs {
    final manager =
        $$McpCallHistoryTableTableTableManager($_db, $_db.mcpCallHistoryTable)
            .filter((f) => f.serverId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mcpCallHistoryTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$McpResourcesTableTable,
      List<McpResourcesTableData>> _mcpResourcesTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mcpResourcesTable,
          aliasName: $_aliasNameGenerator(
              db.mcpServersTable.id, db.mcpResourcesTable.serverId));

  $$McpResourcesTableTableProcessedTableManager get mcpResourcesTableRefs {
    final manager =
        $$McpResourcesTableTableTableManager($_db, $_db.mcpResourcesTable)
            .filter((f) => f.serverId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mcpResourcesTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$McpOAuthTokensTableTable,
      List<McpOAuthTokensTableData>> _mcpOAuthTokensTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mcpOAuthTokensTable,
          aliasName: $_aliasNameGenerator(
              db.mcpServersTable.id, db.mcpOAuthTokensTable.serverId));

  $$McpOAuthTokensTableTableProcessedTableManager get mcpOAuthTokensTableRefs {
    final manager =
        $$McpOAuthTokensTableTableTableManager($_db, $_db.mcpOAuthTokensTable)
            .filter((f) => f.serverId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_mcpOAuthTokensTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$McpServersTableTableFilterComposer
    extends Composer<_$AppDatabase, $McpServersTableTable> {
  $$McpServersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get headers => $composableBuilder(
      column: $table.headers, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timeout => $composableBuilder(
      column: $table.timeout, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get longRunning => $composableBuilder(
      column: $table.longRunning, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get disabled => $composableBuilder(
      column: $table.disabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientSecret => $composableBuilder(
      column: $table.clientSecret, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorizationEndpoint => $composableBuilder(
      column: $table.authorizationEndpoint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tokenEndpoint => $composableBuilder(
      column: $table.tokenEndpoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastConnected => $composableBuilder(
      column: $table.lastConnected, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> mcpConnectionsTableRefs(
      Expression<bool> Function($$McpConnectionsTableTableFilterComposer f) f) {
    final $$McpConnectionsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mcpConnectionsTable,
        getReferencedColumn: (t) => t.serverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpConnectionsTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpConnectionsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mcpToolsTableRefs(
      Expression<bool> Function($$McpToolsTableTableFilterComposer f) f) {
    final $$McpToolsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mcpToolsTable,
        getReferencedColumn: (t) => t.serverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpToolsTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpToolsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mcpCallHistoryTableRefs(
      Expression<bool> Function($$McpCallHistoryTableTableFilterComposer f) f) {
    final $$McpCallHistoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mcpCallHistoryTable,
        getReferencedColumn: (t) => t.serverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpCallHistoryTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpCallHistoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mcpResourcesTableRefs(
      Expression<bool> Function($$McpResourcesTableTableFilterComposer f) f) {
    final $$McpResourcesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mcpResourcesTable,
        getReferencedColumn: (t) => t.serverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpResourcesTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpResourcesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mcpOAuthTokensTableRefs(
      Expression<bool> Function($$McpOAuthTokensTableTableFilterComposer f) f) {
    final $$McpOAuthTokensTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mcpOAuthTokensTable,
        getReferencedColumn: (t) => t.serverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpOAuthTokensTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpOAuthTokensTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$McpServersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $McpServersTableTable> {
  $$McpServersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get headers => $composableBuilder(
      column: $table.headers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timeout => $composableBuilder(
      column: $table.timeout, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get longRunning => $composableBuilder(
      column: $table.longRunning, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get disabled => $composableBuilder(
      column: $table.disabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientId => $composableBuilder(
      column: $table.clientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientSecret => $composableBuilder(
      column: $table.clientSecret,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorizationEndpoint => $composableBuilder(
      column: $table.authorizationEndpoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tokenEndpoint => $composableBuilder(
      column: $table.tokenEndpoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastConnected => $composableBuilder(
      column: $table.lastConnected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$McpServersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $McpServersTableTable> {
  $$McpServersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get headers =>
      $composableBuilder(column: $table.headers, builder: (column) => column);

  GeneratedColumn<int> get timeout =>
      $composableBuilder(column: $table.timeout, builder: (column) => column);

  GeneratedColumn<bool> get longRunning => $composableBuilder(
      column: $table.longRunning, builder: (column) => column);

  GeneratedColumn<bool> get disabled =>
      $composableBuilder(column: $table.disabled, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get clientSecret => $composableBuilder(
      column: $table.clientSecret, builder: (column) => column);

  GeneratedColumn<String> get authorizationEndpoint => $composableBuilder(
      column: $table.authorizationEndpoint, builder: (column) => column);

  GeneratedColumn<String> get tokenEndpoint => $composableBuilder(
      column: $table.tokenEndpoint, builder: (column) => column);

  GeneratedColumn<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => column);

  GeneratedColumn<DateTime> get lastConnected => $composableBuilder(
      column: $table.lastConnected, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> mcpConnectionsTableRefs<T extends Object>(
      Expression<T> Function($$McpConnectionsTableTableAnnotationComposer a)
          f) {
    final $$McpConnectionsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mcpConnectionsTable,
            getReferencedColumn: (t) => t.serverId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$McpConnectionsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mcpConnectionsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> mcpToolsTableRefs<T extends Object>(
      Expression<T> Function($$McpToolsTableTableAnnotationComposer a) f) {
    final $$McpToolsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mcpToolsTable,
        getReferencedColumn: (t) => t.serverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpToolsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mcpToolsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mcpCallHistoryTableRefs<T extends Object>(
      Expression<T> Function($$McpCallHistoryTableTableAnnotationComposer a)
          f) {
    final $$McpCallHistoryTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mcpCallHistoryTable,
            getReferencedColumn: (t) => t.serverId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$McpCallHistoryTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mcpCallHistoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> mcpResourcesTableRefs<T extends Object>(
      Expression<T> Function($$McpResourcesTableTableAnnotationComposer a) f) {
    final $$McpResourcesTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mcpResourcesTable,
            getReferencedColumn: (t) => t.serverId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$McpResourcesTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mcpResourcesTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> mcpOAuthTokensTableRefs<T extends Object>(
      Expression<T> Function($$McpOAuthTokensTableTableAnnotationComposer a)
          f) {
    final $$McpOAuthTokensTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.mcpOAuthTokensTable,
            getReferencedColumn: (t) => t.serverId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$McpOAuthTokensTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mcpOAuthTokensTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$McpServersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $McpServersTableTable,
    McpServersTableData,
    $$McpServersTableTableFilterComposer,
    $$McpServersTableTableOrderingComposer,
    $$McpServersTableTableAnnotationComposer,
    $$McpServersTableTableCreateCompanionBuilder,
    $$McpServersTableTableUpdateCompanionBuilder,
    (McpServersTableData, $$McpServersTableTableReferences),
    McpServersTableData,
    PrefetchHooks Function(
        {bool mcpConnectionsTableRefs,
        bool mcpToolsTableRefs,
        bool mcpCallHistoryTableRefs,
        bool mcpResourcesTableRefs,
        bool mcpOAuthTokensTableRefs})> {
  $$McpServersTableTableTableManager(
      _$AppDatabase db, $McpServersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McpServersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McpServersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McpServersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> baseUrl = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> headers = const Value.absent(),
            Value<int?> timeout = const Value.absent(),
            Value<bool> longRunning = const Value.absent(),
            Value<bool> disabled = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<String?> clientId = const Value.absent(),
            Value<String?> clientSecret = const Value.absent(),
            Value<String?> authorizationEndpoint = const Value.absent(),
            Value<String?> tokenEndpoint = const Value.absent(),
            Value<bool> isConnected = const Value.absent(),
            Value<DateTime?> lastConnected = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              McpServersTableCompanion(
            id: id,
            name: name,
            baseUrl: baseUrl,
            type: type,
            headers: headers,
            timeout: timeout,
            longRunning: longRunning,
            disabled: disabled,
            error: error,
            clientId: clientId,
            clientSecret: clientSecret,
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint,
            isConnected: isConnected,
            lastConnected: lastConnected,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String baseUrl,
            required String type,
            Value<String?> headers = const Value.absent(),
            Value<int?> timeout = const Value.absent(),
            Value<bool> longRunning = const Value.absent(),
            Value<bool> disabled = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<String?> clientId = const Value.absent(),
            Value<String?> clientSecret = const Value.absent(),
            Value<String?> authorizationEndpoint = const Value.absent(),
            Value<String?> tokenEndpoint = const Value.absent(),
            Value<bool> isConnected = const Value.absent(),
            Value<DateTime?> lastConnected = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              McpServersTableCompanion.insert(
            id: id,
            name: name,
            baseUrl: baseUrl,
            type: type,
            headers: headers,
            timeout: timeout,
            longRunning: longRunning,
            disabled: disabled,
            error: error,
            clientId: clientId,
            clientSecret: clientSecret,
            authorizationEndpoint: authorizationEndpoint,
            tokenEndpoint: tokenEndpoint,
            isConnected: isConnected,
            lastConnected: lastConnected,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$McpServersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {mcpConnectionsTableRefs = false,
              mcpToolsTableRefs = false,
              mcpCallHistoryTableRefs = false,
              mcpResourcesTableRefs = false,
              mcpOAuthTokensTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mcpConnectionsTableRefs) db.mcpConnectionsTable,
                if (mcpToolsTableRefs) db.mcpToolsTable,
                if (mcpCallHistoryTableRefs) db.mcpCallHistoryTable,
                if (mcpResourcesTableRefs) db.mcpResourcesTable,
                if (mcpOAuthTokensTableRefs) db.mcpOAuthTokensTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mcpConnectionsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$McpServersTableTableReferences
                            ._mcpConnectionsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$McpServersTableTableReferences(db, table, p0)
                                .mcpConnectionsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.serverId == item.id),
                        typedResults: items),
                  if (mcpToolsTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$McpServersTableTableReferences
                            ._mcpToolsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$McpServersTableTableReferences(db, table, p0)
                                .mcpToolsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.serverId == item.id),
                        typedResults: items),
                  if (mcpCallHistoryTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$McpServersTableTableReferences
                            ._mcpCallHistoryTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$McpServersTableTableReferences(db, table, p0)
                                .mcpCallHistoryTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.serverId == item.id),
                        typedResults: items),
                  if (mcpResourcesTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$McpServersTableTableReferences
                            ._mcpResourcesTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$McpServersTableTableReferences(db, table, p0)
                                .mcpResourcesTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.serverId == item.id),
                        typedResults: items),
                  if (mcpOAuthTokensTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$McpServersTableTableReferences
                            ._mcpOAuthTokensTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$McpServersTableTableReferences(db, table, p0)
                                .mcpOAuthTokensTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.serverId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$McpServersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $McpServersTableTable,
    McpServersTableData,
    $$McpServersTableTableFilterComposer,
    $$McpServersTableTableOrderingComposer,
    $$McpServersTableTableAnnotationComposer,
    $$McpServersTableTableCreateCompanionBuilder,
    $$McpServersTableTableUpdateCompanionBuilder,
    (McpServersTableData, $$McpServersTableTableReferences),
    McpServersTableData,
    PrefetchHooks Function(
        {bool mcpConnectionsTableRefs,
        bool mcpToolsTableRefs,
        bool mcpCallHistoryTableRefs,
        bool mcpResourcesTableRefs,
        bool mcpOAuthTokensTableRefs})>;
typedef $$McpConnectionsTableTableCreateCompanionBuilder
    = McpConnectionsTableCompanion Function({
  Value<int> id,
  required String serverId,
  required bool isConnected,
  required DateTime lastCheck,
  Value<int?> latency,
  Value<String?> error,
  Value<String?> serverName,
  Value<String?> serverVersion,
  Value<String?> protocolVersion,
  Value<int?> toolsCount,
  Value<int?> resourcesCount,
  Value<int?> promptsCount,
  Value<DateTime> recordedAt,
});
typedef $$McpConnectionsTableTableUpdateCompanionBuilder
    = McpConnectionsTableCompanion Function({
  Value<int> id,
  Value<String> serverId,
  Value<bool> isConnected,
  Value<DateTime> lastCheck,
  Value<int?> latency,
  Value<String?> error,
  Value<String?> serverName,
  Value<String?> serverVersion,
  Value<String?> protocolVersion,
  Value<int?> toolsCount,
  Value<int?> resourcesCount,
  Value<int?> promptsCount,
  Value<DateTime> recordedAt,
});

final class $$McpConnectionsTableTableReferences extends BaseReferences<
    _$AppDatabase, $McpConnectionsTableTable, McpConnectionsTableData> {
  $$McpConnectionsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $McpServersTableTable _serverIdTable(_$AppDatabase db) =>
      db.mcpServersTable.createAlias($_aliasNameGenerator(
          db.mcpConnectionsTable.serverId, db.mcpServersTable.id));

  $$McpServersTableTableProcessedTableManager? get serverId {
    if ($_item.serverId == null) return null;
    final manager =
        $$McpServersTableTableTableManager($_db, $_db.mcpServersTable)
            .filter((f) => f.id($_item.serverId!));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$McpConnectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $McpConnectionsTableTable> {
  $$McpConnectionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCheck => $composableBuilder(
      column: $table.lastCheck, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get latency => $composableBuilder(
      column: $table.latency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverName => $composableBuilder(
      column: $table.serverName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get protocolVersion => $composableBuilder(
      column: $table.protocolVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toolsCount => $composableBuilder(
      column: $table.toolsCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get resourcesCount => $composableBuilder(
      column: $table.resourcesCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get promptsCount => $composableBuilder(
      column: $table.promptsCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  $$McpServersTableTableFilterComposer get serverId {
    final $$McpServersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpConnectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $McpConnectionsTableTable> {
  $$McpConnectionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCheck => $composableBuilder(
      column: $table.lastCheck, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get latency => $composableBuilder(
      column: $table.latency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverName => $composableBuilder(
      column: $table.serverName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get protocolVersion => $composableBuilder(
      column: $table.protocolVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toolsCount => $composableBuilder(
      column: $table.toolsCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get resourcesCount => $composableBuilder(
      column: $table.resourcesCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get promptsCount => $composableBuilder(
      column: $table.promptsCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  $$McpServersTableTableOrderingComposer get serverId {
    final $$McpServersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableOrderingComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpConnectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $McpConnectionsTableTable> {
  $$McpConnectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isConnected => $composableBuilder(
      column: $table.isConnected, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCheck =>
      $composableBuilder(column: $table.lastCheck, builder: (column) => column);

  GeneratedColumn<int> get latency =>
      $composableBuilder(column: $table.latency, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<String> get serverName => $composableBuilder(
      column: $table.serverName, builder: (column) => column);

  GeneratedColumn<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<String> get protocolVersion => $composableBuilder(
      column: $table.protocolVersion, builder: (column) => column);

  GeneratedColumn<int> get toolsCount => $composableBuilder(
      column: $table.toolsCount, builder: (column) => column);

  GeneratedColumn<int> get resourcesCount => $composableBuilder(
      column: $table.resourcesCount, builder: (column) => column);

  GeneratedColumn<int> get promptsCount => $composableBuilder(
      column: $table.promptsCount, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  $$McpServersTableTableAnnotationComposer get serverId {
    final $$McpServersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpConnectionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $McpConnectionsTableTable,
    McpConnectionsTableData,
    $$McpConnectionsTableTableFilterComposer,
    $$McpConnectionsTableTableOrderingComposer,
    $$McpConnectionsTableTableAnnotationComposer,
    $$McpConnectionsTableTableCreateCompanionBuilder,
    $$McpConnectionsTableTableUpdateCompanionBuilder,
    (McpConnectionsTableData, $$McpConnectionsTableTableReferences),
    McpConnectionsTableData,
    PrefetchHooks Function({bool serverId})> {
  $$McpConnectionsTableTableTableManager(
      _$AppDatabase db, $McpConnectionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McpConnectionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McpConnectionsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McpConnectionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serverId = const Value.absent(),
            Value<bool> isConnected = const Value.absent(),
            Value<DateTime> lastCheck = const Value.absent(),
            Value<int?> latency = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<String?> serverName = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<String?> protocolVersion = const Value.absent(),
            Value<int?> toolsCount = const Value.absent(),
            Value<int?> resourcesCount = const Value.absent(),
            Value<int?> promptsCount = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
          }) =>
              McpConnectionsTableCompanion(
            id: id,
            serverId: serverId,
            isConnected: isConnected,
            lastCheck: lastCheck,
            latency: latency,
            error: error,
            serverName: serverName,
            serverVersion: serverVersion,
            protocolVersion: protocolVersion,
            toolsCount: toolsCount,
            resourcesCount: resourcesCount,
            promptsCount: promptsCount,
            recordedAt: recordedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serverId,
            required bool isConnected,
            required DateTime lastCheck,
            Value<int?> latency = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<String?> serverName = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<String?> protocolVersion = const Value.absent(),
            Value<int?> toolsCount = const Value.absent(),
            Value<int?> resourcesCount = const Value.absent(),
            Value<int?> promptsCount = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
          }) =>
              McpConnectionsTableCompanion.insert(
            id: id,
            serverId: serverId,
            isConnected: isConnected,
            lastCheck: lastCheck,
            latency: latency,
            error: error,
            serverName: serverName,
            serverVersion: serverVersion,
            protocolVersion: protocolVersion,
            toolsCount: toolsCount,
            resourcesCount: resourcesCount,
            promptsCount: promptsCount,
            recordedAt: recordedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$McpConnectionsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serverId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serverId,
                    referencedTable:
                        $$McpConnectionsTableTableReferences._serverIdTable(db),
                    referencedColumn: $$McpConnectionsTableTableReferences
                        ._serverIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$McpConnectionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $McpConnectionsTableTable,
    McpConnectionsTableData,
    $$McpConnectionsTableTableFilterComposer,
    $$McpConnectionsTableTableOrderingComposer,
    $$McpConnectionsTableTableAnnotationComposer,
    $$McpConnectionsTableTableCreateCompanionBuilder,
    $$McpConnectionsTableTableUpdateCompanionBuilder,
    (McpConnectionsTableData, $$McpConnectionsTableTableReferences),
    McpConnectionsTableData,
    PrefetchHooks Function({bool serverId})>;
typedef $$McpToolsTableTableCreateCompanionBuilder = McpToolsTableCompanion
    Function({
  Value<int> id,
  required String serverId,
  required String name,
  required String description,
  required String inputSchema,
  Value<DateTime> cachedAt,
  required DateTime expiresAt,
});
typedef $$McpToolsTableTableUpdateCompanionBuilder = McpToolsTableCompanion
    Function({
  Value<int> id,
  Value<String> serverId,
  Value<String> name,
  Value<String> description,
  Value<String> inputSchema,
  Value<DateTime> cachedAt,
  Value<DateTime> expiresAt,
});

final class $$McpToolsTableTableReferences extends BaseReferences<_$AppDatabase,
    $McpToolsTableTable, McpToolsTableData> {
  $$McpToolsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $McpServersTableTable _serverIdTable(_$AppDatabase db) =>
      db.mcpServersTable.createAlias($_aliasNameGenerator(
          db.mcpToolsTable.serverId, db.mcpServersTable.id));

  $$McpServersTableTableProcessedTableManager? get serverId {
    if ($_item.serverId == null) return null;
    final manager =
        $$McpServersTableTableTableManager($_db, $_db.mcpServersTable)
            .filter((f) => f.id($_item.serverId!));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$McpToolsTableTableFilterComposer
    extends Composer<_$AppDatabase, $McpToolsTableTable> {
  $$McpToolsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputSchema => $composableBuilder(
      column: $table.inputSchema, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  $$McpServersTableTableFilterComposer get serverId {
    final $$McpServersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpToolsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $McpToolsTableTable> {
  $$McpToolsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputSchema => $composableBuilder(
      column: $table.inputSchema, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  $$McpServersTableTableOrderingComposer get serverId {
    final $$McpServersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableOrderingComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpToolsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $McpToolsTableTable> {
  $$McpToolsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get inputSchema => $composableBuilder(
      column: $table.inputSchema, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  $$McpServersTableTableAnnotationComposer get serverId {
    final $$McpServersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpToolsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $McpToolsTableTable,
    McpToolsTableData,
    $$McpToolsTableTableFilterComposer,
    $$McpToolsTableTableOrderingComposer,
    $$McpToolsTableTableAnnotationComposer,
    $$McpToolsTableTableCreateCompanionBuilder,
    $$McpToolsTableTableUpdateCompanionBuilder,
    (McpToolsTableData, $$McpToolsTableTableReferences),
    McpToolsTableData,
    PrefetchHooks Function({bool serverId})> {
  $$McpToolsTableTableTableManager(_$AppDatabase db, $McpToolsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McpToolsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McpToolsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McpToolsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serverId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> inputSchema = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
          }) =>
              McpToolsTableCompanion(
            id: id,
            serverId: serverId,
            name: name,
            description: description,
            inputSchema: inputSchema,
            cachedAt: cachedAt,
            expiresAt: expiresAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serverId,
            required String name,
            required String description,
            required String inputSchema,
            Value<DateTime> cachedAt = const Value.absent(),
            required DateTime expiresAt,
          }) =>
              McpToolsTableCompanion.insert(
            id: id,
            serverId: serverId,
            name: name,
            description: description,
            inputSchema: inputSchema,
            cachedAt: cachedAt,
            expiresAt: expiresAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$McpToolsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serverId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serverId,
                    referencedTable:
                        $$McpToolsTableTableReferences._serverIdTable(db),
                    referencedColumn:
                        $$McpToolsTableTableReferences._serverIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$McpToolsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $McpToolsTableTable,
    McpToolsTableData,
    $$McpToolsTableTableFilterComposer,
    $$McpToolsTableTableOrderingComposer,
    $$McpToolsTableTableAnnotationComposer,
    $$McpToolsTableTableCreateCompanionBuilder,
    $$McpToolsTableTableUpdateCompanionBuilder,
    (McpToolsTableData, $$McpToolsTableTableReferences),
    McpToolsTableData,
    PrefetchHooks Function({bool serverId})>;
typedef $$McpCallHistoryTableTableCreateCompanionBuilder
    = McpCallHistoryTableCompanion Function({
  required String id,
  required String serverId,
  required String toolName,
  required String arguments,
  required DateTime calledAt,
  Value<String?> result,
  Value<String?> error,
  Value<int?> duration,
  Value<bool> isSuccess,
  Value<int> rowid,
});
typedef $$McpCallHistoryTableTableUpdateCompanionBuilder
    = McpCallHistoryTableCompanion Function({
  Value<String> id,
  Value<String> serverId,
  Value<String> toolName,
  Value<String> arguments,
  Value<DateTime> calledAt,
  Value<String?> result,
  Value<String?> error,
  Value<int?> duration,
  Value<bool> isSuccess,
  Value<int> rowid,
});

final class $$McpCallHistoryTableTableReferences extends BaseReferences<
    _$AppDatabase, $McpCallHistoryTableTable, McpCallHistoryTableData> {
  $$McpCallHistoryTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $McpServersTableTable _serverIdTable(_$AppDatabase db) =>
      db.mcpServersTable.createAlias($_aliasNameGenerator(
          db.mcpCallHistoryTable.serverId, db.mcpServersTable.id));

  $$McpServersTableTableProcessedTableManager? get serverId {
    if ($_item.serverId == null) return null;
    final manager =
        $$McpServersTableTableTableManager($_db, $_db.mcpServersTable)
            .filter((f) => f.id($_item.serverId!));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$McpCallHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $McpCallHistoryTableTable> {
  $$McpCallHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toolName => $composableBuilder(
      column: $table.toolName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get arguments => $composableBuilder(
      column: $table.arguments, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get calledAt => $composableBuilder(
      column: $table.calledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSuccess => $composableBuilder(
      column: $table.isSuccess, builder: (column) => ColumnFilters(column));

  $$McpServersTableTableFilterComposer get serverId {
    final $$McpServersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpCallHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $McpCallHistoryTableTable> {
  $$McpCallHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toolName => $composableBuilder(
      column: $table.toolName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get arguments => $composableBuilder(
      column: $table.arguments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get calledAt => $composableBuilder(
      column: $table.calledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get error => $composableBuilder(
      column: $table.error, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSuccess => $composableBuilder(
      column: $table.isSuccess, builder: (column) => ColumnOrderings(column));

  $$McpServersTableTableOrderingComposer get serverId {
    final $$McpServersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableOrderingComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpCallHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $McpCallHistoryTableTable> {
  $$McpCallHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get toolName =>
      $composableBuilder(column: $table.toolName, builder: (column) => column);

  GeneratedColumn<String> get arguments =>
      $composableBuilder(column: $table.arguments, builder: (column) => column);

  GeneratedColumn<DateTime> get calledAt =>
      $composableBuilder(column: $table.calledAt, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get isSuccess =>
      $composableBuilder(column: $table.isSuccess, builder: (column) => column);

  $$McpServersTableTableAnnotationComposer get serverId {
    final $$McpServersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpCallHistoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $McpCallHistoryTableTable,
    McpCallHistoryTableData,
    $$McpCallHistoryTableTableFilterComposer,
    $$McpCallHistoryTableTableOrderingComposer,
    $$McpCallHistoryTableTableAnnotationComposer,
    $$McpCallHistoryTableTableCreateCompanionBuilder,
    $$McpCallHistoryTableTableUpdateCompanionBuilder,
    (McpCallHistoryTableData, $$McpCallHistoryTableTableReferences),
    McpCallHistoryTableData,
    PrefetchHooks Function({bool serverId})> {
  $$McpCallHistoryTableTableTableManager(
      _$AppDatabase db, $McpCallHistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McpCallHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McpCallHistoryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McpCallHistoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> serverId = const Value.absent(),
            Value<String> toolName = const Value.absent(),
            Value<String> arguments = const Value.absent(),
            Value<DateTime> calledAt = const Value.absent(),
            Value<String?> result = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<int?> duration = const Value.absent(),
            Value<bool> isSuccess = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              McpCallHistoryTableCompanion(
            id: id,
            serverId: serverId,
            toolName: toolName,
            arguments: arguments,
            calledAt: calledAt,
            result: result,
            error: error,
            duration: duration,
            isSuccess: isSuccess,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String serverId,
            required String toolName,
            required String arguments,
            required DateTime calledAt,
            Value<String?> result = const Value.absent(),
            Value<String?> error = const Value.absent(),
            Value<int?> duration = const Value.absent(),
            Value<bool> isSuccess = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              McpCallHistoryTableCompanion.insert(
            id: id,
            serverId: serverId,
            toolName: toolName,
            arguments: arguments,
            calledAt: calledAt,
            result: result,
            error: error,
            duration: duration,
            isSuccess: isSuccess,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$McpCallHistoryTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serverId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serverId,
                    referencedTable:
                        $$McpCallHistoryTableTableReferences._serverIdTable(db),
                    referencedColumn: $$McpCallHistoryTableTableReferences
                        ._serverIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$McpCallHistoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $McpCallHistoryTableTable,
    McpCallHistoryTableData,
    $$McpCallHistoryTableTableFilterComposer,
    $$McpCallHistoryTableTableOrderingComposer,
    $$McpCallHistoryTableTableAnnotationComposer,
    $$McpCallHistoryTableTableCreateCompanionBuilder,
    $$McpCallHistoryTableTableUpdateCompanionBuilder,
    (McpCallHistoryTableData, $$McpCallHistoryTableTableReferences),
    McpCallHistoryTableData,
    PrefetchHooks Function({bool serverId})>;
typedef $$McpResourcesTableTableCreateCompanionBuilder
    = McpResourcesTableCompanion Function({
  Value<int> id,
  required String serverId,
  required String uri,
  required String name,
  Value<String?> description,
  Value<String?> mimeType,
  Value<DateTime> cachedAt,
  required DateTime expiresAt,
});
typedef $$McpResourcesTableTableUpdateCompanionBuilder
    = McpResourcesTableCompanion Function({
  Value<int> id,
  Value<String> serverId,
  Value<String> uri,
  Value<String> name,
  Value<String?> description,
  Value<String?> mimeType,
  Value<DateTime> cachedAt,
  Value<DateTime> expiresAt,
});

final class $$McpResourcesTableTableReferences extends BaseReferences<
    _$AppDatabase, $McpResourcesTableTable, McpResourcesTableData> {
  $$McpResourcesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $McpServersTableTable _serverIdTable(_$AppDatabase db) =>
      db.mcpServersTable.createAlias($_aliasNameGenerator(
          db.mcpResourcesTable.serverId, db.mcpServersTable.id));

  $$McpServersTableTableProcessedTableManager? get serverId {
    if ($_item.serverId == null) return null;
    final manager =
        $$McpServersTableTableTableManager($_db, $_db.mcpServersTable)
            .filter((f) => f.id($_item.serverId!));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$McpResourcesTableTableFilterComposer
    extends Composer<_$AppDatabase, $McpResourcesTableTable> {
  $$McpResourcesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  $$McpServersTableTableFilterComposer get serverId {
    final $$McpServersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpResourcesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $McpResourcesTableTable> {
  $$McpResourcesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  $$McpServersTableTableOrderingComposer get serverId {
    final $$McpServersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableOrderingComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpResourcesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $McpResourcesTableTable> {
  $$McpResourcesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  $$McpServersTableTableAnnotationComposer get serverId {
    final $$McpServersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpResourcesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $McpResourcesTableTable,
    McpResourcesTableData,
    $$McpResourcesTableTableFilterComposer,
    $$McpResourcesTableTableOrderingComposer,
    $$McpResourcesTableTableAnnotationComposer,
    $$McpResourcesTableTableCreateCompanionBuilder,
    $$McpResourcesTableTableUpdateCompanionBuilder,
    (McpResourcesTableData, $$McpResourcesTableTableReferences),
    McpResourcesTableData,
    PrefetchHooks Function({bool serverId})> {
  $$McpResourcesTableTableTableManager(
      _$AppDatabase db, $McpResourcesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McpResourcesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McpResourcesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McpResourcesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serverId = const Value.absent(),
            Value<String> uri = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
          }) =>
              McpResourcesTableCompanion(
            id: id,
            serverId: serverId,
            uri: uri,
            name: name,
            description: description,
            mimeType: mimeType,
            cachedAt: cachedAt,
            expiresAt: expiresAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serverId,
            required String uri,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            required DateTime expiresAt,
          }) =>
              McpResourcesTableCompanion.insert(
            id: id,
            serverId: serverId,
            uri: uri,
            name: name,
            description: description,
            mimeType: mimeType,
            cachedAt: cachedAt,
            expiresAt: expiresAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$McpResourcesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serverId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serverId,
                    referencedTable:
                        $$McpResourcesTableTableReferences._serverIdTable(db),
                    referencedColumn: $$McpResourcesTableTableReferences
                        ._serverIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$McpResourcesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $McpResourcesTableTable,
    McpResourcesTableData,
    $$McpResourcesTableTableFilterComposer,
    $$McpResourcesTableTableOrderingComposer,
    $$McpResourcesTableTableAnnotationComposer,
    $$McpResourcesTableTableCreateCompanionBuilder,
    $$McpResourcesTableTableUpdateCompanionBuilder,
    (McpResourcesTableData, $$McpResourcesTableTableReferences),
    McpResourcesTableData,
    PrefetchHooks Function({bool serverId})>;
typedef $$McpOAuthTokensTableTableCreateCompanionBuilder
    = McpOAuthTokensTableCompanion Function({
  required String serverId,
  required String accessToken,
  Value<String?> refreshToken,
  Value<String?> tokenType,
  Value<DateTime?> expiresAt,
  Value<String?> scopes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$McpOAuthTokensTableTableUpdateCompanionBuilder
    = McpOAuthTokensTableCompanion Function({
  Value<String> serverId,
  Value<String> accessToken,
  Value<String?> refreshToken,
  Value<String?> tokenType,
  Value<DateTime?> expiresAt,
  Value<String?> scopes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$McpOAuthTokensTableTableReferences extends BaseReferences<
    _$AppDatabase, $McpOAuthTokensTableTable, McpOAuthTokensTableData> {
  $$McpOAuthTokensTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $McpServersTableTable _serverIdTable(_$AppDatabase db) =>
      db.mcpServersTable.createAlias($_aliasNameGenerator(
          db.mcpOAuthTokensTable.serverId, db.mcpServersTable.id));

  $$McpServersTableTableProcessedTableManager? get serverId {
    if ($_item.serverId == null) return null;
    final manager =
        $$McpServersTableTableTableManager($_db, $_db.mcpServersTable)
            .filter((f) => f.id($_item.serverId!));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$McpOAuthTokensTableTableFilterComposer
    extends Composer<_$AppDatabase, $McpOAuthTokensTableTable> {
  $$McpOAuthTokensTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tokenType => $composableBuilder(
      column: $table.tokenType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scopes => $composableBuilder(
      column: $table.scopes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$McpServersTableTableFilterComposer get serverId {
    final $$McpServersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableFilterComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpOAuthTokensTableTableOrderingComposer
    extends Composer<_$AppDatabase, $McpOAuthTokensTableTable> {
  $$McpOAuthTokensTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tokenType => $composableBuilder(
      column: $table.tokenType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scopes => $composableBuilder(
      column: $table.scopes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$McpServersTableTableOrderingComposer get serverId {
    final $$McpServersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableOrderingComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpOAuthTokensTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $McpOAuthTokensTableTable> {
  $$McpOAuthTokensTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => column);

  GeneratedColumn<String> get tokenType =>
      $composableBuilder(column: $table.tokenType, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get scopes =>
      $composableBuilder(column: $table.scopes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$McpServersTableTableAnnotationComposer get serverId {
    final $$McpServersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serverId,
        referencedTable: $db.mcpServersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$McpServersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.mcpServersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$McpOAuthTokensTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $McpOAuthTokensTableTable,
    McpOAuthTokensTableData,
    $$McpOAuthTokensTableTableFilterComposer,
    $$McpOAuthTokensTableTableOrderingComposer,
    $$McpOAuthTokensTableTableAnnotationComposer,
    $$McpOAuthTokensTableTableCreateCompanionBuilder,
    $$McpOAuthTokensTableTableUpdateCompanionBuilder,
    (McpOAuthTokensTableData, $$McpOAuthTokensTableTableReferences),
    McpOAuthTokensTableData,
    PrefetchHooks Function({bool serverId})> {
  $$McpOAuthTokensTableTableTableManager(
      _$AppDatabase db, $McpOAuthTokensTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McpOAuthTokensTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McpOAuthTokensTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McpOAuthTokensTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> serverId = const Value.absent(),
            Value<String> accessToken = const Value.absent(),
            Value<String?> refreshToken = const Value.absent(),
            Value<String?> tokenType = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<String?> scopes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              McpOAuthTokensTableCompanion(
            serverId: serverId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresAt: expiresAt,
            scopes: scopes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String serverId,
            required String accessToken,
            Value<String?> refreshToken = const Value.absent(),
            Value<String?> tokenType = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<String?> scopes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              McpOAuthTokensTableCompanion.insert(
            serverId: serverId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresAt: expiresAt,
            scopes: scopes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$McpOAuthTokensTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (serverId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serverId,
                    referencedTable:
                        $$McpOAuthTokensTableTableReferences._serverIdTable(db),
                    referencedColumn: $$McpOAuthTokensTableTableReferences
                        ._serverIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$McpOAuthTokensTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $McpOAuthTokensTableTable,
    McpOAuthTokensTableData,
    $$McpOAuthTokensTableTableFilterComposer,
    $$McpOAuthTokensTableTableOrderingComposer,
    $$McpOAuthTokensTableTableAnnotationComposer,
    $$McpOAuthTokensTableTableCreateCompanionBuilder,
    $$McpOAuthTokensTableTableUpdateCompanionBuilder,
    (McpOAuthTokensTableData, $$McpOAuthTokensTableTableReferences),
    McpOAuthTokensTableData,
    PrefetchHooks Function({bool serverId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LlmConfigsTableTableTableManager get llmConfigsTable =>
      $$LlmConfigsTableTableTableManager(_db, _db.llmConfigsTable);
  $$PersonasTableTableTableManager get personasTable =>
      $$PersonasTableTableTableManager(_db, _db.personasTable);
  $$PersonaGroupsTableTableTableManager get personaGroupsTable =>
      $$PersonaGroupsTableTableTableManager(_db, _db.personaGroupsTable);
  $$ChatSessionsTableTableTableManager get chatSessionsTable =>
      $$ChatSessionsTableTableTableManager(_db, _db.chatSessionsTable);
  $$ChatMessagesTableTableTableManager get chatMessagesTable =>
      $$ChatMessagesTableTableTableManager(_db, _db.chatMessagesTable);
  $$KnowledgeBasesTableTableTableManager get knowledgeBasesTable =>
      $$KnowledgeBasesTableTableTableManager(_db, _db.knowledgeBasesTable);
  $$KnowledgeDocumentsTableTableTableManager get knowledgeDocumentsTable =>
      $$KnowledgeDocumentsTableTableTableManager(
          _db, _db.knowledgeDocumentsTable);
  $$KnowledgeChunksTableTableTableManager get knowledgeChunksTable =>
      $$KnowledgeChunksTableTableTableManager(_db, _db.knowledgeChunksTable);
  $$KnowledgeBaseConfigsTableTableTableManager get knowledgeBaseConfigsTable =>
      $$KnowledgeBaseConfigsTableTableTableManager(
          _db, _db.knowledgeBaseConfigsTable);
  $$CustomModelsTableTableTableManager get customModelsTable =>
      $$CustomModelsTableTableTableManager(_db, _db.customModelsTable);
  $$GeneralSettingsTableTableTableManager get generalSettingsTable =>
      $$GeneralSettingsTableTableTableManager(_db, _db.generalSettingsTable);
  $$McpServersTableTableTableManager get mcpServersTable =>
      $$McpServersTableTableTableManager(_db, _db.mcpServersTable);
  $$McpConnectionsTableTableTableManager get mcpConnectionsTable =>
      $$McpConnectionsTableTableTableManager(_db, _db.mcpConnectionsTable);
  $$McpToolsTableTableTableManager get mcpToolsTable =>
      $$McpToolsTableTableTableManager(_db, _db.mcpToolsTable);
  $$McpCallHistoryTableTableTableManager get mcpCallHistoryTable =>
      $$McpCallHistoryTableTableTableManager(_db, _db.mcpCallHistoryTable);
  $$McpResourcesTableTableTableManager get mcpResourcesTable =>
      $$McpResourcesTableTableTableManager(_db, _db.mcpResourcesTable);
  $$McpOAuthTokensTableTableTableManager get mcpOAuthTokensTable =>
      $$McpOAuthTokensTableTableTableManager(_db, _db.mcpOAuthTokensTable);
}
