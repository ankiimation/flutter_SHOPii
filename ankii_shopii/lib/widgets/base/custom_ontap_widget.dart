import 'package:flutter/material.dart';

class CustomOnTapWidget extends StatelessWidget {
  final Widget child;
  final Function onTap;

  CustomOnTapWidget({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      highlightColor: Colors.transparent,
//      splashColor: Colors.transparent,
//      focusColor: Colors.transparent,
//      hoverColor: Colors.transparent,

      onTap: onTap,
      child: child,
    );
  }
}
