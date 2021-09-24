// import 'package:flutter/material.dart';
//
// class Header extends StatelessWidget with PreferredSizeWidget {
//   // 引数取得
//   final GlobalKey<ScaffoldState> key;
//   Header({this.key});
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0.0, // 影
//       title: Image(
//         image: AssetImage(
//           'assets/img/logo.png',
//         ),
//         height: 18,
//       ),
//       leading: IconButton(
//         icon: Icon(Icons.dehaze),
//         color: Color(0xFF707070),
//         padding: new EdgeInsets.all(15.0),
//         onPressed: () {
//           key.currentState.openDrawer();
//         },
//       ),
//       centerTitle: true,
//       backgroundColor: Colors.white,
//     );
//   }
// }
