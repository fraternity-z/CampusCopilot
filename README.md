# AnywhereChat - 智能AI助手

一个功能强大的跨平台AI助手应用，支持多模型对话、智能体管理、知识库检索和RAG增强等功能。

## ✨ 主要特性

### 🤖 多模型AI对话
- **多供应商支持**: OpenAI、Google Gemini、Anthropic Claude
- **流式对话**: 实时响应，支持思考链显示
- **多模态支持**: 文本、图片、语音交互
- **上下文管理**: 智能上下文窗口管理

### 👥 智能体管理
- **个性化智能体**: 创建和管理不同角色的AI助手
- **智能体分组**: 按类别组织智能体
- **系统提示词**: 自定义智能体行为和专业领域
- **使用统计**: 跟踪智能体使用情况

### 📚 知识库与RAG
- **文档管理**: 支持多种格式文档上传和管理
- **智能分块**: 自动文档分块和向量化
- **向量搜索**: 基于语义相似度的智能搜索
- **RAG增强**: 自动检索相关知识增强AI回答
- **嵌入模型**: 支持多种嵌入模型配置

### 🎙️ 语音交互
- **语音识别**: 实时语音转文字
- **语音合成**: 文字转语音播放
- **多语言支持**: 支持多种语言的语音交互

### ⚙️ 高级设置
- **模型参数**: 温度、最大Token等参数调节
- **数据管理**: 导入导出、备份恢复
- **主题切换**: 明暗主题支持
- **多语言**: 国际化支持

## 🏗️ 技术架构

### 架构模式
- **Clean Architecture**: 清晰的分层架构
- **Domain-Driven Design**: 领域驱动设计
- **MVVM Pattern**: 使用Riverpod状态管理

### 技术栈
- **Flutter**: 跨平台UI框架
- **Riverpod**: 状态管理和依赖注入
- **Drift**: 本地数据库ORM
- **Freezed**: 不可变数据类
- **Go Router**: 路由管理
- **HTTP**: 网络请求

### 项目结构
```
lib/
├── app/                    # 应用入口和路由
├── core/                   # 核心功能和工具
├── data/                   # 数据层
│   └── local/             # 本地数据库
├── features/              # 功能模块
│   ├── llm_chat/         # AI对话功能
│   ├── persona_management/ # 智能体管理
│   ├── knowledge_base/    # 知识库功能
│   ├── speech/           # 语音功能
│   └── settings/         # 设置功能
└── shared/               # 共享组件和工具
```

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- Git

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/your-repo/anywherechat.git
cd anywherechat
```

2. **安装依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **运行应用**
```bash
flutter run
```

### 配置API密钥

1. 进入应用设置页面
2. 选择要使用的AI供应商
3. 输入相应的API密钥：
   - **OpenAI**: 在 [OpenAI Platform](https://platform.openai.com/) 获取
   - **Google**: 在 [Google AI Studio](https://makersuite.google.com/) 获取
   - **Anthropic**: 在 [Anthropic Console](https://console.anthropic.com/) 获取

## 📖 功能详解

### AI对话功能
- 创建新的聊天会话
- 选择不同的智能体进行对话
- 支持文本、图片输入
- 实时流式响应
- 思考链过程展示

### 智能体管理
- 创建自定义智能体
- 设置系统提示词和参数
- 智能体分组管理
- 导入导出智能体配置

### 知识库功能
- 上传文档（TXT、MD、PDF、DOCX等）
- 自动文档处理和向量化
- 语义搜索和关键词搜索
- RAG增强对话
- 配置嵌入模型和参数

### 语音交互
- 点击录音按钮开始语音输入
- 实时语音识别转文字
- AI回答自动语音播放
- 支持多种语言和声音

## 🔧 开发指南

### 添加新功能模块

1. **创建功能目录**
```
lib/features/your_feature/
├── data/              # 数据层
├── domain/            # 领域层
└── presentation/      # 表现层
```

2. **实现分层架构**
- **Data Layer**: 数据源、仓库实现
- **Domain Layer**: 实体、用例、仓库接口
- **Presentation Layer**: UI、状态管理、Provider

3. **添加路由**
在 `app/app_router.dart` 中添加新路由

4. **注册依赖**
在相应的Provider文件中注册依赖注入

### 数据库迁移

1. 修改表结构文件
2. 更新数据库版本号
3. 添加迁移逻辑
4. 运行代码生成

### 测试

```bash
# 运行单元测试
flutter test

# 运行集成测试
flutter test integration_test/

# 生成测试覆盖率报告
flutter test --coverage
```

## 📱 支持平台

- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## 🎯 核心功能演示

### 知识库RAG功能
1. **上传文档**: 支持拖拽上传多种格式文档
2. **自动处理**: 智能分块、向量化、状态跟踪
3. **语义搜索**: 基于向量相似度的智能搜索
4. **RAG增强**: 对话中自动检索相关知识

### 智能体对话
1. **选择智能体**: 从预设或自定义智能体中选择
2. **多模态输入**: 文本、图片、语音输入
3. **实时响应**: 流式输出，思考过程可视化
4. **上下文管理**: 智能管理对话历史

### 语音交互
1. **语音输入**: 实时语音识别转文字
2. **语音输出**: AI回答自动语音播放
3. **多语言**: 支持中英文等多种语言

## 🔧 配置说明

### API配置
在设置页面配置各AI供应商的API密钥：

**OpenAI配置**
- API Key: 从OpenAI Platform获取
- Base URL: 可自定义API端点
- 支持模型: GPT-4, GPT-3.5, DALL-E, Whisper等

**Google配置**
- API Key: 从Google AI Studio获取
- 支持模型: Gemini Pro, Gemini Vision等

**Anthropic配置**
- API Key: 从Anthropic Console获取
- 支持模型: Claude-3, Claude-2等

### 知识库配置
- **嵌入模型**: 选择用于向量化的嵌入模型
- **分块参数**: 调整文档分块大小和重叠
- **搜索参数**: 设置相似度阈值和返回结果数

### 语音配置
- **识别语言**: 选择语音识别的目标语言
- **合成声音**: 选择文字转语音的声音类型
- **音频质量**: 调整音频采样率和质量

## 🤝 贡献指南

我们欢迎所有形式的贡献！

### 如何贡献
1. Fork 项目到你的GitHub账户
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

### 代码规范
- 遵循 [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- 使用 `dart format` 格式化代码
- 使用 `dart analyze` 检查代码质量
- 为新功能编写单元测试
- 更新相关文档

### 提交规范
使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：
- `feat:` 新功能
- `fix:` 修复bug
- `docs:` 文档更新
- `style:` 代码格式调整
- `refactor:` 代码重构
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

## 🐛 问题反馈

遇到问题？我们来帮助你！

### 报告Bug
1. 在 [Issues](https://github.com/your-repo/anywherechat/issues) 页面创建新issue
2. 使用Bug报告模板
3. 提供详细的复现步骤
4. 包含错误日志和截图

### 功能建议
1. 在 [Discussions](https://github.com/your-repo/anywherechat/discussions) 页面发起讨论
2. 详细描述功能需求和使用场景
3. 说明功能的价值和优先级

## 📚 相关文档

- [知识库和RAG功能详解](docs/KNOWLEDGE_BASE_RAG.md)
- [API集成指南](docs/API_INTEGRATION.md)
- [部署指南](docs/DEPLOYMENT.md)
- [常见问题](docs/FAQ.md)

## 📄 许可证

本项目采用Apache License 2.0 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

感谢以下开源项目和服务：

- [Flutter](https://flutter.dev/) - 跨平台UI框架
- [Riverpod](https://riverpod.dev/) - 状态管理解决方案
- [Drift](https://drift.simonbinder.eu/) - 类型安全的数据库ORM
- [OpenAI](https://openai.com/) - AI模型和API服务
- [Google AI](https://ai.google/) - Gemini模型服务
- [Anthropic](https://anthropic.com/) - Claude模型服务

---

<div align="center">

**AnywhereChat** - 让AI助手无处不在 🚀

</div>