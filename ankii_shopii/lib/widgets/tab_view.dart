import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomTabViewItem> children;

  CustomTabView({this.backgroundColor = BACKGROUND_COLOR, this.itemColor = PRIMARY_COLOR, this.children});

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
            margin: EdgeInsets.only(top: 25),
            padding: EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        widget.children[_currentIndex].label,
                        style: TextStyle(color: widget.children[_currentIndex].color ?? widget.itemColor, fontSize: 20),
                      )),
                ),
                Expanded(
                  child: PageView(
                    controller: pageViewController,
                    onPageChanged: (index) {
                      onSwipeChangePage(index);
                    },
                    children: widget.children.map((child) => Expanded(child: child.child)).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(30),
//                color: widget.backgroundColor,
//                boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 5), blurRadius: 5)]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.children.map((child) {
                var color = child.color ?? widget.itemColor;
                var icon = child.icon;
                var label = child.label;
                var index = widget.children.indexOf(child);

                return GestureDetector(
                  onTap: () {
                    onTapChangePage(index);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: _currentIndex == index ? 10 : 0),
                    decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      icon,
                      size: 20,
                      color: _currentIndex == index ? color : color.withOpacity(0.3),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
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
