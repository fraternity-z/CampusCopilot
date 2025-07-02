import 'package:flutter/material.dart';
import '../../domain/entities/persona.dart';
import '../../data/preset_personas.dart';

/// 预设智能体选择器弹窗
class PresetPersonaSelectorDialog extends StatelessWidget {
  const PresetPersonaSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // 标题栏
            _buildHeader(context),

            // 预设智能体列表
            Expanded(child: _buildPresetList(context)),
          ],
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '选择助手',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: '关闭',
          ),
        ],
      ),
    );
  }

  /// 构建预设智能体列表
  Widget _buildPresetList(BuildContext context) {
    final presets = presetPersonas; // 全局数据

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: presets.length + 1,
      itemBuilder: (context, index) {
        if (index < presets.length) {
          final persona = presets[index];
          return _buildPresetCard(context, persona);
        } else {
          // 自定义助手选项
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.add, color: Colors.white),
            ),
            title: const Text('自定义助手'),
            subtitle: const Text('从零开始创建个性化助手'),
            onTap: () => Navigator.of(context).pop(null),
          );
        }
      },
    );
  }

  /// 构建预设智能体卡片
  Widget _buildPresetCard(BuildContext context, Persona persona) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pop(persona),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 头像
              CircleAvatar(
                radius: 24,
                backgroundColor: persona.avatar != null
                    ? _getAvatarColor(persona.avatar!)
                    : Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  persona.avatar ?? persona.name[0].toUpperCase(),
                  style: TextStyle(
                    color: persona.avatar != null
                        ? Colors.white
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      persona.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      persona.description ?? '专业的AI助手',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 箭头图标
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取头像颜色
  Color _getAvatarColor(String emoji) {
    switch (emoji) {
      case '🌐':
        return Colors.blue;
      case '💻':
        return Colors.green;
      case '🌍':
        return Colors.orange;
      case '✍️':
        return Colors.purple;
      case '📐':
        return Colors.red;
      case '📜':
        return Colors.brown;
      case '✈️':
        return Colors.cyan;
      case '🏃':
        return Colors.teal;
      case '🎬':
        return Colors.indigo;
      case '🍳':
        return Colors.amber;
      case '💝':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
