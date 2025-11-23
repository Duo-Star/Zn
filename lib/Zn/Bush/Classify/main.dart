import '../div_bush.dart';

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



class BushFunction {

}

/*
root
  |-
 */


