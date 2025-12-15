import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zn/Zn/Bush/Classify/call.dart';
import 'Zn/Bush/div_bush.dart' as div_bush;
import 'Zn/Bush/unfold.dart' as unfold;
import 'Zn/Bush/debug.dart' as bush_debug;
import 'Zn/Bush/lib.dart' as lib;
import 'Zn/DebugTools/format_out.dart' as format_out;
import 'Zn/Bush/Classify/compound.dart';
import 'Zn/Bush/Classify/assignment.dart';
import 'Zn/Bush/Classify/function.dart';

//
import 'runtime/main.dart' as runtime;

//
void main() {
  runApp(const MyApp());

  ///
  runtime.main();

  // div_bush.test();

  void pf(dynamic sth) {
    if (sth is Map || sth is List) {
      print(format_out.formatDynamicAsTree(sth));
    } else {
      print(sth);
    }
  }

  //print(lib.killUselessParentheses(' (code)11'));

  List<String> d = [
    '1',
    '{}',
    'a=1',
    'a=<>',
    'a=[]',
    'a=""',
    'a()=0',
    'a={}',
    'a=(){}',
  ];

  d.forEach((String s) {
    // pf(checkAssignment(s));
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

  // code = '''a=(){x y z {1 2 {{}}}}''';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Widget> w = [Text('000000'), MaterialButton(onPressed: () {})];

  int i = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            w[i],
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
