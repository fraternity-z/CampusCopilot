import 'package:flutter/material.dart';

/// UI 相关常量定义
class UIConstants {
  UIConstants._();

  // 侧边栏相关
  static const double sidebarWidth = 320.0;
  static const double sidebarWidthMobile = 0.85;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;

  // 间距
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;

  // 图标大小
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXL = 28.0;

  // 头像大小
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 40.0;
  static const double avatarSizeLarge = 48.0;

  // 容器高度
  static const double headerHeight = 64.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;

  // 阴影
  static const double shadowBlurRadius = 10.0;
  static const Offset shadowOffset = Offset(2, 0);
  static const double shadowOpacity = 0.1;

  // 透明度
  static const double overlayOpacity = 0.3;
  static const double disabledOpacity = 0.7;
  static const double borderOpacity = 0.2;
  static const double outlineOpacity = 0.5;

  // 手势阈值
  static const double swipeVelocityThreshold = 500.0;

  // 动画曲线
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve fastCurve = Curves.easeOut;
}

/// 标签页信息配置
class TabConfig {
  final IconData icon;
  final String label;
  final String? asset;

  const TabConfig({required this.icon, required this.label, this.asset});
}

/// 侧边栏标签页配置
class SidebarTabConfig {
  static const Map<SidebarTab, TabConfig> configs = {
    SidebarTab.assistants: TabConfig(icon: Icons.person, label: '助手'),
    SidebarTab.topics: TabConfig(icon: Icons.topic, label: '聊天记录'),
    SidebarTab.settings: TabConfig(icon: Icons.settings, label: '参数设置'),
  };

  static TabConfig getConfig(SidebarTab tab) {
    return configs[tab] ?? const TabConfig(icon: Icons.help, label: '未知');
  }
}

/// 侧边栏标签页枚举
enum SidebarTab { assistants, topics, settings }
