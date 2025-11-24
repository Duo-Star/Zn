library;

// 是否在字符表中
bool isIn(String str, List<String> li) {
  for (String s in li) {
    if (str == s) {
      return true;
    }
  }
  return false;
}

// 寻找第一个非空字符
String findFirstNotBlankSign(String str) {
  if (str.isEmpty) return '/?';
  for (int i = 0; i < str.length; i++) {
    String char = str[i];
    if (!isIn(char, [' ', '\n', '\t'])) {
      return char;
    }
  }
  return '/?';
}

// （匹配a-zA-Z）
bool isAlpha(String char) {
  return RegExp(r'^[a-zA-Z]$').hasMatch(char);
}

// 移除注释// or /* */，其中""中不处理，\"为转义
String removeComments(String sourceCode) {
  StringBuffer result = StringBuffer();
  int i = 0;
  int length = sourceCode.length;
  while (i < length) {
    // 检查字符串字面量（单引号）
    if (sourceCode[i] == "'") {
      result.write("'");
      i++;
      while (i < length && sourceCode[i] != "'") {
        // 处理转义字符
        if (sourceCode[i] == '\\' && i + 1 < length) {
          result.write(sourceCode[i]);
          i++;
          result.write(sourceCode[i]);
          i++;
        } else {
          result.write(sourceCode[i]);
          i++;
        }
      }
      if (i < length) {
        result.write("'");
        i++;
      }
    }
    // 检查字符串字面量（双引号）
    else if (sourceCode[i] == '"') {
      result.write('"');
      i++;
      while (i < length && sourceCode[i] != '"') {
        // 处理转义字符
        if (sourceCode[i] == '\\' && i + 1 < length) {
          result.write(sourceCode[i]);
          i++;
          result.write(sourceCode[i]);
          i++;
        } else {
          result.write(sourceCode[i]);
          i++;
        }
      }
      if (i < length) {
        result.write('"');
        i++;
      }
    }
    // 检查单行注释
    else if (i + 1 < length &&
        sourceCode[i] == '/' &&
        sourceCode[i + 1] == '/') {
      // 跳过直到行尾或文件结束
      while (i < length && sourceCode[i] != '\n') {
        i++;
      }
      // 保留换行符以维持行号
      if (i < length && sourceCode[i] == '\n') {
        result.write('\n');
        i++;
      }
    }
    // 检查多行注释
    else if (i + 1 < length &&
        sourceCode[i] == '/' &&
        sourceCode[i + 1] == '*') {
      i += 2; // 跳过 '/*'
      // 跳过直到找到 '*/' 或文件结束
      while (i + 1 < length &&
          !(sourceCode[i] == '*' && sourceCode[i + 1] == '/')) {
        i++;
      }
      i += 2; // 跳过 '*/'
    }
    // 普通字符
    else {
      result.write(sourceCode[i]);
      i++;
    }
  }
  return result.toString();
}


/*
dart 写一个函数String adaptStr(String code){
把code中的""换成ÀÁ这是为了我区分上下引号
它作为一个自制的编程语言解析器，我的编程语言只有""这样一种字符串表达方法
如果在字符串中表示"符号，用户需要使用\转义，
所以你不要理会\"，而是只替换起语法作用的上下引号明白吗
 */
String adaptStr(String code) {
  StringBuffer result = StringBuffer();
  bool inString = false;
  bool escapeNext = false;
  for (int i = 0; i < code.length; i++) {
    String char = code[i];
    if (escapeNext) {
      // 当前字符被转义，直接添加到结果中
      result.write(char);
      escapeNext = false;
      continue;
    }
    if (char == '\\') {
      // 遇到转义符，标记下一个字符需要转义
      result.write(char);
      escapeNext = true;
      continue;
    }
    if (char == '"') {
      if (inString) {
        // 结束字符串，使用下引号 Á
        result.write('Á');
        inString = false;
      } else {
        // 开始字符串，使用上引号 À
        result.write('À');
        inString = true;
      }
    } else {
      // 普通字符，直接添加
      result.write(char);
    }
  }
  return result.toString();
}


// 寻找配对，他只找第一对
// [ok?, string, from, to]
// demo：
// findPair('a={{}', '{', '}') = [false, (a={{}) find error, 2, 1]
// findPair('a={{}}', '{', '}') = [true, {{}}, 2, 6]
List<dynamic> findPair(String code, String left, String right) {
  code = code.trim();
  int mm = 0;
  int expectFrom = 0;
  int expectTo = 0;
  for (int i = 0; i < code.length; i++) {
    String char = code[i];
    if (char == left) {
      if (mm == 0) {
        expectFrom = i;
      }
      mm += 1;
    } else if (char == right) {
      mm += (-1);
      if (mm == 0) {
        expectTo = i;
        return [
          true,
          code.substring(expectFrom, expectTo + 1),
          expectFrom,
          expectTo + 1,
        ];
      }
    }
  }
  return [false, '($code) find error', expectFrom, expectTo + 1];
}



// 去除<无用>的最外层括号(自动迭代)，例如：
//print(killUselessParentheses(' (code)'));   :code
//print(killUselessParentheses(' (((code)))'));   :code
//print(killUselessParentheses(' d(((code)))'));   : d(((code)))
String killUselessParentheses(String code){
  String firstNotBlankSign =  findFirstNotBlankSign(code);
  if (firstNotBlankSign == '('){
    String kill = killParentheses(code);
    return killUselessParentheses(kill);
  }
  return code;
}


// 不管括号在哪直接去除(只去除一次)
// 这会误伤：f()
String killParentheses(String code) {
  code = code.trim();
  int mm = 0;
  int expectFrom = 0;
  int expectTo = 0;
  for (int i = 0; i < code.length; i++) {
    String char = code[i];
    if (char == '(') {
      if (mm == 0) {
        expectFrom = i;
      }
      mm += 1;
    } else if (char == ')') {
      mm += (-1);
      if (mm == 0) {
        expectTo = i;
        return code.substring(expectFrom + 1, expectTo);
      }
    }
  }
  return '($code) killParentheses error';
}

