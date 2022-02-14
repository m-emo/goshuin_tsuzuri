import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/jinja_edit/jinja_edit.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import '../../app_store.dart';

class SelectJinjaList extends StatelessWidget {
  const SelectJinjaList({Key key, @required this.store}) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: StylesIcon.backIcon,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '神社・寺院選択',
          style: Styles.appBarTextStyle,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () {
            // 更新前のデータを保持（比較チェック用）
            setEditSopt(store, "0");

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JinjaEdit(
                        store: store,
                        kbn: "0",
                        senimotokbn: "2",
                      )),
            );
          },
          icon: StylesIcon.addIcon,
          label: Text(
            '神社・寺院を追加',
            style: Styles.mainTextStyle,
          ),
        ),
      ],
      body: Observer(
        builder: (context) => ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _SpotList(
                store: store,
                spotList: (store.spotArrayPef)[index].value);
            // return ListView.builder(
            //   itemBuilder: (BuildContext context, int index) {
            //     return Container(
            //       decoration: BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(
            //         color: StylesColor.bordercolor,
            //         width: 1.0,
            //       ))),
            //       child: InkWell(
            //         onTap: () {
            //           store.setEditGoshuinSpotId(
            //               (store.spotArray)[index].id); // 神社・寺院ID
            //           store.setEditGoshuinSpotName(
            //               (store.spotArray)[index].spotName); // 神社・寺院名
            //           store.setEditGoshuinSpotPrefectures(
            //               (store.spotArray)[index].prefectures); // 神社・寺院 都道府県
            //           store.setEditGoshuinSpotPrefecturesNo(
            //               (store.spotArray)[index].prefecturesNo); // 都道府県番号
            //           Navigator.pop(context); //前の画面に戻る
            //         },
            //         child: Container(
            //           color: Colors.white,
            //           padding: EdgeInsets.only(right: 10, left: 10),
            //           height: 70.0,
            //           child: Container(
            //             child: Row(
            //               children: <Widget>[
            //                 Container(
            //                   padding: EdgeInsets.only(right: 20, left: 10),
            //                   child: icon((store.spotArray)[index].kbn),
            //                 ),
            //                 Expanded(
            //                   child: Container(
            //                     padding: EdgeInsets.only(right: 10),
            //                     child: Text(
            //                       "${(store.spotArray)[index].spotName}",
            //                       // 神社・寺院名
            //                       style: Styles.mainTextStyleBold,
            //                       overflow: TextOverflow.ellipsis,
            //                       maxLines: 2,
            //                     ),
            //                   ),
            //                 ),
            //                 Container(
            //                   child: Text(
            //                       "[ " +
            //                           "${(store.spotArray)[index].prefectures}" +
            //                           " ]  ",
            //                       style: Styles.mainTextStyleSmall),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            //   itemCount: (store.spotArrayPef[indexPrf].value).length,
            // );
          },
          itemCount: (store.spotArrayPef).length,
        ),
      ),
    );
  }

}

//******** 神社・寺院リストWidget -start- ********
/*
* 神社・寺院リストWidget
* prm : spotList 都道府県別の神社・寺院リスト
* return : Widget
 */
class _SpotList extends StatelessWidget {
  // 引数
  final AppStore store;
  final List<SpotData> spotList;

  _SpotList({this.store, this.spotList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: StylesColor.bordercolor,
            width: 1.0,
          ))),
          child: InkWell(
            onTap: () {
              store
                  .setEditGoshuinSpotId(spotList[index].id); // 神社・寺院ID
              store.setEditGoshuinSpotName(
                  spotList[index].spotName); // 神社・寺院名
              store.setEditGoshuinSpotPrefectures(
                  spotList[index].prefectures); // 神社・寺院 都道府県
              store.setEditGoshuinSpotPrefecturesNo(
                  spotList[index].prefecturesNo); // 都道府県番号
              Navigator.pop(context); //前の画面に戻る
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(right: 10, left: 10),
              height: 70.0,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: icon(spotList[index].kbn),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "${spotList[index].spotName}",
                          // 神社・寺院名
                          style: Styles.mainTextStyleBold,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                          "[ " +
                              "${spotList[index].prefectures}" +
                              " ]  ",
                          style: Styles.mainTextStyleSmall),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: spotList.length,
    );
  }


  /*区分からアイコンを返却*/
  Image icon(kbn) {
    if (kbn == "1") {
      // 神社
      return StylesIcon.jinjaIcon;
    }
    else if (kbn == "2") {
      // 寺
      return StylesIcon.teraIcon;
    }
    // else {
    //   // その他
    //   return StylesIcon.sonotaIcon;
    // }
  }
}
//******** 神社・寺院リストWidget -end- ********
