// 生成 AST Abstract Syntax Tree
// ------------------------------
// 单词表
// 匿名 Anonymous
// 参数 Parameter
// 期待 expect
// 括号 Parentheses

// ------------------------------
// 类型
enum NodeType {
  value, // 值
  call, // 函数调用
}

// 具体
enum NodeSpecific {
  // 值
  label, // a
  number, // 1.23
  string, // ""
  vector, // <>
  map, // []
  function, //
  // 函数调用
  eqCall, // a=1
  labelCall, // a
  noParameterCall, // a()
  parameterCall, // a(...)
  centerCall, // {}a{}
  operatorCall, // a+a
  getCall, // a.
  metaCall, // a:
  getModifyCall, // a.a = 1
}

class Node {
  String source = '';
  late NodeType type;
  late NodeSpecific specific;

  //
  Node(this.source, this.type, this.specific);
  //
  @override
  String toString() {
    return "Node($source, $type, $specific)";
  }
}

