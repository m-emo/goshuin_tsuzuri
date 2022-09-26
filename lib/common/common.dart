import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/jinja_edit/jinja_edit.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import '../dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/common/property.dart';
import '../app_store.dart';

//******** ボタン付きメッセージウィンドウWidget -start- ********
/*
* ボタン付きメッセージウィンドウWidget
* prm : context
*       msg 表示メッセージ
*       btnMsg1 ボタンテキスト１（上部分）
*       btnMsg1 ボタンテキスト２（下部分）
*       flg 1:戻る、編集登録続けるの2処理
*           2:削除、編集続けるの2処理（御朱印削除）
*       store 表示用データ
*       kbn 新規登録＝0、更新＝1
* return : Widget
 */
// Future<bool> myShowDialog(BuildContext context, String msg, String btnMsg1,
//     String btnMsg2, int flg, AppStore store, String kbn) {
  Future<dynamic> myShowDialog(BuildContext context, String msg, String btnMsg1,
      String btnMsg2, int flg, AppStore store, String kbn) {
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
                          editResetGoshuin(store, kbn);
                        } else if (flg == 2) {
                          //御朱印削除
                          // DBのdelete
                          DbGoshuinData().deleteGoshuin(store.editGoshuinId);
                          // リストから削除
                          store.deleteGoshuinArrayOneData(store.editGoshuinId);
                          // editデータを初期化
                          editResetGoshuin(store, kbn);
                          // 戻る（ダイアログ閉じる⇒編集閉じる⇒詳細閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        };
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
        ],
      );
    },
  );
}
//******** ボタン付きメッセージウィンドウWidget -end- ********

//******** ボタン付きメッセージウィンドウ(神社・寺院登録編集用）Widget -start- ********
/*
* ボタン付きメッセージウィンドウ(神社・寺院登録編集用）Widget
* prm : context
*       flg 0:編集、登録中の場合に戻るボタン押した際の確認ダイアログ
*           1:「削除する/削除やめる」ダイアログ
*           2:「登録完了後閉じる/続けて登録」ダイアログ
*           3:登録更新時に入力エラーでもこのまま登録するかの確認ダイアログ
*       store 表示用データ
*       kbn 更新・新規登録区分値（新規登録＝０、更新＝1） ※登録、更新時に必要
*       senimotokbn 遷移元区分 （神社・寺院一覧からの新規登録遷移＝1、御朱印登録からの新規登録遷移＝2）※登録、更新時に必要
* return : Widget
 */
class _btnMsgSpot {
  final String btnMsg1;
  final String btnMsg2;
  final String msg;

  _btnMsgSpot({required this.btnMsg1, required this.btnMsg2, required this.msg});
}

// Future<bool> myShowDialogSpot(BuildContext context, int flg, AppStore store,
//     String kbn, String senimotokbn) {
  Future<dynamic> myShowDialogSpot(BuildContext context, int flg, AppStore store,
      String kbn, String senimotokbn) {
  // BoxFitType のリストを作成
  //  btnMsg1 ボタンテキスト１（上部分）
  //  btnMsg1 ボタンテキスト２（下部分）
  //  msg 表示メッセージ
  List<_btnMsgSpot> _listBtnMsgSpot = [
    _btnMsgSpot(
        btnMsg1: BtnText.btn_text_close,
        btnMsg2: BtnText.btn_text_edit_continue,
        msg: Msglist.edit_cancel),
    _btnMsgSpot(
        btnMsg1: BtnText.btn_text_delete,
        btnMsg2: BtnText.btn_text_buck,
        msg: Msglist.delete),
    _btnMsgSpot(
        btnMsg1: BtnText.btn_text_close,
        btnMsg2: BtnText.btn_text_edit_continue_insert,
        msg: Msglist.edit_complete_spot),
    _btnMsgSpot(
        btnMsg1: BtnText.btn_text_edit_continue_insert2,
        btnMsg2: BtnText.btn_text_buck,
        msg: Msglist.edit_same_nameSpot)
  ];

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
                    _listBtnMsgSpot[flg].msg,
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
                      child: Text(_listBtnMsgSpot[flg].btnMsg1,
                          style: Styles.mainButtonTextStyle),
                      onPressed: () async {
                        if (flg == 0 || flg == 2) {
                          //
                          // 戻る（ダイアログ閉じる⇒編集閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          editResetSopt(store);
                        } else if (flg == 1) {
                          //神社・寺院削除
                          //削除対象に紐づく御朱印がないかチェック
                          var checkflg = false;
                          for (var i = 0; i < store.goshuinArray.length; i++) {
                            if (store.goshuinArray[i].spotId == store.editSpotid) {
                              checkflg = true;
                              break;
                            }
                          }
                          // 紐づく御朱印があるため削除しない
                          if(checkflg){
                            // 戻る（ダイアログ閉じる）
                            Navigator.of(context).pop();
                            showMsgArea("削除対象の神社・寺院で登録されている御朱印があるため削除できません。\n先に御朱印を削除してください。", store);
                            return;
                          }

                          // DBのdelete
                          DbSpotData().deleteSpot(store.editSpotid);
                          // 神社・寺院リストから削除
                          store.deleteSpotArrayOneData(store.editSpotid);
                          // editデータを初期化
                          editResetSopt(store);
                          // 神社・寺院最大IDを再取得
                          SpotData spotMax = await DbSpotData().getMaxIdSpot();
                          var spotMaxId = spotMax.id;
                          var id = "";
                          if (spotMaxId == null) {
                            // 全件消えた場合
                            id = "";
                            print("★0件になった");
                          } else {
                            id = spotMaxId;
                            print("★最大値"+id);
                          }
                          store.setSpotMaxId(id);

                          // 戻る（ダイアログ閉じる⇒編集閉じる⇒詳細閉じる）
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else if (flg == 3) {
                          // ダイアログ閉じる
                          Navigator.of(context).pop();
                          // 登録、更新を進める
                          insertupdateSpot(kbn, senimotokbn, store, context);
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
                        side: const BorderSide(color: StylesColor.maincolor2),
                        padding: EdgeInsets.all(10.0),
                      ),
                      child: Text(_listBtnMsgSpot[flg].btnMsg2,
                          style: Styles.mainButtonTextStylePurple),
                      onPressed: () {
                        if (flg == 0 || flg == 1 || flg == 2 || flg == 3) {
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
  // 引数
  final AppStore store;

  MsgArea({required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return AnimatedOpacity(
          opacity: store.errFlg ? 0.0 : 1.0,
          duration: Duration(milliseconds: 200),
          // Visibility(
          // visible: store.errFlg,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Text(
              "${store.errMsg}",
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

//******** メッセージウィンドウ表示 -start- ********
/*
* メッセージウィンドウ表示
* prm : msg メッセージウィンドウの表示テキスト
*       store 表示用データ
* return : なし
 */
void showMsgArea(String msg, AppStore store) {
  // メッセージウィンドウのテキスト設定
  store.setErrMsg(msg);
  // メッセージウィンドウ表示に切り替え
  store.setErrFlg(false);

  // 5秒後に非表示
  Future.delayed(Duration(seconds: 5), () {
    store.setErrFlg(true);
  });
}

//******** メッセージウィンドウ表示 -end- ********

//******** 画像の変換 -start- ********
/*
* 画像の変換
* prm : base64Image base64画像
*       boxFitNum boxFitを適用する番号
* return : 画像
 */

class BoxFitType {
  final String name;
  final BoxFit type;

  BoxFitType({required this.name, required this.type});
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
//******** 画像の変換 -end- ********

//******** 御朱印登録がない場合の表示Widget -start- ********
/*
* 御朱印登録がない場合の表示Widget
* prm : なし
* return : Widget
 */
class NoDataArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
            image: AssetImage(
              'assets/img/no_data_list.png',
            ),
          height: 150,
        ),
        Text('御朱印がありません', style: Styles.mainTextStyle),
        Text('登録を押して御朱印を登録してください',style: Styles.subTextStyleSmall),
      ],
      ),
    );
  }
}
//******** 御朱印登録がない場合の表示Widget -end- ********

//******** 神社・寺院登録がない場合の表示Widget -start- ********
/*
* 神社・寺院登録がない場合の表示Widget
* prm : なし
* return : Widget
 */
class NoDataAreaSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage(
              'assets/img/no_data_list2.png',
            ),
            height: 150,
          ),
          Text('神社・寺院がありません', style: Styles.mainTextStyle),
          Text('＋を押して神社・寺院を登録してください',style: Styles.subTextStyleSmall),
        ],
      ),
    );
  }
}
//******** 神社・寺院登録がない場合の表示Widget -end- ********
/*
* 登録時・更新の御朱印データeditの保持
* prm : store 表示用データ
*       kbn 新規登録＝0、更新＝1
* return : なし
 */
void editSetGoshuin(AppStore store, String kbn){
  if(kbn == "0"){
    store.setEditGoshuinId(""); // 御朱印ID[GSI+連番9桁（GSI000000001）]
    store.setEditGoshuinBase64Image(""); // 御朱印画像(base64)
    store.setEditGoshuinSpotId(""); // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
    store.setEditGoshuinSpotName(""); // 神社・寺院名
    store.setEditGoshuinSpotPrefecturesNo(""); // 都道府県番号
    store.setEditGoshuinSpotPrefectures(""); // 神社・寺院 都道府県
    store.setEditGoshuinName(""); // 御朱印名
    store.setEditGoshuinSanpaiDate(""); // 参拝日
    store.setEditGoshuinMemo(""); // メモ
    store.setEditGoshuinCreateData(""); // 登録日
  }else{
    store.setEditGoshuinId(
        store.showGoshuinData.id); // 御朱印ID[GSI+連番9桁（GSI000000001）]
    store.setEditGoshuinBase64Image(
        store.showGoshuinData.img); // 御朱印画像(base64)
    store.setEditGoshuinSpotId(store
        .showGoshuinData.spotId); // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
    store.setEditGoshuinSpotName(
        store.showGoshuinData.spotName); // 神社・寺院名
    store.setEditGoshuinSpotPrefecturesNo(
        store.showGoshuinData.spotPrefecturesNo); // 都道府県番号
    store.setEditGoshuinSpotPrefectures(
        store.showGoshuinData.spotPrefectures); // 神社・寺院 都道府県
    store.setEditGoshuinName(
        store.showGoshuinData.goshuinName); // 御朱印名
    store.setEditGoshuinSanpaiDate(
        store.showGoshuinData.date); // 参拝日
    store.setEditGoshuinMemo(store.showGoshuinData.memo); // メモ
    store.setEditGoshuinCreateData(store.showGoshuinData.createData); // 登録日
  }
}



/*
* 登録時の御朱印データeditのリセット
* prm : store 表示用データ
*       kbn 新規登録＝0、更新＝1
* return : なし
 */
void editResetGoshuin(AppStore store, String kbn) {
  // 編集対象のデータをクリア
  store.setEditGoshuinId(""); // 御朱印ID[GSI+連番9桁（GSI000000001）]
  store.setEditGoshuinBase64Image(""); // 御朱印画像(base64)
  store.setEditGoshuinSpotId(""); // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
  store.setEditGoshuinSpotName(""); // 神社・寺院名
  store.setEditGoshuinSpotPrefecturesNo(""); // 都道府県番号
  store.setEditGoshuinSpotPrefectures(""); // 神社・寺院 都道府県
  store.setEditGoshuinName(""); // 御朱印名
  store.setEditGoshuinSanpaiDate(""); // 参拝日
  store.setEditGoshuinMemo(""); // メモ
  store.setEditGoshuinCreateData(""); // 登録日

  // エラーメッセージをクリア
  store.setErrMsg("");
  store.setErrFlg(true);

  // insert時のみ更新前のデータをクリア
  if (kbn == "0") {
    GoshuinListData data = GoshuinListData(
      id: "",
      img: "",
      spotId: "",
      spotName: "",
      spotPrefecturesNo: '',
      spotPrefectures: "",
      goshuinName: "",
      date: "",
      memo: "",
      createData: "",
    );
    store.setShowGoshuinData(data);
  }
}

/*
* 登録・更新時の神社寺院データeditのリセット
* prm : store 表示用データ
* return : なし
 */
void editResetSopt(AppStore store) {
  // 編集対象のデータをクリア
  store.setEditSpotid(""); // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
  store.setEditSpotName(""); // 神社・寺名
  store.setEditSpotKbn(""); // 区分（1:寺, 2:神社 ,0:その他）
  store.setEditSpotprefectures(""); // 都道府県名
  store.setEditSpotprefecturesNo(""); // 都道府県No
  store.setEditSpotBase64Image(""); // 神社・寺院画像(base64)
  store.setEditSpotcreateData(""); // 登録日

  // 画面用表示値をクリア
  store.setEditSpotShowKbn("");
  store.setEditSpotShowUint8ListImage("");
  store.setEditSpotName("");
  print("★"+store.editSpotName);

  // エラーメッセージをクリア
  store.setErrMsg("");
  store.setErrFlg(true);

  // // 更新前のデータをクリア
  // SpotData data = SpotData(
  //   id: "",
  //   spotName: "",
  //   kbn: "",
  //   prefectures: "",
  //   prefecturesNo: "",
  //   img: "",
  //   createData: null,
  // );
  // store.setShowSpotData(data);
}

/*
* 登録・更新時の神社・寺院データeditの設定
* prm : store 表示用データ
*       kbn 区分（0:新規登録、1:更新）
* return : なし
 */
void setEditSopt(AppStore store, String kbn) {
  if (kbn == "0") {
    // 新規登録
    store.setEditSpotid(""); // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
    store.setEditSpotName(""); // 神社・寺名
    store.setEditSpotKbn(""); // 区分（1:寺, 2:神社 ,0:その他）
    store.setEditSpotprefectures(""); // 都道府県名
    store.setEditSpotprefecturesNo(""); // 都道府県No
    store.setEditSpotBase64Image(""); // 神社・寺院画像(base64)
    store.setEditSpotcreateData(""); // 登録日

    // 更新前のデータを保持（比較チェック用）
    SpotData spotData = SpotData(
      id: "",
      spotName: "",
      kbn: "",
      prefectures: "",
      prefecturesNo: "",
      img: "",
      createData: "",
    );
    store.setShowSpotData(spotData);
  } else if (kbn == "1") {
    // 更新
    store.setEditSpotid(store.showSpotData.id); // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
    store.setEditSpotName(store.showSpotData.spotName); // 神社・寺名
    store.setEditSpotKbn(store.showSpotData.kbn); // 区分（1:寺, 2:神社 ,0:その他）
    store.setEditSpotprefectures(store.showSpotData.prefectures); // 都道府県名
    store.setEditSpotprefecturesNo(store.showSpotData.prefecturesNo); // 都道府県No
    store.setEditSpotBase64Image(store.showSpotData.img); // 神社・寺院画像(base64)
    store.setEditSpotcreateData(store.showSpotData.createData); // 登録日

    // 編集画面用表示値(区分)
    var kbn = "";
    if (store.showSpotData.kbn == spotKbn.spot_kbn_tera) {
      kbn = spotKbn.spot_text_tera;
    } else if (store.showSpotData.kbn == spotKbn.spot_kbn_jinja) {
      kbn = spotKbn.spot_text_jinja;
    } else if (store.showSpotData.kbn == spotKbn.spot_kbn_sonota) {
      kbn = spotKbn.spot_text_sonota;
    }
    store.setEditSpotShowKbn(kbn);

    store.setEditSpotShowUint8ListImage("");
  }
}

/*
* 御朱印を新規登録、変更時に既存データから変更しているかチェック
* prm : store 表示用データ
* return : flg (true:編集中、false：データを変更していない）
 */
bool checkGoshuinEdit(AppStore store) {
  // 更新前のデータ
  GoshuinListData beforeGoshuinData = store.showGoshuinData;
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
  if (beforeGoshuinData.memo != store.editGoshuinMemo) flg = true; // メモチェック

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
  SpotData beforeSpotData = store.showSpotData;
  // 編集状態判定
  bool flg = false;

  if (beforeSpotData.img != store.editSpotBase64Image) flg = true; // 画像チェック
  if (beforeSpotData.kbn != store.editSpotKbn) flg = true; // 区分チェック
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

/*
* 神社寺院を新規登録、変更時に既存データから変更しているかチェック
* prm : store 表示用データ
* return : flg (true:編集中、false：データを変更していない）
 */


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
