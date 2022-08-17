import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/root.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:provider/provider.dart';

import '../app_store.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: StylesColor.bgcolor,
      ),
      home: RootWidget(store: store),
      routes: <String, WidgetBuilder>{
      },
    );
  }
}