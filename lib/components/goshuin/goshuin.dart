import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin_edit/goshuin_edit.dart';

import '../../app_store.dart';

class Goshuin extends StatelessWidget {
  const Goshuin({Key key, @required this.store}) : super(key: key);

  // 引数
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: StylesIcon.backIcon,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Observer(
            builder: (context) {
              return Text(
                "${store.showGoshuinData.spotName}",
                style: Styles.appBarTextStyle,
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              // 編集画面へ移動
              icon: StylesIcon.editIcon,
              onPressed: () {
                // 登録時・更新の御朱印データeditの保持
                editSetGoshuin(store, "1");


                // 更新前のデータを保持（比較チェック用）
                // store.setBeforeGoshuinData(goshuinData);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
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
            _Photo(store: store),
            _NameArea(store: store),
            _MemoArea(store: store),
          ],
        ));
  }
}

//******** 写真Widget -start- ********
/*
* 写真Widget
* prm : store 表示用データ
* return : Widget
 */
class _Photo extends StatelessWidget {
  // 引数
  final AppStore store;

  _Photo({@required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StylesColor.bgImgcolor,
      child: Observer(
        builder: (context) {
          return Container(
            child: showImg(store.showGoshuinData.img, 1),
          );
        },
      ),
    );
  }
}
//******** 写真Widget -end- ********

//******** 御朱印名Widget -start- ********
/*
* 御朱印名Widget
* prm : store 表示用データ
* return : Widget
 */
class _NameArea extends StatelessWidget {
  // 引数
  final AppStore store;

  _NameArea({@required this.store});

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
            child: Observer(
              builder: (context) {
                return Text(
                  "[ " +
                      "${store.showGoshuinData.spotPrefectures}" +
                      " ]  " +
                      "${store.showGoshuinData.date}",
                  style: Styles.subTextStyle,
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: Observer(
              builder: (context) {
                return Text(
                  "${store.showGoshuinData.spotName}",
                  // 神社名
                  style: Styles.mainTextStyleLarge,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15.0),
            child: Observer(
              builder: (context) {
                return Text(
                  "${store.showGoshuinData.goshuinName}",
                  // 御朱印名
                  style: Styles.mainTextStyle,
                );
              },
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
* prm : store 表示用データ
* return : Widget
 */
class _MemoArea extends StatelessWidget {
  // 引数
  final AppStore store;

  _MemoArea({@required this.store});

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
            child: Observer(
              builder: (context) {
                return Text(
                  "${store.showGoshuinData.memo}",
                  textAlign: TextAlign.left,
                  style: Styles.mainTextStyle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//******** メモWidget -end- ********
