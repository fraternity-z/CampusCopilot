import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/help_data_repository.dart';
import '../../domain/entities/help_section.dart';

/// 帮助数据仓库Provider
final helpRepositoryProvider = Provider<HelpDataRepository>((ref) {
  return HelpDataRepository();
});

/// 帮助栏目列表Provider
final helpSectionsProvider = FutureProvider<List<HelpSection>>((ref) async {
  final repository = ref.read(helpRepositoryProvider);
  return repository.getAllSections();
});

/// 常用帮助条目Provider
final frequentlyUsedItemsProvider = FutureProvider<List<HelpItem>>((ref) async {
  final repository = ref.read(helpRepositoryProvider);
  return repository.getFrequentlyUsedItems();
});

/// 搜索查询状态Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// 搜索结果Provider
final searchResultsProvider = FutureProvider<List<HelpItem>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    return [];
  }

  final repository = ref.read(helpRepositoryProvider);
  return repository.searchHelpItems(query);
});

/// 选中的帮助栏目Provider
final selectedSectionProvider = StateProvider<String?>((ref) => null);

/// 选中栏目的详细信息Provider
final selectedSectionDetailProvider = FutureProvider<HelpSection?>((ref) async {
  final sectionId = ref.watch(selectedSectionProvider);
  if (sectionId == null) return null;

  final repository = ref.read(helpRepositoryProvider);
  return repository.getSectionById(sectionId);
});

/// 选中的帮助条目Provider
final selectedHelpItemProvider = StateProvider<String?>((ref) => null);

/// 选中条目的详细信息Provider
final selectedHelpItemDetailProvider = FutureProvider<HelpItem?>((ref) async {
  final itemId = ref.watch(selectedHelpItemProvider);
  if (itemId == null) return null;

  final repository = ref.read(helpRepositoryProvider);
  return repository.getHelpItemById(itemId);
});

/// 帮助界面状态管理
class HelpUIState {
  final bool isSearching;
  final bool showSidebar;
  final String? selectedSection;
  final String? selectedItem;

  const HelpUIState({
    this.isSearching = false,
    this.showSidebar = true,
    this.selectedSection,
    this.selectedItem,
  });

  HelpUIState copyWith({
    bool? isSearching,
    bool? showSidebar,
    String? selectedSection,
    String? selectedItem,
  }) {
    return HelpUIState(
      isSearching: isSearching ?? this.isSearching,
      showSidebar: showSidebar ?? this.showSidebar,
      selectedSection: selectedSection ?? this.selectedSection,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }
}

/// UI状态Provider
final helpUIStateProvider = StateNotifierProvider<HelpUIStateNotifier, HelpUIState>((ref) {
  return HelpUIStateNotifier();
});

/// UI状态管理器
class HelpUIStateNotifier extends StateNotifier<HelpUIState> {
  HelpUIStateNotifier() : super(const HelpUIState());

  /// 切换搜索状态
  void toggleSearch() {
    state = state.copyWith(isSearching: !state.isSearching);
  }

  /// 切换侧边栏显示
  void toggleSidebar() {
    state = state.copyWith(showSidebar: !state.showSidebar);
  }

  /// 选择栏目
  void selectSection(String? sectionId) {
    state = state.copyWith(
      selectedSection: sectionId,
      selectedItem: null, // 选择新栏目时清空选中的条目
    );
  }

  /// 选择帮助条目
  void selectItem(String? itemId) {
    state = state.copyWith(selectedItem: itemId);
  }

  /// 开始搜索
  void startSearch() {
    state = state.copyWith(isSearching: true);
  }

  /// 结束搜索
  void endSearch() {
    state = state.copyWith(isSearching: false);
  }

}
