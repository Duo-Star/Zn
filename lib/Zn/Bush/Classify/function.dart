import '../lib.dart' as lib;

// 特征：
// {...}    (...){...}   // 但是一般人们不会把一个函数拉在这的
// a = {...}   a = (...){...}
// a(...)=...
// !!!!!!!!!!!!!!!!!!
// 是函数 = ( 存在根{}，根{}后无() ) 或 ( 1.字母前置 2.紧跟( 3.对称)后存在=)
//-----------------------------------------------
// 你说如果他是函数调用返回一个函数咋办？
// 傻孩子，我们只检查最外层特征，
// 那个他就是个“函数调用”啊！
// ?? for while loop 咋办？
// 那个他也是个“函数调用”啊！
// ----------------------------------------------
// 函数的内在量是什么？
// @isF bool
// @name String
// @hasName bool
// @parameter String   保留原始形式例如 (x, y)
// @hasParameter bool
// @bush List<String>
// @hasReturnLabel bool
// @returnLabel String
//------------------------------
//
// 检查是否是函数，给出详细信息
(bool, Map<String, dynamic>) checkFunction(String code) {
  code = code.trim();
  // 先检查是不是函数
  bool isF = false;
  bool isNormalF = false;
  bool isMathWayF = false;
  // 函数细节
  bool hasName = false;
  bool hasParameter = false;
  bool hasReturnLabel = false;
  // 函数细节
  String? name = '';
  String parameter = '';
  String funCode = ''; // 代码没有{}
  String? returnLabel = '';
  String fullFunCode = '';// 包含() {}
  // 核心检查函数
  bool core(String code) {
    String firstNotBlankSign = lib.findFirstNotBlankSign(code);
    if (firstNotBlankSign == '(') {
      // (...){...}
      List<dynamic> pairInfo = (lib.findPair(code, '(', ')'));
      String inParentheses = code.substring(pairInfo[2], pairInfo[3]);
      // 参数
      parameter = inParentheses;
      hasParameter = parameter != '()';
      String after = code.substring(pairInfo[3]);
      if (lib.findFirstNotBlankSign(after) == '{') {
        List<dynamic> pairInfo = lib.findPair(after, '{', '}');
        funCode = after.substring(pairInfo[2] + 1, pairInfo[3] - 1);
        fullFunCode = code;
        String afterFEnd = after.substring(pairInfo[3]);
        bool hasCall = afterFEnd.contains('(');
        bool asParameter = lib.isAlpha(lib.findFirstNotBlankSign(afterFEnd));
        return (!hasCall) && (!asParameter);
      }
    } else if (firstNotBlankSign == '{') {
      // {...}
      hasParameter = false;
      List<dynamic> pairInfo = (lib.findPair(code, '{', '}'));
      funCode = code.substring(pairInfo[2] + 1, pairInfo[3] - 1);
      fullFunCode = code;
      String afterFEnd = code.substring(pairInfo[3]);
      bool hasCall = afterFEnd.contains('(');
      bool asParameter = lib.isAlpha(lib.findFirstNotBlankSign(afterFEnd));
      return (!hasCall) && (!asParameter);
    }
    return false;
  }

  //
  isNormalF = core(code);
  //
  if (lib.isAlpha(lib.findFirstNotBlankSign(code))) {
    RegExpMatch? match = RegExp(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b').firstMatch(code);
    // 函数名
    hasName = true;
    name = (match?.group(0));
    //
    int? labelEnd = match?.end;
    if (labelEnd != null) {
      String afterLabel = code.substring(labelEnd);
      String firstSignAfterLabel = lib.findFirstNotBlankSign(afterLabel);
      if (firstSignAfterLabel == '=') {
        int eqIndex = code.indexOf('=');
        if (eqIndex != -1) {
          if (core(code.substring(eqIndex + 1).trim())) {
            // f = (){}   or   f = {}
            isNormalF = true;
          }
        }
      } else if (firstSignAfterLabel == '(') {
        // 开始检查 f(x) = x
        int indexOfFirstParentheses = lib.findPair(afterLabel, '(', ')')[3];
        // 参数
        parameter = afterLabel.substring(0, indexOfFirstParentheses);
        hasParameter = parameter != '()';
        String afterFirstParentheses = afterLabel.substring(
          indexOfFirstParentheses,
        );
        isMathWayF = lib.findFirstNotBlankSign(afterFirstParentheses) == '=';
        int afEqIndex = afterFirstParentheses.indexOf('=');
        String afEq = afterFirstParentheses.substring(afEqIndex + 1);
        // 代码
        funCode = afEq;
        fullFunCode = '{$afEq}';
      }
    }
  }
  // 判断是不是函数
  isF = isMathWayF || isNormalF;
  // 计算返回值标签
  if (isF) {
    int retIndex = funCode.indexOf('<<');
    if (retIndex != -1) {
      hasReturnLabel = true;
      String afRt = (funCode.substring(retIndex + 2));
      RegExpMatch? match = RegExp(
        r'\b[a-zA-Z_][a-zA-Z0-9_]*\b',
      ).firstMatch(afRt);
      returnLabel = (match?.group(0));
    }
  }
  //
  funCode = funCode.trim();
  // 返回
  return (
  isF,
  {
    'hasName': hasName, //
    'hasParameter': hasParameter, //
    'name': name, //
    'hasReturnLabel': hasReturnLabel, //
    'parameter': parameter, //
    'funCode': funCode, //
    'returnLabel': returnLabel,
    'isMathWayF': isMathWayF, //
    'fullFunCode': fullFunCode
  },
  );
}

void testCheckFunction() {
  List<String> expressions = [
    '{1?1}',
    '(){i love u}',
    '(x yz){welcome zn}',
    'a = (){hello world}',
    'a = (x, yz){hhh kkk}',
    'a = {1+1}',
    'f(x)=x',
    'f()=1',
    '{}(1)',
    '(){}()',
    '{1 {}() 1+2}',
    'f(x y) = x^2 + y^2 -1',
    'f = (){<< r r=1}',
  ];

  for (String expression in expressions) {
    var (isFunction, details) = checkFunction(expression);
    print('表达式: "$expression" -> $isFunction, $details');
  }
}
