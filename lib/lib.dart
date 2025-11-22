library;

/// 判断字符串从 [index] 开始之后是否接着目标字符
/// 目标字符: : + - * / , > ] } )
/// 中间可以间隔若干个空白字符
bool isFollowedByTargetChars(String text, int index, RegExp? regex) {
  if (index < 0 || index >= text.length) return false;
  // 正则表达式：匹配0个或多个空白字符后跟着目标字符
  regex = regex ?? RegExp(r'^\s*[:+\-*/,>\]})]');
  // 从 index 位置开始检查子字符串
  String substring = text.substring(index);
  return regex.hasMatch(substring);
}

// 去除最外层括号，注意是最外层，你可以重复来剥洋葱，他只找第一对
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

// 寻找配对，他只找第一对
// [ok?, string, from, to]
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
  return [true, '($code) find error', expectFrom, expectTo + 1];
}

// （匹配0-9）
bool isDigit2(String char) {
  return RegExp(r'^\d$').hasMatch(char);
}

// （匹配a-zA-Z）
bool isAlpha(String char) {
  return RegExp(r'^[a-zA-Z]$').hasMatch(char);
}

// 字符中第一次出现...的地方索引
int findFirstOccurrence(String str, List<String> targets) {
  if (str.isEmpty) return -1;
  for (int i = 0; i < str.length; i++) {
    String char = str[i];
    if (targets.contains(char)) {
      return i;
    }
  }
  return -1;
}

bool isIn(String str, List<String> li){
  for (String s in li) {
    if (str==s) {
      return true;
    }
  }
  return false;
}


String safeSubstring(String str, int start, [int? end]) {
  if (str.isEmpty) return '';
  // 处理start边界
  if (start < 0) start = 0;
  if (start >= str.length) return '';
  // 处理end边界
  if (end == null) {
    end = str.length;
  } else {
    if (end < start) end = start;
    if (end > str.length) end = str.length;
  }
  // 确保start不超过end
  if (start > end) start = end;
  return str.substring(start, end);
}