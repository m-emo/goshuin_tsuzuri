import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin/goshuin.dart';
import 'package:goshuintsuzuri/components/jinja_edit/jinja_edit.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:mobx/mobx.dart';

import '../../app_store.dart';

class Jinja extends StatelessWidget {
  const Jinja({Key key, @required this.store}) : super(key: key);

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
          title: Text(
            "${store.showSpotData.spotName}",
            style: Styles.appBarTextStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: StylesIcon.editIcon,
              onPressed: () {
                // 更新前のデータを保持（比較チェック用）
                setEditSopt(store, "1");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JinjaEdit(store: store, kbn: "1")),
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
            ListArea(store: store),
          ],
        ));
  }
}

//******** 写真Widget -start- ********
class _Photo extends StatelessWidget {
  // 引数
  final AppStore store;

  _Photo({@required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StylesColor.bgImgcolor,
      child: Container(
        child: showImg(store.showSpotData.img, 1),
      ),
    );
  }
}
//******** 写真Widget -end- ********

//******** 神社名Widget -start- ********
/*
* 神社名Widget
* prm :
* return : Widget
 */
class _NameArea extends StatelessWidget {
  // 引数
  final AppStore store;

  _NameArea({@required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: StylesColor.bordercolor,
        width: 1.0,
      ))),
      child: Container(
        color: Colors.white,
        // margin: const EdgeInsets.only(top: 4.0, bottom:4.0),
        padding: const EdgeInsets.only(
            top: 15.0, right: 20.0, bottom: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Observer(
                builder: (context) {
                  return Text(
                    "[ " + "${store.showSpotData.prefectures}" + " ]",
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
                    "${store.showSpotData.spotName}",
                    // 御朱印名
                    style: Styles.mainTextStyleLarge,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//******** 神社名Widget -end- ********

//******** 御朱印リストWidget -start- ********
/*
* 御朱印リストWidget
* prm : goshuinArray 神社・寺院別の御朱印一覧データ
*       store 利用データ
* return : Widget
 */
class ListArea extends StatelessWidget {
  // 引数
  final AppStore store;

  ListArea({@required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) => ListView.builder(
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
                      // 表示用データをセット
                      store.setShowGoshuinData(
                          (store.showSpotDataUnderGoshuinList)[index]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Goshuin(store: store)),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          top: 10, right: 10, bottom: 10, left: 10),
                      height: 100.0,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 90.0,
                              width: 90.0,
                              color: StylesColor.bgImgcolor,
                              child: Container(
                                child: showImg(
                                    (store.showSpotDataUnderGoshuinList)[index]
                                        .img,
                                    1),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 10.0),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // 左寄せ
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // 均等配置
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      store.showSpotDataUnderGoshuinList[index]
                                              .id +
                                          store
                                              .showSpotDataUnderGoshuinList[
                                                  index]
                                              .goshuinName, // 御朱印名
                                      style: Styles.mainTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                        store
                                            .showSpotDataUnderGoshuinList[index]
                                            .date,
                                        // 日付
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
                );
              },
              itemCount: store.showSpotDataUnderGoshuinList.length,
            ));
  }
}
//******** 御朱印リストWidget -end- ********
