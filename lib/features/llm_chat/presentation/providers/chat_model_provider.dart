import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 当前聊天窗口选中的 LLM 模型 ID
final selectedChatModelProvider = StateProvider<String?>((ref) => null);
