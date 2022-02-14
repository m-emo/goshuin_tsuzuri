import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin/goshuin.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:mobx/mobx.dart';

import '../../app_store.dart';

class GoshuinListPhoto extends StatelessWidget {
  const GoshuinListPhoto({Key key, @required this.store}) : super(key: key);

  // 引数取得
  final AppStore store; // 引数

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 2.0, left: 2.0),
        color: Color(0xFFFFFFFF),
        child: Scaffold(
          backgroundColor: StylesColor.bgImgcolor,
          body: Observer(
            builder: (context) {
              return GridView.count(
                // 1行に表示する数
                crossAxisCount: 3,
                // 縦スペース
                crossAxisSpacing: 1.0,
                // 横スペース
                mainAxisSpacing: 1.0,

                shrinkWrap: true,
                children: List.generate(store.goshuinArray.length, (index) {
                  return Card(
                    margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: InkWell(
                        onTap: () {
                          // 表示用データをセット
                          // store.showGoshuinData = (store.goshuinArray)[index];
                          store.showGoshuinData = (store.goshuinArray)[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Goshuin(store: store)),
                          );
                        },
                        child: showImg(store.goshuinArray[index].img, 1)),
                  );
                }),
              );
            },
          ),
        ));
  }
}
