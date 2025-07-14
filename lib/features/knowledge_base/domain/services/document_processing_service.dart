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
class TextExtractionResult {
  final String text;
  final String? error;

  const TextExtractionResult({required this.text, this.error});
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
      final chunks = await _splitIntoChunks(
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

  /// 从文件中提取文本内容（公共方法）
  Future<TextExtractionResult> extractTextFromFile(
    String filePath,
    String fileType,
  ) async {
    return _extractText(filePath, fileType);
  }

  /// 提取文本内容
  Future<TextExtractionResult> _extractText(
    String filePath,
    String fileType,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const TextExtractionResult(text: '', error: '文件不存在');
      }

      switch (fileType.toLowerCase()) {
        case 'txt':
        case 'md':
        case 'markdown':
          return TextExtractionResult(
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
            return TextExtractionResult(text: text);
          } catch (e) {
            return TextExtractionResult(text: '', error: '不支持的文件类型: $fileType');
          }
      }
    } catch (e) {
      return TextExtractionResult(text: '', error: '文本提取失败: $e');
    }
  }

  /// 将文本分割成块（异步版本，避免UI卡住）
  Future<List<DocumentChunk>> _splitIntoChunks({
    required String documentId,
    required String text,
    required int chunkSize,
    required int chunkOverlap,
  }) async {
    if (text.isEmpty) return [];

    // 验证参数合理性
    if (chunkOverlap >= chunkSize) {
      debugPrint(
        '⚠️ 警告：重叠大小($chunkOverlap)不能大于等于块大小($chunkSize)，自动调整为${(chunkSize * 0.2).round()}',
      );
      chunkOverlap = (chunkSize * 0.2).round(); // 设置为块大小的20%
    }

    debugPrint(
      '📝 开始分块处理，文本长度: ${text.length}, 块大小: $chunkSize, 重叠: $chunkOverlap',
    );
    final chunks = <DocumentChunk>[];
    int start = 0;
    int chunkIndex = 0;
    int processedChars = 0;
    int lastStart = -1; // 用于检测无限循环

    while (start < text.length) {
      // 检测无限循环
      if (start == lastStart) {
        debugPrint('❌ 检测到无限循环，强制退出。start=$start, lastStart=$lastStart');
        break;
      }
      lastStart = start;

      // 每处理一定数量的字符后，让出控制权给UI线程
      if (processedChars > 10000) {
        await Future.delayed(const Duration(milliseconds: 1));
        processedChars = 0;
      }

      // 计算当前块的结束位置
      int end = start + chunkSize;
      if (end > text.length) {
        end = text.length;
      }

      // 尝试在句子边界分割（简化版本）
      if (end < text.length) {
        final sentenceEnd = _findSentenceEndSimple(text, end);
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

        // 每10个块输出一次进度
        if (chunkIndex % 10 == 0) {
          debugPrint('📊 已处理 $chunkIndex 个文本块');
        }
      }

      // 计算下一个块的开始位置（考虑重叠）
      int nextStart = end - chunkOverlap;

      // 确保下一个开始位置有效
      if (nextStart <= start) {
        // 如果计算出的下一个位置没有前进，强制前进至少1个字符
        nextStart = start + 1;
        debugPrint(
          '⚠️ 调整下一个开始位置: $start -> $nextStart (原计算值: ${end - chunkOverlap})',
        );
      }

      start = nextStart;

      // 边界检查
      if (start >= text.length) {
        break;
      }

      processedChars += (end - (start - 1));

      // 安全检查：如果块数量过多，可能存在问题
      if (chunkIndex > text.length / 10) {
        debugPrint('❌ 块数量异常过多($chunkIndex)，可能存在无限循环，强制退出');
        break;
      }
    }

    debugPrint('✅ 分块完成，总共生成 ${chunks.length} 个文本块');
    return chunks;
  }

  /// 查找句子结束位置（简化版本，更高效）
  int _findSentenceEndSimple(String text, int position) {
    // 简化版本：只查找最常见的句子结束符，范围更小
    const sentenceEnders = ['.', '。', '\n'];

    // 向前查找最近的句子结束符（范围缩小到50个字符）
    for (int i = position; i < text.length && i < position + 50; i++) {
      if (sentenceEnders.contains(text[i])) {
        return i + 1;
      }
    }

    // 向后查找（范围缩小到50个字符）
    for (int i = position - 1; i >= 0 && i > position - 50; i--) {
      if (sentenceEnders.contains(text[i])) {
        return i + 1;
      }
    }

    return position;
  }

  /// 估算token数量（优化版本）
  int _estimateTokenCount(String text) {
    if (text.isEmpty) return 0;

    // 简化的token估算：避免复杂的正则表达式
    // 大致按照字符数除以4来估算（这是一个常用的经验值）
    // 对于中英文混合文本，这个估算相对准确且高效
    return (text.length / 4).ceil();
  }

  /// 提取PDF文本内容
  Future<TextExtractionResult> _extractPdfText(String filePath) async {
    try {
      // 注意：pdf包主要用于创建PDF，不是解析现有PDF的最佳选择
      // 这里提供基础实现，实际应用中建议使用专门的PDF解析库
      return const TextExtractionResult(
        text: '',
        error: 'PDF文本提取功能需要使用专门的PDF解析库',
      );
    } catch (e) {
      return TextExtractionResult(text: '', error: 'PDF文件读取失败: $e');
    }
  }

  /// 提取DOCX文本内容
  Future<TextExtractionResult> _extractDocxText(String filePath) async {
    try {
      debugPrint('📄 开始处理DOCX文件: $filePath');
      final file = File(filePath);

      if (!await file.exists()) {
        return const TextExtractionResult(text: '', error: 'DOCX文件不存在');
      }

      final bytes = await file.readAsBytes();
      debugPrint('📊 DOCX文件大小: ${bytes.length} bytes');

      // 使用ZipDecoder解析DOCX文件结构
      final archive = ZipDecoder().decodeBytes(bytes);
      final docxContent = StringBuffer();
      bool foundDocument = false;

      // 查找 word/document.xml 文件
      for (final archiveFile in archive) {
        if (archiveFile.name == 'word/document.xml') {
          foundDocument = true;
          debugPrint('✅ 找到document.xml文件');

          try {
            final xmlContent = archiveFile.content as List<int>;
            final xmlString = utf8.decode(xmlContent);
            final xmlDoc = XmlDocument.parse(xmlString);

            // 提取所有文本节点
            final textNodes = xmlDoc.findAllElements('w:t');
            debugPrint('📝 找到${textNodes.length}个文本节点');

            for (final textNode in textNodes) {
              final text = textNode.innerText;
              if (text.isNotEmpty) {
                docxContent.write(text);
                docxContent.write(' '); // 添加空格分隔
              }
            }
            break;
          } catch (xmlError) {
            debugPrint('❌ XML解析错误: $xmlError');
            return TextExtractionResult(
              text: '',
              error: 'DOCX文件XML解析失败: $xmlError',
            );
          }
        }
      }

      if (!foundDocument) {
        return const TextExtractionResult(
          text: '',
          error: 'DOCX文件格式无效：未找到document.xml',
        );
      }

      final extractedText = docxContent.toString().trim();
      debugPrint('✅ DOCX文本提取完成，长度: ${extractedText.length}');

      if (extractedText.isEmpty) {
        return const TextExtractionResult(text: '', error: 'DOCX文件中未找到文本内容');
      }

      return TextExtractionResult(text: extractedText);
    } catch (e, stackTrace) {
      debugPrint('💥 DOCX文件处理异常: $e');
      debugPrint('堆栈跟踪: $stackTrace');
      return TextExtractionResult(text: '', error: 'DOCX文件读取失败: $e');
    }
  }

  /// 提取RTF文本内容
  Future<TextExtractionResult> _extractRtfText(String filePath) async {
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

      return TextExtractionResult(text: textBuffer.toString().trim());
    } catch (e) {
      return TextExtractionResult(text: '', error: 'RTF文件读取失败: $e');
    }
  }
}
