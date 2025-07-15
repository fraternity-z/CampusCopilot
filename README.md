# AnywhereChat - 智能AI助手

一个功能强大的跨平台AI助手应用，支持多模型对话、智能体管理、知识库检索和RAG增强等功能。

## ✨ 主要特性

### 🤖 多模态AI对话
- **多供应商支持**: OpenAI、Google Gemini等主流AI服务
- **流式对话**: 实时响应，支持思考链显示（o1、Gemini Thinking等）
- **多模态支持**: 文本、图片、文档输入
- **上下文管理**: 可配置的上下文窗口管理（0-20条消息）

### 👥 智能体管理
- **个性化智能体**: 创建和管理不同角色的AI助手
- **智能体分组**: 按类别组织智能体，支持拖拽排序
- **系统提示词**: 自定义智能体行为和专业领域
- **API配置绑定**: 每个智能体可绑定不同的API配置

### 📚 知识库与RAG
- **多知识库支持**: 创建和管理多个独立知识库
- **文档管理**: 支持PDF、DOCX、TXT等多种格式
- **智能分块**: 自动文档分块和向量化处理
- **向量搜索**: 基于语义相似度的智能检索
- **RAG增强**: 可选的检索增强生成功能

### 🎨 界面特性
- **卡片式图片显示**: 150x150px美观图片卡片
- **全屏图片查看**: 支持缩放、平移的沉浸式查看
- **代码高亮**: 多语言代码语法高亮显示
- **数学公式**: LaTeX数学公式渲染支持
- **Mermaid图表**: 流程图、时序图等图表渲染

### ⚙️ 高级设置
- **模型参数**: 温度、最大Token、TopP等参数精确调节
- **主题切换**: Material Design 3深色/浅色主题
- **侧边栏管理**: 可折叠的侧边栏，智能按钮隐藏
- **数据管理**: 完整的本地数据存储和管理

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
│   └── settings/         # 设置功能
└── shared/               # 共享组件和工具
```

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.32.5
- Dart SDK >= 3.8.1
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
   - **Google**: 在 [Google AI Studio](https://aistudio.google.com/) 获取

## 📖 功能详解

### AI对话功能
- 创建新的聊天会话，支持多会话管理
- 选择不同的智能体进行专业对话
- 支持文本、图片、文档多模态输入
- 实时流式响应，提升交互体验
- 思考链过程展示（支持o1、Gemini Thinking等模型）
- 卡片式图片显示，支持全屏查看

### 智能体管理
- 创建自定义智能体，定制AI角色
- 设置系统提示词和专业领域
- 智能体分组管理，支持拖拽排序
- 绑定不同API配置，灵活切换模型
- 智能体使用统计和管理

### 知识库功能
- 多知识库支持，独立管理不同领域文档
- 上传文档（PDF、DOCX、TXT等多种格式）
- 自动文档分块和向量化处理
- 基于语义相似度的智能检索
- 可选的RAG增强对话功能
- 文档处理状态实时跟踪

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

- ✅ **Windows**: 完整功能支持，主要开发平台
- ✅ **Android**: 完整功能支持，移动端体验优化
- ✅ **iOS**: 完整功能支持
- 🔄 **macOS**: 理论支持，未充分测试
- 🔄 **Linux**: 理论支持，未充分测试
- ❌ **Web**: 暂不支持（数据库限制）

## 🎯 核心功能演示

### 知识库RAG功能
1. **上传文档**: 支持拖拽上传多种格式文档
2. **自动处理**: 智能分块、向量化、状态跟踪
3. **语义搜索**: 基于向量相似度的智能搜索
4. **RAG增强**: 对话中自动检索相关知识

### 智能体对话
1. **选择智能体**: 从预设或自定义智能体中选择
2. **多模态输入**: 文本、图片、文档输入
3. **实时响应**: 流式输出，思考过程可视化
4. **上下文管理**: 可配置的对话历史管理（0-20条）
5. **参数调节**: 温度、Token限制、TopP等参数实时调节

## 🔧 配置说明

### API配置
在设置页面配置各AI供应商的API密钥：

**OpenAI配置**
- API Key: 从OpenAI Platform获取
- Base URL: 可自定义API端点
- 支持模型: GPT-4, GPT-3.5, DALL-E, Whisper等

**Google配置**
- API Key: 从Google AI Studio获取
- 支持模型: Gemini Pro, Gemini Vision, Gemini Thinking等

### 知识库配置
- **多知识库**: 创建和管理多个独立知识库
- **嵌入模型**: 选择用于向量化的嵌入模型
- **分块参数**: 调整文档分块大小和重叠
- **搜索参数**: 设置相似度阈值和返回结果数
- **RAG开关**: 可选择是否启用检索增强功能

### 界面配置
- **主题设置**: 深色/浅色主题自动适配
- **侧边栏**: 可折叠侧边栏，智能按钮管理
- **图片显示**: 卡片式图片展示，全屏查看支持
- **代码高亮**: 多语言代码语法高亮

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

- [功能说明](docs/FEATURES.md) - 详细功能介绍和使用指南
- [架构文档](docs/ARCHITECTURE.md) - 项目架构和技术栈说明
- [开发指南](docs/DEVELOPMENT.md) - 开发环境配置和编码规范
- [许可证指南](docs/LICENSE_GUIDE.md) - 许可证详细说明和FAQ
- [Android Studio设置](docs/Android-Studio-Setup.md) - Android开发环境配置
- [CI/CD指南](docs/CI-CD-Guide.md) - 持续集成和部署指南

## 📄 许可证

本项目采用双重许可证模式：

### 🆓 Apache License 2.0（个人和小团队）
- **适用对象**: 个人用户和5人以下团队
- **使用范围**: 个人项目、教育用途、非商业用途
- **许可条款**: 遵循Apache License 2.0标准条款

### 💼 商业许可证（企业和大团队）
- **适用对象**: 5人以上组织或商业用途
- **包含服务**: 优先技术支持、定制开发、企业部署
- **联系方式**: 927751260@qq.com

详细许可条款请查看 [LICENSE](LICENSE) 文件

## 🙏 致谢

感谢以下开源项目和服务：

- [Flutter](https://flutter.dev/) - 跨平台UI框架
- [Riverpod](https://riverpod.dev/) - 状态管理解决方案
- [Drift](https://drift.simonbinder.eu/) - 类型安全的数据库ORM
- [OpenAI](https://openai.com/) - AI模型和API服务
- [Google AI](https://ai.google/) - Gemini模型服务

---

<div align="center">

**AnywhereChat** - 让AI助手无处不在 🚀

</div>