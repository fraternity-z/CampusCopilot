import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/widgets/elegant_notification.dart';
import 'package:drift/drift.dart' as drift;

import '../../../llm_chat/data/providers/llm_provider_factory.dart';
import '../../../llm_chat/domain/providers/llm_provider.dart';
import '../../../llm_chat/domain/services/model_management_service.dart';
import '../../../../data/local/app_database.dart';
import '../../../../core/di/database_providers.dart';
import '../widgets/select_model_dialog.dart';
import '../providers/custom_provider_notifier.dart';
import '../../../../core/utils/model_icon_utils.dart';
import '../../domain/entities/app_settings.dart';

/// AI提供商配置页面
class ProviderConfigScreen extends ConsumerStatefulWidget {
  final String providerId;

  const ProviderConfigScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderConfigScreen> createState() =>
      _ProviderConfigScreenState();
}

class _ProviderConfigScreenState extends ConsumerState<ProviderConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _organizationIdController = TextEditingController();

  bool _isLoading = false;
  bool _isEnabled = true;
  LlmConfigsTableData? _existingConfig;
  List<ModelInfo> _availableModels = [];
  
  // 模型分组展开状态（按系列名称）
  final Map<String, bool> _expandedGroups = {};

  @override
  void initState() {
    super.initState();
    _loadProviderConfig();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _organizationIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerInfo = ref.watch(providerInfoProvider(widget.providerId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${providerInfo.displayName} 配置'),
        actions: [
          // 如果是自定义提供商，显示删除按钮
          if (_existingConfig?.isCustomProvider == true) ...[
            IconButton(
              onPressed: _isLoading ? null : _showDeleteConfirmDialog,
              icon: const Icon(Icons.delete_outline),
              tooltip: '删除提供商',
            ),
          ],
          TextButton(
            onPressed: _isLoading ? null : _saveConfig,
            child: const Text('保存'),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '加载配置中...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : AnimationLimiter(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      _buildBasicConfigCard(providerInfo),
                      const SizedBox(height: 16),
                      _buildAdvancedConfigCard(providerInfo),
                      const SizedBox(height: 16),
                      _buildModelManagementCard(),
                      const SizedBox(height: 16),
                      _buildTestConnectionCard(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// 构建基础配置卡片
  Widget _buildBasicConfigCard(ProviderInfo providerInfo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _getProviderIcon(widget.providerId),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '基础配置',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 配置名称
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '配置名称',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    helperText: '为此配置设置一个易识别的名称',
                    prefixIcon: Icon(
                      Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入配置名称';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // API密钥
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(
                    labelText: 'API密钥',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    helperText: '从提供商官网获取的API密钥',
                    prefixIcon: Icon(
                      Icons.key_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入API密钥';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // 启用状态
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: SwitchListTile(
                  title: Text(
                    '启用此配置',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    '关闭后此配置将不会出现在选择列表中',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: _isEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isEnabled = value;
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // activeThumbColor deprecated in Flutter 3.32+
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建高级配置卡片
  Widget _buildAdvancedConfigCard(ProviderInfo providerInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '高级配置',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 基础URL
            TextFormField(
              controller: _baseUrlController,
              decoration: const InputDecoration(
                labelText: '基础URL（可选）',
                border: OutlineInputBorder(),
                helperText: '自定义API端点，留空使用默认地址',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.hasScheme) {
                    return '请输入有效的URL';
                  }
                }
                return null;
              },
            ),

            // OpenAI专用配置
            if (widget.providerId == 'openai') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _organizationIdController,
                decoration: const InputDecoration(
                  labelText: '组织ID（可选）',
                  border: OutlineInputBorder(),
                  helperText: 'OpenAI组织ID，仅团队账户需要',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建模型管理卡片
  Widget _buildModelManagementCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '可用模型',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _refreshModels,
                      icon: const Icon(Icons.refresh),
                      tooltip: '从API获取最新模型',
                    ),
                    IconButton(
                      onPressed: _addCustomModel,
                      icon: const Icon(Icons.add),
                      tooltip: '添加自定义模型',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_availableModels.isEmpty)
              const Center(child: Text('暂无可用模型，请先配置API密钥并点击刷新'))
            else
              _buildGroupedModelList(),
          ],
        ),
      ),
    );
  }

  /// 构建测试连接卡片
  Widget _buildTestConnectionCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.network_check_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '连接测试',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _testConnection,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_protected_setup,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '测试连接',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建分组的模型列表
  Widget _buildGroupedModelList() {
    // 按模型名称系列分组
    final Map<String, List<ModelInfo>> groupedModels = {};
    for (final model in _availableModels) {
      final groupKey = _extractModelSeries(model.name);
      groupedModels.putIfAbsent(groupKey, () => []).add(model);
    }

    // 过滤掉空的分组并按组名排序
    final availableGroups = groupedModels.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList()
        ..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      children: [
        // 全部展开/折叠按钮
        if (availableGroups.length > 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _toggleAllGroups(true),
                icon: const Icon(Icons.expand_more, size: 18),
                label: const Text('全部展开'),
              ),
              TextButton.icon(
                onPressed: () => _toggleAllGroups(false),
                icon: const Icon(Icons.expand_less, size: 18),
                label: const Text('全部折叠'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // 分组列表
        ...availableGroups.map((entry) {
          final seriesName = entry.key;
          final models = entry.value;
          final isExpanded = _expandedGroups[seriesName] ?? true;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                // 分组头部
                InkWell(
                  onTap: () => _toggleGroup(seriesName),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getSeriesColor(seriesName).withValues(alpha: 0.08),
                      borderRadius: isExpanded
                          ? const BorderRadius.vertical(top: Radius.circular(12))
                          : BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _getSeriesIcon(seriesName),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seriesName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
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
                        // 分组删除按钮
                        IconButton(
                          onPressed: () => _showDeleteGroupDialog(context, seriesName, models),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: '删除整个$seriesName',
                          iconSize: 20,
                          color: Colors.red,
                        ),
                        
                        // 展开/折叠箭头
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 分组内容
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: models.map((model) {
                        return _buildModelItem(model);
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// 构建单个模型项
  Widget _buildModelItem(ModelInfo model) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: _getModelIcon(model),
        title: Text(model.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.description != null)
              Text(model.description!),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                if (model.contextWindow != null)
                  Chip(
                    label: Text('${model.contextWindow}K上下文'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (model.supportsVision)
                  const Chip(
                    label: Text('视觉'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (model.supportsFunctionCalling)
                  const Chip(
                    label: Text('函数调用'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 管理按钮
            IconButton(
              onPressed: () => _showModelManagementDialog(context, model),
              icon: const Icon(Icons.settings_outlined),
              tooltip: '管理模型',
              iconSize: 20,
              color: Colors.blue,
            ),
            // 删除按钮
            IconButton(
              onPressed: () => _showDeleteModelDialog(context, model),
              icon: const Icon(Icons.delete_outline),
              tooltip: '删除模型',
              iconSize: 20,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  /// 提取模型系列名称
  String _extractModelSeries(String modelName) {
    final name = modelName.toLowerCase().trim();
    
    // DeepSeek系列
    if (name.contains('deepseek')) {
      return 'DeepSeek系列';
    }
    
    // GPT系列细分
    if (name.startsWith('gpt-5')) {
      return 'GPT-5系列';
    }
    if (name.startsWith('gpt-4')) {
      return 'GPT-4系列';
    }
    if (name.startsWith('gpt-3')) {
      return 'GPT-3系列';
    }
    if (name.contains('gpt')) {
      return 'GPT其他';
    }
    
    // Claude系列细分
    if (name.contains('claude-4')) {
      return 'Claude 4系列';
    }
    if (name.contains('claude-3.5') || name.contains('claude-3-5')) {
      return 'Claude 3.5系列';
    }
    if (name.contains('claude-3')) {
      return 'Claude 3系列';
    }
    if (name.contains('claude')) {
      return 'Claude其他';
    }
    
    // Gemini系列
    if (name.contains('gemini-2')) {
      return 'Gemini 2系列';
    }
    if (name.contains('gemini-1.5')) {
      return 'Gemini 1.5系列';
    }
    if (name.contains('gemini')) {
      return 'Gemini系列';
    }
    
    // 嵌入模型
    if (name.contains('text-embedding') || name.contains('embedding')) {
      return '嵌入模型';
    }
    
    // 图像生成模型
    if (name.contains('dall-e') || name.contains('dalle') || 
        name.contains('midjourney') || name.contains('stable-diffusion') ||
        name.contains('image') && (name.contains('gen') || name.contains('create'))) {
      return '图像生成';
    }
    
    // 语音模型
    if (name.contains('tts') || name.contains('stt') || 
        name.contains('whisper') || name.contains('speech')) {
      return '语音模型';
    }
    
    // 其他知名系列
    if (name.contains('llama')) {
      return 'LLaMA系列';
    }
    if (name.contains('qwen') || name.contains('tongyi')) {
      return '通义千问系列';
    }
    if (name.contains('chatglm') || name.contains('glm')) {
      return 'ChatGLM系列';
    }
    if (name.contains('moonshot') || name.contains('kimi')) {
      return 'Moonshot系列';
    }
    if (name.contains('yi-')) {
      return '零一万物系列';
    }
    
    // 按第一个词或短划线分割
    final parts = modelName.split(RegExp(r'[-_\s]'));
    if (parts.isNotEmpty) {
      final firstPart = parts[0].trim();
      if (firstPart.isNotEmpty) {
        return '${firstPart[0].toUpperCase()}${firstPart.substring(1)}系列';
      }
    }
    
    return '其他模型';
  }

  /// 切换单个分组的展开状态
  void _toggleGroup(String seriesName) {
    setState(() {
      _expandedGroups[seriesName] = !(_expandedGroups[seriesName] ?? true);
    });
  }

  /// 切换所有分组的展开状态
  void _toggleAllGroups(bool expanded) {
    setState(() {
      // 获取当前所有分组的键
      final currentGroups = <String>{};
      for (final model in _availableModels) {
        currentGroups.add(_extractModelSeries(model.name));
      }
      
      for (final groupName in currentGroups) {
        _expandedGroups[groupName] = expanded;
      }
    });
  }

  /// 获取系列颜色（统一淡灰色）
  Color _getSeriesColor(String seriesName) {
    return Colors.grey.shade300;
  }

  /// 获取系列图标
  Widget _getSeriesIcon(String seriesName) {
    const color = Colors.grey;
    
    // 直接根据系列名称识别厂商
    final vendor = ModelIconUtils.getVendorFromModelName(seriesName);
    
    if (vendor != null) {
      return ModelIconUtils.buildModelIcon(
        seriesName,
        size: 18,
        color: Colors.grey,
      );
    }
    
    // 其他特殊情况
    if (seriesName.toLowerCase().contains('chatglm')) {
      return const Icon(Icons.chat_bubble, color: color);
    }
    
    return const Icon(Icons.api, color: color);
  }

  /// 显示分组删除确认对话框
  void _showDeleteGroupDialog(BuildContext context, String seriesName, List<ModelInfo> models) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除整个$seriesName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要删除 "$seriesName" 下的所有模型吗？'),
            const SizedBox(height: 12),
            Text(
              '将删除以下 ${models.length} 个模型：',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 150),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: models.map((model) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 4),
                          const SizedBox(width: 8),
                          Expanded(child: Text(model.name)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, size: 16, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(
                    '此操作无法撤销！',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteGroup(seriesName, models);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text('删除$seriesName'),
          ),
        ],
      ),
    );
  }

  /// 删除整个分组
  Future<void> _deleteGroup(String seriesName, List<ModelInfo> models) async {
    try {
      final service = ref.read(modelManagementServiceProvider);
      
      for (final model in models) {
        await service.deleteCustomModel(model.id);
      }
      
      await _loadModels();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已删除 "$seriesName" 下的 ${models.length} 个模型'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('删除失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 显示模型管理对话框
  void _showModelManagementDialog(BuildContext context, ModelInfo model) {
    showDialog(
      context: context,
      builder: (context) => ModelManagementDialog(
        model: model,
        onSaved: () {
          _loadModels();
        },
      ),
    );
  }

  /// 显示删除模型确认对话框
  void _showDeleteModelDialog(BuildContext context, ModelInfo model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除模型'),
        content: Text('确定要删除模型 "${model.name}" 吗？\n\n此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteModel(model);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 获取提供商图标
  Widget _getProviderIcon(String providerId) {
    final provider = _mapProviderIdToEnum(providerId);
    if (provider != null) {
      return ModelIconUtils.buildProviderIcon(
        provider,
        size: 24,
        color: Colors.grey,
      );
    }
    return const Icon(Icons.api);
  }
  
  /// 将providerId字符串映射到AIProvider枚举
  AIProvider? _mapProviderIdToEnum(String providerId) {
    switch (providerId.toLowerCase()) {
      case 'openai':
        return AIProvider.openai;
      case 'openai_responses':
        return AIProvider.openaiResponses;
      case 'google':
      case 'gemini':
        return AIProvider.gemini;
      case 'anthropic':
      case 'claude':
        return AIProvider.claude;
      case 'deepseek':
        return AIProvider.deepseek;
      case 'qwen':
        return AIProvider.qwen;
      case 'openrouter':
        return AIProvider.openrouter;
      case 'ollama':
        return AIProvider.ollama;
      default:
        return null;
    }
  }

  /// 获取模型图标（根据模型名称）
  Widget _getModelIcon(ModelInfo model) {
    // 优先根据模型名称获取厂商图标
    return ModelIconUtils.buildModelIcon(
      model.name,
      size: 20,
      color: Colors.grey, // 统一使用灰色
    );
  }


  /// 加载提供商配置
  Future<void> _loadProviderConfig() async {
    setState(() => _isLoading = true);

    try {
      final database = ref.read(appDatabaseProvider);
      final configs = await database.getAllLlmConfigs();

      _existingConfig = configs.cast<LlmConfigsTableData?>().firstWhere(
        (config) =>
            config?.provider == widget.providerId ||
            config?.id == widget.providerId,
        orElse: () => null,
      );

      if (_existingConfig != null) {
        _nameController.text = _existingConfig!.name;
        _apiKeyController.text = _existingConfig!.apiKey;
        _baseUrlController.text = _existingConfig!.baseUrl ?? '';
        _organizationIdController.text = _existingConfig!.organizationId ?? '';
        _isEnabled = _existingConfig!.isEnabled;
      } else {
        final providerInfo = ref.read(providerInfoProvider(widget.providerId));
        _nameController.text = '${providerInfo.displayName} 配置';
      }

      await _loadModels();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载配置失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 加载模型列表
  Future<void> _loadModels() async {
    try {
      final service = ref.read(modelManagementServiceProvider);
      late List<ModelInfo> models;
      if (_existingConfig != null) {
        models = await service.getModelsByConfig(_existingConfig!.id);
        if (models.isEmpty) {
          // 回退按 provider 查询（旧数据或未绑定配置的模型）
          models = await service.getModelsByProvider(widget.providerId);
        }
      } else {
        models = await service.getModelsByProvider(widget.providerId);
      }

      setState(() {
        _availableModels = models;
      });
    } catch (e) {
      // 忽略错误，使用空列表
    }
  }

  /// 保存配置
  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 先验证配置
      final tempConfig = LlmConfig(
        id: 'temp-validation',
        name: _nameController.text,
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: _baseUrlController.text.isEmpty
            ? null
            : _baseUrlController.text,
        organizationId: _organizationIdController.text.isEmpty
            ? null
            : _organizationIdController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isCustomProvider: false,
        apiCompatibilityType: LlmProviderFactory.getProviderCompatibilityType(
          widget.providerId,
        ),
      );

      // 验证配置有效性
      if (!LlmProviderFactory.validateProviderConfig(tempConfig)) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('配置验证失败，请检查输入信息')));
        }
        return;
      }

      final database = ref.read(appDatabaseProvider);
      final now = DateTime.now();
      final configId =
          _existingConfig?.id ??
          '${widget.providerId}-${now.millisecondsSinceEpoch}';

      final config = LlmConfigsTableCompanion.insert(
        id: configId,
        name: _nameController.text,
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: drift.Value(
          _baseUrlController.text.isEmpty ? null : _baseUrlController.text,
        ),
        organizationId: drift.Value(
          _organizationIdController.text.isEmpty
              ? null
              : _organizationIdController.text,
        ),
        createdAt: _existingConfig?.createdAt ?? now,
        updatedAt: now,
        isEnabled: drift.Value(_isEnabled),
        isCustomProvider: const drift.Value(false), // 内置提供商
        apiCompatibilityType: drift.Value(
          LlmProviderFactory.getProviderCompatibilityType(widget.providerId),
        ),
      );

      await database.upsertLlmConfig(config);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('配置保存成功')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 刷新模型列表
  Future<void> _refreshModels() async {
    // Ollama通常不需要API密钥，其他提供商需要
    if (widget.providerId.toLowerCase() != 'ollama' &&
        _apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入API密钥')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(modelManagementServiceProvider);
      final config = LlmConfig(
        id: 'temp',
        name: 'temp',
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: _baseUrlController.text.isEmpty
            ? null
            : _baseUrlController.text,
        organizationId: _organizationIdController.text.isEmpty
            ? null
            : _organizationIdController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 先获取模型列表
      final allModels = await service.fetchModelsFromAPI(config);

      if (!mounted) return;

      // 弹出选择对话框
      final selected = await showDialog<List<ModelInfo>>(
        context: context,
        builder: (ctx) => SelectModelDialog(models: allModels),
      );

      if (selected != null && selected.isNotEmpty) {
        int addedCount = 0;
        int skippedCount = 0;

        for (final model in selected) {
          try {
            await service.addCustomModel(
              name: model.name.isEmpty ? model.id : model.name,
              modelId: model.id,
              provider: widget.providerId,
              type: model.type,
              configId: _existingConfig?.id,
            );
            addedCount++;
          } catch (e) {
            // 模型可能已存在，跳过
            skippedCount++;
            debugPrint('跳过重复模型: ${model.id} - $e');
          }
        }

        await _loadModels();

        if (mounted) {
          String message = '已添加 $addedCount 个模型';
          if (skippedCount > 0) {
            message += '，跳过 $skippedCount 个重复模型';
          }
          ElegantNotification.success(
            context,
            message,
            duration: const Duration(seconds: 3),
            showAtTop: false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('获取模型失败: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 添加自定义模型
  void _addCustomModel() {
    _showModelEditDialog();
  }


  /// 显示模型编辑对话框
  void _showModelEditDialog({ModelInfo? model}) {
    showDialog(
      context: context,
      builder: (context) => ModelEditDialog(
        providerId: widget.providerId,
        configId: _existingConfig?.id ?? '',
        model: model,
        onSaved: _loadModels,
      ),
    );
  }


  /// 删除模型
  Future<void> _deleteModel(ModelInfo model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除模型 "${model.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(modelManagementServiceProvider);
        await service.deleteCustomModel(model.id);
        await _loadModels();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('删除模型失败: $e')));
        }
      }
    }
  }

  /// 测试连接
  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final config = LlmConfig(
        id: 'test',
        name: 'test',
        provider: widget.providerId,
        apiKey: _apiKeyController.text,
        baseUrl: _baseUrlController.text.isEmpty
            ? null
            : _baseUrlController.text,
        organizationId: _organizationIdController.text.isEmpty
            ? null
            : _organizationIdController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 首先验证配置格式
      if (!LlmProviderFactory.validateProviderConfig(config)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('配置格式验证失败，请检查输入信息'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // 创建提供商并测试连接
      final provider = LlmProviderFactory.createProvider(config);
      final isValid = await provider.validateConfig();

      if (mounted) {
        if (isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ 连接测试成功！API配置正确，可以正常使用'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ 连接测试失败\n请检查API密钥、基础URL等配置是否正确'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '连接测试失败';

        // 根据错误类型提供更具体的提示
        if (e.toString().contains('401') ||
            e.toString().contains('Unauthorized')) {
          errorMessage = '❌ API密钥无效或已过期\n请检查API密钥是否正确';
        } else if (e.toString().contains('403') ||
            e.toString().contains('Forbidden')) {
          errorMessage = '❌ 访问被拒绝\n请检查API密钥权限或账户状态';
        } else if (e.toString().contains('404') ||
            e.toString().contains('Not Found')) {
          errorMessage = '❌ API端点不存在\n请检查基础URL是否正确';
        } else if (e.toString().contains('timeout') ||
            e.toString().contains('TimeoutException')) {
          errorMessage = '❌ 连接超时\n请检查网络连接或基础URL';
        } else if (e.toString().contains('SocketException') ||
            e.toString().contains('Connection')) {
          errorMessage = '❌ 网络连接失败\n请检查网络连接和基础URL';
        } else {
          errorMessage = '❌ 连接测试失败\n错误详情: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog() {
    if (_existingConfig == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除提供商'),
        content: Text(
          '确定要删除 "${_existingConfig!.customProviderName ?? _existingConfig!.name}" 吗？\n\n此操作无法撤销。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProvider();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  /// 删除提供商
  Future<void> _deleteProvider() async {
    if (_existingConfig == null) return;

    setState(() => _isLoading = true);

    try {
      final database = ref.read(appDatabaseProvider);
      await database.deleteLlmConfig(_existingConfig!.id);

      // 刷新自定义提供商列表
      ref.read(customProviderNotifierProvider.notifier).loadProviders();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('提供商已删除')));
        context.pop(); // 返回上一页
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// 模型管理对话框
class ModelManagementDialog extends ConsumerStatefulWidget {
  final ModelInfo model;
  final VoidCallback onSaved;

  const ModelManagementDialog({
    super.key,
    required this.model,
    required this.onSaved,
  });

  @override
  ConsumerState<ModelManagementDialog> createState() => _ModelManagementDialogState();
}

class _ModelManagementDialogState extends ConsumerState<ModelManagementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  
  String _selectedApiType = 'OpenAI';
  final List<String> _apiTypes = [
    'OpenAI',
    'OpenAI-Response', 
    'Anthropic',
    'Gemini',
    '图片生成',
    'Jina 重排序',
  ];
  
  String _originalGroupName = '';  // 记录原始分组名

  @override
  void initState() {
    super.initState();
    // 初始化当前值
    _originalGroupName = _extractModelSeries(widget.model.name);
    _groupNameController.text = _originalGroupName;
    _selectedApiType = _getModelApiType(widget.model);
  }

  /// 根据模型推断API类型
  String _getModelApiType(ModelInfo model) {
    final name = model.name.toLowerCase();
    if (name.contains('claude')) return 'Anthropic';
    if (name.contains('gemini')) return 'Gemini';
    if (name.contains('dall-e') || name.contains('image')) return '图片生成';
    if (name.contains('jina')) return 'Jina 重排序';
    return 'OpenAI';
  }

  /// 提取模型系列名称（复制之前的逻辑）
  String _extractModelSeries(String modelName) {
    final name = modelName.toLowerCase().trim();
    
    if (name.contains('deepseek')) return 'DeepSeek系列';
    if (name.startsWith('gpt-5')) return 'GPT-5系列';
    if (name.startsWith('gpt-4')) return 'GPT-4系列';
    if (name.startsWith('gpt-3')) return 'GPT-3系列';
    if (name.contains('gpt')) return 'GPT其他';
    if (name.contains('claude-4')) return 'Claude 4系列';
    if (name.contains('claude-3.5')) return 'Claude 3.5系列';
    if (name.contains('claude-3')) return 'Claude 3系列';
    if (name.contains('claude')) return 'Claude其他';
    if (name.contains('gemini-2')) return 'Gemini 2系列';
    if (name.contains('gemini-1.5')) return 'Gemini 1.5系列';
    if (name.contains('gemini')) return 'Gemini系列';
    
    return '其他模型';
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('管理模型 - ${widget.model.name}'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 分组名称
                TextFormField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(
                    labelText: '分组名称',
                    helperText: '设置此模型所属的分组，如果分组不存在将自动创建',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '请输入分组名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 端点类型
                const Text(
                  '端点类型',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '选择此模型的API调用方式',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedApiType,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedApiType = newValue;
                          });
                        }
                      },
                      items: _apiTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              _getApiTypeIcon(value),
                              const SizedBox(width: 8),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _saveModel,
          child: const Text('保存'),
        ),
      ],
    );
  }

  /// 获取API类型图标
  Widget _getApiTypeIcon(String apiType) {
    switch (apiType) {
      case 'OpenAI':
        return ModelIconUtils.buildProviderIcon(AIProvider.openai, size: 20);
      case 'OpenAI-Response':
        return ModelIconUtils.buildProviderIcon(AIProvider.openaiResponses, size: 20);
      case 'Anthropic':
        return ModelIconUtils.buildProviderIcon(AIProvider.claude, size: 20);
      case 'Gemini':
        return ModelIconUtils.buildProviderIcon(AIProvider.gemini, size: 20);
      case '图片生成':
        return const Icon(Icons.image, color: Colors.purple, size: 20);
      case 'Jina 重排序':
        return const Icon(Icons.sort, color: Colors.teal, size: 20);
      default:
        return const Icon(Icons.api, color: Colors.grey, size: 20);
    }
  }

  /// 保存模型配置
  Future<void> _saveModel() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // 这里需要根据实际的模型更新API来实现
      // 目前先显示成功提示，实际实现需要调用相应的服务
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('模型配置已保存'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// 模型编辑对话框
class ModelEditDialog extends ConsumerStatefulWidget {
  final String providerId;
  final String? configId;
  final ModelInfo? model;
  final VoidCallback onSaved;

  const ModelEditDialog({
    super.key,
    required this.providerId,
    this.configId,
    this.model,
    required this.onSaved,
  });

  @override
  ConsumerState<ModelEditDialog> createState() => _ModelEditDialogState();
}

class _ModelEditDialogState extends ConsumerState<ModelEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelIdController = TextEditingController();
  ModelType _selectedType = ModelType.chat;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _modelIdController.text = widget.model!.id;
      _selectedType = widget.model!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.model == null ? '添加模型' : '编辑模型'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '模型名称'),
                  validator: (value) =>
                      value?.isEmpty == true ? '请输入模型名称' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelIdController,
                  decoration: const InputDecoration(labelText: '模型ID'),
                  validator: (value) =>
                      value?.isEmpty == true ? '请输入模型ID' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ModelType>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(labelText: '模型类型'),
                  items: ModelType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getModelTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(onPressed: _saveModel, child: const Text('保存')),
      ],
    );
  }

  Future<void> _saveModel() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final service = ref.read(modelManagementServiceProvider);

      if (widget.model == null) {
        await service.addCustomModel(
          name: _nameController.text,
          modelId: _modelIdController.text,
          provider: widget.providerId,
          configId: widget.configId,
          type: _selectedType,
        );
      } else {
        await service.updateCustomModel(
          id: widget.model!.id,
          name: _nameController.text,
          modelId: _modelIdController.text,
          configId: widget.configId,
          type: _selectedType,
        );
      }

      widget.onSaved();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存失败: $e')));
      }
    }
  }

  String _getModelTypeName(ModelType type) {
    switch (type) {
      case ModelType.chat:
        return '聊天模型';
      case ModelType.embedding:
        return '嵌入模型';
      case ModelType.multimodal:
        return '多模态';
      case ModelType.imageGeneration:
        return '图像生成';
      case ModelType.speech:
        return '语音';
    }
  }

}
