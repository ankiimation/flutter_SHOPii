import 'dart:async';
import 'dart:math';

import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../themes/constant.dart';
import '../../themes/constant.dart';
import '../../themes/constant.dart';
import '../../themes/constant.dart';
import '../../themes/constant.dart';

const double _leftRightMargin = 20;
const double _topBottomMargin = 10;

class HomePage extends StatefulWidget {
  static const String routeName = "/homePage";
  final ScrollController scrollController;

  HomePage(this.scrollController);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              InPageAppBar(
                title: 'Home',
              ),
              buildForYou(),
              // buildSearchBar(),
              buildCategories()
            ],
          ),
        ),
      ),
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
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 25, bottom: 10),
            child: Text(
              'For you',
              style: DEFAULT_TEXT_STYLE.copyWith(
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
                        (url) => Container(
                          width: 150,
                          margin: EdgeInsets.only(left: urls.indexOf(url) == 0 ? 20 : 0, right: 20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
//                              boxShadow: [
//                                BoxShadow(
//                                    color: Colors.black26,
//                                    offset: Offset(5, 5),
//                                    blurRadius: 5)
//                              ],
                              color: FOREGROUND_COLOR,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
//
                                      image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                                      color: PRIMARY_COLOR,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Bún thịt lướng',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: DEFAULT_TEXT_STYLE.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '50.000đ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: DEFAULT_TEXT_STYLE.copyWith(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_shopping_cart,
                                      size: 20,
                                    ),
                                    Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()))
        ],
      ),
    );
  }

  Widget buildCategories() {
    return Container(
        height: 800,
        margin: EdgeInsets.only(
          top: _topBottomMargin,
          bottom: _topBottomMargin,
//            left: _leftRightMargin,
//            right: _leftRightMargin
        ),
        child: CustomTabView(
          backgroundColor: BACKGROUND_COLOR,
          children: [
            CustomTabViewItem(
                icon: Icons.fastfood,
                label: 'Noodle',
                color: PRIMARY_COLOR,
                child: Column(
                  children: <Widget>[
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          'View More >>',
                          style: DEFAULT_TEXT_STYLE.copyWith(color: PRIMARY_COLOR),
                        ))
                  ],
                )),
            CustomTabViewItem(
                icon: Icons.free_breakfast,
                label: 'Snack',
                color: PRIMARY_COLOR,
                child: Column(
                  children: <Widget>[
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          'View More >>',
                          style: DEFAULT_TEXT_STYLE.copyWith(color: PRIMARY_COLOR),
                        ))
                  ],
                )),
            CustomTabViewItem(
                icon: Icons.local_drink,
                label: 'Drink',
                color: PRIMARY_COLOR,
                child: Column(
                  children: <Widget>[
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    CustomProductListItem(
                      image: NetworkImage(
                          'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                      title: 'Mì xào hải sản',
                      price: '50000đ',
                      priceTextColor: Colors.red,
                      backgroundColor: FOREGROUND_COLOR,
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          'View More >>',
                          style: DEFAULT_TEXT_STYLE.copyWith(color: PRIMARY_COLOR),
                        ))
                  ],
                )),
          ],
        ));
  }
}
