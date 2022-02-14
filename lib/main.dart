import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/app.dart';

void main() {
  // ランドスケープモードを禁止する
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App());
}
