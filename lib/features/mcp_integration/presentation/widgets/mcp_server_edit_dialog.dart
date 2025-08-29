import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  
  // JSON导入相关
  final TextEditingController _jsonController = TextEditingController();
  bool _showJsonImport = false;

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
    _jsonController.dispose();
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

  /// 构建手动表单
  Widget _buildManualForm() {
    return Form(
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
    );
  }

  /// 构建JSON导入表单
  Widget _buildJsonImportForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'JSON配置导入',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          '支持格式示例：{"mcpServers": {"server-name": {"type": "sse", "url": "https://example.com"}}}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        // JSON输入框
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 工具栏
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('JSON配置'),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _pasteFromClipboard,
                      icon: const Icon(Icons.paste, size: 16),
                      label: const Text('从剪贴板粘贴'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _clearJsonInput,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('清空'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    ),
                  ],
                ),
              ),
              // JSON编辑器
              TextField(
                controller: _jsonController,
                decoration: const InputDecoration(
                  hintText: '在此粘贴JSON配置...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 15,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 解析和保存按钮
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _parseJsonConfig,
              icon: const Icon(Icons.transform, size: 16),
              label: const Text('解析并填充表单'),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: _parseAndSaveJson,
              icon: const Icon(Icons.save, size: 16),
              label: const Text('解析并保存'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _showJsonImport = false;
                });
              },
              child: const Text('切换到手动模式'),
            ),
          ],
        ),
        if (_jsonController.text.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue[700], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '解析JSON配置后会自动填充到表单字段中，您可以切换到手动模式进行进一步编辑',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// 从剪贴板粘贴
  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        setState(() {
          _jsonController.text = clipboardData!.text!;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已从剪贴板粘贴配置')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('粘贴失败: $e')),
        );
      }
    }
  }

  /// 清空JSON输入
  void _clearJsonInput() {
    setState(() {
      _jsonController.clear();
    });
  }

  /// 解析JSON配置
  void _parseJsonConfig({bool showSuccessMessage = true}) {
    if (_jsonController.text.trim().isEmpty) {
      if (showSuccessMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请先输入JSON配置')),
        );
      }
      return;
    }

    try {
      final jsonData = json.decode(_jsonController.text);
      
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('mcpServers')) {
        final servers = jsonData['mcpServers'] as Map<String, dynamic>;
        
        if (servers.isEmpty) {
          if (showSuccessMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('JSON中未找到服务器配置')),
            );
          }
          return;
        }

        // 取第一个服务器配置（如果有多个，用户可以选择）
        final serverEntry = servers.entries.first;
        final serverName = serverEntry.key;
        final serverConfig = serverEntry.value as Map<String, dynamic>;

        _fillFormFromJson(serverName, serverConfig);
        
        if (showSuccessMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已解析配置: $serverName')),
          );

          // 如果有多个服务器，提示用户
          if (servers.length > 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('检测到${servers.length}个服务器配置，已导入第一个: $serverName'),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        if (showSuccessMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('JSON格式不正确，请检查格式')),
          );
        }
      }
    } catch (e) {
      if (showSuccessMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('JSON解析失败: $e')),
        );
      }
    }
  }

  /// 解析JSON并直接保存
  void _parseAndSaveJson() {
    if (_jsonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先输入JSON配置')),
      );
      return;
    }

    try {
      final jsonData = json.decode(_jsonController.text);
      
      if (jsonData is Map<String, dynamic> && jsonData.containsKey('mcpServers')) {
        final servers = jsonData['mcpServers'] as Map<String, dynamic>;
        
        if (servers.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('JSON中未找到服务器配置')),
          );
          return;
        }

        // 取第一个服务器配置
        final serverEntry = servers.entries.first;
        final serverName = serverEntry.key;
        final serverConfig = serverEntry.value as Map<String, dynamic>;

        // 填充表单
        _fillFormFromJson(serverName, serverConfig);
        
        // 立即保存
        _performSave();
        
        // 如果有多个服务器，提示用户
        if (servers.length > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('检测到${servers.length}个服务器配置，已保存第一个: $serverName'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('JSON格式不正确，请检查格式')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON解析失败: $e')),
      );
    }
  }

  /// 从JSON填充表单
  void _fillFormFromJson(String serverName, Map<String, dynamic> config) {
    setState(() {
      // 基础信息
      _nameController.text = serverName;
      _baseUrlController.text = config['url'] ?? '';
      
      // 连接类型
      final typeString = config['type']?.toString().toLowerCase() ?? 'sse';
      _selectedType = typeString == 'streamablehttp' ? McpTransportType.streamableHttp : McpTransportType.sse;
      
      // 超时设置
      if (config['timeout'] != null) {
        _timeoutController.text = config['timeout'].toString();
      } else {
        _timeoutController.text = '30';
      }
      
      // 长时间运行设置
      _longRunning = config['longRunning'] == true;
      
      // Headers
      _headers.clear();
      if (config['headers'] is Map) {
        final headers = config['headers'] as Map<String, dynamic>;
        _headers.addAll(headers.map((key, value) => MapEntry(key, value.toString())));
      }
      
      // OAuth设置
      _clientIdController.text = config['clientId']?.toString() ?? '';
      _clientSecretController.text = config['clientSecret']?.toString() ?? '';
      _authEndpointController.text = config['authorizationEndpoint']?.toString() ?? '';
      _tokenEndpointController.text = config['tokenEndpoint']?.toString() ?? '';
      _showOAuthSettings = _clientIdController.text.isNotEmpty;
    });
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
            // 标题和JSON导入切换
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
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showJsonImport = !_showJsonImport;
                    });
                  },
                  icon: Icon(_showJsonImport ? Icons.edit : Icons.code),
                  label: Text(_showJsonImport ? '表单模式' : 'JSON导入'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
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
                child: _showJsonImport ? _buildJsonImportForm() : _buildManualForm(),
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
            if (!Uri.tryParse(value)!.hasScheme == true) {
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
    // 在JSON导入模式下，如果字段为空，尝试先自动解析JSON
    if (_showJsonImport) {
      if (_nameController.text.trim().isEmpty && _jsonController.text.trim().isNotEmpty) {
        // 静默解析JSON，不显示成功消息
        _parseJsonConfig(showSuccessMessage: false);
        // 立即继续保存
        _performSave();
        return;
      } else if (_nameController.text.trim().isEmpty && _jsonController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请输入JSON配置或切换到手动模式')),
        );
        return;
      }
    } else {
      // 表单模式下进行表单验证
      if (_formKey.currentState?.validate() != true) {
        return;
      }
    }
    
    _performSave();
  }

  /// 执行实际的保存操作
  void _performSave() {
    // 基础字段验证
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入服务器名称')),
      );
      return;
    }
    
    if (_baseUrlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入服务器URL')),
      );
      return;
    }
    
    // URL格式验证
    final uri = Uri.tryParse(_baseUrlController.text.trim());
    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的URL')),
      );
      return;
    }
    
    // 创建服务器配置
    final config = McpServerConfig(
      id: widget.server?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      baseUrl: _baseUrlController.text.trim(),
      type: _selectedType,
      headers: _headers.isNotEmpty ? Map.from(_headers) : null,
      timeout: int.tryParse(_timeoutController.text),
      longRunning: _longRunning,
      clientId: _showOAuthSettings && _clientIdController.text.trim().isNotEmpty 
          ? _clientIdController.text.trim() : null,
      clientSecret: _showOAuthSettings && _clientSecretController.text.trim().isNotEmpty 
          ? _clientSecretController.text.trim() : null,
      authorizationEndpoint: _showOAuthSettings && _authEndpointController.text.trim().isNotEmpty 
          ? _authEndpointController.text.trim() : null,
      tokenEndpoint: _showOAuthSettings && _tokenEndpointController.text.trim().isNotEmpty 
          ? _tokenEndpointController.text.trim() : null,
      createdAt: widget.server?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(config);
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