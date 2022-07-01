import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/components/goshuin_edit/goshuin_edit.dart';
import 'package:goshuintsuzuri/components/goshuin_list/goshuin_list.dart';
import 'package:goshuintsuzuri/components/jinja_list/jinja_list.dart';
import 'package:goshuintsuzuri/dao/db_goshuin_data.dart';
import 'package:goshuintsuzuri/dao/db_spot_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';
import '../app_store.dart';
import 'common.dart';
import 'header.dart';

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
      ObservableList<GoshuinListData> goshuinObservableList = ObservableList.of([]);
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

    // store.setGoshuinMaxId("GSI001001");
    // store.setSpotMaxId("SPT001001");
/*
    ObservableList<GoshuinListData> value = ObservableList.of([
      GoshuinListData(
        id: "GSI000005",
        img: img5,
        spotId: "SPT000002",
        spotName: "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社",
        spotPrefecturesNo: "26",
        spotPrefectures: "京都府",
        goshuinName: "限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印限定御朱印",
        date: "2021.10.10",
        memo: "テストテスト",
        createData: "2021.10.20",
      ),
      GoshuinListData(
        id: "GSI000002",
        img: img2,
        spotId: "SPT000001",
        spotName: "最上稲荷",
        spotPrefecturesNo: "33",
        spotPrefectures: "岡山県",
        goshuinName: "通常御朱印",
        date: "2021.10.20",
        memo: "テストテスト",
        createData: "2021-10-29T05:14:07.009299Z",
      ),
      GoshuinListData(
        id: "GSI000003",
        img: img3,
        spotId: "SPT000003",
        spotName: "清水寺",
        spotPrefecturesNo: "26",
        spotPrefectures: "京都府",
        goshuinName: "限定御朱印",
        date: "2021.10.30",
        memo: "テストテスト",
        createData: "2021-10-29T05:14:07.009299Z",
      ),
      GoshuinListData(
        id: "GSI000004",
        img: img4,
        spotId: "SPT000002",
        spotName: "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社",
        spotPrefecturesNo: "26",
        spotPrefectures: "京都府",
        goshuinName: "限定御朱印",
        date: "2021.10.10",
        memo: "テストテスト",
        createData: "2021-10-29T05:14:07.009299Z",
      ),
    ]);
    store.setGoshuinArray(value);
    */
/*
    ObservableList<SpotData> value2 = ObservableList.of([
      SpotData(
        id: "SPT000002",
        spotName: "八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社八坂神社",
        kbn: "1",
        prefectures: "京都府",
        prefecturesNo: "26",
        img: img2_s,
        createData: "2021.10.20",
      ),
      SpotData(
        id: "SPT000012",
        spotName: "下賀茂神社",
        kbn: "1",
        prefectures: "京都府",
        prefecturesNo: "26",
        img: img2_s,
        createData: "2021.10.20",
      ),
      SpotData(
        id: "SPT000003",
        spotName: "清水寺",
        kbn: "2",
        prefectures: "京都府",
        prefecturesNo: "26",
        img: img3_s,
        createData: "2021.10.20",
      ),
      SpotData(
        id: "SPT000001",
        spotName: "最上稲荷",
        kbn: "3",
        prefectures: "岡山県",
        prefecturesNo: "33",
        img: img1_s,
        createData: "2021.10.20",
      ),
    ]);
    store.setSpotArray(value2);
*/

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
      // JinjaList(store: store),
      JinjaList(store: store),
      GoshuinEdit(kbn: "0"),
    ];
    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _key,
      // appBar: Header(key:_key),
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
            _key.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text("Item 1"),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              title: Text("Item 2"),
              trailing: Icon(Icons.arrow_forward),
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

// ★後で消す
  String img5 =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAAESUlEQVR4nO2csUvzThjHn/74TeriYLGD0JB2skX8A6KDf4BCQFxcb/AfCIiLSzq5CA462kUEIe7VxSVOIrY4GElAXOogtJ7r/YaXvry+SfqrbZJ7zjwf6PKEHt/wae4ud0kLQggBBBr+kR2A+AoJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQQYJQca/sgN8h6urKzg/P0+svaWlJdjZ2UmsvUQQCmFZlgCARD/tdlv2aX1BqS7r/f1ddoTUKQihzusIhUIh8Tbb7TYsLi4m3u64KHOFfH5+Jt6mrutQLBYTb3cSlBnUfd8P1UzThP39/bHbLBaLMDc3N0msxFFGyMfHR6hWqVRQdTdJoEyX9fT0FKrVajUJSdJFGSEvLy+hWqlUkpAkXZQREgRBqDY/P599kJRRZtpbqVTg+fn5S41zDlNTU5ISpYMyQv6+B9F1HTzPk5QmPZTosjqdTqi2trYmIUn6KCEkaspbLpezD5IBSgiJmvIuLCxISJI+Sgjp9XqhWrValZAkfZQQcn9/H6rNzMxISJI+SiydPD4+hmqHh4eh2uzsLNRqNahWq1Cv15WcEisx7R132d2yLNje3lZrvUve3tho+L4/8a4gY0z4vi/7VEYC/RjCOZ+4jZOTE9A0DS4vLxNIlC7ohUTdg4zLxsYGNBqNxNpLAyXGkNvbWwD4NbOanp4O3RQGQQCcc7i7uwPHceDi4mJoe0dHR/ieNhkgu89Mg263K2zbHjquuK4rO2YkP1LIANd1ha7rkUIMwxCcc9kRQyjRZU1CEASgaVrkMcdxYH19PeNEw0E/qE9KuVyGZrMZeezg4CDjNP/Pj79CBqysrMDNzU2o7vs+qpXjH3+FDNja2oqsR62TySQ3QlZXVyPr/X4/4yTDyY2QuPWsqG5MJrkRogokBBm5F4JphgWQIyFxT89j25vPjZCHh4fIOra9+dwIub6+jqzX6/WMkwwnF3fqb29vkS/mMMbg+PhYQqJ4cnGF7O3tRdY3NzczTjICMpeasyBuX8QwDNnRIkEtxHEcwRgb+9XlYZtUtEH1Tf5+2oQxJlqt1kjfdV1XGIYRK8O27ZTTjw/aQb3RaMDu7m7kMcYYGIYBpVLp90s7nufB6+srnJ2dDV2fMk0TTk9P8T5EJ/sXEUW32038HxsAQJimiXLb9k9QzrI456DreqJt2raN+8oYIPsXEQfnXDSbzdiHFEb9GIaB7v9MhoFWyADOuWi1WoIx9i0RlmWNPAnABNpBPY5OpwOe50G/34der/d7C9YwDAAAWF5eBk3T8HdNMSgn5KeDclDPMyQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGSQEGf8Bsif0GGGaLT4AAAAASUVORK5CYII=";
  String img2 =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAADrElEQVR4nO2bMUvzQBjHH1/eWXCws1IcRB2cBCGL+AUk4uZaED9AR8Ehm6MK4naz0N1M6pBVODclnVtEUNL1cfLFtpek9q25/12eH9zypGn/7S/XOy65OWZmEmD4YzuAMIwIAUOEgCFCwBAhYIgQMEQIGCIEDBEChggBQ4SAIULAECFgiBAwRAgYIgQMEQKGCAFDhIAhQsAQIWCIEDBECBgiBAwRAsZf2wH+h8FgQGma0vPzM318fAwd29zcpEajQYuLi5bSTQk7RpZlHMcxh2HIRFTawjDkTqfDWZbZjj4RzgjJsoyVUtxsNicSMdqCIOAkSWx/jVKcEKK15iAIphIx2s7Pz21/nULghSilZiLCFSlzzLjbES4uLuj4+LjwNWEY0s7ODs3PzxMR0fv7Oz0+PtLV1VXheUmS0NbW1syyzgzbV0QRSZIYr/Bms8lKKe71ernnfo05pvO/3gNxoIcWwszcarWGfsgoin70Q2qtcycCSqlfTD4d8EK01v+u6GlnSZ1OJ3fmhQb0GDJL9vf36ebmZqyepiktLS1VHyiH2iydHB4eGusPDw8VJymmNkK2t7eNda11xUmKqY2QvDWtt7e3ipMUUxshRERBENiOUEqthKyurtqOUEqthLy+vtqOUEqthJimvQsLCxaS5FMbId1u11hfX1+vNkgJtRHy8vJirK+srFScpJjaCLm9vTXWNzY2Kk5Sgu21myro9XrGtax2u2072hi16CHX19fG+t7eXsVJyvF+cbHf71Oj0RirB0FAd3d3FhIV430POTs7M9ZPTk4qTjIZXveQp6cn47QWtXcQedxDBoMBHR0dGY9dXl5WnGZyvBVyenpK9/f3Y/V2u01ra2sWEk2I3Une75B3yxb1wYbveDeGdLtdWl5eNh7TWmP3DvLsL6vf79Pu7q7xmFIKXgYR+fOXlWVZ7gPYrVbLdryJ8UZInowwDOHHje94ISSKotxBPE1T2/F+hPNCfJLB7LiQPBlE5MReEBPOCil6kDqOY9vxpsZJIXEceymD2UEhPstgdkyI7zKYHRJSJAN5i9pPcUJIkYwoimzHmynwQuokgxlcSJqmudvRfJTBDCykSMasG5JcWCGjmz1/u6Hg1f0QHxAhYMAKOTg4qOyzoiiq7LPK8O6euuvA9pC6IkLAECFgiBAwRAgYIgQMEQKGCAFDhIAhQsAQIWCIEDBECBgiBAwRAoYIAUOEgCFCwBAhYIgQMEQIGCIEDBEChggBQ4SA8Qmu/vaEynODIAAAAABJRU5ErkJggg==";
  String img3 =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEjUlEQVR4nO2cvUvrXhyHP738JsWx3QqVukhF6CrERUXqGgUHBaeC/gNFcHLopls3XcyqUByqQtqlInHq0lJEagsuksx1Pb/h3it6m6Rvac43zfeBDJ605ZM+53hectKIEEKAIcMv2QGYn7AQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYrAQYvwnO8A4WJYF0zRRq9V+lKfTacRiMUSjUUnJRidwQp6fn1GpVHB5eYlWq+X6WkVRsLu7i52dneDIEQFB13WhKIoAMNKhaZrsSxgI8kLq9fpYIr4fqqqKbrcr+5JcIS3EMAxPRARJSkQIurvfLctCLBZzPK8oClZWVrC0tPRVVq1WUS6XXfuXQqGAo6MjT7N6huwa0Y98Pt9Ty/P5vKjX647v6Xa7olgsimQy6dhSTNP08SoGh7wQ0zS/vsRsNjvUF9lutx2lFAqFCaYeHfJChPgtxa1FuKHruq0QRVE8TukNpPsQr1hdXUW1Wu0pN02T3PwkFEsnmUzGttw0TZ+T9CcUQuLxuOwIAxMKIUGChRAjFELq9bpt+fz8vM9J+jP1oyyn2b6qqri+vpaQyJ2pbyEnJye25YeHhz4nGRC506DJYrfsAsKTQiECMlMfFtM0RS6Xc1zHGnXW7weBu2PoRqfTQalUwvn5ueNqr6ZpSKVSPicbnMAJ6XQ6eHx8/FFWrVbRbDZtl0e+UygUsLe3N8l44yO7iQ6L25K605FMJoVhGLKjD0Tghr2RSGTo9+i6jrW1tQmk8Z6pH/YCwPr6Ora3t9FoNGRH6Y/sJjosTkPZQQ/qu08C9y8LgG1N//j4wMvLCyqVCm5ublzfn8/ncXx8PKl44yG7RkyCdrvdtyUVi0XZMW2ZSiF/6beni+JGh6nu1FOpFO7v76Gqqu35s7MznxP1J5B9yLB0Oh3HpXZq99WnuoX8JZFIQNM023NPT08+p3EnFEIAYHNz07a8VCr5nMSd0AiJRqNQFKWnvFwuS0jjTGiEAMDi4mJPWb9nTPwmVEKCAAshRqiENJvNnjK7fkUmoRFiWZbtDSy7fkUmoRHy8PBgW761teVzEndCMVP//PzE8vKy7YiKZ+oSOD09tZWRzWZJyQBAe/ld0zShqqrQNG3kBzXdluEpbgciK+T7o2z4s1FB07SBl8wNwxCqqjrKoPpIG9ltQBcXFz/+brVa2N/fB/B7qJrJZBCPx5FOp79eU6vV8P7+jru7O9ctQaqq4uDgYCK5x0Z2jbDj39bh5UH9OXWSnfrs7Cyy2aznn5vL5XB1dYWZmRnPP9szZNcINwzD8ORnNRRFEbquy76cgQjEPKTRaOD29rZv3/AvuVwOGxsbgdkkBwRwYmhZFt7e3vD6+goAX4ISiQTi8Tjm5uawsLBAekO1G4ETMu2Q7NTDDAshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshBgshxv+gRYm2j5tU9QAAAABJRU5ErkJggg==";
  String img4 =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAADG0lEQVR4nO3dsWoiURTG8ZNlK3t7Zco8QCqfwcCAjUlINSFYKogiQYJNIBYRQoiFDBhLCx8gVSp7Uwant0jltDdFEDY7mpXVyfnu5ftBmptiDvkzV2ZuwANjjBGC8Ut7APqKQcAwCBgGAcMgYBgEDIOAYRAwDAKGQcAwCBgGAcMgYBgEDIOAYRAwDAKGQcAwCBgGAcMgYBgEDIOAYRAwDALmt/YAaZlOpzIYDL6sNRoNyeVyOgNtyckgcRxLuVyWt7e3xO8eHx8VJtqek1vW9fX12hg2cC7I8/Oz3NzcaI/x35wKslgs5OLiQnuMnTgVpNVqWbtVrTgTZDKZSL/f1x5jZ04EiaJIqtWq9hh74USQWq1m/Va1Yn2Qp6cnGY/HiXXP8xSm2Z3VD4ZRFMnp6WlivV6vy/v7u5V3jbV3SBzHUqvVEuue51n9eWJtkDAM125V7XZbstmswkT7YWWQ19dXqVQqifUgCOTk5ERhov2xLkgcx3J5eZlY9zxPOp2OwkT7ZV2Qu7s7eXl5Sax3u12rt6oVq4JMp1NpNpuJ9Xq9LsViUWGi/bMmyOqM42+e58nV1ZXCROmwJsimM47RaCSZTEZhonRYEWQymaw947i/v5ejoyOFidIDH2SxWKx90CsUCnJ+fv7zA6UMPsimM46HhwentqoV6CCbzjiGw6EcHh4qTJQ+2CBRFMnx8XFi3fd965/GvwMbZNOLw9vbW4Vpfg5kkE1nHN1uF/4f3XYFF2TTGUcQBM48jX8HKkgcx3J2dpZYd+XF4TaggoRhuPbF4Wg0cuLF4VYMiNlsZkRE5cf3fbNcLrX/BMYYY2DukF6vp3bt8Xgs8/lc7fp/gglCnxgEDEyQUqmkdm3f9yWfz6td/wvtD7G0BEGQ+PAOgkB7rH+CuUPoE4OAYRAwDAKGQcAwCBgGAcMgYBgEDIOAYRAwzgZZ97JS8wXmtg6M4RdLInH2DrEVg4BhEDAMAoZBwDAIGAYBwyBgGAQMg4BhEDAMAoZBwDAIGAYBwyBgGAQMg4BhEDAMAoZBwDAIGAYBwyBgGAQMg4D5APzXZrolrWJwAAAAAElFTkSuQmCC";
  String img1_s =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFFElEQVR4nO2csWvqXBTAz/v4Jku7lHZW4ubgIAgW0kVLRwuBQoeuGfoPWDrpEijUMSAda6fSlkydEhdBdHCopHSSuLXEoVBI1/sN37O8viRW683NQc8PhHqiOUd/vYm5N/f+YowxINDwT9wFEF8hIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcggIcj4N67E4/EYXNf9fJ5KpSCRSMRVDhqECen1etDv96HVasHd3V3o6xRFgVwuB/l8HgqFwspJ+hX1raSWZUGtVoN2u/2j92uaBkdHR5BMJvkWFsJoNIJGowFvb2+fsWw2CycnJ0LyA4sIx3GYoigMALg8bNuOqlTGGGOe5zFd10PziyKSTI7jMEmSuMkAAOZ5XhSlMsYYM03z23pFwT3TrDIkSWKqqjJVVZksy1Nfq2ka7zIZY4zZtj1zKxYF10ye502Voaoq63a7of/tjuMwwzB8XxLvw5XneUzTtLlaqCi4Zgr7kJIkzf2l2rbNKpUK03WdZ4nMMIwfHU5FwS2T67qhMhzH4ZVmYVRVnXoYDTuEiYLblXqn0wmM1+t1YT9ZZ+Hw8DAwrmkaDAYDODg4EFvQX3C7MHx4ePDFJEmCvb09Xim4UCgUvjxXFAVqtRpkMpmYKvoKtxZiWZYvViwW0V1pJxIJMAwDZFkGwzDg9vYWjQwAji1kOBz6YrIs89o9V8rlMpTL5bjLCCTS3t739/cod7+URCrk8fExyt0vJdyEBB2eLi8v4ePjg1eKlYCbkJ2dncD4/f09rxQrATchYT9vq9UqjEYjXmmWHm5CisUiSJLkiw+HQyiVSiRlRrie1Ov1emB8OBxCKpWC6+trnumWEq5CyuUyqKoauv34+Bh2d3cDLyKJ3/DuHPM8b6YxBlmWmWmavNMvTLPZXI7e3j+ZVQr87mFtNpvMdd0oSpmbpRTC2M8GgXRdj3SodhaWVsiEbrf77RDt3y3GMIyoywpl6YVMME1zLjGqqsbSWlZGyATTNFmlUplJiqIows8tKydkguu6TNf1b8e3FUUR2lJWVsiE725Qmxy+RLHyQibYtj21tYi6ZolbCJrpCJlMBgaDASiKEri9VqsJrige0AgB+H+8++LiIrCTst1uQ6/Xi6EqsaASAgCQTCahWq0Gbmu1WmKLiQF0QgAA9vf3A+P9fl9wJeJBKWRrayvwXDJtos+ygFIIAMDm5mbcJcQCWiGrCglBBlohz8/PvljYNcoygVLIaDQKnCSay+ViqEYsKIU0Go3AeD6fF1yJeLgKGY/HC+/Dsiw4Pz/3xSVJ8k0lWEa4CUmn07C9vQ2np6c/FmNZFpRKpcBt1WoV3dSGSODRQ2mapq93VNM01u12Z3q/bdtTp5rJsixsTCTu3l4u80Nubm58sbOzs8+/VVWFbDYLGxsbX15j2zZ0Op2pqzxIkgRXV1er0ToAFlcfNtmTxyOOCaNxt5CFzyFra2tQqVQW3Y0PWZbBNE1UE0aFwMvsd+eBWR+TG+fiuj8r7hYSydIauq7PvfCMoijMMIzYb5QLWhokqqU9goh8eaanpyd4fX2Fl5cX37b19XVIp9O0eNkfRC6EmA+UXSerDAlBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBBglBxn8jRQQfxQylzQAAAABJRU5ErkJggg==";
  String img2_s =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAAFi0lEQVR4nO2dMU/rOhSAfZ/eVFQWFkYqd78DUiWQMrX8guyM5idkRQxBSDBm6RpWUH5AyoKEChJCSOlGFTaqsIHS9bzl5r5C49A2x8nh3vNJGTDUPu0X28mxU34AAAiGDP/UHQDzERZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCDBZCjH/ravj19VUkSfL751arJRqNRl3hkKEyIbe3t+L+/l5cXV2Ji4sL7d/Zti22t7dFp9MROzs7lUjKTo6Hh4cP5c1mU7Tb7WpPFjBMGIZgWRYIIVY6XNeFOI7R40qSBHzfXzg2x3EgDEP0OD5jTEgcx2Db9soiPh9RFKHElSQJuK67chxKKSMnSIYRIXEcg5QSTYYQAtI0LR1XEAQocUkpjfUWdCGLypBSglIKlFJfDhuu65aKKU1TcBwH9QQRQsBwOET61P4HVUiapoUylFIwHA61Z3scxxAEwdxQV3a4WmToVEqB7/u/D9d1v3ydlBKSJCkV22dQhejGZinl0h9qFEXgOA54nlc6Ls/zcuOyLAvCMCwcDpMkKexdSqnS8c2CJiRJEq0Mk5PgInzuuVJK8H1/qTrCMNRKwbrgAEAUEgRBbrBBEGA1UQrf90EIAbZtr3yC6EaAsnPcLGhClFK5vQPj6ogKaZpqRwEs0HJZg8Fgrqzb7f5R6ZBGoyFc150rH4/HYjQaobSBJmQ8Hs+VWZaFVT0ZOp1ObvnT0xNK/UazvW9vbyarr4XNzc3c8vf3d5T6jQp5fHw0WX0ttFoto/WjCckbnvr9vphOp1hNkMD0nIgmZHd3N7f88vISqwkSmD7B0ITs7e3llh8eHorn52esZmonjuPc8maziVI/mpButyuklHPl4/FY9Hq9P0bKZDLJLW+32yj1o07qZ2dnueXj8Vi0Wi1xfn6O2Vwt3N3d5ZajTfZot5i/yLtjnz2yhN53JS+bbds2Wv3oQtI0XSjd/R3F6BKMmPk6IyuGi0oRM5lX7HUFE+jeE2bsxtbU0zRdeu3a8zyyyUhd78DM9AIYFJIxHA6X2nUipSSTsp9F9x5IrxgWsex2IKUUmd6SraWY7h0AFQrJCMNw4Q0Htm3XPrfEcaztySZiq1xIRpIk4HnelztUbNuuraekaart1aaG1dqEZKRpqt2EMDt81YGuJ5uMp3YhGVEUFfaWqu9ZdHsETA1VGWSEABTfv1iWVVkcw+FQe2KY2Bw3CykhAMU7H01/GF+1v+zWoVUgJwSg2svMWZIk0cow3XYGSSG6TXeYSbzPFA2XVV7pkRQCoM8bmYCKDADEfVnYbGxsVNLOdDoV+/v7uU91SSnF6elppXvLyAqpiqOjI62MMAzF1tZWpfH81UKOj4/FycnJXHldMoQQhgZlBPJSFpiTetGjE3Xu1icpRJfQw7r0LFqnqfvRCZJCdDkkjPRJkQwKS8qoQjByPLqVOYxHG6jLAEAUkt3hOo6zspiip5TKpi2+gwwAJCF5H6TrugvnnqIoKtw+ZFlWqd5RJJqSDACAHwDl/0vbwcGB6Pf72t8rpcTPnz/F+vr6h/IoisTNzY24vr7WvrbsJehgMBC9Xm+l1y5LGIai2+2Wq6SsUV3eCePAuAQ1FVvegbFwVfrGcG1tTTiOU7aaOSzLqu/mrE5KK/3FV/PAoke2cQ4roVc2nmUOjB5i5Ks1PM9b+otnbNuGIAjQM6tlvmhm2QPjAgFlUi9iNBqJyWQiXl5e5n5Xy/dREce4EGY5/upsL0VYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDFYCDH+A1UpHzAni0g0AAAAAElFTkSuQmCC";
  String img3_s =
      "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";
}
