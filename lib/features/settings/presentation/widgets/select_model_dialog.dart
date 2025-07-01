import 'package:flutter/material.dart';

import '../../../llm_chat/domain/providers/llm_provider.dart';

/// 模型系列枚举
enum ModelSeries {
  deepseek('DeepSeek系列', 'deepseek', Icons.psychology, Color(0xFF8B5CF6)),
  gpt('GPT系列', 'gpt', Icons.auto_awesome, Color(0xFF10B981)),
  claude('Claude系列', 'claude', Icons.smart_toy, Color(0xFFFF6B35)),
  gemini('Gemini系列', 'gemini', Icons.stars, Color(0xFF4285F4)),
  qwen('通义千问系列', 'qwen', Icons.text_fields, Color(0xFF722ED1)),
  baichuan('百川系列', 'baichuan', Icons.waves, Color(0xFF13C2C2)),
  chatglm('ChatGLM系列', 'chatglm', Icons.chat, Color(0xFFEB2F96)),
  yi('零一万物系列', '01-ai', Icons.memory, Color(0xFF1890FF)),
  doubao('豆包系列', 'doubao', Icons.code, Color(0xFF52C41A)),
  other('其他模型', '', Icons.extension, Color(0xFF8C8C8C));

  const ModelSeries(this.displayName, this.keyword, this.icon, this.color);

  final String displayName;
  final String keyword;
  final IconData icon;
  final Color color;
}

/// 选择模型弹窗 - 改进版
/// 支持按系列分组、一键添加分组、美观UI
class SelectModelDialog extends StatefulWidget {
  const SelectModelDialog({super.key, required this.models});

  final List<ModelInfo> models;

  @override
  State<SelectModelDialog> createState() => _SelectModelDialogState();
}

class _SelectModelDialogState extends State<SelectModelDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  Map<ModelSeries, List<ModelInfo>> _groupedModels = {};
  Map<ModelSeries, List<ModelInfo>> _filteredGroupedModels = {};

  @override
  void initState() {
    super.initState();
    _groupModels();
    _filteredGroupedModels = Map.from(_groupedModels);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 按系列分组模型
  void _groupModels() {
    _groupedModels = {for (var series in ModelSeries.values) series: []};

    for (final model in widget.models) {
      final modelId = model.id.toLowerCase();
      bool isGrouped = false;

      for (final series in ModelSeries.values) {
        if (series == ModelSeries.other) continue;
        if (modelId.contains(series.keyword.toLowerCase())) {
          _groupedModels[series]!.add(model);
          isGrouped = true;
          break;
        }
      }

      if (!isGrouped) {
        _groupedModels[ModelSeries.other]!.add(model);
      }
    }

    // 移除空分组
    _groupedModels.removeWhere((key, value) => value.isEmpty);
  }

  /// 搜索过滤
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredGroupedModels = Map.from(_groupedModels);
      } else {
        _filteredGroupedModels = {};
        _groupedModels.forEach((series, models) {
          final filteredModels = models.where((model) {
            return model.id.toLowerCase().contains(query) ||
                model.name.toLowerCase().contains(query) ||
                series.displayName.toLowerCase().contains(query);
          }).toList();

          if (filteredModels.isNotEmpty) {
            _filteredGroupedModels[series] = filteredModels;
          }
        });
      }
    });
  }

  /// 切换分组选择状态
  void _toggleGroupSelection(ModelSeries series, List<ModelInfo> models) {
    setState(() {
      final groupModelIds = models.map((m) => m.id).toSet();
      final allSelected = groupModelIds.every(
        (id) => _selectedIds.contains(id),
      );

      if (allSelected) {
        _selectedIds.removeAll(groupModelIds);
      } else {
        _selectedIds.addAll(groupModelIds);
      }
    });
  }

  /// 获取分组选择状态
  bool _isGroupSelected(List<ModelInfo> models) {
    if (models.isEmpty) return false;
    return models.every((model) => _selectedIds.contains(model.id));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(context),
            Expanded(child: _buildModelList(context)),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.library_add,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '添加模型',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '已选 ${_selectedIds.length} 个模型',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建搜索栏
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索模型或系列...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainer,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  /// 构建模型列表
  Widget _buildModelList(BuildContext context) {
    if (_filteredGroupedModels.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredGroupedModels.length,
      itemBuilder: (context, index) {
        final entry = _filteredGroupedModels.entries.elementAt(index);
        return _buildGroupSection(context, entry.key, entry.value);
      },
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '没有找到匹配的模型',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分组部分
  Widget _buildGroupSection(
    BuildContext context,
    ModelSeries series,
    List<ModelInfo> models,
  ) {
    final isSelected = _isGroupSelected(models);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // 分组标题
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: series.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(series.icon, size: 20, color: series.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        series.displayName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: series.color,
                            ),
                      ),
                      Text(
                        '${models.length} 个模型',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => _toggleGroupSelection(series, models),
                  icon: Icon(
                    isSelected
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    size: 16,
                  ),
                  label: Text(isSelected ? '取消全选' : '全选'),
                  style: FilledButton.styleFrom(
                    backgroundColor: isSelected
                        ? series.color.withValues(alpha: 0.1)
                        : series.color,
                    foregroundColor: isSelected ? series.color : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 模型列表
          ...models.map((model) => _buildModelItem(context, series, model)),
        ],
      ),
    );
  }

  /// 构建单个模型项
  Widget _buildModelItem(
    BuildContext context,
    ModelSeries series,
    ModelInfo model,
  ) {
    final isSelected = _selectedIds.contains(model.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedIds.remove(model.id);
              } else {
                _selectedIds.add(model.id);
              }
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? series.color.withValues(alpha: 0.05) : null,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: series.color.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name.isNotEmpty ? model.name : model.id,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? series.color
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (model.name.isNotEmpty && model.name != model.id) ...[
                        const SizedBox(height: 2),
                        Text(
                          model.id,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      if (model.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          model.description!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (model.supportsVision) ...[
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '视觉',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.purple.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIds.remove(model.id);
                      } else {
                        _selectedIds.add(model.id);
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected ? series.color : null,
                    foregroundColor: isSelected ? Colors.white : series.color,
                    side: BorderSide(color: series.color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    isSelected ? '已选' : '选择',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 16),
              label: const Text('取消'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: _selectedIds.isEmpty
                  ? null
                  : () {
                      final selectedModels = widget.models
                          .where((m) => _selectedIds.contains(m.id))
                          .toList();
                      Navigator.pop(context, selectedModels);
                    },
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                _selectedIds.isEmpty
                    ? '请选择模型'
                    : '添加 ${_selectedIds.length} 个模型',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
