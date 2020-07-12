import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/pages/categories/categories_page.dart';
import 'package:ankiishopii/pages/home/home_page.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/constant.dart';
import '../../themes/constant.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  var _pageController = PageController(keepPage: true);
  bool _isHideTopBottomBar = false;

  int _currentIndex = 0;
  List<Widget> pages = [];

  void _openCloseSearchInput() {
    //print('open search page');
    Navigator.push(context, MaterialPageRoute(builder: (b) => SearchPage()));
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

    pages = [
      HomePage(hideTopBottomBar),
      CategoriesPage(),
      Text('Notification'),
      Text('account')
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: BACKGROUND_COLOR,
        appBar: buildAppBar(),
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
        currentIndex: _currentIndex,
        onChange: (index) {
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        children: [
          CustomBottomNavigationItem(
              icon: Icons.store, label: 'Home', color: PRIMARY_COLOR),
          CustomBottomNavigationItem(
              icon: Icons.receipt, label: 'Receipt', color: PRIMARY_COLOR),
          CustomBottomNavigationItem(
              icon: Icons.notifications,
              label: 'Notification',
              color: PRIMARY_COLOR),
          CustomBottomNavigationItem(
              icon: Icons.account_circle,
              label: 'Account',
              color: PRIMARY_COLOR),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return CustomAppBar(
      backgroundColor: BACKGROUND_COLOR,
      padding: EdgeInsets.only(left: 5, right: 5),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          child: Text(
            'SHOPii',
            style: TextStyle(
                color: PRIMARY_COLOR,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold),
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
