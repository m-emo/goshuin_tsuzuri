import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin/goshuin.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';

import '../../app_store.dart';

class GoshuinListList extends StatefulWidget {
  const GoshuinListList({Key key, @required this.store}) : super(key: key);

  // 引数取得
  final AppStore store; // 引数

  @override
  State<StatefulWidget> createState() {
    return GoshuinListListState(store: store);
  }
}

class GoshuinListListState extends State {
  // 引数
  final AppStore store;

  GoshuinListListState({this.store});

  Widget build(BuildContext context) {
    return Scaffold(
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
                GoshuinListData goshuinData = (store.goshuinArray)[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Goshuin(store: store, goshuinData: goshuinData)),
                );
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
                height: 100.0,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 90.0,
                      width: 90.0,
                      color: StylesColor.bgImgcolor,
                      child: Container(
                        child: showImg((store.goshuinArray)[index].img, 1),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 左寄せ
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // 均等配置
                        children: <Widget>[
                          Container(
                            child: Text(
                              "${(store.goshuinArray)[index].spotName}",
                              // 神社・寺院名
                              style: Styles.mainTextStyleBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              "${(store.goshuinArray)[index].goshuinName}",
                              // 御朱印名
                              style: Styles.mainTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                                "[ " +
                                    "${(store.goshuinArray)[index].spotPrefectures}" +
                                    " ]  " +
                                    "${(store.goshuinArray)[index].date}",
                                // 都道府県 日付
                                style: Styles.subTextStyleSmall),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: (store.goshuinArray).length,
      ),
    );
  }
}
