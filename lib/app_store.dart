import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

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



  // 御朱印画像(base64)
  @observable
  String base64Image;

  // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  @observable
  String spotId;

  // 神社・寺院名
  @observable
  String spotName = "";

  // 神社・寺院 都道府県
  @observable
  String spotPrefectures = "";

  // 御朱印名
  @observable
  String goshuinName;

  // 参拝日
  @observable
  String sanpaiDate = "";

  // メモ
  @observable
  String memo;

  // 御朱印最大ID
  @observable
  String goshuinMaxId;

  // 御朱印登録エラーフラグ
  @observable
  bool goshuinErrFlg = true;

  // 御朱印一覧
  @observable
  List<GoshuinListData> goshuinArray;
  // 神社・寺院一覧
  @observable
  List<SpotData> spotArray;


  @action
  void setBase64Image(String value){
    base64Image = value;
  }
  @action
  void setSpotId(String value){
    spotId = value;
  }
  @action
  void setSpotName(String value){
    spotName = value;
  }
  @action
  void setSpotPrefectures(String value){
    spotPrefectures = value;
  }
  @action
  void setName(String value){
    goshuinName = value;
  }
  @action
  void setSanpaiDate(String value){
    sanpaiDate = value;
  }
  @action
  void setGoshuinMaxId(String value){
    goshuinMaxId = value;
  }
  @action
  void setGoshuinErrFlg(bool value){
    goshuinErrFlg = value;
  }
  @action
  void setGoshuinArray(List<GoshuinListData> value){
    goshuinArray = value;
  }
  @action
  void setSpotArray(List<SpotData> value){
    spotArray = value;
  }

  // リストの先頭に御朱印データ設定
  @action
  void setGoshuinArrayOneData(GoshuinListData value){
    goshuinArray.insert(0, value);
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
  Color get whiteOrNot =>
      primary == Colors.white ? Colors.white : secondary;

}
