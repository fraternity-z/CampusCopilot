// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0

// 课程表缓存管理器

import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:ai_assistant/model/xidian_ids/classtable.dart';
import 'package:ai_assistant/shared/utils/debug_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassTableCacheManager {
  static const String _cacheFileName = "cached_classtable.json";
  static const String _cacheMetaKey = "classtable_cache_meta";
  static const int _cacheValidDays = 7; // 缓存有效期7天

  /// 获取缓存文件路径
  static Future<File> _getCacheFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$_cacheFileName');
  }

  /// 缓存元数据结构
  static Map<String, dynamic> _createCacheMeta({
    required String semesterCode,
    required DateTime cacheTime,
    required int dataVersion,
  }) {
    return {
      'semesterCode': semesterCode,
      'cacheTime': cacheTime.toIso8601String(),
      'dataVersion': dataVersion,
    };
  }

  /// 检查缓存是否有效
  static Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metaJson = prefs.getString(_cacheMetaKey);
      
      if (metaJson == null) return false;
      
      final meta = json.decode(metaJson);
      final cacheTime = DateTime.parse(meta['cacheTime']);
      final now = DateTime.now();
      
      // 检查缓存是否在有效期内
      final daysDiff = now.difference(cacheTime).inDays;
      final isValid = daysDiff < _cacheValidDays;
      
      debugLog(() => "[ClassTableCacheManager] Cache valid: $isValid, days since cache: $daysDiff");
      return isValid;
    } catch (e) {
      debugLog(() => "[ClassTableCacheManager] Error checking cache validity: $e");
      return false;
    }
  }

  /// 保存课程表到缓存
  static Future<void> saveClassTable(ClassTableData classTable) async {
    try {
      final file = await _getCacheFile();
      
      // 保存课程表数据
      final jsonData = json.encode(classTable.toJson());
      await file.writeAsString(jsonData);
      
      // 保存缓存元数据
      final prefs = await SharedPreferences.getInstance();
      final meta = _createCacheMeta(
        semesterCode: classTable.semesterCode,
        cacheTime: DateTime.now(),
        dataVersion: 1,
      );
      
      await prefs.setString(_cacheMetaKey, json.encode(meta));
      
      debugLog(() => "[ClassTableCacheManager] ClassTable cached successfully for semester: ${classTable.semesterCode}");
    } catch (e) {
      debugLog(() => "[ClassTableCacheManager] Error saving cache: $e");
    }
  }

  /// 从缓存加载课程表
  static Future<ClassTableData?> loadClassTable() async {
    try {
      // 检查缓存是否有效
      if (!await isCacheValid()) {
        debugLog(() => "[ClassTableCacheManager] Cache is invalid or expired");
        return null;
      }

      final file = await _getCacheFile();
      if (!await file.exists()) {
        debugLog(() => "[ClassTableCacheManager] Cache file not found");
        return null;
      }

      // 读取缓存数据
      final jsonData = await file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonData);
      
      final classTable = ClassTableData.fromJson(data);
      debugLog(() => "[ClassTableCacheManager] ClassTable loaded from cache for semester: ${classTable.semesterCode}");
      
      return classTable;
    } catch (e) {
      debugLog(() => "[ClassTableCacheManager] Error loading cache: $e");
      return null;
    }
  }

  /// 清除缓存
  static Future<void> clearCache() async {
    try {
      final file = await _getCacheFile();
      if (await file.exists()) {
        await file.delete();
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheMetaKey);
      
      debugLog(() => "[ClassTableCacheManager] Cache cleared");
    } catch (e) {
      debugLog(() => "[ClassTableCacheManager] Error clearing cache: $e");
    }
  }

  /// 获取缓存信息（用于调试）
  static Future<Map<String, dynamic>?> getCacheInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metaJson = prefs.getString(_cacheMetaKey);
      
      if (metaJson == null) return null;
      
      return json.decode(metaJson);
    } catch (e) {
      debugLog(() => "[ClassTableCacheManager] Error getting cache info: $e");
      return null;
    }
  }

  /// 检查是否需要强制刷新（例如新学期）
  static Future<bool> shouldForceRefresh(String currentSemester) async {
    try {
      final cacheInfo = await getCacheInfo();
      if (cacheInfo == null) return true;
      
      final cachedSemester = cacheInfo['semesterCode'] as String?;
      final shouldRefresh = cachedSemester != currentSemester;
      
      debugLog(() => "[ClassTableCacheManager] Should force refresh: $shouldRefresh (current: $currentSemester, cached: $cachedSemester)");
      return shouldRefresh;
    } catch (e) {
      debugLog(() => "[ClassTableCacheManager] Error checking force refresh: $e");
      return true;
    }
  }
}