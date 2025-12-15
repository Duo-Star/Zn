import 'dart:math';
import 'Zn/DebugTools/format_out.dart' as format_out;

import 'runtime.dart';

Map<String, Data Function(Data data, Data it)> sysFunPool = {
  'print': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    pf('--> out: ${it.value[1][0]}:$d');
    return d;
  },
  'sin': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    return numb(sin(d.value));
  },
  'add': (Data data, Data it) {
    List<Data> addNumsAddress = it.value[1];
    List<num> addNums = [];
    for (Data address in addNumsAddress) {
      addNums.add(data.get(address).value);
    }
    var r = numb(addNums.reduce((value, element) => value + element));
    pf('debug: add$addNumsAddress : $addNums = $r');
    return r;
  },
  // 算术运算符
  '+': (Data data, Data it) {
    List<num> nums = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return numb(nums[0] + nums[1]);
  },
  '-': (Data data, Data it) {
    List<num> nums = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return numb(nums[0] - nums[1]);
  },
  '*': (Data data, Data it) {
    List<num> nums = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return numb(nums[0] * nums[1]);
  },
  '/': (Data data, Data it) {
    List<num> nums = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    if (nums[1] == 0) {
      throw Exception('Division by zero');
    }
    return numb(nums[0] / nums[1]);
  },

  // 比较运算符（扩展）
  '<': (Data data, Data it) {
    List<num> dn = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return (dn[0] < dn[1]) ? numb(1) : numb(0);
  },
  '>': (Data data, Data it) {
    List<num> dn = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return (dn[0] > dn[1]) ? numb(1) : numb(0);
  },
  '<=': (Data data, Data it) {
    List<num> dn = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return (dn[0] <= dn[1]) ? numb(1) : numb(0);
  },
  '>=': (Data data, Data it) {
    List<num> dn = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return (dn[0] >= dn[1]) ? numb(1) : numb(0);
  },
  '==': (Data data, Data it) {
    List<Data> operands = [
      data.get(it.value[1][0]),
      data.get(it.value[1][1]),
    ];
    // 比较值和类型
    bool equal = operands[0].value == operands[1].value &&
        operands[0].type == operands[1].type;
    return equal ? numb(1) : numb(0);
  },
  '!=': (Data data, Data it) {
    List<Data> operands = [
      data.get(it.value[1][0]),
      data.get(it.value[1][1]),
    ];
    bool notEqual = operands[0].value != operands[1].value ||
        operands[0].type != operands[1].type;
    return notEqual ? numb(1) : numb(0);
  },

  // 逻辑运算符
  'and': (Data data, Data it) {
    List<Data> operands = it.value[1].map((address) => data.get(address)).toList();
    bool result = true;
    for (var operand in operands) {
      if (operand.value == 0) { // 假设0为false，非0为true
        result = false;
        break;
      }
    }
    return result ? numb(1) : numb(0);
  },
  'or': (Data data, Data it) {
    List<Data> operands = it.value[1].map((address) => data.get(address)).toList();
    bool result = false;
    for (var operand in operands) {
      if (operand.value != 0) { // 假设0为false，非0为true
        result = true;
        break;
      }
    }
    return result ? numb(1) : numb(0);
  },
  'not': (Data data, Data it) {
    Data operand = data.get(it.value[1][0]);
    return (operand.value == 0) ? numb(1) : numb(0);
  },

  // 流程控制
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
  'if-else': (Data data, Data it) {
    num condition = data.get(it.value[1][0]).value;
    Data trueBranch = data.getL(it.value[1][1]);
    Data falseBranch = data.getL(it.value[1][2]);

    pf('debug: if-else condition: $condition');
    if (condition == 1) {
      pf('debug: run true branch');
      return trueBranch.run(env: data);
    } else {
      pf('debug: run false branch');
      return falseBranch.run(env: data);
    }
  },
  'loop': (Data data, Data it) {
    Data f = data.getL(it.value[1][0]);
    num n = data.get(it.value[1][1]).value;
    Data result = nil();
    for (int i=0; i<n; i++){
      pf('debug: loop iteration $i');
      result = f.run(env: data);
    }
    return result;
  },

  // 额外的数学函数
  'sqrt': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    if (d.value < 0) {
      throw Exception('Square root of negative number');
    }
    return numb(sqrt(d.value));
  },
  'abs': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    return numb(d.value.abs());
  },
  'pow': (Data data, Data it) {
    List<num> nums = [
      data.get(it.value[1][0]).value,
      data.get(it.value[1][1]).value,
    ];
    return numb(pow(nums[0], nums[1]));
  },

  // 工具函数
  'nil?': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    return (d.type == 'nil') ? numb(1) : numb(0);
  },
  'number?': (Data data, Data it) {
    Data d = data.get(it.value[1][0]);
    return (d.type == 'number') ? numb(1) : numb(0);
  },
};


Map<String, Data Function(Data data, Data it)> sysFunPoolV = {
  'printV': (Data data, Data it) {
    pf('--> out: value - $it');
    return data;
  },
};





// ---------------------------------------------------------
// nil 空值
Data nil() {
  return Data()..type = Type.nil;
}

// 函数
Data fun(List<Data> list) {
  return Data()
    ..type = Type.fun
    ..instructionList = list
    ..runtimeValue = List<Data>.from(list);
}

// 数字
Data numb(num n,{label='_'}) {
  return Data()
    ..type = Type.num
    ..value = n;
}

// 地址，新值
Data cngV(Data address, Data data) {
  return Data()
    ..type = Type.changeV
    ..value = [address, data];
}

// 地址，新值地址
Data cng(Data address, Data newAddress) {
  return Data()
    ..type = Type.change
    ..value = [address, newAddress];
}

// 系统函数
Data sysFunCall(String name, List<Data> par) {
  return Data()
    ..type = Type.sysFunCall
    ..value = [name, par];
}

// 系统函数 - 值
Data sysFunCallV(String name, List<Data> d) {
  return Data()
    ..type = Type.sysFunCallV
    ..value = [name, d];
}

// 调取函数 「函数地址，参数地址」
Data call(Data address, List<Data> par) {
  return Data()
    ..type = Type.call
    ..value = [address, par];
}

// 打印
Data prt(Data address) {
  return sysFunCall('print', [address]);
}

// 打印-值
Data prtV(Data d) {
  return sysFunCallV('printV', [d]);
}

// 条件调用
Data callIf(Data cod, Data f) {
  return sysFunCall('if', [cod, f]);
}

// 循环
Data loop(Data f, Data n) {
  return sysFunCall('loop', [f, n]);
}

// 小于
Data mLess(Data a, Data b) {
  return sysFunCall('<', [a, b]);
}

// 大于
Data mGreater(Data a, Data b) {
  return sysFunCall('>', [a, b]);
}

// 小于等于
Data mLessEqual(Data a, Data b) {
  return sysFunCall('<=', [a, b]);
}

// 大于等于
Data mGreaterEqual(Data a, Data b) {
  return sysFunCall('>=', [a, b]);
}

// 等于
Data mEqual(Data a, Data b) {
  return sysFunCall('==', [a, b]);
}

// 不等于
Data mNotEqual(Data a, Data b) {
  return sysFunCall('!=', [a, b]);
}

// 加法
Data mAdd(Data a, Data b) {
  return sysFunCall('+', [a, b]);
}

// 减法
Data mSubtract(Data a, Data b) {
  return sysFunCall('-', [a, b]);
}

// 乘法
Data mMultiply(Data a, Data b) {
  return sysFunCall('*', [a, b]);
}

// 除法
Data mDivide(Data a, Data b) {
  return sysFunCall('/', [a, b]);
}

// 逻辑与
Data mAnd(Data a, Data b) {
  return sysFunCall('and', [a, b]);
}

// 逻辑或
Data mOr(Data a, Data b) {
  return sysFunCall('or', [a, b]);
}

// 逻辑非
Data mNot(Data a) {
  return sysFunCall('not', [a]);
}

// 正弦
Data mSin(Data a) {
  return sysFunCall('sin', [a]);
}

// 平方根
Data mSqrt(Data a) {
  return sysFunCall('sqrt', [a]);
}

// 绝对值
Data mAbs(Data a) {
  return sysFunCall('abs', [a]);
}

// 幂运算
Data mPow(Data base, Data exponent) {
  return sysFunCall('pow', [base, exponent]);
}

Data rt(Data fAddress, Data resultAddress){
  return Data()..type=Type.rt..value=resultAddress;
}


// 地址交换器
Data x() {
  return Data()..type=Type.x;
}

// 地址
Data a(List<int> address) {
  return Data()..value = [address];
}
