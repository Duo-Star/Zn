import 'dart:math';
import 'Zn/DebugTools/format_out.dart' as format_out;

void pf(dynamic sth) {
  if (sth is Map || sth is List) {
    print(format_out.formatDynamicAsTree(sth));
  } else {
    print(sth);
  }
}

// 地址
class Address {
  List<int> address = [];
  Address(this.address);
  @override
  String toString() {
    return "@$address";
  }
}

//
enum DataType { nil, num, xf }

class Data {
  List<Data> value = [];
  DataType type = DataType.nil;
  //
  Data();
  //
}

//
enum OpType {
  none, // 空
  call, // 调用函数
  def, // 自定义函数
  sysCall, // 调用系统函数
  numb, // 存储数字
}

class Op {
  OpType type = OpType.none;
  List<dynamic> parameter = [];
  //
  Op(this.type, this.parameter);
  //
  Op numb(num n) {
    return Op(OpType.numb, [n]);
  }
//
  Op add(Address ad1, Address ad2) {
    return Op(OpType.sysCall, ['add', ad1, ad2]);
  }
//
  Op prt(Address ad) {
    return Op(OpType.sysCall, ['prt', ad]);
  }
  //
  Op def(List<Op> p) {
    return Op(OpType.def, [p]);
  }
  //
  //Op call()

}


//
class Zn {
  Data root = Data();
  //Fun program = Fun([]);
  //
  void run() {}
}

//
void main() {
  Zn zn = Zn();
  //zn.program = Fun([]);
}
