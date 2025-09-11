import 'package:flutter/material.dart';

/// Web 预览版：设置页（本地状态，不持久化）
class SettingsTabWeb extends StatefulWidget {
  const SettingsTabWeb({super.key});

  @override
  State<SettingsTabWeb> createState() => _SettingsTabWebState();
}

class _SettingsTabWebState extends State<SettingsTabWeb> {
  // 模型参数
  String _reasoning = 'auto';
  int _maxReasoningTokens = 2048;
  double _temperature = 0.7;
  double _contextLength = 8;
  bool _enableMaxTokens = false;
  double _maxTokens = 1024;

  // 代码块设置
  String _mathEngine = 'katex';
  bool _codeEdit = false;
  bool _lineNumbers = true;
  bool _codeFolding = true;

  // 常规
  bool _markdown = true;
  bool _autosave = true;
  bool _notifications = false;

  bool _paramsExpanded = true;
  bool _codeExpanded = false;
  bool _generalExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置（Web 预览）')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            context,
            title: '模型参数', icon: Icons.tune, expanded: _paramsExpanded, onToggle: ()=>setState(()=>_paramsExpanded=!_paramsExpanded),
            child: Column(children: [
              Row(children: [const Icon(Icons.psychology, size: 18), const SizedBox(width: 8), Text('思考强度')]),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(value: _reasoning, items: const [
                  DropdownMenuItem(value: 'off', child: Text('不启用')),
                  DropdownMenuItem(value: 'auto', child: Text('AUTO')),
                  DropdownMenuItem(value: 'low', child: Text('LOW')),
                  DropdownMenuItem(value: 'medium', child: Text('MEDIUM')),
                  DropdownMenuItem(value: 'high', child: Text('HIGH')),
                ], onChanged: (v){ if(v!=null) setState(()=>_reasoning=v); }),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('最大思考Tokens'), Text('$_maxReasoningTokens'),
              ]),
              Slider(value: _maxReasoningTokens.toDouble(), min: 0, max: 8000, divisions: 80, onChanged: (v)=>setState(()=>_maxReasoningTokens=v.round())),
              const SizedBox(height: 8),
              _slider(context, '温度 (Temperature)', _temperature, 0, 2, 20, (v)=>setState(()=>_temperature=v)),
              const SizedBox(height: 8),
              _slider(context, '上下文窗口（消息数）', _contextLength, 0, 20, 20, (v)=>setState(()=>_contextLength=v)),
              if (_enableMaxTokens) ...[
                const SizedBox(height: 8),
                _slider(context, '最大Token数', _maxTokens, 100, 4000, 39, (v)=>setState(()=>_maxTokens=v)),
              ],
              SwitchListTile(title: const Text('启用最大Token限制'), value: _enableMaxTokens, onChanged: (v)=>setState(()=>_enableMaxTokens=v), contentPadding: EdgeInsets.zero),
              Text('提示：该页为预览，不会保存设置。', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ]),
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: '代码块设置', icon: Icons.code, expanded: _codeExpanded, onToggle: ()=>setState(()=>_codeExpanded=!_codeExpanded),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('数学渲染引擎'),
                DropdownButton<String>(value: _mathEngine, items: const [DropdownMenuItem(value: 'katex', child: Text('KaTeX')), DropdownMenuItem(value: 'mathjax', child: Text('MathJax'))], onChanged: (v){ if(v!=null) setState(()=>_mathEngine=v); }),
              ]),
              SwitchListTile(title: const Text('启用代码编辑'), subtitle: const Text('允许编辑代码块内容'), value: _codeEdit, onChanged: (v)=>setState(()=>_codeEdit=v), contentPadding: EdgeInsets.zero),
              SwitchListTile(title: const Text('显示行号'), subtitle: const Text('在代码块左侧显示行号'), value: _lineNumbers, onChanged: (v)=>setState(()=>_lineNumbers=v), contentPadding: EdgeInsets.zero),
              SwitchListTile(title: const Text('启用代码折叠'), subtitle: const Text('长代码块可以折叠显示'), value: _codeFolding, onChanged: (v)=>setState(()=>_codeFolding=v), contentPadding: EdgeInsets.zero),
            ]),
          ),
          const SizedBox(height: 12),
          _section(
            context,
            title: '常规设置', icon: Icons.settings, expanded: _generalExpanded, onToggle: ()=>setState(()=>_generalExpanded=!_generalExpanded),
            child: Column(children: [
              SwitchListTile(title: const Text('启用Markdown渲染'), value: _markdown, onChanged: (v)=>setState(()=>_markdown=v), contentPadding: EdgeInsets.zero),
              SwitchListTile(title: const Text('自动保存'), value: _autosave, onChanged: (v)=>setState(()=>_autosave=v), contentPadding: EdgeInsets.zero),
              SwitchListTile(title: const Text('启用通知'), value: _notifications, onChanged: (v)=>setState(()=>_notifications=v), contentPadding: EdgeInsets.zero),
            ]),
          ),
          const SizedBox(height: 24),
          OutlinedButton(onPressed: (){ setState((){
            _reasoning='auto'; _maxReasoningTokens=2048; _temperature=0.7; _contextLength=8; _enableMaxTokens=false; _maxTokens=1024; _mathEngine='katex'; _codeEdit=false; _lineNumbers=true; _codeFolding=true; _markdown=true; _autosave=true; _notifications=false;});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('仅预览：已重置设置')));
          }, child: const Text('重置所有设置')),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, {required String title, required IconData icon, required bool expanded, required VoidCallback onToggle, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Column(children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
              Icon(expanded ? Icons.expand_less : Icons.expand_more),
            ]),
          ),
        ),
        if (expanded) const Divider(height: 1),
        if (expanded) Padding(padding: const EdgeInsets.all(16), child: child),
      ]),
    );
  }

  Widget _slider(BuildContext context, String label, double value, double min, double max, int divisions, void Function(double) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        Text(value.toStringAsFixed(2), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
      Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
    ]);
  }
}

