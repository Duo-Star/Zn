//
import '../Zn/DebugTools/format_out.dart' as format_out;

void pf(dynamic sth) {
  if (sth is Map || sth is List) {
    print(format_out.formatDynamicAsTree(sth));
  } else {
    print(sth);
  }
}
void p_([String? s]){
  pf('-----------------${s??'div'}-----------------');
}

//
enum Type {
  // value
  address, // address
  tree, // tree
  num, // num
  nil, // nil
  // tree op
  call, // call tree as function
  grow, // run tree as list
  ind, // tree value index
  pInd, // tree program index
  ret, // return
  // value op
  label,
  cng, // change
  get, // get
  clr, // clear
  // system
  sysCall,
}

class Z {
  List<dynamic> data = []; // 自由值
  List<Z> program = []; // 程序
  List<Z> value = []; // 运行值
  Type type = Type.nil; // 类型
  //
  List<String> parameterLabels = [];
  List<Z> temp = []; // 临时寄存器
  Map<String, Z> map = {}; // 标签映射表 映射到地址或是值
  String label = '/';
  // 空值
  static Z nil() => Z()..type = Type.nil;

  // 数字
  static Z nNum(num n, {label = '/'}) {
    return Z()
      ..type = Type.num
      ..data = [n]
      ..label = label;
  }

  //
  num get gNum => data[0];
  bool get isNum => type == Type.num;
  // --
  // --
  // 地址
  static Z nAddress(List<int> address, {label = '/'}) {
    return Z()
      ..type = Type.address
      ..data = [address]
      ..label = label;
  }

  // get
  List<int> get gAddress => data[0];
  bool get isAddress => type == Type.address;
  // --
  // --
  // 树
  static Z nTree(List<Z> program, {String label = '/'}) {
    return Z()
      ..type = Type.tree
      ..program = program
      ..label = label;
  }

  // --
  // --
  // call
  static Z nCall(Z f, {List<Z>? p, String label = '/'}) {
    return Z()
      ..type = Type.call
      ..data = [f, p ?? []]
      ..label = label;
  }

  //
  static Z nLabel(String lb) {
    return Z()
      ..type = Type.label
      ..data = [lb];
  }

  // 静态方法，不依赖于实例
  static Z getZByAddress(Z rootZ, List<int> address) {
    if (address.isEmpty) return Z.nil();
    Z current = rootZ;
    for (int index in address) {
      if (index < 0 || index >= current!.program.length) {
        return Z.nil();
      }
      current = current.program[index];
    }
    return current;
  }

  // 针对所有类型，是统一运行接口
  Z run({
    required int i, // 我在父环境的索引
    required List<int> faAddress, // 父环境地址
    required List<int> myAddress, // 我的地址
    required Map<String, Z> givenMap, // 标签环境
    required Z rootZ, // 根环境
  }) {
    p_('run-start');
    pf(
      'run-start 语句地址：$myAddress (所在地址:$faAddress，索引:$i) 祖传映射表: $givenMap 根环境: $rootZ',
    );
    // 在所在地址中注册位置
    faAddress.add(i);
    // 预设结果
    Z result = this;
    //
    switch (type) {
      case Type.tree:
        // 表明树，注意在这里不求值
        // call grow
        pf('run-tree do none');
        break;
      case Type.address:
        pf('run-address do none');
        break;
      case Type.num:
        pf('run-num 将数字：${data[0]} 放在：@$faAddress 标签为：$label');
        break;
      case Type.nil:
        pf('run-nil do none');
        break;
      case Type.call:
        // call 树
        // 处理 参差不齐 的 函数：地址/标签/值
        Z f = data[0];
        List<int> fAddress = [];
        if (f.type == Type.address) {
          // ok
          fAddress = f.gAddress;
        } else if (f.type == Type.label) {
          // label 2 address
          fAddress = (givenMap[f.data[0]])!.gAddress;
        } else if (f.type == Type.tree) {
          // save tree and give address
          program.insert(0, f); // save
          List<int> tempAds = List.from(myAddress);
          tempAds.add(0);
          fAddress = tempAds;
        } else {
          pf('run-call 你只能对函数使用call，而不是对：${f.type}使用');
        }
        // 处理 参差不齐 的 参数值：地址/标签/值
        List<Z> p = data[1];
        //
        pf('run-call 发现函数调用语法：函数位于$fAddress，启动参数：');
        Z fZ = getZByAddress(rootZ, fAddress);
        fZ.call(
          addressZ: Z.nAddress(myAddress),
          rootZ: rootZ,
          givenMap: Map.from(givenMap),
        );

        break;

      case Type.grow:
        break;

      case Type.ind:
        break;

      case Type.pInd:
        break;

      case Type.ret:
        break;

      case Type.cng:
        break;

      case Type.get:
        break;

      case Type.clr:
        break;

      case Type.sysCall:
        break;
      case Type.label:
        break;
    }
    p_('run-end');
    return result;
  }

  // 针对tree的调用，程序入口
  Z call({Z? addressZ, Z? rootZ, Map<String, Z>? givenMap}) {
    final myAddressZ = addressZ ?? Z.nAddress([]);
    pf('call-start 函数调用，call语法位置：$myAddressZ');
    List<int> address = myAddressZ.gAddress; // 获取地址
    final Z myRootZ = rootZ ?? this; // 如果rootZ为null，使用当前实例，理论上只有根程序可以
    final Map<String, Z> myGivenMap = givenMap ?? map; // 上层注意复制
    // 遍历程序列
    for (int i = 0; i < program.length; i++) {
      Z item = program[i]; // 获取每一个命令
      // myAddress
      List<int> x = List.from(address);
      x.add(i);
      Z myAddress = Z.nAddress(x);
      // 建立映射表
      if (item.label != '/') {
        if (myGivenMap.containsKey(item.label)) {
          pf('call-map 已存在${item.label} 执行函数内覆盖，函数内重定向到$myAddress');
        } else {
          pf('call-map 新建立映射${item.label} -> $myAddress');
        }
        myGivenMap[item.label] = myAddress;
      } else {
        pf('call-map 无标签，跳过建立映射');
      }
      // 运行
      Z runResult = item.run(
        i: i, // 父环境的索引
        faAddress: List.from(address), // 父环境地址
        myAddress: myAddress.gAddress,
        givenMap: Map.from(myGivenMap), // 标签环境
        rootZ: myRootZ, // 根环境
      );
      pf('call-item 获得run结果：[$runResult] 保存位于：${myAddress.gAddress}');
      value.insert(i, runResult); // 将运行结果插入值列
    }
    pf('call-end 尾值：${value.last}');
    return value.last; // 函数返回尾值
  }

  @override
  String toString() {
    switch (type) {
      case Type.tree:
        return 'tree-program:$program, value:$value, label:$label';
      case Type.address:
        return '@${data[0]}';
      case Type.num:
        return 'num-N<${data[0]}>, label:$label';
      case Type.nil:
        return 'nil';
      case Type.call:
        return 'call';
      case Type.grow:
        return 'grow';
      case Type.ind:
        return 'ind';
      case Type.pInd:
        return 'pInd';
      case Type.ret:
        return 'ret';
      case Type.cng:
        return 'cng';
      case Type.get:
        return 'get';
      case Type.clr:
        return 'clr';
      case Type.sysCall:
        return 'sysCall';
      case Type.label:
        return 'label';
    }
  }
}

void main() {
  Z z = Z.nTree([
    Z.nNum(label: 'a', 1),
    Z.nTree(label: 'f', [
      Z.nNum(label: 'a', 1),
    ]),
    Z.nCall(Z.nLabel('f')),
    Z.nCall(Z.nAddress([1])),
    Z.nCall(Z.nTree(label: 'f', [
      Z.nNum(label: 'a', 1),
    ])),

  ]);
  z.call();
  pf('root map:');
  pf(z.map);
}
