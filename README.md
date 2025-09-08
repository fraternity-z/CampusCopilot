# Campus Copilot - 智能校园助手

一个专为西电校园生活设计的智能AI助手，集成多模态AI对话、课程管理、知识库检索、智能体管理等功能，让AI助手成为你的校园智能伙伴。

![启动](https://github.com/user-attachments/assets/5669290a-980c-4084-a951-53a76148e2da)

## ✨ 主要特性

### 🎓 智能校园管理
- **课程表管理**: 自动登录西电教务系统，获取个人课程安排
- **实时课程状态**: 显示当前课程和下节课信息，支持课程时间智能提醒
- **学期管理**: 自动识别学期时间，支持多学期课程数据缓存
- **个人信息管理**: 统一的校园个人信息中心

### 🤖 多模态AI对话

- **多供应商支持**: OpenAI、Google Gemini、Anthropic Claude等主流AI服务
- **流式对话**: 实时响应，支持思考链显示（o1、Gemini Thinking等）
- **多模态支持**: 文本、图片、文档输入，支持各类文件格式
- **上下文管理**: 可配置的上下文窗口管理（0-20条消息）
- **智能搜索集成**: 集成多种搜索引擎，支持实时信息检索

### 👥 智能体管理
- **个性化智能体**: 创建和管理不同角色的AI助手（学习助手、编程助手、写作助手等）
- **智能体分组**: 按类别组织智能体，支持拖拽排序和分组管理
- **系统提示词**: 自定义智能体行为和专业领域
- **API配置绑定**: 每个智能体可绑定不同的API配置和模型

### 📚 知识库与RAG
- **多知识库支持**: 创建和管理多个独立知识库（课程资料、论文资料等）
- **文档管理**: 支持PDF、DOCX、TXT等多种格式，支持批量处理
- **智能分块**: 自动文档分块和向量化处理，优化检索效果
- **向量搜索**: 基于ObjectBox本地向量数据库的语义检索
- **RAG增强**: 可选的检索增强生成功能，提升AI回答准确性

### 🎨 界面特性
- **Modern Material Design**: Material Design 3设计语言
- **卡片式布局**: 美观的卡片式信息展示
- **全屏图片查看**: 支持缩放、平移的沉浸式图片查看
- **代码高亮**: 多语言代码语法高亮显示，支持复制功能<img width="2500" height="1363" alt="屏幕截图 2025-09-08 213157" src="https://github.com/user-attachments/assets/fa587e38-9a8b-4fcb-9580-ae06430b71e8" />

- **数学公式**: LaTeX数学公式完整渲染支持
- **Mermaid图表**: 流程图、时序图、甘特图等图表渲染

### ⚙️ 高级设置
- **模型参数**: 温度、最大Token、TopP等参数精确调节
- **主题切换**: Material Design 3深色/浅色主题自动适配<img width="2533" height="1374" alt="屏幕截图 2025-09-08 213325" src="https://github.com/user-attachments/assets/f932c354-ac26-450f-837e-0331f4117bc1" />

- **侧边栏管理**: 可折叠的响应式侧边栏设计
- **数据管理**: 完整的本地数据存储和备份功能
- **MCP集成**: 支持MCP (Model Context Protocol) 服务器集成

## 🏗️ 技术架构

### 架构模式
- **Clean Architecture**: 清晰的分层架构
- **Domain-Driven Design**: 领域驱动设计
- **MVVM Pattern**: 使用Riverpod状态管理

### 核心技术栈
- **Flutter**: 跨平台UI框架，Material Design 3
- **Riverpod**: 状态管理和依赖注入
- **Drift**: 类型安全的本地数据库ORM (SQLite)
- **ObjectBox**: 高性能本地向量数据库
- **Freezed**: 不可变数据类生成
- **Go Router**: 声明式路由管理
- **Dio**: 强大的HTTP网络请求库

### 项目结构
```
lib/
├── app/                       # 应用入口和导航
│   ├── navigation/           # 侧边栏和路由管理
│   └── constants/            # 应用常量定义
├── core/                      # 核心服务和工具
│   ├── database/             # 数据库配置和迁移
│   └── utils/                # 通用工具类
├── data/                      # 数据层
│   └── local/                # 本地数据库表定义
├── features/                  # 功能模块（Clean Architecture）
│   ├── daily_management/     # 校园日常管理
│   │   ├── presentation/     # UI和状态管理
│   │   └── services/         # 业务逻辑服务
│   ├── llm_chat/            # AI对话功能
│   │   ├── data/            # 数据层（API提供商）
│   │   ├── domain/          # 领域层（实体和用例）
│   │   └── presentation/    # 表现层（UI组件）
│   ├── knowledge_base/      # 知识库RAG功能
│   │   ├── data/            # 向量数据库和文档处理
│   │   ├── domain/          # RAG核心逻辑
│   │   └── presentation/    # 知识库管理界面
│   ├── persona_management/  # 智能体管理
│   ├── settings/            # 应用设置
│   ├── course_schedule/     # 课程安排（西电教务）
│   ├── learning_mode/       # 学习模式
│   └── mcp_integration/     # MCP协议集成
├── model/                     # 数据模型定义
├── repository/               # 数据仓库和缓存
└── shared/                   # 共享组件和工具
    ├── widgets/             # 通用UI组件
    └── utils/               # 共享工具函数
```

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.8.1
- Dart SDK >= 3.8.1  
- Android Studio / VS Code
- Git

### 开发命令

```bash
# 安装依赖
flutter pub get

# 生成代码(Freezed、JSON序列化、Drift数据库)
dart run build_runner build --delete-conflicting-outputs

# 监听文件变化自动生成代码
dart run build_runner watch --delete-conflicting-outputs

# 运行应用
flutter run

# 运行测试
flutter test

# 构建发布
flutter build apk --release      # Android
flutter build windows --release  # Windows
flutter build ios --release     # iOS
```

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/your-repo/campus-copilot.git
cd campus-copilot
```

2. **安装依赖**
```bash
flutter pub get
```

3. **生成代码（重要）**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **运行应用**
```bash
flutter run
```

### 初始配置

#### 1. API密钥配置
1. 进入应用设置页面
2. 选择要使用的AI供应商
3. 输入相应的API密钥：
   - **OpenAI**: 在 [OpenAI Platform](https://platform.openai.com/) 获取
   - **Google Gemini**: 在 [Google AI Studio](https://aistudio.google.com/) 获取
   - **Anthropic Claude**: 在 [Anthropic Console](https://console.anthropic.com/) 获取

#### 2. 西电教务系统配置（课程表功能）
1. 进入日常管理 → 课程表
2. 使用西电统一身份认证账号登录
3. 系统将自动获取并缓存课程表数据
4. 支持自动登录和7天数据缓存

## 📖 功能详解

### 🎓 校园日常管理
- **智能课程表**: 自动从西电教务系统同步课程安排![课表](https://github.com/user-attachments/assets/561e5306-882c-4fe1-884f-e9a10fdb309f)

- **实时状态**: 显示当前正在上的课和下节课信息<img width="2518" height="1019" alt="屏幕截图 2025-09-08 213556" src="https://github.com/user-attachments/assets/9d1cdf04-0772-41cc-a88a-a1dcae9a27a2" />

- **课程预览**: 卡片式展示今日课程概览和计划安排
- **学期管理**: 自动识别学期周次，支持多学期数据
- **登录记忆**: 支持登录信息保存，应用启动时自动登录

### 🤖 AI对话功能
- **多会话管理**: 创建和管理多个独立的对话会话<img width="496" height="1511" alt="屏幕截图 2025-09-08 214735" src="https://github.com/user-attachments/assets/dabe98f4-a73a-4bbd-93dd-15dfa72a39a2" />

- **智能体选择**: 从预设或自定义智能体中选择对话伙伴<img width="2488" height="1447" alt="image" src="https://github.com/user-attachments/assets/a91a6d7c-640d-4ad0-9832-cd401b37399e" />

- **多模态输入**: 支持文本、图片、文档等多种输入方式<img width="1872" height="761" alt="屏幕截图 2025-09-08 213717" src="https://github.com/user-attachments/assets/f00dcce7-fb0d-4793-9fb5-2c14e22669d9" />

- **实时流式响应**: 打字机效果的实时响应体验
- **思考过程可视化**: 支持o1、Gemini Thinking等模型的思考过程展示
- **上下文管理**: 可配置的对话历史管理（0-20条消息）

### 👥 智能体管理
- **智能体创建**: 创建学习助手、编程助手、写作助手等角色<img width="2519" height="1479" alt="屏幕截图 2025-09-08 214634" src="https://github.com/user-attachments/assets/bd26fbd6-3898-4863-8339-3ce7bb639020" />

- **分组管理**: 按专业、用途等维度组织智能体
- **系统提示词**: 自定义智能体的行为模式和专业领域
- **API绑定**: 为不同智能体配置专用的API和模型
- **使用统计**: 跟踪智能体的使用频率和效果

### 📚 知识库功能
- **多知识库**: 为不同课程、项目创建独立的知识库
- **文档上传**: 支持PDF、DOCX、TXT等格式的批量上传
- **智能处理**: 自动文档分块、向量化和语义索引
- **RAG检索**: 基于语义相似度的智能文档检索
- **增强对话**: 在AI对话中自动检索相关知识增强回答

## 🔧 开发指南

### 添加新功能模块

1. **创建功能目录**（遵循Clean Architecture）
```
lib/features/your_feature/
├── data/              # 数据层
│   ├── providers/     # API和数据提供商
│   └── repositories/  # 数据仓库实现
├── domain/            # 领域层
│   ├── entities/      # 业务实体
│   ├── services/      # 业务服务
│   └── repositories/  # 仓库接口
└── presentation/      # 表现层
    ├── providers/     # Riverpod状态管理
    ├── views/         # UI页面
    └── widgets/       # UI组件
```

2. **实现分层架构**
- **Data Layer**: API集成、本地存储、缓存管理
- **Domain Layer**: 业务逻辑、实体定义、服务接口
- **Presentation Layer**: UI组件、状态管理、用户交互

3. **添加导航路由**
在 `app/navigation/app_router.dart` 中添加新页面路由

4. **注册依赖注入**
在相应的Provider文件中使用Riverpod注册服务

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
- ✅ **iOS**: 完整功能支持，适配iOS设计规范
- 🔄 **macOS**: 理论支持，未充分测试
- 🔄 **Linux**: 理论支持，未充分测试
- ❌ **Web**: 暂不支持（ObjectBox向量数据库限制）

> **特殊说明**: 
> - 西电教务系统集成功能主要面向西安电子科技大学学生
> - 其他学校用户可以使用除课程表管理外的所有AI功能

## 🎯 核心功能演示

### 🎓 校园日常管理
1. **登录西电教务**: 使用统一身份认证登录，自动获取课程表
2. **智能课程预览**: 主页卡片显示当前课程和下节课信息
3. **学期时间管理**: 自动识别当前学期周次，支持周次切换
4. **课程详情查看**: 完整的课程时间表，支持时间段对齐显示
5. **自动缓存**: 7天有效期的课程数据缓存，减少网络请求

### 📚 知识库RAG功能
1. **多知识库管理**: 为不同课程、项目创建专门的知识库
2. **批量文档上传**: 支持拖拽上传PDF、DOCX、TXT等格式
3. **智能文档处理**: 自动分块、向量化，实时处理状态显示
4. **语义搜索**: 基于ObjectBox的高性能向量相似度搜索
5. **RAG增强对话**: 在AI对话中自动检索相关知识库内容

### 🤖 智能体对话
1. **智能体选择**: 从学习助手、编程助手等预设角色中选择
2. **多模态交互**: 支持文本、图片、文档等多种输入方式
3. **实时流式响应**: 打字机效果的实时AI回答生成
4. **思考过程展示**: 支持o1、Gemini Thinking等模型的推理过程
5. **参数精确调节**: 温度、最大Token、TopP等参数实时调节

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
- [ObjectBox](https://objectbox.io/) - 高性能本地向量数据库
- [traintime_pda](https://github.com/BenderBlog/traintime_pda) - Traintime PDA，又称 XDYou，是为西电学生设计的开源信息查询软件。

---

<div align="center">

**Campus Copilot** - 让AI助手成为你的校园智能伙伴 🎓🚀

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev/)
[![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=flat&logo=material-design&logoColor=white)](https://material.io/design)

</div>
