import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../theme/app_theme.dart';
import 'modern_button.dart';
import 'modern_chat_bubble.dart';
import 'modern_persona_card.dart';
import 'modern_knowledge_card.dart';
import 'modern_settings_widgets.dart';
import 'animated_card.dart';
import 'loading_animations.dart';

/// UI组件展示页面
class UIShowcasePage extends StatefulWidget {
  const UIShowcasePage({super.key});

  @override
  State<UIShowcasePage> createState() => _UIShowcasePageState();
}

class _UIShowcasePageState extends State<UIShowcasePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _switchValue = false;
  double _sliderValue = 0.5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI组件展示'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '按钮'),
            Tab(text: '卡片'),
            Tab(text: '聊天'),
            Tab(text: '设置'),
            Tab(text: '动画'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildButtonsTab(),
          _buildCardsTab(),
          _buildChatTab(),
          _buildSettingsTab(),
          _buildAnimationsTab(),
        ],
      ),
    );
  }

  Widget _buildButtonsTab() {
    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            const Text(
              '现代化按钮',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // 主要按钮
            ModernButton(
              text: '主要按钮',
              icon: Icons.star,
              onPressed: () {},
              style: ModernButtonStyle.primary,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // 次要按钮
            ModernButton(
              text: '次要按钮',
              icon: Icons.favorite,
              onPressed: () {},
              style: ModernButtonStyle.secondary,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // 轮廓按钮
            ModernButton(
              text: '轮廓按钮',
              icon: Icons.edit,
              onPressed: () {},
              style: ModernButtonStyle.outline,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // 幽灵按钮
            ModernButton(
              text: '幽灵按钮',
              icon: Icons.visibility,
              onPressed: () {},
              style: ModernButtonStyle.ghost,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // 危险按钮
            ModernButton(
              text: '危险按钮',
              icon: Icons.delete,
              onPressed: () {},
              style: ModernButtonStyle.danger,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // 加载按钮
            ModernButton(text: '加载中...', isLoading: true, onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsTab() {
    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            const Text(
              '现代化卡片',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // 动画卡片
            AnimatedCard(
              onTap: () {},
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '动画卡片',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text('这是一个带有悬停和点击动画效果的卡片'),
                ],
              ),
            ),

            // 渐变卡片
            GradientCard(
              gradient: AppTheme.primaryGradient,
              onTap: () {},
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '渐变卡片',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingS),
                  Text(
                    '这是一个带有渐变背景的卡片',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // 智能体卡片
            ModernPersonaCard(
              name: 'AI助手',
              description: '这是一个智能的AI助手，可以帮助您完成各种任务。',
              tags: const ['智能', '助手', '高效'],
              usageCount: 42,
              lastUsed: DateTime.now().subtract(const Duration(hours: 2)),
              onTap: () {},
              onEdit: () {},
              onDelete: () {},
            ),

            // 知识库卡片
            ModernKnowledgeCard(
              title: '用户手册.pdf',
              fileType: 'pdf',
              fileSize: 2048576,
              status: 'completed',
              uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
              onTap: () {},
              onDelete: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return AnimationLimiter(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  const Text(
                    '聊天界面',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // 用户消息
                  ModernChatBubble(
                    message: '你好，我想了解一下AI助手的功能。',
                    isFromUser: true,
                    timestamp: DateTime.now().subtract(
                      const Duration(minutes: 5),
                    ),
                  ),

                  // AI回复
                  ModernChatBubble(
                    message:
                        '您好！我是您的AI助手，我可以帮助您：\n\n1. 回答各种问题\n2. 协助完成任务\n3. 提供专业建议\n4. 进行创意写作\n\n有什么我可以帮助您的吗？',
                    isFromUser: false,
                    timestamp: DateTime.now().subtract(
                      const Duration(minutes: 4),
                    ),
                  ),

                  // 系统消息
                  const SystemMessageBubble(message: '对话已开始', icon: Icons.chat),

                  // 正在输入
                  ModernChatBubble(
                    message: '',
                    isFromUser: false,
                    timestamp: DateTime.now(),
                    isTyping: true,
                  ),
                ],
              ),
            ),
          ),

          // 聊天输入框
          ModernChatInput(
            controller: TextEditingController(),
            onSend: () {},
            onVoicePressed: () {},
            hintText: '输入您的消息...',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return AnimationLimiter(
      child: ListView(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(AppTheme.spacingM),
              child: Text(
                '设置界面',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            ModernSettingsGroup(
              title: '基本设置',
              subtitle: '应用的基本配置选项',
              children: [
                ModernSwitchSettingsItem(
                  title: '启用通知',
                  subtitle: '接收应用通知和提醒',
                  leading: const Icon(Icons.notifications),
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),

                ModernSliderSettingsItem(
                  title: '音量',
                  subtitle: '调整应用音量大小',
                  leading: const Icon(Icons.volume_up),
                  value: _sliderValue,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  valueFormatter: (value) => '${(value * 100).toInt()}%',
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),

                ModernSettingsItem(
                  title: '关于应用',
                  subtitle: '查看应用信息和版本',
                  leading: const Icon(Icons.info),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationsTab() {
    return AnimationLimiter(
      child: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            const Text(
              '加载动画',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // 脉冲动画
            const Row(
              children: [
                PulseLoadingAnimation(),
                SizedBox(width: AppTheme.spacingM),
                Text('脉冲动画'),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),

            // 波浪动画
            const Row(
              children: [
                WaveLoadingAnimation(),
                SizedBox(width: AppTheme.spacingM),
                Text('波浪动画'),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),

            // 旋转动画
            const Row(
              children: [
                SpinLoadingAnimation(),
                SizedBox(width: AppTheme.spacingM),
                Text('旋转动画'),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),

            // 打字机动画
            TypingAnimation(
              text: '这是一个打字机效果的动画文本！',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
