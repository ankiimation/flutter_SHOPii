import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isLoadingDialogShowing = false;

  static showLoadingDialog(BuildContext context, {String text, bool hideOnBackButton = false}) async {
    _isLoadingDialogShowing = true;
    await showDialog(
        context: context,
        barrierDismissible: false,
        child: WillPopScope(
          onWillPop: () async {
            return hideOnBackButton;
          },
          child: AlertDialog(
            backgroundColor: BACKGROUND_COLOR.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomDotLoading(
                  primaryColor: FOREGROUND_COLOR,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  text ?? '',
                  style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }

  static hideLoadingDialog(BuildContext context, {String text}) async {
    if (_isLoadingDialogShowing) {
      Navigator.pop(context);
    }
  }
}
