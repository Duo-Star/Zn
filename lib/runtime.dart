import 'dart:math';

import 'Zn/DebugTools/format_out.dart' as format_out;

void pf(dynamic sth) {
  if (sth is Map || sth is List) {
    print(format_out.formatDynamicAsTree(sth));
  } else {
    print(sth);
  }
}

class Address {
  List<int> address = [];
  Address(this.address);
  @override
  String toString() {
    return "@$address";
  }
}

Map<String, Data Function(Data data, Data it)> sysFunPool = {
  'print': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    pf('--> out: ${it.value[1][0]}:$d');
    return d;
  },
  'sin': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    pf("sin $d.value");
    // pf('--> out: ${it.value[1][0]}:$d');
    return d;
  },
  'add': (Data data, Data it) {
    List<Address> addNumsAddress = it.value[1];
    List<num> addNums = [];
    for (Address address in addNumsAddress) {
      addNums.add(data.get(address).value);
    }
    var r = numb(addNums.reduce((value, element) => value + element));
    pf('debug: add$addNumsAddress : $addNums = $r');
    return r;
  },
  '<': (Data data, Data it) {
    List<num> dn = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return (dn[0] < dn[1]) ? numb(1) : numb(0);
  },
  'if': (Data data, Data it) {
    num boo = data.get(it.value[1][0]).value;
    Data f = data.getL(it.value[1][1]);
    Data result = nil();
    if (boo == 1) {
      pf('debug: runIF: $f');
      result = f.run(env: data);
    } else {
      pf('debug: notRunIF: $f');
    }
    return result;
  },
};

enum Type { nil, num, fun, change, changeV, sysFunCall, call, get }

class Data {
  List<Data> list = []; // 保留原指令
  List<Data> valueList = []; // 会替换成值
  dynamic value;
  Type type = Type.nil;
  //

  // 地址索引
  Data get(Address ad, {Data? env}) {
    env = env ?? this;
    List<Data> c = env.valueList;
    Data d = Data();
    for (int i in ad.address) {
      d = c[i - 1];
      c = d.valueList;
    }
    return d;
  }

  //
  Data getL(Address ad, {Data? env}) {
    env = env ?? this;
    List<Data> c = env.list;
    Data d = Data();
    for (int i in ad.address) {
      d = c[i - 1];
      c = d.list;
    }
    return d;
  }

  //
  // 替换
  void changeV(Address ad, Data newData, {Data? env}) {
    env = env ?? this;
    // 如果地址为空，替换当前对象
    if (ad.address.isEmpty) {
      env.list = newData.list;
      env.valueList = newData.valueList;
      env.value = newData.value;
      env.type = newData.type;
      return;
    }
    List<Data> c = env.valueList;
    // 遍历到倒数第二个索引（找到父节点）
    for (int i = 0; i < ad.address.length - 1; i++) {
      int index = ad.address[i] - 1;
      // 边界检查
      if (index < 0 || index >= c.length) {
        throw Exception('Index ${ad.address}[i] out of bounds at position $i');
      }
      c = c[index].valueList;
    }
    // 替换最后一个索引位置的 Data
    int lastIndex = ad.address.last - 1;
    if (lastIndex < 0 || lastIndex >= c.length) {
      throw Exception('Index ${ad.address.last} out of bounds');
    }
    c[lastIndex] = newData;
  }

  //
  //
  Data run({Data? env}) {
    env = env ?? this;
    for (int i = 0; i < list.length; i++) {
      Data it = list[i];
      if (it.type == Type.change) {
        //
        changeV(it.value[0], get(it.value[1], env: env), env: env);
      } else if (it.type == Type.changeV) {
        //
        changeV(it.value[0], it.value[1], env: env);
      } else if (it.type == Type.call) {
        //pf(get(it.value[0], env:env ));
        valueList[i] = getL(it.value[0], env: env).run(env: env);
      } else if (it.type == Type.sysFunCall) {
        //pf(it);
        Data result = sysFunPool[it.value[0]]!(env, it);
        valueList[i] = result;
      } else if (it.type == Type.get) {}
    }
    Data result = valueList.last;
    // pf("333$back");
    return result;
  }

  //
  @override
  String toString() {
    if (type == Type.num) {
      return '[$type:$value]';
    } else if (type == Type.change) {
      return '[$type:${value[0]} -> ${value[1]}]';
    } else if (type == Type.sysFunCall) {
      return '[$type:${value[0]}(${value[1]})]';
    } else {
      return '[$type: - program:$list - data:$valueList]';
    }
  }
}

// ---------------------------------------------------------
// nil
Data nil() {
  return Data()..type = Type.nil;
}

// 函数
Data fun(List<Data> list) {
  return Data()
    ..type = Type.fun
    ..list = list
    ..valueList = List<Data>.from(list);
}

// 数字
Data numb(num n) {
  return Data()
    ..type = Type.num
    ..value = n;
}

// 地址，新值
Data cngV(Address address, Data data) {
  return Data()
    ..type = Type.changeV
    ..value = [address, data];
}

// 地址，新值地址
Data cng(Address address, Address newAddress) {
  return Data()
    ..type = Type.change
    ..value = [address, newAddress];
}

// 系统函数
Data sysFunCall(String name, List<Address> par) {
  return Data()
    ..type = Type.sysFunCall
    ..value = [name, par];
}

// 调取函数 「函数地址，参数地址」
Data call(Address address, List<Address> par) {
  return Data()
    ..type = Type.call
    ..value = [address, par];
}

//
Data prt(Address address) {
  return sysFunCall('print', [address]);
}

//
Data callIf(Address cod, Address f) {
  return sysFunCall('if', [cod, f]);
}

//
Data lessThan(Address a, Address b) {
  return sysFunCall('<', [a, b]);
}

//
Data add(Address a, Address b) {
  return sysFunCall('add', [a, b]);
}

//
Data x() {
  return sysFunCall('x', []);
}

//
Address a(List<int> address) {
  return Address(address);
}

//
void main() {
  pf('demo');
  Data p = fun([
    numb(0),
    numb(1),
    numb(5),
    fun([
      add(a([1]), a([2])),
      cng(a([1]), a([4, 1])),
      lessThan(a([1]), a([3])),
      prt(a([1])),
      callIf(a([4, 3]), a([4])),
    ]),
    call(a([4]), []),
    sysFunCall('sin', [a([1])]),
    prt(a([5])),
  ]);

  //pf(p);
  p.run();
  //pf(p);

  /*
  zn------------
  x = 1
  f = (x){ x->2 }
  f(x)
  zn-p----------
  1 { _ [2 1]->2 } [2]([1])
   */
  Data p2 = fun([
    numb(1),
    fun([
      x(),
      cngV(a([2, 1]), numb(2)),
    ]),
    call(a([2]), [a([1])])
  ]);




}
