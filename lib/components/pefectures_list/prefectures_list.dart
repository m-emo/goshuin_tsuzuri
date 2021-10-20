import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:flutter/material.dart';

import '../../app_store.dart';

class PrefecturesList extends StatelessWidget {
  const PrefecturesList({Key key, @required this.store}) : super(key: key);
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
          '都道府県',
          style: Styles.appBarTextStyle,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: prefecturesListdata.length,
        itemBuilder: (context, int index) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: StylesColor.bordercolor,
              width: 2.0,
            ))),
            child: InkWell(
              onTap: () {
                store.setEditSpotprefectures(prefecturesListdata[index].value); // 都道府県名
                store.setEditSpotprefecturesNo(prefecturesListdata[index].key); // 都道府県番号
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 50.0, top: 20.0, bottom: 20.0),
                child: Text(prefecturesListdata[index].value, style: Styles.mainTextStyle),
              ),
            ),
          );
        },
      ),
    );
  }
}
