import 'package:ankiishopii/blocs/login_bloc/bloc.dart';
import 'package:ankiishopii/blocs/login_bloc/service.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: FOREGROUND_COLOR,
      body: Stack(
        children: <Widget>[
          Container(
//              padding: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context) + 30),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          'https://i.pinimg.com/originals/2e/0a/ab/2e0aaba94a7e19d5792021915604bc23.jpg'))),
              child: Container(
                padding: EdgeInsets.only(
                    top: ScreenHelper.getPaddingTop(context) + 30),
                height: double.maxFinite,
                width: double.maxFinite,
                color: PRIMARY_COLOR.withOpacity(0.5),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.cartArrowDown,
                      size: 50,
                      color: BACKGROUND_COLOR,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'SHOPii!',
                      style: TextStyle(color: BACKGROUND_COLOR, fontSize: 45),
                    )
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: buildLoginPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginPanel() {
    return Container(
      margin: EdgeInsets.only(
          top: ScreenHelper.getPaddingTop(context) + 150, left: 10, right: 10),
      decoration: BoxDecoration(
          //boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, -2), blurRadius: 2)],
          color: BACKGROUND_COLOR,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      constraints:
          BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Container(
//              margin: EdgeInsets.only(top: 10, left: 20),
//              child: Text(
//                'Login',
//                style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 25),
//              )),
          Container(
            margin: EdgeInsets.only(top: 50, left: 20, right: 20),
            decoration: BoxDecoration(
                color: BACKGROUND_COLOR,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FOREGROUND_COLOR, width: 2)),
            child: TextFormField(
              controller: usernameTextController,
              decoration: InputDecoration(
                labelText: 'Username',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
                color: BACKGROUND_COLOR,
                border: Border.all(color: FOREGROUND_COLOR, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              controller: passwordTextController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          buildLoginButton(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              'Or login with',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: PRIMARY_TEXT_COLOR.withOpacity(0.5), fontSize: 12),
            ),
          ),
          buildSocialLogin(),
          SizedBox(
            height: 30,
          ),
          buildRegisterButton()
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () async {
          LoadingDialog.showLoadingDialog(context);
          var account = await LoginService()
              .logIn(usernameTextController.text, passwordTextController.text);
          LoadingDialog.hideLoadingDialog(context);
          if (account != null) {
            refreshCart(context);
            refreshLogin(context);
            Navigator.pop(context);
          } else {
            await showDialog(
                context: context,
                child: AlertDialog(
                  content: Text('Login FAILED'),
                ));
          }
        },
        color: FOREGROUND_COLOR,
        padding: EdgeInsets.all(15),
        child: Container(
            alignment: Alignment.center,
            child: Text(
              'Login',
              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            color: FOREGROUND_COLOR,
            //  shape: CircleBorder(),
            icon: Icon(
              FontAwesomeIcons.facebook,
              size: 30,
              color: Colors.blue,
            ),
            onPressed: () {}),
        IconButton(
            color: FOREGROUND_COLOR,
            //  shape: CircleBorder(),
            icon: Icon(
              FontAwesomeIcons.google,
              size: 30,
              color: PRICE_COLOR_PRIMARY,
            ),
            onPressed: () {}),
      ],
    );
  }

  Widget buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Dont have an account?',style: TEXT_STYLE_PRIMARY),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: FOREGROUND_COLOR, width: 2),
                borderRadius: BorderRadius.circular(10)),
            onPressed: () {},
            color: BACKGROUND_COLOR,
            padding: EdgeInsets.all(10),
            child:
                Container(alignment: Alignment.center, child: Text('Register',style: TEXT_STYLE_PRIMARY)),
          ),
        ),
      ],
    );
  }
}
