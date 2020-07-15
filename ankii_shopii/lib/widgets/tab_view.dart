import 'dart:async';

import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomTabView extends StatefulWidget {
  final bool barShadow;
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomTabViewItem> children;

  CustomTabView(
      {this.barShadow = false, this.backgroundColor = BACKGROUND_COLOR, this.itemColor = PRIMARY_COLOR, this.children});

  @override
  _CustomTabViewState createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  int _currentIndex = 0;
  var pageViewController = PageController(
    keepPage: true,
  );

  void onSwipeChangePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTapChangePage(int index) {
    pageViewController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20)),
          // margin: EdgeInsets.only(top: 35),
          // padding: EdgeInsets.only(top: 25),
          child: PageView(
            controller: pageViewController,
            onPageChanged: (index) {
              onSwipeChangePage(index);
            },
            children: widget.children.map((child) => child.child).toList(),
          ),
        ),
        Container(
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(30),
//                color: widget.backgroundColor,
//                boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 5), blurRadius: 5)]),
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow:
                  widget.barShadow ? [BoxShadow(color: Colors.grey.withOpacity(0.3), offset: Offset(0, 6), blurRadius: 3)] : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.children.map((child) {
              var color = child.color ?? widget.itemColor;
              var icon = child.icon;
              var label = child.label;
              var index = widget.children.indexOf(child);

              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      onTapChangePage(index);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      margin: EdgeInsets.only(top: _currentIndex == index ? 10 : 0),
                      child: Icon(
                        icon,
                        size: 20,
                        color: _currentIndex == index ? color : color.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Text(
                    _currentIndex == index ? label : '',
                    style: TextStyle(color: color, fontSize: 14),
                  )
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class CustomTabViewItem {
  final IconData icon;
  final String label;
  final Color color;
  final Widget child;

  CustomTabViewItem({@required this.icon, @required this.label, this.color, @required this.child});
}
