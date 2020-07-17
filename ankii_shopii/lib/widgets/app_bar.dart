import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
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
        color: backgroundColor,
//          boxShadow: [
//        BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 3)]
      ),
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

class InPageAppBar extends StatelessWidget {
  final String title;
  final Widget leading;
  final bool isLoggedIn;

  const InPageAppBar({this.title, this.leading, this.isLoggedIn = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 30, right: 20, top: ScreenHelper.getPaddingTop(context) + 20),
      child: Row(
        children: <Widget>[
          Container(margin: EdgeInsets.only(right: this.leading != null ? 10 : 0), child: this.leading),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title ?? '',
                  style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 30),
                ),
                isLoggedIn
                    ? Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (b) => SearchPage()));
                            },
                            child: Icon(
                              Icons.search,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.shopping_cart,
                            color: PRIMARY_COLOR,
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
