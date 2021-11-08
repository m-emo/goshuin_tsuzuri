import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_store.dart';
import 'components/app.dart';

void main() {
  // ランドスケープモードを禁止する
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // runApp(App());

  runApp(MultiProvider(
    providers: [
      Provider<AppStore>(create: (_) => AppStore()),
    ],
    child: App(),
  ));
}
