/// 将 Map 以树形结构格式化为字符串，使用制表符逻辑（├─ └─ │）表示层级
///
/// 支持：嵌套 Map、List、null、基本类型
/// 返回：格式化后的完整字符串
String formatMapAsTree(Map<dynamic, dynamic> map) {
  final buffer = StringBuffer();
  final entries = map.entries.toList();
  final lastIndex = entries.length - 1;
  buffer.writeln('root');
  for (int i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final isLast = i == lastIndex;
    final prefix = _buildPrefix(i, entries.length);

    buffer.writeln('$prefix${isLast ? '└─' : '├─'} ${entry.key}:');

    final value = entry.value;
    final childPrefix = prefix + (isLast ? '   ' : '│  ');

    if (value is Map) {
      buffer.write(_formatMap(value, childPrefix));
    } else if (value is List) {
      buffer.write(_formatList(value, childPrefix));
    } else {
      buffer.writeln('$childPrefix${isLast ? '└─' : '├─'} $value');
    }
  }

  return buffer.toString();
}

// 递归格式化嵌套 Map
String _formatMap(Map<dynamic, dynamic> map, String prefix) {
  final buffer = StringBuffer();
  final entries = map.entries.toList();
  final lastIndex = entries.length - 1;

  for (int i = 0; i < entries.length; i++) {
    final entry = entries[i];
    final isLast = i == lastIndex;
    final connector = isLast ? '└─' : '├─';
    final nextPrefix = prefix + (isLast ? '   ' : '│  ');

    buffer.writeln('$prefix$connector ${entry.key}:');

    final value = entry.value;
    if (value is Map) {
      buffer.write(_formatMap(value, nextPrefix));
    } else if (value is List) {
      buffer.write(_formatList(value, nextPrefix));
    } else {
      buffer.writeln('$nextPrefix${isLast ? '└─' : '├─'} $value');
    }
  }
  return buffer.toString();
}

// 递归格式化 List（支持嵌套）
String _formatList(List<dynamic> list, String prefix) {
  final buffer = StringBuffer();
  final lastIndex = list.length - 1;

  for (int i = 0; i < list.length; i++) {
    final isLast = i == lastIndex;
    final connector = isLast ? '└─' : '├─';
    final nextPrefix = prefix + (isLast ? '   ' : '│  ');

    final item = list[i];

    if (item is Map) {
      buffer.writeln('$prefix$connector[$i]:');
      buffer.write(_formatMap(item, nextPrefix));
    } else if (item is List) {
      buffer.writeln('$prefix$connector[$i]:');
      buffer.write(_formatList(item, nextPrefix));
    } else {
      buffer.writeln('$prefix$connector[$i]: $item');
    }
  }
  return buffer.toString();
}

// 辅助：根据层级和索引生成前缀（仅用于顶层调用）
String _buildPrefix(int currentIndex, int total) {
  if (currentIndex == 0 && total == 1) return '';
  return currentIndex == 0 ? '' : '│  ';
}

// ==================== 示例使用 ====================

void test() {
  final sampleMap = {
    'name': 'Alice',
    'age': 30,
    'active': true,
    'address': {
      'street': '123 Main St',
      'city': 'Tokyo',
      'coordinates': [35.6762, 139.6503],
      'details': {
        'floor': 5,
        'hasElevator': true,
      }
    },
    'hobbies': ['reading', 'coding', {'type': 'sports', 'name': 'tennis'}],
    'metadata': null,
    'tags': ['dev', 'AI', ['nested', 'list']]
  };

  final result = formatMapAsTree(sampleMap);
  print('=== Map Tree String ===\n$result');
}