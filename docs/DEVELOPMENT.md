# AnywhereChat 开发指南

## 开发环境设置

### 前置要求
- Flutter SDK 3.19.0 或更高版本
- Dart SDK 3.3.0 或更高版本
- Android Studio 或 VS Code
- Git

### 环境配置

1. **克隆项目**
```bash
git clone <repository-url>
cd AnywhereChat
```

2. **安装依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **运行项目**
```bash
flutter run
```

## 项目结构说明

### 核心目录
- `lib/app/`: 应用级配置和路由
- `lib/core/`: 核心服务和工具
- `lib/data/`: 数据层实现
- `lib/features/`: 功能模块
- `lib/shared/`: 共享组件

### 功能模块结构
每个功能模块遵循以下结构：
```
feature_name/
├── data/           # 数据层
│   ├── models/     # 数据模型
│   ├── providers/  # 数据提供者
│   └── repositories/ # 数据仓库
├── domain/         # 领域层
│   ├── entities/   # 实体
│   ├── providers/  # 领域提供者
│   └── usecases/   # 用例
└── presentation/   # 表现层
    ├── providers/  # 状态管理
    ├── views/      # 页面和组件
    └── widgets/    # UI组件
```

## 开发规范

### 代码风格
- 遵循 Dart 官方代码风格
- 使用 `analysis_options.yaml` 配置的规则
- 类名使用 PascalCase
- 变量和方法名使用 camelCase
- 常量使用 UPPER_SNAKE_CASE

### 命名规范
- **文件名**: 使用 snake_case
- **类名**: 使用 PascalCase
- **变量名**: 使用 camelCase
- **Provider**: 以 Provider 结尾
- **Notifier**: 以 Notifier 结尾
- **Widget**: 以 Widget 结尾

### 注释规范
```dart
/// 类或方法的简要描述
/// 
/// 详细说明（可选）
/// 
/// 参数说明：
/// - [param1]: 参数1的说明
/// - [param2]: 参数2的说明
/// 
/// 返回值说明
/// 
/// 示例：
/// ```dart
/// final result = methodName(param1, param2);
/// ```
class ExampleClass {
  // 实现
}
```

## 状态管理

### Riverpod 使用指南

1. **Provider 定义**
```dart
final exampleProvider = Provider<ExampleService>((ref) {
  return ExampleService();
});
```

2. **StateNotifier 使用**
```dart
class ExampleNotifier extends StateNotifier<ExampleState> {
  ExampleNotifier() : super(ExampleState.initial());
  
  void updateState() {
    state = state.copyWith(/* 更新字段 */);
  }
}

final exampleNotifierProvider = 
    StateNotifierProvider<ExampleNotifier, ExampleState>((ref) {
  return ExampleNotifier();
});
```

3. **在Widget中使用**
```dart
class ExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exampleNotifierProvider);
    
    return Widget(
      onPressed: () => ref.read(exampleNotifierProvider.notifier).updateState(),
    );
  }
}
```

## 数据库操作

### Drift 使用指南

1. **表定义**
```dart
class ExampleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
}
```

2. **DAO 实现**
```dart
@DriftAccessor(tables: [ExampleTable])
class ExampleDao extends DatabaseAccessor<AppDatabase> with _$ExampleDaoMixin {
  ExampleDao(AppDatabase db) : super(db);
  
  Future<List<ExampleTableData>> getAllExamples() => select(exampleTable).get();
  
  Future<int> insertExample(ExampleTableCompanion entry) => 
      into(exampleTable).insert(entry);
}
```

## API 集成

### LLM Provider 实现

1. **继承基类**
```dart
class CustomLlmProvider extends LlmProvider {
  @override
  Future<ChatResult> generateChat(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async {
    // 实现聊天生成逻辑
  }
  
  @override
  Stream<StreamedChatResult> generateChatStream(
    List<ChatMessage> messages, {
    ChatOptions? options,
  }) async* {
    // 实现流式聊天生成逻辑
  }
}
```

2. **注册Provider**
```dart
class LlmProviderFactory {
  static LlmProvider createProvider(LlmConfig config) {
    switch (config.provider) {
      case 'custom':
        return CustomLlmProvider(config);
      default:
        throw UnsupportedError('Unsupported provider: ${config.provider}');
    }
  }
}
```

## 测试指南

### 单元测试
```dart
void main() {
  group('ExampleService', () {
    late ExampleService service;
    
    setUp(() {
      service = ExampleService();
    });
    
    test('should return expected result', () {
      // Arrange
      final input = 'test input';
      
      // Act
      final result = service.processInput(input);
      
      // Assert
      expect(result, equals('expected output'));
    });
  });
}
```

### Widget 测试
```dart
void main() {
  testWidgets('ExampleWidget should display correctly', (tester) async {
    // Arrange
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ExampleWidget(),
        ),
      ),
    );
    
    // Act & Assert
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

## 构建和部署

### 开发构建
```bash
flutter run --debug
```

### 发布构建
```bash
flutter build apk --release
flutter build windows --release
```

### 代码生成
```bash
# 生成 Freezed 和 JSON 序列化代码
dart run build_runner build --delete-conflicting-outputs

# 监听文件变化自动生成
dart run build_runner watch --delete-conflicting-outputs
```

## 调试技巧

### 日志输出
```dart
import 'package:flutter/foundation.dart';

debugPrint('调试信息: $variable');
```

### 性能分析
```bash
flutter run --profile
```

### 内存分析
```bash
flutter run --debug --enable-software-rendering
```

## 常见问题

### 1. 构建失败
- 检查 Flutter 版本是否符合要求
- 运行 `flutter clean` 清理缓存
- 重新运行 `flutter pub get`

### 2. 代码生成失败
- 检查 `build_runner` 版本
- 删除 `.dart_tool` 文件夹
- 重新运行代码生成命令

### 3. 数据库迁移
- 更新数据库版本号
- 实现迁移逻辑
- 测试迁移过程
