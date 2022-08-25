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
        bool check = checkGoshuinEdit(store);
        if (!check) {
          Navigator.of(context).pop();
        } else {
          myShowDialog(context, Msglist.edit_cancel, BtnText.btn_text_close,
              BtnText.btn_text_edit_continue, 1, store, kbn);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: StylesIcon.backIcon,
            onPressed: () {
              // 編集中かチェック
              bool check = checkGoshuinEdit(store);
              if (!check) {
                Navigator.of(context).pop();
              } else {
                myShowDialog(
                    context,
                    Msglist.edit_cancel,
                    BtnText.btn_text_close,
                    BtnText.btn_text_edit_continue,
                    1,
                    store,
                    kbn);
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
              Container(
                // 背景色
                color: StylesColor.bgEditcolor,
              ),
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
        null != store.editGoshuinBase64Image &&
        "" != store.editGoshuinBase64Image) {
      bytesImage = Base64Decoder().convert(store.editGoshuinBase64Image);
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
                      child: Row(
                        children: <Widget>[
                          Text(
                            "写真を選択・追加",
                            style: Styles.mainTextStyleBold,
                          ),
                          Text(
                            " *",
                            style: Styles.mainTextRequired,
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
      // imageFile.absolute.path,
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
      store.setEditGoshuinBase64Image(base64Image);
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
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "神社・寺院",
                                  style: Styles.mainTextStyleBold,
                                ),
                                Text(
                                  " *",
                                  style: Styles.mainTextRequired,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Observer(
                              builder: (context) {
                                return Text(
                                  "${store.editGoshuinSpotPrefectures}",
                                  // 都道府県名
                                  style: Styles.mainTextStyleSmall,
                                );
                              },
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
                            "${store.editGoshuinSpotName}", // 神社・寺院名
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

    if (picked != null) setState(() => store.setEditGoshuinSanpaiDate(fmtDate));
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
                child: Row(
                  children: <Widget>[
                    Text(
                      "参拝日",
                      style: Styles.mainTextStyleBold,
                    ),
                    Text(
                      " *",
                      style: Styles.mainTextRequired,
                    ),
                  ],
                ), // child: RichText(
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "${store.editGoshuinSanpaiDate}",
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
              controller: TextEditingController(text: store.editGoshuinMemo),
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
              id = Id.goshuin_id_pfx + "000000001";
            } else {
              var prefix = maxId.substring(0, 3); // プレフィックス
              int num = int.parse(maxId.substring(3, 12)); // 連番
              num = num + 1;
              id = prefix + num.toString().padLeft(9, "0");
            }
            // 最大ID登録
            store.setGoshuinMaxId(id);

            // DBのinsert
            final createData =
                (DateTime.now().toUtc().toIso8601String()); // 日時取得
            goshuin = GoshuinData(
              id: id,
              img: store.editGoshuinBase64Image,
              spotId: store.editGoshuinSpotId,
              goshuinName: store.editGoshuinName,
              date: store.editGoshuinSanpaiDate,
              memo: store.editGoshuinMemo,
              createData: createData,
            );
            DbGoshuinData().insertGoshuin(goshuin);

            // 御朱印一覧保持リストの先頭にデータセット
            GoshuinListData setListData = GoshuinListData(
              id: id,
              img: store.editGoshuinBase64Image,
              spotId: store.editGoshuinSpotId,
              spotName: store.editGoshuinSpotName,
              spotPrefecturesNo: store.editGoshuinSpotPrefecturesNo,
              spotPrefectures: store.editGoshuinSpotPrefectures,
              goshuinName: store.editGoshuinName,
              date: store.editGoshuinSanpaiDate,
              memo: store.editGoshuinMemo,
              createData: createData,
            );

            // 御朱印リストに追加
            store.setGoshuinArrayOneData(setListData);
          }

          /*
          * 更新
          */
          void update() {
            setState(() {
              GoshuinListData setListData = GoshuinListData(
                id: store.editGoshuinId,
                img: store.editGoshuinBase64Image,
                spotId: store.editGoshuinSpotId,
                spotName: store.editGoshuinSpotName,
                spotPrefecturesNo: store.editGoshuinSpotPrefecturesNo,
                spotPrefectures: store.editGoshuinSpotPrefectures,
                goshuinName: store.editGoshuinName,
                date: store.editGoshuinSanpaiDate,
                memo: store.editGoshuinMemo,
                createData: store.editGoshuinCreateData,
              );

              // 神社・寺院データの詳細画面表示時の下に表示される関連の御朱印リストを修正
              store.updateShowSpotDataUnderGoshuinList(setListData);
              // 御朱印リストを修正
              store.updateGoshuinArrayOneData(setListData);
              // 詳細画面表示時の御朱印データを更新
              store.setShowGoshuinData(setListData);

              //DBのupdate
              goshuin = GoshuinData(
                id: store.editGoshuinId,
                img: store.editGoshuinBase64Image,
                spotId: store.editGoshuinSpotId,
                goshuinName: store.editGoshuinName,
                date: store.editGoshuinSanpaiDate,
                memo: store.editGoshuinMemo,
                createData: store.editGoshuinCreateData,
              );
              DbGoshuinData().updateGoshuin(goshuin);
            });
          }

          /*
          * 入力チェック
          */
          String inputCheck() {
            // ★上限数いれるか考える
            if (store.goshuinMaxId == MaxNum.max_goshuin_id) {
              return "御朱印の登録件数が上限です。";
            }
            if (store.editGoshuinBase64Image == "") {
              return "写真を追加してください";
            }
            if (store.editGoshuinSpotId == "") {
              return "神社・寺院を選択してください";
            }
            if (store.editGoshuinSanpaiDate == "") {
              return "参拝日を選択してください";
            }
            return "";
          }

          // データを登録・更新する
          var msg = "";
          // 入力チェック
          msg = inputCheck();
          if (msg != "") {
            // チェックNGのためメッセージウィンドウを表示
            showMsgArea(msg, store);
          } else {
            // チェックOK
            if (kbn == "1") {
              update(); // 更新
              Navigator.of(context).pop();
            } else {
              insert(); // 登録
              myShowDialog(
                  context,
                  Msglist.edit_complete,
                  BtnText.btn_text_close,
                  BtnText.btn_text_edit_continue_insert,
                  1,
                  store,
                  kbn);
            }
            // insert,update終わった後で、editデータを初期化
            editResetGoshuin(store, kbn);
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
          side: const BorderSide(color: StylesColor.maincolor),
          padding: EdgeInsets.all(15.0),
        ),
        child: Text('御朱印を削除する', style: Styles.mainButtonTextStyleRed),
        onPressed: () {
          myShowDialog(context, Msglist.delete, BtnText.btn_text_delete,
              BtnText.btn_text_buck, 2, store, kbn);
        },
      ),
    );
  }
}
//******** 削除ボタンWidget -end- ********
