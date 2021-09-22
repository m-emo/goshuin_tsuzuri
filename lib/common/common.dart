import 'package:flutter/material.dart';

import '../app_store.dart';

/*画像がない場合は初期画像を表示*/
Image showImg(String bytesImage) {
  if (null == bytesImage || "" == bytesImage) {
    // 画像なし
    return Image(
      image: AssetImage(
        'assets/img/logo.png',
      ),
    );
  } else {
    // 画像あり
    return Image(
      image: AssetImage(
        'assets/img/logo.png',
      ),
    );
    // return Image.memory(
    //   bytesImage,
    //   fit: BoxFit.cover,
    // );
  }
}

/*editのリセット*/
void editReset(AppStore store){
  store.setEditGoshuinId(""); // 御朱印ID[GSI+連番6桁（GSI000001）]
  store.setEditBase64Image(""); // 御朱印画像(base64)
  store.setEditSpotId(""); // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  store.setEditSpotName(""); // 神社・寺院名
  store.setEditSpotPrefectures(""); // 神社・寺院 都道府県
  store.setEditGoshuinName(""); // 御朱印名
  store.setEditSanpaiDate(""); // 参拝日
  store.setEditMemo(""); // メモ
}

/*編集中かチェック*/
void checkEdit(AppStore store){
  // 御朱印IDが空の場合、新規登録になる
  print("★よんだ");
  print(store.editGoshuinId);
  if(store.editGoshuinId == null || store.editGoshuinId == ""){
    print("★空");
  }

}


/*都道府県リスト*/
const List<MapEntry<String, String>> prefecturesListdata = [
  MapEntry("01", "北海道"),
  MapEntry ("02", "青森県"),
  MapEntry ("03", "岩手県"),
  MapEntry ("04", "宮城県"),
  MapEntry ("05", "秋田県"),
  MapEntry ("06", "山形県"),
  MapEntry ("07", "福島県"),
  MapEntry ("08", "茨城県"),
  MapEntry ("09", "栃木県"),
  MapEntry ("10", "群馬県"),
  MapEntry ("11", "埼玉県"),
  MapEntry ("12", "千葉県"),
  MapEntry ("13", "東京都"),
  MapEntry ("14", "神奈川県"),
  MapEntry ("15", "新潟県"),
  MapEntry ("16", "富山県"),
  MapEntry ("17", "石川県"),
  MapEntry ("18", "福井県"),
  MapEntry ("19", "山梨県"),
  MapEntry ("20", "長野県"),
  MapEntry ("21", "岐阜県"),
  MapEntry ("22", "静岡県"),
  MapEntry ("23", "愛知県"),
  MapEntry ("24", "三重県"),
  MapEntry ("25", "滋賀県"),
  MapEntry ("26", "京都府"),
  MapEntry ("27", "大阪府"),
  MapEntry ("28", "兵庫県"),
  MapEntry ("29", "奈良県"),
  MapEntry ("30", "和歌山県"),
  MapEntry ("31", "鳥取県"),
  MapEntry ("32", "島根県"),
  MapEntry ("33", "岡山県"),
  MapEntry ("34", "広島県"),
  MapEntry ("35", "山口県"),
  MapEntry ("36", "徳島県"),
  MapEntry ("37", "香川県"),
  MapEntry ("38", "愛媛県"),
  MapEntry ("39", "高知県"),
  MapEntry ("40", "福岡県"),
  MapEntry ("41", "佐賀県"),
  MapEntry ("42", "長崎県"),
  MapEntry ("43", "熊本県"),
  MapEntry ("44", "大分県"),
  MapEntry ("45", "宮崎県"),
  MapEntry ("46", "鹿児島県"),
  MapEntry ("47", "沖縄県"),
  MapEntry ("98", "海外"),
  MapEntry ("99", "その他")
];