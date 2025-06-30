import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/persona.dart';
import '../../../../core/di/database_providers.dart';
import '../../../../data/local/app_database.dart';

/// 智能体状态管理
class PersonaNotifier extends StateNotifier<PersonaState> {
  final AppDatabase _database;
  final _uuid = const Uuid();

  PersonaNotifier(this._database) : super(const PersonaState()) {
    _loadPersonas();
  }

  /// 加载智能体列表
  Future<void> _loadPersonas() async {
    try {
      // 从数据库加载智能体
      final dbPersonas = await _database.getAllPersonas();

      List<Persona> personas;

      if (dbPersonas.isEmpty) {
        // 如果数据库为空，创建默认智能体
        personas = await _createDefaultPersonas();
      } else {
        // 转换数据库记录为Persona对象
        personas = dbPersonas
            .map(
              (p) => Persona(
                id: p.id,
                name: p.name,
                description: p.description,
                systemPrompt: p.systemPrompt,
                avatar: p.avatar,
                isDefault: p.isDefault,
                apiConfigId: p.apiConfigId,
                createdAt: p.createdAt,
                updatedAt: p.updatedAt,
              ),
            )
            .toList();
      }

      state = state.copyWith(
        personas: personas,
        selectedPersona:
            personas.where((p) => p.isDefault).firstOrNull ?? personas.first,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// 创建默认智能体
  Future<List<Persona>> _createDefaultPersonas() async {
    final defaultPersonas = <Persona>[
      Persona(
        id: _uuid.v4(),
        name: '通用助手',
        description: '一个友好的AI助手，可以帮助您解答各种问题',
        systemPrompt: '你是一个友好、有帮助的AI助手。请用简洁明了的方式回答用户的问题。',
        avatar: '🤖',
        isDefault: true,
        apiConfigId: 'default',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Persona(
        id: _uuid.v4(),
        name: '编程专家',
        description: '专业的编程助手，精通多种编程语言和技术',
        systemPrompt:
            '你是一个专业的编程助手，精通多种编程语言包括Python、JavaScript、Dart、Flutter等。请提供准确、实用的编程建议和代码示例。',
        avatar: '💻',
        isDefault: false,
        apiConfigId: 'default',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Persona(
        id: _uuid.v4(),
        name: '写作助手',
        description: '帮助您改善写作，提供创意和文案建议',
        systemPrompt: '你是一个专业的写作助手，擅长各种文体的写作，包括技术文档、创意写作、商务文案等。请提供有建设性的写作建议。',
        avatar: '✍️',
        isDefault: false,
        apiConfigId: 'default',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    // 保存到数据库
    for (final persona in defaultPersonas) {
      await _database.upsertPersona(
        PersonasTableCompanion.insert(
          id: persona.id,
          name: persona.name,
          description: persona.description ?? '',
          systemPrompt: persona.systemPrompt,
          avatar: Value(persona.avatar),
          isDefault: Value(persona.isDefault),
          apiConfigId: persona.apiConfigId ?? 'default',
          createdAt: persona.createdAt,
          updatedAt: persona.updatedAt,
        ),
      );
    }

    return defaultPersonas;
  }

  /// 创建新智能体
  Future<void> createPersona(Persona persona) async {
    try {
      final newPersona = persona.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 保存到数据库
      await _database.upsertPersona(
        PersonasTableCompanion.insert(
          id: newPersona.id,
          name: newPersona.name,
          description: newPersona.description ?? '',
          systemPrompt: newPersona.systemPrompt,
          avatar: Value(newPersona.avatar),
          isDefault: Value(newPersona.isDefault),
          apiConfigId: newPersona.apiConfigId ?? 'default',
          createdAt: newPersona.createdAt,
          updatedAt: newPersona.updatedAt,
        ),
      );

      state = state.copyWith(
        personas: [...state.personas, newPersona],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 更新智能体
  Future<void> updatePersona(Persona persona) async {
    try {
      final updatedPersona = persona.copyWith(updatedAt: DateTime.now());

      // 更新数据库
      await _database.upsertPersona(
        PersonasTableCompanion(
          id: Value(updatedPersona.id),
          name: Value(updatedPersona.name),
          description: Value(updatedPersona.description ?? ''),
          systemPrompt: Value(updatedPersona.systemPrompt),
          avatar: Value(updatedPersona.avatar),
          isDefault: Value(updatedPersona.isDefault),
          apiConfigId: Value(updatedPersona.apiConfigId ?? 'default'),
          createdAt: Value(updatedPersona.createdAt),
          updatedAt: Value(updatedPersona.updatedAt),
        ),
      );

      final updatedPersonas = state.personas.map((p) {
        return p.id == persona.id ? updatedPersona : p;
      }).toList();

      state = state.copyWith(
        personas: updatedPersonas,
        selectedPersona: state.selectedPersona?.id == persona.id
            ? updatedPersona
            : state.selectedPersona,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 删除智能体
  Future<void> deletePersona(String personaId) async {
    try {
      final persona = state.personas.firstWhere((p) => p.id == personaId);

      // 不能删除默认智能体
      if (persona.isDefault) {
        throw Exception('Cannot delete default persona');
      }

      // 从数据库删除
      await _database.deletePersona(personaId);

      final updatedPersonas = state.personas
          .where((p) => p.id != personaId)
          .toList();

      // 如果删除的是当前选中的智能体，切换到默认智能体
      Persona? newSelectedPersona = state.selectedPersona;
      if (state.selectedPersona?.id == personaId) {
        newSelectedPersona = updatedPersonas.firstWhere((p) => p.isDefault);
      }

      state = state.copyWith(
        personas: updatedPersonas,
        selectedPersona: newSelectedPersona,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 复制智能体
  Future<void> duplicatePersona(String personaId) async {
    try {
      final originalPersona = state.personas.firstWhere(
        (p) => p.id == personaId,
      );

      final duplicatedPersona = originalPersona.copyWith(
        id: _uuid.v4(),
        name: '${originalPersona.name} (副本)',
        isDefault: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 保存到数据库
      await _database.upsertPersona(
        PersonasTableCompanion.insert(
          id: duplicatedPersona.id,
          name: duplicatedPersona.name,
          description: duplicatedPersona.description ?? '',
          systemPrompt: duplicatedPersona.systemPrompt,
          avatar: Value(duplicatedPersona.avatar),
          isDefault: Value(duplicatedPersona.isDefault),
          apiConfigId: duplicatedPersona.apiConfigId ?? 'default',
          createdAt: duplicatedPersona.createdAt,
          updatedAt: duplicatedPersona.updatedAt,
        ),
      );

      state = state.copyWith(
        personas: [...state.personas, duplicatedPersona],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 选择智能体
  void selectPersona(String personaId) {
    final persona = state.personas.firstWhere((p) => p.id == personaId);
    state = state.copyWith(selectedPersona: persona);
  }

  /// 设置默认智能体
  Future<void> setDefaultPersona(String personaId) async {
    try {
      // 取消当前默认智能体的默认状态
      final updatedPersonas = state.personas.map((p) {
        if (p.isDefault) {
          return p.copyWith(isDefault: false, updatedAt: DateTime.now());
        } else if (p.id == personaId) {
          return p.copyWith(isDefault: true, updatedAt: DateTime.now());
        }
        return p;
      }).toList();

      // 更新数据库
      for (final persona in updatedPersonas) {
        await _database.upsertPersona(
          PersonasTableCompanion(
            id: Value(persona.id),
            name: Value(persona.name),
            description: Value(persona.description ?? ''),
            systemPrompt: Value(persona.systemPrompt),
            avatar: Value(persona.avatar),
            isDefault: Value(persona.isDefault),
            apiConfigId: Value(persona.apiConfigId ?? 'default'),
            createdAt: Value(persona.createdAt),
            updatedAt: Value(persona.updatedAt),
          ),
        );
      }

      state = state.copyWith(
        personas: updatedPersonas,
        selectedPersona: updatedPersonas.firstWhere((p) => p.id == personaId),
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// 智能体状态
class PersonaState {
  final List<Persona> personas;
  final Persona? selectedPersona;
  final bool isLoading;
  final String? error;

  const PersonaState({
    this.personas = const [],
    this.selectedPersona,
    this.isLoading = true,
    this.error,
  });

  PersonaState copyWith({
    List<Persona>? personas,
    Persona? selectedPersona,
    bool? isLoading,
    String? error,
  }) {
    return PersonaState(
      personas: personas ?? this.personas,
      selectedPersona: selectedPersona ?? this.selectedPersona,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 智能体Provider
final personaProvider = StateNotifierProvider<PersonaNotifier, PersonaState>((
  ref,
) {
  final database = ref.read(appDatabaseProvider);
  return PersonaNotifier(database);
});

/// 智能体列表Provider
final personaListProvider = Provider<List<Persona>>((ref) {
  return ref.watch(personaProvider).personas;
});

/// 当前选中智能体Provider
final selectedPersonaProvider = Provider<Persona?>((ref) {
  return ref.watch(personaProvider).selectedPersona;
});

/// 默认智能体Provider
final defaultPersonaProvider = Provider<Persona?>((ref) {
  final personas = ref.watch(personaListProvider);
  return personas.where((p) => p.isDefault).firstOrNull;
});

/// 智能体加载状态Provider
final personaLoadingProvider = Provider<bool>((ref) {
  return ref.watch(personaProvider).isLoading;
});

/// 智能体错误Provider
final personaErrorProvider = Provider<String?>((ref) {
  return ref.watch(personaProvider).error;
});
