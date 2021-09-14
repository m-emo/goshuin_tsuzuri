import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/common/header.dart';
import 'package:goshuintsuzuri/components/jinja/jinja.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import '../../app_store.dart';

class JinjaList extends StatelessWidget {
  JinjaList({Key key, @required this.store}) : super(key: key);

  // 引数取得
  final AppStore store; // 引数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      backgroundColor: Colors.white,
      persistentFooterButtons: <Widget>[
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/addJinja'),
          icon: StylesIcon.addIcon,
          label: Text(
            '神社・寺院を追加',
            style: Styles.mainTextStyle,
          ),
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
              // onTap: () => Navigator.pushNamed(context, '/addJinja'),
              onTap: () {
                // 神社・寺院別の御朱印一覧取得
                List<GoshuinListData> goshuinArray = [];
                for (var getgoshuin in store.goshuinArray) {
                  // 神社・寺院別のIDが一致する場合、リストに設定
                  if(getgoshuin.spotId == (store.spotArray)[index].id){
                    goshuinArray.add(getgoshuin);
                  }
                }

                // 画面表示用のデータ設定
                SpotData spotData = (store.spotArray)[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Jinja(store: store, spotData: spotData, goshuinArray:goshuinArray)),
                );
              },
              child: Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
                height: 85.0,
                child: Container(
                  /*color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 0.0, right: 10.0, bottom: 0.0, left: 2.0),*/
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 65.0,
                        width: 95.0,
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
                      Expanded(
                        child: Container(
                          child: Text(
                            "${(store.spotArray)[index].spotName}", // 神社・寺院名
                            style: Styles.mainTextStyleBold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Container(
                        // width: 60,
                        child: Text("[ " + "${(store.spotArray)[index].prefectures}" + " ]  ",
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
}