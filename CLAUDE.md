# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 开发命令

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

## 架构概述

项目采用Clean Architecture + DDD架构:

- **表现层(Presentation)**: UI组件和Riverpod状态管理
- **领域层(Domain)**: 实体、用例、服务接口 
- **数据层(Data)**: 仓库实现、数据源、API集成

### 核心技术栈

- **状态管理**: Riverpod (StateNotifier/Provider)
- **本地存储**: Drift(SQLite) + ObjectBox(向量数据库)
- **多模态AI**: OpenAI、Google Gemini、Anthropic集成
- **RAG系统**: 基于ObjectBox的本地向量数据库实现
- **UI框架**: Material Design 3

关键目录结构:
```
lib/
├── app/                    # 应用配置和导航
├── core/                   # 核心服务和工具
├── data/local/            # 本地数据库
├── features/              # 功能模块
│   ├── llm_chat/         # AI对话
│   ├── knowledge_base/   # 知识库RAG
│   ├── persona_management/ # 智能体管理
│   └── settings/         # 设置
└── shared/               # 共享组件
```

## 重要开发注意事项

1. 使用Freezed创建不可变数据类
2. Provider命名须以Provider/Notifier结尾
3. 数据库更改需要版本化管理
4. API密钥等敏感信息使用本地加密存储
5. 保持完整的中文注释

## Development Environment
- OS: Windows 10.0.19045
- Shell: Git Bash
- Path format: Windows (use forward slashes in Git Bash)
- File system: Case-insensitive
- Line endings: CRLF (configure Git autocrlf)

## Playwright MCP Guide

File paths:
- Screenshots: `./CCimages/screenshots/`
- PDFs: `./CCimages/pdfs/`

Browser error fix: `npx playwright install`
