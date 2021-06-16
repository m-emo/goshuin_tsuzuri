import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import '../app_store.dart';

class GoshuinListList extends StatelessWidget {
  const GoshuinListList({Key key, @required this.store}) : super(key: key);

  // 引数取得
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
            margin: EdgeInsets.only(bottom: 2),
            height: 100.0,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/goshuin'),
              child: Container(
                /*color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 0.0, right: 10.0, bottom: 0.0, left: 2.0),*/
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 90.0,
                      width: 90.0,
                      color: StylesColor.bgImgcolor,
                      /*
                      child: bytesImage == null
                          ? new Text('No image value.')
                          : Image.memory(
                        bytesImage,
                        fit: BoxFit.cover,
                      )
                  */
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
                              "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社", // 神社・寺院名
                              style: Styles.mainTextStyleBold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child:
                            Text(
                              // "八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印", // 御朱印名
                              "${store.name}",
                              style: Styles.mainTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),

                          ),
                          Container(
                            child: Text("[ 北海道 ]  " + "2020.10.10",
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
        itemCount: 10,
      ),
    );
  }
}
