import 'package:flutter/material.dart';

class Header extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          //_scaffoldKey.currentState.openDrawer();
        },
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
