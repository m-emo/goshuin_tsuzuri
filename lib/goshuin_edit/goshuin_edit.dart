import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';

class GoshuinEdit extends StatelessWidget {
  // 引数取得
  final String kbn; // // 新規登録＝０、更新＝１
  // final String id; // 御朱印ID
  GoshuinEdit({Key key, this.kbn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: StylesIcon.backIcon,
          onPressed: () => Navigator.of(context).pop(),
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
        child: Area(),
      ),
    );
  }
}

class Area extends StatelessWidget {
  // 引数
  final String kbn;

  Area({this.kbn});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ImagePickerView(kbn: kbn),
          // PlaceArea(kbn: kbn, goshuin: goshuin),
          PlaceArea(),
          NameArea(),
          // SelectDateArea(kbn: kbn, goshuin: goshuin),
          SelectDateArea(),
          MemoArea(),
          // ButtonArea(kbn: kbn, updateGoshuin: goshuin),
          ButtonArea(kbn: kbn),
          kbn == "1" // 更新
              ? ButtonDeleteArea()
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
class ImagePickerView extends StatefulWidget {
  // 引数
  final String kbn;

  ImagePickerView({this.kbn});

  @override
  State createState() {
    return ImagePickerViewState(kbn: kbn);
  }
}

class ImagePickerViewState extends State {
  // 引数
  final String kbn;

  ImagePickerViewState({this.kbn});

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
                    // width: size.width - 150,
                    // color: Colors.black26,
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
                              _getImageFromDevice(ImageSource.camera);
                            }),
                        ListTile(
                            leading: FaIcon(FontAwesomeIcons.images),
                            title: Text('ギャラリーから選択'),
                            onTap: () {
                              Navigator.pop(context);
                              _getImageFromDevice(ImageSource.gallery);
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

  /*
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              height: size.width - 100,
              width: size.width - 100,
              child: FlatButton(
                onPressed: () async {
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
                                _getImageFromDevice(ImageSource.camera);
                              }),
                          ListTile(
                              leading: FaIcon(FontAwesomeIcons.images),
                              title: Text('ギャラリーから選択'),
                              onTap: () {
                                Navigator.pop(context);
                                _getImageFromDevice(ImageSource.gallery);
                              }),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  child: bytesImage == null
                      ? Container(
                    alignment: Alignment.center,
                    height: size.width - 100,
                    width: size.width - 100,
                    color: Colors.black26,
                    child: FaIcon(FontAwesomeIcons.cameraRetro),
                  )
                      : Image.memory(
                    bytesImage,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
*/
// カメラまたはライブラリから画像を取得
  void _getImageFromDevice(ImageSource source) async {
    // データ登録用変数セット
    // final valueChangeNotifier =
    // Provider.of<_ValueChangeNotifier>(context, listen: false);

    // 撮影/選択したFileが返ってくる
    var imageFile = await ImagePicker.pickImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return;
    }

    // flutter_image_compressで指定サイズ／品質に圧縮
    List<int> imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 800,
      minHeight: 800,
      quality: 60,
    );

//    List<int> imageBytes = await imageFile.readAsBytesSync();

    // BASE64文字列値にエンコード
    String base64Image = base64Encode(imageBytes);
    // valueChangeNotifier.setBytesImg(base64Image);

    // Uint8Listへ変換
    Uint8List bytesImage = Base64Decoder().convert(base64Image);

    setState(() {
      // this.imageFile = imageFile;
      this.bytesImage = bytesImage;
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

class PlaceArea extends StatefulWidget {
  // 引数
  // final String kbn;
  // final GoshuinList goshuin;
  // PlaceArea({this.kbn, this.goshuin});

  @override
  State<StatefulWidget> createState() {
    // return _PlaceArea(kbn: kbn, goshuin: goshuin);
    return _PlaceArea();
  }
}

class _PlaceArea extends State<PlaceArea> {
  // 引数
  // final String kbn;
  // final GoshuinList goshuin;
  //
  // _PlaceArea({this.kbn, this.goshuin});

  var _place = ''; // 神社・寺院名
  var _prefectures = ''; // 都道府県名

  @override
  // void initState() {
  //   super.initState();
  //   // 更新時初期値設定
  //   setState(() {
  //     if (kbn == "1") {
  //       // 更新
  //       _place = goshuin.shrineName;
  //       _prefectures = "[ " + goshuin.prefectures + " ]";
  //     } else {
  //       // 登録
  //       _place = '選択してください（必須）';
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
          top: 15.0, right: 20.0, bottom: 15.0, left: 20.0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          _navigateAndDisplaySelection(context);
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
                                      style:
                                          TextStyle(color: Color(0xFFD13833))),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${_prefectures}", // 都道府県名
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
                        "${_place}", // 神社・寺院名
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

  // 神社・寺院選択値受取
  void _navigateAndDisplaySelection(BuildContext context) async {
    // var shrine = Shrine();
    // shrine = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => JinjaList(kbn: "0"),
    //     ));
    // var place = shrine.shrineName; // 神社・寺院
    // var prefectures = "[ " + shrine.prefectures + " ]"; // 都道府県名
    // var jinjaId = shrine.shrineId; // 神社・寺院ID

    // データ登録用変数セット
    // final valueChangeNotifier =
    // Provider.of<_ValueChangeNotifier>(context, listen: false);
    // print("★神社設定");
    // print(place + "     " + jinjaId);
    // valueChangeNotifier.setJinjaId(jinjaId);
    // print(valueChangeNotifier._jinjaId);

    // setState(() {
    //   _place = place;
    //   _prefectures = prefectures;
    // });
  }
}
//******** 神社・寺院Widget -end- ********

//******** 御朱印名Widget -start- ********
/*
* 御朱印名Widget
* prm : kbn 更新・新規登録区分値
* return : Widget
 */
class NameArea extends StatelessWidget {
  // 引数
  final String kbn;

  NameArea({this.kbn});

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
            child: AddTitle(title1: "御朱印名"),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: TextField(
              style: Styles.mainTextStyle,
              // controller: _textEditingController,
              decoration: new InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: '通常御朱印',
                hintStyle: TextStyle(fontSize: 14.0, color: Colors.black12),
              ),
              // onChanged: (changed) => valueChangeNotifier.setName(changed),
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
* prm : kbn 更新・新規登録区分値
*     : goshuin 更新御朱印データ
* return : Widget
 */
class SelectDateArea extends StatefulWidget {
  // 引数
  // final String kbn;
  // final GoshuinList goshuin;

  // SelectDateArea({this.kbn, this.goshuin});

  @override
  State<StatefulWidget> createState() {
    // return _SelectDateAreaState(kbn: kbn, goshuin: goshuin);
    return _SelectDateAreaState();
  }
}

class _SelectDateAreaState extends State<SelectDateArea> {
  // 引数
  // final String kbn;
  // final GoshuinList goshuin;

  // _SelectDateAreaState({this.kbn, this.goshuin});

  var _labelText = '';
  DateTime _date = new DateTime.now();
  var formatter = new DateFormat('yyyy.MM.dd');

  // @override
  // void initState() {
  //   super.initState();
  //   // 更新時初期値設定
  //   setState(() {
  //     if (kbn == "1") {
  //       // 更新
  //       _labelText = goshuin.date;
  //     } else {
  //       // 登録
  //       _labelText = '選択（必須）';
  //     }
  //   });
  // }

  Future<Null> _selectDate(BuildContext context) async {
    //   final valueChangeNotifier =
    //   Provider.of<_ValueChangeNotifier>(context, listen: false);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    var fmtDate = formatter.format(picked);

    //   // データ登録用変数セット
    //   valueChangeNotifier.setDate(fmtDate);
    //
    if (picked != null) setState(() => _labelText = fmtDate);
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
                      "${_labelText}",
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
* prm : kbn 更新・新規登録区分値
* return : Widget
 */
class MemoArea extends StatelessWidget {
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
            child: AddTitle(title1: "メモ"),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: Styles.mainTextStyle,
              // controller: _textEditingController,
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
* return : Widget
 */
class ButtonArea extends StatelessWidget {
//   var goshuin = Goshuin();

  // 引数
  final String kbn;

//   final GoshuinList updateGoshuin;
//
//   ButtonArea({this.kbn, this.updateGoshuin});
  ButtonArea({this.kbn});

  @override
  Widget build(BuildContext context) {
//     // エラーチェックダイアログ
//     void _pushDialog(BuildContext context, String msg) {
//       showDialog<int>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(''),
//             content: Text(msg),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('OK'),
//                 onPressed: () => Navigator.of(context).pop(0),
//               ),
//             ],
//           );
//         },
//       );
//     }
//
//     final valueChangeNotifier = Provider.of<_ValueChangeNotifier>(context);
//
    return Container(
      margin: const EdgeInsets.only(
          top: 20.0, right: 20.0, left: 20.0, bottom: 30.0),
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
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
        color: StylesColor.maincolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {},

        // child: FlatButton(
        //   padding: EdgeInsets.all(15.0),
        //   // child: kbn == "1" // 更新
        //   //     ? new Text(
        //   //   "更新する",
        //   //   style: Styles.mainButtonTextStyle,
        //   // )
        //   //     : Text(
        //   //   // 登録
        //   //   "登録する",
        //   //   style: Styles.mainButtonTextStyle,
        //   // ),
        //   color: Color(0xFFE75331),
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//         onPressed: () async {
//           void insert() async {
//             // 最大ID取得
//             GoshuinList max = await DbGoshuinData().getMaxIdGoshuin();
//             var maxId = max.id;
//             var id = "";
//             if (maxId == null) {
//               // 初回登録
//               id = "GSI000001";
//             } else {
//               var prefix = maxId.substring(0, 3); // プレフィックス
//               int num = int.parse(maxId.substring(3, 9)); // 連番
//               num = num + 1;
//               id = prefix + num.toString().padLeft(6, "0");
//             }
//
//             // 登録
//             goshuin = Goshuin(
//               id: id,
//               img: valueChangeNotifier._img,
//               shrineId: valueChangeNotifier._jinjaId,
//               goshuinName: valueChangeNotifier._name,
//               date: valueChangeNotifier._date,
//               memo: valueChangeNotifier._memo,
//             );
//             await DbGoshuinData().insertGoshuin(goshuin);
//             print("add.dart ★登録した");
//           }
//
//           void update() async {
//             print(valueChangeNotifier._jinjaId);
//             // 更新
//             goshuin = Goshuin(
//               id: updateGoshuin.id,
//               img: valueChangeNotifier._img,
//               shrineId: valueChangeNotifier._jinjaId,
//               goshuinName: valueChangeNotifier._name,
//               date: valueChangeNotifier._date,
//               memo: valueChangeNotifier._memo,
//             );
//             await DbGoshuinData().updateGoshuin(goshuin);
//             print("add.dart ★更新した" + updateGoshuin.id);
//             print(valueChangeNotifier._jinjaId);
//           }
//
//           /*入力チェック*/
//           String checkInsert() {
//             var text = "";
//             var check = true;
//             if (valueChangeNotifier._img == "") {
//               text = "御朱印画像を追加してください";
//               return text;
//             }
//             if (valueChangeNotifier._jinjaId == "") {
//               if (text != "") {
//                 text = text + "、神社・寺院";
//               } else {
//                 text = "神社・寺院";
//               }
//               check = false;
//             }
//             if (valueChangeNotifier._date == "") {
//               if (text != "") {
//                 text = text + "、参拝日";
//               } else {
//                 text = "参拝日";
//               }
//               check = false;
//             }
//
//             if (check == false) {
//               text = text + "は必須です。\n入力してください。";
//             }
//             return text;
//           }
//
//           // 更新
//           var msg = "";
//           if (kbn == "1") {
//             await update();
//             // 戻る
//             Navigator.of(context).pop();
//           }
//           // 登録
//           else {
//             msg = checkInsert();
//             if (msg != "") {
//               _pushDialog(context, msg);
//             } else {
//               await insert();
//               // 戻る
//               Navigator.of(context).pop();
//             }
//           }
//         },
      ),
    );
  }
}

//******** ボタンWidget -end- ********

//******** 削除ボタンWidget -start- ********
/*
* 削除ボタンWidget
* return : Widget
 */
class ButtonDeleteArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        child: Text('御朱印を削除する', style: Styles.mainButtonTextStyleRed),
        // color: Colors.notnull,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: StylesColor.maincolor),
        ),
        onPressed: () {},
      ),
    );
  }
}
//******** 削除ボタンWidget -end- ********

// 見出し
class AddTitle extends StatelessWidget {
  final String title1; // 引数
  AddTitle({@required this.title1});

  @override
  Widget build(BuildContext context) {
    return Text(
      title1,
      style: Styles.mainTextStyleBold,
    );
  }
}
