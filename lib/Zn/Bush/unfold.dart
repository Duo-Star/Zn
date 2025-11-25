library;

// ------------------------------------------
// 这个文件是干啥的：
// 展开root及其子函数所有栽种值表达式
// 请运行
// ------------------------------------------
import 'div_bush.dart' as div_bush;
import 'lib.dart' as lib;
//
import 'Classify/function.dart';
import 'Classify/assignment.dart';

// 1. 是不是函数定义
// 2. 是不是标签
// 3. 是不是数字
// 4. 是不是字符串
// 5. 是不是向量
// 6. 是不是表
// -----------------------
// 7. 函数前缀调用
// 8.
//
// ---------------------------------------------
//
enum PlantType { bush, tree, forest}

//
class Plant {
  late PlantType type;
  List<Plant> body = [];
  String code = '';
  //
  Plant(this.type, this.body, this.code);
}

// 单一表达式
class Bush extends Plant {
  Bush(String code) : super(PlantType.bush, [], code);
}

// 函数体
class Tree extends Plant {
  Tree(List<Plant> bushes, ) : super(PlantType.tree, bushes, '');
  void add(Plant code){
    super.body.add(code);
  }
}

// 主函数
class Forest extends Plant {
  Forest(List<Plant> plants) : super(PlantType.forest, plants, '');
}

//
Tree tree(String code) {
  //
  Tree resultTree = Tree([]);
  //
  List<String> rootBush = div_bush.divBush(code);
  //
  for (String source in rootBush) {
    String item = lib.killUselessParentheses(source);
    var (isF, fInfo) = checkFunction(item);
    print('源:"$source", 即:"$item" 函数:[ $isF, $fInfo ]');
    if (isF){
    // resultTree.add(source);
    } else {

    }
  }
  return resultTree;
}




// -------------------------------------------------------------------------------
//
List<Map> forest(String code) {
  //
  //Forest forest = Forest([]);
  List<Map> map = [];
  //
  List<String> rootBush = div_bush.divBush(code);
  // print(rootBush);
  //
  for (String source in rootBush) {
    String item = lib.killUselessParentheses(source);
    var (isF, fInfo) = checkFunction(item);
    // print('源:"$source", 即:"$item" 函数:[ $isF, $fInfo ]');
    if (isF){
      map.add({"类型":'函数',
        '信息':fInfo.toString(),
        '树': forest(fInfo['funCode'])});
    } else {
      map.add({"类型":'灌木', "代码:":source});
    }
  }
  //
  return map;
}
