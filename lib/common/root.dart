import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/components/goshuin_edit/goshuin_edit.dart';
import 'package:goshuintsuzuri/components/goshuin_list/goshuin_list.dart';
import 'package:goshuintsuzuri/components/jinja_list/jinja_list.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../app_store.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({Key key, @required this.store}) : super(key: key);

  // 引数取得
  final AppStore store;

  @override
  _RootWidgetState createState() => _RootWidgetState(store: store);
}

class _RootWidgetState extends State<RootWidget> {
  // 引数取得
  final AppStore store;
  _RootWidgetState({this.store});
  int _selectedIndex = 0;
  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  static const _footerIcons = [
    Icons.home,
    FontAwesomeIcons.toriiGate,
    FontAwesomeIcons.cameraRetro,
  ];

  static const _footerItemNames = [
    '御朱印帳',
    '神社・寺院',
    '登録',
  ];

  // === 追加部分 ===
  // var _routes = [
  //   GoshuinList(store: store),
  //   JinjaList(),
  //   GoshuinEdit(kbn: "0"),
  // ];

  // ==============

  @override
  void initState() {
    super.initState();
    // 画面下のタブ表示
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    for (var i = 1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
    }

    // DBからデータ取得
    List<GoshuinListData> value = [
GoshuinListData(id: "GSI000005",
        img: "",
        spotId: "26-00002",
        spotName: "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社",
        spotPrefectures: "京都府",
        goshuinName: "限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印",
        date: "2021.10.10",
        memo: "テストテスト",
        createData: "2021.10.20",),
      GoshuinListData(id: "GSI000002",
        img: "",
        spotId: "33-00001",
        spotName: "最上稲荷",
        spotPrefectures: "岡山県",
        goshuinName: "通常御朱印",
        date: "2021.10.20",
        memo: "テストテスト",
        createData: "2021.10.20",),
       GoshuinListData(id: "GSI000003",
        img: "",
        spotId: "26-00001",
        spotName: "清水寺",
        spotPrefectures: "京都府",
        goshuinName: "限定御朱印",
        date: "2021.10.30",
        memo: "テストテスト",
        createData: "2021.10.20",),
        GoshuinListData(id: "GSI000004",
          img: "",
          spotId: "26-00002",
          spotName: "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社",
          spotPrefectures: "京都府",
          goshuinName: "限定御朱印",
          date: "2021.10.10",
          memo: "テストテスト",
          createData: "2021.10.20",),
    ];
    store.setGoshuinArray(value);
    // DBからデータ取得
    List<SpotData> value2 = [
      SpotData(
          id: "26-00001",
          spotName: "清水寺",
          kbn: "2",
          prefectures: "京都府",
          prefecturesNo: "26",
          img: "",
          createData: "2021.10.20",),
      SpotData(
        id: "33-00001",
        spotName: "最上稲荷",
        kbn: "3",
        prefectures: "岡山県",
        prefecturesNo: "33",
        img: "",
        createData: "2021.10.20",),
      SpotData(
        id: "26-00002",
        spotName: "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社",
        kbn: "1",
        prefectures: "京都府",
        prefecturesNo: "26",
        img: "",
        createData: "2021.10.20",),
    ];
    store.setSpotArray(value2);
    // DBのデータから都道府県別の御朱印データ一覧を作成
    store.setGoshuinArrayPef();
// ★あとで削除
    print(store.goshuinArrayPef);
  }

  /// インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Color(0xFFE75331),
        ),
        title: Text(
          _footerItemNames[index],
          style: TextStyle(
            color: Color(0xFFE75331),
          ),
        ));
  }

  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black26,
        ),
        title: Text(
          _footerItemNames[index],
          style: TextStyle(
            color: Colors.black26,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        // Navigator.pushNamed(context, '/addGoshuin');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoshuinEdit(store: store)),
        );


      } else {
        _bottomNavigationBarItems[_selectedIndex] =
            _UpdateDeactiveState(_selectedIndex);
        _bottomNavigationBarItems[index] = _UpdateActiveState(index);
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var _routes = [
      GoshuinList(store: store),
      JinjaList(store: store),
      GoshuinEdit(kbn: "0"),
    ];

    return Scaffold(
      body: _routes.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12.0,
      ),
    );
  }
}
