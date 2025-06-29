import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';

class PersonaGroupState {
  final List<PersonaGroupsTableData> groups;
  final String? error;

  const PersonaGroupState({this.groups = const [], this.error});

  PersonaGroupState copyWith({
    List<PersonaGroupsTableData>? groups,
    String? error,
  }) {
    return PersonaGroupState(groups: groups ?? this.groups, error: error);
  }
}

class PersonaGroupNotifier extends StateNotifier<PersonaGroupState> {
  final AppDatabase _database;
  final _uuid = const Uuid();

  PersonaGroupNotifier(this._database) : super(const PersonaGroupState()) {
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final groups = await _database.getAllPersonaGroups();
      state = state.copyWith(groups: groups, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createGroup(String name) async {
    try {
      final now = DateTime.now();
      final group = PersonaGroupsTableCompanion.insert(
        id: _uuid.v4(),
        name: name,
        createdAt: now,
        updatedAt: now,
      );
      await _database.upsertPersonaGroup(group);
      await _loadGroups();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> renameGroup(String id, String newName) async {
    try {
      await (_database.update(
        _database.personaGroupsTable,
      )..where((t) => t.id.equals(id))).write(
        PersonaGroupsTableCompanion(
          name: drift.Value(newName),
          updatedAt: drift.Value(DateTime.now()),
        ),
      );
      await _loadGroups();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteGroup(String id) async {
    try {
      await _database.deletePersonaGroup(id);
      await _loadGroups();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final personaGroupProvider =
    StateNotifierProvider<PersonaGroupNotifier, PersonaGroupState>((ref) {
      final database = ref.read(appDatabaseProvider);
      return PersonaGroupNotifier(database);
    });
