// import 'package:flutter/material.dart';
// import '../../app_store.dart';
// import '../components/backup/backup.dart';
//
// class DrawerContent extends StatelessWidget {
//   const DrawerContent({required Key key, required this.store}) : super(key: key);
//
//   // 引数
//   final AppStore store;
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           DrawerHeader(
//             child: Text('Drawer Header'),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           ListTile(
//             title: Text("バックアップ・機種変更"),
//             trailing: Icon(Icons.arrow_forward),
//             onTap: () {
//               Navigator.of(context).pop();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         Backup()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text("データ復元"),
//             trailing: Icon(Icons.arrow_forward),
//             onTap: () {
//               Navigator.of(context).pop();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         Backup()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text("プライバシーポリシー"),
//             trailing: Icon(Icons.arrow_forward),
//           ),
//         ],
//       ),
//     );
//   }
// }