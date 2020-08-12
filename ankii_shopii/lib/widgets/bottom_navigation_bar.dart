import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

import 'base/custom_ontap_widget.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final bool barShadow;
  final Color backgroundColor;
  final Color itemColor;
  final Color selectedItemColor;
  final Color overlayColor;
  final List<CustomBottomNavigationItem> children;
  final Function(int) onChange;
  final int currentIndex;

  CustomBottomNavigationBar(
      {this.backgroundColor = BACKGROUND_COLOR,
      this.barShadow = false,
      this.itemColor = PRIMARY_COLOR,
      this.currentIndex = 0,
      @required this.children,
      this.selectedItemColor = FORE_TEXT_COLOR,
      this.overlayColor = PRIMARY_COLOR,
      this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changeIndex(int index) {
    if (widget.onChange != null) {
      widget.onChange(index);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          boxShadow: widget.barShadow
              ? [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, -2),
                      blurRadius: 2)
                ]
              : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.children.map((item) {
          var color = item.color ?? widget.itemColor;
          var icon = item.icon;
          var label = item.label;
          int index = widget.children.indexOf(item);
          return CustomOnTapWidget(
            onTap: () {
              _changeIndex(index);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: widget.currentIndex == index
                  ? MediaQuery.of(context).size.width / widget.children.length +
                      20
                  : 50,
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: widget.currentIndex == index
                      ? widget.overlayColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 20,
                    color: widget.currentIndex == index
                        ? widget.selectedItemColor
                        : color.withOpacity(0.5),
                  ),
                  Expanded(
                      flex: 2,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: widget.currentIndex == index
                            ? Text(
                                label ?? '',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: widget.selectedItemColor),
                              )
                            : Container(),
                      ))
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  CustomBottomNavigationItem(
      {@required this.icon, @required this.label, this.color});
}
