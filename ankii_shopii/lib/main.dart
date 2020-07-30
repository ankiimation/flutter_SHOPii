import 'dart:io';

import 'package:ankiishopii/blocs/account_bloc/service.dart';
import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/login_bloc/bloc.dart';
import 'package:ankiishopii/blocs/login_bloc/event.dart';
import 'package:ankiishopii/blocs/login_bloc/service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/routes.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/cart_bloc/bloc.dart';
import 'pages/navigator/navigator_page.dart';

BuildContext mainContext;
main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

GlobalKey navigatorPagedKey = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>(create: (context) => CartBloc()..add(LoadCart())),
          BlocProvider<LoginBloc>(create: (context) => LoginBloc()..add(GetCurrentLogin())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SHOPii',
          theme: ThemeData(
            fontFamily: GoogleFonts.aBeeZee().fontFamily,
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.grey,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
//      onGenerateRoute: Routes.onGenerateRoute,
//      navigatorObservers: [MyRouteObserver()],
//      initialRoute: MyRouteObserver.currentRoute,
          home: LoadingScreen(),
        ));
  }
}

class LoadingScreen extends StatefulWidget {
  static const routeName = 'loading';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load().then((value) {
      if (value) {
//        Navigator.of(context).pushReplacementNamed('navigatorPage');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (b) => NavigatorPage(
                      key: navigatorPagedKey,
                    )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }

  Future<bool> load() async {
    await getGlobal();
    if (currentLogin == null) {
      print('Not Logged In!');
    }
    return true;
  }
}
