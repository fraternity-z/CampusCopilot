import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/mcp_server_config.dart';

/// MCP工具调用对话框
class McpToolCallDialog extends StatefulWidget {
  final McpTool tool;
  final McpServerConfig server;
  final Function(Map<String, dynamic>) onCall;

  const McpToolCallDialog({
    super.key,
    required this.tool,
    required this.server,
    required this.onCall,
  });

  @override
  State<McpToolCallDialog> createState() => _McpToolCallDialogState();
}

class _McpToolCallDialogState extends State<McpToolCallDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _values = {};
  bool _isLoading = false;
  String? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    final properties = widget.tool.inputSchema['properties'] as Map<String, dynamic>? ?? {};
    
    for (final entry in properties.entries) {
      final paramName = entry.key;
      final paramSchema = entry.value as Map<String, dynamic>;
      final defaultValue = paramSchema['default'];
      
      final controller = TextEditingController(
        text: defaultValue?.toString() ?? '',
      );
      _controllers[paramName] = controller;
      
      if (defaultValue != null) {
        _values[paramName] = defaultValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Flexible(
              child: _buildContent(),
            ),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.build,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.tool.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.server.name,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  /// 构建内容区域
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 工具描述
          if (widget.tool.description.isNotEmpty) ...[
            Text(
              '工具描述',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                widget.tool.description,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 24),
          ],
          // 参数表单
          _buildParametersForm(),
          // 结果显示
          if (_result != null || _error != null) ...[
            const SizedBox(height: 24),
            _buildResultArea(),
          ],
        ],
      ),
    );
  }

  /// 构建参数表单
  Widget _buildParametersForm() {
    final properties = widget.tool.inputSchema['properties'] as Map<String, dynamic>? ?? {};
    
    if (properties.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue[700], size: 20),
            const SizedBox(width: 8),
            const Text('此工具不需要任何参数'),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '参数设置',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...properties.entries.map((entry) => _buildParameterField(entry.key, entry.value)),
        ],
      ),
    );
  }

  /// 构建参数字段
  Widget _buildParameterField(String paramName, Map<String, dynamic> paramSchema) {
    final type = paramSchema['type'] as String? ?? 'string';
    final description = paramSchema['description'] as String?;
    final required = widget.tool.inputSchema['required'] as List<dynamic>? ?? [];
    final isRequired = required.contains(paramName);
    final enumValues = paramSchema['enum'] as List<dynamic>?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 参数标签
          Row(
            children: [
              Expanded(
                child: Text(
                  paramName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '必需',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          const SizedBox(height: 8),
          // 参数输入控件
          _buildInputWidget(paramName, paramSchema, type, enumValues, isRequired),
        ],
      ),
    );
  }

  /// 构建输入控件
  Widget _buildInputWidget(
    String paramName, 
    Map<String, dynamic> paramSchema,
    String type, 
    List<dynamic>? enumValues, 
    bool isRequired,
  ) {
    // 枚举类型使用下拉框
    if (enumValues != null && enumValues.isNotEmpty) {
      return DropdownButtonFormField<String>(
        initialValue: _values[paramName]?.toString(),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: '请选择...',
        ),
        items: enumValues.map((value) {
          return DropdownMenuItem<String>(
            value: value.toString(),
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _values[paramName] = value;
          });
        },
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '此参数为必需项';
          }
          return null;
        } : null,
      );
    }

    // 布尔类型使用开关
    if (type == 'boolean') {
      return SwitchListTile(
        title: Text('启用 $paramName'),
        value: _values[paramName] == true,
        onChanged: (value) {
          setState(() {
            _values[paramName] = value;
          });
        },
        contentPadding: EdgeInsets.zero,
      );
    }

    // 数字类型
    if (type == 'number' || type == 'integer') {
      return TextFormField(
        controller: _controllers[paramName],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: _getHintText(paramSchema, type),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: type == 'integer' 
            ? [FilteringTextInputFormatter.digitsOnly]
            : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (type == 'integer') {
              _values[paramName] = int.tryParse(value);
            } else {
              _values[paramName] = double.tryParse(value);
            }
          } else {
            _values.remove(paramName);
          }
        },
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '此参数为必需项';
          }
          if (type == 'integer' && int.tryParse(value) == null) {
            return '请输入有效的整数';
          }
          if (type == 'number' && double.tryParse(value) == null) {
            return '请输入有效的数字';
          }
          return null;
        } : null,
      );
    }

    // 数组类型
    if (type == 'array') {
      return TextFormField(
        controller: _controllers[paramName],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: '使用逗号分隔多个值',
          helperText: '例如: value1,value2,value3',
        ),
        maxLines: null,
        onChanged: (value) {
          if (value.isNotEmpty) {
            _values[paramName] = value.split(',').map((e) => e.trim()).toList();
          } else {
            _values.remove(paramName);
          }
        },
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '此参数为必需项';
          }
          return null;
        } : null,
      );
    }

    // 对象类型
    if (type == 'object') {
      return TextFormField(
        controller: _controllers[paramName],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: '输入JSON格式的对象',
          helperText: '例如: {"key": "value"}',
        ),
        maxLines: 3,
        onChanged: (value) {
          if (value.isNotEmpty) {
            try {
              // 这里应该解析JSON，简化处理
              _values[paramName] = value;
            } catch (e) {
              // 暂时存储字符串，调用时再处理
              _values[paramName] = value;
            }
          } else {
            _values.remove(paramName);
          }
        },
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return '此参数为必需项';
          }
          return null;
        } : null,
      );
    }

    // 字符串类型（默认）
    return TextFormField(
      controller: _controllers[paramName],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: _getHintText(paramSchema, type),
      ),
      maxLines: _isMultiLine(paramSchema) ? 3 : 1,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _values[paramName] = value;
        } else {
          _values.remove(paramName);
        }
      },
      validator: isRequired ? (value) {
        if (value == null || value.isEmpty) {
          return '此参数为必需项';
        }
        return null;
      } : null,
    );
  }

  /// 构建结果区域
  Widget _buildResultArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '执行结果',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _error != null ? Colors.red.withValues(alpha: 0.05) : Colors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _error != null 
                  ? Colors.red.withValues(alpha: 0.3) 
                  : Colors.green.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _error != null ? Icons.error : Icons.check_circle,
                    size: 16,
                    color: _error != null ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _error != null ? '执行失败' : '执行成功',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _error != null ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SelectableText(
                _error ?? _result ?? '',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建操作按钮
  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('关闭'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _callTool,
          child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('执行工具'),
        ),
      ],
    );
  }

  /// 调用工具
  Future<void> _callTool() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      // TODO: 实际的工具调用逻辑
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _result = 'Tool execution successful\nArguments: ${_values.toString()}';
        _isLoading = false;
      });
      
      widget.onCall(_values);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// 获取提示文本
  String _getHintText(Map<String, dynamic> paramSchema, String type) {
    final example = paramSchema['example'];
    if (example != null) {
      return '例如: $example';
    }
    
    switch (type) {
      case 'string':
        return '请输入文本...';
      case 'number':
        return '请输入数字...';
      case 'integer':
        return '请输入整数...';
      case 'boolean':
        return '选择真或假';
      case 'array':
        return '使用逗号分隔多个值';
      case 'object':
        return '输入JSON对象';
      default:
        return '请输入值...';
    }
  }

  /// 是否为多行文本
  bool _isMultiLine(Map<String, dynamic> paramSchema) {
    final format = paramSchema['format'] as String?;
    return format == 'textarea' || paramSchema['multiline'] == true;
  }
}