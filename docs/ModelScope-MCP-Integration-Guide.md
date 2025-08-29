# ModelScope MCP 集成指南：数据格式转换与适配机制

## 概述

本文档详细说明了 CherryStudio 如何将 ModelScope 平台的 MCP 服务格式转换为统一的 MCP 标准格式，实现无缝集成和管理。

## ModelScope API 数据结构

### API 端点

**获取可运行的 MCP 服务列表：**
```
GET https://www.modelscope.cn/api/v1/mcp/services/operational
```

**认证方式：**
```http
Authorization: Bearer {your_access_token}
Content-Type: application/json
```

### ModelScope API 响应格式

```json
{
  "Code": 200,
  "Message": "success",
  "Data": {
    "Result": [
      {
        "id": "12306-mcp",
        "name": "12306TrainQuery",
        "chinese_name": "12306火车票查询服务",
        "description": "提供全国火车票查询、余票查询、车次信息查询等功能",
        "operational_urls": [
          {
            "url": "https://mcp.api-inference.modelscope.net/f3bc99ae109c43/sse"
          }
        ],
        "tags": ["交通", "查询", "火车票"],
        "logo_url": "https://modelscope.cn/api/v1/models/logos/12306-mcp.png",
        "author": "modelscope",
        "version": "1.0.0",
        "status": "active",
        "created_at": "2024-01-15T10:30:00Z",
        "updated_at": "2024-01-20T14:45:00Z"
      },
      {
        "id": "weather-mcp",
        "name": "WeatherQuery",
        "chinese_name": "天气查询服务",
        "description": "提供全球天气查询、预报、历史天气等功能",
        "operational_urls": [
          {
            "url": "https://mcp.api-inference.modelscope.net/weather/sse"
          }
        ],
        "tags": ["天气", "查询", "预报"],
        "logo_url": "https://modelscope.cn/api/v1/models/logos/weather-mcp.png"
      }
    ],
    "Total": 25,
    "Page": 1,
    "PageSize": 20
  }
}
```

## 数据转换映射关系

### 字段映射表

| ModelScope 字段 | MCP 标准字段 | 转换规则 | 示例 |
|----------------|-------------|---------|------|
| `id` | `id` | 添加 `@modelscope/` 前缀 | `12306-mcp` → `@modelscope/12306-mcp` |
| `chinese_name` | `name` | 优先使用中文名称，回退到英文名称 | `"12306火车票查询服务"` |
| `name` | `name` (备选) | 当 `chinese_name` 不存在时使用 | `"12306TrainQuery"` |
| `description` | `description` | 直接映射 | `"提供全国火车票查询..."` |
| `operational_urls[0].url` | `baseUrl` | 使用第一个可运行 URL | `"https://mcp.api-inference..."` |
| `tags` | `tags` | 数组直接映射 | `["交通", "查询", "火车票"]` |
| `logo_url` | `logoUrl` | 直接映射 | `"https://modelscope.cn/..."` |
| - | `type` | 固定值 `"sse"` | `"sse"` |
| - | `provider` | 固定值 `"ModelScope"` | `"ModelScope"` |
| - | `isActive` | 固定值 `true` | `true` |

### 转换后的 MCP 标准格式

```json
{
  "mcpServers": {
    "@modelscope/12306-mcp": {
      "id": "@modelscope/12306-mcp",
      "name": "12306火车票查询服务",
      "description": "提供全国火车票查询、余票查询、车次信息查询等功能",
      "type": "sse",
      "baseUrl": "https://mcp.api-inference.modelscope.net/f3bc99ae109c43/sse",
      "command": "",
      "args": [],
      "env": {},
      "isActive": true,
      "provider": "ModelScope",
      "providerUrl": "https://www.modelscope.cn/mcp/servers/@12306-mcp",
      "logoUrl": "https://modelscope.cn/api/v1/models/logos/12306-mcp.png",
      "tags": ["交通", "查询", "火车票"]
    },
    "@modelscope/weather-mcp": {
      "id": "@modelscope/weather-mcp",
      "name": "天气查询服务",
      "description": "提供全球天气查询、预报、历史天气等功能",
      "type": "sse",
      "baseUrl": "https://mcp.api-inference.modelscope.net/weather/sse",
      "command": "",
      "args": [],
      "env": {},
      "isActive": true,
      "provider": "ModelScope",
      "providerUrl": "https://www.modelscope.cn/mcp/servers/@weather-mcp",
      "logoUrl": "https://modelscope.cn/api/v1/models/logos/weather-mcp.png",
      "tags": ["天气", "查询", "预报"]
    }
  }
}
```

## 核心转换逻辑实现

### TypeScript 类型定义

```typescript
// ModelScope API 响应类型
interface ModelScopeServer {
  id: string
  name: string
  chinese_name?: string
  description?: string
  operational_urls?: { url: string }[]
  tags?: string[]
  logo_url?: string
  author?: string
  version?: string
  status?: string
  created_at?: string
  updated_at?: string
}

interface ModelScopeApiResponse {
  Code: number
  Message: string
  Data: {
    Result: ModelScopeServer[]
    Total: number
    Page: number
    PageSize: number
  }
}

// MCP 标准类型
interface MCPServer {
  id: string
  name: string
  description?: string
  type: 'stdio' | 'sse' | 'inMemory' | 'streamableHttp'
  baseUrl?: string
  command?: string
  args?: string[]
  env?: Record<string, string>
  isActive: boolean
  provider?: string
  providerUrl?: string
  logoUrl?: string
  tags?: string[]
}
```

### 转换函数实现

```typescript
import { nanoid } from '@reduxjs/toolkit'
import type { MCPServer } from '@renderer/types'

const MODELSCOPE_HOST = 'https://www.modelscope.cn'

/**
 * 将 ModelScope 服务器格式转换为 MCP 标准格式
 * @param server ModelScope 服务器对象
 * @returns MCP 标准格式的服务器对象
 */
function transformModelScopeServerToMCP(server: ModelScopeServer): MCPServer | null {
  // 验证必需字段
  if (!server.operational_urls?.[0]?.url) {
    console.warn(`Server ${server.id} has no operational URL, skipping`)
    return null
  }

  // 生成唯一 ID
  const mcpId = `@modelscope/${server.id}`
  
  // 选择最佳名称
  const displayName = server.chinese_name || 
                     server.name || 
                     `ModelScope Server ${nanoid()}`

  // 构建 MCP 服务器对象
  const mcpServer: MCPServer = {
    id: mcpId,
    name: displayName,
    description: server.description || '',
    type: 'sse', // ModelScope 统一使用 SSE 协议
    baseUrl: server.operational_urls[0].url,
    command: '',
    args: [],
    env: {},
    isActive: true, // 默认激活
    provider: 'ModelScope',
    providerUrl: `${MODELSCOPE_HOST}/mcp/servers/@${server.id}`,
    logoUrl: server.logo_url || '',
    tags: server.tags || []
  }

  return mcpServer
}

/**
 * 批量转换 ModelScope 服务器列表
 * @param servers ModelScope 服务器数组
 * @param existingServers 已存在的 MCP 服务器数组
 * @returns 转换结果包含新增和更新的服务器
 */
function batchTransformModelScopeServers(
  servers: ModelScopeServer[],
  existingServers: MCPServer[] = []
): {
  addedServers: MCPServer[]
  updatedServers: MCPServer[]
  skippedServers: string[]
} {
  const addedServers: MCPServer[] = []
  const updatedServers: MCPServer[] = []
  const skippedServers: string[] = []

  for (const server of servers) {
    try {
      const mcpServer = transformModelScopeServerToMCP(server)
      
      if (!mcpServer) {
        skippedServers.push(server.id)
        continue
      }

      // 检查服务器是否已存在
      const existingServer = existingServers.find(s => s.id === mcpServer.id)
      
      if (existingServer) {
        // 更新现有服务器（保持用户的激活状态）
        const updatedServer: MCPServer = {
          ...mcpServer,
          isActive: existingServer.isActive // 保持用户设置的激活状态
        }
        updatedServers.push(updatedServer)
      } else {
        // 添加新服务器
        addedServers.push(mcpServer)
      }
    } catch (error) {
      console.error(`Error processing ModelScope server ${server.id}:`, error)
      skippedServers.push(server.id)
    }
  }

  return {
    addedServers,
    updatedServers,
    skippedServers
  }
}
```

### 完整的同步服务实现

```typescript
interface ModelScopeSyncResult {
  success: boolean
  message: string
  addedServers: MCPServer[]
  updatedServers: MCPServer[]
  errorDetails?: string
}

/**
 * 从 ModelScope 同步 MCP 服务器
 * @param token ModelScope 访问令牌
 * @param existingServers 已存在的服务器列表
 * @returns 同步结果
 */
export async function syncModelScopeServers(
  token: string,
  existingServers: MCPServer[]
): Promise<ModelScopeSyncResult> {
  try {
    // 调用 ModelScope API
    const response = await fetch(`${MODELSCOPE_HOST}/api/v1/mcp/services/operational`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`
      }
    })

    // 处理认证错误
    if (response.status === 401 || response.status === 403) {
      return {
        success: false,
        message: '认证失败，请检查您的访问令牌',
        addedServers: [],
        updatedServers: []
      }
    }

    // 处理服务器错误
    if (!response.ok) {
      return {
        success: false,
        message: `API 请求失败: ${response.status}`,
        addedServers: [],
        updatedServers: [],
        errorDetails: `HTTP ${response.status}: ${response.statusText}`
      }
    }

    // 解析响应数据
    const data: ModelScopeApiResponse = await response.json()
    const servers = data.Data?.Result || []

    if (servers.length === 0) {
      return {
        success: true,
        message: '未找到可用的 MCP 服务器',
        addedServers: [],
        updatedServers: []
      }
    }

    // 批量转换服务器
    const { addedServers, updatedServers, skippedServers } = 
      batchTransformModelScopeServers(servers, existingServers)

    // 生成结果消息
    const totalProcessed = addedServers.length + updatedServers.length
    let message = `成功同步 ${totalProcessed} 个服务器`
    
    if (addedServers.length > 0) {
      message += `，新增 ${addedServers.length} 个`
    }
    
    if (updatedServers.length > 0) {
      message += `，更新 ${updatedServers.length} 个`
    }
    
    if (skippedServers.length > 0) {
      message += `，跳过 ${skippedServers.length} 个`
    }

    return {
      success: true,
      message,
      addedServers,
      updatedServers
    }
  } catch (error) {
    console.error('ModelScope 同步错误:', error)
    return {
      success: false,
      message: '同步过程中发生错误',
      addedServers: [],
      updatedServers: [],
      errorDetails: String(error)
    }
  }
}
```

## 数据验证与错误处理

### 数据验证规则

```typescript
/**
 * 验证 ModelScope 服务器数据的完整性
 * @param server ModelScope 服务器对象
 * @returns 验证结果
 */
function validateModelScopeServer(server: ModelScopeServer): {
  isValid: boolean
  errors: string[]
} {
  const errors: string[] = []

  // 必需字段验证
  if (!server.id) {
    errors.push('缺少服务器 ID')
  }

  if (!server.operational_urls?.length) {
    errors.push('缺少可运行的 URL')
  } else if (!server.operational_urls[0].url) {
    errors.push('第一个 URL 为空')
  }

  // URL 格式验证
  if (server.operational_urls?.[0]?.url) {
    try {
      new URL(server.operational_urls[0].url)
    } catch {
      errors.push('URL 格式无效')
    }
  }

  // 名称验证（至少要有一个有效名称）
  if (!server.name && !server.chinese_name) {
    errors.push('缺少服务器名称')
  }

  return {
    isValid: errors.length === 0,
    errors
  }
}
```

### 错误处理策略

```typescript
/**
 * 错误处理包装器
 * @param operation 要执行的操作
 * @param server 相关的服务器信息
 * @returns 操作结果
 */
async function withErrorHandling<T>(
  operation: () => Promise<T>,
  context: string
): Promise<T | null> {
  try {
    return await operation()
  } catch (error) {
    console.error(`${context} 操作失败:`, error)
    
    // 根据错误类型进行不同处理
    if (error instanceof TypeError) {
      console.error('数据类型错误，可能是 API 响应格式变更')
    } else if (error instanceof SyntaxError) {
      console.error('JSON 解析错误，API 响应可能不是有效的 JSON')
    } else if (error instanceof Error && error.name === 'NetworkError') {
      console.error('网络连接错误，请检查网络状态')
    }
    
    return null
  }
}
```

## Token 管理机制

### Token 存储与管理

```typescript
// Token 存储键
const TOKEN_STORAGE_KEY = 'modelscope_token'

/**
 * 保存 ModelScope 访问令牌
 * @param token 访问令牌
 */
export function saveModelScopeToken(token: string): void {
  try {
    localStorage.setItem(TOKEN_STORAGE_KEY, token)
    console.log('ModelScope token 已保存')
  } catch (error) {
    console.error('保存 token 失败:', error)
  }
}

/**
 * 获取 ModelScope 访问令牌
 * @returns 访问令牌或 null
 */
export function getModelScopeToken(): string | null {
  try {
    return localStorage.getItem(TOKEN_STORAGE_KEY)
  } catch (error) {
    console.error('获取 token 失败:', error)
    return null
  }
}

/**
 * 清除 ModelScope 访问令牌
 */
export function clearModelScopeToken(): void {
  try {
    localStorage.removeItem(TOKEN_STORAGE_KEY)
    console.log('ModelScope token 已清除')
  } catch (error) {
    console.error('清除 token 失败:', error)
  }
}

/**
 * 检查是否存在有效的 ModelScope 令牌
 * @returns 是否存在令牌
 */
export function hasModelScopeToken(): boolean {
  const token = getModelScopeToken()
  return !!token && token.length > 0
}
```

### Token 自动刷新机制

```typescript
/**
 * 带自动重试的 API 调用
 * @param url API 端点
 * @param options 请求选项
 * @param maxRetries 最大重试次数
 * @returns API 响应
 */
async function apiCallWithRetry(
  url: string,
  options: RequestInit,
  maxRetries: number = 3
): Promise<Response> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(url, options)
      
      // 如果是认证错误且不是最后一次尝试，清除 token 并重试
      if ((response.status === 401 || response.status === 403) && attempt < maxRetries) {
        clearModelScopeToken()
        console.log(`认证失败，尝试重试 (${attempt}/${maxRetries})`)
        continue
      }
      
      return response
    } catch (error) {
      if (attempt === maxRetries) {
        throw error
      }
      console.log(`请求失败，尝试重试 (${attempt}/${maxRetries}):`, error)
      await new Promise(resolve => setTimeout(resolve, 1000 * attempt))
    }
  }
  
  throw new Error('最大重试次数已达到')
}
```

## 配置示例

### 基本配置示例

```json
{
  "mcpServers": {
    "@modelscope/12306-mcp": {
      "id": "@modelscope/12306-mcp",
      "name": "12306火车票查询服务",
      "description": "提供全国火车票查询、余票查询、车次信息查询等功能",
      "type": "sse",
      "baseUrl": "https://mcp.api-inference.modelscope.net/f3bc99ae109c43/sse",
      "isActive": true,
      "provider": "ModelScope",
      "tags": ["交通", "查询", "火车票"]
    }
  }
}
```

### 高级配置示例

```json
{
  "mcpServers": {
    "@modelscope/advanced-weather": {
      "id": "@modelscope/advanced-weather",
      "name": "高级天气预报服务",
      "description": "提供全球天气预报、气象预警、历史数据分析等高级功能",
      "type": "sse",
      "baseUrl": "https://mcp.api-inference.modelscope.net/weather-advanced/sse",
      "headers": {
        "X-Custom-Header": "value",
        "X-Version": "v2"
      },
      "timeout": 30,
      "longRunning": false,
      "isActive": true,
      "provider": "ModelScope",
      "providerUrl": "https://www.modelscope.cn/mcp/servers/@advanced-weather",
      "logoUrl": "https://modelscope.cn/api/v1/models/logos/weather-advanced.png",
      "tags": ["天气", "预报", "高级", "分析"],
      "disabledTools": [],
      "disabledAutoApproveTools": ["dangerous-operation"]
    }
  }
}
```

## 最佳实践

### 1. 数据转换最佳实践

**优先级策略：**
```typescript
// 名称优先级：中文名称 > 英文名称 > 生成名称
const displayName = server.chinese_name || 
                   server.name || 
                   `ModelScope Server ${nanoid()}`

// URL 选择：使用第一个可运行的 URL
const serviceUrl = server.operational_urls?.[0]?.url
if (!serviceUrl) {
  throw new Error('No operational URL available')
}
```

**数据清理：**
```typescript
// 清理和规范化标签
const cleanTags = (server.tags || [])
  .filter(tag => tag && typeof tag === 'string')
  .map(tag => tag.trim())
  .filter(tag => tag.length > 0)

// 清理描述文本
const cleanDescription = server.description
  ? server.description.trim().replace(/\s+/g, ' ')
  : ''
```

### 2. 性能优化

**批量处理：**
```typescript
// 使用 Promise.allSettled 进行并发处理
const transformPromises = servers.map(server => 
  transformModelScopeServerToMCP(server)
)

const results = await Promise.allSettled(transformPromises)
const successfulTransforms = results
  .filter((result): result is PromiseFulfilledResult<MCPServer> => 
    result.status === 'fulfilled' && result.value !== null
  )
  .map(result => result.value)
```

**缓存策略：**
```typescript
// 缓存转换结果
const transformCache = new Map<string, MCPServer>()

function getCachedTransform(server: ModelScopeServer): MCPServer | null {
  const cacheKey = `${server.id}-${server.updated_at}`
  return transformCache.get(cacheKey) || null
}

function setCachedTransform(server: ModelScopeServer, result: MCPServer): void {
  const cacheKey = `${server.id}-${server.updated_at}`
  transformCache.set(cacheKey, result)
}
```

### 3. 错误监控与日志

**结构化日志：**
```typescript
interface TransformLog {
  timestamp: string
  serverId: string
  action: 'transform' | 'skip' | 'error'
  details?: string
  performance?: {
    duration: number
    memoryUsage: number
  }
}

function logTransform(log: TransformLog): void {
  console.log(`[ModelScope Transform] ${log.timestamp}`, {
    serverId: log.serverId,
    action: log.action,
    details: log.details,
    performance: log.performance
  })
}
```

### 4. 测试策略

**单元测试示例：**
```typescript
import { describe, it, expect } from 'vitest'

describe('ModelScope to MCP Transform', () => {
  it('should transform complete server data correctly', () => {
    const modelScopeServer: ModelScopeServer = {
      id: 'test-server',
      name: 'Test Server',
      chinese_name: '测试服务器',
      description: '测试用服务器',
      operational_urls: [{ url: 'https://example.com/sse' }],
      tags: ['测试', '示例']
    }

    const result = transformModelScopeServerToMCP(modelScopeServer)
    
    expect(result).toEqual({
      id: '@modelscope/test-server',
      name: '测试服务器',
      description: '测试用服务器',
      type: 'sse',
      baseUrl: 'https://example.com/sse',
      isActive: true,
      provider: 'ModelScope',
      tags: ['测试', '示例']
    })
  })

  it('should handle missing optional fields gracefully', () => {
    const minimalServer: ModelScopeServer = {
      id: 'minimal-server',
      name: 'Minimal Server',
      operational_urls: [{ url: 'https://example.com/sse' }]
    }

    const result = transformModelScopeServerToMCP(minimalServer)
    
    expect(result?.id).toBe('@modelscope/minimal-server')
    expect(result?.name).toBe('Minimal Server')
    expect(result?.description).toBe('')
    expect(result?.tags).toEqual([])
  })
})
```

## 故障排除

### 常见问题及解决方案

**1. API 认证失败**
```
错误：401 Unauthorized
原因：访问令牌无效或已过期
解决：重新获取有效的 ModelScope 访问令牌
```

**2. 服务器数据格式错误**
```
错误：transformModelScopeServerToMCP 返回 null
原因：服务器缺少必需的 operational_urls
解决：检查 ModelScope API 响应数据完整性
```

**3. URL 格式无效**
```
错误：Invalid URL format
原因：operational_urls 中包含无效的 URL
解决：添加 URL 格式验证和错误处理
```

**4. 批量转换性能问题**
```
问题：大量服务器转换导致界面卡顿
解决：使用 Web Worker 或分批处理
```

### 调试工具

**开启详细日志：**
```typescript
// 在浏览器控制台中启用调试
localStorage.setItem('debug', 'modelscope:*')

// 或者设置特定的日志级别
localStorage.setItem('modelscope_log_level', 'debug')
```

**性能监控：**
```typescript
function performanceMonitor<T>(
  operation: () => Promise<T>,
  operationName: string
): Promise<T> {
  const start = performance.now()
  
  return operation().finally(() => {
    const duration = performance.now() - start
    console.log(`[Performance] ${operationName}: ${duration.toFixed(2)}ms`)
  })
}
```

## 版本兼容性

### API 版本支持

| ModelScope API 版本 | 支持状态 | 说明 |
|-------------------|----------|------|
| v1.0 | ✅ 完全支持 | 当前使用版本 |
| v1.1 | ⚠️ 部分支持 | 新增字段向后兼容 |
| v2.0 | 🚧 开发中 | 计划支持 |

### 数据格式演进

```typescript
// v1.0 格式处理
function handleV1Format(server: any): MCPServer | null {
  return transformModelScopeServerToMCP(server)
}

// v1.1 格式处理（向后兼容）
function handleV1_1Format(server: any): MCPServer | null {
  // 处理新增的字段
  const baseTransform = transformModelScopeServerToMCP(server)
  if (!baseTransform) return null
  
  // 添加 v1.1 特有字段
  if (server.categories) {
    baseTransform.tags = [...(baseTransform.tags || []), ...server.categories]
  }
  
  return baseTransform
}
```

## 结论

CherryStudio 对 ModelScope MCP 服务的集成采用了完善的数据转换机制，确保了：

1. **数据完整性**：完整保留 ModelScope 服务的所有重要信息
2. **格式标准化**：统一转换为 MCP 标准格式
3. **错误处理**：完善的验证和错误处理机制  
4. **性能优化**：高效的批量处理和缓存策略
5. **可维护性**：清晰的代码结构和完整的测试覆盖

这种设计使得用户可以无缝使用 ModelScope 平台上丰富的 MCP 服务，同时保持与其他 MCP 服务提供商的一致体验。
