import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';

import '../app_store.dart';

class Jinja extends StatelessWidget {
  const Jinja({Key key, @required this.store}) : super(key: key);

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
            '神社名',
            style: Styles.appBarTextStyle,
          ),
          actions: <Widget>[
            IconButton(
              icon: StylesIcon.editIcon,
            ),
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Photo(),
            NameArea(),
            ListArea(),
          ],
        ));
  }
}

//******** 写真Widget -start- ********
class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      height: 300,
    );
  }
}
/*
class ImagePickerViewState extends State {
  // 引数
  final String kbn;

  ImagePickerViewState({this.kbn});

  File imageFile;
  Uint8List bytesImage;

  @override
  void initState() {
    super.initState();

    final valueChangeNotifier =
    Provider.of<_ValueChangeNotifier>(context, listen: false);
    // 画像に戻す
    Uint8List bytesImg = Base64Decoder().convert(valueChangeNotifier._img);
    // 更新時初期値設定
    setState(() {
      if (kbn == "1") {
        // 更新
        bytesImage = bytesImg;
      }
    });
  }

  @override
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
              /*
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
              */
            ),
          ]),
    );
  }

// カメラまたはライブラリから画像を取得
/*
  void _getImageFromDevice(ImageSource source) async {
    // データ登録用変数セット
    final valueChangeNotifier =
    Provider.of<_ValueChangeNotifier>(context, listen: false);

    // 撮影/選択したFileが返ってくる
    var imageFile = await ImagePicker.pickImage(source: source);
    // Androidで撮影せずに閉じた場合はnullになる
    if (imageFile == null) {
      return;
    }

    // flutter_image_compressで指定サイズ／品質に圧縮
    List<int> imageBytes = await FlutterImageCompress.compressWithFile(
      // ②
      imageFile.absolute.path,
      minWidth: 800,
      minHeight: 800,
      quality: 60,
    );

//    List<int> imageBytes = await imageFile.readAsBytesSync();

    // BASE64文字列値にエンコード
    String base64Image = base64Encode(imageBytes);
    valueChangeNotifier.setBytesImg(base64Image);

    // Uint8Listへ変換
    Uint8List bytesImage = Base64Decoder().convert(base64Image);

    setState(() {
//      this.imageFile = imageFile;
      this.bytesImage = bytesImage;
    });
  }
 */
}
 */
//******** 写真Widget -end- ********

//******** 神社名Widget -start- ********
/*
* 神社名Widget
* prm :
* return : Widget
 */
class NameArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: StylesColor.bordercolor,
        width: 1.0,
      ))),
      child: Container(
        color: Colors.white,
        // margin: const EdgeInsets.only(top: 4.0, bottom:4.0),
        padding: const EdgeInsets.only(
            top: 15.0, right: 20.0, bottom: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                "[ 京都府 ]",
                style: Styles.subTextStyle,
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印",
                // 御朱印名
                style: Styles.mainTextStyleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//******** 神社名Widget -end- ********

//******** 御朱印リストWidget -start- ********
/*
* 御朱印リストWidget
* prm :
* return : Widget
 */
class ListArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: StylesColor.bordercolor,
            width: 1.0,
          ))),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, '/goshuin'),
            child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 10),
              height: 100.0,
              child: Container(
                /*color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 0.0, right: 10.0, bottom: 0.0, left: 2.0),*/
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 90.0,
                      width: 90.0,
                      color: StylesColor.bgImgcolor,
                      /*
                      child: bytesImage == null
                          ? new Text('No image value.')
                          : Image.memory(
                        bytesImage,
                        fit: BoxFit.cover,
                      )
                  */
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 左寄せ
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // 均等配置
                        children: <Widget>[
                          Container(
                            child: Text(
                              "八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印八坂神社朱印",
                              // 御朱印名
                              style: Styles.mainTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            child: Text("2020.10.10",
                                // 日付
                                style: Styles.subTextStyleSmall),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: 3,
    );
  }
}
//******** 御朱印リストWidget -end- ********
