import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isLoadingDialogShowing = false;

  static showLoadingDialog(BuildContext context, {String text}) async {
    _isLoadingDialogShowing = true;
    await showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[CircularProgressIndicator(), Text(text ?? '')],
          ),
        ));
  }

  static hideLoadingDialog(BuildContext context, {String text}) async {
    if (_isLoadingDialogShowing) {
      Navigator.pop(context);
    }
  }
}
