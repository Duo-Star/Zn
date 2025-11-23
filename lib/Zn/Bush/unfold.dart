library;
// ------------------------------------------
// 这个文件是干啥的：
// 展开root及其子函数所有栽种值表达式
// 请运行
// ------------------------------------------
import 'div_bush.dart' as div_bush;
import 'lib.dart' as lib;

// 你说如果他是函数调用返回一个函数咋办？
// 傻孩子，我们只检查最外层特征，
// 那个他就是个“函数调用”啊！
// ?? for while loop 咋办？
// 那个他也是个“函数调用”啊！
// ----------------------------------------------
// 特征：
// {...}    (...){...}   // 但是一般人们不会把一个函数拉在这的
// a = {...}   a = (...){...}
// a(...)=...
// !!!!!!!!!!!!!!!!!!
// 是函数 = ( 存在根{}，根{}后无() ) 或 ( 1.字母前置 2.紧跟( 3.对称)后存在=)
//
//-----------------------------
// 函数的内在量是什么？
// @name String
// @hasName bool
// @parameter String   保留原始形式例如 (x, y)
// @hasParameter bool
// @bush List<String>
// @returnLabel String
//------------------------------
//
// 检查是否是函数，给出详细信息
List<dynamic> checkIfFunction(String code){
  code = code.trim();
  // 先检查是不是函数
  bool isF = false;
  bool isNormalF = false;
  bool isMathWayF = false;
  //
  List<dynamic> pairInfo = (lib.findPair(code, '{', '}'));
if (pairInfo[0]==false){
  return [false,];
}

  return [isF, 0];
}

void unfold(String code){
  List<String> rootBush = div_bush.divBush(code);
  for (String item in rootBush) {

  }

}
