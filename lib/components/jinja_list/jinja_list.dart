import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/jinja/jinja.dart';
import 'package:goshuintsuzuri/components/jinja_edit/jinja_edit.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:provider/provider.dart';
import '../../app_store.dart';

class JinjaList extends StatelessWidget {
  // JinjaList({Key key, @required this.store}) : super(key: key);
  JinjaList({Key key}) : super(key: key);

  // 引数取得
  // final AppStore store; // 引数

  @override
  Widget build(BuildContext context) {
    final _store = Provider.of<AppStore>(context);
    return Scaffold(
      // appBar: Header(),
      backgroundColor: Colors.white,
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () {
            // 更新前のデータを保持（比較チェック用）
            setEditSopt(_store, "0", null);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  JinjaEdit(store: _store, kbn: "0", senimotokbn: "1",)),
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
          ListView.builder(
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
                    for (var getgoshuin in _store.goshuinArray) {
                      // 神社・寺院別のIDが一致する場合、リストに設定
                      if (getgoshuin.spotId == (_store.spotArray)[index].id) {
                        goshuinArray.add(getgoshuin);
                      }
                    }
                    // 画面表示用のデータ設定
                    SpotData spotData = (_store.spotArray)[index];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Jinja(
                              store: _store,
                              spotData: spotData,
                              goshuinArray: goshuinArray)),
                    );
                  },
                  child: Container(
                    // color: Colors.white,
                    padding: EdgeInsets.only(
                        top: 10, right: 10, bottom: 10, left: 10),
                    height: 85.0,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 65.0,
                            width: 95.0,
                            color: StylesColor.bgImgcolor,
                            child: Container(
                              child: showImg((_store.spotArray)[index].img, 2),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10.0),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "${(_store.spotArray)[index].spotName}",
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
                                    "${(_store.spotArray)[index].prefectures}" +
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
            itemCount: (_store.spotArray).length,
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
