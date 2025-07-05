# 知识库和RAG功能实现文档

## 概述

本文档描述了在AI助手应用中实现的完整知识库和RAG（检索增强生成）功能。该功能允许用户上传文档，自动处理和向量化，并在聊天中智能检索相关信息来增强AI回答。

## 功能特性

### 1. 知识库管理
- **文档上传**: 支持多种文件格式（TXT、MD、PDF、DOCX等）
- **自动处理**: 文档自动分块、文本提取和向量化
- **状态跟踪**: 实时显示文档处理进度和状态
- **批量操作**: 支持批量上传、删除和重新索引

### 2. 嵌入模型配置
- **模型选择**: 从用户配置的模型列表中选择嵌入模型
- **参数配置**: 可配置分块大小、重叠、相似度阈值等参数
- **多提供商支持**: 支持OpenAI、Google、Anthropic等提供商的嵌入模型

### 3. 向量搜索
- **相似度搜索**: 基于余弦相似度的向量搜索
- **混合搜索**: 结合向量搜索和关键词搜索
- **智能排序**: 根据相似度和相关性智能排序结果

### 4. RAG集成
- **自动增强**: 智能判断查询是否需要RAG增强
- **上下文注入**: 将检索到的相关信息注入到AI提示词中
- **透明处理**: 用户无感知的RAG处理流程

## 架构设计

### 数据层
```
lib/data/local/tables/
├── knowledge_documents_table.dart     # 文档表
├── knowledge_chunks_table.dart        # 文本块表
└── knowledge_base_configs_table.dart  # 配置表
```

### 领域层
```
lib/features/knowledge_base/domain/
├── entities/
│   └── knowledge_document.dart        # 实体定义
└── services/
    ├── document_processing_service.dart # 文档处理
    ├── embedding_service.dart          # 嵌入生成
    ├── vector_search_service.dart      # 向量搜索
    └── rag_service.dart                # RAG服务
```

### 表现层
```
lib/features/knowledge_base/presentation/
├── views/
│   └── knowledge_base_screen.dart     # 主界面
└── providers/
    ├── knowledge_base_provider.dart   # 知识库状态管理
    ├── knowledge_base_config_provider.dart # 配置管理
    ├── document_processing_provider.dart   # 处理状态管理
    └── rag_provider.dart              # RAG状态管理
```

## 核心流程

### 1. 文档上传和处理流程
```
用户上传文档 → 文档信息保存 → 文本提取 → 智能分块 → 生成嵌入向量 → 保存到数据库
```

### 2. RAG增强流程
```
用户提问 → 判断是否需要RAG → 生成查询嵌入 → 向量搜索 → 构建增强提示词 → 发送给AI模型
```

### 3. 搜索流程
```
用户搜索 → 生成查询嵌入 → 向量相似度计算 → 关键词匹配 → 结果合并排序 → 返回结果
```

## 数据库设计

### 知识库配置表 (knowledge_base_configs)
- `id`: 配置唯一标识
- `name`: 配置名称
- `embedding_model_id`: 嵌入模型ID
- `embedding_model_name`: 嵌入模型名称
- `embedding_model_provider`: 模型提供商
- `chunk_size`: 分块大小
- `chunk_overlap`: 分块重叠
- `max_retrieved_chunks`: 最大检索结果数
- `similarity_threshold`: 相似度阈值
- `is_default`: 是否为默认配置

### 文档表 (knowledge_documents)
- `id`: 文档唯一标识
- `name`: 文档名称
- `type`: 文件类型
- `size`: 文件大小
- `file_path`: 文件路径
- `file_hash`: 文件哈希
- `status`: 处理状态
- `chunks`: 文本块数量
- `uploaded_at`: 上传时间
- `processed_at`: 处理时间

### 文本块表 (knowledge_chunks)
- `id`: 文本块唯一标识
- `document_id`: 所属文档ID
- `content`: 文本内容
- `chunk_index`: 块索引
- `character_count`: 字符数
- `token_count`: Token数
- `embedding`: 嵌入向量（JSON格式）
- `created_at`: 创建时间

## 使用说明

### 1. 配置嵌入模型
1. 进入知识库设置页面
2. 选择嵌入模型（从已配置的模型列表中选择）
3. 调整分块参数和搜索参数
4. 保存配置

### 2. 上传文档
1. 点击上传按钮
2. 选择支持的文件格式
3. 等待自动处理完成
4. 查看处理状态和结果

### 3. 搜索知识库
1. 在搜索页面输入查询
2. 查看向量搜索结果
3. 点击结果查看详细信息
4. 复制相关内容

### 4. RAG增强聊天
1. 在聊天界面正常提问
2. 系统自动判断是否需要RAG
3. 如需要，自动检索相关知识
4. AI基于检索到的信息回答

## 性能优化

### 1. 向量存储优化
- 使用JSON格式存储向量，便于查询
- 批量处理嵌入生成，减少API调用
- 缓存常用查询结果

### 2. 搜索优化
- 混合搜索策略，提高召回率
- 智能阈值调整，平衡精度和召回
- 结果缓存，提高响应速度

### 3. 内存优化
- 流式处理大文档
- 分批加载搜索结果
- 及时释放不用的资源

## 扩展功能

### 1. 支持更多文件格式
- PDF文本提取
- DOCX文档解析
- 图片OCR识别
- 音频转文字

### 2. 高级搜索功能
- 语义搜索
- 多模态搜索
- 时间范围过滤
- 文档类型过滤

### 3. 知识图谱
- 实体识别和链接
- 关系抽取
- 知识推理
- 可视化展示

## 故障排除

### 常见问题
1. **文档处理失败**: 检查文件格式和大小限制
2. **嵌入生成失败**: 检查API配置和网络连接
3. **搜索结果不准确**: 调整相似度阈值和搜索参数
4. **RAG效果不好**: 优化文档质量和分块策略

### 调试方法
1. 查看处理日志
2. 检查数据库状态
3. 验证API调用
4. 测试搜索功能

## 总结

本知识库和RAG功能实现了完整的文档管理、向量搜索和智能问答流程，为AI助手提供了强大的知识检索和增强能力。通过模块化设计和清晰的架构，系统具有良好的可扩展性和维护性。
