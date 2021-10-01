import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import '../dao/db_goshuin_data.dart';
import '../app_store.dart';

/*
* メッセージウィンドウWidget
* prm : store 表示用データ
* return : Widget
 */
Future<bool> myShowDialog(BuildContext context, String msg, AppStore store) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            margin:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    msg,
                    style: Styles.mainTextStyle,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        primary: StylesColor.maincolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                      child: Text('閉じる', style: Styles.mainButtonTextStyle),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        editResetGoshuin(store);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          // primary: Colors.black,
                          side: const BorderSide(color: StylesColor.maincolor),
                          padding: EdgeInsets.all(10.0),
                        ),
                        child: Text('編集を続ける',
                            style: Styles.mainButtonTextStyleRed),
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                ),
              ],
            ),
          ),
          // )
        ],
      );
      // return AlertDialog(
      //   content: Text(msg),
      //   actions: [
      //     SizedBox(
      //       width: double.infinity,
      //       child: Container(
      //         margin:
      //             const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 8.0),
      //         child: TextButton(
      //           style: ElevatedButton.styleFrom(
      //             primary: StylesColor.maincolor,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(5),
      //             ),
      //             padding: EdgeInsets.all(10.0),
      //           ),
      //           child: Text('閉じる', style: Styles.mainButtonTextStyle),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).pop();
      //             editResetGoshuin(store);
      //           },
      //         ),
      //       ),
      //     ),
      //     SizedBox(
      //       width: double.infinity,
      //       child: Container(
      //         margin:
      //             const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
      //         child: OutlinedButton(
      //             style: OutlinedButton.styleFrom(
      //               primary: Colors.black,
      //               side: const BorderSide(color: StylesColor.maincolor),
      //               padding: EdgeInsets.all(10.0),
      //             ),
      //             child: Text('編集を続ける', style: Styles.mainButtonTextStyleRed),
      //             onPressed: () => Navigator.of(context).pop()),
      //       ),
      //     ),
      //   ],
      // );
    },
  );
}

class BoxFitType {
  final String name;
  final BoxFit type;

  BoxFitType({this.name, this.type});
}

/*画像がない場合は初期画像を表示*/
Image showImg(String base64Image, int boxFitNum) {
  // BoxFitType のリストを作成
  List<BoxFitType> listBoxFitType = [
    BoxFitType(name: "fill", type: BoxFit.fill),
    BoxFitType(name: "contain", type: BoxFit.contain),
    BoxFitType(name: "cover", type: BoxFit.cover),
    BoxFitType(name: "fitWidth", type: BoxFit.fitWidth),
    BoxFitType(name: "fitHeight", type: BoxFit.fitHeight),
    BoxFitType(name: "none", type: BoxFit.none),
    BoxFitType(name: "scaleDown", type: BoxFit.scaleDown)
  ];

  if (null == base64Image || "" == base64Image) {
    // 画像なし
    return Image(
      image: AssetImage(
        'assets/img/no_img.png',
      ),
    );
  } else {
    // 画像あり
    // Uint8Listへ変換
    Uint8List bytesImage = Base64Decoder().convert(base64Image);
    return Image.memory(
      bytesImage,
      fit: listBoxFitType[boxFitNum].type,
    );
  }
}

/*
* editのリセット
* prm : store 表示用データ
* return : なし
 */
void editResetGoshuin(AppStore store) {
  // 編集対象のデータをクリア
  store.setEditGoshuinId(""); // 御朱印ID[GSI+連番6桁（GSI000001）]
  store.setEditBase64Image(""); // 御朱印画像(base64)
  store.setEditSpotId(""); // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  store.setEditSpotName(""); // 神社・寺院名
  store.setEditSpotPrefectures(""); // 神社・寺院 都道府県
  store.setEditGoshuinName(""); // 御朱印名
  store.setEditSanpaiDate(""); // 参拝日
  store.setEditMemo(""); // メモ

  // 更新前のデータをクリア
  GoshuinListData data = GoshuinListData(
    id: "",
    img: "",
    spotId: "",
    spotName: "",
    spotPrefectures: "",
    goshuinName: "",
    date: "",
    memo: "",
    createData: "",
  );
  store.setBeforeGoshuinData(data);
}

/*
* 御朱印を新規登録、変更時に既存データから変更しているかチェック
* prm : store 表示用データ
* return : flg (true:編集中、false：データを変更していない）
 */
bool checkEdit(AppStore store) {
  // 更新前のデータ
  GoshuinListData beforeGoshuinData = store.beforeGoshuinData;
  // 編集状態判定
  bool flg = false;

  if (beforeGoshuinData.img != store.editBase64Image) flg = true; // 画像チェック
  if (beforeGoshuinData.spotId != store.editSpotId) flg = true; // 神社・寺院IDチェック
  if (beforeGoshuinData.goshuinName != store.editGoshuinName)
    flg = true; // 御朱印名チェック
  if (beforeGoshuinData.date != store.editSanpaiDate) flg = true; // 参拝日チェック
  if (beforeGoshuinData.memo != store.editMemo) flg = true; // メモ

  // いずれかが変更されていた場合編集中となる
  if (flg) {
    return true;
  } else {
    return false;
  }
}

/*都道府県リスト*/
const List<MapEntry<String, String>> prefecturesListdata = [
  MapEntry("01", "北海道"),
  MapEntry("02", "青森県"),
  MapEntry("03", "岩手県"),
  MapEntry("04", "宮城県"),
  MapEntry("05", "秋田県"),
  MapEntry("06", "山形県"),
  MapEntry("07", "福島県"),
  MapEntry("08", "茨城県"),
  MapEntry("09", "栃木県"),
  MapEntry("10", "群馬県"),
  MapEntry("11", "埼玉県"),
  MapEntry("12", "千葉県"),
  MapEntry("13", "東京都"),
  MapEntry("14", "神奈川県"),
  MapEntry("15", "新潟県"),
  MapEntry("16", "富山県"),
  MapEntry("17", "石川県"),
  MapEntry("18", "福井県"),
  MapEntry("19", "山梨県"),
  MapEntry("20", "長野県"),
  MapEntry("21", "岐阜県"),
  MapEntry("22", "静岡県"),
  MapEntry("23", "愛知県"),
  MapEntry("24", "三重県"),
  MapEntry("25", "滋賀県"),
  MapEntry("26", "京都府"),
  MapEntry("27", "大阪府"),
  MapEntry("28", "兵庫県"),
  MapEntry("29", "奈良県"),
  MapEntry("30", "和歌山県"),
  MapEntry("31", "鳥取県"),
  MapEntry("32", "島根県"),
  MapEntry("33", "岡山県"),
  MapEntry("34", "広島県"),
  MapEntry("35", "山口県"),
  MapEntry("36", "徳島県"),
  MapEntry("37", "香川県"),
  MapEntry("38", "愛媛県"),
  MapEntry("39", "高知県"),
  MapEntry("40", "福岡県"),
  MapEntry("41", "佐賀県"),
  MapEntry("42", "長崎県"),
  MapEntry("43", "熊本県"),
  MapEntry("44", "大分県"),
  MapEntry("45", "宮崎県"),
  MapEntry("46", "鹿児島県"),
  MapEntry("47", "沖縄県"),
  MapEntry("98", "海外"),
  MapEntry("99", "その他")
];
