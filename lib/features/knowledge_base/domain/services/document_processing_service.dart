import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

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
          // TODO: 实现PDF文本提取
          return const _TextExtractionResult(text: '', error: 'PDF文件处理暂未实现');

        case 'docx':
          // TODO: 实现DOCX文本提取
          return const _TextExtractionResult(text: '', error: 'DOCX文件处理暂未实现');

        case 'rtf':
          // TODO: 实现RTF文本提取
          return const _TextExtractionResult(text: '', error: 'RTF文件处理暂未实现');

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
}
