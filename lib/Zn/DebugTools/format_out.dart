/// 完美树形打印任意嵌套的 List / Map / 基本类型
/// 支持中文、null、空集合，层级对齐精准
String formatDynamicAsTree(dynamic data) {
  final buffer = StringBuffer();
  _formatValue(buffer, data, '', true, '');
  return buffer.toString();
}

void _formatValue(
    StringBuffer buffer,
    dynamic value,
    String prefix,
    bool isLast,
    String keyOrIndex, {
      bool isRoot = false,
    }) {
  final connector = isLast ? '└─ ' : '├─ ';
  final continuePrefix = prefix + (isLast ? '   ' : '│  ');

  // 打印当前行：key/index + connector
  if (!isRoot) {
    buffer.write('$prefix$connector');
    if (keyOrIndex.isNotEmpty) {
      buffer.write('$keyOrIndex: ');
    }
  }

  // 处理不同类型
  if (value == null) {
    buffer.writeln('null');
  }
  else if (value is Map) {
    final entries = value.entries.toList();
    if (entries.isEmpty) {
      buffer.writeln('{}');
    } else {
      buffer.writeln('{Map (${entries.length})}');
      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final bool last = i == entries.length - 1;
        _formatValue(
          buffer,
          entry.value,
          continuePrefix,
          last,
          entry.key.toString(),
        );
      }
    }
  }
  else if (value is List) {
    if (value.isEmpty) {
      buffer.writeln('[]');
    } else {
      buffer.writeln('[List (${value.length})]');
      for (int i = 0; i < value.length; i++) {
        final bool last = i == value.length - 1;
        _formatValue(
          buffer,
          value[i],
          continuePrefix,
          last,
          '[$i]',
        );
      }
    }
  }
  else {
    // 基本类型：String, num, bool 等
    final display = value is String ? '"$value"' : value.toString();
    buffer.writeln(display);
  }
}

// ====================== 使用示例 ======================
void main() {
  final data = {
    'name': '张三',
    'age': 28,
    'active': true,
    'scores': [95, 87, 99.5],
    'info': {
      'city': '北京',
      'tags': ['coder', 'runner', null],
      'settings': {
        'theme': 'dark',
        'notifications': false
      }
    },
    'friends': [],
    'metadata': <String, dynamic>{},
    'nothing': null
  };

  print(formatDynamicAsTree(data));
}