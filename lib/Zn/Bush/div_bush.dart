library;
// ------------------------------------------
// 这个文件是干啥的：
// 把传入字符串按灌木分割输出List<String>
// 请运行 List<String> list = divBush(code);
// ------------------------------------------
// 运行 test() 查看测试输出
// ------------------------------------------
import 'bracket_checker.dart';
import 'lib.dart';
import 'debug.dart';
//
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
        '= : . + - * / ^ ! % , > ] } ) ?'.split(' '),
      );
      bool have_2 = isAlpha(firstSign)|| isIn(firstSign, ['{']);
      return !(have_1 || have_2);
    } else if (taskType == ']') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '= : . + - * / ^ ! % , > ] } ) ?'.split(' '),
      );
      bool have_2 = isAlpha(firstSign);
      return !(have_1 || have_2);
    } else if (taskType == '>') {
      //
      bool have_1 = isIn(firstNotBlankSign, ': . + - * / ^ ! % , > ] } ) ?'.split(' '));
      bool have_2 = isAlpha(firstSign)||isIn(firstSign, '['.split(' '));
      return !(have_1 || have_2);
    } else if (taskType == '}') {
      //
      bool have_1 = isIn(firstNotBlankSign, ': . + - * / ^ ! % , > ] } ) ?'.split(' '));
      bool have_2 = isAlpha(firstSign)||isIn(firstSign, '('.split(' '));
      return !(have_1 || have_2);
    } else if (taskType == '"') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '" : . + - * / ^ ! % , > ] } ) ?'.split(' '),
      );
      bool have_2 = isAlpha(firstSign);
      return !(have_1 || have_2);
    } else if (taskType == '/number') {
      //
      bool have_1 = isIn(firstNotBlankSign, ': . + - * / ^ ! % , > ] } ) ?'.split(' '));
      bool have_2 = isIn(firstSign, ['']);
      return !(have_1 || have_2);
    } else if (taskType == '/label') {
      //
      bool have_1 = isIn(
        firstNotBlankSign,
        '= : . + - * / ^ ! % , > ] } )'.split(' '),
      );
      bool have_2 = isIn(firstSign, ['(', '[', '"', '<', '{']);
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
List<String> divBush(String code) {
  // 移除注释
  code = removeComments(code);
  // 任务列表
  List<DivTask> taskList = [];
  // 代码片段
  List<String> bushes = [];
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
    bushes.add(frag.trim());
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
    fix(bushes, checkAngleBrackets);
    fix(bushes, checkCurlyBraces);
    fix(bushes, checkDoubleQuotes);
    fix(bushes, checkParentheses);
    fix(bushes, checkSquareBrackets);
  }
  fixAll();
  return bushes;
}


void test() {
  String code = '';
  code = debugTests[2];
  List<String> list = divBush(code);
  print('-----------------------');
  for (String item in list) {
    print(item);
  }

}
