import '../../domain/entities/help_section.dart';

/// 帮助数据 - 参考B站和腾讯云的帮助界面设计
class HelpData {
  static final List<HelpSection> sections = [
    // 快速入门
    HelpSection(
      id: 'quick_start',
      title: '快速入门',
      icon: 'rocket_launch',
      description: '新手必看，快速上手Campus Copilot',
      order: 1,
      tags: ['新手', '入门', '快速'],
      items: [
        HelpItem(
          id: 'qs_01',
          title: '欢迎使用Campus Copilot',
          content: '''Campus Copilot是一款功能强大的校园AI助手应用，集成了聊天、知识库、学习模式、日常管理等多种功能，帮助您提升学习和工作效率。

主要功能包括：
• AI智能对话 - 支持多种AI模型
• 知识库管理 - 文档上传、向量搜索
• 学习模式 - 苏格拉底式教学
• 日常管理 - 课程表、任务计划
• 个性化设置 - 主题、语言等自定义选项''',
          type: HelpItemType.quickStart,
          tags: ['介绍', '功能概览'],
          isFrequentlyUsed: true,
          viewCount: 1520,
        ),
        HelpItem(
          id: 'qs_02',
          title: '首次使用设置',
          content: '''首次启动Campus Copilot时，请按以下步骤进行基础配置：''',
          type: HelpItemType.quickStart,
          tags: ['设置', '配置'],
          isFrequentlyUsed: true,
          viewCount: 890,
          steps: [
            HelpStep(
              step: 1,
              title: '选择AI模型',
              description: '进入设置 > 模型设置，选择并配置您要使用的AI模型',
              tips: ['推荐先配置OpenAI或国产模型如通义千问'],
            ),
            HelpStep(
              step: 2,
              title: '外观设置',
              description: '在设置 > 外观设置中选择适合的主题和语言',
              tips: ['支持亮色/暗色主题切换'],
            ),
            HelpStep(
              step: 3,
              title: '开始对话',
              description: '返回聊天界面，开始与AI助手对话',
              tips: ['可以尝试问一些简单问题来测试配置'],
            ),
          ],
        ),
        HelpItem(
          id: 'qs_03',
          title: '界面导航说明',
          content: '''Campus Copilot采用侧边栏导航设计，主要包含三个标签页：''',
          type: HelpItemType.quickStart,
          tags: ['界面', '导航'],
          viewCount: 650,
          steps: [
            HelpStep(
              step: 1,
              title: 'Assistants 助手',
              description: '管理AI助手和人格设定，创建专业化的对话助手',
            ),
            HelpStep(
              step: 2,
              title: 'Topics 话题',
              description: '查看和管理聊天话题，支持话题分类和搜索',
            ),
            HelpStep(
              step: 3,
              title: 'Settings 设置',
              description: '包含模型参数、代码块设置、常规设置等配置选项',
            ),
          ],
        ),
      ],
    ),

    // AI对话功能
    HelpSection(
      id: 'ai_chat',
      title: 'AI对话功能',
      icon: 'chat',
      description: '了解如何使用AI对话功能',
      order: 2,
      tags: ['对话', 'AI', '聊天'],
      items: [
        HelpItem(
          id: 'ac_01',
          title: '如何开始对话',
          content: '''在聊天界面中，您可以通过多种方式与AI助手开始对话：''',
          type: HelpItemType.guide,
          tags: ['对话', '聊天'],
          isFrequentlyUsed: true,
          viewCount: 1200,
          steps: [
            HelpStep(
              step: 1,
              title: '文本输入',
              description: '在底部输入框中直接输入问题或请求',
              tips: ['支持多行文本输入', '可使用Shift+Enter换行'],
            ),
            HelpStep(
              step: 2,
              title: '选择模型',
              description: '点击发送按钮旁的模型选择器，选择合适的AI模型',
              tips: ['不同模型有不同特点，建议根据任务选择'],
            ),
            HelpStep(
              step: 3,
              title: '发送消息',
              description: '输入完成后点击发送按钮或按Enter键',
            ),
          ],
        ),
        HelpItem(
          id: 'ac_02',
          title: '模型参数设置',
          content: '''您可以在侧边栏设置中调整模型参数以获得更好的对话效果：

• **温度(Temperature)**: 控制回答的创造性，值越高越有创意
• **上下文窗口**: 控制AI记忆的历史消息数量
• **最大Token数**: 限制AI回答的长度
• **思考强度**: 适用于o1等推理模型，控制思考深度''',
          type: HelpItemType.guide,
          tags: ['参数', '设置', '优化'],
          viewCount: 750,
        ),
        HelpItem(
          id: 'ac_03',
          title: 'AI搜索功能',
          content: '''AI搜索功能可以让助手在回答问题时自动联网搜索最新信息：

启用方法：
1. 进入设置 > AI搜索设置
2. 选择搜索服务商（如Google、Bing等）
3. 配置相应的API密钥
4. 在对话中开启"AI搜索"按钮

使用时，AI会自动判断是否需要联网搜索，并将搜索结果整合到回答中。''',
          type: HelpItemType.feature,
          tags: ['搜索', '联网', 'API'],
          viewCount: 420,
        ),
      ],
    ),

    // 知识库管理
    HelpSection(
      id: 'knowledge_base',
      title: '知识库管理',
      icon: 'folder',
      description: '文档管理与向量搜索功能',
      order: 3,
      tags: ['知识库', '文档', '向量搜索'],
      items: [
        HelpItem(
          id: 'kb_01',
          title: '创建知识库',
          content: '''知识库功能可以帮您管理和搜索文档内容：''',
          type: HelpItemType.guide,
          tags: ['创建', '管理'],
          isFrequentlyUsed: true,
          viewCount: 680,
          steps: [
            HelpStep(
              step: 1,
              title: '进入知识库页面',
              description: '点击主导航中的"知识库"或在设置中点击"知识库"',
            ),
            HelpStep(
              step: 2,
              title: '创建新知识库',
              description: '点击"创建知识库"按钮，输入名称和描述',
              tips: ['建议按主题或项目分类创建不同的知识库'],
            ),
            HelpStep(
              step: 3,
              title: '上传文档',
              description: '在知识库中上传PDF、Word、文本等文档',
              tips: ['支持多种文档格式', '大文件会自动分块处理'],
            ),
          ],
        ),
        HelpItem(
          id: 'kb_02',
          title: '文档搜索',
          content: '''上传文档后，您可以使用向量搜索功能快速查找相关内容：

• **语义搜索**: 根据内容含义搜索，而非仅匹配关键词
• **相似度评分**: 搜索结果会显示相关度评分
• **上下文预览**: 显示匹配内容的上下文
• **多知识库搜索**: 可以跨多个知识库进行搜索''',
          type: HelpItemType.feature,
          tags: ['搜索', '向量', '语义'],
          viewCount: 520,
        ),
        HelpItem(
          id: 'kb_03',
          title: 'RAG增强对话',
          content: '''知识库可以与AI对话结合，实现RAG（检索增强生成）：

使用方法：
1. 确保已创建知识库并上传相关文档
2. 在对话中提问时，AI会自动搜索知识库
3. AI会基于搜索到的内容生成更准确的回答

适用场景：
• 专业文档问答
• 学习资料查询
• 企业知识管理
• 技术文档搜索''',
          type: HelpItemType.feature,
          tags: ['RAG', '增强', '对话'],
          viewCount: 380,
        ),
      ],
    ),

    // 学习模式
    HelpSection(
      id: 'learning_mode',
      title: '学习模式',
      icon: 'school',
      description: '苏格拉底式教学与个性化学习',
      order: 4,
      tags: ['学习', '教学', '苏格拉底'],
      items: [
        HelpItem(
          id: 'lm_01',
          title: '启用学习模式',
          content: '''学习模式采用苏格拉底式教学方法，通过引导性问答帮助您深入理解知识：''',
          type: HelpItemType.guide,
          tags: ['启用', '设置'],
          isFrequentlyUsed: true,
          viewCount: 450,
          steps: [
            HelpStep(
              step: 1,
              title: '进入学习模式设置',
              description: '在设置页面中找到"学习模式"选项',
            ),
            HelpStep(
              step: 2,
              title: '选择学科领域',
              description: '根据您的学习需求选择相应的学科',
              tips: ['支持数学、物理、编程等多个学科'],
            ),
            HelpStep(
              step: 3,
              title: '调整难度等级',
              description: '设置适合的学习难度和引导程度',
            ),
          ],
        ),
        HelpItem(
          id: 'lm_02',
          title: '苏格拉底式对话',
          content: '''苏格拉底式教学的核心是通过问答引导学习者自主发现答案：

特点：
• **启发式提问**: AI不直接给出答案，而是提出引导性问题
• **分步骤引导**: 将复杂问题分解为易理解的小步骤
• **鼓励思考**: 促进主动思考而非被动接受
• **个性化调节**: 根据理解程度调整引导强度

示例：
学生问："如何求导数？"
AI会引导："你知道导数的定义吗？让我们从极限的概念开始..."''',
          type: HelpItemType.feature,
          tags: ['苏格拉底', '引导', '教学'],
          viewCount: 320,
        ),
      ],
    ),

    // 日常管理
    HelpSection(
      id: 'daily_management',
      title: '日常管理',
      icon: 'calendar_today',
      description: '课程表与任务计划管理',
      order: 5,
      tags: ['日常', '管理', '课程表'],
      items: [
        HelpItem(
          id: 'dm_01',
          title: '课程表管理',
          content: '''日常管理功能可以帮您管理课程表和学习计划：''',
          type: HelpItemType.guide,
          tags: ['课程表', '管理'],
          viewCount: 280,
          steps: [
            HelpStep(
              step: 1,
              title: '添加课程',
              description: '在日常管理页面中添加课程信息',
              tips: ['支持导入教务系统课程表'],
            ),
            HelpStep(
              step: 2,
              title: '设置提醒',
              description: '为课程和任务设置提醒通知',
            ),
            HelpStep(
              step: 3,
              title: '查看日程',
              description: '在日历视图中查看每日安排',
            ),
          ],
        ),
        HelpItem(
          id: 'dm_02',
          title: '任务计划',
          content: '''创建和管理学习任务，制定合理的学习计划：

功能特点：
• **任务分类**: 按科目或优先级分类管理
• **进度跟踪**: 实时显示任务完成进度
• **智能提醒**: 根据deadline智能安排提醒
• **数据统计**: 分析学习效率和时间分配''',
          type: HelpItemType.feature,
          tags: ['任务', '计划', '提醒'],
          viewCount: 180,
        ),
      ],
    ),

    // 常见问题
    HelpSection(
      id: 'faq',
      title: '常见问题',
      icon: 'help_outline',
      description: '常见问题解答和故障排除',
      order: 6,
      tags: ['问题', 'FAQ', '故障'],
      items: [
        HelpItem(
          id: 'faq_01',
          title: 'AI模型无法连接怎么办？',
          content: '''如果AI模型无法连接，请按以下步骤排查：

1. **检查网络连接**: 确保设备已连接互联网
2. **验证API密钥**: 检查API密钥是否正确且有效
3. **检查服务状态**: 确认AI服务商的服务是否正常
4. **重启应用**: 尝试重启应用后再次连接
5. **更换模型**: 临时切换到其他可用模型

如果问题持续存在，请查看错误日志或联系技术支持。''',
          type: HelpItemType.troubleshooting,
          tags: ['连接', '错误', 'API'],
          isFrequentlyUsed: true,
          viewCount: 920,
        ),
        HelpItem(
          id: 'faq_02',
          title: '文档上传失败如何解决？',
          content: '''文档上传失败的常见原因和解决方法：

**文件格式不支持**:
• 确保文件格式为PDF、DOC、DOCX、TXT等支持的格式

**文件过大**:
• 单个文件建议不超过100MB
• 可以将大文件分割后分别上传

**网络问题**:
• 检查网络连接稳定性
• 在网络条件好的环境下重试

**存储空间不足**:
• 清理不需要的文档释放空间
• 升级存储配额（如适用）''',
          type: HelpItemType.troubleshooting,
          tags: ['上传', '文档', '失败'],
          isFrequentlyUsed: true,
          viewCount: 650,
        ),
        HelpItem(
          id: 'faq_03',
          title: '如何提升AI回答质量？',
          content: '''以下方法可以帮您获得更好的AI回答：

**优化问题描述**:
• 提供清晰、具体的问题描述
• 包含必要的背景信息和上下文
• 使用准确的专业术语

**调整模型参数**:
• 根据任务类型调整温度参数
• 对于创意任务，提高温度值
• 对于事实查询，降低温度值

**选择合适模型**:
• 代码相关问题选择代码优化模型
• 创意写作选择文本生成模型
• 数学问题选择逻辑推理强的模型

**使用知识库**:
• 上传相关资料到知识库
• 启用RAG功能获得更准确的专业回答''',
          type: HelpItemType.faq,
          tags: ['质量', '优化', '技巧'],
          isFrequentlyUsed: true,
          viewCount: 1100,
        ),
        HelpItem(
          id: 'faq_04',
          title: '数据安全和隐私保护',
          content: '''Campus Copilot对用户数据安全和隐私保护的承诺：

**本地数据存储**:
• 聊天记录和文档主要存储在本地设备
• 知识库向量数据本地化处理
• 敏感信息不会上传到云端

**API调用安全**:
• AI模型API调用采用加密传输
• 不存储用户的API密钥明文
• 支持多种安全的API提供商

**用户控制权**:
• 支持随时删除本地数据
• 可以选择性备份和恢复数据
• 提供数据导出功能

**隐私设置**:
• 可关闭数据收集和分析功能
• 支持匿名使用模式
• 遵循相关隐私法规要求''',
          type: HelpItemType.faq,
          tags: ['安全', '隐私', '数据'],
          viewCount: 480,
        ),
      ],
    ),

    // 云端开发环境
    HelpSection(
      id: 'cloud_development',
      title: '云端开发环境',
      icon: 'cloud',
      description: '云端IDE功能和开发环境配置',
      order: 7,
      tags: ['云端', '开发', 'IDE', '腾讯云'],
      items: [
        HelpItem(
          id: 'cd_01',
          title: '云端工作空间介绍',
          content: '''Campus Copilot集成了云端开发环境，为您提供稳定、高效的编程体验：

**主要特性**:
• 无需本地安装，随时随地编程
• 支持多种编程语言和框架
• 实时协作开发
• 自动保存和版本控制
• GPU加速支持

**适用场景**:
• 远程开发和学习
• 团队协作项目
• 临时开发环境测试
• 资源受限设备开发''',
          type: HelpItemType.feature,
          tags: ['云端', '工作空间', 'IDE'],
          viewCount: 180,
        ),
        HelpItem(
          id: 'cd_02',
          title: '工作空间配置',
          content: '''配置适合您的云端工作空间：''',
          type: HelpItemType.guide,
          tags: ['配置', '工作空间'],
          viewCount: 150,
          steps: [
            HelpStep(
              step: 1,
              title: '选择实例类型',
              description: '根据项目需求选择合适的计算资源配置',
              tips: ['基础版适合轻量开发', '专业版支持GPU加速'],
            ),
            HelpStep(
              step: 2,
              title: '配置开发环境',
              description: '选择编程语言、框架和工具包',
              tips: ['可以预装常用的开发工具'],
            ),
            HelpStep(
              step: 3,
              title: '设置网络和存储',
              description: '配置网络访问权限和存储空间',
              tips: ['支持SSH连接和文件同步'],
            ),
            HelpStep(
              step: 4,
              title: '启动工作空间',
              description: '启动云端环境并开始开发',
            ),
          ],
        ),
        HelpItem(
          id: 'cd_03',
          title: '代码导入和管理',
          content: '''在云端环境中高效管理您的代码：

**代码导入方式**:
• Git仓库克隆
• 本地文件上传
• 模板项目创建
• 云端同步

**版本管理**:
• 自动备份和快照
• Git集成支持
• 分支管理和合并
• 协作开发支持

**文件管理**:
• 云端文件浏览器
• 批量操作支持
• 实时同步更新
• 安全权限控制''',
          type: HelpItemType.guide,
          tags: ['代码', '导入', '版本管理'],
          viewCount: 130,
        ),
        HelpItem(
          id: 'cd_04',
          title: 'GPU开发环境',
          content: '''为AI和深度学习项目提供GPU加速支持：

**GPU配置**:
• NVIDIA GPU实例
• CUDA和cuDNN支持
• TensorFlow和PyTorch预装
• Jupyter Notebook集成

**使用场景**:
• 机器学习模型训练
• 深度学习研究
• 大数据处理
• 图像视频处理

**性能优化**:
• 自动资源分配
• 负载均衡调度
• 成本效益分析''',
          type: HelpItemType.feature,
          tags: ['GPU', 'AI', '深度学习'],
          viewCount: 95,
        ),
      ],
    ),

    // 开发者工具
    HelpSection(
      id: 'developer_tools',
      title: '开发者工具',
      icon: 'build',
      description: 'API、SDK和开发者资源',
      order: 8,
      tags: ['API', 'SDK', '开发者', '工具'],
      items: [
        HelpItem(
          id: 'dt_01',
          title: 'API接口使用',
          content: '''Campus Copilot提供丰富的API接口，支持第三方应用集成：

**核心API**:
• 聊天API - 文本对话和AI交互
• 知识库API - 文档管理和搜索
• 文件处理API - 文档上传和解析
• 用户管理API - 账户和权限管理

**认证方式**:
• API密钥认证
• OAuth 2.0授权
• JWT令牌验证
• IP白名单控制

**使用指南**:
• 查看API文档
• 获取测试密钥
• 示例代码下载
• 在线测试工具''',
          type: HelpItemType.guide,
          tags: ['API', '接口', '认证'],
          viewCount: 160,
        ),
        HelpItem(
          id: 'dt_02',
          title: 'SDK集成开发',
          content: '''使用SDK快速集成Campus Copilot功能到您的应用中：

**支持平台**:
• Web前端 (JavaScript/TypeScript)
• 移动端 (iOS/Android)
• 服务器端 (Python/Java/Node.js)
• 桌面应用 (Electron)

**核心功能**:
• AI对话集成
• 文件上传处理
• 实时消息推送
• 用户认证管理

**开发流程**:
1. 下载对应平台的SDK
2. 安装和配置依赖
3. 初始化SDK实例
4. 调用API接口
5. 处理响应和错误''',
          type: HelpItemType.guide,
          tags: ['SDK', '集成', '开发'],
          viewCount: 120,
        ),
        HelpItem(
          id: 'dt_03',
          title: 'DeepSeek模型集成',
          content: '''集成DeepSeek大语言模型，提升AI对话质量：

**模型特性**:
• 优秀的中文理解能力
• 强大的推理和分析能力
• 高效的代码生成能力
• 稳定的API服务

**集成步骤**:
1. 获取DeepSeek API密钥
2. 配置模型参数
3. 测试连接和调用
4. 优化提示词和参数

**最佳实践**:
• 选择合适的模型版本
• 优化上下文长度
• 控制温度参数
• 处理错误和重试''',
          type: HelpItemType.feature,
          tags: ['DeepSeek', '模型', '集成'],
          viewCount: 140,
        ),
        HelpItem(
          id: 'dt_04',
          title: '开发者社区',
          content: '''加入Campus Copilot开发者社区，获取帮助和资源：

**社区资源**:
• 开发者论坛
• 技术文档库
• 示例代码仓库
• 问题解答专区

**参与方式**:
• 提交功能建议
• 报告问题和bug
• 分享开发经验
• 贡献开源代码

**获取帮助**:
• 在线技术支持
• 开发者培训
• 合作伙伴计划
• 认证开发者计划''',
          type: HelpItemType.feature,
          tags: ['社区', '开发者', '支持'],
          viewCount: 85,
        ),
      ],
    ),

    // 高级功能
    HelpSection(
      id: 'advanced',
      title: '高级功能',
      icon: 'settings_applications',
      description: '高级设置和个性化功能',
      order: 9,
      tags: ['高级', '设置', '个性化'],
      items: [
        HelpItem(
          id: 'adv_01',
          title: '自定义AI助手人格',
          content: '''您可以创建专业化的AI助手人格以适应不同场景：''',
          type: HelpItemType.guide,
          tags: ['人格', '自定义'],
          viewCount: 340,
          steps: [
            HelpStep(
              step: 1,
              title: '进入助手管理',
              description: '在侧边栏Assistants标签中管理AI助手',
            ),
            HelpStep(
              step: 2,
              title: '创建新助手',
              description: '点击创建按钮，设置助手名称和描述',
              tips: ['可以创建专业领域的专家助手'],
            ),
            HelpStep(
              step: 3,
              title: '配置人格特征',
              description: '设置助手的专业领域、回答风格等特征',
            ),
          ],
        ),
        HelpItem(
          id: 'adv_02',
          title: '代码块功能增强',
          content: '''Campus Copilot提供强大的代码处理功能：

**代码编辑**:
• 直接在聊天中编辑代码块
• 支持语法高亮和自动补全
• 多种编程语言支持

**代码执行**:
• 支持部分编程语言的在线执行
• 提供代码运行结果反馈
• 安全的沙箱执行环境

**代码导出**:
• 一键复制代码到剪贴板
• 支持导出为文件
• 保持代码格式和注释''',
          type: HelpItemType.feature,
          tags: ['代码', '编辑', '执行'],
          viewCount: 290,
        ),
        HelpItem(
          id: 'adv_03',
          title: '主题和外观自定义',
          content: '''个性化您的Campus Copilot外观：

**主题选择**:
• 亮色主题 - 适合日间使用
• 暗色主题 - 适合夜间使用
• 自动切换 - 跟随系统设置

**界面自定义**:
• 调整字体大小和类型
• 设置聊天气泡样式
• 自定义颜色方案

**布局设置**:
• 侧边栏位置调整
• 消息密度控制
• 响应式布局适配''',
          type: HelpItemType.feature,
          tags: ['主题', '外观', '自定义'],
          viewCount: 220,
        ),
      ],
    ),
  ];
}
