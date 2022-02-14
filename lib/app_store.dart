import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'common/common.dart';
import 'dao/db_goshuin_data.dart';
import 'dao/db_spot_data.dart';
part 'app_store.g.dart';

/// ✨ Run the following command inside your project folder.
///    This generates the code in app_store.g.dart,
///    which we have already included as part file.
///
/// $ flutter packages pub run build_runner build
///

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {

//******** 御朱印登録に利用 -start- ********
  // 御朱印ID[GSI+連番6桁（GSI000001）]
  @observable
  String editGoshuinId;

  // 御朱印画像(base64)
  @observable
  String editGoshuinBase64Image;

  // 神社・寺院ID [SPT+連番6桁（SPT000001）]
  @observable
  String editGoshuinSpotId;

  // 神社・寺院名
  @observable
  String editGoshuinSpotName = "";

  // 神社・寺院 都道府県番号
  @observable
  String editGoshuinSpotPrefecturesNo = "";

  // 神社・寺院 都道府県
  @observable
  String editGoshuinSpotPrefectures = "";

  // 御朱印名
  @observable
  String editGoshuinName;

  // 参拝日
  @observable
  String editGoshuinSanpaiDate = "";

  // メモ
  @observable
  String editGoshuinMemo;

  // 登録日
  @observable
  String editGoshuinCreateData;

//******** 御朱印登録に利用 -end- ********

//******** 神社・寺院登録に利用 -start- ********
  // 神社・寺院ID [SPT+連番6桁（SPT000001）]
  @observable
  String editSpotid;

  // 神社・寺名
  @observable
  String editSpotName;

  // 区分（1:寺, 2:神社 ,0:その他）
  @observable
  String editSpotKbn;

  // 都道府県名
  @observable
  String editSpotprefectures;

  // 都道府県No
  @observable
  String editSpotprefecturesNo;

  // 神社・寺院画像(base64)
  @observable
  String editSpotBase64Image;

  // 登録日
  @observable
  String editSpotcreateData;

//******** 神社・寺院登録に利用 -end- ********

//******** 神社・寺院登録の画面表示用に利用 -start- ********
  // 区分表示値
  @observable
  String editSpotShowKbn = "";

  // 神社・寺院画像
  @observable
  String editSpotShowUint8ListImage;

//******** 神社・寺院登録の画面表示用に利用 -end- ********

  // 御朱印データの詳細画面表示時
  @observable
  GoshuinListData showGoshuinData;

  // 神社・寺院データの詳細画面表示時
  @observable
  SpotData showSpotData;

  // 神社・寺院データの詳細画面表示時の下に表示される関連の御朱印リスト
  @observable
  ObservableList<GoshuinListData> showSpotDataUnderGoshuinList;

  // 御朱印最大ID
  @observable
  String goshuinMaxId;

  // 神社・寺院最大ID
  @observable
  String spotMaxId;

  // 登録・変更チェックエラーフラグ
  @observable
  bool errFlg = true;

  // 登録・変更チェックエラーメッセージ
  @observable
  String errMsg = "";

  // 御朱印一覧
  @observable
  ObservableList<GoshuinListData> goshuinArray;

/*
  // 御朱印一覧(都道府県別）
  // (例）
  // [
  // MapEntry(01(都道府県番号), [
  //   MapEntry(01-00001(spotId), [<GoshuinListData>,<GoshuinListData>]),
  //   MapEntry(01-00002(spotId), [<GoshuinListData>,<GoshuinListData>]),
  //  ]),
  // MapEntry(02(都道府県番号), [
  //   MapEntry(02-00001(spotId), [<GoshuinListData>,<GoshuinListData>]),
  //   MapEntry(02-00002(spotId), [<GoshuinListData>,<GoshuinListData>]),
  //  ]),
  // ]
  @observable
  List<MapEntry<String, List<MapEntry<String, List<GoshuinListData>>>>>
      goshuinArrayPef;
*/

  // 神社・寺院一覧（都道府県順の神社寺院一覧に必要）
  //(例）
  //[
  // MapEntry(01(都道府県番号), [
  //   <SpotData>,<SpotData>
  //  ]),
  // MapEntry(02(都道府県番号), [
  //   <SpotData>,<SpotData>
  //  ]),
  // ]
  @observable
  List<MapEntry<String, List<SpotData>>>
  spotArrayPef;


   // 神社・寺院一覧
  @observable
  ObservableList<SpotData> spotArray;

  @action
  void setEditGoshuinId(String value) {
    editGoshuinId = value;
  }

  @action
  void setEditGoshuinBase64Image(String value) {
    editGoshuinBase64Image = value;
  }

  @action
  void setEditGoshuinSpotId(String value) {
    editGoshuinSpotId = value;
  }

  @action
  void setEditGoshuinSpotName(String value) {
    editGoshuinSpotName = value;
  }

  @action
  void setEditGoshuinSpotPrefecturesNo(String value) {
    editGoshuinSpotPrefecturesNo = value;
  }

  @action
  void setEditGoshuinSpotPrefectures(String value) {
    editGoshuinSpotPrefectures = value;
  }

  @action
  void setEditGoshuinName(String value) {
    editGoshuinName = value;
  }

  @action
  void setEditGoshuinSanpaiDate(String value) {
    editGoshuinSanpaiDate = value;
  }

  @action
  void setEditGoshuinMemo(String value) {
    editGoshuinMemo = value;
  }

  @action
  void setEditGoshuinCreateData(String value) {
    editGoshuinCreateData = value;
  }

  @action
  void setEditSpotid(String value) {
    editSpotid = value;
  }

  @action
  void setEditSpotName(String value) {
    editSpotName = value;
  }

  @action
  void setEditSpotKbn(String value) {
    editSpotKbn = value;
  }

  @action
  void setEditSpotprefectures(String value) {
    editSpotprefectures = value;
    print(editSpotprefectures);
  }

  @action
  void setEditSpotprefecturesNo(String value) {
    editSpotprefecturesNo = value;
  }

  @action
  void setEditSpotBase64Image(String value) {
    editSpotBase64Image = value;
  }

  @action
  void setEditSpotcreateData(String value) {
    editSpotcreateData = value;
  }

  @action
  void setEditSpotShowKbn(String value) {
    editSpotShowKbn = value;
  }

  @action
  void setEditSpotShowUint8ListImage(String value) {
    editSpotShowUint8ListImage = value;
  }

  @action
  void setShowGoshuinData(GoshuinListData value) {
    showGoshuinData = value;
  }

  @action
  void setShowSpotData(SpotData value) {
    showSpotData = value;
  }

  @action
  void setShowSpotDataUnderGoshuinList(ObservableList<GoshuinListData> value) {
    showSpotDataUnderGoshuinList = value;
  }

  @action
  void setGoshuinMaxId(String value) {
    goshuinMaxId = value;
  }

  @action
  void setSpotMaxId(String value) {
    spotMaxId = value;
  }

  @action
  void setErrFlg(bool value) {
    errFlg = value;
  }

  @action
  void setErrMsg(String value) {
    errMsg = value;
  }

  @action
  void setGoshuinArray(ObservableList<GoshuinListData> value) {
    goshuinArray = value;
  }

  @action
  void setSpotArray(ObservableList<SpotData> value) {
    spotArray = value;
  }

  /*
  * 御朱印リストの先頭に御朱印データ追加
  * prm : goshuinId 御朱印ID
  * return : なし
  */
  @action
  void setGoshuinArrayOneData(GoshuinListData value) {
    goshuinArray.insert(0, value);
  }

  /*
  * 御朱印リストのデータを変更
  * prm : goshuinListData 御朱印データ
  * return : なし
  */
  @action
  void updateGoshuinArrayOneData(GoshuinListData goshuinListData) {
    for (var i = 0; i < goshuinArray.length; i++) {
      if (goshuinArray[i].id == goshuinListData.id) {
        // 削除
        goshuinArray.removeAt(i);
        // 削除した位置に追加
        goshuinArray.insert(i, goshuinListData);
        break;
      }
    }
  }

  /*
  * 御朱印リストから削除
  * prm : goshuinId 御朱印ID
  * return : なし
  */
  @action
  void deleteGoshuinArrayOneData(String goshuinId) {
    for (var i = 0; i < goshuinArray.length; i++) {
      if (goshuinArray[i].id == goshuinId) {
        goshuinArray.removeAt(i);
        break;
      }
    }
  }

  /*
* リストの先頭に神社・寺院データ設定
* prm : value 神社・寺院データ<SpotData>
* return : なし
 */
  @action
  void setSpotArrayOneData(SpotData value) {
    var flg = false;
    for (var spot in spotArray) {
      if (spot.id == value.id) {
        flg = true;
        break;
      }
    }
    // 同じIDのデータがない場合、リストの先頭に神社・寺院データ設定
    if (!flg) {
      spotArray.insert(0, value);
    }
  }

  /*
  * 神社・寺院リストのデータを変更
  * prm : spotData 神社・寺院データ
  * return : なし
  */
  @action
  void updateSpotArrayOneData(SpotData spotData) {
    for (var i = 0; i < spotArray.length; i++) {
      if (spotArray[i].id == spotData.id) {
        // 削除
        spotArray.removeAt(i);
        // 削除した位置に追加
        spotArray.insert(i, spotData);
        break;
      }
    }
  }

  /*
  * 御朱印リストから削除
  * prm : spotId 神社・寺院ID
  * return : なし
  */
  @action
  void deleteSpotArrayOneData(String spotId) {
    for (var i = 0; i < spotArray.length; i++) {
      if (spotArray[i].id == spotId) {
        spotArray.removeAt(i);
        break;
      }
    }
  }

  /*
* 御朱印がupdateされた場合に神社・寺院データの詳細画面表示時の下に表示される関連の御朱印リストを修正
* ※神社一覧から御朱印詳細まで遷移し修正した場合、戻ると神社・寺院データの詳細画面表示時の下に御朱印リストが表示されるため
* prm : なし
* return : なし
 */
  void updateShowSpotDataUnderGoshuinList(GoshuinListData setListData) {
    // 更新前のデータ
    GoshuinListData beforeGoshuinData = showGoshuinData;

    if (showSpotDataUnderGoshuinList != null && showSpotDataUnderGoshuinList != "") {
      // ※神社・寺院が変更された場合、リストから削除
      if (beforeGoshuinData.spotId != editGoshuinSpotId) {
        for (var i = 0; i < showSpotDataUnderGoshuinList.length; i++) {
          // 対象の御朱印IDのデータをリストから削除
          if (showSpotDataUnderGoshuinList[i].id == editGoshuinId) {
            // 削除
            showSpotDataUnderGoshuinList.removeAt(i);
          }
        }
      }
      // 写真、御朱印名、参拝日が変更された場合、リストを修正
      else if (beforeGoshuinData.img != editGoshuinBase64Image ||
          beforeGoshuinData.goshuinName != editGoshuinName ||
          beforeGoshuinData.date != editGoshuinSanpaiDate) {
        for (var i = 0; i < showSpotDataUnderGoshuinList.length; i++) {
          if (showSpotDataUnderGoshuinList[i].id == editGoshuinId) {
            // 削除
            showSpotDataUnderGoshuinList.removeAt(i);
            // 削除した位置に追加
            showSpotDataUnderGoshuinList.insert(i, setListData);
          }
        }
      }
    }
  }

  /*
* 神社・寺院がupdateされた場合に御朱印リストの神社・寺院の情報を修正
* prm : spotData
* return : なし
 */
  void updateGoshuinSpotInfo(SpotData spotData) {
    for (var i = 0; i < goshuinArray.length; i++) {
      // 神社・寺院IDが一致する場合に情報修正
      if (goshuinArray[i].spotId == spotData.id) {
        GoshuinListData setListData = GoshuinListData(
          id: goshuinArray[i].id,
          img: goshuinArray[i].img,
          spotId: goshuinArray[i].spotId,
          spotName: spotData.spotName,
          spotPrefecturesNo: spotData.prefecturesNo,
          spotPrefectures: spotData.prefectures,
          goshuinName: goshuinArray[i].goshuinName,
          date: goshuinArray[i].date,
          memo: goshuinArray[i].memo,
          createData: goshuinArray[i].createData,
        );

        // 削除
        goshuinArray.removeAt(i);
        // 削除した位置に追加
        goshuinArray.insert(i, setListData);
      }
    }
  }

  /*
* DBのデータから都道府県別の御朱印データ一覧を作成
* prm : なし
* return : なし

  @action
  void setGoshuinArrayPef() {
    // 都道府県別の御朱印データ一覧のList
    List<MapEntry<String, List<MapEntry<String, List<GoshuinListData>>>>>
        goshuinDataList = [];

    // 一時的に格納するマップを設定（key：都道府県番号、value：都道府県番号ごとの御朱印データのList）
    Map<String, List<GoshuinListData>> goshuinMap = {};

    // 取得した御朱印リストから都道府県別にデータを設定する
    for (var goshuin in goshuinArray) {
      // 都道府県番号を取得
      var pefNum = goshuin.spotPrefecturesNo;

      // mapの中に同じ都道府県番号があるかチェック
      if (goshuinMap.containsKey(pefNum)) {
        // 存在する場合、リストに御朱印データを追加
        // 都道府県の御朱印リストを取得
        List<GoshuinListData> list = goshuinMap[pefNum];
        //リストの末尾に追加
        list.add(goshuin);
      } else {
        // 存在しない場合、mapに御朱印データを追加
        List<GoshuinListData> list = [goshuin];
        goshuinMap[pefNum] = list;
      }
    }

    // 都道府県順に並び替え
    for (var prefectures in prefecturesListdata) {
      // 都道府県番号と一致するデータがあるかチェック
      if (goshuinMap.containsKey(prefectures.key)) {
        // 存在する場合、spotId(神社・寺院ID)ごとにリスト生成

        // 一時的に格納するマップを設定（key：spotId(神社・寺院ID)、value：spotIdごとの御朱印データのList）
        Map<String, List<GoshuinListData>> goshuinMapspotId = {};
        // 都道府県番号ごとの御朱印データのListを取得
        List<GoshuinListData> goshuinlist = goshuinMap[prefectures.key];

        for (var goshuin in goshuinlist) {
          // mapの中に同じspotId(神社・寺院ID)があるかチェック
          if (goshuinMapspotId.containsKey(goshuin.spotId)) {
            // 存在する場合、リストに御朱印データを追加
            // spotIdごとの御朱印リストを取得
            List<GoshuinListData> list = goshuinMapspotId[goshuin.spotId];
            //リストの末尾に追加
            list.add(goshuin);
            // 一時的に格納するマップに御朱印データを変更
            // ★書く

          } else {
            // 存在しない場合、一時的に格納するマップに御朱印データを追加
            List<GoshuinListData> list = [goshuin];
            goshuinMapspotId[goshuin.spotId] = list;
          }
        }

        // spotId(神社・寺院ID)毎の御朱印リストを格納用に変換
        List<MapEntry<String, List<GoshuinListData>>> spotList = [];
        for (var key in goshuinMapspotId.keys) {
          spotList.add(MapEntry(key, goshuinMapspotId[key]));
        }

        // Listに追加
        goshuinDataList.add(MapEntry(prefectures.key, spotList));
      }
    }
    // データを格納
    goshuinArrayPef = goshuinDataList;
  }
*/

  /*
* DBのデータから都道府県別の神社・寺院データ一覧を作成
* ※都道府県昇順、区分昇順、ID昇順で並べる
* prm : なし
* return : なし
 */
  @action
  void setSpotArrayPef() {

    // 都道府県別の御朱印データ一覧のList
    List<MapEntry<String, List<SpotData>>>
    spotDataList = [];

    // 一時的に格納するマップを設定（key：都道府県番号、value：都道府県番号ごとの御朱印データのList）
    Map<String, List<SpotData>> spotMap = {};

    // 取得した神社・寺院一覧から都道府県別にデータを設定する
    for (var spot in spotArray) {
      // 都道府県番号を取得
      var pefNum = spot.prefecturesNo;

      // mapの中に同じ都道府県番号があるかチェック
      if (spotMap.containsKey(pefNum)) {
        // 存在する場合、リストに神社・寺院データを追加
        // 都道府県の神社・寺院リストを取得
        List<SpotData> list = spotMap[pefNum];
        //リストの末尾に追加
        list.add(spot);
      } else {
        // 存在しない場合、mapに神社・寺院データを追加
        List<SpotData> list = [spot];
        spotMap[pefNum] = list;
      }
    }

    // 都道府県順に並び替え
    for (var prefectures in prefecturesListdata) {
      // 都道府県番号と一致するデータがあるかチェック
      if (spotMap.containsKey(prefectures.key)) {
        // 存在する場合、区分昇順、ID昇順で並べる

        // 該当の都道府県の神社・寺院データを取得
        List<SpotData> dataList = spotMap[prefectures.key];
        dataList.sort(
              (a, b) {
            int result = a.kbn.compareTo(b.kbn);
            if (result != 0) return result;
            return a.id.compareTo(b.id);
          },
        );

        // Listに追加
        spotDataList.add(MapEntry(prefectures.key, dataList));
      }
    }
    // データを格納
    spotArrayPef = spotDataList;
  }


}
