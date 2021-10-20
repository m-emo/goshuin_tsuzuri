import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/common/style.dart';
import 'package:goshuintsuzuri/common/header.dart';
import 'package:goshuintsuzuri/components/goshuin_list_jinja/goshuin_list_jinja.dart';
import 'package:goshuintsuzuri/components/goshuin_list_jinja/goshuin_list_jinja2.dart';
import 'package:goshuintsuzuri/components/goshuin_list_list/goshuin_list_list.dart';
import 'package:goshuintsuzuri/components/goshuin_list_photo/goshuin_list_photo.dart';

import '../../app_store.dart';

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class GoshuinList extends StatelessWidget {
  GoshuinList({Key key, @required this.store}) : super(key: key);

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final List<TabInfo> _tabs = [
      TabInfo("一覧", GoshuinListList(store: store)),
      TabInfo("神社・寺院", GoshuinListJija(store: store)),
      TabInfo("写真", GoshuinListPhoto(store: store)),
    ];

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        // key: _scaffoldKey,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Color(0xFFE75331),
              labelColor: StylesColor.subTextColor,
              unselectedLabelColor: StylesColor.subTextColor.withOpacity(0.3),
              labelStyle: TextStyle(fontSize: 14.0),
              tabs: _tabs.map((TabInfo tab) {
                return Container(height: 30.0,child:Tab(text: tab.label),);
              }).toList(),
            ),
          ),
        ),
        body: TabBarView(
            // key: PageStorageKey(_tabs.map((tab) => tab.index).toList()),
            children: _tabs.map((tab) => tab.widget).toList()
        ),
      ),
    );
  }
}