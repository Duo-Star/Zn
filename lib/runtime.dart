import 'dart:math';

import 'Zn/DebugTools/format_out.dart' as format_out;
import 'sys_fun.dart';

//
void pf(dynamic sth) {
  if (sth is Map || sth is List) {
    print(format_out.formatDynamicAsTree(sth));
  } else {
    print(sth);
  }
}


enum Type {
  nil,
  num,
  fun,
  rt,
  //
  change,
  changeV,
  //
  sysFunCall,
  sysFunCallV,
  call,
  //
  get,
  address,
  x,

}

//
class Data {
  List<Data> instructionList = []; // 保留原指令
  List<Data> runtimeValue = []; // 会替换成值
  dynamic value; // 存储 Dart值
  Type type = Type.nil; // 标注类型
  //

  // 地址索引
  Data get(Data ad, {Data? env}) {
    env = env ?? this;
    List<Data> c = env.runtimeValue;
    Data d = Data();
    for (int i in ad.value[0]) {
      d = c[i - 1];
      c = d.runtimeValue;
    }
    return d;
  }

  //
  Data getL(Data ad, {Data? env}) {
    env = env ?? this;
    List<Data> c = env.instructionList;
    Data d = Data();
    for (int i in ad.value[0]) {
      d = c[i - 1];
      c = d.instructionList;
    }
    return d;
  }

  //
  // 替换
  void changeV(Data ad, Data newData, {Data? env}) {
    env = env ?? this;
    // 如果地址为空，替换当前对象
    if (ad.value[0].isEmpty) {
      env.instructionList = newData.instructionList;
      env.runtimeValue = newData.runtimeValue;
      env.value = newData.value;
      env.type = newData.type;
      return;
    }
    List<Data> c = env.runtimeValue;
    // 遍历到倒数第二个索引（找到父节点）
    for (int i = 0; i < ad.value[0].length - 1; i++) {
      int index = ad.value[0][i] - 1;
      // 边界检查
      if (index < 0 || index >= c.length) {
        throw Exception('Index ${ad.value[0]}[i] out of bounds at position $i');
      }
      c = c[index].runtimeValue;
    }
    // 替换最后一个索引位置的 Data
    int lastIndex = ad.value[0].last - 1;
    if (lastIndex < 0 || lastIndex >= c.length) {
      throw Exception('Index ${ad.value[0].last} out of bounds');
    }
    c[lastIndex] = newData;
  }

  //
  //
  Data run({Data? env}) {
    env = env ?? this;
    for (int i = 0; i < instructionList.length; i++) {
      Data it = instructionList[i];
      if (it.type == Type.change) {
        //
        changeV(it.value[0], get(it.value[1], env: env), env: env);
      } else if (it.type == Type.changeV) {
        //
        changeV(it.value[0], it.value[1], env: env);
      } else if (it.type == Type.call) {
        pf('aaa${it.value[0]}** ${get(it.value[0], env:env )}');
        runtimeValue[i] = getL(it.value[0], env: env).run(env: env);
      } else if (it.type == Type.sysFunCall) {
        pf(it);
        Data result = sysFunPool[it.value[0]]!(env, it);
        runtimeValue[i] = result;
      } else if (it.type == Type.sysFunCallV) {
        pf(it.value);
        sysFunPoolV[it.value[0]]!(env, it);
      } else if (it.type == Type.rt) {

        break;
      }
    }
    Data result = runtimeValue.last;
    return result;
  }

  //
  @override
  String toString() {
    if (type == Type.num) {
      return '[num:$value]';
    } else if (type == Type.change) {
      return '[change:${value[0]} -> ${value[1]}]';
    } else if (type == Type.sysFunCall) {
      return '[$type:${value[0]}(${value[1]})]';
    }  else if (type == Type.address) {
      return '[$type:${value[0]}(${value[1]})]';
    } else {
      return '[$type: - program:$instructionList - data:$runtimeValue]';
    }
  }
}


//
void main() {
  pf('demo');
  Data p = fun([
    numb(0),
    numb(1),
    numb(5),
    fun([
      mAdd(a([1]), a([2])),
      cng(a([1]), a([4, 1])),
      mLess(a([1]), a([3])),
      prt(a([1])),
      callIf(a([4, 3]), a([4])),
    ]),
    call(a([4]), []),
    mSin(a([1])),
    prt(a([6])),
    numb(114514),
    fun([
      prt(a([8])),
    ]),
    numb(3),
    loop(a([9]), a([10])),
    prtV(numb(222)),
  ]);

//
  p = fun([
    fun([
      x(),
      numb(1, label: 'a'),
      prt(a([1,1])),
      rt(a([1]), a([1,1])),
    ]),
    call(a([1]), []),
  ]);

  //pf(p);
  Data result = p.run();
  pf('finish: program finish with $result');
  //pf(p);
}
