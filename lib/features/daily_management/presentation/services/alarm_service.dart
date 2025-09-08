import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../domain/entities/plan_entity.dart';

/// 闹钟服务类
/// 
/// 提供计划提醒的闹钟管理功能，支持创建、更新、取消闹钟
/// 保持与现有代码的低耦合性，作为独立模块提供服务
class AlarmService {
  static const String _defaultAlarmAudio = 'assets/audio/alarm.mp3';
  static const String _alarmVolumeKey = 'alarm_volume';
  static const String _alarmVibrateKey = 'alarm_vibrate';
  static const String _alarmAudioKey = 'alarm_audio_path';
  
  /// 为计划创建闹钟提醒
  /// 
  /// [plan] 计划实体，必须包含有效的 reminderTime
  /// [customTitle] 自定义闹钟标题，如果为空则使用计划标题
  /// [customBody] 自定义闹钟内容，如果为空则使用计划描述
  static Future<bool> createPlanAlarm({
    required PlanEntity plan,
    String? customTitle,
    String? customBody,
  }) async {
    if (plan.reminderTime == null) {
      return false;
    }

    try {
      final alarmSettings = await _buildAlarmSettings(
        id: plan.id.hashCode, // 使用计划ID的哈希值作为闹钟ID
        dateTime: plan.reminderTime!,
        title: customTitle ?? '计划提醒：${plan.title}',
        body: customBody ?? _generateAlarmBody(plan),
      );

      final success = await Alarm.set(alarmSettings: alarmSettings);
      
      if (success) {
        debugPrint('🔔 为计划 "${plan.title}" 创建闹钟提醒成功，时间：${plan.reminderTime}');
      } else {
        debugPrint('❌ 为计划 "${plan.title}" 创建闹钟提醒失败');
      }
      
      return success;
    } catch (e) {
      debugPrint('❌ 创建计划闹钟时发生错误: $e');
      return false;
    }
  }

  /// 更新计划闹钟
  /// 
  /// [plan] 更新后的计划实体
  /// [oldAlarmId] 旧闹钟的ID（如果计划ID变化了）
  static Future<bool> updatePlanAlarm({
    required PlanEntity plan,
    int? oldAlarmId,
  }) async {
    try {
      // 先取消旧的闹钟
      final alarmIdToCancel = oldAlarmId ?? plan.id.hashCode;
      await cancelPlanAlarm(alarmIdToCancel);
      
      // 如果新的计划有提醒时间，创建新闹钟
      if (plan.reminderTime != null) {
        return await createPlanAlarm(plan: plan);
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ 更新计划闹钟时发生错误: $e');
      return false;
    }
  }

  /// 取消计划闹钟
  /// 
  /// [alarmId] 闹钟ID，可以是计划ID的哈希值
  static Future<bool> cancelPlanAlarm(int alarmId) async {
    try {
      final success = await Alarm.stop(alarmId);
      
      if (success) {
        debugPrint('🔕 闹钟 $alarmId 已取消');
      } else {
        debugPrint('⚠️ 闹钟 $alarmId 取消失败或不存在');
      }
      
      return success;
    } catch (e) {
      debugPrint('❌ 取消闹钟时发生错误: $e');
      return false;
    }
  }

  /// 取消计划的闹钟（使用计划实体）
  static Future<bool> cancelPlanAlarmByPlan(PlanEntity plan) async {
    return await cancelPlanAlarm(plan.id.hashCode);
  }

  /// 获取所有活跃的闹钟
  static Future<List<AlarmSettings>> getActiveAlarms() async {
    return await Alarm.getAlarms();
  }

  /// 检查计划是否已设置闹钟
  static Future<bool> isPlanAlarmSet(PlanEntity plan) async {
    final activeAlarms = await getActiveAlarms();
    return activeAlarms.any((alarm) => alarm.id == plan.id.hashCode);
  }

  /// 批量为计划列表创建闹钟
  static Future<List<bool>> createAlarmsForPlans(List<PlanEntity> plans) async {
    final results = <bool>[];
    
    for (final plan in plans) {
      if (plan.reminderTime != null) {
        final success = await createPlanAlarm(plan: plan);
        results.add(success);
      } else {
        results.add(false);
      }
    }
    
    return results;
  }

  /// 批量取消计划闹钟
  static Future<List<bool>> cancelAlarmsForPlans(List<PlanEntity> plans) async {
    final results = <bool>[];
    
    for (final plan in plans) {
      final success = await cancelPlanAlarmByPlan(plan);
      results.add(success);
    }
    
    return results;
  }

  /// 构建闹钟设置
  static Future<AlarmSettings> _buildAlarmSettings({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    final volume = await _getAlarmVolume();
    final vibrate = await _getAlarmVibrate();
    final audioPath = await _getAlarmAudioPath();
    
    return AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: audioPath,
      loopAudio: true,
      vibrate: vibrate,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: volume,
        fadeDuration: const Duration(seconds: 3),
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: '停止提醒',
        icon: 'notification_icon',
        iconColor: const Color(0xFF2196F3),
      ),
    );
  }

  /// 生成闹钟提醒内容
  static String _generateAlarmBody(PlanEntity plan) {
    final buffer = StringBuffer();
    
    // 添加计划类型
    buffer.write('${plan.type.displayName}计划');
    
    // 添加优先级信息
    if (plan.priority != PlanPriority.medium) {
      buffer.write(' | ${plan.priority.displayName}优先级');
    }
    
    // 添加时间信息
    if (plan.startTime != null) {
      final timeFormat = '${plan.startTime!.hour.toString().padLeft(2, '0')}:${plan.startTime!.minute.toString().padLeft(2, '0')}';
      buffer.write(' | $timeFormat开始');
    }
    
    // 添加描述信息
    if (plan.description != null && plan.description!.isNotEmpty) {
      buffer.write('\n${plan.description}');
    }
    
    return buffer.toString();
  }

  // === 闹钟设置管理 ===

  /// 获取闹钟音量设置
  static Future<double> _getAlarmVolume() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_alarmVolumeKey) ?? 0.8;
    } catch (e) {
      return 0.8; // 默认音量
    }
  }

  /// 设置闹钟音量
  static Future<bool> setAlarmVolume(double volume) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setDouble(_alarmVolumeKey, volume.clamp(0.0, 1.0));
    } catch (e) {
      return false;
    }
  }

  /// 获取振动设置
  static Future<bool> _getAlarmVibrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_alarmVibrateKey) ?? true;
    } catch (e) {
      return true; // 默认开启振动
    }
  }

  /// 设置振动
  static Future<bool> setAlarmVibrate(bool vibrate) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_alarmVibrateKey, vibrate);
    } catch (e) {
      return false;
    }
  }

  /// 获取闹钟音频路径
  static Future<String> _getAlarmAudioPath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customPath = prefs.getString(_alarmAudioKey);
      
      // 如果用户设置了自定义音频路径，检查是否存在
      if (customPath != null && customPath.isNotEmpty) {
        if (await _isAudioFileExists(customPath)) {
          return customPath;
        }
      }
      
      // 检查默认音频是否存在，不存在则使用备用方案
      if (await _isAudioFileExists(_defaultAlarmAudio)) {
        return _defaultAlarmAudio;
      }
      
      // 使用系统默认提示音作为备用方案
      return 'assets/audio/notification.mp3';
    } catch (e) {
      return 'assets/audio/notification.mp3';
    }
  }
  
  /// 检查音频文件是否存在
  static Future<bool> _isAudioFileExists(String assetPath) async {
    try {
      // 对于 assets 文件，我们假设它们存在，除非明确知道不存在
      // 在实际使用中，如果音频文件不存在，alarm 插件会使用系统默认音频
      return assetPath.startsWith('assets/');
    } catch (e) {
      return false;
    }
  }

  /// 设置闹钟音频路径
  static Future<bool> setAlarmAudioPath(String audioPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_alarmAudioKey, audioPath);
    } catch (e) {
      return false;
    }
  }

  /// 测试播放闹钟音频
  static Future<void> testAlarmSound() async {
    try {
      // 创建一个测试闹钟，1秒后响起
      final testDateTime = DateTime.now().add(const Duration(seconds: 2));
      final testAlarmSettings = await _buildAlarmSettings(
        id: 999999, // 使用特殊ID用于测试
        dateTime: testDateTime,
        title: '测试闹钟',
        body: '这是一个测试闹钟，用于预览设置效果',
      );

      await Alarm.set(alarmSettings: testAlarmSettings);
      
      // 5秒后自动取消测试闹钟
      Future.delayed(const Duration(seconds: 5), () {
        Alarm.stop(999999);
      });
      
    } catch (e) {
      debugPrint('❌ 测试闹钟播放失败: $e');
    }
  }

  /// 重置所有闹钟设置为默认值
  static Future<void> resetAlarmSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_alarmVolumeKey);
      await prefs.remove(_alarmVibrateKey);
      await prefs.remove(_alarmAudioKey);
      debugPrint('🔄 闹钟设置已重置为默认值');
    } catch (e) {
      debugPrint('❌ 重置闹钟设置失败: $e');
    }
  }

  /// 获取闹钟设置摘要
  static Future<Map<String, dynamic>> getAlarmSettingsSummary() async {
    final activeAlarms = await getActiveAlarms();
    return {
      'volume': await _getAlarmVolume(),
      'vibrate': await _getAlarmVibrate(),
      'audioPath': await _getAlarmAudioPath(),
      'activeAlarms': activeAlarms.length,
    };
  }
}

/// 闹钟配置模型
class AlarmConfiguration {
  final double volume;
  final bool vibrate;
  final String audioPath;
  final Duration fadeDuration;
  final bool volumeEnforced;

  const AlarmConfiguration({
    this.volume = 0.8,
    this.vibrate = true,
    this.audioPath = 'assets/alarm.mp3',
    this.fadeDuration = const Duration(seconds: 3),
    this.volumeEnforced = true,
  });

  AlarmConfiguration copyWith({
    double? volume,
    bool? vibrate,
    String? audioPath,
    Duration? fadeDuration,
    bool? volumeEnforced,
  }) {
    return AlarmConfiguration(
      volume: volume ?? this.volume,
      vibrate: vibrate ?? this.vibrate,
      audioPath: audioPath ?? this.audioPath,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      volumeEnforced: volumeEnforced ?? this.volumeEnforced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'volume': volume,
      'vibrate': vibrate,
      'audioPath': audioPath,
      'fadeDurationMs': fadeDuration.inMilliseconds,
      'volumeEnforced': volumeEnforced,
    };
  }

  factory AlarmConfiguration.fromJson(Map<String, dynamic> json) {
    return AlarmConfiguration(
      volume: (json['volume'] as num?)?.toDouble() ?? 0.8,
      vibrate: json['vibrate'] as bool? ?? true,
      audioPath: json['audioPath'] as String? ?? 'assets/alarm.mp3',
      fadeDuration: Duration(milliseconds: json['fadeDurationMs'] as int? ?? 3000),
      volumeEnforced: json['volumeEnforced'] as bool? ?? true,
    );
  }
}
