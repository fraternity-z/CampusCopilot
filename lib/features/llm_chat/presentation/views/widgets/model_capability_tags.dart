import 'package:flutter/material.dart';
import '../../../domain/entities/model_capabilities.dart';
import '../../../domain/utils/model_capability_checker.dart';

/// 模型能力标签显示组件
class ModelCapabilityTags extends StatelessWidget {
  /// 模型名称
  final String? modelName;
  
  /// 最大显示标签数量
  final int maxTags;
  
  /// 标签大小
  final TagSize size;
  
  /// 是否紧凑显示
  final bool compact;
  
  /// 自定义颜色映射
  final Map<ModelCapabilityType, Color>? customColors;
  
  const ModelCapabilityTags({
    super.key,
    required this.modelName,
    this.maxTags = 4,
    this.size = TagSize.small,
    this.compact = false,
    this.customColors,
  });

  @override
  Widget build(BuildContext context) {
    if (modelName == null || modelName!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final capabilities = ModelCapabilityChecker.getModelCapabilities(modelName);
    
    // 排除基础chat能力，只显示特殊能力
    final specialCapabilities = capabilities
        .where((cap) => cap != ModelCapabilityType.chat)
        .toList();
    
    if (specialCapabilities.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // 限制显示数量
    final displayCapabilities = specialCapabilities.take(maxTags).toList();
    final hasMore = specialCapabilities.length > maxTags;
    
    if (compact) {
      return _buildCompactTags(context, displayCapabilities, hasMore);
    } else {
      return _buildNormalTags(context, displayCapabilities, hasMore);
    }
  }
  
  /// 构建紧凑模式标签
  Widget _buildCompactTags(
    BuildContext context,
    List<ModelCapabilityType> capabilities,
    bool hasMore,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...capabilities.map((capability) => Padding(
          padding: const EdgeInsets.only(right: 4),
          child: _buildCapabilityIcon(context, capability),
        )),
        if (hasMore) _buildMoreIndicator(context),
      ],
    );
  }
  
  /// 构建普通模式标签
  Widget _buildNormalTags(
    BuildContext context,
    List<ModelCapabilityType> capabilities,
    bool hasMore,
  ) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...capabilities.map((capability) => _buildCapabilityTag(context, capability)),
        if (hasMore) _buildMoreTag(context, capabilities.length),
      ],
    );
  }
  
  /// 构建能力标签
  Widget _buildCapabilityTag(BuildContext context, ModelCapabilityType capability) {
    final config = _getTagConfig(capability);
    final tagSize = _getTagSize();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tagSize.horizontalPadding,
        vertical: tagSize.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(tagSize.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: tagSize.iconSize,
            color: config.color,
          ),
          SizedBox(width: tagSize.spacing),
          Text(
            capability.displayName,
            style: TextStyle(
              fontSize: tagSize.fontSize,
              color: config.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建能力图标（紧凑模式）
  Widget _buildCapabilityIcon(BuildContext context, ModelCapabilityType capability) {
    final config = _getTagConfig(capability);
    final tagSize = _getTagSize();
    
    return Tooltip(
      message: capability.displayName,
      child: Container(
        padding: EdgeInsets.all(tagSize.iconPadding),
        decoration: BoxDecoration(
          color: config.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(tagSize.iconBorderRadius),
        ),
        child: Icon(
          config.icon,
          size: tagSize.iconSize,
          color: config.color,
        ),
      ),
    );
  }
  
  /// 构建更多指示器（紧凑模式）
  Widget _buildMoreIndicator(BuildContext context) {
    final tagSize = _getTagSize();
    
    return Container(
      padding: EdgeInsets.all(tagSize.iconPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(tagSize.iconBorderRadius),
      ),
      child: Icon(
        Icons.more_horiz,
        size: tagSize.iconSize,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
  
  /// 构建更多标签（普通模式）
  Widget _buildMoreTag(BuildContext context, int visibleCount) {
    final totalCapabilities = ModelCapabilityChecker.getModelCapabilities(modelName).length - 1; // 排除chat
    final moreCount = totalCapabilities - visibleCount;
    final tagSize = _getTagSize();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tagSize.horizontalPadding,
        vertical: tagSize.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(tagSize.borderRadius),
      ),
      child: Text(
        '+$moreCount',
        style: TextStyle(
          fontSize: tagSize.fontSize,
          color: Theme.of(context).colorScheme.outline,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  /// 获取标签配置
  _TagConfig _getTagConfig(ModelCapabilityType capability) {
    // 优先使用自定义颜色
    final color = customColors?[capability] ?? _getDefaultColor(capability);
    final icon = _getCapabilityIcon(capability);
    
    return _TagConfig(color: color, icon: icon);
  }
  
  /// 获取默认颜色
  Color _getDefaultColor(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Colors.grey;
      case ModelCapabilityType.vision:
        return Colors.purple;
      case ModelCapabilityType.functionCalling:
        return Colors.blue;
      case ModelCapabilityType.reasoning:
        return Colors.orange;
      case ModelCapabilityType.webSearch:
        return Colors.green;
      case ModelCapabilityType.embedding:
        return Colors.indigo;
      case ModelCapabilityType.rerank:
        return Colors.teal;
      case ModelCapabilityType.imageGeneration:
        return Colors.pink;
      case ModelCapabilityType.audio:
        return Colors.red;
    }
  }
  
  /// 获取能力图标
  IconData _getCapabilityIcon(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Icons.chat_bubble_outline;
      case ModelCapabilityType.vision:
        return Icons.visibility;
      case ModelCapabilityType.functionCalling:
        return Icons.build;
      case ModelCapabilityType.reasoning:
        return Icons.psychology;
      case ModelCapabilityType.webSearch:
        return Icons.search;
      case ModelCapabilityType.embedding:
        return Icons.scatter_plot;
      case ModelCapabilityType.rerank:
        return Icons.sort;
      case ModelCapabilityType.imageGeneration:
        return Icons.image;
      case ModelCapabilityType.audio:
        return Icons.headphones;
    }
  }
  
  /// 获取标签尺寸配置
  _TagSizeConfig _getTagSize() {
    switch (size) {
      case TagSize.small:
        return const _TagSizeConfig(
          fontSize: 10,
          iconSize: 10,
          horizontalPadding: 6,
          verticalPadding: 2,
          borderRadius: 4,
          spacing: 2,
          iconPadding: 3,
          iconBorderRadius: 3,
        );
      case TagSize.medium:
        return const _TagSizeConfig(
          fontSize: 12,
          iconSize: 12,
          horizontalPadding: 8,
          verticalPadding: 4,
          borderRadius: 6,
          spacing: 4,
          iconPadding: 4,
          iconBorderRadius: 4,
        );
      case TagSize.large:
        return const _TagSizeConfig(
          fontSize: 14,
          iconSize: 14,
          horizontalPadding: 10,
          verticalPadding: 6,
          borderRadius: 8,
          spacing: 6,
          iconPadding: 6,
          iconBorderRadius: 6,
        );
    }
  }
}

/// 标签大小枚举
enum TagSize {
  small,
  medium,
  large,
}

/// 标签配置
class _TagConfig {
  final Color color;
  final IconData icon;
  
  const _TagConfig({
    required this.color,
    required this.icon,
  });
}

/// 标签尺寸配置
class _TagSizeConfig {
  final double fontSize;
  final double iconSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double spacing;
  final double iconPadding;
  final double iconBorderRadius;
  
  const _TagSizeConfig({
    required this.fontSize,
    required this.iconSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.spacing,
    required this.iconPadding,
    required this.iconBorderRadius,
  });
}

/// 详细的模型能力卡片组件
class ModelCapabilityCard extends StatelessWidget {
  /// 模型名称
  final String? modelName;
  
  /// 是否显示详细描述
  final bool showDescription;
  
  const ModelCapabilityCard({
    super.key,
    required this.modelName,
    this.showDescription = true,
  });

  @override
  Widget build(BuildContext context) {
    if (modelName == null || modelName!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final capabilities = ModelCapabilityChecker.getModelCapabilities(modelName);
    final description = ModelCapabilityChecker.getCapabilityDescription(modelName);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 模型能力概述
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '模型能力',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            if (showDescription) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            // 能力标签
            ModelCapabilityTags(
              modelName: modelName,
              size: TagSize.medium,
              maxTags: 6,
            ),
            
            // 详细能力列表
            if (showDescription && capabilities.length > 1) ...[
              const SizedBox(height: 16),
              ...capabilities.map((capability) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getCapabilityIcon(capability),
                      size: 16,
                      color: _getCapabilityColor(capability),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capability.displayName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            capability.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
  
  /// 获取能力图标
  IconData _getCapabilityIcon(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Icons.chat_bubble_outline;
      case ModelCapabilityType.vision:
        return Icons.visibility;
      case ModelCapabilityType.functionCalling:
        return Icons.build;
      case ModelCapabilityType.reasoning:
        return Icons.psychology;
      case ModelCapabilityType.webSearch:
        return Icons.search;
      case ModelCapabilityType.embedding:
        return Icons.scatter_plot;
      case ModelCapabilityType.rerank:
        return Icons.sort;
      case ModelCapabilityType.imageGeneration:
        return Icons.image;
      case ModelCapabilityType.audio:
        return Icons.headphones;
    }
  }
  
  /// 获取能力颜色
  Color _getCapabilityColor(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Colors.grey;
      case ModelCapabilityType.vision:
        return Colors.purple;
      case ModelCapabilityType.functionCalling:
        return Colors.blue;
      case ModelCapabilityType.reasoning:
        return Colors.orange;
      case ModelCapabilityType.webSearch:
        return Colors.green;
      case ModelCapabilityType.embedding:
        return Colors.indigo;
      case ModelCapabilityType.rerank:
        return Colors.teal;
      case ModelCapabilityType.imageGeneration:
        return Colors.pink;
      case ModelCapabilityType.audio:
        return Colors.red;
    }
  }
}

/// 单个能力标签组件
class CapabilityTag extends StatelessWidget {
  /// 能力类型
  final ModelCapabilityType capability;
  
  /// 标签大小
  final TagSize size;
  
  /// 自定义颜色
  final Color? customColor;
  
  /// 是否只显示图标
  final bool iconOnly;
  
  const CapabilityTag({
    super.key,
    required this.capability,
    this.size = TagSize.small,
    this.customColor,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = customColor ?? _getDefaultColor(capability);
    final tagSize = _getTagSize(size);
    
    if (iconOnly) {
      return Tooltip(
        message: capability.displayName,
        child: Container(
          padding: EdgeInsets.all(tagSize.iconPadding),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(tagSize.iconBorderRadius),
          ),
          child: Icon(
            _getCapabilityIcon(capability),
            size: tagSize.iconSize,
            color: color,
          ),
        ),
      );
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tagSize.horizontalPadding,
        vertical: tagSize.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(tagSize.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCapabilityIcon(capability),
            size: tagSize.iconSize,
            color: color,
          ),
          SizedBox(width: tagSize.spacing),
          Text(
            capability.displayName,
            style: TextStyle(
              fontSize: tagSize.fontSize,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 获取默认颜色
  Color _getDefaultColor(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Colors.grey;
      case ModelCapabilityType.vision:
        return Colors.purple;
      case ModelCapabilityType.functionCalling:
        return Colors.blue;
      case ModelCapabilityType.reasoning:
        return Colors.orange;
      case ModelCapabilityType.webSearch:
        return Colors.green;
      case ModelCapabilityType.embedding:
        return Colors.indigo;
      case ModelCapabilityType.rerank:
        return Colors.teal;
      case ModelCapabilityType.imageGeneration:
        return Colors.pink;
      case ModelCapabilityType.audio:
        return Colors.red;
    }
  }
  
  /// 获取能力图标
  IconData _getCapabilityIcon(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Icons.chat_bubble_outline;
      case ModelCapabilityType.vision:
        return Icons.visibility;
      case ModelCapabilityType.functionCalling:
        return Icons.build;
      case ModelCapabilityType.reasoning:
        return Icons.psychology;
      case ModelCapabilityType.webSearch:
        return Icons.search;
      case ModelCapabilityType.embedding:
        return Icons.scatter_plot;
      case ModelCapabilityType.rerank:
        return Icons.sort;
      case ModelCapabilityType.imageGeneration:
        return Icons.image;
      case ModelCapabilityType.audio:
        return Icons.headphones;
    }
  }
  
  /// 获取标签尺寸配置
  _TagSizeConfig _getTagSize(TagSize size) {
    switch (size) {
      case TagSize.small:
        return const _TagSizeConfig(
          fontSize: 10,
          iconSize: 10,
          horizontalPadding: 6,
          verticalPadding: 2,
          borderRadius: 4,
          spacing: 2,
          iconPadding: 3,
          iconBorderRadius: 3,
        );
      case TagSize.medium:
        return const _TagSizeConfig(
          fontSize: 12,
          iconSize: 12,
          horizontalPadding: 8,
          verticalPadding: 4,
          borderRadius: 6,
          spacing: 4,
          iconPadding: 4,
          iconBorderRadius: 4,
        );
      case TagSize.large:
        return const _TagSizeConfig(
          fontSize: 14,
          iconSize: 14,
          horizontalPadding: 10,
          verticalPadding: 6,
          borderRadius: 8,
          spacing: 6,
          iconPadding: 6,
          iconBorderRadius: 6,
        );
    }
  }
}

/// 模型能力过滤器组件
class ModelCapabilityFilter extends StatefulWidget {
  /// 所有可用的能力类型
  final List<ModelCapabilityType> availableCapabilities;
  
  /// 当前选中的能力类型
  final List<ModelCapabilityType> selectedCapabilities;
  
  /// 能力选择变化回调
  final ValueChanged<List<ModelCapabilityType>> onCapabilitiesChanged;
  
  const ModelCapabilityFilter({
    super.key,
    required this.availableCapabilities,
    required this.selectedCapabilities,
    required this.onCapabilitiesChanged,
  });

  @override
  State<ModelCapabilityFilter> createState() => _ModelCapabilityFilterState();
}

class _ModelCapabilityFilterState extends State<ModelCapabilityFilter> {
  late List<ModelCapabilityType> _selectedCapabilities;
  
  @override
  void initState() {
    super.initState();
    _selectedCapabilities = List.from(widget.selectedCapabilities);
  }
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.availableCapabilities.map((capability) {
        final isSelected = _selectedCapabilities.contains(capability);
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCapabilityIcon(capability),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(capability.displayName),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedCapabilities.add(capability);
              } else {
                _selectedCapabilities.remove(capability);
              }
              widget.onCapabilitiesChanged(_selectedCapabilities);
            });
          },
          backgroundColor: Colors.transparent,
          selectedColor: _getDefaultColor(capability).withValues(alpha: 0.2),
          checkmarkColor: _getDefaultColor(capability),
        );
      }).toList(),
    );
  }
  
  /// 获取能力图标
  IconData _getCapabilityIcon(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Icons.chat_bubble_outline;
      case ModelCapabilityType.vision:
        return Icons.visibility;
      case ModelCapabilityType.functionCalling:
        return Icons.build;
      case ModelCapabilityType.reasoning:
        return Icons.psychology;
      case ModelCapabilityType.webSearch:
        return Icons.search;
      case ModelCapabilityType.embedding:
        return Icons.scatter_plot;
      case ModelCapabilityType.rerank:
        return Icons.sort;
      case ModelCapabilityType.imageGeneration:
        return Icons.image;
      case ModelCapabilityType.audio:
        return Icons.headphones;
    }
  }
  
  /// 获取默认颜色
  Color _getDefaultColor(ModelCapabilityType capability) {
    switch (capability) {
      case ModelCapabilityType.chat:
        return Colors.grey;
      case ModelCapabilityType.vision:
        return Colors.purple;
      case ModelCapabilityType.functionCalling:
        return Colors.blue;
      case ModelCapabilityType.reasoning:
        return Colors.orange;
      case ModelCapabilityType.webSearch:
        return Colors.green;
      case ModelCapabilityType.embedding:
        return Colors.indigo;
      case ModelCapabilityType.rerank:
        return Colors.teal;
      case ModelCapabilityType.imageGeneration:
        return Colors.pink;
      case ModelCapabilityType.audio:
        return Colors.red;
    }
  }
}
