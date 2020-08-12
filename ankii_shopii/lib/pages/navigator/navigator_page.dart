import 'dart:async';

import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/main.dart';
import 'package:ankiishopii/pages/account/account_page.dart';
import 'package:ankiishopii/pages/categories/categories_page.dart';
import 'package:ankiishopii/pages/favorite/favorite_page.dart';
import 'package:ankiishopii/pages/home/home_page.dart';
import 'package:ankiishopii/pages/notification/notification_page.dart';
import 'package:ankiishopii/pages/ordering/ordering_page.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
import 'package:ankiishopii/routes.dart';
import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

import '../../themes/constant.dart';
import '../../themes/constant.dart';

StreamController navigationPageStreamController = BehaviorSubject();
List<Widget> pages = [];
var _pageController = PageController(keepPage: false);

void changePageViewPage(int index) {
  _pageController.animateToPage(index,
      duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
}

class NavigatorPage extends StatefulWidget {
  static const String routeName = "navigatorPage";
  final int initPageIndex;

  const NavigatorPage({Key key, this.initPageIndex = 0}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  var _scrollStreamController = StreamController();
  var scrollController = ScrollController();

  //int _currentIndex = 0;

  void _openCloseSearchInput() {
    //print('open search page');
    Navigator.pushNamed(context, SearchPage.routeName);
  }

  void changePage(int index) {
    if (index < 0 || index >= pages.length) {
      index = 0;
    }

    navigationPageStreamController.sink.add(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      bool upDirection = scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      _scrollStreamController.sink.add(upDirection);
    });

    pages = [
      HomePage(scrollController),
      CategoriesPage(scrollController),
      FavoritePage(scrollController),
      OrderingPage(scrollController),
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
    return WillPopScope(
        onWillPop: () {
          changePageViewPage(0);
        },
        child: StreamBuilder(
          stream: navigationPageStreamController.stream,
          builder: (context, snapshot) {
            var index = 0;
            if (snapshot.hasData) index = snapshot.data;
            return Scaffold(
              backgroundColor: BACKGROUND_COLOR,
              // appBar: buildAppBar(),
              drawer: buildDrawer(),
              body: StreamBuilder(
                  stream: _scrollStreamController.stream,
                  builder: (context, scrollSnapshot) {
                    bool isHideBar =
                        scrollSnapshot.hasData && scrollSnapshot.data == true;
                    return Stack(
                      children: [
                        PageView(
                          onPageChanged: (index) {
                            changePage(index);
                            setState(() {
                              _scrollStreamController.sink.add(false);
                            });
                          },
                          controller: _pageController,
                          children: pages,
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: buildBottomNavigator(index, isHideBar))
                      ],
                    );
                  }),
            );
          },
        ));
  }

  Widget buildBottomNavigator(int currentIndex, bool _isHideTopBottomBar) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: _isHideTopBottomBar
          ? null
          : Container(
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Card(
                elevation: 5,
                color: BACKGROUND_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 60,
                  child: CustomBottomNavigationBar(
                    selectedItemColor: FORE_TEXT_COLOR,
                    overlayColor: PRIMARY_COLOR,
                    currentIndex: currentIndex,
                    backgroundColor: Colors.transparent,
                    onChange: (index) {
                      changePageViewPage(index);
                    },
                    children: [
                      CustomBottomNavigationItem(
                          icon: Icons.store, label: 'Home'),
                      CustomBottomNavigationItem(
                          icon: Icons.reorder, label: 'Categories'),
                      CustomBottomNavigationItem(
                          icon: Icons.favorite, label: 'Favorite'),
                      CustomBottomNavigationItem(
                          icon: Icons.receipt, label: 'Orders'),
                      CustomBottomNavigationItem(
                          icon: Icons.account_circle, label: 'Account'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

//  Widget buildAppBar() {
//    return CustomAppBar(
//      backgroundColor: BACKGROUND_COLOR,
//      // padding: EdgeInsets.only(left: 5, right: 5),
//      appBar: AppBar(
//        centerTitle: true,
//        elevation: 0,
//        backgroundColor: BACKGROUND_COLOR,
//        title: AnimatedSwitcher(
//          duration: Duration(milliseconds: 200),
//          child: Text(
//            _currentIndex == 1
//                ? 'Categories'
//                : _currentIndex == 2
//                    ? 'Favorite'
//                    : _currentIndex == 3 ? 'Notification' : _currentIndex == 4 ? 'Account' : 'SHOPii',
//            style: DEFAULT_TEXT_STYLE.copyWith(letterSpacing: 1.5, fontWeight: FontWeight.bold),
//          ),
//        ),
//        actions: <Widget>[
//          CustomOnTapWidget(
//            child: Container(
//              margin: EdgeInsets.only(right: 20),
//              child: Icon(
//                Icons.search,
//                color: PRIMARY_COLOR,
//              ),
//            ),
//            onTap: () {
//              _openCloseSearchInput();
//            },
//          ),
//          CustomOnTapWidget(
//            child: Container(
//              margin: EdgeInsets.only(right: 5),
//              child: Icon(
//                Icons.shopping_cart,
//                color: PRIMARY_COLOR,
//              ),
//            ),
//            onTap: () {},
//          )
//        ],
//        leading: CustomOnTapWidget(
//          child: Container(
//            margin: EdgeInsets.only(right: 5),
//            child: Icon(
//              Icons.menu,
//              color: PRIMARY_COLOR,
//            ),
//          ),
//          onTap: () {},
//        ),
//      ),
//    );
//  }

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
