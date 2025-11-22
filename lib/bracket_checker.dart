library;

// {}
bool checkCurlyBraces(String code) {
  final inString = _StringTracker();
  final stack = <String>[];

  for (int i = 0; i < code.length; i++) {
    final char = code[i];
    inString.update(char);

    if (!inString.isInString) {
      if (char == '{') {
        stack.add(char);
      } else if (char == '}') {
        if (stack.isEmpty || stack.last != '{') return false;
        stack.removeLast();
      }
    }
  }

  return stack.isEmpty;
}

// []
bool checkSquareBrackets(String code) {
  final inString = _StringTracker();
  final stack = <String>[];

  for (int i = 0; i < code.length; i++) {
    final char = code[i];
    inString.update(char);

    if (!inString.isInString) {
      if (char == '[') {
        stack.add(char);
      } else if (char == ']') {
        if (stack.isEmpty || stack.last != '[') return false;
        stack.removeLast();
      }
    }
  }

  return stack.isEmpty;
}


// <>
bool checkAngleBrackets(String code) {
  final inString = _StringTracker();
  final stack = <String>[];
  code = code.replaceAll(RegExp(r'<->|<<|<-|->|<=|=>|\?<|\?>'), ' ');
  for (int i = 0; i < code.length; i++) {
    final char = code[i];
    inString.update(char);
    if (!inString.isInString) {
      if (char == '<') {
        stack.add(char);
      } else if (char == '>') {
        if (stack.isEmpty || stack.last != '<') return false;
        stack.removeLast();
      }
    }
  }
  return stack.isEmpty;
}


// ()
bool checkParentheses(String code) {
  final inString = _StringTracker();
  final stack = <String>[];

  for (int i = 0; i < code.length; i++) {
    final char = code[i];
    inString.update(char);

    if (!inString.isInString) {
      if (char == '(') {
        stack.add(char);
      } else if (char == ')') {
        if (stack.isEmpty || stack.last != '(') return false;
        stack.removeLast();
      }
    }
  }

  return stack.isEmpty;
}

// ""
bool checkDoubleQuotes(String code) {
  final stack = <String>[];
  bool isEscaped = false;

  for (int i = 0; i < code.length; i++) {
    final char = code[i];

    if (char == '\\') {
      isEscaped = !isEscaped;
      continue;
    }

    if (char == '"' && !isEscaped) {
      if (stack.isNotEmpty && stack.last == '"') {
        stack.removeLast();
      } else {
        stack.add(char);
      }
    }

    isEscaped = false;
  }

  return stack.isEmpty;
}

// 辅助类：跟踪字符串状态（忽略转义字符的处理）
class _StringTracker {
  bool _isInString = false;
  bool _isEscaped = false;

  bool get isInString => _isInString;

  void update(String char) {
    if (char == '\\' && _isInString) {
      _isEscaped = !_isEscaped;
      return;
    }

    if (char == '"' && !_isEscaped) {
      _isInString = !_isInString;
    }

    _isEscaped = false;
  }
}