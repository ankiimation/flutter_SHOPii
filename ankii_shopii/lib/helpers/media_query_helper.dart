import 'package:flutter/material.dart';

class ScreenHelper{
  static double getHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double getSafeHeight(BuildContext context){
    return MediaQuery.of(context).size.height - getPaddingTop(context) - 60 - 10;
  }
  static double getWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
  static double getPaddingTop(BuildContext context){
    return MediaQuery.of(context).padding.top;
  }
}