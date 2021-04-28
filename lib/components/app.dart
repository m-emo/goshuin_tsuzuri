import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/root.dart';
import 'package:goshuintsuzuri/goshuin/goshuin.dart';
import 'package:goshuintsuzuri/goshuin_edit/goshuin_edit.dart';
import 'package:goshuintsuzuri/jinja/jinja.dart';
import 'package:goshuintsuzuri/pefectures_list/prefectures_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootWidget(),
      routes: <String, WidgetBuilder>{
        '/addJinja': (BuildContext context) => new Jinja(),
        '/addGoshuin': (BuildContext context) => new Goshuin(),
        '/editGoshuin': (BuildContext context) => new GoshuinEdit(),
        '/addGoshuin': (BuildContext context) => new GoshuinEdit(kbn: "0"),
      },
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
