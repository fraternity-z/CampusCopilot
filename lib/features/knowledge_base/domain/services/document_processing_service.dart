import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// 文档块实体
class DocumentChunk {
  final String id;
  final String content;
  final int index;
  final int characterCount;
  final int tokenCount;
  final Map<String, dynamic> metadata;

  const DocumentChunk({
    required this.id,
    required this.content,
    required this.index,
    required this.characterCount,
    required this.tokenCount,
    this.metadata = const {},
  });
}

/// 文档处理结果
class DocumentProcessingResult {
  final List<DocumentChunk> chunks;
  final Map<String, dynamic> metadata;
  final String? error;

  const DocumentProcessingResult({
    required this.chunks,
    this.metadata = const {},
    this.error,
  });

  bool get isSuccess => error == null;
}

/// 文本提取结果
class _TextExtractionResult {
  final String text;
  final String? error;

  const _TextExtractionResult({required this.text, this.error});
}

/// 文档处理服务
class DocumentProcessingService {
  /// 处理文档并分块
  Future<DocumentProcessingResult> processDocument({
    required String documentId,
    required String filePath,
    required String fileType,
    int chunkSize = 1000,
    int chunkOverlap = 200,
  }) async {
    try {
      // 1. 提取文本内容
      final extractResult = await _extractText(filePath, fileType);
      if (extractResult.error != null) {
        return DocumentProcessingResult(chunks: [], error: extractResult.error);
      }

      // 2. 分块处理
      final chunks = _splitIntoChunks(
        documentId: documentId,
        text: extractResult.text,
        chunkSize: chunkSize,
        chunkOverlap: chunkOverlap,
      );

      return DocumentProcessingResult(
        chunks: chunks,
        metadata: {
          'originalLength': extractResult.text.length,
          'chunkCount': chunks.length,
          'chunkSize': chunkSize,
          'chunkOverlap': chunkOverlap,
          'fileType': fileType,
          'processedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('文档处理失败: $e');
      return DocumentProcessingResult(chunks: [], error: e.toString());
    }
  }

  /// 提取文本内容
  Future<_TextExtractionResult> _extractText(
    String filePath,
    String fileType,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const _TextExtractionResult(text: '', error: '文件不存在');
      }

      switch (fileType.toLowerCase()) {
        case 'txt':
        case 'md':
        case 'markdown':
          return _TextExtractionResult(
            text: await file.readAsString(encoding: utf8),
          );

        case 'pdf':
          return await _extractPdfText(filePath);

        case 'docx':
          return await _extractDocxText(filePath);

        case 'rtf':
          return await _extractRtfText(filePath);

        default:
          // 尝试作为纯文本读取
          try {
            final text = await file.readAsString(encoding: utf8);
            return _TextExtractionResult(text: text);
          } catch (e) {
            return _TextExtractionResult(
              text: '',
              error: '不支持的文件类型: $fileType',
            );
          }
      }
    } catch (e) {
      return _TextExtractionResult(text: '', error: '文本提取失败: $e');
    }
  }

  /// 将文本分割成块
  List<DocumentChunk> _splitIntoChunks({
    required String documentId,
    required String text,
    required int chunkSize,
    required int chunkOverlap,
  }) {
    if (text.isEmpty) return [];

    final chunks = <DocumentChunk>[];
    int start = 0;
    int chunkIndex = 0;

    while (start < text.length) {
      // 计算当前块的结束位置
      int end = start + chunkSize;
      if (end > text.length) {
        end = text.length;
      }

      // 尝试在句子边界分割
      if (end < text.length) {
        final sentenceEnd = _findSentenceEnd(text, end);
        if (sentenceEnd > start && sentenceEnd - start <= chunkSize + 100) {
          end = sentenceEnd;
        }
      }

      // 提取块内容
      final chunkContent = text.substring(start, end).trim();
      if (chunkContent.isNotEmpty) {
        final chunkId = '${documentId}_chunk_$chunkIndex';
        final chunk = DocumentChunk(
          id: chunkId,
          content: chunkContent,
          index: chunkIndex,
          characterCount: chunkContent.length,
          tokenCount: _estimateTokenCount(chunkContent),
          metadata: {'startPosition': start, 'endPosition': end},
        );
        chunks.add(chunk);
        chunkIndex++;
      }

      // 计算下一个块的开始位置（考虑重叠）
      start = end - chunkOverlap;
      if (start < 0) start = 0;
      if (start >= end) break; // 避免无限循环
    }

    return chunks;
  }

  /// 查找句子结束位置
  int _findSentenceEnd(String text, int position) {
    const sentenceEnders = ['.', '!', '?', '。', '！', '？'];

    // 向前查找最近的句子结束符
    for (int i = position; i < text.length && i < position + 100; i++) {
      if (sentenceEnders.contains(text[i])) {
        return i + 1;
      }
    }

    // 向后查找
    for (int i = position - 1; i >= 0 && i > position - 100; i--) {
      if (sentenceEnders.contains(text[i])) {
        return i + 1;
      }
    }

    return position;
  }

  /// 估算token数量（简单实现）
  int _estimateTokenCount(String text) {
    // 简单估算：中文字符按1个token计算，英文单词按1个token计算
    int tokenCount = 0;

    // 统计中文字符
    final chineseRegex = RegExp(r'[\u4e00-\u9fff]');
    tokenCount += chineseRegex.allMatches(text).length;

    // 统计英文单词
    final englishWords = text
        .replaceAll(chineseRegex, ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    tokenCount += englishWords;

    return tokenCount;
  }

  /// 提取PDF文本内容
  Future<_TextExtractionResult> _extractPdfText(String filePath) async {
    try {
      // 注意：pdf包主要用于创建PDF，不是解析现有PDF的最佳选择
      // 这里提供基础实现，实际应用中建议使用专门的PDF解析库
      return const _TextExtractionResult(
        text: '',
        error: 'PDF文本提取功能需要使用专门的PDF解析库',
      );
    } catch (e) {
      return _TextExtractionResult(text: '', error: 'PDF文件读取失败: $e');
    }
  }

  /// 提取DOCX文本内容
  Future<_TextExtractionResult> _extractDocxText(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      // 使用ZipDecoder解析DOCX文件结构
      final archive = ZipDecoder().decodeBytes(bytes);
      final docxContent = StringBuffer();

      // 查找 word/document.xml 文件
      for (final file in archive) {
        if (file.name == 'word/document.xml') {
          final xmlContent = file.content;
          final xmlDoc = XmlDocument.parse(utf8.decode(xmlContent));

          // 提取所有文本节点
          final textNodes = xmlDoc.findAllElements('w:t');
          for (final textNode in textNodes) {
            docxContent.write(textNode.innerText);
            docxContent.write(' '); // 添加空格分隔
          }
          break;
        }
      }

      return _TextExtractionResult(text: docxContent.toString().trim());
    } catch (e) {
      return _TextExtractionResult(text: '', error: 'DOCX文件读取失败: $e');
    }
  }

  /// 提取RTF文本内容
  Future<_TextExtractionResult> _extractRtfText(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString(encoding: utf8);

      // 简单的RTF解析：去除控制符，提取纯文本
      final textBuffer = StringBuffer();
      bool inControlWord = false;

      for (int i = 0; i < content.length; i++) {
        final char = content[i];

        if (char == '{' || char == '}') {
          // 跳过组分隔符
          continue;
        } else if (char == '\\') {
          inControlWord = true;
          continue;
        } else if (inControlWord) {
          if (char == ' ' || char == '\n' || char == '\r') {
            inControlWord = false;
          }
          continue;
        }

        // 如果不在控制字符中，添加到文本中
        if (!inControlWord && char.codeUnitAt(0) >= 32) {
          textBuffer.write(char);
        }
      }

      return _TextExtractionResult(text: textBuffer.toString().trim());
    } catch (e) {
      return _TextExtractionResult(text: '', error: 'RTF文件读取失败: $e');
    }
  }
}
