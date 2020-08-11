import 'package:flutter/material.dart';

class CustomOnTapWidget extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final Function onTapDown;
  final Function onTapUp;
  final GlobalKey key;

  CustomOnTapWidget(
      {this.child, this.onTap, this.key, this.onTapDown, this.onTapUp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: key,
//      highlightColor: Colors.transparent,
//      splashColor: Colors.transparent,
//      focusColor: Colors.transparent,
//      hoverColor: Colors.transparent,

      onTapDown: (a) {
        if (onTapDown != null) onTapDown();
      },
      onTapCancel: () {
        if (onTapUp != null) onTapUp();
      },
      onTapUp: (a) {
        if (onTapUp != null) onTapUp();
        if (onTap != null) onTap();
      },
      child: child,
    );
  }
}
