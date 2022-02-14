import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/jinja/jinja.dart';
import 'package:goshuintsuzuri/components/jinja_edit/jinja_edit.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:mobx/mobx.dart';
import '../../app_store.dart';

class JinjaList extends StatelessWidget {
  JinjaList({Key key, @required this.store}) : super(key: key);

  // 引数取得
  final AppStore store; // 引数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        senimotokbn: "1",
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
      body: Stack(
        children: <Widget>[
          Observer(
            builder: (context) => ListView.builder(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    _Midashi(
                        spotPrefectures:
                            (store.spotArrayPef)[index].value[0].prefectures),
                    _SpotList(
                      store: store,
                      spotList: (store.spotArrayPef)[index].value,
                    ),
                  ],
                );
              },
              itemCount: (store.spotArrayPef).length,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                color: StylesColor.bordercolor,
                width: 1.0,
              )),
            ),
            height: 1.0,
          ),
        ],
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
              // 神社・寺院別の御朱印一覧取得
              List<GoshuinListData> goshuinArray = [];
              for (var getgoshuin in store.goshuinArray) {
                // 神社・寺院別のIDが一致する場合、リストに設定
                if (getgoshuin.spotId == spotList[index].id) {
                  goshuinArray.add(getgoshuin);
                }
              }

              // 画面表示用のデータ設定
              store.setShowSpotData(spotList[index]); // 神社・寺院の詳細表示用
              store.setShowSpotDataUnderGoshuinList(
                  ObservableList.of(goshuinArray)); // 神社・寺院の詳細表示の下に表示する関連御朱印リスト

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Jinja(store: store)),
              );
            },
            child: Container(
              // color: Colors.white,
              padding:
                  EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
              height: 85.0,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 65.0,
                      width: 95.0,
                      color: StylesColor.bgImgcolor,
                      child: Container(
                        child: showImg(spotList[index].img, 2),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "${spotList[index].kbn}_${spotList[index].id}_${spotList[index].spotName}",
                          // 神社・寺院名
                          style: Styles.mainTextStyleBold,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Container(
                      // width: 60,
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
}
//******** 神社・寺院リストWidget -end- ********

//******** 都道府県見出しWidget -start- ********
/*
* 都道府県見出しWidget
* prm : spotPrefectures 都道府県名
* return : Widget
 */
class _Midashi extends StatelessWidget {
  // 引数
  final String spotPrefectures;

  _Midashi({this.spotPrefectures});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: StylesColor.bordercolor,
        width: 2.0,
      ))),
      child: Container(
        color: Colors.white,
        height: 45.0,
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
                  spotPrefectures, // 都道府県名
                  style: Styles.subTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//******** 都道府県見出しWidget -end- ********