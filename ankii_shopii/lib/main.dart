import 'dart:io';

import 'package:ankiishopii/blocs/account_bloc/service.dart';
import 'package:ankiishopii/blocs/login_bloc/service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/routes.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/navigator/navigator_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHOPii',
      theme: ThemeData(
        fontFamily: GoogleFonts.andada().fontFamily,
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
    );
  }
}

class LoadingScreen extends StatefulWidget {
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (b) => NavigatorPage()));
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
