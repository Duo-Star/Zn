  
List<Unit> div(String code, List<Unit>? list) {  
  list = list ?? [];  
  code = code.trim();  
  String first = code[0];  
  if (first == '(') {  
    //去除()重新解析  
    list.add(div(match.killParentheses(code), [])[0]);  
  } else if (match.isDigit2(first)) {  
    list.add(Unit(first, UnitType.value, UnitSpecific.number));  
    print(code);  
    print(match.findPair(code, '<', '>'));  
  }  
  return list;  
}  
  
List<Unit> div222(String code) {  
  bool root = true;  
  String state = '';  
  for (int i = 0; i < code.length; i++) {  
    String char = code[i];  
    // 包括这个字符的之后的字符  
    String after = code.substring(i, code.length);  
  
    if (root) {  
      if (match.isAlpha(char)) {  
        // 从root进入string  
        // = ( .        //假如 abc=        state = 'root 2 str';  
        root = false;  
        int stopAt = match.findFirstOccurrence(after, ['=', '(', '.', ' ']);//3  
        String label = match.safeSubstring(after, i, stopAt);//abc  
        String sign = match.safeSubstring(after, stopAt, stopAt+1);// =  
        if (sign=='=') {  
  
        }      } else if (state == '') {  
      } else if (char == '<') {  
        List<dynamic> pairInfo = match.findPair(after, '<', '>');  
        String pairString = pairInfo[1];  
        String tail = match.safeSubstring(after, pairInfo[3], pairInfo[3] + 1);  
        print("tail:$tail");  
        print(match.isIn(tail, [':', '.', '[']));  
      }  
    } else {}  
  }  
  return [];  
}  
  
void main() {  
  //List<Unit> list = [];  
  //div('((0)) (2) <2>', list);  //print("-----\n$list");  //div(code);  div222('abc=');  
}