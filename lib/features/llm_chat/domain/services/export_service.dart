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

    // 创建styles.xml样式定义
    final stylesXml = _createStylesXml();
    archive.addFile(
      ArchiveFile('word/styles.xml', stylesXml.length, stylesXml),
    );

    // 创建[Content_Types].xml
    final contentTypesXml = utf8.encode(
      '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
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
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
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

    return Uint8List.fromList(zipBytes);
  }

  /// 创建样式定义
  static List<int> _createStylesXml() {
    final stylesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <!-- 默认段落样式 -->
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:pPr>
      <w:spacing w:after="0" w:line="240" w:lineRule="auto"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Microsoft YaHei" w:eastAsia="Microsoft YaHei" w:hAnsi="Microsoft YaHei"/>
      <w:sz w:val="22"/>
      <w:szCs w:val="22"/>
    </w:rPr>
  </w:style>

  <!-- 标题1样式 -->
  <w:style w:type="paragraph" w:styleId="Title">
    <w:name w:val="Title"/>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:spacing w:before="240" w:after="240"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:color w:val="2F5496"/>
      <w:sz w:val="36"/>
      <w:szCs w:val="36"/>
    </w:rPr>
  </w:style>

  <!-- 标题2样式 -->
  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="Heading 2"/>
    <w:pPr>
      <w:spacing w:before="240" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:color w:val="2F5496"/>
      <w:sz w:val="28"/>
      <w:szCs w:val="28"/>
    </w:rPr>
  </w:style>

  <!-- 用户消息样式 -->
  <w:style w:type="paragraph" w:styleId="UserMessage">
    <w:name w:val="User Message"/>
    <w:pPr>
      <w:spacing w:before="120" w:after="60"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:color w:val="1F4E79"/>
      <w:sz w:val="24"/>
      <w:szCs w:val="24"/>
    </w:rPr>
  </w:style>

  <!-- AI消息样式 -->
  <w:style w:type="paragraph" w:styleId="AIMessage">
    <w:name w:val="AI Message"/>
    <w:pPr>
      <w:spacing w:before="120" w:after="60"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:color w:val="70AD47"/>
      <w:sz w:val="24"/>
      <w:szCs w:val="24"/>
    </w:rPr>
  </w:style>

  <!-- 代码块样式 -->
  <w:style w:type="paragraph" w:styleId="CodeBlock">
    <w:name w:val="Code Block"/>
    <w:pPr>
      <w:shd w:val="clear" w:color="auto" w:fill="F8F8F8"/>
      <w:ind w:left="432" w:right="432"/>
      <w:spacing w:before="120" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Consolas" w:eastAsia="Microsoft YaHei" w:hAnsi="Consolas"/>
      <w:color w:val="E74C3C"/>
      <w:sz w:val="20"/>
      <w:szCs w:val="20"/>
    </w:rPr>
  </w:style>

  <!-- 思考过程样式 -->
  <w:style w:type="paragraph" w:styleId="ThinkingProcess">
    <w:name w:val="Thinking Process"/>
    <w:pPr>
      <w:shd w:val="clear" w:color="auto" w:fill="FFF2CC"/>
      <w:ind w:left="432"/>
      <w:spacing w:before="120" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:i/>
      <w:color w:val="7F6000"/>
      <w:sz w:val="20"/>
      <w:szCs w:val="20"/>
    </w:rPr>
  </w:style>

  <!-- 元数据样式 -->
  <w:style w:type="paragraph" w:styleId="Metadata">
    <w:name w:val="Metadata"/>
    <w:pPr>
      <w:spacing w:after="60"/>
    </w:pPr>
    <w:rPr>
      <w:i/>
      <w:color w:val="7C7C7C"/>
      <w:sz w:val="18"/>
      <w:szCs w:val="18"/>
    </w:rPr>
  </w:style>

  <!-- 分隔线样式 -->
  <w:style w:type="paragraph" w:styleId="Separator">
    <w:name w:val="Separator"/>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:spacing w:before="120" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:color w:val="D0D0D0"/>
      <w:sz w:val="18"/>
      <w:szCs w:val="18"/>
    </w:rPr>
  </w:style>
</w:styles>''';
    
    return utf8.encode(stylesXml);
  }

  /// 创建document.xml内容
  static List<int> _createDocumentXml(Map<String, dynamic> data) {
    final buffer = StringBuffer();

    buffer.write('''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>''');

    // 标题 - 使用Title样式
    buffer.write(
      '<w:p><w:pPr><w:pStyle w:val="Title"/></w:pPr><w:r><w:t>${_escapeXml(data['title'])}</w:t></w:r></w:p>',
    );

    // 空行
    buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');

    // 会话信息
    if (data['show_metadata'] == true) {
      buffer.write(
        '<w:p><w:pPr><w:pStyle w:val="Heading2"/></w:pPr><w:r><w:t>📋 会话信息</w:t></w:r></w:p>',
      );
      
      // 元数据项目使用统一样式
      final metadataItems = [
        '🆔 会话ID: ${_escapeXml(data['session_id'])}',
        '📅 创建时间: ${_escapeXml(data['created_at'])}',
        '🕒 最后更新: ${_escapeXml(data['updated_at'])}',
        '💬 消息总数: ${_escapeXml(data['message_count'])}',
      ];
      
      if (data['total_tokens'] != '0') {
        metadataItems.add('🔢 总Token数: ${_escapeXml(data['total_tokens'])}');
      }
      if (data['tags'].toString().isNotEmpty) {
        metadataItems.add('🏷️ 标签: ${_escapeXml(data['tags'])}');
      }
      
      for (final item in metadataItems) {
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="Metadata"/></w:pPr><w:r><w:t>$item</w:t></w:r></w:p>',
        );
      }
      buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
    }

    // 聊天记录标题
    buffer.write('<w:p><w:pPr><w:pStyle w:val="Heading2"/></w:pPr><w:r><w:t>💬 聊天记录</w:t></w:r></w:p>');
    buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');

    // 消息内容
    final messages = data['messages'] as List<Map<String, dynamic>>;
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final isUser = message['role'] == '用户';
      final styleId = isUser ? 'UserMessage' : 'AIMessage';
      final icon = isUser ? '👤' : '🤖';

      // 角色和时间标题
      buffer.write(
        '<w:p><w:pPr><w:pStyle w:val="$styleId"/></w:pPr><w:r><w:t>$icon ${_escapeXml(message['role'])} (${_escapeXml(message['timestamp'])})</w:t></w:r></w:p>',
      );

      // 消息内容处理
      final content = message['content'] as String;
      _processMessageContent(buffer, content);

      // 思考过程
      if (message['has_thinking'] == true) {
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="ThinkingProcess"/></w:pPr><w:r><w:t>🤔 思考过程:</w:t></w:r></w:p>',
        );
        final thinkingContent = message['thinking_content'] as String;
        _processThinkingContent(buffer, thinkingContent);
      }

      // 附件图片
      if (message['has_images'] == true) {
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="Metadata"/></w:pPr><w:r><w:t>📷 包含图片附件</w:t></w:r></w:p>',
        );
      }

      // Token数
      if (message['has_tokens'] == true) {
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="Metadata"/></w:pPr><w:r><w:t>🔢 Token数: ${_escapeXml(message['token_count'])}</w:t></w:r></w:p>',
        );
      }

      // 消息间分隔线（除了最后一条消息）
      if (i < messages.length - 1) {
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="Separator"/></w:pPr><w:r><w:t>────────────────────────────────────</w:t></w:r></w:p>',
        );
        buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
      }
    }

    buffer.write('  </w:body></w:document>');

    return utf8.encode(buffer.toString());
  }

  /// 处理消息内容，保留格式化效果
  static void _processMessageContent(StringBuffer buffer, String content) {
    final lines = content.split('\n');
    bool inCodeBlock = false;
    String? currentCodeLanguage;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmedLine = line.trim();
      
      // 检查代码块开始/结束
      if (trimmedLine.startsWith('```')) {
        if (!inCodeBlock) {
          // 代码块开始
          inCodeBlock = true;
          currentCodeLanguage = trimmedLine.substring(3).trim();
          if (currentCodeLanguage.isEmpty) {
            currentCodeLanguage = 'text';
          }
          buffer.write(
            '<w:p><w:pPr><w:pStyle w:val="CodeBlock"/></w:pPr><w:r><w:t>💻 代码块 ($currentCodeLanguage):</w:t></w:r></w:p>',
          );
        } else {
          // 代码块结束
          inCodeBlock = false;
          currentCodeLanguage = null;
          buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
        }
        continue;
      }
      
      if (inCodeBlock) {
        // 在代码块内
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="CodeBlock"/></w:pPr><w:r><w:t>${_escapeXml(line)}</w:t></w:r></w:p>',
        );
      } else {
        // 普通文本处理
        if (trimmedLine.isEmpty) {
          buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
        } else if (trimmedLine.startsWith('# ')) {
          // 一级标题
          buffer.write(
            '<w:p><w:pPr><w:pStyle w:val="Heading2"/></w:pPr><w:r><w:t>${_escapeXml(trimmedLine.substring(2))}</w:t></w:r></w:p>',
          );
        } else if (trimmedLine.startsWith('## ')) {
          // 二级标题
          buffer.write(
            '<w:p><w:pPr><w:pStyle w:val="Heading2"/></w:pPr><w:r><w:t>▸ ${_escapeXml(trimmedLine.substring(3))}</w:t></w:r></w:p>',
          );
        } else if (trimmedLine.startsWith('- ') || trimmedLine.startsWith('* ')) {
          // 列表项
          buffer.write(
            '<w:p><w:r><w:t>• ${_escapeXml(trimmedLine.substring(2))}</w:t></w:r></w:p>',
          );
        } else if (RegExp(r'^\d+\.').hasMatch(trimmedLine)) {
          // 有序列表
          buffer.write(
            '<w:p><w:r><w:t>${_escapeXml(trimmedLine)}</w:t></w:r></w:p>',
          );
        } else {
          // 普通段落，处理内联格式
          final processedLine = _processInlineFormatting(line);
          buffer.write(
            '<w:p><w:r><w:t>$processedLine</w:t></w:r></w:p>',
          );
        }
      }
    }
  }
  
  /// 处理思考内容
  static void _processThinkingContent(StringBuffer buffer, String content) {
    final lines = content.split('\n');
    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        buffer.write(
          '<w:p><w:pPr><w:pStyle w:val="ThinkingProcess"/></w:pPr><w:r><w:t>${_escapeXml(line)}</w:t></w:r></w:p>',
        );
      } else {
        buffer.write('<w:p><w:r><w:t></w:t></w:r></w:p>');
      }
    }
  }
  
  /// 处理内联格式（粗体、斜体、代码等）
  static String _processInlineFormatting(String text) {
    // 保留基本的格式标记，让Word能够识别
    text = text.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'【粗体】$1【/粗体】');
    text = text.replaceAll(RegExp(r'\*(.*?)\*'), r'【斜体】$1【/斜体】');
    text = text.replaceAll(RegExp(r'`(.*?)`'), r'【代码】$1【/代码】');
    text = text.replaceAll(RegExp(r'!\[.*?\]\(.*?\)'), '【图片】');
    text = text.replaceAll(RegExp(r'\[.*?\]\(.*?\)'), '【链接】');
    
    return _escapeXml(text);
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

  /// 处理DOCX内容 - 保留原始内容用于后续格式化处理
  static String _processDocxContent(String content) {
    // 不再移除Markdown格式，让后续的处理函数来处理格式化
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
