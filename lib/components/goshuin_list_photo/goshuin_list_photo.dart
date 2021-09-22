import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin/goshuin.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';

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
          body: GridView.count(
            crossAxisCount: 3,
            // 1行に表示する数
            crossAxisSpacing: 2.0,
            // 縦スペース
            mainAxisSpacing: 2.0,
            // 横スペース

            shrinkWrap: true,
            children: List.generate(store.goshuinArray.length, (index) {
              // // 画像取得
              // String base64Image = listGoshuin[index].img; // 画像(base64)
              // // 画像に戻す
              // Uint8List bytesImage = Base64Decoder().convert(base64Image);

              return Card(
                margin: EdgeInsets.all(0.0),
                child: InkWell(
                    onTap: () {
                      GoshuinListData goshuinData = (store.goshuinArray)[index];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Goshuin(
                                store: store, goshuinData: goshuinData)),
                      );
                    },
                    child: showImg(store.goshuinArray[index].img)),
              );
            }),
          ),
        ));
  }
}
