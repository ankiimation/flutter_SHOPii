import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String error;

  CustomErrorWidget({this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.error,
            color: PRIMARY_COLOR,
          ),
          Text(error.toString())
        ],
      ),
    );
  }
}
