import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'dao/db_goshuin_data.dart';

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
  List<GoshuinList> goshuinArray = [
    GoshuinList(id: "GSI000001",
      img: "",
      spotId: "03-00001",
      spotName: "八坂神社",
      spotPrefectures: "京都",
      goshuinName: "限定御朱印",
      date: "2021.10.10",
      memo: "テストテスト",
      createData: "2021.10.20",),
    GoshuinList(id: "GSI000002",
      img: "",
      spotId: "03-00001",
      spotName: "最上稲荷",
      spotPrefectures: "岡山",
      goshuinName: "通常御朱印",
      date: "2021.10.20",
      memo: "テストテスト",
      createData: "2021.10.20",),
    GoshuinList(id: "GSI000003",
      img: "",
      spotId: "03-00001",
      spotName: "清水寺",
      spotPrefectures: "京都",
      goshuinName: "限定御朱印",
      date: "2021.10.30",
      memo: "テストテスト",
      createData: "2021.10.20",),
  ];

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
