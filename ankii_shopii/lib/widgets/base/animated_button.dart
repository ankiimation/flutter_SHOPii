import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

class CustomAnimatedButton extends StatefulWidget {
  final double elevation;
  final Widget child;
  final Function onTap;
  final Color color;
  final ShapeBorder shape;

  CustomAnimatedButton(
      {this.elevation = 1,
      this.child,
      this.onTap,
      this.color = PRIMARY_COLOR,
      this.shape});

  @override
  _CustomAnimatedButtonState createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 20));
    animation = Tween<double>(begin: widget.elevation, end: 0.0)
        .animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (down) {
        animationController.forward();
      },
      onTapUp: (up) {
        animationController.reverse();
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      onTapCancel: () {
        animationController.reverse();
      },
      child: Card(
        color: widget.color,
        elevation: animation.value,
        shape: widget.shape,
        child: widget.child,
      ),
    );
  }
}
