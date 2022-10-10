import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin_edit/goshuin_edit.dart';
import 'package:goshuintsuzuri/components/goshuin_list/goshuin_list.dart';
import 'package:goshuintsuzuri/components/hukugen/hukugen.dart';
import 'package:goshuintsuzuri/components/jinja_list/jinja_list.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import '../app_store.dart';
import '../components/backup/backup.dart';
import 'common.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key, required this.store}) : super(key: key);

  // 引数取得
  final AppStore store;

  @override
  _RootWidgetState createState() => _RootWidgetState(store: store);
}

class _RootWidgetState extends State<RootWidget> {
  // 引数取得
  final AppStore store;

  _RootWidgetState({required this.store});

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

  @override
  void initState() {
    super.initState();
    // 画面下のタブ表示
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    for (var i = 1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
    }

    // DBからデータ取得
    void getData() async {
      // 御朱印最大ID取得
      GoshuinData goshuinMax = await DbGoshuinData().getMaxIdGoshuin();
      var goshuinMaxId = goshuinMax.id;
      var id = "";
      if (goshuinMaxId == null) {
        // 初回登録
        id = "";
      } else {
        id = goshuinMaxId;
      }
      store.setGoshuinMaxId(id);

      // 神社・寺院最大ID取得
      SpotData spotMax = await DbSpotData().getMaxIdSpot();
      var spotMaxId = spotMax.id;
      id = "";
      if (spotMaxId == null) {
        // 初回登録
        id = "";
      } else {
        id = spotMaxId;
      }
      store.setSpotMaxId(id);

      // 御朱印を全件取得
      ObservableList<GoshuinListData> goshuinObservableList =
          ObservableList.of([]);
      if (goshuinMaxId == null) {
        // 登録なしのためデータは空
      } else {
        List<GoshuinListData> goshuinList =
            await DbGoshuinData().getAllGoshuins();
        goshuinObservableList = ObservableList.of(goshuinList);
      }
      store.setGoshuinArray(goshuinObservableList);

      // 神社・寺院を全件取得
      ObservableList<SpotData> spotObservableList = ObservableList.of([]);
      if (spotMaxId == null) {
        // 登録なしのためデータは空
      } else {
        List<SpotData> spotList = await DbSpotData().getAllSpot();
        spotObservableList = ObservableList.of(spotList);
      }
      store.setSpotArray(spotObservableList);

      // DBのデータから都道府県別の神社・寺院データ一覧を作成
      store.setSpotArrayPef();
    }

    // DBからデータ取得を呼び出し
    getData();
  }

  /// インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
      ),
      label: _footerItemNames[index],
    );
  }

  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
      ),
      label: _footerItemNames[index],
    );
  }

  // 新規登録ボタン
  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        // 登録時・更新の御朱印データeditの保持
        editSetGoshuin(store, "0");

        // 更新前のデータを保持（比較チェック用）
        GoshuinListData goshuinListData = GoshuinListData(
          id: "",
          img: "",
          spotId: "",
          spotName: "",
          spotPrefecturesNo: "",
          spotPrefectures: "",
          goshuinName: "",
          date: "",
          memo: "",
          createData: "",
        );
        store.setShowGoshuinData(goshuinListData);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GoshuinEdit(
                    store: store,
                    kbn: '0',
                  )),
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
      GoshuinEdit(
        kbn: "0",
        store: store,
      ),
    ];
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        // 影
        title: Image(
          image: AssetImage(
            'assets/img/logo.png',
          ),
          height: 18,
        ),
        leading: IconButton(
          icon: Icon(Icons.dehaze),
          color: Color(0xFF707070),
          padding: new EdgeInsets.all(15.0),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
            // Scaffold.of(context).openDrawer();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      // drawer: DrawerContent(key: key, store: store,),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 60,
              child: DrawerHeader(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  '設定',
                  style: Styles.mainTextStyleLarge,
                ),
              ),
            ),
            ListTile(
              title: Text(
                "バックアップ・機種変更",
                style: Styles.mainTextStyle,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // バックアップ用のメルアド初期化
                store.setMailaddress("");
                // 画面遷移
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Backup(
                            store: store,
                          )),
                );
              },
            ),
            ListTile(
              title: Text(
                "データ復元",
                style: Styles.mainTextStyle,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Hukugen(
                            store: store,
                          )),
                );
              },
            ),
            ListTile(
              title: Text(
                "プライバシーポリシー",
                style: Styles.mainTextStyle,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
      body: _routes.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12.0,
        selectedItemColor: StylesColor.maincolor,
        unselectedItemColor: StylesColor.subTextColor2,
      ),
    );
  }
}
