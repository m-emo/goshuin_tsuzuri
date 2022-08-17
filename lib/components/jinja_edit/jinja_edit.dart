import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/property.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/pefectures_list/prefectures_list.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mobx/mobx.dart';

import '../../app_store.dart';
import '../../dao/db_goshuin_data.dart';

class JinjaEdit extends StatelessWidget {
  const JinjaEdit({Key key, @required this.store, this.kbn, this.senimotokbn})
      : super(key: key);

  // 引数取得
  final String kbn; // 新規登録＝0、更新＝1
  final String senimotokbn; //遷移元区分 　神社・寺院一覧からの新規登録遷移＝1、御朱印登録からの新規登録遷移＝2
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // backキー
        // 編集中かチェック
        bool check = checkSpotEdit(store);
        if (!check) {
          // 編集用データをリセット
          editResetSopt(store);
          Navigator.of(context).pop();
        } else {
          // ダイアログを表示
          myShowDialogSpot(context, 0, store, kbn, senimotokbn);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: StylesIcon.backIcon,
            onPressed: () {
              // 編集中かチェック
              bool check = checkSpotEdit(store);
              if (!check) {
                // 編集用データをリセット
                editResetSopt(store);
                Navigator.of(context).pop();
              } else {
                // ダイアログを表示
                myShowDialogSpot(context, 0, store, kbn, senimotokbn);
              }
            },
          ),
          title: kbn == "1" // 更新
              ? new Text(
                  "編集中",
                  style: Styles.appBarTextStyle,
                )
              : Text(
                  // 登録
                  '神社・寺院登録',
                  style: Styles.appBarTextStyle,
                ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                // 背景色
                color: StylesColor.bgImgcolor,
              ),
              Area(kbn: kbn, store: store, senimotokbn: senimotokbn),
              MsgArea(store: store),
            ],
          ),
        ),
      ),
    );
  }
}

class Area extends StatelessWidget {
  // 引数
  final String kbn;
  final String senimotokbn;
  final AppStore store;

  Area({this.kbn, this.senimotokbn, this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _ImagePickerView(kbn: kbn, store: store),
          _KbnArea(kbn: kbn, store: store),
          _PrefecturesArea(kbn: kbn, store: store),
          _NameArea(kbn: kbn, store: store),
          _ButtonArea(kbn: kbn, store: store, senimotokbn: senimotokbn),
          kbn == "1" // 更新
              ? _ButtonDeleteArea(kbn: kbn, store: store)
              : Container(),
        ],
      ),
    );
  }
}

//******** 写真Widget -start- ********
/*
* 写真Widget
* prm : kbn 更新・新規登録区分値
*     : goshuin 更新御朱印データ
* return : Widget
 */
class _ImagePickerView extends StatefulWidget {
  // 引数
  final String kbn;
  final AppStore store;

  _ImagePickerView({this.kbn, this.store});

  @override
  State createState() {
    return _ImagePickerViewState(kbn: kbn, store: store);
  }
}

class _ImagePickerViewState extends State {
  // 引数
  final String kbn;
  final AppStore store;

  _ImagePickerViewState({this.kbn, this.store});

  File imageFile;
  Uint8List bytesImage;

  @override
  void initState() {
    super.initState();
    // 更新時のみUint8Listへ変換
    if (kbn == "1" &&
        null != store.editSpotBase64Image &&
        "" != store.editSpotBase64Image) {
      bytesImage = Base64Decoder().convert(store.editSpotBase64Image);
    }

    // 更新時初期値設定
    setState(() {
      if (kbn == "1") {
        // 更新
        bytesImage = bytesImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            child: bytesImage == null
                ? Container(
                    alignment: Alignment.center,
                    height: size.width - 150,
                    child: StylesIcon.insertPhotoRounded,
                  )
                : Image.memory(
                    bytesImage,
                    height: size.width - 150,
                    width: size.width - 150,
                  ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
            child: InkWell(
              onTap: () async {
                var result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                            leading: FaIcon(FontAwesomeIcons.camera),
                            title: Text('写真を撮る'),
                            onTap: () {
                              Navigator.pop(context);
                              _getImageFromDevice(ImageSource.camera, store);
                            }),
                        ListTile(
                            leading: FaIcon(FontAwesomeIcons.images),
                            title: Text('ギャラリーから選択'),
                            onTap: () {
                              Navigator.pop(context);
                              _getImageFromDevice(ImageSource.gallery, store);
                            }),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 11,
                    child: Container(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        "写真を選択・追加",
                        style: Styles.mainTextStyleBold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// カメラまたはライブラリから画像を取得
  void _getImageFromDevice(ImageSource source, AppStore store) async {
    // 撮影/選択したFileを取得
    //var imageFile = await ImagePicker.pickImage(source: source);
    var imageFile = await ImagePicker().pickImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return;
    }

    // 指定サイズ／品質に圧縮
    List<int> imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 800,
      minHeight: 800,
      quality: 60,
    );

    // BASE64文字列値にエンコード
    String base64Image = base64Encode(imageBytes);

    // Uint8Listへ変換
    Uint8List bytesImage = Base64Decoder().convert(base64Image);

    setState(() {
      this.bytesImage = bytesImage;
      store.setEditSpotBase64Image(base64Image);
    });
  }
}
//******** 写真Widget -end- ********

//******** 区分Widget -start- ********
/*
* 区分Widget
* prm : kbn 更新・新規登録区分値
* return : Widget
 */
class _KbnArea extends StatelessWidget {
  // 引数
  final String kbn;
  final AppStore store;

  _KbnArea({this.kbn, this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: InkWell(
        onTap: () async {
          var result = await showModalBottomSheet<int>(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      leading: StylesIcon.teraIcon,
                      title: Text(spotKbn.spot_text_tera),
                      onTap: () {
                        Navigator.pop(context);
                        store.setEditSpotShowKbn(spotKbn.spot_text_tera);
                        store.setEditSpotKbn(spotKbn.spot_kbn_tera);
                      }),
                  ListTile(
                      leading: StylesIcon.jinjaIcon,
                      title: Text(spotKbn.spot_text_jinja),
                      onTap: () {
                        Navigator.pop(context);
                        store.setEditSpotShowKbn(spotKbn.spot_text_jinja);
                        store.setEditSpotKbn(spotKbn.spot_kbn_jinja);
                      }),
                  ListTile(
                      leading: FaIcon(FontAwesomeIcons.images),
                      title: Text(spotKbn.spot_text_sonota),
                      onTap: () {
                        Navigator.pop(context);
                        store.setEditSpotShowKbn(spotKbn.spot_text_sonota);
                        store.setEditSpotKbn(spotKbn.spot_kbn_sonota);
                      }),
                ],
              );
            },
          );
        },
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 11,
              child: Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: RichText(
                              text: TextSpan(
                                text: "区分",
                                style: Styles.mainTextStyleBold,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                          color: StylesColor.maincolor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Observer(
                        builder: (context) {
                          return Text(
                            "${store.editSpotShowKbn}", // 区分
                            style: Styles.mainTextStyle,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
//******** 区分Widget -end- ********

//******** 都道府県Widget -start- ********
/*
* 都道府県Widget
* prm : kbn 更新・新規登録区分値
*     : goshuin 更新御朱印データ
* return : Widget
 */

class _PrefecturesArea extends StatelessWidget {
// 引数
  final String kbn;
  final AppStore store;

  _PrefecturesArea({this.kbn, this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PrefecturesList(store: store)),
          );
        },
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 11,
              child: Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: RichText(
                              text: TextSpan(
                                text: "都道府県",
                                style: Styles.mainTextStyleBold,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                          color: StylesColor.maincolor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Observer(
                        builder: (context) {
                          return Text(
                            // 登録
                            "${store.editSpotprefectures}", // 都道府県名
                            style: Styles.mainTextStyle,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
//******** 都道府県Widget -end- ********

//******** 神社・寺院名Widget -start- ********
/*
* 神社・寺院名Widget
* prm : kbn 更新・新規登録区分値
*       store 表示用データ
* return : Widget
 */
class _NameArea extends StatelessWidget {
  // 引数
  final String kbn;
  final AppStore store;

  _NameArea({this.kbn, this.store});

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
            child: RichText(
              text: TextSpan(
                text: "神社・寺院名",
                style: Styles.mainTextStyleBold,
                children: <TextSpan>[
                  TextSpan(
                      text: ' *',
                      style: TextStyle(color: StylesColor.maincolor)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: Styles.mainTextStyle,
              controller: TextEditingController(text: store.editSpotName),
              // decoration: const InputDecoration(
              //   border: InputBorder.none,
              // ),
              // decoration: new InputDecoration.collapsed(
              //   border: InputBorder.none,
              // ),
              onChanged: (changed) => store.setEditSpotName(changed),
            ),
          ),
        ],
      ),
    );
  }
}
//******** 神社・寺院名Widget -end- ********

//******** ボタンWidget -start- ********
/*
* ボタンWidget
* prm : kbn 更新・新規登録区分値
*       store 表示用データ
* return : Widget
 */
class _ButtonArea extends StatefulWidget {
  // 引数
  final String kbn;
  final String senimotokbn;
  final AppStore store;

  _ButtonArea({this.kbn, this.senimotokbn, this.store});

  @override
  _ButtonAreaState createState() =>
      _ButtonAreaState(kbn: kbn, senimotokbn: senimotokbn, store: store);
}

class _ButtonAreaState extends State<_ButtonArea> {
  var spot = SpotData();

  // 引数
  final String kbn;
  final String senimotokbn;
  final AppStore store;

  _ButtonAreaState({this.kbn, this.senimotokbn, this.store});

  @override
  Widget build(BuildContext context) {
    /*ボタン処理*/
    return Container(
      margin: const EdgeInsets.only(
          top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: StylesColor.maincolor2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(15.0),
        ),
        child: kbn == "1" // 更新
            ? new Text(
                "更新する",
                style: Styles.mainButtonTextStyle,
              )
            : Text(
                // 登録
                "登録する",
                style: Styles.mainButtonTextStyle,
              ),
        onPressed: () {
          /**
           ** 入力チェック
           **/
          String inputCheck() {
            // ★上限数いれるか考える
            if (store.spotMaxId == MaxNum.max_spot_id) {
              return "神社・寺院の登録件数が999999件となり上限です。";
            }
            if (store.editSpotKbn == "") {
              return "区分を選択してください";
            }
            if (store.editSpotprefecturesNo == "") {
              return "都道府県を選択してください";
            }
            if (store.editSpotName == "") {
              return "神社・寺院名を入力してください";
            }
            return "";
          }

          /*
          * 同じ都道府県で同名の神社・寺院が登録されているかチェック
          *  prm : kbn 更新・新規登録区分値（新規登録＝０、更新＝1）
          *  return : true:チェックNG、false:チェックOK
          */
          bool checkSameName(String kbn) {
            for (spot in store.spotArray) {
              if (spot.prefecturesNo == store.editSpotprefecturesNo &&
                  spot.spotName == store.editSpotName) {
                if (kbn == "1") {
                  if (spot.id == store.editSpotid) {
                    // 編集中の場合は自分のIDは除外して次のデータを確認する
                    continue;
                  } else {
                    // 自分以外のIDの場合はNG
                    return true;
                  }
                } else {
                  // 新規登録時
                  return true;
                }
              }
            }
            return false;
          }

          /*
          * 【ボタン押下処理】データを登録・更新する
          */
          var msg = ""; // エラーメッセージ
          var checkflg = true; // 入力チェックフラグ

          // 入力チェック
          msg = inputCheck();
          if (msg != "") {
            // チェックNGのためメッセージウィンドウを表示
            showMsgArea(msg, store);
            return;
          }

          // 同じ都道府県で同名の神社・寺院が登録されているかチェック
          bool flg = checkSameName(kbn);
          if (flg) {
            //同じ都道府県で同名の神社・寺院が登録されているためメッセージウィンドウを表示
            myShowDialogSpot(context, 3, store, kbn, senimotokbn);
            return;
          }

          // Insert update処理
          insertupdateSpot(kbn, senimotokbn, store, context);
        },
      ),
    );
  }
}
//******** ボタンWidget -end- ********

//******** Insert update処理 -start- ********
/*
* Insert update処理
* prm : kbn 更新・新規登録区分値（新規登録＝０、更新＝1）
*       senimotokbn 遷移元区分 （神社・寺院一覧からの新規登録遷移＝1、御朱印登録からの新規登録遷移＝2）
*       store 表示用データ
*       context
* return : Widget
 */

void insertupdateSpot(
    String kbn, String senimotokbn, AppStore store, BuildContext context) {
  var spot = SpotData();
// 更新
  if (kbn == "1") {
    //神社・寺院一覧を更新する
    spot = SpotData(
        id: store.editSpotid,
        spotName: store.editSpotName,
        kbn: store.editSpotKbn,
        prefectures: store.editSpotprefectures,
        prefecturesNo: store.editSpotprefecturesNo,
        img: store.editSpotBase64Image,
        createData: store.editSpotcreateData);

    // 都道府県、神社名が変わっている場合、それぞれのリストを更新
    if (store.showSpotData.prefecturesNo != store.editSpotprefecturesNo ||
        store.showSpotData.spotName != store.editSpotName) {
      // 御朱印リストの都道府県、神社名を修正
      store.updateGoshuinSpotInfo(spot);
      // 神社・寺院リストのデータを変更
      store.updateSpotArrayOneData(spot);
      // 都道府県別の神社・寺院データ一覧を更新
      store.setSpotArrayPef();
      // 神社・寺院データの詳細画面表示時の下に表示される関連の御朱印リストを修正
      store.updateSpotShowSpotDataUnderGoshuinList(store.editSpotName,
          store.editSpotprefectures, store.editSpotprefecturesNo);
    }
    // 画像が変更されている場合、それぞれのリストを変更
    if (store.showSpotData.img != store.editSpotBase64Image) {
      // 都道府県別の神社・寺院データ一覧を更新
      store.setSpotArrayPef();
    }

    // 詳細画面表示時の神社・寺院データを更新
    store.setShowSpotData(spot);

    // DBのinsert（神社・寺院）
    DbSpotData().updateSpot(spot);

    Navigator.of(context).pop();
  }

  // 登録
  else {
    // 最大の神社・寺院IDを取得
    var maxId = store.spotMaxId;

    var id = "";
    if (maxId == null || maxId == "") {
      // 初回登録
      id = Id.spot_id_pfx + "000001";
    } else {
      var prefix = maxId.substring(0, 3); // プレフィックス
      int num = int.parse(maxId.substring(3, 9)); // 連番
      num = num + 1;
      id = prefix + num.toString().padLeft(6, "0");
    }
    // 最大ID登録
    store.setSpotMaxId(id);

    // insert
    final createData = (DateTime.now().toUtc().toIso8601String()); // 日時取得
    spot = SpotData(
        id: id,
        spotName: store.editSpotName,
        kbn: store.editSpotKbn,
        prefectures: store.editSpotprefectures,
        prefecturesNo: store.editSpotprefecturesNo,
        img: store.editSpotBase64Image,
        createData: createData);

    //神社・寺院一覧保持リストの先頭にデータセット
    store.setSpotArrayOneData(spot);
    // 都道府県別の神社・寺院データ一覧を更新
    store.setSpotArrayPef();

    // DBのinsert
    DbSpotData().insertSpot(spot);

    // 神社・寺院一覧からの新規登録遷移の場合、続けて登録ダイアログを表示
    if (senimotokbn == "1") {
      myShowDialogSpot(context, 2, store, kbn, senimotokbn);
    }
    // 御朱印登録からの新規登録遷移の場合
    else if (senimotokbn == "2") {
      Navigator.of(context).pop();
    }
  }
  // insert,update終わった後で、editデータを初期化
  editResetSopt(store);
}

//******** Insert update処理 -end- ********

//******** 削除ボタンWidget -start- ********
/*
* 削除ボタンWidget
* prm : store データ
*       kbn 新規登録＝0、更新＝1
* return : Widget
 */
class _ButtonDeleteArea extends StatelessWidget {
  // 引数
  final AppStore store;
  final String kbn;

  _ButtonDeleteArea({this.kbn, this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0, bottom: 50.0, left: 20.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.black,
          side: const BorderSide(color: StylesColor.maincolor2),
          padding: EdgeInsets.all(15.0),
        ),
        child: Text('神社・寺院を削除する', style: Styles.mainButtonTextStylePurple),
        onPressed: () {
          myShowDialogSpot(context, 1, store, "", "");
        },
      ),
    );
  }
}
//******** 削除ボタンWidget -end- ********
