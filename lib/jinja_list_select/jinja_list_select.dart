import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/header.dart';
import 'package:goshuintsuzuri/common/style.dart';

class Jinja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      persistentFooterButtons: <Widget>[
        FlatButton(
          color: Colors.white,
          child: Text(
            '＋ 神社・寺院を追加',
            style: Styles.mainTextStyle,
          ),
          onPressed: () => Navigator.pushNamed(context, '/addJinja'),
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
              onTap: () => Navigator.pop(context, "テスト神社名"), //前の画面に戻る
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
                      Expanded(
                        child: Container(
                          child: Text(
                            "あああああああああああああああああああああああああああああ", // 神社・寺院名
                            style: Styles.mainTextStyleBold,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.green,
                        width: 60,
                        child: Text("[ " + "北海道" + " ]  ",
                            style: Styles.mainTextStyleSmall),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: 3,
      ),
    );

  }
}