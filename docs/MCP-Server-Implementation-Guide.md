# Cherry Studio MCP服务器实现指南

## 概述

Cherry Studio实现了完整的Model Context Protocol (MCP)服务器集成，支持多种传输协议和连接方式。本文档详细说明了MCP服务器的实现架构、配置参数、调用方法以及最佳实践。

## 目录

- [架构概览](#架构概览)
- [支持的传输方式](#支持的传输方式)
- [连接配置](#连接配置)
- [API调用方法](#api调用方法)
- [错误处理与重连机制](#错误处理与重连机制)
- [最佳实践](#最佳实践)
- [故障排除](#故障排除)

## 架构概览

### 核心组件

```typescript
// 主要文件结构
src/
├── main/
│   └── services/
│       ├── MCPService.ts          // MCP服务核心实现
│       ├── DxtService.ts          // DXT包管理服务
│       └── mcp/
│           ├── oauth/             // OAuth认证实现
│           └── shell-env.ts       // 环境变量管理
├── renderer/
│   └── src/
│       ├── utils/
│       │   └── mcp-tools.ts       // MCP工具转换实用函数
│       └── store/
│           └── mcp.ts             // MCP状态管理
└── packages/
    └── mcp-trace/                 // MCP追踪和监控
```

### 服务架构

```typescript
class McpService {
  private clients: Map<string, Client> = new Map()           // 客户端缓存
  private pendingClients: Map<string, Promise<Client>>       // 等待连接的客户端
  private activeToolCalls: Map<string, AbortController>      // 活动工具调用管理
  private dxtService = new DxtService()                      // DXT包服务
}
```

## 支持的传输方式

### 1. SSE (Server-Sent Events) 传输

**适用场景**: Web服务、实时数据流、长连接需求

```typescript
// SSE连接配置
interface SSEServerConfig {
  type: 'sse'
  baseUrl: string                    // SSE端点URL
  headers?: Record<string, string>   // 自定义请求头
  timeout?: number                   // 超时时间(秒)
  longRunning?: boolean              // 是否为长时间运行的服务
}

// 示例配置
const sseServer: MCPServer = {
  id: 'sse-server-1',
  name: 'My SSE Server',
  type: 'sse',
  baseUrl: 'https://api.example.com/mcp/sse',
  headers: {
    'X-API-Key': 'your-api-key',
    'Content-Type': 'text/event-stream'
  },
  timeout: 30,
  longRunning: false
}
```

**内部实现**:
```typescript
const options: SSEClientTransportOptions = {
  eventSourceInit: {
    fetch: async (url, init) => {
      const headers = { ...(server.headers || {}), ...(init?.headers || {}) }
      
      // OAuth token自动注入
      if (authProvider && typeof authProvider.tokens === 'function') {
        try {
          const tokens = await authProvider.tokens()
          if (tokens && tokens.access_token) {
            headers['Authorization'] = `Bearer ${tokens.access_token}`
          }
        } catch (error) {
          logger.error('Failed to fetch tokens:', error)
        }
      }
      
      return net.fetch(url.toString(), { ...init, headers })
    }
  },
  requestInit: { headers: server.headers || {} },
  authProvider
}
```

### 2. StreamableHTTP 传输

**适用场景**: RESTful API、HTTP/HTTPS服务、需要双向通信的场景

```typescript
// StreamableHTTP连接配置
interface StreamableHTTPServerConfig {
  type: 'streamableHttp'
  baseUrl: string                    // HTTP端点URL
  headers?: Record<string, string>   // 自定义请求头
  timeout?: number                   // 超时时间(秒)
  longRunning?: boolean              // 是否为长时间运行的服务
}

// 示例配置
const httpServer: MCPServer = {
  id: 'http-server-1',
  name: 'My HTTP Server',
  type: 'streamableHttp',
  baseUrl: 'https://api.example.com/mcp',
  headers: {
    'Authorization': 'Bearer token123',
    'User-Agent': 'Cherry Studio/1.0'
  },
  timeout: 60,
  longRunning: true
}
```

**内部实现**:
```typescript
const options: StreamableHTTPClientTransportOptions = {
  requestInit: {
    headers: server.headers || {}
  },
  authProvider
}
const transport = new StreamableHTTPClientTransport(new URL(server.baseUrl), options)
```

### 3. Stdio 传输

**适用场景**: 本地进程、命令行工具、子进程通信

```typescript
// Stdio连接配置
interface StdioServerConfig {
  command: string                    // 执行命令
  args?: string[]                    // 命令参数
  env?: Record<string, string>       // 环境变量
  timeout?: number                   // 超时时间(秒)
  longRunning?: boolean              // 是否为长时间运行的进程
  registryUrl?: string               // NPM/PyPI镜像源
}

// 示例配置
const stdioServer: MCPServer = {
  id: 'stdio-server-1',
  name: 'My Local Tool',
  command: 'npx',
  args: ['@my-org/mcp-server'],
  env: {
    'DEBUG': '1',
    'API_KEY': 'secret-key'
  },
  timeout: 120,
  longRunning: true,
  registryUrl: 'https://registry.npmmirror.com'
}
```

**支持的命令类型**:
- `npx`: 自动使用bun运行，支持NPM镜像源
- `uvx`/`uv`: Python包管理器，支持PyPI镜像源  
- 其他可执行文件: 直接执行

### 4. InMemory 传输

**适用场景**: 内置服务、测试环境、无需外部进程的场景

```typescript
// InMemory连接配置
interface InMemoryServerConfig {
  type: 'inMemory'
  name: string                       // 内存服务器名称
  args?: string[]                    // 初始化参数
  env?: Record<string, string>       // 环境变量
}

// 示例配置
const memoryServer: MCPServer = {
  id: 'memory-server-1',
  name: 'memory-service',
  type: 'inMemory',
  args: ['--mode=development'],
  env: {
    'LOG_LEVEL': 'debug'
  }
}
```

## 连接配置

### MCPServer完整配置接口

```typescript
interface MCPServer {
  id: string                         // 唯一标识符
  name: string                       // 服务器名称
  type?: 'sse' | 'streamableHttp' | 'inMemory'  // 传输类型
  
  // HTTP/SSE 配置
  baseUrl?: string                   // 服务器URL
  headers?: Record<string, string>   // HTTP请求头
  
  // Stdio 配置
  command?: string                   // 执行命令
  args?: string[]                    // 命令参数
  env?: Record<string, string>       // 环境变量
  
  // 通用配置
  timeout?: number                   // 超时时间(秒)，默认60秒
  longRunning?: boolean              // 是否长时间运行，影响超时策略
  registryUrl?: string               // 包管理器镜像源
  
  // DXT 配置
  dxtPath?: string                   // DXT包解压路径
  
  // 内部状态
  disabled?: boolean                 // 是否禁用
  error?: string                     // 错误信息
}
```

### OAuth认证配置

```typescript
// OAuth提供者配置
class McpOAuthClientProvider {
  config = {
    callbackPort: 3000,              // 回调端口
    callbackPath: '/oauth/callback', // 回调路径
    timeout: 300000                  // 5分钟超时
  }
  
  async tokens(): Promise<{
    access_token: string
    refresh_token?: string
    expires_in?: number
  }> {
    // 返回当前有效的token
  }
}
```

## API调用方法

### 初始化和连接管理

```typescript
// 初始化MCP客户端
async function initClient(server: MCPServer): Promise<Client> {
  const mcpService = new McpService()
  const client = await mcpService.initClient(server)
  return client
}

// 检查连接状态
async function checkConnectivity(server: MCPServer): Promise<boolean> {
  const isConnected = await window.api.checkMcpConnectivity(server)
  return isConnected
}

// 重启服务器
async function restartServer(server: MCPServer): Promise<void> {
  await window.api.restartMcpServer(server)
}

// 停止服务器
async function stopServer(server: MCPServer): Promise<void> {
  await window.api.stopMcpServer(server)
}
```

### 工具调用

```typescript
// 列出可用工具
async function listTools(server: MCPServer): Promise<MCPTool[]> {
  const tools = await window.api.listMcpTools(server)
  return tools
}

// 调用工具
async function callTool(
  server: MCPServer, 
  toolName: string, 
  args: any,
  callId?: string
): Promise<MCPCallToolResponse> {
  const response = await window.api.callMcpTool({
    server,
    name: toolName,
    args,
    callId
  })
  return response
}

// 中断工具调用
async function abortTool(callId: string): Promise<boolean> {
  const result = await window.api.abortMcpTool(callId)
  return result
}
```

### 资源管理

```typescript
// 列出资源
async function listResources(server: MCPServer): Promise<MCPResource[]> {
  const resources = await window.api.listMcpResources(server)
  return resources
}

// 获取资源内容
async function getResource(
  server: MCPServer, 
  uri: string
): Promise<GetResourceResponse> {
  const resource = await window.api.getMcpResource({ server, uri })
  return resource
}
```

### 提示模板

```typescript
// 列出提示模板
async function listPrompts(server: MCPServer): Promise<MCPPrompt[]> {
  const prompts = await window.api.listMcpPrompts(server)
  return prompts
}

// 获取提示内容
async function getPrompt(
  server: MCPServer,
  name: string,
  args?: Record<string, any>
): Promise<GetPromptResult> {
  const prompt = await window.api.getMcpPrompt({ server, name, args })
  return prompt
}
```

## 错误处理与重连机制

### 连接健康检查

```typescript
// 自动ping检查
private async healthCheck(client: Client, server: MCPServer): Promise<boolean> {
  try {
    const pingResult = await client.ping()
    if (!pingResult) {
      // 连接失效，清理缓存
      this.clients.delete(this.getServerKey(server))
      return false
    }
    return true
  } catch (error) {
    logger.error(`Health check failed for ${server.name}:`, error)
    return false
  }
}
```

### OAuth自动重连

```typescript
// OAuth认证失败自动处理
try {
  await client.connect(transport)
} catch (error) {
  if (error.name === 'UnauthorizedError' || error.message.includes('Unauthorized')) {
    logger.debug(`Authentication required for server: ${server.name}`)
    await this.handleAuth(client, transport)
  } else {
    throw error
  }
}
```

### 工具调用超时管理

```typescript
// 可配置的超时策略
const callOptions = {
  timeout: server.timeout ? server.timeout * 1000 : 60000,           // 基础超时
  resetTimeoutOnProgress: server.longRunning,                        // 进度重置超时
  maxTotalTimeout: server.longRunning ? 10 * 60 * 1000 : undefined, // 最大总超时
  signal: abortController.signal                                      // 手动中断信号
}
```

### 缓存管理

```typescript
// 分层缓存策略
const cacheKeys = {
  tools: `mcp:list_tool:${serverKey}`,           // 5分钟TTL
  prompts: `mcp:list_prompts:${serverKey}`,      // 60分钟TTL  
  resources: `mcp:list_resources:${serverKey}`,  // 60分钟TTL
  resource: `mcp:get_resource:${serverKey}:${uri}`, // 30分钟TTL
  prompt: `mcp:get_prompt:${serverKey}:${name}:${argsKey}` // 30分钟TTL
}
```

## 最佳实践

### 1. 服务器配置

```typescript
// 推荐的生产环境配置
const productionServer: MCPServer = {
  id: 'prod-api-server',
  name: 'Production API Server',
  type: 'streamableHttp',
  baseUrl: 'https://api.production.com/mcp',
  headers: {
    'Authorization': 'Bearer ${PROD_API_TOKEN}',
    'X-Client-Version': '1.0.0',
    'Accept': 'application/json'
  },
  timeout: 30,                       // 30秒基础超时
  longRunning: false                 // 非长运行任务
}

// 长时间运行的本地服务
const longRunningServer: MCPServer = {
  id: 'data-processor',
  name: 'Data Processing Service',
  command: 'python',
  args: ['-m', 'my_mcp_server'],
  env: {
    'PYTHONPATH': '/path/to/modules',
    'LOG_LEVEL': 'INFO'
  },
  timeout: 300,                      // 5分钟基础超时
  longRunning: true                  // 启用进度重置超时
}
```

### 2. 错误处理模式

```typescript
// 统一错误处理
async function safeMcpCall<T>(
  operation: () => Promise<T>,
  fallback?: T,
  retries: number = 3
): Promise<T> {
  for (let i = 0; i < retries; i++) {
    try {
      return await operation()
    } catch (error) {
      logger.warn(`MCP operation failed (attempt ${i + 1}/${retries}):`, error)
      
      if (i === retries - 1) {
        if (fallback !== undefined) {
          return fallback
        }
        throw error
      }
      
      // 指数退避
      await new Promise(resolve => setTimeout(resolve, Math.pow(2, i) * 1000))
    }
  }
  throw new Error('All retries exhausted')
}
```

### 3. 性能优化

```typescript
// 批量工具调用
async function batchToolCalls(
  server: MCPServer,
  calls: Array<{ name: string; args: any }>
): Promise<MCPCallToolResponse[]> {
  const results = await Promise.allSettled(
    calls.map(call => window.api.callMcpTool({ server, ...call }))
  )
  
  return results.map((result, index) => {
    if (result.status === 'fulfilled') {
      return result.value
    } else {
      logger.error(`Tool call ${calls[index].name} failed:`, result.reason)
      throw result.reason
    }
  })
}
```

### 4. 监控和日志

```typescript
// MCP操作追踪
import { withSpanFunc } from '@mcp-trace/trace-core'

async function trackedToolCall(server: MCPServer, name: string, args: any) {
  return await withSpanFunc(
    `${server.name}.${name}`,
    'MCP',
    async () => {
      return await window.api.callMcpTool({ server, name, args })
    },
    [{ server, name, args }]
  )
}
```

## 故障排除

### 常见问题及解决方案

**1. 连接超时**
```bash
# 症状: Connection timeout after 60 seconds
# 解决: 增加timeout配置或启用longRunning模式
{
  "timeout": 120,
  "longRunning": true
}
```

**2. OAuth认证失败**
```bash
# 症状: UnauthorizedError或401响应
# 解决: 检查token有效性，确保OAuth流程正常
# 日志位置: Cherry Studio > 设置 > 开发者 > 日志
```

**3. NPX/UV包安装失败**
```bash
# 症状: Package installation failed
# 解决: 配置镜像源
{
  "command": "npx",
  "registryUrl": "https://registry.npmmirror.com"
}
```

**4. 工具调用参数错误**
```bash
# 症状: Invalid arguments for tool
# 解决: 检查inputSchema，使用正确的参数格式
const args = {
  "param1": "value1",
  "param2": 123
}
```

### 调试技巧

**1. 启用详细日志**
```typescript
// 在开发者工具中设置
localStorage.setItem('debug', 'mcp:*')
```

**2. 检查服务器状态**
```typescript
// 获取所有MCP服务器状态
const servers = store.getState().mcp.servers
console.log('MCP Servers:', servers)
```

**3. 手动测试连接**
```typescript
// 控制台中测试特定服务器
const server = { /* 你的服务器配置 */ }
const isConnected = await window.api.checkMcpConnectivity(server)
console.log('Connection status:', isConnected)
```

## 相关文档

- [MCP官方规范](https://modelcontextprotocol.io/)
- [Cherry Studio用户指南](../README.zh.md)
- [开发者贡献指南](../CONTRIBUTING.zh.md)
- [API参考文档](./api-reference.md)

---

*最后更新: 2025-08-27*
