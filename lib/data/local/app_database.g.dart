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

class $PlansTableTable extends PlansTable
    with TableInfo<$PlansTableTable, PlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
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
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('study'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _planDateMeta =
      const VerificationMeta('planDate');
  @override
  late final GeneratedColumn<DateTime> planDate = GeneratedColumn<DateTime>(
      'plan_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reminderTimeMeta =
      const VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<DateTime> reminderTime = GeneratedColumn<DateTime>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _courseIdMeta =
      const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
      'course_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
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
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        description,
        type,
        priority,
        status,
        planDate,
        startTime,
        endTime,
        reminderTime,
        tags,
        courseId,
        progress,
        notes,
        createdAt,
        updatedAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans_table';
  @override
  VerificationContext validateIntegrity(Insertable<PlansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('plan_date')) {
      context.handle(_planDateMeta,
          planDate.isAcceptableOrUnknown(data['plan_date']!, _planDateMeta));
    } else if (isInserting) {
      context.missing(_planDateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
          _reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(
              data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlansTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      planDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}plan_date'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      reminderTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder_time']),
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      courseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}course_id']),
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $PlansTableTable createAlias(String alias) {
    return $PlansTableTable(attachedDatabase, alias);
  }
}

class PlansTableData extends DataClass implements Insertable<PlansTableData> {
  /// 计划ID（主键）
  final int id;

  /// 计划标题
  final String title;

  /// 计划描述
  final String? description;

  /// 计划类型（study:学习，work:工作，life:生活，other:其他）
  final String type;

  /// 优先级（1:低，2:中，3:高）
  final int priority;

  /// 计划状态（pending:待处理，in_progress:进行中，completed:已完成，cancelled:已取消）
  final String status;

  /// 计划日期
  final DateTime planDate;

  /// 开始时间
  final DateTime? startTime;

  /// 结束时间
  final DateTime? endTime;

  /// 提醒时间
  final DateTime? reminderTime;

  /// 标签（用逗号分隔）
  final String? tags;

  /// 关联的课程ID（如果与课程相关）
  final int? courseId;

  /// 完成进度（0-100）
  final int progress;

  /// 备注
  final String? notes;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  /// 完成时间
  final DateTime? completedAt;
  const PlansTableData(
      {required this.id,
      required this.title,
      this.description,
      required this.type,
      required this.priority,
      required this.status,
      required this.planDate,
      this.startTime,
      this.endTime,
      this.reminderTime,
      this.tags,
      this.courseId,
      required this.progress,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    map['priority'] = Variable<int>(priority);
    map['status'] = Variable<String>(status);
    map['plan_date'] = Variable<DateTime>(planDate);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<DateTime>(reminderTime);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || courseId != null) {
      map['course_id'] = Variable<int>(courseId);
    }
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  PlansTableCompanion toCompanion(bool nullToAbsent) {
    return PlansTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      priority: Value(priority),
      status: Value(status),
      planDate: Value(planDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      courseId: courseId == null && nullToAbsent
          ? const Value.absent()
          : Value(courseId),
      progress: Value(progress),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory PlansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlansTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      priority: serializer.fromJson<int>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      planDate: serializer.fromJson<DateTime>(json['planDate']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      reminderTime: serializer.fromJson<DateTime?>(json['reminderTime']),
      tags: serializer.fromJson<String?>(json['tags']),
      courseId: serializer.fromJson<int?>(json['courseId']),
      progress: serializer.fromJson<int>(json['progress']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'priority': serializer.toJson<int>(priority),
      'status': serializer.toJson<String>(status),
      'planDate': serializer.toJson<DateTime>(planDate),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'reminderTime': serializer.toJson<DateTime?>(reminderTime),
      'tags': serializer.toJson<String?>(tags),
      'courseId': serializer.toJson<int?>(courseId),
      'progress': serializer.toJson<int>(progress),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  PlansTableData copyWith(
          {int? id,
          String? title,
          Value<String?> description = const Value.absent(),
          String? type,
          int? priority,
          String? status,
          DateTime? planDate,
          Value<DateTime?> startTime = const Value.absent(),
          Value<DateTime?> endTime = const Value.absent(),
          Value<DateTime?> reminderTime = const Value.absent(),
          Value<String?> tags = const Value.absent(),
          Value<int?> courseId = const Value.absent(),
          int? progress,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      PlansTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        planDate: planDate ?? this.planDate,
        startTime: startTime.present ? startTime.value : this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        reminderTime:
            reminderTime.present ? reminderTime.value : this.reminderTime,
        tags: tags.present ? tags.value : this.tags,
        courseId: courseId.present ? courseId.value : this.courseId,
        progress: progress ?? this.progress,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  PlansTableData copyWithCompanion(PlansTableCompanion data) {
    return PlansTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      planDate: data.planDate.present ? data.planDate.value : this.planDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      tags: data.tags.present ? data.tags.value : this.tags,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      progress: data.progress.present ? data.progress.value : this.progress,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlansTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('planDate: $planDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('tags: $tags, ')
          ..write('courseId: $courseId, ')
          ..write('progress: $progress, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      description,
      type,
      priority,
      status,
      planDate,
      startTime,
      endTime,
      reminderTime,
      tags,
      courseId,
      progress,
      notes,
      createdAt,
      updatedAt,
      completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlansTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.planDate == this.planDate &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.reminderTime == this.reminderTime &&
          other.tags == this.tags &&
          other.courseId == this.courseId &&
          other.progress == this.progress &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt);
}

class PlansTableCompanion extends UpdateCompanion<PlansTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> type;
  final Value<int> priority;
  final Value<String> status;
  final Value<DateTime> planDate;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<DateTime?> reminderTime;
  final Value<String?> tags;
  final Value<int?> courseId;
  final Value<int> progress;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  const PlansTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.planDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.tags = const Value.absent(),
    this.courseId = const Value.absent(),
    this.progress = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  PlansTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime planDate,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.tags = const Value.absent(),
    this.courseId = const Value.absent(),
    this.progress = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  })  : title = Value(title),
        planDate = Value(planDate);
  static Insertable<PlansTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? type,
    Expression<int>? priority,
    Expression<String>? status,
    Expression<DateTime>? planDate,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<DateTime>? reminderTime,
    Expression<String>? tags,
    Expression<int>? courseId,
    Expression<int>? progress,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (planDate != null) 'plan_date': planDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (tags != null) 'tags': tags,
      if (courseId != null) 'course_id': courseId,
      if (progress != null) 'progress': progress,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  PlansTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? type,
      Value<int>? priority,
      Value<String>? status,
      Value<DateTime>? planDate,
      Value<DateTime?>? startTime,
      Value<DateTime?>? endTime,
      Value<DateTime?>? reminderTime,
      Value<String?>? tags,
      Value<int?>? courseId,
      Value<int>? progress,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? completedAt}) {
    return PlansTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      planDate: planDate ?? this.planDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reminderTime: reminderTime ?? this.reminderTime,
      tags: tags ?? this.tags,
      courseId: courseId ?? this.courseId,
      progress: progress ?? this.progress,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (planDate.present) {
      map['plan_date'] = Variable<DateTime>(planDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<DateTime>(reminderTime.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('planDate: $planDate, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('tags: $tags, ')
          ..write('courseId: $courseId, ')
          ..write('progress: $progress, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt')
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
  late final $PlansTableTable plansTable = $PlansTableTable(this);
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
        plansTable
      ];
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
typedef $$PlansTableTableCreateCompanionBuilder = PlansTableCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  Value<String> type,
  Value<int> priority,
  Value<String> status,
  required DateTime planDate,
  Value<DateTime?> startTime,
  Value<DateTime?> endTime,
  Value<DateTime?> reminderTime,
  Value<String?> tags,
  Value<int?> courseId,
  Value<int> progress,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> completedAt,
});
typedef $$PlansTableTableUpdateCompanionBuilder = PlansTableCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<String> type,
  Value<int> priority,
  Value<String> status,
  Value<DateTime> planDate,
  Value<DateTime?> startTime,
  Value<DateTime?> endTime,
  Value<DateTime?> reminderTime,
  Value<String?> tags,
  Value<int?> courseId,
  Value<int> progress,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> completedAt,
});

class $$PlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlansTableTable> {
  $$PlansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get planDate => $composableBuilder(
      column: $table.planDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$PlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlansTableTable> {
  $$PlansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get planDate => $composableBuilder(
      column: $table.planDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get courseId => $composableBuilder(
      column: $table.courseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlansTableTable> {
  $$PlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get planDate =>
      $composableBuilder(column: $table.planDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderTime => $composableBuilder(
      column: $table.reminderTime, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$PlansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlansTableTable,
    PlansTableData,
    $$PlansTableTableFilterComposer,
    $$PlansTableTableOrderingComposer,
    $$PlansTableTableAnnotationComposer,
    $$PlansTableTableCreateCompanionBuilder,
    $$PlansTableTableUpdateCompanionBuilder,
    (
      PlansTableData,
      BaseReferences<_$AppDatabase, $PlansTableTable, PlansTableData>
    ),
    PlansTableData,
    PrefetchHooks Function()> {
  $$PlansTableTableTableManager(_$AppDatabase db, $PlansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> planDate = const Value.absent(),
            Value<DateTime?> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<int?> courseId = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              PlansTableCompanion(
            id: id,
            title: title,
            description: description,
            type: type,
            priority: priority,
            status: status,
            planDate: planDate,
            startTime: startTime,
            endTime: endTime,
            reminderTime: reminderTime,
            tags: tags,
            courseId: courseId,
            progress: progress,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime planDate,
            Value<DateTime?> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<DateTime?> reminderTime = const Value.absent(),
            Value<String?> tags = const Value.absent(),
            Value<int?> courseId = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              PlansTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            type: type,
            priority: priority,
            status: status,
            planDate: planDate,
            startTime: startTime,
            endTime: endTime,
            reminderTime: reminderTime,
            tags: tags,
            courseId: courseId,
            progress: progress,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlansTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlansTableTable,
    PlansTableData,
    $$PlansTableTableFilterComposer,
    $$PlansTableTableOrderingComposer,
    $$PlansTableTableAnnotationComposer,
    $$PlansTableTableCreateCompanionBuilder,
    $$PlansTableTableUpdateCompanionBuilder,
    (
      PlansTableData,
      BaseReferences<_$AppDatabase, $PlansTableTable, PlansTableData>
    ),
    PlansTableData,
    PrefetchHooks Function()>;

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
  $$PlansTableTableTableManager get plansTable =>
      $$PlansTableTableTableManager(_db, _db.plansTable);
}
