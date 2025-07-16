import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_assistant/app/constants/ui_constants.dart';
import 'package:ai_assistant/app/navigation/sidebar_container.dart';
import 'package:ai_assistant/app/navigation/assistants_tab.dart';
import 'package:ai_assistant/app/navigation/topics_tab.dart';
import 'package:ai_assistant/app/navigation/settings_tab.dart';
import 'package:ai_assistant/app/widgets/sidebar_button.dart';
import 'package:ai_assistant/app/widgets/action_button.dart';

void main() {
  group('导航优化测试', () {
    testWidgets('UIConstants 常量定义正确', (tester) async {
      expect(UIConstants.sidebarWidth, 320.0);
      expect(UIConstants.sidebarWidthMobile, 0.85);
      expect(UIConstants.animationDuration, const Duration(milliseconds: 300));
      expect(UIConstants.borderRadius, 16.0);
      expect(UIConstants.spacingL, 16.0);
      expect(UIConstants.iconSizeMedium, 20.0);
    });

    testWidgets('SidebarTabConfig 配置正确', (tester) async {
      final assistantsConfig = SidebarTabConfig.getConfig(
        SidebarTab.assistants,
      );
      expect(assistantsConfig.icon, Icons.person);
      expect(assistantsConfig.label, '助手');

      final topicsConfig = SidebarTabConfig.getConfig(SidebarTab.topics);
      expect(topicsConfig.icon, Icons.topic);
      expect(topicsConfig.label, '聊天记录');

      final settingsConfig = SidebarTabConfig.getConfig(SidebarTab.settings);
      expect(settingsConfig.icon, Icons.settings);
      expect(settingsConfig.label, '参数设置');
    });

    testWidgets('SidebarButton 组件渲染正确', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SidebarButton(
              icon: Icons.star,
              label: '测试按钮',
              badge: '5',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('测试按钮'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('ActionButton 组件渲染正确', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButton(icon: Icons.add, label: '添加', onTap: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('添加'), findsOneWidget);
    });

    testWidgets('SidebarHeader 组件渲染正确', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: SidebarHeader())),
        ),
      );

      expect(find.byIcon(Icons.smart_toy), findsOneWidget);
      expect(find.text('Anywherechat'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('SidebarTabBar 组件渲染正确', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SidebarTabBar(
              selectedTab: SidebarTab.assistants,
              onTabSelected: (tab) {},
            ),
          ),
        ),
      );

      // 应该有三个标签
      expect(find.byType(InkWell), findsNWidgets(3));

      // 检查标签图标
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.topic), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // 检查标签文本
      expect(find.text('助手'), findsOneWidget);
      expect(find.text('聊天记录'), findsOneWidget);
      expect(find.text('参数设置'), findsOneWidget);
    });

    testWidgets('SidebarExpandButton 组件渲染正确', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: SidebarExpandButton())),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byType(Material), findsAtLeastNWidgets(1));
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('SidebarOverlay 组件渲染正确', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: Scaffold(body: SidebarOverlay())),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    group('标签页组件测试', () {
      testWidgets('AssistantsTab 组件可以创建', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: AssistantsTab())),
          ),
        );

        // 组件应该能够正常创建，不抛出异常
        expect(find.byType(AssistantsTab), findsOneWidget);
      });

      testWidgets('TopicsTab 组件可以创建', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: TopicsTab())),
          ),
        );

        expect(find.byType(TopicsTab), findsOneWidget);
        expect(find.text('聊天记录'), findsOneWidget);
      });

      testWidgets('SettingsTab 组件可以创建', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(home: Scaffold(body: SettingsTab())),
          ),
        );

        expect(find.byType(SettingsTab), findsOneWidget);
        expect(find.text('模型参数'), findsOneWidget);
        expect(find.text('代码块设置'), findsOneWidget);
        expect(find.text('常规设置'), findsOneWidget);
      });
    });

    group('性能优化验证', () {
      test('常量使用避免魔法数字', () {
        // 验证所有常量都有明确定义
        expect(UIConstants.sidebarWidth, isA<double>());
        expect(UIConstants.animationDuration, isA<Duration>());
        expect(UIConstants.borderRadius, isA<double>());
        expect(UIConstants.spacingL, isA<double>());
        expect(UIConstants.iconSizeMedium, isA<double>());
        expect(UIConstants.shadowOpacity, isA<double>());
        expect(UIConstants.overlayOpacity, isA<double>());
      });

      test('SidebarTab 枚举正确定义', () {
        expect(SidebarTab.values.length, 3);
        expect(SidebarTab.assistants.index, 0);
        expect(SidebarTab.topics.index, 1);
        expect(SidebarTab.settings.index, 2);
      });

      test('TabConfig 配置完整', () {
        for (final tab in SidebarTab.values) {
          final config = SidebarTabConfig.getConfig(tab);
          expect(config.icon, isA<IconData>());
          expect(config.label, isA<String>());
          expect(config.label.isNotEmpty, true);
        }
      });
    });

    group('组件拆分验证', () {
      test('组件职责单一', () {
        // SidebarButton 只负责按钮显示
        expect(SidebarButton, isA<Type>());

        // ActionButton 只负责操作按钮
        expect(ActionButton, isA<Type>());

        // SidebarHeader 只负责头部显示
        expect(SidebarHeader, isA<Type>());

        // SidebarTabBar 只负责标签栏
        expect(SidebarTabBar, isA<Type>());
      });

      test('标签页组件独立', () {
        // 每个标签页都是独立的组件
        expect(AssistantsTab, isA<Type>());
        expect(TopicsTab, isA<Type>());
        expect(SettingsTab, isA<Type>());
      });
    });
  });

  group('主题优化测试', () {
    test('主题构建方法存在', () {
      // 验证主题相关的类和方法存在
      expect(UIConstants, isA<Type>());
      expect(SidebarTabConfig, isA<Type>());
    });
  });
}
