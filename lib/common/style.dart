import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Styles {
  // appBarのテキストスタイル
  static const appBarTextStyle = TextStyle(
    color: Color(0xFF3B3B3B),
    fontSize: 16.0,
  );

  //メインテキストスタイル
  static const mainTextStyle = TextStyle(
    color: Color(0xFF3B3B3B),
    letterSpacing: 0.5,
    fontSize: 14.0,
  );

  // メインテキストスタイルの太字
  static const mainTextStyleBold = TextStyle(
    color: Color(0xFF3B3B3B),
    letterSpacing: 0.5,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
  );

  //メインテキストスタイル(小さめ）
  static const mainTextStyleSmall = TextStyle(
    color: Color(0xFF3B3B3B),
    letterSpacing: 0.5,
    fontSize: 12.0,
  );

  //メインテキストスタイル(大きめ）
  static const mainTextStyleLarge = TextStyle(
    color: Color(0xFF3B3B3B),
    letterSpacing: 0.5,
    fontSize: 18.0,
  );

  //サブテキストスタイル
  static const subTextStyle = TextStyle(
    color: Color(0xFF707070),
    letterSpacing: 0.5,
    fontSize: 14.0,
  );

  //サブテキストスタイル(小さめ）
  static const subTextStyleSmall = TextStyle(
    color: Color(0xFF707070),
    letterSpacing: 0.5,
    fontSize: 12.0,
  );

// ボタンテキストスタイル
  static const mainButtonTextStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    letterSpacing: 1.0,
    fontSize: 16.0,
  );

// ボタンテキストスタイル(赤字）
  static const mainButtonTextStyleRed = TextStyle(
    color: Color(0xFFE75331),
    letterSpacing: 1.0,
    fontSize: 16.0,
  );
}

// 色のスタイル
class StylesColor {
  // 画面全ての背景色
  static const bgcolor = Color(0xFFFFFFFF);

  // 写真画像の背景色
  static const bgImgcolor = Color(0xFFFFFFFF);

// ボーダーカラー
  static const bordercolor = Color(0xFFEAEAEA);

  // メインカラー
  static const maincolor = Color(0xFFE75331);

  // サブテキストカラー
  static const subTextColor = Color(0xFF707070);

  // サブテキストカラー(薄め）
  static const subTextColor2 = Color(0xFFB9B9B9);
}

class StylesIcon {
  // 戻る（＞）アイコン
  static const backIcon = Icon(Icons.arrow_back_ios, color: Color(0xFFB9B9B9));

  // 展開（下▽）アイコン
  static const openIcon =
      Icon(Icons.keyboard_arrow_down_sharp, color: Color(0xFFB9B9B9));

  // 追加アイコン
  static const addIcon = Icon(Icons.add, color: Color(0xFF3B3B3B));

  // 修正アイコン
  static const editIcon =
      Icon(FontAwesomeIcons.edit, color: Color(0xFFB9B9B9), size: 22);

  // 画像アイコン
  static const insertPhotoRounded =
      Icon(Icons.insert_photo_rounded, color: Color(0xFFB9B9B9), size: 100);

  // 神社・寺院選択リスト用アイコン
  // 神社
  static const jinjaIcon =
      Icon(FontAwesomeIcons.toriiGate, color: Color(0xFFB9B9B9), size: 20);

  // 神社
  static const teraIcon =
      Icon(FontAwesomeIcons.home, color: Color(0xFFB9B9B9), size: 20);

  // その他
  static const sonotaIcon =
      Icon(FontAwesomeIcons.key, color: Color(0xFFB9B9B9), size: 20);
}
