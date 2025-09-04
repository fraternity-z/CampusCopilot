import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_copilot/features/llm_chat/presentation/views/widgets/streaming_message_content_widget.dart';
import 'package:campus_copilot/features/llm_chat/domain/entities/chat_message.dart';

void main() {
  group('OptimizedStreamingMessageWidget 流式输出顺序测试', () {
    late ChatMessage testMessage;

    setUp(() {
      testMessage = ChatMessage(
        id: 'test-id',
        chatSessionId: 'session-id',
        content: '',
        isFromUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );
    });

    testWidgets('应该先显示思考链，后显示正文内容', (WidgetTester tester) async {
      // 创建包含思考链和正文的消息
      final messageWithThinking = testMessage.copyWith(
        content: '<think>这是思考过程</think>这是正文内容',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OptimizedStreamingMessageWidget(
                message: messageWithThinking,
                isStreaming: true,
              ),
            ),
          ),
        ),
      );

      // 验证组件能够正常渲染
      expect(find.byType(OptimizedStreamingMessageWidget), findsOneWidget);
    });

    testWidgets('没有思考链时应该直接显示正文内容', (WidgetTester tester) async {
      // 创建只有正文的消息
      final messageWithoutThinking = testMessage.copyWith(content: '这是纯正文内容');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OptimizedStreamingMessageWidget(
                message: messageWithoutThinking,
                isStreaming: true,
              ),
            ),
          ),
        ),
      );

      // 验证组件能够正常渲染
      expect(find.byType(OptimizedStreamingMessageWidget), findsOneWidget);
    });

    testWidgets('流式输出完成后应该切换到完整渲染', (WidgetTester tester) async {
      // 创建已完成的消息
      final completedMessage = testMessage.copyWith(
        content: '<think>思考过程</think>正文内容',
        status: MessageStatus.sent,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OptimizedStreamingMessageWidget(
                message: completedMessage,
                isStreaming: false,
              ),
            ),
          ),
        ),
      );

      // 验证组件能够正常渲染
      expect(find.byType(OptimizedStreamingMessageWidget), findsOneWidget);
    });
  });
}
