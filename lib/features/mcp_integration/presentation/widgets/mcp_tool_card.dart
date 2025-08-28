import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/mcp_server_config.dart';

/// MCP工具卡片组件
class McpToolCard extends StatelessWidget {
  final McpTool tool;
  final VoidCallback? onTap;

  const McpToolCard({
    super.key,
    required this.tool,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 工具名称和图标
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getToolColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getToolIcon(),
                      color: _getToolColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tool.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (tool.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            tool.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              // 参数信息
              if (_hasParameters()) ...[
                const SizedBox(height: 16),
                _buildParametersPreview(),
              ],
              // 工具标签
              const SizedBox(height: 12),
              _buildToolTags(),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  /// 获取工具颜色（基于名称生成）
  Color _getToolColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.brown,
    ];
    
    final hash = tool.name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  /// 获取工具图标（基于名称推断）
  IconData _getToolIcon() {
    final name = tool.name.toLowerCase();
    
    if (name.contains('search') || name.contains('find')) {
      return Icons.search;
    } else if (name.contains('file') || name.contains('read') || name.contains('write')) {
      return Icons.insert_drive_file;
    } else if (name.contains('web') || name.contains('http') || name.contains('fetch')) {
      return Icons.web;
    } else if (name.contains('database') || name.contains('db') || name.contains('sql')) {
      return Icons.storage;
    } else if (name.contains('image') || name.contains('photo')) {
      return Icons.image;
    } else if (name.contains('email') || name.contains('mail')) {
      return Icons.email;
    } else if (name.contains('calendar') || name.contains('date') || name.contains('time')) {
      return Icons.calendar_today;
    } else if (name.contains('calculator') || name.contains('math') || name.contains('compute')) {
      return Icons.calculate;
    } else if (name.contains('weather')) {
      return Icons.wb_sunny;
    } else if (name.contains('location') || name.contains('map')) {
      return Icons.location_on;
    }
    
    return Icons.extension;
  }

  /// 检查是否有参数
  bool _hasParameters() {
    final properties = tool.inputSchema['properties'] as Map<String, dynamic>?;
    return properties != null && properties.isNotEmpty;
  }

  /// 构建参数预览
  Widget _buildParametersPreview() {
    final properties = tool.inputSchema['properties'] as Map<String, dynamic>?;
    final required = tool.inputSchema['required'] as List<dynamic>? ?? [];
    
    if (properties == null || properties.isEmpty) {
      return const SizedBox.shrink();
    }

    final parameterWidgets = <Widget>[];
    int count = 0;
    const maxDisplay = 3;

    for (final entry in properties.entries) {
      if (count >= maxDisplay) break;
      
      final paramName = entry.key;
      final paramSchema = entry.value as Map<String, dynamic>?;
      final isRequired = required.contains(paramName);
      
      parameterWidgets.add(
        _buildParameterChip(
          name: paramName,
          type: paramSchema?['type'] as String? ?? 'string',
          isRequired: isRequired,
        ),
      );
      count++;
    }

    if (properties.length > maxDisplay) {
      parameterWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '+${properties.length - maxDisplay}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '参数:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: parameterWidgets,
        ),
      ],
    );
  }

  /// 构建参数标签
  Widget _buildParameterChip({
    required String name,
    required String type,
    required bool isRequired,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRequired 
            ? Colors.red.withValues(alpha: 0.1) 
            : Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRequired 
              ? Colors.red.withValues(alpha: 0.3) 
              : Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRequired)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 4),
            ),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isRequired ? Colors.red[700] : Colors.blue[700],
            ),
          ),
          Text(
            ':$type',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建工具标签
  Widget _buildToolTags() {
    final tags = <Widget>[];
    
    // 参数数量标签
    final properties = tool.inputSchema['properties'] as Map<String, dynamic>?;
    if (properties != null) {
      tags.add(
        _buildTag(
          text: '${properties.length}个参数',
          color: Colors.blue,
          icon: Icons.tune,
        ),
      );
    }

    // 必需参数标签
    final required = tool.inputSchema['required'] as List<dynamic>? ?? [];
    if (required.isNotEmpty) {
      tags.add(
        _buildTag(
          text: '${required.length}个必需',
          color: Colors.red,
          icon: Icons.star,
        ),
      );
    }

    // 工具类型标签（基于名称推断）
    final toolType = _inferToolType();
    if (toolType != null) {
      tags.add(
        _buildTag(
          text: toolType,
          color: Colors.green,
          icon: _getToolIcon(),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: tags,
    );
  }

  /// 构建标签
  Widget _buildTag({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
  color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 推断工具类型
  String? _inferToolType() {
    final name = tool.name.toLowerCase();
    
    if (name.contains('search')) return '搜索';
    if (name.contains('file')) return '文件';
    if (name.contains('web') || name.contains('http')) return '网络';
    if (name.contains('database') || name.contains('sql')) return '数据库';
    if (name.contains('image')) return '图像';
    if (name.contains('email')) return '邮件';
    if (name.contains('calendar')) return '日历';
    if (name.contains('calculator') || name.contains('math')) return '计算';
    if (name.contains('weather')) return '天气';
    if (name.contains('location')) return '位置';
    
    return null;
  }
}