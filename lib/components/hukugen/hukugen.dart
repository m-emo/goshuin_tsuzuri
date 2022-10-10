import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import '../../app_store.dart';
import '../../common/common.dart';
import '../../common/style.dart';

class Hukugen extends StatelessWidget {
  const Hukugen({Key? key, required this.store}) : super(key: key);

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
          "データ復元",
          style: Styles.appBarTextStyle,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: StylesColor.bgEditcolor,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: Image(
                        image: AssetImage(
                          'assets/img/download.png',
                        ),
                        height: 100,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        top: 30.0, right: 10.0, bottom: 30.0, left: 10.0),
                    child: Column(
                      children: <Widget>[
                        Text("バックアップしたファイルからデータを復元します。\n\n",
                            style: Styles.mainTextStyle),
                        Text("※すでに登録されているデータがある場合、上書きされるためご注意ください。",
                            style: Styles.mainTextStyleBold),
                      ],
                    ),
                  ),
                  _EmailArea(
                    store: store,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 50.0, right: 10.0, bottom: 30.0, left: 10.0),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: StylesColor.maincolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(15.0),
                      ),
                      child: Text(
                        'データを復元する',
                        style: Styles.mainButtonTextStyle,
                      ),
                      onPressed: () async {
                        // if (store.mailaddress == "") {
                        //   // チェックNGのためメッセージウィンドウを表示
                        //   var msg = "メールアドレスを入力してください";
                        //   showMsgArea(msg, store);
                        // } else {
                        //   // データ保存先を指定
                        //   final dataDir = await getApplicationDocumentsDirectory();
                        //   String dataDirPath = dataDir.path;
                        //   // String dataDirPath = await getDatabasesPath();
                        //   // final dataDir = Directory(dataDirPath);
                        //
                        //   try {
                        //     var filename = "backup_goshuin_db.zip";
                        //     final zipFile = File(dataDirPath + "/" + filename);
                        //     ZipFile.createFromDirectory(
                        //         sourceDir: dataDir,
                        //         zipFile: zipFile,
                        //         recurseSubDirs: true);
                        //     print(dataDirPath);
                        //     final email = Email(
                        //       body: '御朱印綴のバックアップデータです',
                        //       subject: '御朱印綴バックアップデータ',
                        //       recipients: [store.mailaddress],
                        //       attachmentPaths: [dataDirPath + "/" + filename],
                        //       isHTML: false,
                        //     );
                        //     await FlutterEmailSender.send(email);
                        //   } catch (e) {
                        //     print(e);
                        //   }
                        //   print(dataDirPath); // ★テスト用です。書き換えてください
                        // }
                      },
                    ),
                  ),
                ],
              ),
              MsgArea(store: store),
            ],
          ),
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
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: StylesColor.maincolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(10.0),
              ),
              child: Text(
                'バックアップデータを選択する',
                style: Styles.mainButtonTextStyle,
              ),
              onPressed: () async {
                print("★おした");
                // ファイルの取得
                final filePickerResult = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['zip'],
                );
                if (filePickerResult != null) {
                  // null じゃなければ io パッケージをつかって file を開こう
                  // result の中にはファイル名やパス名などの情報が入っている

                  // File file = File(filePickerResult.files.single.path);
                } else {
                  // キャンセル場合だったときの処理はここに書こう
                }
              },
            ),
          ),
          Container(
            child: Text(
              "バックアップデータを選択する",
              style: Styles.mainTextStyleBold,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: Styles.mainTextStyle,
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
