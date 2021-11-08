import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:provider/provider.dart';
import '../dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/common/property.dart';
import '../app_store.dart';

//******** ボタン付きメッセージウィンドウWidget -start- ********
/*
* ボタン付きメッセージウィンドウWidget
* prm : store 表示用データ
*       msg 表示メッセージ
*       btnMsg1 ボタンテキスト１（上部分）
*       btnMsg1 ボタンテキスト２（下部分）
*       kbn 1:戻る、編集登録続けるの2処理
*           2:削除、編集続けるの2処理（御朱印削除）
* return : Widget
 */
Future<bool> myShowDialog(BuildContext context, String msg, String btnMsg1,
    String btnMsg2, int flg, AppStore store) {
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
                      child: Text(btnMsg1, style: Styles.mainButtonTextStyle),
                      onPressed: () {
                        if (flg == 1) {
                          // 戻る（ダイアログ閉じる⇒編集閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          editResetGoshuin(store);
                        } else if (flg == 2) {
                          //御朱印削除
                          // ★DB削除

                          // リストから削除
                          store.deleteGoshuinArrayOneData(store.editGoshuinId);
                          // editデータを初期化
                          editResetGoshuin(store);
                          // 戻る（ダイアログ閉じる⇒編集閉じる⇒詳細閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                        ;
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
                      child:
                          Text(btnMsg2, style: Styles.mainButtonTextStyleRed),
                      onPressed: () {
                        if (flg == 1 || flg == 2) {
                          // ダイアログ閉じる
                          Navigator.of(context).pop();
                        }
                        ;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // )
        ],
      );
    },
  );
}
//******** ボタン付きメッセージウィンドウWidget -end- ********

//******** ボタン付きメッセージウィンドウ(神社・寺院登録編集用）Widget -start- ********
/*
* ボタン付きメッセージウィンドウ(神社・寺院登録編集用）Widget
* prm : store 表示用データ
*       msg 表示メッセージ
*       btnMsg1 ボタンテキスト１（上部分）
*       btnMsg1 ボタンテキスト２（下部分）
*       flg 1:編集、登録中の場合に戻るボタン押した際の確認ダイアログ
*           2:「削除する/削除やめる」ダイアログ
* return : Widget
 */
Future<bool> myShowDialog_sub(BuildContext context, String msg, String btnMsg1,
    String btnMsg2, int flg, AppStore store) {
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
                        primary: StylesColor.maincolor2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),
                      child: Text(btnMsg1, style: Styles.mainButtonTextStyle),
                      onPressed: () {
                        if (flg == 1) {
                          //
                          // 戻る（ダイアログ閉じる⇒編集閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          editResetSopt(store);
                        } else if (flg == 2) {
                          //神社・寺院削除
                          //削除対象に紐づく御朱印がないかチェック

                          // ★DB削除

                          // リストから削除
                          store.deleteGoshuinArrayOneData(store.editGoshuinId);
                          // editデータを初期化
                          editResetSopt(store);
                          // 戻る（ダイアログ閉じる⇒編集閉じる⇒詳細閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                        ;
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
                        side: const BorderSide(color: StylesColor.maincolor2),
                        padding: EdgeInsets.all(10.0),
                      ),
                      child: Text(btnMsg2,
                          style: Styles.mainButtonTextStylePurple),
                      onPressed: () {
                        // 続けて登録する
                        if (flg == 1 || flg == 2) {
                          // ダイアログ閉じる
                          Navigator.of(context).pop();
                        }
                        ;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
//******** ボタン付きメッセージウィンドウ(神社・寺院登録編集用）Widget -end- ********

//******** メッセージウィンドウWidget -start- ********
/*
* メッセージウィンドウWidget
* prm : store 表示用データ
* return : Widget
 */
class MsgArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    return Observer(
      builder: (context) {
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
      },
    );
  }
}
//******** メッセージウィンドウWidget -end- ********

class BoxFitType {
  final String name;
  final BoxFit type;

  BoxFitType({this.name, this.type});
}

/*画像がない場合は初期画像を表示*/
Image showImg(String base64Image, int boxFitNum) {
  // BoxFitType のリストを作成
  List<BoxFitType> listBoxFitType = [
    BoxFitType(name: "fill", type: BoxFit.fill), // boxFitNum =0
    BoxFitType(name: "contain", type: BoxFit.contain), // boxFitNum =1
    BoxFitType(name: "cover", type: BoxFit.cover), // boxFitNum =2
    BoxFitType(name: "fitWidth", type: BoxFit.fitWidth), // boxFitNum =3
    BoxFitType(name: "fitHeight", type: BoxFit.fitHeight), // boxFitNum =4
    BoxFitType(name: "none", type: BoxFit.none), // boxFitNum =5
    BoxFitType(name: "scaleDown", type: BoxFit.scaleDown) // boxFitNum =6
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
* 登録時の御朱印データeditのリセット
* prm : store 表示用データ
* return : なし
 */
void editResetGoshuin(AppStore store) {
  // 編集対象のデータをクリア
  store.setEditGoshuinId(""); // 御朱印ID[GSI+連番6桁（GSI000001）]
  store.setEditGoshuinBase64Image(""); // 御朱印画像(base64)
  store.setEditGoshuinSpotId(""); // 神社・寺院ID [SPT+連番6桁（SPT000001）]
  store.setEditGoshuinSpotName(""); // 神社・寺院名
  store.setEditGoshuinSpotPrefecturesNo(""); // 都道府県番号
  store.setEditGoshuinSpotPrefectures(""); // 神社・寺院 都道府県
  store.setEditGoshuinName(""); // 御朱印名
  store.setEditGoshuinSanpaiDate(""); // 参拝日
  store.setEditGoshuinMemo(""); // メモ

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
* 登録時の神社寺院データeditのリセット
* prm : store 表示用データ
* return : なし
 */
void editResetSopt(AppStore store) {
  // 編集対象のデータをクリア
  store.setEditSpotid(""); // 神社・寺院ID [SPT+連番6桁（SPT000001）]
  store.setEditSpotName(""); // 神社・寺名
  store.setEditSpotKbn(""); // 区分（1:寺, 2:神社 ,0:その他）
  store.setEditSpotprefectures(""); // 都道府県名
  store.setEditSpotprefecturesNo(""); // 都道府県No
  store.setEditSpotBase64Image(""); // 神社・寺院画像(base64)
  store.setEditSpotcreateData(""); // 登録日

  // 画面用表示値をクリア
  store.setEditSpotShowKbn("");
  store.setEditSpotShowUint8ListImage("");

  // 更新前のデータをクリア
  SpotData data = SpotData(
    id: "",
    spotName: "",
    kbn: "",
    prefectures: "",
    prefecturesNo: "",
    img: "",
    createData: null,
  );
  store.setBeforeSpotData(data);
}

/*
* 登録・更新時の神社・寺院データeditの設定
* prm : store 表示用データ
*       kbn 区分（0:新規登録、1:更新）
* return : なし
 */
void setEditSopt(AppStore store, String kbn, SpotData data) {

  if(kbn == "0"){
    // 新規登録
    store.setEditSpotid(""); // 神社・寺院ID [SPT+連番6桁（SPT000001）]
    store.setEditSpotName(""); // 神社・寺名
    store.setEditSpotKbn(""); // 区分（1:寺, 2:神社 ,0:その他）
    store.setEditSpotprefectures(""); // 都道府県名
    store.setEditSpotprefecturesNo(""); // 都道府県No
    store.setEditSpotBase64Image(""); // 神社・寺院画像(base64)
    store.setEditSpotcreateData(""); // 登録日

    // 更新前のデータを保持（比較チェック用）
    data = SpotData(
      id: "",
      spotName: "",
      kbn: "",
      prefectures: "",
      prefecturesNo: "",
      img: "",
      createData: "",
    );
  }else if(kbn == "1"){
    // 更新
    store.setEditSpotid(data.id); // 神社・寺院ID [SPT+連番6桁（SPT000001）]
    store.setEditSpotName(data.spotName); // 神社・寺名
    store.setEditSpotKbn(data.kbn); // 区分（1:寺, 2:神社 ,0:その他）
    store.setEditSpotprefectures(data.prefectures); // 都道府県名
    store.setEditSpotprefecturesNo(data.prefecturesNo); // 都道府県No
    store.setEditSpotBase64Image(data.img); // 神社・寺院画像(base64)
    store.setEditSpotcreateData(data.createData); // 登録日

    // 編集画面用表示値(区分)
    var kbn = "";
    if(data.kbn == spotKbn.spot_kbn_tera){
      kbn = spotKbn.spot_text_tera;
    }else if(data.kbn == spotKbn.spot_kbn_jinja){
      kbn = spotKbn.spot_text_jinja;
    }else if(data.kbn == spotKbn.spot_kbn_sonota){
      kbn = spotKbn.spot_text_sonota;
    }
    store.setEditSpotShowKbn(kbn);

    store.setEditSpotShowUint8ListImage("");
  }
  store.setBeforeSpotData(data);
}



/*
* 御朱印を新規登録、変更時に既存データから変更しているかチェック
* prm : store 表示用データ
* return : flg (true:編集中、false：データを変更していない）
 */
bool checkGoshuinEdit(AppStore store) {
  // 更新前のデータ
  GoshuinListData beforeGoshuinData = store.beforeGoshuinData;
  // 編集状態判定
  bool flg = false;

  if (beforeGoshuinData.img != store.editGoshuinBase64Image)
    flg = true; // 画像チェック
  if (beforeGoshuinData.spotId != store.editGoshuinSpotId)
    flg = true; // 神社・寺院IDチェック
  if (beforeGoshuinData.goshuinName != store.editGoshuinName)
    flg = true; // 御朱印名チェック
  if (beforeGoshuinData.date != store.editGoshuinSanpaiDate)
    flg = true; // 参拝日チェック
  if (beforeGoshuinData.memo != store.editGoshuinMemo) flg = true; // メモ

  // いずれかが変更されていた場合編集中となる
  if (flg) {
    return true;
  } else {
    return false;
  }
}

/*
* 神社寺院を新規登録、変更時に既存データから変更しているかチェック
* prm : store 表示用データ
* return : flg (true:編集中、false：データを変更していない）
 */
bool checkSpotEdit(AppStore store) {
  // 更新前のデータ
  SpotData beforeSpotData = store.beforeSpotData;
  // 編集状態判定
  bool flg = false;

  if (beforeSpotData.img != store.editSpotBase64Image) flg = true; // 画像チェック
  if (beforeSpotData.prefecturesNo != store.editSpotprefecturesNo)
    flg = true; // 都道府県チェック
  if (beforeSpotData.spotName != store.editSpotName) flg = true; // 神社・寺院名

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
