//import 'package:ankiishopii/pages/home/home_page.dart';
//import 'package:ankiishopii/pages/navigator/navigator_page.dart';
//import 'package:ankiishopii/pages/search/search_page.dart';
//import 'package:flutter/material.dart';
//
//class Routes {
//  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//    switch (settings.name) {
//      case NavigatorPage.routeName:
//        return MaterialPageRoute(builder: (_) => NavigatorPage(), settings: settings);
//      case HomePage.routeName:
//        return MaterialPageRoute(builder: (_) => HomePage(), settings: settings);
//      case SearchPage.routeName:
//        return MaterialPageRoute(builder: (_) => SearchPage(), settings: settings);
//      default:
//        return MaterialPageRoute(builder: (_) => NavigatorPage(), settings: settings);
//    }
//  }
//}
//
//class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
//  static String currentRoute = '/';
//
//  void onRouteChange(PageRoute route) {
//    currentRoute = route.settings.name;
//    print(currentRoute);
//  }
//
//  @override
//  void didPop(Route route, Route previousRoute) {
//    super.didPop(route, previousRoute);
//    // TODO: implement didPop
//    onRouteChange(previousRoute);
//  }
//
//  @override
//  void didPush(Route route, Route previousRoute) {
//    super.didPush(route, previousRoute);
//    // TODO: implement didPush
//    onRouteChange(route);
//  }
//
//  @override
//  void didReplace({Route newRoute, Route oldRoute}) {
//    super.didReplace();
//    // TODO: implement didReplace
//    onRouteChange(newRoute);
//  }
//}
