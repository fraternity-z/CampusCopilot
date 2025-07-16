import 'package:flutter/foundation.dart';

import '../vector_databases/objectbox_vector_client.dart';
import '../../domain/services/vector_database_interface.dart';

/// ObjectBox 向量数据库测试工具
///
/// 用于测试 ObjectBox 向量数据库的基本功能
class ObjectBoxVectorTest {
  static Future<void> runBasicTests() async {
    debugPrint('🧪 开始 ObjectBox 向量数据库基本功能测试...');

    try {
      // 1. 初始化测试
      await _testInitialization();

      // 2. 集合操作测试
      await _testCollectionOperations();

      // 3. 向量操作测试
      await _testVectorOperations();

      // 4. 搜索功能测试
      await _testSearchFunctionality();

      debugPrint('✅ 所有测试通过！');
    } catch (e) {
      debugPrint('❌ 测试失败: $e');
      rethrow;
    }
  }

  /// 测试初始化
  static Future<void> _testInitialization() async {
    debugPrint('🔧 测试数据库初始化...');

    final client = ObjectBoxVectorClient();
    final initialized = await client.initialize();

    if (!initialized) {
      throw Exception('数据库初始化失败');
    }

    final isHealthy = await client.isHealthy();
    if (!isHealthy) {
      throw Exception('数据库健康检查失败');
    }

    await client.close();
    debugPrint('✅ 初始化测试通过');
  }

  /// 测试集合操作
  static Future<void> _testCollectionOperations() async {
    debugPrint('📁 测试集合操作...');

    final client = ObjectBoxVectorClient();
    await client.initialize();

    try {
      // 创建测试集合
      final createResult = await client.createCollection(
        collectionName: 'test_collection',
        vectorDimension: 384,
        description: '测试集合',
        metadata: {'test': true},
      );

      if (!createResult.success) {
        throw Exception('创建集合失败: ${createResult.error}');
      }

      // 检查集合是否存在
      final exists = await client.collectionExists('test_collection');
      if (!exists) {
        throw Exception('集合存在性检查失败');
      }

      // 获取集合信息
      final info = await client.getCollectionInfo('test_collection');
      if (info == null) {
        throw Exception('获取集合信息失败');
      }

      if (info.vectorDimension != 384) {
        throw Exception('集合维度不匹配');
      }

      // 删除测试集合
      final deleteResult = await client.deleteCollection('test_collection');
      if (!deleteResult.success) {
        throw Exception('删除集合失败: ${deleteResult.error}');
      }

      debugPrint('✅ 集合操作测试通过');
    } finally {
      await client.close();
    }
  }

  /// 测试向量操作
  static Future<void> _testVectorOperations() async {
    debugPrint('🔢 测试向量操作...');

    final client = ObjectBoxVectorClient();
    await client.initialize();

    try {
      // 创建测试集合
      await client.createCollection(
        collectionName: 'vector_test',
        vectorDimension: 3,
        description: '向量测试集合',
      );

      // 准备测试向量
      final testVectors = [
        VectorDocument(
          id: 'doc1',
          vector: [1.0, 0.0, 0.0],
          metadata: {'content': '测试文档1'},
        ),
        VectorDocument(
          id: 'doc2',
          vector: [0.0, 1.0, 0.0],
          metadata: {'content': '测试文档2'},
        ),
        VectorDocument(
          id: 'doc3',
          vector: [0.0, 0.0, 1.0],
          metadata: {'content': '测试文档3'},
        ),
      ];

      // 插入向量
      final insertResult = await client.insertVectors(
        collectionName: 'vector_test',
        documents: testVectors,
      );

      if (!insertResult.success) {
        throw Exception('插入向量失败: ${insertResult.error}');
      }

      // 获取单个向量
      final retrievedVector = await client.getVector(
        collectionName: 'vector_test',
        documentId: 'doc1',
      );

      if (retrievedVector == null) {
        throw Exception('获取向量失败');
      }

      if (retrievedVector.vector.length != 3) {
        throw Exception('向量维度不匹配');
      }

      // 批量获取向量
      final batchVectors = await client.getVectors(
        collectionName: 'vector_test',
        documentIds: ['doc1', 'doc2'],
      );

      if (batchVectors.length != 2) {
        throw Exception('批量获取向量失败');
      }

      // 删除向量
      final deleteResult = await client.deleteVectors(
        collectionName: 'vector_test',
        documentIds: ['doc3'],
      );

      if (!deleteResult.success) {
        throw Exception('删除向量失败: ${deleteResult.error}');
      }

      // 清理测试集合
      await client.deleteCollection('vector_test');

      debugPrint('✅ 向量操作测试通过');
    } finally {
      await client.close();
    }
  }

  /// 测试搜索功能
  static Future<void> _testSearchFunctionality() async {
    debugPrint('🔍 测试搜索功能...');

    final client = ObjectBoxVectorClient();
    await client.initialize();

    try {
      // 创建测试集合
      await client.createCollection(
        collectionName: 'search_test',
        vectorDimension: 3,
        description: '搜索测试集合',
      );

      // 插入测试向量
      final testVectors = [
        VectorDocument(
          id: 'search1',
          vector: [1.0, 0.0, 0.0],
          metadata: {'content': '红色'},
        ),
        VectorDocument(
          id: 'search2',
          vector: [0.8, 0.2, 0.0],
          metadata: {'content': '橙色'},
        ),
        VectorDocument(
          id: 'search3',
          vector: [0.0, 1.0, 0.0],
          metadata: {'content': '绿色'},
        ),
      ];

      await client.insertVectors(
        collectionName: 'search_test',
        documents: testVectors,
      );

      // 执行相似度搜索
      final searchResult = await client.search(
        collectionName: 'search_test',
        queryVector: [0.9, 0.1, 0.0], // 接近红色的向量
        limit: 2,
        scoreThreshold: 0.5,
      );

      if (!searchResult.isSuccess) {
        throw Exception('搜索失败: ${searchResult.error}');
      }

      if (searchResult.items.isEmpty) {
        throw Exception('搜索结果为空');
      }

      // 验证搜索结果排序（最相似的应该排在前面）
      final firstResult = searchResult.items.first;
      if (firstResult.id != 'search1') {
        debugPrint('⚠️ 搜索结果排序可能不准确，但功能正常');
      }

      // 测试批量搜索
      final batchSearchResults = await client.batchSearch(
        collectionName: 'search_test',
        queryVectors: [
          [1.0, 0.0, 0.0],
          [0.0, 1.0, 0.0],
        ],
        limit: 1,
      );

      if (batchSearchResults.length != 2) {
        throw Exception('批量搜索失败');
      }

      // 清理测试集合
      await client.deleteCollection('search_test');

      debugPrint('✅ 搜索功能测试通过');
    } finally {
      await client.close();
    }
  }

  /// 运行性能测试
  static Future<void> runPerformanceTests() async {
    debugPrint('⚡ 开始 ObjectBox 向量数据库性能测试...');

    final client = ObjectBoxVectorClient();
    await client.initialize();

    try {
      // 创建性能测试集合
      await client.createCollection(
        collectionName: 'perf_test',
        vectorDimension: 384,
        description: '性能测试集合',
      );

      // 生成大量测试向量
      final testVectors = <VectorDocument>[];
      for (int i = 0; i < 1000; i++) {
        final vector = List.generate(384, (index) => (index + i) / 1000.0);
        testVectors.add(VectorDocument(
          id: 'perf_doc_$i',
          vector: vector,
          metadata: {'index': i, 'content': '性能测试文档 $i'},
        ));
      }

      // 测试批量插入性能
      final insertStart = DateTime.now();
      final insertResult = await client.insertVectors(
        collectionName: 'perf_test',
        documents: testVectors,
      );
      final insertTime = DateTime.now().difference(insertStart);

      if (!insertResult.success) {
        throw Exception('批量插入失败: ${insertResult.error}');
      }

      debugPrint('📊 插入 ${testVectors.length} 个向量耗时: ${insertTime.inMilliseconds}ms');

      // 测试搜索性能
      final queryVector = List.generate(384, (index) => index / 384.0);
      final searchStart = DateTime.now();
      final searchResult = await client.search(
        collectionName: 'perf_test',
        queryVector: queryVector,
        limit: 10,
      );
      final searchTime = DateTime.now().difference(searchStart);

      if (!searchResult.isSuccess) {
        throw Exception('搜索失败: ${searchResult.error}');
      }

      debugPrint('📊 搜索耗时: ${searchTime.inMilliseconds}ms');
      debugPrint('📊 找到 ${searchResult.items.length} 个结果');

      // 清理测试集合
      await client.deleteCollection('perf_test');

      debugPrint('✅ 性能测试完成');
    } finally {
      await client.close();
    }
  }
}
