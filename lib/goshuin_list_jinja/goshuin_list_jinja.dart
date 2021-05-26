import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';

class GoshuinListJija extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[ListContents(), ListContents()],
      ),
    );
  }
}

class ListContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Midashi(),
        GoshuinListJija2(),
        GoshuinListJija2(),
        GoshuinListJija2()
      ],
    );
  }
}

//******** 都道府県見出しWidget ********
class Midashi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 40.0,
      child: Row(
        children: <Widget>[
          Container(
            width: 6.0,
            padding: const EdgeInsets.only(right: 10.0),
            color: StylesColor.maincolor,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10.0, right: 10),
              child: Text(
                "京都府", // 都道府県名
                style: Styles.subTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoshuinListJija2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
      header: Flexible(
        child: Container(
          padding: EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 16),
          height: 40.0,
          child: Container(
            /*color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 0.0, right: 10.0, bottom: 0.0, left: 2.0),*/
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      "八坂神社", // 神社・寺院名
                      style: Styles.mainTextStyleBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ヘッダー背景色
      headerBackgroundColorStart: Colors.white,
      // ヘッダー背景色
      headerBackgroundColorEnd: Colors.white,
      // 子要素の背景色
      expandedBackgroundColor: Colors.white,
      animatedWidgetFollowingHeader: StylesIcon.openIcon,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < 4; i++)
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: StylesColor.bordercolor,
                  width: 1.0,
                ))),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/goshuin'),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 5, right: 10, bottom: 5, left: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 75.0,
                          width: 75.0,
                          color: StylesColor.bgImgcolor,
                          /*
                      child: bytesImage == null
                          ? new Text('No image value.')
                          : Image.memory(
                        bytesImage,
                        fit: BoxFit.cover,
                      )
                  */
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10.0),
                        ),
                        Flexible(
                          child: Column(
                            // 左寄せ
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // 均等配置
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  // 御朱印名
                                  "八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印",
                                  style: Styles.mainTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                    // 日付
                                    "2020.10.10",
                                    style: Styles.subTextStyleSmall),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        // + more params, see example !!
      ],

      // // 開いたときのヘッダ
      // headerExpanded: Flexible(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       // ImageUtil.loadImage('locations/working_clock'),
      //       const SizedBox(
      //         width: 14,
      //       ),
      //       Flexible(
      //         child: Text("aaaa"),
      //         // child: TextStyles.normalStyle(
      //         //   body,
      //         //   color: ColorNames.grey2,
      //         //   fontSize: 14,
      //         // ),
      //       ),
      //     ],
      //   ),
      // ),
      // // 閉じた時
      // header: Flexible(
      //   child: Row(
      //     children: <Widget>[
      //       // ImageUtil.loadImage('locations/working_clock'),
      //       const SizedBox(
      //         width: 14,
      //       ),
      //       Text("2222"),
      //       // isWorking
      //       //     ? TextStyles.boldStyle(
      //       //   // 営業中
      //       //   S.of(context).restaurantDetailOpen,
      //       //   color: ColorNames.shopGreen,
      //       //   fontSize: 14,
      //       // )
      //       //     : TextStyles.boldStyle(
      //       //   // 閉店中
      //       //   S.of(context).restaurantDetailClose,
      //       //   color: ColorNames.red,
      //       //   fontSize: 14,
      //       // ),
      //       const SizedBox(
      //         width: 8,
      //       ),
      //       Expanded(
      //         child: Text("111111"),
      //         // child: TextStyles.normalStyle(
      //         //   title,
      //         //   color: ColorNames.grey2,
      //         //   fontSize: 14,
      //         // ),
      //       ),
      //       // 開く下向き＜
      //       // ImageUtil.loadImage('locations/arrow_up'),
      //     ],
      //   ),
      // ),
    );
  }
}

//
// class GoshuinListJija extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _State();
//   }
// }
//
// class PlaceItem {
//   bool isExpanded;
//   String name;
//   String image;
//
//   PlaceItem(this.isExpanded, this.name, this.image);
// }
//
// ExpansionPanel _createPanel(PlaceItem place) {
//   return ExpansionPanel(
//     headerBuilder: (BuildContext context, bool isExpanded) {
//       return Container(
//         padding: EdgeInsets.all(8.0),
//         child: Row(
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(right: 10.0),
//               child: Icon(Icons.image),
//             ),
//             Text(
//               place.name,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//       );
//     },
//     body: Image.asset('assets/' + place.image),
//     isExpanded: place.isExpanded,
//   );
// }
//
// class _State extends State<GoshuinListJija> {
//   var _placeList = new List<PlaceItem>();
//
//   @override
//   void initState() {
//     _placeList.add(
//       PlaceItem(false, 'Huntington Beach', 'huntington-beach.jpg'),
//     );
//     _placeList.add(
//       PlaceItem(false, 'The Hat', 'the-hat.jpg'),
//     );
//     _placeList.add(
//       PlaceItem(false, 'Shake Shack', 'shake-shack.jpg'),
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(8.0),
//         child: ListView(
//           children: <Widget>[
//             ExpansionPanelList(
//               expansionCallback: (int index, bool isExpanded) {
//                 setState(() {
//                   _placeList[index].isExpanded = !_placeList[index].isExpanded;
//                 });
//               },
//               children: _placeList.map(_createPanel).toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
