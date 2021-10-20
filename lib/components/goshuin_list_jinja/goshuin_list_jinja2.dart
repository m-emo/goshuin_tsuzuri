// import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:goshuintsuzuri/common/common.dart';
// import 'package:goshuintsuzuri/common/style.dart';
// import 'package:goshuintsuzuri/components/goshuin/goshuin.dart';
// import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
//
// import '../../app_store.dart';
//
// class GoshuinListJija2 extends StatelessWidget {
//   const GoshuinListJija2({Key key, @required this.store}) : super(key: key);
//
//   // 引数取得
//   final AppStore store; // 引数
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[ListContents(store: store)],
//       ),
//     );
//   }
// }
//
// class ListContents extends StatelessWidget {
//   // 引数
//   final AppStore store;
//
//   ListContents({this.store});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (BuildContext context, int index) {
//         return Column(
//           children: <Widget>[
//             _Midashi(
//                 spotPrefecturesNum: (store.goshuinPefArray)[index].key),
//             _SpotList(
//                 store: store, spotList: (store.goshuinArrayPef)[index].value)
//           ],
//         );
//       },
//       itemCount: (store.goshuinPefArray).length,
//     );
//   }
// }
//
// //******** 都道府県見出しWidget -start- ********
// /*
// * 都道府県見出しWidget
// * prm : spotPrefecturesNum 都道府県番号
// * return : Widget
//  */
// class _Midashi extends StatelessWidget {
//   // 引数
//   final String spotPrefecturesNum;
//   _Midashi({this.spotPrefecturesNum});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border(
//               bottom: BorderSide(
//         color: StylesColor.bordercolor,
//         width: 2.0,
//       ))),
//       child: Container(
//         color: Colors.white,
//         height: 45.0,
//         child: Row(
//           children: <Widget>[
//             Container(
//               width: 6.0,
//               padding: const EdgeInsets.only(right: 10.0),
//               color: StylesColor.maincolor,
//             ),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.only(
//                     top: 10, bottom: 10, left: 10.0, right: 10),
//                 child: Text(
//                   _getText(spotPrefecturesNum), // 都道府県名
//                   style: Styles.subTextStyle,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// String _getText(String PreNum) {
//   var name = "";
//   // 都道府県名を取得
//   for (var data in prefecturesListdata){
//     // 一致する都道府県番号の都道府県名を取得
//     if(data.key == PreNum){
//       name = data.value;
//     }
//   }
//   return name;
//   }
// //******** 都道府県見出しWidget -end- ********
//
// //******** 神社・寺院リストWidget -start- ********
// /*
// * 神社・寺院リストWidget
// * prm : spotList 都道府県別の神社・寺院リスト
// * return : Widget
//  */
// class _SpotList extends StatelessWidget {
//   // 引数
//   final AppStore store;
//   final List<MapEntry<String, List<GoshuinListData>>> spotList;
//
//   _SpotList({this.store, this.spotList});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (BuildContext context, int index) {
//         return ConfigurableExpansionTile(
//           header: Flexible(
//             child: Container(
//               padding:
//                   EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 16),
//               height: 45.0,
//               child: Container(
//                 /*color: Colors.white,
//               padding: const EdgeInsets.only(
//                   top: 0.0, right: 10.0, bottom: 0.0, left: 2.0),*/
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                         child: Text(
//                           spotList[index].value[0].spotId +
//                               spotList[index].value[0].spotName, // 神社・寺院名
//                           style: Styles.mainTextStyleBold,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // リストが展開される前の境界線の開始色
//           borderColorStart: StylesColor.bordercolor,
//           //   // リストが展開された後のアニメーション終了時の境界線の色
//           borderColorEnd: StylesColor.bordercolor,
//           topBorderOn:false,
//           // 子要素の背景色
//           expandedBackgroundColor: Colors.white,
//           animatedWidgetFollowingHeader: StylesIcon.openIcon,
//           children: [
//             _GoshuinList(store: store, goshuinList: spotList[index].value),
//           ],
//         );
//       },
//       itemCount: (spotList).length,
//     );
//   }
// }
//
// //******** 神社・寺院リストWidget -end- ********
//
// //******** 御朱印リストWidget -start- ********
// /*
// * 御朱印リストWidget
// * prm : goshuinList 神社・寺院別の御朱印リスト
// * return : Widget
//  */
// class _GoshuinList extends StatelessWidget {
// // 引数
//   final AppStore store;
//   final List<GoshuinListData> goshuinList;
//
//   _GoshuinList({this.store, this.goshuinList});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//           decoration: BoxDecoration(
//               border: Border(
//                   top: BorderSide(
//             color: StylesColor.bordercolor,
//             width: 1.0,
//           ))),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         Goshuin(store: store, goshuinData: goshuinList[index])),
//               );
//             },
//             child: Container(
//               padding: EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     height: 75.0,
//                     width: 75.0,
//                     color: StylesColor.bgImgcolor,
//                     child: showImg(goshuinList[index].img, 1),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(right: 10.0),
//                   ),
//                   Flexible(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 均等配置
//                       children: <Widget>[
//                         Container(
//                           child: Text(
//                             goshuinList[index].id +
//                                 goshuinList[index].goshuinName, // 御朱印名
//                             style: Styles.mainTextStyle,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.only(top: 5.0),
//                           child: Text(goshuinList[index].date, // 日付
//                               style: Styles.subTextStyleSmall),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       itemCount: (goshuinList).length,
//     );
//   }
// }
// //******** 御朱印リストWidget -end- ********
