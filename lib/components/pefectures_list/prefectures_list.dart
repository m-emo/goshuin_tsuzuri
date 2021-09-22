import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:flutter/material.dart';

class PrefecturesList extends StatelessWidget {
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
                Navigator.pop(context, prefecturesListdata[index]); //前の画面に戻る（変更なし）
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
