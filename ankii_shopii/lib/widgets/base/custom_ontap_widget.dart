import 'package:flutter/material.dart';

class CustomOnTapWidget extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final GlobalKey key;

  CustomOnTapWidget({this.child, this.onTap, this.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
//      highlightColor: Colors.transparent,
//      splashColor: Colors.transparent,
//      focusColor: Colors.transparent,
//      hoverColor: Colors.transparent,

      onTap: onTap,
      child: child,
    );
  }
}
