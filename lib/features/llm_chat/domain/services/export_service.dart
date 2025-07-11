import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';

import '../entities/chat_message.dart';
import '../entities/chat_session.dart';

/// 导出格式枚举
enum ExportFormat { markdown, docx }

/// 聊天记录导出服务
class ExportService {
  /// 导出聊天记录
  ///
  /// [session] 聊天会话
  /// [messages] 聊天消息列表
  /// [format] 导出格式
  /// [includeMetadata] 是否包含元数据
  ///
  /// 返回导出的文件路径
  static Future<String?> exportChatHistory({
    required ChatSession session,
    required List<ChatMessage> messages,
    required ExportFormat format,
    bool includeMetadata = true,
  }) async {
    try {
      switch (format) {
        case ExportFormat.markdown:
          return await _exportToMarkdown(
            session: session,
            messages: messages,
            includeMetadata: includeMetadata,
          );
        case ExportFormat.docx:
          return await _exportToDocx(
            session: session,
            messages: messages,
            includeMetadata: includeMetadata,
          );
      }
    } catch (e) {
      debugPrint('导出失败: $e');
      rethrow;
    }
  }

  /// 导出到Markdown格式
  static Future<String> _exportToMarkdown({
    required ChatSession session,
    required List<ChatMessage> messages,
    bool includeMetadata = true,
  }) async {
    final buffer = StringBuffer();
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 标题和元数据
    buffer.writeln('# ${session.displayTitle}');
    buffer.writeln();

    if (includeMetadata) {
      buffer.writeln('## 会话信息');
      buffer.writeln('- **会话ID**: ${session.id}');
      buffer.writeln('- **创建时间**: ${dateFormatter.format(session.createdAt)}');
      buffer.writeln('- **最后更新**: ${dateFormatter.format(session.updatedAt)}');
      buffer.writeln('- **消息总数**: ${session.messageCount}');
      if (session.totalTokens > 0) {
        buffer.writeln('- **总Token数**: ${session.totalTokens}');
      }
      if (session.tags.isNotEmpty) {
        buffer.writeln('- **标签**: ${session.tags.join(', ')}');
      }
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }

    // 聊天记录
    buffer.writeln('## 聊天记录');
    buffer.writeln();

    for (final message in messages) {
      final timeStr = dateFormatter.format(message.timestamp);
      final role = message.isFromUser ? '👤 用户' : '🤖 AI助手';

      buffer.writeln('### $role ($timeStr)');
      buffer.writeln();

      // 处理消息内容，保持Markdown格式
      final content = _processMarkdownContent(message.content);
      buffer.writeln(content);

      // 如果有思考链内容
      if (message.thinkingContent?.isNotEmpty == true) {
        buffer.writeln();
        buffer.writeln('**思考过程：**');
        buffer.writeln();
        buffer.writeln('```');
        buffer.writeln(message.thinkingContent);
        buffer.writeln('```');
      }

      // 如果有图片URL
      if (message.imageUrls.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('**附件图片：**');
        for (final imageUrl in message.imageUrls) {
          buffer.writeln('![图片]($imageUrl)');
        }
      }

      if (includeMetadata && message.tokenCount != null) {
        buffer.writeln();
        buffer.writeln('*Token数: ${message.tokenCount}*');
      }

      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }

    // 生成文件名
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '聊天记录_${session.displayTitle}_$timestamp.md';

    // 保存文件
    return await _saveFile(buffer.toString(), fileName);
  }

  /// 导出到DOCX格式
  static Future<String> _exportToDocx({
    required ChatSession session,
    required List<ChatMessage> messages,
    bool includeMetadata = true,
  }) async {
    // 创建基础DOCX模板数据
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 准备模板数据
    final templateData = <String, dynamic>{
      'title': session.displayTitle,
      'session_id': session.id,
      'created_at': dateFormatter.format(session.createdAt),
      'updated_at': dateFormatter.format(session.updatedAt),
      'message_count': session.messageCount.toString(),
      'total_tokens': session.totalTokens.toString(),
      'tags': session.tags.join(', '),
      'show_metadata': includeMetadata,
      'messages': messages
          .map(
            (message) => {
              'role': message.isFromUser ? '用户' : 'AI助手',
              'content': _processDocxContent(message.content),
              'timestamp': dateFormatter.format(message.timestamp),
              'thinking_content': message.thinkingContent ?? '',
              'has_thinking': message.thinkingContent?.isNotEmpty == true,
              'token_count': message.tokenCount?.toString() ?? '',
              'has_tokens': message.tokenCount != null,
              'image_urls': message.imageUrls,
              'has_images': message.imageUrls.isNotEmpty,
            },
          )
          .toList(),
    };

    // 创建简单的DOCX内容
    final docxContent = await _createDocxContent(templateData);

    // 生成文件名
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '聊天记录_${session.displayTitle}_$timestamp.docx';

    // 保存文件
    return await _saveFileBytes(docxContent, fileName);
  }

  /// 创建DOCX内容
  static Future<Uint8List> _createDocxContent(Map<String, dynamic> data) async {
    return await _createSimpleDocx(data);
  }

  /// 创建简单的DOCX文档
  static Future<Uint8List> _createSimpleDocx(Map<String, dynamic> data) async {
    // 创建DOCX文档结构（ZIP格式）
    final archive = Archive();

    // 创建document.xml内容
    final documentXml = _createDocumentXml(data);
    archive.addFile(
      ArchiveFile('word/document.xml', documentXml.length, documentXml),
    );

    // 创建[Content_Types].xml
    final contentTypesXml = utf8.encode(
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''',
    );
    archive.addFile(
      ArchiveFile(
        '[Content_Types].xml',
        contentTypesXml.length,
        contentTypesXml,
      ),
    );

    // 创建_rels/.rels
    final relsXml = utf8.encode(
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''',
    );
    archive.addFile(ArchiveFile('_rels/.rels', relsXml.length, relsXml));

    // 创建word/_rels/document.xml.rels
    final docRelsXml = utf8.encode(
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>''',
    );
    archive.addFile(
      ArchiveFile(
        'word/_rels/document.xml.rels',
        docRelsXml.length,
        docRelsXml,
      ),
    );

    // 压缩为ZIP格式
    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    return Uint8List.fromList(zipBytes!);
  }

  /// 创建document.xml内容
  static List<int> _createDocumentXml(Map<String, dynamic> data) {
    final buffer = StringBuffer();

    buffer.write('''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>''');

    // 标题
    buffer.write(
      '<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="28"/></w:rPr><w:t>${_escapeXml(data['title'])}</w:t></w:r></w:p>',
    );

    // 空行
    buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');

    // 会话信息
    if (data['show_metadata'] == true) {
      buffer.write(
        '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>会话信息</w:t></w:r></w:p>',
      );
      buffer.write(
        '<w:p><w:r><w:t>会话ID: ${_escapeXml(data['session_id'])}</w:t></w:r></w:p>',
      );
      buffer.write(
        '<w:p><w:r><w:t>创建时间: ${_escapeXml(data['created_at'])}</w:t></w:r></w:p>',
      );
      buffer.write(
        '<w:p><w:r><w:t>消息总数: ${_escapeXml(data['message_count'])}</w:t></w:r></w:p>',
      );
      if (data['total_tokens'] != '0') {
        buffer.write(
          '<w:p><w:r><w:t>总Token数: ${_escapeXml(data['total_tokens'])}</w:t></w:r></w:p>',
        );
      }
      if (data['tags'].toString().isNotEmpty) {
        buffer.write(
          '<w:p><w:r><w:t>标签: ${_escapeXml(data['tags'])}</w:t></w:r></w:p>',
        );
      }
      buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
    }

    // 聊天记录标题
    buffer.write('<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>聊天记录</w:t></w:r></w:p>');
    buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');

    // 消息内容
    final messages = data['messages'] as List<Map<String, dynamic>>;
    for (final message in messages) {
      // 角色和时间
      buffer.write(
        '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>${_escapeXml(message['role'])} (${_escapeXml(message['timestamp'])})</w:t></w:r></w:p>',
      );

      // 消息内容（分段处理）
      final content = message['content'] as String;
      final lines = content.split('\n');
      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          buffer.write('<w:p><w:r><w:t>${_escapeXml(line)}</w:t></w:r></w:p>');
        } else {
          buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
        }
      }

      // 思考过程
      if (message['has_thinking'] == true) {
        buffer.write(
          '<w:p><w:r><w:rPr><w:i/></w:rPr><w:t>思考过程:</w:t></w:r></w:p>',
        );
        final thinkingLines = (message['thinking_content'] as String).split(
          '\n',
        );
        for (final line in thinkingLines) {
          buffer.write(
            '<w:p><w:r><w:rPr><w:i/></w:rPr><w:t>${_escapeXml(line)}</w:t></w:r></w:p>',
          );
        }
      }

      // Token数
      if (message['has_tokens'] == true) {
        buffer.write(
          '<w:p><w:r><w:rPr><w:i/></w:rPr><w:t>Token数: ${_escapeXml(message['token_count'])}</w:t></w:r></w:p>',
        );
      }

      // 分隔线
      buffer.write(
        '<w:p><w:r><w:t>━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</w:t></w:r></w:p>',
      );
      buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
    }

    buffer.write('  </w:body></w:document>');

    return utf8.encode(buffer.toString());
  }

  /// XML转义
  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// 处理Markdown内容
  static String _processMarkdownContent(String content) {
    // 确保代码块正确格式化
    content = content.replaceAll('```', '\n```\n');

    // 处理换行
    content = content.replaceAll('\n\n\n', '\n\n');

    return content.trim();
  }

  /// 处理DOCX内容
  static String _processDocxContent(String content) {
    // 移除Markdown格式标记，保留纯文本
    content = content.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1'); // 粗体
    content = content.replaceAll(RegExp(r'\*(.*?)\*'), r'$1'); // 斜体
    content = content.replaceAll(RegExp(r'`(.*?)`'), r'$1'); // 内联代码
    content = content.replaceAll(RegExp(r'```[\s\S]*?```'), '[代码块]'); // 代码块
    content = content.replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '[图片]'); // 图片
    content = content.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '[链接]'); // 链接

    return content.trim();
  }

  /// 保存文本文件
  static Future<String> _saveFile(String content, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content, encoding: utf8);
    return file.path;
  }

  /// 保存字节文件
  static Future<String> _saveFileBytes(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// 打开导出的文件
  static Future<void> openExportedFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('无法打开文件: ${result.message}');
      }
    } catch (e) {
      debugPrint('打开文件失败: $e');
      rethrow;
    }
  }

  /// 获取支持的导出格式
  static List<Map<String, dynamic>> getSupportedFormats() {
    return [
      {
        'format': ExportFormat.markdown,
        'name': 'Markdown',
        'description': '纯文本格式，保留Markdown标记',
        'extension': '.md',
        'icon': Icons.text_fields,
      },
      {
        'format': ExportFormat.docx,
        'name': 'Word文档',
        'description': '富文本格式，适合打印和分享',
        'extension': '.docx',
        'icon': Icons.description,
      },
    ];
  }
}
