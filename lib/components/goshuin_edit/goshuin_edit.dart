import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goshuintsuzuri/common/common.dart';
import 'package:goshuintsuzuri/common/property.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/select_jinja_list/select_jinja_list.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';

import '../../app_store.dart';

class GoshuinEdit extends StatelessWidget {
  const GoshuinEdit({Key key, @required this.store, this.kbn})
      : super(key: key);

  // 引数取得
  final String kbn; // // 新規登録＝０、更新＝１
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // backキー
        // 編集中かチェック
        bool check = checkEdit(store);
        if (!check) {
          Navigator.of(context).pop();
        } else {
          myShowDialog(context, Msglist.edit_cancel);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: StylesIcon.backIcon,
            onPressed: () {
              // 編集中かチェック
              bool check = checkEdit(store);
              if (!check) {
                Navigator.of(context).pop();
              } else {
                myShowDialog(context, Msglist.edit_cancel);
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
                  '御朱印登録',
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
              Area(kbn: kbn, store: store),
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
  final AppStore store;

  Area({this.kbn, this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _ImagePickerView(kbn: kbn, store: store),
          _PlaceArea(kbn: kbn, store: store),
          _NameArea(kbn: kbn, store: store),
          _SelectDateArea(store: store),
          _MemoArea(store: store),
          _ButtonArea(kbn: kbn, store: store),
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

    // final valueChangeNotifier =
    // Provider.of<_ValueChangeNotifier>(context, listen: false);
    // // 画像に戻す
    // Uint8List bytesImg = Base64Decoder().convert(valueChangeNotifier._img);
    // 更新時初期値設定
    setState(() {
      if (kbn == "1") {
        // 更新
        // bytesImage = bytesImg;
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
      store.setEditBase64Image(base64Image);
    });
  }
}
//******** 写真Widget -end- ********

//******** 神社・寺院Widget -start- ********
/*
* 神社・寺院Widget
* prm : kbn 更新・新規登録区分値
*     : goshuin 更新御朱印データ
* return : Widget
 */
class _PlaceArea extends StatelessWidget {
// 引数
  final String kbn;
  final AppStore store;

  _PlaceArea({this.kbn, this.store});

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
                builder: (context) => SelectJinjaList(store: store)),
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
                                text: "神社・寺院",
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
                          Container(
                            child: Text(
                              "${store.editSpotPrefectures}", // 都道府県名
                              style: Styles.mainTextStyleSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        // 登録
                        "${store.editSpotName}", // 神社・寺院名
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
//******** 神社・寺院Widget -end- ********

//******** 御朱印名Widget -start- ********
/*
* 御朱印名Widget
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
            child: Text(
              "御朱印名",
              style: Styles.mainTextStyleBold,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: Styles.mainTextStyle,
              controller: TextEditingController(text: store.editGoshuinName),
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: '通常御朱印',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
              ),
              onChanged: (changed) => store.setEditGoshuinName(changed),
            ),
          ),
        ],
      ),
    );
  }
}
//******** 御朱印名Widget -end- ********

//******** 日付Widget -start- ********
/*
* 日付Widget
* prm : store 表示用データ
* return : Widget
 */
class _SelectDateArea extends StatefulWidget {
  // 引数
  final AppStore store;

  _SelectDateArea({this.store});

  @override
  State<StatefulWidget> createState() {
    return _SelectDateAreaState(store: store);
  }
}

class _SelectDateAreaState extends State<_SelectDateArea> {
  // 引数
  final AppStore store;

  _SelectDateAreaState({this.store});

  var _labelText = '';
  DateTime _date = new DateTime.now();
  var formatter = new DateFormat('yyyy.MM.dd');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    var fmtDate = formatter.format(picked);

    if (picked != null) setState(() => store.setEditSanpaiDate(fmtDate));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          _selectDate(context);
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
              top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RichText(
                  text: TextSpan(
                    text: "参拝日",
                    style: Styles.mainTextStyleBold,
                    children: <TextSpan>[
                      TextSpan(
                          text: ' *',
                          style: TextStyle(color: Color(0xFFD13833))),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${store.editSanpaiDate}",
                      style: Styles.mainTextStyle,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.date_range),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//******** 日付Widget -end- ********

//******** メモWidget -start- ********
/*
* メモWidget
* prm : store 表示用データ
* return : Widget
 */
class _MemoArea extends StatelessWidget {
  // 引数
  final AppStore store;

  _MemoArea({this.store});

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
            child: Text(
              "メモ",
              style: Styles.mainTextStyleBold,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: Styles.mainTextStyle,
              controller: TextEditingController(text: store.editMemo),
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: '入力してください',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//******** メモWidget -end- ********

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
  final AppStore store;

  _ButtonArea({this.kbn, this.store});

  @override
  _ButtonAreaState createState() => _ButtonAreaState(kbn: kbn, store: store);
}

class _ButtonAreaState extends State<_ButtonArea> {
  var goshuin = GoshuinData();

  // 引数
  final String kbn;
  final AppStore store;

  _ButtonAreaState({this.kbn, this.store});

  @override
  Widget build(BuildContext context) {
    /*ボタン処理*/
    return Container(
      margin: const EdgeInsets.only(
          top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: StylesColor.maincolor,
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
            // 最大ID取得
            var maxId = store.goshuinMaxId;
            var id = "";
            if (maxId == null || maxId == "") {
              // 初回登録
              id = "GSI000001";
            } else {
              var prefix = maxId.substring(0, 3); // プレフィックス
              int num = int.parse(maxId.substring(3, 9)); // 連番
              num = num + 1;
              id = prefix + num.toString().padLeft(6, "0");
            }
            // 最大ID登録
            store.setGoshuinMaxId(id);

            // insert
            goshuin = GoshuinData(
              id: id,
              img: store.editBase64Image,
              spotId: store.editSpotId,
              goshuinName: store.editGoshuinName,
              date: store.editSanpaiDate,
              memo: store.editMemo,
              createData: id,
            );
            // DbGoshuinData().insertGoshuin(goshuin); // ★　戻す

            // 御朱印一覧保持リストの先頭にデータセット
            //★テスト用に固定値設定
            GoshuinListData setListData = GoshuinListData(
              id: "GSI000003",
              img: "",
              spotId: "26-00001",
              spotName: "清水寺①",
              spotPrefectures: "京都府",
              goshuinName: "限定御朱印①",
              date: "2021.10.30",
              memo: "テストテスト",
              createData: "2021.10.20",
            );
            store.setGoshuinArrayOneData(setListData);

            //神社・寺院一覧保持リストの先頭にデータセット
            //★テスト用に固定値設定
            SpotData setSpotData = SpotData(
              id: "44-00001",
              spotName: "大分清水寺①",
              prefectures: "大分県",
              prefecturesNo: "44",
              img: "",
              createData: "2021.10.20",
            );
            store.setSpotArrayOneData(setSpotData);
          }

          /*
          * 更新
          */
          void update() {
            setState(() {
              //神社・寺院一覧保持リストの先頭にデータセット
              GoshuinListData setListData = GoshuinListData(
                id: store.editGoshuinId,
                img: store.editBase64Image,
                spotId: store.editSpotId,
                spotName: store.editSpotName,
                spotPrefectures: store.editSpotPrefectures,
                goshuinName: store.editGoshuinName,
                date: store.editSanpaiDate,
                memo: store.editMemo,
                createData: "", //★現在日入れる
              );
              store.updateGoshuinArrayOneData(setListData);
              //★DBのupdate
            });
          }

          /*
          * 入力チェック
          */
          String inputCheck() {
            setState(() {
              bool isVisible = store.goshuinErrFlg;
              print(isVisible);
              print("★isVisible");
              isVisible = !isVisible;
              store.setGoshuinErrFlg(isVisible);

              var text = "";
              var check = true;
              if (store.editBase64Image == "") {
                return "写真を追加してください";
              }
              if (store.editSpotId == "") {
                return "神社・寺院を選択してください";
              }
              if (store.editSanpaiDate == "") {
                return "参拝日を選択してください";
              }
            });
          }

          // データを登録・更新する
          var msg = "";
          //★確認のために外す
          // msg = inputCheck(); // 入力チェック
          if (msg != "") {
            // チェックNG
            // _pushDialog(context, msg);
          } else {
            // チェックOK
            if (kbn == "1") {
              update(); // 更新
            } else {
              insert(); // 登録
            }
            // insert,update終わった後で、editデータを初期化
            editReset(store);
            // 戻る
            // ★もどす
            // Navigator.of(context).pop();

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
          side: const BorderSide(color: StylesColor.maincolor),
          padding: EdgeInsets.all(15.0),
        ),
        child: Text('御朱印を削除する', style: Styles.mainButtonTextStyleRed),
        onPressed: () {
          // ★DB削除

          // リストから削除
          store.deleteGoshuinArrayOneData(store.editGoshuinId);
          // editデータを初期化
          editReset(store);
        },
      ),
    );
  }
}
//******** 削除ボタンWidget -end- ********
