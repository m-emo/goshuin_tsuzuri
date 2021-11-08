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

  // 編集前の御朱印データ
  GoshuinListData beforeGoshuinData;

  // 編集前の神社・寺院データ
  SpotData beforeSpotData;

  // 御朱印最大ID
  @observable
  String goshuinMaxId;

  // 神社・寺院最大ID
  @observable
  String spotMaxId;

  // 御朱印登録・変更チェックエラーフラグ
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
  void setBeforeGoshuinData(GoshuinListData value) {
    beforeGoshuinData = value;
  }

  @action
  void setBeforeSpotData(SpotData value) {
    beforeSpotData = value;
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
* 神社・寺院がupdateされた場合に御朱印リストの神社・寺院の情報を修正
* prm : なし
* return : なし
 */
  void updateGoshuinSpotInfo(SpotData spotData) {
    for (var i = 0; i < goshuinArray.length; i++) {
      // 神社・寺院IDが一致する場合に情報修正
      if (goshuinArray[i].spotId== spotData.id) {

        GoshuinListData setListData = GoshuinListData(
          id: goshuinArray[i].id,
          img: goshuinArray[i].img,
          spotId: goshuinArray[i].spotId,
          spotName: spotData.spotName,
          spotPrefecturesNo:spotData.prefecturesNo,
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
 */
  @action
  void setGoshuinArrayPef() {
    // 都道府県別の御朱印データ一覧のList
    List<MapEntry<String,  List<MapEntry<String, List<GoshuinListData>>>>> goshuinDataList = [];

    // 一時的に格納するマップを設定（key：都道府県番号、value：都道府県番号ごとの御朱印データのList）
    Map<String, List<GoshuinListData>> goshuinMap = {};

    // 取得した御朱印リストから都道府県別にデータを設定する
    for (var goshuin in goshuinArray) {
      // 都道府県番号を取得
      var pefNum = goshuin.spotPrefecturesNo;

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

    // 都道府県順に並び替え
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
  }


















//
//   // 御朱印データが存在する都道府県リスト（key：都道府県番号、value：spotId(神社・寺院ID)のリスト）
//   @observable
//   List<MapEntry<String, List<String>>> goshuinPefArray;
//   // spotId(神社・寺院ID)ごとの御朱印IDマップ（key：spotId(神社・寺院ID)、value：御朱印IDのリスト）
//   @observable
//   Map<String, List<String>> goshuinSpotIdMap;
//   // 御朱印データのMap型保持版（都道府県別表示に利用）
//   @observable
//   Map<String, GoshuinListData> goshuinDataMap;
//   /*
// * DBのデータから御朱印データが存在する都道府県リストを作成
// * prm : なし
// * return : なし
//  */
//   @action
//   void setGoshuinPefArray() {
//     // 御朱印データが存在する都道府県リスト（key：都道府県番号、value：spotId(神社・寺院ID)のリスト）
//     List<MapEntry<String, List<String>>> ichijiGoshuinPefArray=[];
//     // spotId(神社・寺院ID)ごとの御朱印IDマップ（key：spotId(神社・寺院ID)、value：御朱印IDのリスト）
//     Map<String, List<String>> ichijiGoshuinSpotIdMap ={};
//     // 御朱印データのMap型保持版（都道府県別表示に利用）
//     Map<String, GoshuinListData> ichijiGoshuinDataMap ={};
//
//
//
//       // 一時的に格納するマップを設定（key：都道府県番号、value：都道府県番号ごとの御朱印データのList）
//       Map<String, List<GoshuinListData>> goshuinMap = {};
//
//       // 取得した御朱印リストから都道府県別にデータを設定する
//       for (var goshuin in goshuinArray) {
//         //spotId(神社・寺院ID) [都道府県番号-都道府県番号内の連番5桁（03-00001）]から都道府県番号を取得
//         var pefNum = (goshuin.spotId).substring(0,2);
//
//         // mapの中に同じ都道府県番号があるかチェック
//         if(goshuinMap.containsKey(pefNum)){
//           // 存在する場合、リストに御朱印データを追加
//           // 都道府県の御朱印リストを取得
//           List<GoshuinListData> list = goshuinMap[pefNum];
//           //リストの末尾に追加
//           list.add(goshuin);
//
//         }else{
//           // 存在しない場合、mapに御朱印データを追加
//           List<GoshuinListData> list = [goshuin];
//           goshuinMap[pefNum] = list;
//         }
//       }
//
//       // 都道府県順に並び替え
//       for(var prefectures in prefecturesListdata){
//         // 都道府県番号と一致するデータがあるかチェック
//         if(goshuinMap.containsKey(prefectures.key)){
//           //　一時的にspotId(神社・寺院ID)ごとの御朱印IDを格納するマップを設定（key：spotId(神社・寺院ID)、value：御朱印IDのList）
//           Map<String, List<String>> spotIdGoshuinIdMap = {};
//
//           // 都道府県番号ごとの御朱印データのListを取得
//           List<GoshuinListData> goshuinlist =  goshuinMap[prefectures.key];
//
//           for (var goshuin in goshuinlist) {
//             // mapの中に同じspotId(神社・寺院ID)があるかチェック
//             if(spotIdGoshuinIdMap.containsKey(goshuin.spotId)){
//               // 存在する場合、spotId(神社・寺院ID)ごとの御朱印IDを格納するマップに御朱印ID追加
//               List<String> list = spotIdGoshuinIdMap[goshuin.spotId];
//               list.add(goshuin.id);
//             }else{
//               // 存在しない場合、一時的に格納するマップに追加
//               List<String> list = [goshuin.id];
//               spotIdGoshuinIdMap[goshuin.spotId] = list;
//             }
//           }
//
//           // spotId(神社・寺院ID)リスト,御朱印IDのリストを格納用に変換
//           List<String> spotIdList = [];
//           for (var spotId in spotIdGoshuinIdMap.keys) {
//             List<String> goshuinIdList = [];
//             spotIdList.add(spotId);
//
//             for(var goshuinId in spotIdGoshuinIdMap[spotId]){
//               goshuinIdList.add(goshuinId);
//             }
//
//             // spotId(神社・寺院ID)ごとの御朱印IDマップに追加（key：spotId(神社・寺院ID)、value：御朱印IDのリスト）
//             ichijiGoshuinSpotIdMap[spotId] = goshuinIdList;
//           }
//
//           // 都道府県リストに追加（key：都道府県番号、value：spotId(神社・寺院ID)のリスト）
//           ichijiGoshuinPefArray.add(MapEntry(prefectures.key, spotIdList));
//         }
//       }
//
//       // 御朱印リスト一覧をMapに変換（都道府県別表示に利用）
//       goshuinArray.forEach((goshuin) => ichijiGoshuinDataMap[goshuin.id] = goshuin);
//
//       // それぞれを登録
//     goshuinSpotIdMap = ichijiGoshuinSpotIdMap;
//     goshuinPefArray = ichijiGoshuinPefArray;
//     goshuinDataMap = ichijiGoshuinDataMap;
//
//     // ★表示用なので消す
//     print(goshuinSpotIdMap);
//       print(goshuinPefArray);
//       print(goshuinDataMap);
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//   // ★やめるかも
//   /*
// * 都道府県別の御朱印データ一覧の先頭にに1件追加
// * prm : goshuinListData 御朱印データ
// * return : なし
//  */
//
//   @action
//   void setGoshuinArrayPefOneData(GoshuinListData goshuinListData) {
//     //spotId(神社・寺院ID) [都道府県番号-都道府県番号内の連番5桁（03-00001）]から都道府県番号を取得
//     var pefNum = (goshuinListData.spotId).substring(0,2); // 文字列
//     int pefNumIntSetdata = int.parse(pefNum); // 数値
//
//     // 都道府県がすでにあるかチェック
//       for(int j = 0; j < goshuinArrayPef.length; j++){
//       // 都道府県番号が一致した場合、リストに御朱印データを追加
//       if(goshuinArrayPef[j].key == pefNum){
//         // 都道府県の御朱印リストを取得
//         List<MapEntry<String, List<GoshuinListData>>> goshuinMapList = goshuinArrayPef[j].value;
//
//         // 都道府県別の御朱印リストから同じspotId(神社・寺院ID)があるかチェック
//
//         for(int i = 0; i < goshuinMapList.length; i++){
//           var spotId = goshuinListData.spotId;
//           if(goshuinMapList[i].key == spotId){
//             // 同じspotId(神社・寺院ID)が存在する場合
//             // spotId(神社・寺院ID)の御朱印リストを取得
//             List<GoshuinListData> goshuinSpotList = goshuinMapList[i].value;
//             //リストの末尾に追加
//             goshuinSpotList.add(goshuinListData);
//
//             // 都道府県の御朱印リストを更新(削除して追加）
//             goshuinMapList.removeAt(i);
//             // 削除した位置に追加
//             goshuinMapList.insert(i, MapEntry(spotId, goshuinSpotList));
//
//
//             break;
//
//             // List<MapEntry<String,  List<MapEntry<String, List<GoshuinListData>>>>> goshuinArrayPef;
//
//
//           }
//         }
//
//
//         // List<GoshuinListData> list = (goshuinMapPef.value).;
//         // //リストの末尾に追加
//         // list.add(goshuin);
//       }
//
//     }
//
//
//
//   }
//


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
