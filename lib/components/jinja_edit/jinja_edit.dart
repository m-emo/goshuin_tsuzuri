import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/property.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/pefectures_list/prefectures_list.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../app_store.dart';

class JinjaEdit extends StatelessWidget {
  const JinjaEdit({Key key, @required this.store, this.kbn, this.senimotokbn})
      : super(key: key);

  // 引数取得
  final String kbn; // // 新規登録＝０、更新＝1
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
          Navigator.of(context).pop();
        } else {
          myShowDialog_sub(context, Msglist.edit_cancel, BtnText.btn_text_close,
              BtnText.btn_text_edit_continue, 1, store);
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
                Navigator.of(context).pop();
              } else {
                myShowDialog_sub(
                    context,
                    Msglist.edit_cancel,
                    BtnText.btn_text_close,
                    BtnText.btn_text_edit_continue,
                    1,
                    store);
              }
            },
            // onPressed: () => Navigator.of(context).pop(),
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
          _PrefecturesArea(kbn: kbn, store: store),
          _NameArea(kbn: kbn, store: store),
          _ButtonArea(kbn: kbn, store: store, senimotokbn: senimotokbn),
          kbn == "1" // 更新
              ? ButtonDeleteArea(store: store)
              : Container(),
        ],
      ),
    );
  }
}

//******** メッセージウィンドウWidget -start- ********
/*
* メッセージウィンドウWidget
* prm : store 表示用データ
* return : Widget
 */
class MsgArea extends StatefulWidget {
  // 引数
  final AppStore store;

  MsgArea({this.store});

  @override
  State createState() {
    return MsgAreaState(store: store);
  }
}

class MsgAreaState extends State {
  // 引数
  final AppStore store;

  MsgAreaState({this.store});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: store.goshuinErrFlg,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 80),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Text(
          '写真を追加してください',
          style: Styles.mainButtonTextStyle,
        ),
        width: 300.0,
        height: 80.0,
      ),
    );
  }
}

//******** メッセージウィンドウWidget -end- ********

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
    var imageFile = await ImagePicker.pickImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return;
    }

    // 指定サイズ／品質に圧縮
    List<int> imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
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
                          // Container(
                          //   child: Text(
                          //     "${store.editSpotprefectures}", // 都道府県名
                          //     style: Styles.mainTextStyleSmall,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        // 登録
                        "${store.editSpotprefectures}", // 都道府県名
                        style: Styles.mainTextStyle,
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
                text: "神社・寺院",
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
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
              ),
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
          /*
          * 登録
          * */
          void insert() {
            // 該当都道府県の最大の神社・寺院IDを取得
            var maxId = store.spotMaxId;

            var id = "";
            if (maxId == null || maxId == "") {
              // 初回登録
              id = "SPT000001";
            } else {
              var prefix = maxId.substring(0, 3); // プレフィックス
              int num = int.parse(maxId.substring(3, 9)); // 連番
              num = num + 1;
              id = prefix + num.toString().padLeft(6, "0");
            }
            // 最大ID登録
            store.setSpotMaxId(id);

            // insert
            spot = SpotData(
                id: id,
                spotName: store.editSpotName,
                kbn: store.editSpotkbn,
                prefectures: store.editSpotprefectures,
                prefecturesNo: store.editSpotprefecturesNo,
                img: store.editSpotBase64Image,
                createData: "");

            //★テスト用に固定値設定
            SpotData setSpotData = SpotData(
              id: "SPT010001",
              spotName: "北海道清水寺①",
              kbn: "1",
              prefectures: "北海道",
              prefecturesNo: "01",
              img: "",
              createData: "2021.10.20",
            );

            //神社・寺院一覧保持リストの先頭にデータセット
            store.setSpotArrayOneData(setSpotData);
            // DBに登録　★書く
          }

          /*
          * 更新
          */
          void update() {
            setState(() {
              //神社・寺院一覧を更新する
              spot = SpotData(
                  id: store.editSpotid,
                  spotName: store.editSpotName,
                  kbn: store.editSpotkbn,
                  prefectures: store.editSpotprefectures,
                  prefecturesNo: store.editSpotprefecturesNo,
                  img: store.editSpotBase64Image,
                  createData: store.editSpotcreateData);

              // 都道府県、神社名が変わっている場合、それぞれの御朱印リストを更新
              if (store.beforeSpotData.prefecturesNo !=
                      store.editSpotprefecturesNo ||
                  store.beforeSpotData.spotName != store.editSpotName) {
                // 御朱印リストの都道府県、神社名を修正
                store.updateGoshuinSpotInfo(spot);
                // 都道府県別御朱印リストを並び替え
                store.setGoshuinArrayPef();
                // ★DBのupdate（御朱印リストの都道府県、神社名を修正）
                //★書く
              }

              //★DBのupdate（神社・寺院を修正）
            });
          }

          /*
          * 入力チェック
          */
          String inputCheck() {
            setState(() {
              if (store.spotMaxId == MaxNum.max_spot_id) {
                return "神社・寺院の登録件数が999999件となり上限です。";
              }
              if (store.editSpotprefecturesNo == "") {
                return "都道府県を選択してください";
              }
              if (store.editSpotName == "") {
                return "神社・寺院名を入力してください";
              }
            });
          }

          /*
          * 同じ都道府県で同名の神社・寺院が登録されているかチェック
          */
          bool checkSameName(){
            for (spot in store.spotArray){
              if(spot.prefecturesNo == store.editSpotprefecturesNo && spot.spotName == store.editSpotName){
                return true;
              }
            }
            return false;
          }

          // データを登録・更新する
          var msg = "";
          //★確認のために外す
          // msg = inputCheck(); // 入力チェック
          if (msg != "") {
            // チェックNG
            // _pushDialog(context, msg);
          } else {
            // 同じ都道府県で同名の神社・寺院が登録されているかチェック
            bool flg = checkSameName();
            // ★確認ダイアログ出す

            if (kbn == "1") {
              update(); // 更新
              Navigator.of(context).pop();
            } else {
              insert(); // 登録
              // 神社・寺院一覧からの新規登録遷移の場合、続けて登録ダイアログを表示
              if (senimotokbn == "1") {
                myShowDialog_sub(
                    context,
                    Msglist.edit_complete_spot,
                    BtnText.btn_text_close,
                    BtnText.btn_text_edit_continue_insert,
                    1,
                    store);
              }
              // 御朱印登録からの新規登録遷移の場合
              else if (senimotokbn == "2") {
                Navigator.of(context).pop();
              }
            }
            // insert,update終わった後で、editデータを初期化
            editResetSopt(store);
          }
        },
      ),
    );
  }
}
//******** ボタンWidget -end- ********

//******** 削除ボタンWidget -start- ********
/*
* 削除ボタンWidget
* prm : store データ
* return : Widget
 */
class ButtonDeleteArea extends StatelessWidget {
  // 引数
  final AppStore store;

  ButtonDeleteArea({this.store});

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
          myShowDialog(context, Msglist.delete, BtnText.btn_text_delete,
              BtnText.btn_text_buck, 2, store);
        },
      ),
    );
  }
}
//******** 削除ボタンWidget -end- ********
