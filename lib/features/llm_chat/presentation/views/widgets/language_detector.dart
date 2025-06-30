/// 语言自动检测工具类
///
/// 通过分析代码特征自动识别编程语言
class LanguageDetector {
  static const Map<String, List<String>> _languageKeywords = {
    'dart': [
      'void',
      'main',
      'class',
      'extends',
      'implements',
      'mixin',
      'enum',
      'abstract',
      'static',
      'final',
      'const',
      'var',
      'dynamic',
      'String',
      'int',
      'double',
      'bool',
      'List',
      'Map',
      'Set',
      'Widget',
      'State',
      'StatelessWidget',
      'StatefulWidget',
      'build',
      'async',
      'await',
      'Future',
      'Stream',
      '@override',
      'import',
      'library',
      'part',
    ],
    'python': [
      'def',
      'class',
      'import',
      'from',
      'if',
      'elif',
      'else',
      'while',
      'for',
      'try',
      'except',
      'finally',
      'with',
      'as',
      'lambda',
      'yield',
      'return',
      'pass',
      'break',
      'continue',
      'global',
      'nonlocal',
      'assert',
      'print',
      'len',
      'range',
      'enumerate',
      'zip',
      '__init__',
      '__main__',
    ],
    'javascript': [
      'function',
      'var',
      'let',
      'const',
      'if',
      'else',
      'for',
      'while',
      'do',
      'switch',
      'case',
      'break',
      'continue',
      'return',
      'try',
      'catch',
      'finally',
      'throw',
      'async',
      'await',
      'Promise',
      'console.log',
      'document',
      'window',
      'typeof',
      'instanceof',
      'new',
      'this',
    ],
    'typescript': [
      'interface',
      'type',
      'enum',
      'namespace',
      'module',
      'declare',
      'export',
      'import',
      'function',
      'var',
      'let',
      'const',
      'class',
      'extends',
      'implements',
      'public',
      'private',
      'protected',
      'readonly',
      'static',
      'abstract',
      'as',
      'keyof',
      'typeof',
      'generic',
    ],
    'java': [
      'public',
      'private',
      'protected',
      'static',
      'final',
      'abstract',
      'class',
      'interface',
      'extends',
      'implements',
      'package',
      'import',
      'void',
      'int',
      'String',
      'boolean',
      'long',
      'double',
      'float',
      'char',
      'byte',
      'short',
      'if',
      'else',
      'for',
      'while',
      'try',
      'catch',
    ],
    'json': ['true', 'false', 'null'],
    'yaml': ['version:', 'name:', 'description:', 'dependencies:'],
    'html': [
      '<!DOCTYPE',
      '<html',
      '<head',
      '<body',
      '<div',
      '<span',
      '<p',
      '<a',
      'href=',
      'src=',
      'class=',
      'id=',
    ],
    'css': [
      'color:',
      'background:',
      'margin:',
      'padding:',
      'border:',
      'width:',
      'height:',
      'display:',
      'position:',
      'font:',
      '@media',
      '@import',
    ],
    'bash': [
      '#!/bin/bash',
      '#!/bin/sh',
      'echo',
      'cd',
      'ls',
      'mkdir',
      'rm',
      'export',
      'source',
      'if',
      'then',
      'else',
      'fi',
      'for',
      'do',
      'done',
    ],
  };

  /// 自动检测代码语言
  static String detectLanguage(String code) {
    if (code.trim().isEmpty) return 'text';

    final scores = <String, int>{};

    // 初始化分数
    for (final language in _languageKeywords.keys) {
      scores[language] = 0;
    }

    // 基于关键字检测
    _scoreByKeywords(code, scores);

    // 基于特殊模式检测
    _scoreByPatterns(code, scores);

    // 找到最高分数的语言
    var maxScore = 0;
    var detectedLanguage = 'text';

    for (final entry in scores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        detectedLanguage = entry.key;
      }
    }

    // 如果分数太低，返回 text
    if (maxScore < 2) {
      return 'text';
    }

    return detectedLanguage;
  }

  /// 基于关键字计分
  static void _scoreByKeywords(String code, Map<String, int> scores) {
    final lowerCode = code.toLowerCase();

    for (final entry in _languageKeywords.entries) {
      final language = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        if (lowerCode.contains(keyword.toLowerCase())) {
          scores[language] = (scores[language] ?? 0) + 1;
        }
      }
    }
  }

  /// 基于特殊模式计分
  static void _scoreByPatterns(String code, Map<String, int> scores) {
    // Dart 特征
    if (code.contains('import \'dart:') || code.contains('import "dart:')) {
      scores['dart'] = (scores['dart'] ?? 0) + 5;
    }
    if (code.contains('Widget build(BuildContext')) {
      scores['dart'] = (scores['dart'] ?? 0) + 5;
    }

    // Python 特征
    if (code.contains('def ') && code.contains(':')) {
      scores['python'] = (scores['python'] ?? 0) + 3;
    }
    if (code.contains('if __name__ == "__main__"')) {
      scores['python'] = (scores['python'] ?? 0) + 5;
    }

    // JavaScript/TypeScript 特征
    if (code.contains('function ') || code.contains('=>')) {
      scores['javascript'] = (scores['javascript'] ?? 0) + 2;
    }
    if (code.contains('interface ') ||
        code.contains(': string') ||
        code.contains(': number')) {
      scores['typescript'] = (scores['typescript'] ?? 0) + 4;
    }

    // Java 特征
    if (code.contains('public class ') ||
        code.contains('public static void main')) {
      scores['java'] = (scores['java'] ?? 0) + 5;
    }

    // JSON 检测
    final trimmed = code.trim();
    if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
      if (code.contains('"') && code.contains(':')) {
        scores['json'] = (scores['json'] ?? 0) + 4;
      }
    }

    // HTML 检测
    if (code.contains('<!DOCTYPE') || code.contains('<html')) {
      scores['html'] = (scores['html'] ?? 0) + 5;
    }

    // CSS 检测
    if (code.contains('{') &&
        code.contains('}') &&
        code.contains(':') &&
        code.contains(';')) {
      scores['css'] = (scores['css'] ?? 0) + 3;
    }

    // YAML 检测
    if (code.contains('---') ||
        (code.contains(':') && !code.contains(';') && !code.contains('{}'))) {
      scores['yaml'] = (scores['yaml'] ?? 0) + 2;
    }

    // Shell 脚本检测
    if (code.startsWith('#!')) {
      scores['bash'] = (scores['bash'] ?? 0) + 5;
    }
  }

  /// 获取支持的语言列表
  static List<String> getSupportedLanguages() {
    return _languageKeywords.keys.toList()..sort();
  }

  /// 检查是否支持某种语言
  static bool isLanguageSupported(String language) {
    return _languageKeywords.containsKey(language.toLowerCase());
  }
}
