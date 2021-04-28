import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/common/header.dart';
import 'package:goshuintsuzuri/goshuin_list_list/goshuin_list_list.dart';
import 'package:goshuintsuzuri/jinja_list/jinja_list.dart';
import 'package:goshuintsuzuri/goshuin_list_photo/goshuin_list_photo.dart';
import 'package:goshuintsuzuri/goshuin_list_jinja/goshuin_list_jinja.dart';

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class GoshuinList extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<TabInfo> _tabs = [
    TabInfo("一覧", GoshuinListList()),
    TabInfo("神社・寺院", GoshuinListJija()),
    TabInfo("写真", GoshuinListPhoto()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        key: _scaffoldKey,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: Image(// Imageウィジェット
              image: AssetImage('assets/img/logo.png',),
              height: 18,
            ),
            leading: IconButton(
              icon: Icon(Icons.dehaze),
              color: Styles.subTextColor,
              padding: new EdgeInsets.all(15.0),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Color(0xFFE75331),
              labelColor: Styles.subTextColor,
              unselectedLabelColor: Styles.subTextColor.withOpacity(0.3),
              labelStyle: TextStyle(fontSize: 14.0),
              tabs: _tabs.map((TabInfo tab) {
                return Container(height: 30.0,child:Tab(text: tab.label),);
              }).toList(),
            ),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}