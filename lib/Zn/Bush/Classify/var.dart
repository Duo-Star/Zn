// 量
// 1 "" <> [] {} (){}

import 'function.dart';
import '../lib.dart' as lib;

//
enum VarType { number, string, vector, map, function, none }

// 检查是不是量
// 1
bool isVar(String code) {
  // TODO
  return false;
}

//
VarType varType(String code) {
  var (isF, fInfo) = checkFunction(code);
  if (isF && !fInfo['hasName']) {
    // (){} {}
    return VarType.function;
  }
  code = lib.killUselessParentheses(code);
  switch (lib.findFirstNotBlankSign(code)) {
    case ('['):
      return VarType.map;
    case ('<'):
      return VarType.vector;
    case ('"'):
      return VarType.string;
  }
  return VarType.number;
}
