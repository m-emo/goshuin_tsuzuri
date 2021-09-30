import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin_edit/goshuin_edit.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';

import '../../app_store.dart';


class Goshuin extends StatelessWidget {
  const Goshuin({Key key, @required this.store, @required this.goshuinData})
      : super(key: key);

  // 引数
  final AppStore store;
  final GoshuinListData goshuinData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: StylesIcon.backIcon,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            goshuinData.spotName,
            style: Styles.appBarTextStyle,
          ),
          actions: <Widget>[
            IconButton(
              // 編集画面へ移動
              icon: StylesIcon.editIcon,
              onPressed: () {
                store.setEditGoshuinId(goshuinData.id); // 御朱印ID[GSI+連番6桁（GSI000001）]
                store.setEditBase64Image(goshuinData.img); // 御朱印画像(base64)
                store.setEditSpotId(goshuinData.spotId); // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
                store.setEditSpotName(goshuinData.spotName); // 神社・寺院名
                store.setEditSpotPrefectures(goshuinData.spotPrefectures); // 神社・寺院 都道府県
                store.setEditGoshuinName(goshuinData.goshuinName); // 御朱印名
                store.setEditSanpaiDate(goshuinData.date); // 参拝日
                store.setEditMemo(goshuinData.memo); // メモ

                // 更新前のデータを保持（比較チェック用）
                store.setBeforeGoshuinData(goshuinData);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      GoshuinEdit(store: store, kbn: "1")),
                );
              },
            ),
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Photo(goshuinData: goshuinData),
            NameArea(goshuinData: goshuinData),
            MemoArea(goshuinData: goshuinData),
          ],
        ));
  }
}

//******** 写真Widget -start- ********
class Photo extends StatelessWidget {
  // 引数
  final GoshuinListData goshuinData;
  Photo({@required this.goshuinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StylesColor.bgImgcolor,
      child: Container(
        child: showImg(goshuinData.img, 1),
      ),
    );
  }
}
//******** 写真Widget -end- ********

//******** 御朱印名Widget -start- ********
/*
* 御朱印名Widget
* prm : goshuinData 御朱印データ
* return : Widget
 */
class NameArea extends StatelessWidget {
  // 引数
  final GoshuinListData goshuinData;
  NameArea({@required this.goshuinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.only(top: 4.0, bottom:4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              "[ " + goshuinData.spotPrefectures + " ]  " + goshuinData.date,
              style: Styles.subTextStyle,
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              goshuinData.spotName,
              // 神社名
              style: Styles.mainTextStyleLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              goshuinData.goshuinName,
              // 御朱印名
              style: Styles.mainTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
//******** 御朱印名Widget -end- ********

//******** メモWidget -start- ********
/*
* メモWidget
* prm : goshuinData 御朱印データ
* return : Widget
 */
class MemoArea extends StatelessWidget {
  // 引数
  final GoshuinListData goshuinData;
  MemoArea({@required this.goshuinData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.only(top: 4.0, bottom:4.0),
      padding: const EdgeInsets.only(right: 20.0, bottom: 30.0, left: 20.0),
      child: Column(
        children: <Widget>[
          // 区切り線
          Divider(
            height: 40,
            thickness: 2,
            color: StylesColor.bordercolor,
          ),
          // メモ欄
          Container(
            width: double.infinity,
            child: Text(
              goshuinData.memo,
              textAlign: TextAlign.left,
              style: Styles.mainTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
//******** メモWidget -end- ********
