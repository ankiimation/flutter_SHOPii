import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isLoadingDialogShowing = false;

  static showLoadingDialog(BuildContext context,
      {String text, bool hideOnBackButton = false}) async {
    _isLoadingDialogShowing = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        child: WillPopScope(
          onWillPop: () async {
            return hideOnBackButton;
          },
          child: AlertDialog(
            elevation: 0,
            backgroundColor: text == null
                ? Colors.transparent
                : BACKGROUND_COLOR.withOpacity(0.9),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomDotLoading(
                  primaryColor: FOREGROUND_COLOR,
                ),
                SizedBox(
                  height: text == null ? 0 : 10,
                ),
                text == null
                    ? Container()
                    : Text(
                        text ?? 'Processing...',
                        style: TEXT_STYLE_PRIMARY.copyWith(
                            fontWeight: FontWeight.bold),
                      )
              ],
            ),
          ),
        ));
  }

  static hideLoadingDialog(BuildContext context, {String text}) async {
    if (_isLoadingDialogShowing) {
      Navigator.pop(context);
      _isLoadingDialogShowing = false;
    }
  }

  static showMessage(BuildContext context, {String text}) async {
    return await showDialog(
        context: context,
        child: AlertDialog(
          backgroundColor: BACKGROUND_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Text(
            text ?? '',
            style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            )
          ],
        ));
  }

  static showConfirm(BuildContext context,
      {String text, @required Function onYes, @required Function onNo}) async {
    return await showDialog(
        context: context,
        child: AlertDialog(
          backgroundColor: BACKGROUND_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: text == null
              ? null
              : Text(
                  text,
                  style:
                      TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
                ),
          actions: <Widget>[
            FlatButton(
              color: FOREGROUND_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.pop(context);
                onNo();
              },
              child: Text('No'),
            ),
            FlatButton(
              color: FOREGROUND_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.pop(context);
                onYes();
              },
              child: Text('Yes'),
            )
          ],
        ));
  }
}
