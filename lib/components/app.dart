import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:goshuintsuzuri/common/root.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:provider/provider.dart';

import '../app_store.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    return MaterialApp(
      // カレンダーの日本語化
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
      ],

      theme: ThemeData(
        scaffoldBackgroundColor: StylesColor.bgcolor,
      ),
      home: RootWidget(store: store),
      routes: <String, WidgetBuilder>{
      },
    );
  }
}