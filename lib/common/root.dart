import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/goshuin_edit/goshuin_edit.dart';
import 'package:goshuintsuzuri/jinja_list/jinja_list.dart';
import 'package:goshuintsuzuri/goshuin_list/goshuin_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RootWidget extends StatefulWidget {
  RootWidget({Key key}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
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
  var _routes = [
    GoshuinList(),
    JinjaList(),
    GoshuinEdit(kbn: "0"),
  ];

  // ==============

  @override
  void initState() {
    super.initState();
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    for (var i = 1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
    }
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
        Navigator.pushNamed(context, '/addGoshuin');
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
