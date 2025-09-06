import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';

import '../../domain/entities/plan_entity.dart';
import '../providers/plan_notifier.dart';
import '../services/alarm_service.dart';

/// 闹钟管理页面
/// 
/// 提供所有闹钟提醒的管理界面，包括查看、测试、取消等功能
class AlarmManagementPage extends ConsumerStatefulWidget {
  const AlarmManagementPage({super.key});

  @override
  ConsumerState<AlarmManagementPage> createState() => _AlarmManagementPageState();
}

class _AlarmManagementPageState extends ConsumerState<AlarmManagementPage> {
  List<AlarmSettings> _activeAlarms = [];
  final Map<int, PlanEntity?> _alarmPlanMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  /// 加载活跃的闹钟
  Future<void> _loadAlarms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _activeAlarms = await AlarmService.getActiveAlarms();
      await _mapAlarmsToPlans();
    } catch (e) {
      debugPrint('❌ 加载闹钟失败: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 将闹钟映射到对应的计划
  Future<void> _mapAlarmsToPlans() async {
    final planState = ref.read(planNotifierProvider);
    if (planState is Loaded) {
      final plans = planState.plans;
      
      for (final alarm in _activeAlarms) {
        // 通过闹钟ID找到对应的计划
        PlanEntity? matchedPlan;
        for (final plan in plans) {
          if (plan.id.hashCode == alarm.id) {
            matchedPlan = plan;
            break;
          }
        }
        _alarmPlanMap[alarm.id] = matchedPlan;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('闹钟管理'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAlarms,
            tooltip: '刷新',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 导航到闹钟设置页面
              _showAlarmSettings();
            },
            tooltip: '闹钟设置',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_activeAlarms.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadAlarms,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activeAlarms.length,
        itemBuilder: (context, index) {
          final alarm = _activeAlarms[index];
          final plan = _alarmPlanMap[alarm.id];
          return _buildAlarmCard(alarm, plan);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无活跃的闹钟',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '在创建计划时设置提醒时间即可自动创建闹钟',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.add),
            label: const Text('创建计划'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmCard(AlarmSettings alarm, PlanEntity? plan) {
    final isTimeExpired = alarm.dateTime.isBefore(DateTime.now());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Row(
              children: [
                Icon(
                  isTimeExpired ? Icons.alarm_off : Icons.alarm,
                  color: isTimeExpired 
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alarm.notificationSettings.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isTimeExpired 
                          ? Theme.of(context).colorScheme.outline
                          : null,
                    ),
                  ),
                ),
                if (isTimeExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '已过期',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 时间信息
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(alarm.dateTime),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                if (!isTimeExpired)
                  Text(
                    _getTimeUntilAlarm(alarm.dateTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // 计划信息
            if (plan != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.event_note,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '关联计划: ${plan.title}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  _buildPriorityChip(plan.priority),
                ],
              ),
              const SizedBox(height: 8),
            ],
            
            // 闹钟设置信息
            Row(
              children: [
                if (alarm.vibrate) ...[
                  Icon(
                    Icons.vibration,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '振动',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                ],
                Icon(
                  Icons.volume_up,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  '音量 ${((alarm.volumeSettings.volume ?? 0.8) * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _testAlarm(alarm),
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('测试'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _cancelAlarm(alarm),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('取消'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(PlanPriority priority) {
    Color color;
    switch (priority) {
      case PlanPriority.high:
        color = Colors.red;
        break;
      case PlanPriority.medium:
        color = Colors.orange;
        break;
      case PlanPriority.low:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 测试闹钟
  Future<void> _testAlarm(AlarmSettings alarm) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    await AlarmService.testAlarmSound();
    
    if (mounted) {
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('🔔 测试闹钟已播放，将在5秒后自动停止'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// 取消闹钟
  Future<void> _cancelAlarm(AlarmSettings alarm) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final confirmed = await _showCancelConfirmDialog(alarm);
    if (confirmed == true) {
      final success = await AlarmService.cancelPlanAlarm(alarm.id);
      
      if (mounted) {
        if (success) {
          messenger?.showSnackBar(
            const SnackBar(content: Text('🔕 闹钟已取消')),
          );
          await _loadAlarms(); // 刷新列表
        } else {
          messenger?.showSnackBar(
            const SnackBar(
              content: Text('❌ 取消闹钟失败'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// 显示取消确认对话框
  Future<bool?> _showCancelConfirmDialog(AlarmSettings alarm) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认取消'),
        content: Text('确定要取消闹钟"${alarm.notificationSettings.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  /// 显示闹钟设置
  void _showAlarmSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AlarmSettingsSheet(),
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final alarmDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (alarmDate == today) {
      dateStr = '今天';
    } else if (alarmDate == tomorrow) {
      dateStr = '明天';
    } else {
      dateStr = '${dateTime.month}/${dateTime.day}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  /// 获取距离闹钟响起的时间
  String _getTimeUntilAlarm(DateTime alarmTime) {
    final now = DateTime.now();
    final difference = alarmTime.difference(now);
    
    if (difference.isNegative) {
      return '已过期';
    }
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天后';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时后';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟后';
    } else {
      return '即将响起';
    }
  }
}

/// 闹钟设置面板
class AlarmSettingsSheet extends StatefulWidget {
  const AlarmSettingsSheet({super.key});

  @override
  State<AlarmSettingsSheet> createState() => _AlarmSettingsSheetState();
}

class _AlarmSettingsSheetState extends State<AlarmSettingsSheet> {
  double _volume = 0.8;
  bool _vibrate = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await AlarmService.getAlarmSettingsSummary();
    setState(() {
      _volume = settings['volume'] ?? 0.8;
      _vibrate = settings['vibrate'] ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '闹钟设置',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 音量设置
          Text(
            '音量',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.volume_down),
              Expanded(
                child: Slider(
                  value: _volume,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                  onChangeEnd: (value) async {
                    await AlarmService.setAlarmVolume(value);
                  },
                ),
              ),
              const Icon(Icons.volume_up),
              const SizedBox(width: 8),
              Text('${(_volume * 100).toInt()}%'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 振动设置
          Row(
            children: [
              Text(
                '振动',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Switch(
                value: _vibrate,
                onChanged: (value) async {
                  setState(() {
                    _vibrate = value;
                  });
                  await AlarmService.setAlarmVibrate(value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.maybeOf(context);
                    await AlarmService.testAlarmSound();
                    if (mounted) {
                      messenger?.showSnackBar(
                        const SnackBar(content: Text('🔔 测试闹钟已播放')),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('测试闹钟'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.maybeOf(context);
                    await AlarmService.resetAlarmSettings();
                    await _loadSettings();
                    if (mounted) {
                      messenger?.showSnackBar(
                        const SnackBar(content: Text('🔄 设置已重置')),
                      );
                    }
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('重置设置'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
