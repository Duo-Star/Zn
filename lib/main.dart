import 'dart:async';

import 'package:flutter/material.dart';
import 'Zn/Bush/div_bush.dart' as div_bush;
import 'Zn/Bush/unfold.dart' as unfold;
import 'Zn/Bush/debug.dart' as bush_debug;
import 'Zn/Bush/lib.dart' as lib;
import 'Zn/DebugTools/format_out.dart' as format_out;
import 'Zn/Bush/Classify/compound.dart';
import 'Zn/Bush/Classify/assignment.dart';
import 'Zn/Bush/Classify/function.dart';



void main() {
  runApp(const MyApp());
  // div_bush.test();

  void pf(dynamic sth){
    if (sth is Map || sth is List){
      print(format_out.formatDynamicAsTree(sth));
    }else{
      print(sth);
    }
  }

  //print(lib.killUselessParentheses(' (code)11'));

  List<String> d = [
    '1','{}',
    'a=1','a=<>','a=[]','a=""',
    'a()=0','a={}','a=(){}'
  ];

  d.forEach((String s){
    pf(checkAssignment(s));
  });

  // testCheckFunction();

  // pf(checkCompound('< 1 2 3 >'));



  String code = bush_debug.debugTests[2];
  //code = '''z {{m n} b} c''';
  code = '''
a=<>:fill(20, (i){rand()*100})
isPrime=(i){ << r f=(k){k+=2 {r=0}??(i?%k)} (f)loop(i-2) r=1 }
F = (x){ ({1}??(x <= 1):{x * F(x-1)})() }
F(x) = ({1}??(x <= 1):{x * F(x-1)})()
F(x)=1?(x<=1):x*F(x-1)
Factorial = (x){ << r {r = 1}??(x <= 1) r = x * f(x-1) }
1 1?1 {<< 1}() {1}() (x){x}(1) {1}??(1)() {<<r r=1}() (i){i}loop(1) (x){<<r r=x}(1)
(a bb ccc){dd ee ff}(1 2 33)
''';

  code = '''
a=(){x y z {1 2 {{}}}}

''';

  List<Map> map = unfold.forest(code);

  // pf(map);

  List<String> s = div_bush.divBush('''
a 1 "" <> [] {} () abc 1.23
(1) ("") (<>) ({}) ([]) ((1))
a=1 a="" a=<> a=[]
a=(){} a()=0 a={}
f() {}() (){}()
{}f{} {}f() {}f<> {}f"" {}f[]
()f{} ()f() ()f<> ()f"" ()f[]
<>f{} <>f() <>f<> <>f"" <>f[]
""f{} ""f() ""f<> ""f"" ""f[]
[]f{} []f() []f<> []f"" []f[]
1 + 1 - 3 * 4 / 5 ^ 6 ?= 5 % 2 != 5 //?< 8 ?> 7 <= 4 >= 3 
(-1)
()?() {}?() ""?() <>?() []?()
{}??():{}
<>.a  <>[1]  <>:a
<>.a()
a.a a[1] a:a
a.a=1 a[1]=1
a=[ b=[<>, { x +45 6 -3  f() {}f"" }, <1-f(), "">] ]
x +456 -3
x +4 5 6 -3
(+123)
''');

  // pf(s);

}

class Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 先绘制黑色背景
    canvas.drawColor(Colors.black54, BlendMode.srcIn);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Widget> w = [
    Text('000000'),
    MaterialButton(onPressed: (){}),
  ];

   int i = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            w[i],
            /*
            Center(
              child: CustomPaint(
                size: Size(200, 200), // 画布大小
                painter: Painter(),
              ),
            ),
             */

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
