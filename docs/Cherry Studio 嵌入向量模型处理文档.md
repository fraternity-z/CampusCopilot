# Cherry Studio 嵌入向量模型处理文档

## 概述
Cherry Studio是一个智能AI助手应用，支持多种嵌入向量模型用于知识库管理、RAG（检索增强生成）、记忆系统等功能。本文档详细分析了项目中嵌入向量模型的识别、配置、处理逻辑和默认设定。

## 1. 嵌入模型识别机制

### 1.1 识别正则表达式
**文件位置**: `src/renderer/src/config/models.ts`

```typescript
// 嵌入模型识别正则表达式
export const EMBEDDING_REGEX = 
  /(?:^text-|embed|bge-|e5-|LLM2Vec|retrieval|uae-|gte-|jina-clip|jina-embeddings|voyage-)/i
```

### 1.2 模型识别函数
```typescript
export function isEmbeddingModel(model: Model): boolean {
  if (!model || isRerankModel(model)) {
    return false
  }

  const modelId = getLowerBaseModelName(model.id)

  // 用户自定义类型优先
  if (isUserSelectedModelType(model, 'embedding') !== undefined) {
    return isUserSelectedModelType(model, 'embedding')!
  }

  // Anthropic 模型不支持嵌入
  if (['anthropic'].includes(model?.provider)) {
    return false
  }

  // 豆包模型特殊处理
  if (model.provider === 'doubao' || modelId.includes('doubao')) {
    return EMBEDDING_REGEX.test(model.name)
  }

  return EMBEDDING_REGEX.test(modelId) || false
}
```

## 2. 支持的嵌入模型配置

### 2.1 模型列表
**文件位置**: `src/renderer/src/config/embedings.ts`

项目支持305种不同的嵌入模型，主要分类包括：

#### OpenAI 系列
- `text-embedding-3-small` (8191 context)
- `text-embedding-3-large` (8191 context)  
- `text-embedding-ada-002` (8191 context)

#### 阿里巴巴 Qwen 系列
- `text-embedding-v3` (8192 context)
- `text-embedding-v2` (2048 context)
- `text-embedding-v1` (2048 context)

#### 字节跳动 Doubao 系列
- `Doubao-embedding` (4095 context)
- `Doubao-embedding-vision` (8191 context)
- `Doubao-embedding-large` (4095 context)

#### 百度文心系列
- `Embedding-V1` (384 context)
- `tao-8k` (8192 context)

#### 腾讯混元系列
- `hunyuan-embedding` (1024 context)

#### BGE 系列
- `BAAI/bge-m3` (8191 context)
- `BAAI/bge-large-zh-v1.5` (512 context)
- `BAAI/bge-large-en-v1.5` (512 context)

#### Jina AI 系列
- `jina-embeddings-v2-base-en` (8191 context)
- `jina-embeddings-v2-base-zh` (8191 context)
- `jina-embeddings-v3` (8191 context)
- `jina-clip-v1` (8191 context)

#### Voyage AI 系列
- `voyage-3-large` (2048 context)
- `voyage-3` (1024 context)
- `voyage-3-lite` (512 context)
- `voyage-code-3` (1024 context)

#### Cohere 系列
- `embed-english-v3.0` (512 context)
- `embed-multilingual-v3.0` (512 context)

#### Nomic 系列
- `nomic-embed-text-v1.5` (8192 context)

### 2.2 最大上下文获取函数
```typescript
export function getEmbeddingMaxContext(id: string) {
  const model = EMBEDDING_MODELS.find((m) => m.id === id)
  
  if (model) {
    return model.max_context
  }

  // 特殊模型规则
  if (id.includes('bge-large')) {
    return 512
  }

  if (id.includes('bge-m3')) {
    return 8000
  }

  return undefined
}
```

## 3. 嵌入向量处理架构

### 3.1 工厂模式实现
**文件位置**: `src/main/knowledge/embeddings/EmbeddingsFactory.ts`

```typescript
export default class EmbeddingsFactory {
  static create({ embedApiClient, dimensions }: { 
    embedApiClient: ApiClient; 
    dimensions?: number 
  }): BaseEmbeddings {
    const batchSize = 10
    const { model, provider, apiKey, apiVersion, baseURL } = embedApiClient
    
    // Voyage AI 特殊处理
    if (provider === 'voyageai') {
      return new VoyageEmbeddings({
        modelName: model,
        apiKey,
        outputDimension: dimensions,
        batchSize: 8
      })
    }
    
    // Ollama 特殊处理
    if (provider === 'ollama') {
      return new OllamaEmbeddings({
        model: model,
        baseUrl: baseURL,
        requestOptions: {
          'encoding-format': 'float'
        }
      })
    }
    
    // Azure OpenAI 处理
    if (apiVersion !== undefined) {
      return new AzureOpenAiEmbeddings({
        azureOpenAIApiKey: apiKey,
        azureOpenAIApiVersion: apiVersion,
        azureOpenAIApiDeploymentName: model,
        azureOpenAIEndpoint: baseURL,
        dimensions,
        batchSize
      })
    }
    
    // 默认 OpenAI 兼容处理
    return new OpenAiEmbeddings({
      model,
      apiKey,
      dimensions,
      batchSize,
      configuration: { baseURL }
    })
  }
}
```

### 3.2 Voyage AI 特殊维度处理
**文件位置**: `src/main/knowledge/embeddings/VoyageEmbeddings.ts`

```typescript
export class VoyageEmbeddings extends BaseEmbeddings {
  override async getDimensions(): Promise<number> {
    return this.configuration?.outputDimension ?? 
           (this.configuration?.modelName === 'voyage-code-2' ? 1536 : 1024)
  }
}
```

## 4. 默认维度设定

### 4.1 内存服务统一维度
**文件位置**: `src/main/services/memory/MemoryService.ts`

```typescript
export class MemoryService {
  private static readonly UNIFIED_DIMENSION = 1536
  private static readonly SIMILARITY_THRESHOLD = 0.85
}
```

### 4.2 各模型默认维度

| 模型系列 | 默认维度 | 备注 |
|---------|----------|------|
| OpenAI text-embedding-3-large | 1536 | 可配置 |
| OpenAI text-embedding-3-small | 1536 | 可配置 |
| Voyage-3 | 1024 | 默认 |
| Voyage-code-2 | 1536 | 特殊处理 |
| BGE 系列 | 1024 | 一般情况 |
| Jina 系列 | 768-1536 | 根据模型 |

## 5. API 客户端实现

### 5.1 基础接口
**文件位置**: `src/renderer/src/aiCore/clients/BaseApiClient.ts`

```typescript
abstract class BaseApiClient {
  abstract getEmbeddingDimensions(model?: Model): Promise<number>
}
```

### 5.2 各提供商实现

#### OpenAI 实现
```typescript
override async getEmbeddingDimensions(model: Model): Promise<number> {
  const sdk = await this.getSdkInstance()
  const data = await sdk.embeddings.create({
    model: model.id,
    input: 'test',
    dimensions: 1 // 测试用
  })
  return data.data[0].embedding.length
}
```

#### Gemini 实现
```typescript
override async getEmbeddingDimensions(model: Model): Promise<number> {
  const sdk = await this.getSdkInstance()
  const data = await sdk.models.embedContent({
    model: model.id,
    content: { parts: [{ text: 'test' }] }
  })
  return data.response.embedding.values.length
}
```

#### AWS Bedrock 实现
```typescript
override async getEmbeddingDimensions(model?: Model): Promise<number> {
  if (!model) {
    throw new Error('Model is required for AWS Bedrock embedding dimensions.')
  }
  // 根据具体模型返回相应维度
}
```

#### Anthropic 实现
```typescript
override async getEmbeddingDimensions(): Promise<number> {
  throw new Error("Anthropic SDK doesn't support getEmbeddingDimensions method.")
}
```

## 6. 用户界面集成

### 6.1 维度输入组件
**文件位置**: `src/renderer/src/components/InputEmbeddingDimension.tsx`

该组件提供：
- 手动输入维度值
- 自动获取模型默认维度
- 验证和错误处理

```typescript
const handleFetchDimension = useCallback(async () => {
  const aiProvider = new AiProvider(provider)
  const dimension = await aiProvider.getEmbeddingDimensions(model)
  onChange?.(dimension)
}, [model, provider, onChange])
```

## 7. 知识库集成

### 7.1 RAG 设置
**文件位置**: `src/renderer/src/pages/settings/WebSearchSettings/CompressionSettings/RagSettings.tsx`

用户可以在 RAG 设置中：
- 选择嵌入模型
- 设置维度大小  
- 配置文档数量
- 选择重排模型

### 7.2 知识库设置
在知识库管理中可以：
- 为每个知识库独立配置嵌入模型
- 设置自定义维度
- 选择合适的上下文长度

## 8. 模型适配指南

### 8.1 添加新的嵌入模型

1. **添加模型配置**
   在 `embedings.ts` 中添加模型信息：
   ```typescript
   {
     id: 'new-embedding-model',
     max_context: 8192
   }
   ```

2. **更新识别正则**
   如需要，更新 `models.ts` 中的 `EMBEDDING_REGEX`

3. **实现 API 客户端**
   在相应的 API 客户端中实现 `getEmbeddingDimensions` 方法

4. **特殊处理逻辑**
   如有特殊需求，在 `EmbeddingsFactory` 中添加处理逻辑

### 8.2 维度处理最佳实践

1. **优先级顺序**：
   - 用户手动设置 > 模型默认维度 > 系统默认维度
   
2. **错误处理**：
   - 提供清晰的错误信息
   - 支持降级处理
   
3. **性能考虑**：
   - 缓存维度信息
   - 避免重复API调用

## 9. 配置示例

### 9.1 典型配置
```typescript
// 知识库配置示例
const knowledgeConfig = {
  embeddingModel: {
    id: 'text-embedding-3-large',
    provider: 'openai',
    dimensions: 1536
  },
  rerankModel: {
    id: 'jina-reranker-v1-base-en',
    provider: 'jina'
  }
}
```

### 9.2 内存系统配置
```typescript
// 内存系统配置
const memoryConfig = {
  unifiedDimension: 1536,
  similarityThreshold: 0.85,
  embeddingModel: 'text-embedding-ada-002'
}
```

## 10. 故障排除

### 10.1 常见问题

1. **维度不匹配**
   - 确保所有向量维度一致
   - 检查模型配置是否正确

2. **API 调用失败** 
   - 验证 API 密钥
   - 检查网络连接
   - 确认模型可用性

3. **性能问题**
   - 调整批处理大小
   - 优化上下文长度
   - 考虑使用更小的模型

### 10.2 调试建议

1. 启用详细日志
2. 使用测试数据验证
3. 监控API调用频率
4. 检查向量质量

## 结论

Cherry Studio 提供了完整的嵌入向量模型支持体系，包括模型识别、配置管理、API集成和用户界面。系统设计灵活，支持多种主流嵌入模型，并提供了扩展机制来适配新的模型。通过统一的工厂模式和抽象接口，确保了代码的可维护性和扩展性。

默认使用1536维度确保了与主流OpenAI模型的兼容性，同时支持用户根据需求进行自定义配置。各个组件之间的集成良好，为用户提供了完整的嵌入向量处理体验。
