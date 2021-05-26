import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';

class GoshuinListPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 2.0, left: 2.0),
        color: Color(0xFFFFFFFF),
        child: Scaffold(
          backgroundColor: StylesColor.bgImgcolor,
    body: GridView.count(
      crossAxisCount: 3,      // 1行に表示する数
      crossAxisSpacing: 2.0,      // 縦スペース
      mainAxisSpacing: 2.0,      // 横スペース

      shrinkWrap: true,

    ),
        ));
  }

/*
    return FutureBuilder(
      future: DbGoshuinData().getGoshuinList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<GoshuinList>> getList) {
        var listGoshuin = getList.data;
        if (getList.hasData) {
          return Container(
            padding: EdgeInsets.only(right: 2.0, left: 2.0),
            color: Color(0xFFFFFFFF),
            child: Scaffold(
              backgroundColor: Styles.bgImgcolor,
              body: GridView.count(
                crossAxisCount: 3,
                // 1行に表示する数

                crossAxisSpacing: 2.0,
                // 縦スペース

                mainAxisSpacing: 2.0,
                // 横スペース

                shrinkWrap: true,
                children: List.generate(listGoshuin.length, (index) {
                  // 画像取得
                  String base64Image = listGoshuin[index].img; // 画像(base64)
                  // 画像に戻す
                  Uint8List bytesImage = Base64Decoder().convert(base64Image);

                  return Card(
                    margin: EdgeInsets.all(0.0),
                    child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Contents(id: listGoshuin[index].id),
                            )),
                        child: bytesImage == null
                            ? new Text('No image value.')
                            : Image.memory(
                          bytesImage,
                          fit: BoxFit.cover,
                        )),
                  );
                }),
              ),
            ),
          );
        } else {
          return Scaffold(
            body:Center(
              /*child: loading,*/
            ),
          );
        }
      },
    );
    */

}
