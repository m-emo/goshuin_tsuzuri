import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:sqflite/sqflite.dart';
import '../../app_store.dart';
import '../../common/common.dart';
import '../../common/style.dart';

class Backup extends StatelessWidget {
  const Backup({Key? key, required this.store}) : super(key: key);

  // 引数
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: StylesIcon.backIcon,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "バックアップ・機種変更",
          style: Styles.appBarTextStyle,
        ),
        // actions: <Widget>[
        //   IconButton(
        //     // 編集画面へ移動
        //     icon: StylesIcon.editIcon,
        //     onPressed: () {
        //       // 登録時・更新の御朱印データeditの保持
        //       editSetGoshuin(store, "1");
        //
        //
        //       // 更新前のデータを保持（比較チェック用）
        //       // store.setBeforeGoshuinData(goshuinData);
        //
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 GoshuinEdit(store: store, kbn: "1")),
        //       );
        //     },
        //   ),
        // ],
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
        color: StylesColor.bgEditcolor,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 30.0, right: 10.0, bottom: 30.0, left: 10.0),
              child: Text("宛先に機種変更後の端末で受け取れるメールアドレスを入力した状態で、バックアップボタンを押してください"),
            ),
            _EmailArea(
              store: store,
            ),
            TextButton(
              // style: ElevatedButton.styleFrom(
              //   primary: StylesColor.maincolor,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(5),
              //   ),
              //   padding:
              //       EdgeInsets.only(top: 10, right: 20, bottom: 10, left: 20),
              // ),
              style: ElevatedButton.styleFrom(
                backgroundColor: StylesColor.maincolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(15.0),
              ),
              child: Text(
                'データをバックアップする',
                style: Styles.mainButtonTextStyle,
              ),
              onPressed: () async {
                print("★" + store.mailaddress);
                if (store.mailaddress == "") {
                  // チェックNGのためメッセージウィンドウを表示
                  var msg = "メールアドレスを入力してください";
                  showMsgArea(msg, store);
                }else{
                  String dataDirPath = await getDatabasesPath();
                  final dataDir = Directory(dataDirPath);
                  // try {
                  //   final zipFile = File(dataDirPath + "/backup_goshuin_db.zip");
                  //   ZipFile.createFromDirectory(
                  //       sourceDir: dataDir,
                  //       zipFile: zipFile,
                  //       recurseSubDirs: true);
                  //
                  //   final email = Email(
                  //     body: 'content',
                  //     subject: '御朱印綴バックアップデータ',
                  //     recipients: ['email'],
                  //     cc: ['email'],
                  //     attachmentPaths: ['exportPath'],
                  //     isHTML: false,
                  //   );
                  //   await FlutterEmailSender.send(email);
                  // } catch (e) {
                  //   print(e);
                  // }
                  print(dataDirPath); // ★テスト用です。書き換えてください
                }

              },
            ),
          ],
        ),
      ),
    );
  }
}

//******** メールアドレス入力欄Widget -start- ********
/*
* メールアドレス入力欄Widget
* prm : store 表示用データ
* return : Widget
 */
class _EmailArea extends StatelessWidget {
  // 引数
  final AppStore store;

  _EmailArea({required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 4.0, bottom: 50.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Text(
              "メールアドレス",
              style: Styles.mainTextStyleBold,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: Styles.mainTextStyle,
              // controller: TextEditingController(text: store.editGoshuinName),
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: '入力してください',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
              ),
              onChanged: (changed) => store.setMailaddress(changed),
            ),
          ),
        ],
      ),
    );
  }
}
//******** メールアドレス入力欄Widget -end- ********
