import 'dart:async';
import 'dart:math';

import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _leftRightMargin = 20;
const double _topBottomMargin = 10;

class HomePage extends StatefulWidget {
  final Function callBackToParent;

  HomePage(this.callBackToParent);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scrollStreamController = StreamController();
  var scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollStreamController.stream.listen((isScrollUp) {
      widget.callBackToParent(isScrollUp);
    });
    scrollController.addListener(() {
      bool upDirection = scrollController.position.userScrollDirection == ScrollDirection.reverse;
      _scrollStreamController.sink.add(upDirection);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              buildForYou(),
              // buildSearchBar(),
              buildCategories()
            ],
          )),
    );
  }

  Widget buildSearchBar() {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      pinned: true,
      floating: true,
      title: Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration:
                    InputDecoration(contentPadding: EdgeInsets.all(15), hintText: 'Search', border: InputBorder.none),
              ),
            ),
            IconButton(
                icon: Icon(
                  MyIcons.search_1,
                  color: PRIMARY_COLOR,
                  size: 20,
                ),
                onPressed: () {})
          ],
        ),
      ),
    );
  }

  Widget buildForYou() {
    List<String> urls = [
      'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg',
      'https://shipdoandemff.com/wp-content/uploads/2017/06/M%C3%AC-x%C3%A0o-gi%C3%B2n-shipdoandemFF.jpg',
      'https://cdn.tgdd.vn/Files/2020/03/08/1240753/3-cach-lam-mon-com-chien-thom-ngon-bo-duong-cho-bua-com-gia-dinh-2.png',
      'https://thucthan.com/media/2019/07/bun-rieu-cua/bun-rieu-cua.png'
    ];
    return Container(
      margin: EdgeInsets.only(top: _topBottomMargin, bottom: _topBottomMargin),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: _leftRightMargin, bottom: 10),
            child: Text(
              'For you' + Random().nextInt(10).toString(),
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 20,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: urls
                      .map(
                        (e) => Container(
                          margin: EdgeInsets.only(left: urls.indexOf(e) == 0 ? 20 : 0, right: 20, bottom: 20),
                          width: 120,
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(5, 5), blurRadius: 5)],
                              image: DecorationImage(image: NetworkImage(e), fit: BoxFit.cover),
                              color: PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      )
                      .toList()))
        ],
      ),
    );
  }

  Widget buildCategories() {
    return Container(
        margin: EdgeInsets.only(
            top: _topBottomMargin, bottom: _topBottomMargin, left: _leftRightMargin, right: _leftRightMargin),
        child: CustomTabView(
          backgroundColor: WHITE_COLOR,
          children: [
            CustomTabViewItem(
                icon: MyIcons.food,
                label: 'Noodle',
                color: Colors.red,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      CustomListItem(
                        image: NetworkImage(
                            'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                        title: 'Mì xào hải sản',
                        price: '50000đ',
                      ),
                      CustomListItem(),
                      CustomListItem(),
                      CustomListItem(),
                      CustomListItem(),
                      FlatButton(
                          onPressed: () {},
                          child: Text(
                            'View More >>',
                            style: TextStyle(color: PRIMARY_COLOR),
                          ))
                    ],
                  ),
                )),
            CustomTabViewItem(
                icon: MyIcons.food,
                label: 'Snack',
                color: Colors.green,
                child: Container(
                  color: Colors.green,
                )),
            CustomTabViewItem(
                icon: Icons.local_drink,
                label: 'Juice',
                color: Colors.blue,
                child: Container(
                  color: Colors.blue,
                )),
          ],
        ));
  }
}
