import 'package:flutter/material.dart';
import '../../domain/entities/mcp_server_config.dart';

/// MCP服务器编辑对话框
class McpServerEditDialog extends StatefulWidget {
  final String title;
  final McpServerConfig? server;
  final Function(McpServerConfig) onSave;

  const McpServerEditDialog({
    super.key,
    required this.title,
    this.server,
    required this.onSave,
  });

  @override
  State<McpServerEditDialog> createState() => _McpServerEditDialogState();
}

class _McpServerEditDialogState extends State<McpServerEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _timeoutController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  final _authEndpointController = TextEditingController();
  final _tokenEndpointController = TextEditingController();

  McpTransportType _selectedType = McpTransportType.sse;
  bool _longRunning = false;
  bool _showOAuthSettings = false;
  final Map<String, String> _headers = {};

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _baseUrlController.dispose();
    _timeoutController.dispose();
    _clientIdController.dispose();
    _clientSecretController.dispose();
    _authEndpointController.dispose();
    _tokenEndpointController.dispose();
    super.dispose();
  }

  void _initializeFields() {
    if (widget.server != null) {
      final server = widget.server!;
      _nameController.text = server.name;
      _baseUrlController.text = server.baseUrl;
      _selectedType = server.type;
      _timeoutController.text = (server.timeout ?? 30).toString();
      _longRunning = server.longRunning ?? false;
      
      // OAuth字段
      _clientIdController.text = server.clientId ?? '';
      _clientSecretController.text = server.clientSecret ?? '';
      _authEndpointController.text = server.authorizationEndpoint ?? '';
      _tokenEndpointController.text = server.tokenEndpoint ?? '';
      _showOAuthSettings = server.clientId?.isNotEmpty == true;

      // Headers
      if (server.headers != null) {
        _headers.addAll(server.headers!);
      }
    } else {
      _timeoutController.text = '30';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 表单内容
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicSettings(),
                      const SizedBox(height: 24),
                      _buildConnectionSettings(),
                      const SizedBox(height: 24),
                      _buildHeadersSettings(),
                      const SizedBox(height: 24),
                      _buildOAuthSettings(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 操作按钮
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// 构建基础设置
  Widget _buildBasicSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '基础设置',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        // 服务器名称
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: '服务器名称 *',
            hintText: '例如：My API Server',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入服务器名称';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // 基础URL
        TextFormField(
          controller: _baseUrlController,
          decoration: const InputDecoration(
            labelText: '服务器URL *',
            hintText: '例如：https://api.example.com/mcp',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入服务器URL';
            }
            if (!Uri.tryParse(value)?.hasScheme == true) {
              return '请输入有效的URL';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// 构建连接设置
  Widget _buildConnectionSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '连接设置',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        // 传输类型
        DropdownButtonFormField<McpTransportType>(
          initialValue: _selectedType,
          decoration: const InputDecoration(
            labelText: '连接类型',
            border: OutlineInputBorder(),
          ),
          items: McpTransportType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Icon(
                    type == McpTransportType.sse 
                        ? Icons.stream 
                        : Icons.http,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(_getTransportTypeName(type)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedType = value;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        // 超时设置
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _timeoutController,
                decoration: const InputDecoration(
                  labelText: '超时时间 (秒)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isNotEmpty == true) {
                    final timeout = int.tryParse(value!);
                    if (timeout == null || timeout < 1) {
                      return '请输入有效的超时时间';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            // 长时间运行开关
            Expanded(
              child: SwitchListTile(
                title: const Text('长时间运行'),
                subtitle: const Text('启用进度重置超时'),
                value: _longRunning,
                onChanged: (value) {
                  setState(() {
                    _longRunning = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建Headers设置
  Widget _buildHeadersSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'HTTP Headers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton.icon(
              onPressed: _addHeader,
              icon: const Icon(Icons.add),
              label: const Text('添加'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_headers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '暂无自定义Headers',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          )
        else
          ..._headers.entries.map((entry) => _buildHeaderItem(entry.key, entry.value)),
      ],
    );
  }

  /// 构建单个Header项
  Widget _buildHeaderItem(String key, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(key),
        subtitle: Text(value),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              _headers.remove(key);
            });
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }

  /// 构建OAuth设置
  Widget _buildOAuthSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'OAuth 认证',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Switch(
              value: _showOAuthSettings,
              onChanged: (value) {
                setState(() {
                  _showOAuthSettings = value;
                  if (!value) {
                    _clientIdController.clear();
                    _clientSecretController.clear();
                    _authEndpointController.clear();
                    _tokenEndpointController.clear();
                  }
                });
              },
            ),
          ],
        ),
        if (_showOAuthSettings) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _clientIdController,
            decoration: const InputDecoration(
              labelText: 'Client ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _clientSecretController,
            decoration: const InputDecoration(
              labelText: 'Client Secret',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _authEndpointController,
            decoration: const InputDecoration(
              labelText: '授权端点',
              hintText: 'https://auth.example.com/authorize',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tokenEndpointController,
            decoration: const InputDecoration(
              labelText: 'Token端点',
              hintText: 'https://auth.example.com/token',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ],
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _saveServer,
          child: const Text('保存'),
        ),
      ],
    );
  }

  /// 添加Header
  void _addHeader() {
    showDialog(
      context: context,
      builder: (context) => _HeaderEditDialog(
        onSave: (key, value) {
          setState(() {
            _headers[key] = value;
          });
        },
      ),
    );
  }

  /// 保存服务器配置
  void _saveServer() {
    if (_formKey.currentState!.validate()) {
      final config = McpServerConfig(
        id: widget.server?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        baseUrl: _baseUrlController.text.trim(),
        type: _selectedType,
        headers: _headers.isNotEmpty ? Map.from(_headers) : null,
        timeout: int.tryParse(_timeoutController.text),
        longRunning: _longRunning,
        clientId: _showOAuthSettings ? _clientIdController.text.trim() : null,
        clientSecret: _showOAuthSettings ? _clientSecretController.text.trim() : null,
        authorizationEndpoint: _showOAuthSettings ? _authEndpointController.text.trim() : null,
        tokenEndpoint: _showOAuthSettings ? _tokenEndpointController.text.trim() : null,
        createdAt: widget.server?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(config);
    }
  }

  /// 获取传输类型名称
  String _getTransportTypeName(McpTransportType type) {
    switch (type) {
      case McpTransportType.sse:
        return 'Server-Sent Events';
      case McpTransportType.streamableHttp:
        return 'Streamable HTTP';
    }
  }
}

/// Header编辑对话框
class _HeaderEditDialog extends StatefulWidget {
  final Function(String key, String value) onSave;

  const _HeaderEditDialog({required this.onSave});

  @override
  State<_HeaderEditDialog> createState() => _HeaderEditDialogState();
}

class _HeaderEditDialogState extends State<_HeaderEditDialog> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加Header'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'Header名称',
                hintText: '例如：Authorization',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入Header名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Header值',
                hintText: '例如：Bearer token123',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入Header值';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _keyController.text.trim(),
                _valueController.text.trim(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}