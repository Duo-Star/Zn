// 低 -> 高
//

// 赋值函数调用
// a=1 a="" a={} a=<> a=[] f(x)=x
// 前缀调用
// f() f{} f[] f"" f<>
// 符号调用
// + - * / ^ % & | ?= !=
// # - ~
// !
// 中缀调用
// {}f{} {}f() {}f<> {}f"" {}f[]
// ()f{} ()f() ()f<> ()f"" ()f[]
// <>f{} <>f() <>f<> <>f"" <>f[]
// ""f{} ""f() ""f<> ""f"" ""f[]
// []f{} []f() []f<> []f"" []f[]
//


// assignment: v.赋值；作业，任务；（工作等的）分配，指派；（财产、权利的）转让
// 赋值函数调用
// a=1 a="" a={} a=<> a=[] f(x)=x





import 'var.dart';
import '../lib.dart' as lib;
import 'function.dart';

// 是否为赋值 值类型 标签 代码
(bool, VarType, String, String) checkAssignment(String code) {
  String first = lib.findFirstNotBlankSign(code);
  // 开头不是字母直接pass
  if (!lib.isAlpha(first)) return (false, VarType.none, '', '');
  // 检查函数的带名定义
  var (isF, fInfo) = checkFunction(code);
  if (isF && fInfo['hasName']) {
    return (true, VarType.function, fInfo['name'], fInfo['fullFunCode']);
  }
  // 其他情况: a=1 a="" a={} a=<> a=[] a={}f{} a=f()
  // 排除 a()
  // 检查标签后
  RegExpMatch? match = RegExp(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b').firstMatch(code);
  int? labelEnd = match?.end;
  if (labelEnd != null) {
    String afterLabel = code.substring(labelEnd);
    String firstSignAfterLabel = lib.findFirstNotBlankSign(afterLabel);
    if (firstSignAfterLabel == '=') {
      int eqIndex = code.indexOf('=');
      if (eqIndex != -1) {
        String varCode = code.substring(eqIndex + 1).trim();
        return (true, varType(code), match?.group(0)??'', varCode);
      }
    }
  }
  return (false, VarType.none, '', '');
}

