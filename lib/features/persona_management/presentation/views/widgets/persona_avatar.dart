import 'dart:io';
import 'package:flutter/material.dart';
import '../../../domain/entities/persona.dart';

/// 智能体头像组件
///
/// 支持图片头像和emoji头像，没有头像时显示名称首字母
class PersonaAvatar extends StatelessWidget {
  final Persona persona;
  final double radius;
  final Color? backgroundColor;

  const PersonaAvatar({
    super.key,
    required this.persona,
    this.radius = 24,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      child: _buildAvatarContent(context),
    );
  }

  Widget _buildAvatarContent(BuildContext context) {
    // 如果有图片头像，显示图片
    if (persona.hasImageAvatar) {
      return ClipOval(
        child: Image.file(
          File(persona.avatarImagePath!),
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    }

    // 否则显示默认头像
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    String displayText = persona.avatarEmoji;

    // 如果emoji为空，使用名称首字母
    if (displayText.isEmpty && persona.name.isNotEmpty) {
      displayText = persona.name[0].toUpperCase();
    }

    // 如果还是为空，使用默认机器人emoji
    if (displayText.isEmpty) {
      displayText = '🤖';
    }

    return Text(
      displayText,
      style: TextStyle(
        fontSize: radius * 0.8, // 根据头像大小调整字体大小
      ),
    );
  }
}
