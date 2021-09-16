import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/root.dart';
import 'package:goshuintsuzuri/components/select_jinja_list/select_jinja_list.dart';

import 'package:goshuintsuzuri/components/pefectures_list/prefectures_list.dart';

import '../app_store.dart';
import 'goshuin_edit/goshuin_edit.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = AppStore();

    return MaterialApp(
      home: RootWidget(store: store),
      routes: <String, WidgetBuilder>{
        // '/addJinja': (_) => Jinja(store: store),
        // '/goshuin': (_) => Goshuin(store: store),
        // '/editGoshuin': (_) => GoshuinEdit(store: store),
        // '/addGoshuin': (_) => GoshuinEdit(store: store, kbn: '0'),
        // '/selecctJinjaList': (_) => SelectJinjaList(store: store),
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
