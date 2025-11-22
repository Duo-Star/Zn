library;

// 以字母或下划线开头，后续可以是字母、数字、下划线
String variableNames = r'\b[a-zA-Z_][a-zA-Z0-9_]*\b';
// 数字
String number = r'\d';
// : + - * / , > ] } )   // 适用于 ] } > 数字
String n1 =  r'^\s*[:+\-*/,>\]})]';
// : + - * / , > ] } ) (   // 适用于标签
String n2 =  r'^\s*[=:+\-*/,>\]})]';



List<List<String>> div = [
  [r'\)', r'^\s*([=:+\-*/,>\]})]|\{)'],
  [r'\]', n1],
  [r'\}', n1, ''],
  [r'\>', n1],
  [number, n1],
  [variableNames, n2]
];
