import 'package:flutter/foundation.dart';
import 'dart:math' as math;

import '../../../../data/local/app_database.dart';
import '../entities/knowledge_document.dart';
import 'embedding_service.dart';

/// 智能检索结果
class IntelligentRetrievalResult {
  final List<RetrievedChunk> chunks;
  final double retrievalTime;
  final int totalCandidates;
  final String searchStrategy;
  final Map<String, dynamic> debugInfo;
  final String? error;

  const IntelligentRetrievalResult({
    required this.chunks,
    required this.retrievalTime,
    required this.totalCandidates,
    required this.searchStrategy,
    this.debugInfo = const {},
    this.error,
  });

  bool get isSuccess => error == null;
}

/// 检索到的文本块（带评分详情）
class RetrievedChunk {
  final String id;
  final String content;
  final double vectorScore;      // 向量相似度分数
  final double keywordScore;     // 关键词匹配分数  
  final double semanticScore;    // 语义相关度分数
  final double finalScore;       // 最终综合分数
  final Map<String, dynamic> metadata;
  final Map<String, double> scoreBreakdown;

  const RetrievedChunk({
    required this.id,
    required this.content,
    required this.vectorScore,
    required this.keywordScore,
    required this.semanticScore,
    required this.finalScore,
    this.metadata = const {},
    this.scoreBreakdown = const {},
  });

  @override
  String toString() {
    return 'RetrievedChunk(id: $id, finalScore: ${finalScore.toStringAsFixed(3)}, '
           'vector: ${vectorScore.toStringAsFixed(3)}, '
           'keyword: ${keywordScore.toStringAsFixed(3)}, '
           'semantic: ${semanticScore.toStringAsFixed(3)})';
  }
}

/// 智能检索服务
/// 
/// 实现业界最先进的混合检索算法：
/// 1. 向量检索（Vector Search）
/// 2. 关键词检索（Keyword Search/BM25）  
/// 3. 语义检索（Semantic Search）
/// 4. 查询重写与扩展
/// 5. 重排序机制（Reranking）
/// 6. 自适应阈值调整
class IntelligentRetrievalService {
  final AppDatabase _database;
  final EmbeddingService _embeddingService;
  
  // 检索配置
  static const double _vectorWeight = 0.4;     // 向量检索权重
  static const double _keywordWeight = 0.3;    // 关键词检索权重
  static const double _semanticWeight = 0.3;   // 语义检索权重
  static const int _maxCandidates = 50;        // 初步候选数量
  static const double _minFinalScore = 0.1;    // 最终分数阈值

  IntelligentRetrievalService(this._database, this._embeddingService);

  /// 智能检索
  Future<IntelligentRetrievalResult> retrieve({
    required String query,
    required KnowledgeBaseConfig config,
    String? knowledgeBaseId,
    int maxResults = 5,
    double? customThreshold,
  }) async {
    final startTime = DateTime.now();
    final debugInfo = <String, dynamic>{};

    try {
      debugPrint('🤖 开始智能检索: "$query"');
      
      // 1. 查询预处理和扩展
      final processedQueries = await _preprocessQuery(query);
      debugInfo['processedQueries'] = processedQueries;
      debugPrint('📝 查询扩展: ${processedQueries.length} 个变体');

      // 2. 获取所有候选文本块
      final allChunks = await _getAllChunks(knowledgeBaseId);
      if (allChunks.isEmpty) {
        return IntelligentRetrievalResult(
          chunks: [],
          retrievalTime: _calculateTime(startTime),
          totalCandidates: 0,
          searchStrategy: 'no_chunks',
          error: '未找到任何文本块',
        );
      }
      debugPrint('📚 候选文本块总数: ${allChunks.length}');

      // 3. 并行执行多种检索策略
      final futures = <Future<List<ScoredChunk>>>[];
      
      // 向量检索
      futures.add(_vectorSearch(processedQueries.first, config, allChunks));
      
      // 关键词检索（BM25）
      futures.add(_keywordSearch(query, allChunks));
      
      // 语义检索（基于关键词语义匹配）
      futures.add(_semanticSearch(query, allChunks));

      final searchResults = await Future.wait(futures);
      
      final vectorResults = searchResults[0];
      final keywordResults = searchResults[1]; 
      final semanticResults = searchResults[2];

      debugInfo['vectorResults'] = vectorResults.length;
      debugInfo['keywordResults'] = keywordResults.length;
      debugInfo['semanticResults'] = semanticResults.length;

      // 4. 结果融合和重排序
      final fusedResults = await _fuseAndRerank(
        vectorResults,
        keywordResults,
        semanticResults,
        query,
        maxResults,
      );

      debugInfo['fusedResults'] = fusedResults.length;
      debugPrint('🔀 融合后候选数: ${fusedResults.length}');

      // 5. 应用最终阈值过滤
      final threshold = customThreshold ?? _adaptiveThreshold(fusedResults);
      final finalResults = fusedResults
          .where((chunk) => chunk.finalScore >= threshold)
          .take(maxResults)
          .toList();

      debugInfo['finalThreshold'] = threshold;
      debugInfo['finalResults'] = finalResults.length;

      debugPrint('✅ 智能检索完成: ${finalResults.length} 个结果');
      for (int i = 0; i < finalResults.length && i < 3; i++) {
        debugPrint('   ${i + 1}. ${finalResults[i]}');
      }

      return IntelligentRetrievalResult(
        chunks: finalResults,
        retrievalTime: _calculateTime(startTime),
        totalCandidates: allChunks.length,
        searchStrategy: 'hybrid_retrieval',
        debugInfo: debugInfo,
      );

    } catch (e) {
      debugPrint('❌ 智能检索失败: $e');
      return IntelligentRetrievalResult(
        chunks: [],
        retrievalTime: _calculateTime(startTime),
        totalCandidates: 0,
        searchStrategy: 'error',
        debugInfo: debugInfo,
        error: e.toString(),
      );
    }
  }

  /// 查询预处理和扩展
  Future<List<String>> _preprocessQuery(String query) async {
    final queries = <String>[query];
    
    // 添加查询变体
    queries.add(query.toLowerCase().trim());
    
    // 添加关键词提取版本
    final keywords = _extractKeywords(query);
    if (keywords.isNotEmpty) {
      queries.add(keywords.join(' '));
    }
    
    // 去重并过滤空查询
    return queries.where((q) => q.trim().isNotEmpty).toSet().toList();
  }

  /// 提取关键词
  List<String> _extractKeywords(String text) {
    // 简单的关键词提取（移除停用词、短词）
    final stopWords = {'的', '了', '在', '是', '我', '有', '和', '就', '不', '人', '都', '一', '个', '上', '也', '很', '到', '说', '要', '去', '你', '会', '着', '没有', '看', '好', '自己', '这', '那', '什么', '怎么', '为什么', 'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'is', 'are', 'was', 'were', 'be', 'been', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should', 'may', 'might', 'can', 'this', 'that', 'these', 'those'};
    
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u4e00-\u9fff]'), ' ') // 保留中英文和数字
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 1 && !stopWords.contains(word))
        .toList();
  }

  /// 向量检索
  Future<List<ScoredChunk>> _vectorSearch(
    String query,
    KnowledgeBaseConfig config,
    List<ChunkData> chunks,
  ) async {
    try {
      // 生成查询向量
      final queryResult = await _embeddingService.generateSingleEmbedding(
        text: query,
        config: config,
      );

      if (!queryResult.isSuccess || queryResult.embeddings.isEmpty) {
        debugPrint('⚠️ 向量检索失败: 无法生成查询向量');
        return [];
      }

      final queryEmbedding = queryResult.embeddings.first;
      final results = <ScoredChunk>[];

      for (final chunk in chunks) {
        if (chunk.embedding.isNotEmpty) {
          final similarity = _calculateCosineSimilarity(queryEmbedding, chunk.embedding);
          if (similarity > 0.1) { // 降低向量检索阈值
            results.add(ScoredChunk(
              chunk: chunk,
              vectorScore: similarity,
              keywordScore: 0.0,
              semanticScore: 0.0,
            ));
          }
        }
      }

      // 按向量相似度排序
      results.sort((a, b) => b.vectorScore.compareTo(a.vectorScore));
      return results.take(_maxCandidates).toList();

    } catch (e) {
      debugPrint('❌ 向量检索异常: $e');
      return [];
    }
  }

  /// 关键词检索（BM25算法）
  Future<List<ScoredChunk>> _keywordSearch(
    String query,
    List<ChunkData> chunks,
  ) async {
    final queryKeywords = _extractKeywords(query);
    if (queryKeywords.isEmpty) return [];

    final results = <ScoredChunk>[];
    final avgDocLength = chunks.map((c) => c.content.length).reduce((a, b) => a + b) / chunks.length;

    for (final chunk in chunks) {
      final score = _calculateBM25Score(
        queryKeywords,
        chunk.content,
        chunks,
        avgDocLength,
      );
      
      if (score > 0.1) {
        results.add(ScoredChunk(
          chunk: chunk,
          vectorScore: 0.0,
          keywordScore: score,
          semanticScore: 0.0,
        ));
      }
    }

    results.sort((a, b) => b.keywordScore.compareTo(a.keywordScore));
    return results.take(_maxCandidates).toList();
  }

  /// BM25评分算法
  double _calculateBM25Score(
    List<String> queryKeywords,
    String document,
    List<ChunkData> corpus,
    double avgDocLength,
  ) {
    const k1 = 1.2;
    const b = 0.75;
    
    final docKeywords = _extractKeywords(document);
    final docLength = document.length;
    final corpusSize = corpus.length;
    
    double score = 0.0;
    
    for (final keyword in queryKeywords) {
      final tf = docKeywords.where((w) => w == keyword).length.toDouble();
      if (tf == 0) continue;
      
      // 计算IDF
      final df = corpus.where((chunk) => 
        _extractKeywords(chunk.content).contains(keyword)
      ).length;
      
      final idf = math.log((corpusSize - df + 0.5) / (df + 0.5));
      
      // 计算BM25分数
      final numerator = tf * (k1 + 1);
      final denominator = tf + k1 * (1 - b + b * (docLength / avgDocLength));
      
      score += idf * (numerator / denominator);
    }
    
    return math.max(0, score / queryKeywords.length); // 标准化
  }

  /// 语义检索（基于关键词语义匹配）
  Future<List<ScoredChunk>> _semanticSearch(
    String query,
    List<ChunkData> chunks,
  ) async {
    final queryKeywords = _extractKeywords(query);
    if (queryKeywords.isEmpty) return [];

    final results = <ScoredChunk>[];

    for (final chunk in chunks) {
      final score = _calculateSemanticScore(queryKeywords, chunk.content);
      
      if (score > 0.1) {
        results.add(ScoredChunk(
          chunk: chunk,
          vectorScore: 0.0,
          keywordScore: 0.0,
          semanticScore: score,
        ));
      }
    }

    results.sort((a, b) => b.semanticScore.compareTo(a.semanticScore));
    return results.take(_maxCandidates).toList();
  }

  /// 计算语义相关度分数
  double _calculateSemanticScore(List<String> queryKeywords, String content) {
    final contentKeywords = _extractKeywords(content);
    if (contentKeywords.isEmpty) return 0.0;

    // 精确匹配得分
    double exactMatches = 0;
    for (final keyword in queryKeywords) {
      if (contentKeywords.contains(keyword)) {
        exactMatches++;
      }
    }

    // 模糊匹配得分（编辑距离）
    double fuzzyMatches = 0;
    for (final queryKw in queryKeywords) {
      for (final contentKw in contentKeywords) {
        final similarity = _calculateEditDistanceSimilarity(queryKw, contentKw);
        if (similarity > 0.7) { // 70%以上相似度
          fuzzyMatches += similarity;
          break; // 避免重复计分
        }
      }
    }

    // 综合得分
    final exactScore = exactMatches / queryKeywords.length;
    final fuzzyScore = fuzzyMatches / queryKeywords.length;
    
    return (exactScore * 0.8 + fuzzyScore * 0.2).clamp(0.0, 1.0);
  }

  /// 计算编辑距离相似度
  double _calculateEditDistanceSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final maxLen = math.max(s1.length, s2.length);
    final editDistance = _calculateEditDistance(s1, s2);
    
    return (maxLen - editDistance) / maxLen;
  }

  /// 计算编辑距离
  int _calculateEditDistance(String s1, String s2) {
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,     // 删除
          matrix[i][j - 1] + 1,     // 插入
          matrix[i - 1][j - 1] + cost, // 替换
        ].reduce(math.min);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// 结果融合和重排序
  Future<List<RetrievedChunk>> _fuseAndRerank(
    List<ScoredChunk> vectorResults,
    List<ScoredChunk> keywordResults,
    List<ScoredChunk> semanticResults,
    String originalQuery,
    int maxResults,
  ) async {
    // 1. 收集所有候选结果
    final allCandidates = <String, ScoredChunk>{};
    
    // 添加向量检索结果
    for (final result in vectorResults) {
      allCandidates[result.chunk.id] = result;
    }
    
    // 融合关键词检索结果
    for (final result in keywordResults) {
      if (allCandidates.containsKey(result.chunk.id)) {
        final existing = allCandidates[result.chunk.id]!;
        allCandidates[result.chunk.id] = ScoredChunk(
          chunk: existing.chunk,
          vectorScore: existing.vectorScore,
          keywordScore: result.keywordScore,
          semanticScore: existing.semanticScore,
        );
      } else {
        allCandidates[result.chunk.id] = result;
      }
    }
    
    // 融合语义检索结果
    for (final result in semanticResults) {
      if (allCandidates.containsKey(result.chunk.id)) {
        final existing = allCandidates[result.chunk.id]!;
        allCandidates[result.chunk.id] = ScoredChunk(
          chunk: existing.chunk,
          vectorScore: existing.vectorScore,
          keywordScore: existing.keywordScore,
          semanticScore: result.semanticScore,
        );
      } else {
        allCandidates[result.chunk.id] = result;
      }
    }

    // 2. 计算最终综合分数
    final finalResults = <RetrievedChunk>[];
    
    for (final candidate in allCandidates.values) {
      final finalScore = _vectorWeight * candidate.vectorScore +
                        _keywordWeight * candidate.keywordScore +
                        _semanticWeight * candidate.semanticScore;

      final scoreBreakdown = {
        'vector': candidate.vectorScore,
        'keyword': candidate.keywordScore, 
        'semantic': candidate.semanticScore,
        'final': finalScore,
        'vector_weighted': _vectorWeight * candidate.vectorScore,
        'keyword_weighted': _keywordWeight * candidate.keywordScore,
        'semantic_weighted': _semanticWeight * candidate.semanticScore,
      };

      finalResults.add(RetrievedChunk(
        id: candidate.chunk.id,
        content: candidate.chunk.content,
        vectorScore: candidate.vectorScore,
        keywordScore: candidate.keywordScore,
        semanticScore: candidate.semanticScore,
        finalScore: finalScore,
        metadata: candidate.chunk.metadata,
        scoreBreakdown: scoreBreakdown,
      ));
    }

    // 3. 按最终分数排序
    finalResults.sort((a, b) => b.finalScore.compareTo(a.finalScore));

    // 4. 应用重排序策略（基于多样性和相关性）
    return _diversityReranking(finalResults, originalQuery, maxResults * 2);
  }

  /// 多样性重排序
  List<RetrievedChunk> _diversityReranking(
    List<RetrievedChunk> candidates,
    String query,
    int maxCandidates,
  ) {
    if (candidates.length <= maxCandidates) return candidates;

    final selected = <RetrievedChunk>[];
    final remaining = List<RetrievedChunk>.from(candidates);

    // 首先选择分数最高的
    if (remaining.isNotEmpty) {
      selected.add(remaining.removeAt(0));
    }

    // 基于多样性选择剩余候选
    while (selected.length < maxCandidates && remaining.isNotEmpty) {
      double maxDiversityScore = -1;
      int bestIndex = 0;

      for (int i = 0; i < remaining.length; i++) {
        final candidate = remaining[i];
        
        // 计算与已选择结果的多样性
        double minSimilarity = 1.0;
        for (final selectedChunk in selected) {
          final similarity = _calculateContentSimilarity(
            candidate.content,
            selectedChunk.content,
          );
          minSimilarity = math.min(minSimilarity, similarity);
        }

        // 多样性分数：原分数 × (1 - 最小相似度)
        final diversityScore = candidate.finalScore * (1 - minSimilarity);
        
        if (diversityScore > maxDiversityScore) {
          maxDiversityScore = diversityScore;
          bestIndex = i;
        }
      }

      selected.add(remaining.removeAt(bestIndex));
    }

    return selected;
  }

  /// 计算内容相似度（简化版）
  double _calculateContentSimilarity(String content1, String content2) {
    final keywords1 = _extractKeywords(content1).toSet();
    final keywords2 = _extractKeywords(content2).toSet();
    
    if (keywords1.isEmpty && keywords2.isEmpty) return 1.0;
    if (keywords1.isEmpty || keywords2.isEmpty) return 0.0;
    
    final intersection = keywords1.intersection(keywords2);
    final union = keywords1.union(keywords2);
    
    return intersection.length / union.length; // Jaccard相似度
  }

  /// 自适应阈值计算
  double _adaptiveThreshold(List<RetrievedChunk> results) {
    if (results.isEmpty) return 0.1;
    
    final scores = results.map((r) => r.finalScore).toList();
    scores.sort((a, b) => b.compareTo(a));
    
    // 如果最高分很低，降低阈值
    if (scores.first < 0.3) {
      return math.max(0.05, scores.first * 0.3);
    }
    
    // 使用分数分布确定阈值
    if (scores.length >= 3) {
      final median = scores[scores.length ~/ 2];
      return math.max(0.1, median * 0.5);
    }
    
    return _minFinalScore;
  }

  /// 获取所有文本块
  Future<List<ChunkData>> _getAllChunks(String? knowledgeBaseId) async {
    try {
      final chunks = knowledgeBaseId != null
          ? await _database.getChunksByKnowledgeBase(knowledgeBaseId)
          : await _database.getAllChunksWithEmbeddings();

      return chunks.map((chunk) {
        List<double> embedding = [];
        if (chunk.embedding != null && chunk.embedding!.isNotEmpty) {
          try {
            final embeddingData = chunk.embedding!;
            if (embeddingData.startsWith('[') && embeddingData.endsWith(']')) {
              final List<dynamic> parsedList = 
                  embeddingData.substring(1, embeddingData.length - 1)
                      .split(',')
                      .map((e) => double.tryParse(e.trim()) ?? 0.0)
                      .toList();
              embedding = parsedList.cast<double>();
            }
          } catch (e) {
            debugPrint('⚠️ 解析嵌入向量失败: ${chunk.id}');
          }
        }

        return ChunkData(
          id: chunk.id,
          content: chunk.content,
          embedding: embedding,
          metadata: {'knowledgeBaseId': chunk.knowledgeBaseId},
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ 获取文本块失败: $e');
      return [];
    }
  }

  /// 计算余弦相似度
  double _calculateCosineSimilarity(List<double> vector1, List<double> vector2) {
    if (vector1.length != vector2.length) return 0.0;

    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (int i = 0; i < vector1.length; i++) {
      dotProduct += vector1[i] * vector2[i];
      norm1 += vector1[i] * vector1[i];
      norm2 += vector2[i] * vector2[i];
    }

    if (norm1 == 0.0 || norm2 == 0.0) return 0.0;
    return dotProduct / (math.sqrt(norm1) * math.sqrt(norm2));
  }

  /// 计算时间差（毫秒）
  double _calculateTime(DateTime startTime) {
    return DateTime.now().difference(startTime).inMilliseconds.toDouble();
  }
}

/// 文本块数据
class ChunkData {
  final String id;
  final String content;
  final List<double> embedding;
  final Map<String, dynamic> metadata;

  const ChunkData({
    required this.id,
    required this.content,
    required this.embedding,
    this.metadata = const {},
  });
}

/// 评分文本块（中间结果）
class ScoredChunk {
  final ChunkData chunk;
  final double vectorScore;
  final double keywordScore;
  final double semanticScore;

  const ScoredChunk({
    required this.chunk,
    required this.vectorScore,
    required this.keywordScore, 
    required this.semanticScore,
  });
}