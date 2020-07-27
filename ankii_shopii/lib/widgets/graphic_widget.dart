import 'dart:async';

import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _defaultSpeed = Duration(milliseconds: 500);

class CustomDotLoading extends StatefulWidget {
  final Duration speed;
  final Color primaryColor;
  final Color secondaryColor;
  final double size;

  CustomDotLoading(
      {this.speed = _defaultSpeed,
      this.primaryColor = PRIMARY_COLOR,
      this.secondaryColor = BACKGROUND_COLOR,
      this.size = 10});

  @override
  _CustomDotLoadingState createState() => _CustomDotLoadingState();
}

class _CustomDotLoadingState extends State<CustomDotLoading> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  StreamController animationValueStreamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.repeat(period: widget.speed, reverse: true);
    _animationController.addListener(() {
      animationValueStreamController.sink.add(_animationController.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    animationValueStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: animationValueStreamController.stream,
        builder: (context, snapshot) {
          double value = snapshot.data ?? 0;
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: widget.size,
                  backgroundColor: value < 0.3 ? widget.primaryColor : widget.secondaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: widget.size,
                  backgroundColor: value > 0.3 && value < 0.7 ? widget.primaryColor : widget.secondaryColor,
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: widget.size,
                  backgroundColor: value > 0.7 ? widget.primaryColor : widget.secondaryColor,
                ),
              ],
            ),
          );
        });
  }
}

class CustomEmptyWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;

  CustomEmptyWidget({this.backgroundColor = FOREGROUND_COLOR, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(50)),
      child: title,
    );
  }
}
