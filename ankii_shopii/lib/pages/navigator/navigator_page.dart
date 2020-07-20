import 'dart:async';

import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/pages/account/account_page.dart';
import 'package:ankiishopii/pages/categories/categories_page.dart';
import 'package:ankiishopii/pages/favorite/favorite_page.dart';
import 'package:ankiishopii/pages/home/home_page.dart';
import 'package:ankiishopii/pages/notification/notification_page.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../themes/constant.dart';
import '../../themes/constant.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class NavigatorPage extends StatefulWidget {
  static const String routeName = "/";

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  var _scrollStreamController = StreamController();
  var scrollController = ScrollController();
  var _pageController = PageController(keepPage: false);
  bool _isHideTopBottomBar = false;

  int _currentIndex = 0;
  List<Widget> pages = [];

  void _openCloseSearchInput() {
    //print('open search page');
    Navigator.pushNamed(context, SearchPage.routeName);
  }

  void _changePage(int index) {
    if (index < 0 || index >= pages.length) {
      index = 0;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  void hideTopBottomBar(bool isScrollUp) {
    if (_isHideTopBottomBar != isScrollUp) {
      print(isScrollUp);
      setState(() {
        _isHideTopBottomBar = isScrollUp;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollStreamController.stream.listen((isScrollUp) {
      hideTopBottomBar(isScrollUp);
    });
    scrollController.addListener(() {
      bool upDirection = scrollController.position.userScrollDirection == ScrollDirection.reverse;
      _scrollStreamController.sink.add(upDirection);
    });

    pages = [
      HomePage(scrollController),
      CategoriesPage(scrollController),
      FavoritePage(scrollController),
      NotificationPage(scrollController),
     AccountPage(scrollController)
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // scrollController.dispose();
    _scrollStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: BACKGROUND_COLOR,
       // appBar: buildAppBar(),
        drawer: buildDrawer(),
        body: PageView(
          onPageChanged: (index) {
            _changePage(index);
            setState(() {
              _isHideTopBottomBar = false;
            });
          },
          controller: _pageController,
          children: pages,
        ),
        bottomNavigationBar: buildBottomNavigator());
  }

  Widget buildBottomNavigator() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _isHideTopBottomBar ? 0 : 60,
      child: CustomBottomNavigationBar(
        barShadow: true,
        currentIndex: _currentIndex,
        onChange: (index) {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        children: [
          CustomBottomNavigationItem(icon: Icons.store, label: 'Home', color: PRIMARY_COLOR),
          CustomBottomNavigationItem(icon: Icons.receipt, label: 'Categories', color: PRIMARY_COLOR),
          CustomBottomNavigationItem(icon: Icons.favorite, label: 'Favorite', color: PRIMARY_COLOR),
          CustomBottomNavigationItem(icon: Icons.notifications, label: 'Notification', color: PRIMARY_COLOR),
          CustomBottomNavigationItem(icon: Icons.account_circle, label: 'Account', color: PRIMARY_COLOR),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return CustomAppBar(
      backgroundColor: BACKGROUND_COLOR,
     // padding: EdgeInsets.only(left: 5, right: 5),
      appBar: AppBar(
        centerTitle: true,
        elevation:0,
        backgroundColor: BACKGROUND_COLOR,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Text(
            _currentIndex == 1
                ? 'Categories'
                : _currentIndex == 2
                    ? 'Favorite'
                    : _currentIndex == 3 ? 'Notification' : _currentIndex == 4 ? 'Account' : 'SHOPii',
            style: DEFAULT_TEXT_STYLE.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.search,
                color: PRIMARY_COLOR,
              ),
            ),
            onTap: () {
              _openCloseSearchInput();
            },
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: Icon(
                Icons.shopping_cart,
                color: PRIMARY_COLOR,
              ),
            ),
            onTap: () {},
          )
        ],
        leading: GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.menu,
              color: PRIMARY_COLOR,
            ),
          ),
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context) + 10),
        color: BACKGROUND_COLOR,
        child: Column(
          children: <Widget>[Text('Drawer')],
        ),
      ),
    );
  }
}
