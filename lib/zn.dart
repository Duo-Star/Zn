import 'bracket_checker.dart' as bracket_checker;
import 'format_map.dart' as format_map;
// 匿名 Anonymous
// 参数 Parameter
// 期待 expect
// 括号 Parentheses

// 提取root种植，分析类型
// 类型
enum UnitType {
  value, // 值
  call, // 函数调用
}

// 具体
enum UnitSpecific {
  // 值
  label,
  number,
  string,
  vector,
  map,
  function,
  // 函数调用
  eqCall,
  labelCall,
  noParameterCall,
  parameterCall,
  centerCall,
  operatorCall,
  getCall,
  metaCall,
  getModifyCall,
}

class Unit {
  String source = '';
  late UnitType type;
  late UnitSpecific specific;
  //
  Unit(this.source, this.type, this.specific);
  //
  @override
  String toString() {
    return "Unit($source, $type, $specific)";
  }
}

// 列举所有可能种植情况（注意这些是直接在外面的）
String code = '''
// 值
a 1 "" <> [] {}
(1) ("") (<>) ({}) ([])
// 函数调用
// 1. = 赋值函数
a=1 a="" a=<> a={}
a=(){} a()=0 a=[]
// 2. 一般函数
f()  {}()  (){}()
{}f{} ()f() <>f<> ""f"" []f[]
// 3. 运算符
1 + 1
(-1)
// 4. 访问和操作()
<>.a  <>[1]  <>:a     //tt
<>.a() 
a.a a[1]  a:a       
a.a=1  a[1]=1

''';

bool isIn(String str, List<String> li) {
  for (String s in li) {
    if (str == s) {
      return true;
    }
  }
  return false;
}

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

class DivTask {
  String code = '';
  String taskType = '';
  int index = 0;
  DivTask(this.code, this.taskType, this.index);
  // 返回是否要切割
  bool run() {
    //
    String firstNotBlankSign = findFirstNotBlankSign(code);
    String firstSign = code.substring(0, 1);
    //
    if (taskType == ')') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '= : . + - * / , > ] } )'.split(' '),
      );
      bool have_2 = isIn(firstSign, ['{']);
      return !(have_1 || have_2);
    } else if (taskType == ']') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '= : . + - * / , > ] } )'.split(' '),
      );
      bool have_2 = isAlpha(firstSign);
      return !(have_1 || have_2);
    } else if (taskType == '>') {
      //
      bool have_1 = isIn(firstNotBlankSign, ': . + - * / , > ] } )'.split(' '));
      bool have_2 = isAlpha(firstSign);
      return !(have_1 || have_2);
    } else if (taskType == '}') {
      //
      bool have_1 = isIn(firstNotBlankSign, ': . + - * / , > ] } ) ?'.split(' '));
      bool have_2 = isAlpha(firstSign);
      return !(have_1 || have_2);
    } else if (taskType == '"') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '" : . + - * / , > ] } )'.split(' '),
      );
      bool have_2 = isAlpha(firstSign);
      return !(have_1 || have_2);
    } else if (taskType == '/number') {
      //
      bool have_1 = isIn(firstNotBlankSign, ': . + - * / , > ] } )'.split(' '));
      bool have_2 = isIn(firstSign, ['']);
      return !(have_1 || have_2);
    } else if (taskType == '/label') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '= : . + - * / , > ] } )'.split(' '),
      );
      bool have_2 = isIn(firstSign, ['(', '[', '"']);
      return !(have_1 || have_2);
    } else {
      print('? $taskType');
    }
    return false;
  }

  //
  @override
  String toString() {
    return 'code:$code, taskType:$taskType';
  }
}

// 分割树
List<String> divTree(String code) {
  // 移除注释
  code = removeComments(code);
  // 任务列表
  List<DivTask> taskList = [];
  // 代码片段
  List<String> trees = [];
  // 添加命令
  void addTask(String type) {
    RegExp regex;
    if (type == '/number') {
      // 匹配到十进制整数小数，不要匹配负数（不包含任何符号）
      regex = RegExp(r'\b\d+(?:\.\d+)?\b');
    } else if (type == '/label') {
      // 必须以字母或下划线开头后面可以跟0个或多个字母、数字或下划线
      regex = RegExp(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b');
    } else {
      // ) ] } > "
      regex = RegExp(r'[)\]}>"]');
    }
    Iterable<RegExpMatch> matches = regex.allMatches(code);
    List<RegExpMatch> matchList = matches.toList();
    for (var match in matchList) {
      String frag = code.substring(match.end);
      String taskType = (type == 'sign') ? match.group(0) ?? '' : type;
      taskList.add(DivTask(frag, taskType, match.end));
      //print('匹配内容："${match.group(0)}", 后续：$frag, taskType：$taskType');
    }
  }
  // 添加匹配
  addTask('sign');
  addTask('/number');
  addTask('/label');
  // 分割索引表
  List<int> splitAt = [];
  // 填充分割索引表
  for (DivTask dt in taskList) {
    bool shouldSplit = dt.run();
    if (shouldSplit) {
      splitAt.add(dt.index);
      //print(dt.index);
    }
  }
  // 排序，以便划分字符串
  splitAt.sort();
  // 划分字符串，代码片段
  for (int i = 0; i < splitAt.length; i++) {
    //print(splitAt[i]);
    String frag;
    if (i == 0) {
      frag = code.substring(0, splitAt[i]);
    } else {
      frag = code.substring(splitAt[i - 1], splitAt[i]);
    }
    trees.add(frag.trim());
  }
  // 整理括号完整性
  List<String> fix(List<String> trees, Function checkF) {
    bool ok = true;
    int illAt = 0;
    for (int i = 0; i < trees.length; i++) {
      String s = trees[i];
      bool health = checkF(s);
      if (health == false) {
        ok = false;
        illAt = i;
        // 一次只修一个错误
        break;
      }
    }
    if (ok) {
      return trees;
    } else {
      if (illAt < trees.length - 1) {
        trees[illAt] = "${trees[illAt]} ${trees[illAt + 1]}";
        trees.removeAt(illAt + 1);
        return fix(trees, checkF);
      } else {
        return trees;
      }
    }
  }

  void fixAll() {
    fix(trees, bracket_checker.checkAngleBrackets);
    fix(trees, bracket_checker.checkCurlyBraces);
    fix(trees, bracket_checker.checkDoubleQuotes);
    fix(trees, bracket_checker.checkParentheses);
    fix(trees, bracket_checker.checkSquareBrackets);
  }
  fixAll();
  return trees;
}
















void main() {
  //code = '() {} [] <> a abc 1 123 3.14 ';
  code = '''
a=<>:fill(20, (i){rand()*100}) n = #arr (i){swapped = 0 {r=arr} ?? (~swapped)}loop(n-1) (j){}loop(n-i) {arr[j] <-> arr[j+1]}??(swapped = arr[j] ?> arr[j + 1]) r=arr
''';

  List<String> list = divTree(code);
  print('-----------------------');
  for (String item in list) {
    print(item);
  }

}

























