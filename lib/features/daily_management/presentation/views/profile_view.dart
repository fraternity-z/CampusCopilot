// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:campus_copilot/shared/utils/debug_log.dart';
import 'package:campus_copilot/repository/preference.dart' as preference;
import 'package:campus_copilot/repository/xidian_ids/ids_session.dart';
import 'login_view.dart';

/// 个人信息界面
/// 
/// 根据登录状态显示：
/// - 已登录：个人信息和注销按钮
/// - 未登录：登录界面
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  
  /// 处理登录成功回调
  void _handleLoginSuccess() {
    if (mounted) {
      setState(() {}); // 刷新页面状态
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    // 检查登录状态
    if (loginState == IDSLoginState.success) {
      return _buildProfileContent();
    } else {
      return _buildLoginPrompt();
    }
  }

  /// 构建个人信息内容（已登录状态）
  Widget _buildProfileContent() {
    final String account = preference.getString(preference.Preference.idsAccount);
    final bool isPostGraduate = preference.getBool(preference.Preference.role);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(), // 改进垂直滚动物理效果
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头像和基本信息
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  account.isNotEmpty ? account : "用户",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPostGraduate ? Colors.blue.shade100 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPostGraduate ? "研究生" : "本科生",
                    style: TextStyle(
                      color: isPostGraduate ? Colors.blue.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // 功能列表
          _buildInfoCard(
            title: "账号信息",
            children: [
              _buildInfoItem(
                icon: Icons.account_circle,
                title: "学号/工号",
                content: account.isNotEmpty ? account : "未设置",
              ),
              _buildInfoItem(
                icon: Icons.school,
                title: "学生类型",
                content: isPostGraduate ? "研究生" : "本科生",
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildInfoCard(
            title: "登录状态",
            children: [
              _buildInfoItem(
                icon: Icons.login,
                title: "当前状态",
                content: "已登录",
                contentColor: Colors.green.shade700,
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // 注销按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text("注销登录"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.shade50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建登录提示（未登录状态）
  Widget _buildLoginPrompt() {
    return LoginView(onLoginSuccess: _handleLoginSuccess);
  }

  /// 构建信息卡片
  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  /// 构建信息项
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String content,
    Color? contentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: contentColor ?? Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 注销登录
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("确认注销"),
        content: const Text("您确定要注销登录吗？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performLogout();
            },
            child: const Text(
              "注销",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// 执行注销
  void _performLogout() async {
    try {
      // 清除登录状态
      await clearLoginState();
      
      // 清除保存的密码
      await preference.setString(preference.Preference.idsPassword, "");
      
      debugLog(() => "[ProfileView] User logged out");
      
      if (mounted) {
        setState(() {}); // 刷新界面
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("已成功注销")),
        );
      }
    } catch (e) {
      debugLog(() => "[ProfileView] Logout failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("注销失败，请重试")),
        );
      }
    }
  }
}