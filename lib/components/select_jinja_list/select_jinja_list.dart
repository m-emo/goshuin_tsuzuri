import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goshuintsuzuri/common/header.dart';
import 'package:goshuintsuzuri/common/style.dart';
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
        FlatButton(
          color: Colors.white,
          child: Text(
            '＋ 神社・寺院を追加',
            style: Styles.mainTextStyle,
          ),
          onPressed: () => Navigator.pushNamed(context, '/addJinja'),
        ),
      ],
      body: ListView.builder(
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
                store.setEditSpotId((store.spotArray)[index].id); // 神社・寺院ID
                store.setEditSpotName(
                    (store.spotArray)[index].spotName); // 神社・寺院名
                store.setEditSpotPrefectures(
                    (store.spotArray)[index].prefectures); // 神社・寺院 都道府県
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
                        child: icon((store.spotArray)[index].kbn),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "${(store.spotArray)[index].spotName}", // 神社・寺院名
                            style: Styles.mainTextStyleBold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                            "[ " +
                                "${(store.spotArray)[index].prefectures}" +
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
        itemCount: (store.spotArray).length,
      ),
    );
  }

  /*区分からアイコンを返却*/
  Icon icon(kbn) {
    if (kbn == "1") {
      // 神社
      return StylesIcon.jinjaIcon;
    } else if (kbn == "2") {
      // 寺
      return StylesIcon.teraIcon;
    } else {
      // その他
      return StylesIcon.sonotaIcon;
    }
  }
}
