# AnywhereChat 架构文档

## 项目概述

AnywhereChat 是一个基于 Flutter 的多模态 AI 聊天应用，支持文本、图片、文档等多种输入方式，集成了知识库检索增强生成（RAG）功能。

## 技术栈

- **前端框架**: Flutter 3.x
- **状态管理**: Riverpod
- **数据库**: Drift (SQLite)
- **路由**: GoRouter
- **UI组件**: Material Design 3
- **图片处理**: image_picker, image
- **文档处理**: file_picker, docx_to_text
- **网络请求**: http, dio
- **AI集成**: OpenAI API, Google Gemini API

## 项目结构

```
lib/
├── app/                    # 应用级配置
│   ├── app_router.dart    # 路由配置
│   └── app_theme.dart     # 主题配置
├── core/                  # 核心功能
│   ├── constants/         # 常量定义
│   ├── di/               # 依赖注入
│   ├── exceptions/       # 异常处理
│   ├── services/         # 核心服务
│   └── utils/            # 工具函数
├── data/                 # 数据层
│   └── local/            # 本地数据存储
├── features/             # 功能模块
│   ├── llm_chat/         # 聊天功能
│   ├── knowledge_base/   # 知识库管理
│   ├── persona_management/ # 智能体管理
│   └── settings/         # 设置管理
└── shared/               # 共享组件
    └── widgets/          # 通用UI组件
```

## 核心功能模块

### 1. 聊天模块 (llm_chat)
- **多模态输入**: 支持文本、图片、文档输入
- **流式响应**: 实时显示AI回复
- **消息管理**: 消息存储、检索、删除
- **会话管理**: 多会话支持，会话配置

### 2. 知识库模块 (knowledge_base)
- **文档管理**: 支持多种文档格式
- **向量检索**: 基于embedding的相似度搜索
- **RAG增强**: 检索增强生成
- **多知识库**: 支持多个独立知识库

### 3. 智能体管理 (persona_management)
- **智能体配置**: 自定义AI角色和提示词
- **分组管理**: 智能体分组和组织
- **配置绑定**: 智能体与API配置绑定

### 4. 设置管理 (settings)
- **API配置**: 多个LLM提供商配置
- **UI设置**: 界面个性化设置
- **模型参数**: 温度、Token限制等参数调节

## 数据流架构

```
UI Layer (Widgets)
    ↓
Presentation Layer (Providers/Notifiers)
    ↓
Domain Layer (Use Cases/Services)
    ↓
Data Layer (Repositories/Database)
```

## 状态管理

使用 Riverpod 进行状态管理：
- **Provider**: 依赖注入和服务提供
- **StateNotifier**: 复杂状态管理
- **StateProvider**: 简单状态管理
- **FutureProvider**: 异步数据处理

## 数据库设计

使用 Drift 进行数据库管理，主要表结构：
- **chat_sessions**: 聊天会话
- **chat_messages**: 聊天消息
- **personas**: 智能体配置
- **knowledge_bases**: 知识库信息
- **documents**: 文档记录
- **chunks**: 文档分块
- **settings**: 应用设置

## API集成

支持多个LLM提供商：
- **OpenAI**: GPT系列模型
- **Google**: Gemini系列模型
- **自定义**: 兼容OpenAI格式的API

## 安全考虑

- **API密钥**: 本地加密存储
- **数据隔离**: 不同知识库数据隔离
- **输入验证**: 严格的输入验证和清理
- **错误处理**: 完善的异常处理机制
