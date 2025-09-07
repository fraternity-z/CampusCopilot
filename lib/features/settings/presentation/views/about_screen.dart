import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// 关于页面
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppInfoSection(context),
          const SizedBox(height: 16),
          _buildVersionSection(context),
          const SizedBox(height: 16),
          _buildSupportSection(context),
          const SizedBox(height: 16),
          _buildLegalSection(context),
        ],
      ),
    );
  }

  /// 应用信息区域
  Widget _buildAppInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/icons/app_icon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Campus Copilot',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '一个功能强大的校园助手应用',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: const Text('Flutter'),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                Chip(
                  label: const Text('AI'),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                Chip(
                  label: const Text('跨平台'),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 版本信息区域
  Widget _buildVersionSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '版本信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildInfoItem(context, '应用版本', 'v1.0.0'),
            const Divider(),
            _buildInfoItem(context, '构建版本', '1.0.0+1'),
            const Divider(),
            _buildInfoItem(context, 'Flutter版本', '3.32.0'),
            const Divider(),
            _buildInfoItem(context, '发布日期', '2025-08-27'),

            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _checkForUpdates(context),
                icon: const Icon(Icons.system_update),
                label: const Text('检查更新'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 支持区域
  Widget _buildSupportSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '帮助与支持',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('使用帮助'),
              subtitle: const Text('查看使用说明和常见问题'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showHelp(context),
              contentPadding: EdgeInsets.zero,
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('意见反馈'),
              subtitle: const Text('报告问题或提出建议'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showFeedback(context),
              contentPadding: EdgeInsets.zero,
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.star_rate),
              title: const Text('评价应用'),
              subtitle: const Text('在应用商店给我们评分'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _rateApp(context),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 法律信息区域
  Widget _buildLegalSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.gavel,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '法律信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('隐私政策'),
              subtitle: const Text('了解我们如何保护您的隐私'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPrivacyPolicy(context),
              contentPadding: EdgeInsets.zero,
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('服务条款'),
              subtitle: const Text('查看使用条款和协议'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermsOfService(context),
              contentPadding: EdgeInsets.zero,
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.copyright),
              title: const Text('开源许可'),
              subtitle: const Text('查看第三方开源库许可'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLicenses(context),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建信息项目
  Widget _buildInfoItem(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 检查更新
  void _checkForUpdates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('检查更新功能开发中...')),
    );
  }

  /// 显示帮助
  void _showHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('帮助页面开发中...')),
    );
  }

  /// 显示反馈
  void _showFeedback(BuildContext context) async {
    const url = 'https://github.com/fraternity-z/CampusCopilot/issues';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('无法打开链接，请手动访问GitHub Issues页面')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('打开链接失败: $e')),
        );
      }
    }
  }

  /// 评价应用
  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('评价功能开发中...')),
    );
  }

  /// 显示隐私政策
  void _showPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('隐私政策页面开发中...')),
    );
  }

  /// 显示服务条款
  void _showTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('服务条款页面开发中...')),
    );
  }

  /// 显示开源许可
  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'AI Assistant',
      applicationVersion: 'v1.0.0',
      applicationIcon: Image.asset(
        'assets/icons/app_icon.png',
        width: 48,
        height: 48,
      ),
    );
  }
}
