import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final EdgeInsets padding;
  final Color primaryColor;
  final Color backgroundColor;
  final AppBar appBar;

  CustomAppBar(
      {Key key, this.padding, this.backgroundColor = BACKGROUND_COLOR, this.primaryColor = PRIMARY_COLOR, this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 3)]),
      child: Container(
        padding: padding,
        child: appBar ??
            AppBar(
              elevation: 0,
              backgroundColor: backgroundColor,
            ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
