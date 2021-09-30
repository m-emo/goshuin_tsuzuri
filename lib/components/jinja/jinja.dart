import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin/goshuin.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';

import '../../app_store.dart';

class Jinja extends StatelessWidget {
  const Jinja(
      {Key key,
      @required this.store,
      @required this.spotData,
      @required this.goshuinArray})
      : super(key: key);

  // 引数
  final AppStore store;
  final SpotData spotData;
  final List<GoshuinListData> goshuinArray;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: StylesIcon.backIcon,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            spotData.spotName,
            style: Styles.appBarTextStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: StylesIcon.editIcon,
            ),
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Photo(spotData: spotData),
            NameArea(spotData: spotData),
            ListArea(goshuinArray: goshuinArray, store: store),
          ],
        ));
  }
}

//******** 写真Widget -start- ********
class Photo extends StatelessWidget {
  // 引数
  final SpotData spotData;
  Photo({@required this.spotData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StylesColor.bgImgcolor,
      child: Container(
        child: showImg(spotData.img, 1),
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
class NameArea extends StatelessWidget {
  // 引数
  final SpotData spotData;
  NameArea({@required this.spotData});

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
              child: Text(
                "[ " + spotData.prefectures + " ]",
                style: Styles.subTextStyle,
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                spotData.spotName,
                // 御朱印名
                style: Styles.mainTextStyleLarge,
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
  final List<GoshuinListData> goshuinArray;
  final AppStore store;

  ListArea({@required this.goshuinArray, @required this.store});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              GoshuinListData goshuinData = goshuinArray[index];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Goshuin(store: store, goshuinData: goshuinData)),
              );
            },
            child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
              height: 100.0,
              child: Container(
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
                              goshuinArray[index].goshuinName, // 御朱印名
                              style: Styles.mainTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            child: Text(goshuinArray[index].date,
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
      itemCount: goshuinArray.length,
    );
  }
}
//******** 御朱印リストWidget -end- ********
