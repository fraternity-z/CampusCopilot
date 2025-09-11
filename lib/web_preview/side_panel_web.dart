import 'package:flutter/material.dart';

/// Web 预览：左侧呼出侧边栏（与图示相似的外观）
class SidePanelWeb extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<int>? onNavigate; // 0: chat, 1: daily, 2: settings, 3: data
  const SidePanelWeb({super.key, required this.onClose, this.onNavigate});

  @override
  State<SidePanelWeb> createState() => _SidePanelWebState();
}

class _SidePanelWebState extends State<SidePanelWeb> {
  int _tab = 2; // 0 助手 1 聊天记录 2 参数设置（默认）

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(2, 0)),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(context),
                _buildTabs(context),
                const SizedBox(height: 8),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.lightbulb, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Campus Copilot', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('智能助手', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    Widget tab(String label, IconData icon, int value) {
      final selected = _tab == value;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _tab = value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: selected ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)) : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 4),
                Text(label, style: TextStyle(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: selected ? FontWeight.w600 : FontWeight.w500)),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(children: [
        tab('助手', Icons.smart_toy_outlined, 0),
        const SizedBox(width: 8),
        tab('聊天记录', Icons.chat_outlined, 1),
        const SizedBox(width: 8),
        tab('参数设置', Icons.settings, 2),
      ]),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_tab) {
      case 0:
        return _assistants(context);
      case 1:
        return _topics(context);
      default:
        return _modelParams(context);
    }
  }

  Widget _assistants(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _navTile(context, Icons.add, '新建助手', onTap: () {}),
        const SizedBox(height: 8),
        _navTile(context, Icons.today_outlined, '前往日常', onTap: () => widget.onNavigate?.call(1)),
        const SizedBox(height: 8),
        _navTile(context, Icons.settings_outlined, '打开设置', onTap: () => widget.onNavigate?.call(2)),
      ],
    );
  }

  Widget _topics(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.forum_outlined),
        title: Text('会话 #$i'),
        subtitle: const Text('这是一个示例会话（预览）'),
        onTap: () => widget.onClose(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2))),
      ),
    );
  }

  Widget _modelParams(BuildContext context) {
    Widget slider(String label, double value, double min, double max, int divisions, ValueChanged<double> onChanged) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          Text(value.toStringAsFixed(2), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
        Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
      ]);
    }

    double temp = 0.7;
    double ctx = 6;
    int maxReasoning = 2000;
    double maxTokens = 2048;
    String effort = 'MEDIUM';

    return StatefulBuilder(builder: (context, set) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // 卡片样式（与截图接近）
          _collapseCard(
            context,
            header: Row(children: [
              const Icon(Icons.tune), const SizedBox(width: 8), const Text('模型参数', style: TextStyle(fontWeight: FontWeight.w600)),
            ]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('思考强度'),
              const SizedBox(height: 6),
              DropdownButton<String>(
                value: effort,
                items: const [
                  DropdownMenuItem(value: 'OFF', child: Text('OFF')),
                  DropdownMenuItem(value: 'AUTO', child: Text('AUTO')),
                  DropdownMenuItem(value: 'LOW', child: Text('LOW')),
                  DropdownMenuItem(value: 'MEDIUM', child: Text('MEDIUM')),
                  DropdownMenuItem(value: 'HIGH', child: Text('HIGH')),
                ],
                onChanged: (v) => set(() => effort = v ?? effort),
              ),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('最大思考Tokens'), Text('$maxReasoning'),
              ]),
              Slider(value: maxReasoning.toDouble(), min: 0, max: 8000, divisions: 80, onChanged: (v) => set(() => maxReasoning = v.round())),
              const SizedBox(height: 8),
              slider('温度 (Temperature)', temp, 0, 2, 20, (v) => set(() => temp = v)),
              const SizedBox(height: 8),
              slider('上下文窗口（消息数）', ctx, 0, 20, 20, (v) => set(() => ctx = v)),
              const SizedBox(height: 8),
              slider('最大Token数', maxTokens, 100, 4000, 39, (v) => set(() => maxTokens = v)),
            ]),
          ),
        ],
      );
    });
  }

  Widget _collapseCard(BuildContext context, {required Widget header, required Widget child}) {
    bool expanded = true;
    return StatefulBuilder(builder: (context, set) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => set(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Expanded(child: header),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ]),
            ),
          ),
          if (expanded) const Divider(height: 1),
          if (expanded) Padding(padding: const EdgeInsets.all(12), child: child),
        ]),
      );
    });
  }

  Widget _navTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
    );
  }
}
