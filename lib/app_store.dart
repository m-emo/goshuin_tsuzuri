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
  @observable
  Color primary;

  @observable
  Color secondary;

  // 写真//たぶん消す★
  @observable
  Uint8List bytesImage;

  // 御朱印ID[GSI+連番6桁（GSI000001）]
  @observable
  String editGoshuinId;

  // 御朱印画像(base64)
  @observable
  String editBase64Image;

  // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  @observable
  String editSpotId;

  // 神社・寺院名
  @observable
  String editSpotName = "";

  // 神社・寺院 都道府県
  @observable
  String editSpotPrefectures = "";

  // 御朱印名
  @observable
  String editGoshuinName;

  // 参拝日
  @observable
  String editSanpaiDate = "";

  // メモ
  @observable
  String editMemo;


  // 御朱印最大ID
  @observable
  String goshuinMaxId;

  // 御朱印登録エラーフラグ
  @observable
  bool goshuinErrFlg = true;

  // 御朱印一覧
  @observable
  List<GoshuinListData> goshuinArray;

  // 御朱印一覧(都道府県別）
  //(例）
  //[
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
  List<MapEntry<String,  List<MapEntry<String, List<GoshuinListData>>>>> goshuinArrayPef;


  // 神社・寺院一覧
  @observable
  List<SpotData> spotArray;

  @action
  void setEditGoshuinId(String value) {
    editGoshuinId = value;
  }

  @action
  void setEditBase64Image(String value) {
    editBase64Image = value;
  }

  @action
  void setEditSpotId(String value) {
    editSpotId = value;
  }

  @action
  void setEditSpotName(String value) {
    editSpotName = value;
  }

  @action
  void setEditSpotPrefectures(String value) {
    editSpotPrefectures = value;
  }

  @action
  void setEditGoshuinName(String value) {
    editGoshuinName = value;
  }

  @action
  void setEditSanpaiDate(String value) {
    editSanpaiDate = value;
  }

  @action
  void setEditMemo(String value) {
    editMemo = value;
  }
  @action
  void setGoshuinMaxId(String value) {
    goshuinMaxId = value;
  }

  @action
  void setGoshuinErrFlg(bool value) {
    goshuinErrFlg = value;
  }

  @action
  void setGoshuinArray(List<GoshuinListData> value) {
    goshuinArray = value;
  }

  @action
  void setSpotArray(List<SpotData> value) {
    spotArray = value;
  }

  /*
  * リストの先頭に御朱印データ追加
  * prm : goshuinId 御朱印ID
  * return : なし
  */
  @action
  void setGoshuinArrayOneData(GoshuinListData value) {
    goshuinArray.insert(0, value);
  }

  /*
  * リストのデータを変更
  * prm : goshuinListData 御朱印データ
  * return : なし
  */
  @action
  void updateGoshuinArrayOneData(GoshuinListData goshuinListData) {
    for (var i = 0; i < goshuinArray.length; i++) {
      if (goshuinArray[i].id== goshuinListData.id) {
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
* DBのデータから都道府県別の御朱印データ一覧を作成
* prm : なし
* return : なし
 */
  @action
  void setGoshuinArrayPef() {
    // 都道府県別の御朱印データ一覧のList
    List<MapEntry<String,  List<MapEntry<String, List<GoshuinListData>>>>> goshuinDataList = [];

    // 一時的に格納するマップを設定（key：都道府県番号、value：都道府県番号ごとの御朱印データのList）
    Map<String, List<GoshuinListData>> goshuinMap = {};

    // 取得した御朱印リストから都道府県別にデータを設定する
    for (var goshuin in goshuinArray) {
      //spotId(神社・寺院ID) [都道府県番号-都道府県番号内の連番5桁（03-00001）]から都道府県番号を取得
      var pefNum = (goshuin.spotId).substring(0,2);

      // mapの中に同じ都道府県番号があるかチェック
      if(goshuinMap.containsKey(pefNum)){
        // 存在する場合、リストに御朱印データを追加
        // 都道府県の御朱印リストを取得
        List<GoshuinListData> list = goshuinMap[pefNum];
        //リストの末尾に追加
        list.add(goshuin);

      }else{
        // 存在しない場合、mapに御朱印データを追加
        List<GoshuinListData> list = [goshuin];
        goshuinMap[pefNum] = list;
      }
    }

    // 都道府県順にマップを並び替え
    for(var prefectures in prefecturesListdata){
      // 都道府県番号と一致するデータがあるかチェック
      if(goshuinMap.containsKey(prefectures.key)){
        // 存在する場合、spotId(神社・寺院ID)ごとにリスト生成

        // 一時的に格納するマップを設定（key：spotId(神社・寺院ID)、value：spotIdごとの御朱印データのList）
        Map<String, List<GoshuinListData>> goshuinMapspotId = {};
        // 都道府県番号ごとの御朱印データのListを取得
        List<GoshuinListData> goshuinlist =  goshuinMap[prefectures.key];

        for (var goshuin in goshuinlist) {
          // mapの中に同じspotId(神社・寺院ID)があるかチェック
          if(goshuinMapspotId.containsKey(goshuin.spotId)){
            // 存在する場合、リストに御朱印データを追加
            // spotIdごとの御朱印リストを取得
            List<GoshuinListData> list = goshuinMapspotId[goshuin.spotId];
            //リストの末尾に追加
            list.add(goshuin);
            // 一時的に格納するマップに御朱印データを変更
            // ★書く

          }else{
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
        goshuinDataList.add(MapEntry(prefectures.key,  spotList));
      }
    }
    // データを格納
    goshuinArrayPef = goshuinDataList;

    // ★後で消す
    print(goshuinArrayPef);
  }





  // ignore: use_setters_to_change_properties
  @action
  void setPrimary(Color value) {
    primary = value;
  }

  // ignore: use_setters_to_change_properties
  @action
  void setSecondary(Color value) {
    secondary = value;
  }

  @computed
  Color get whiteOrNot => primary == Colors.white ? Colors.white : secondary;
}
