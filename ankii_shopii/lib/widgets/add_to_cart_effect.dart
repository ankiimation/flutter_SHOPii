import 'dart:ui';

import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

class CustomPosition {
  double left;
  double top;

  CustomPosition(this.left, this.top);
}

class AddToCartAnimationOverlay extends StatefulWidget {
  final CustomPosition start;
  final CustomPosition end;

  AddToCartAnimationOverlay({@required this.start, @required this.end});

  @override
  _AddToCartAnimationOverlayState createState() => _AddToCartAnimationOverlayState();
}

class _AddToCartAnimationOverlayState extends State<AddToCartAnimationOverlay> {
  double top;

  double left;

  @override
  void initState() {
    super.initState();
    top = widget.start.top;
    left = widget.start.left;
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        top = widget.end.top;
        left = widget.end.left;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(),
          AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: top,
              left: left,
              width: 30,
              height: 30,
              child: Icon(
                Icons.add_shopping_cart,
                color: FOREGROUND_COLOR,
              )),
        ],
      ),
    );
  }
}

class AddToCartAnimationOverlayTest extends StatefulWidget {
  final Widget overlayWidget;
  final CustomPosition start;
  final CustomPosition end;

  AddToCartAnimationOverlayTest({@required this.start, @required this.end, this.overlayWidget});

  @override
  _AddToCartAnimationOverlayTestState createState() => _AddToCartAnimationOverlayTestState();
}

class _AddToCartAnimationOverlayTestState extends State<AddToCartAnimationOverlayTest>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Path _path;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _path = drawPath();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: CustomPaint(
              painter: PathPainter(_path),
            ),
          ),
          Positioned(
              top: calculate(_animation.value).dy,
              left: calculate(_animation.value).dx,
              child: widget.overlayWidget ??
                  Icon(
                    Icons.plus_one,
                    color: PRIMARY_COLOR,
                  )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath() {
    Path path = Path();
    path.moveTo(widget.start.left, widget.start.top);
    path.quadraticBezierTo(widget.end.left * 0.5, widget.end.top, widget.end.left, widget.end.top);
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
