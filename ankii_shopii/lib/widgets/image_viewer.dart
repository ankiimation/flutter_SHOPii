import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImagesViewer extends StatelessWidget {
  final List<Image> images;

  ImagesViewer(this.images);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context)),
        child: Stack(
          children: <Widget>[
            Center(
                child: Container(
                    height: ScreenHelper.getSafeHeight(context),
                    child: CarouselSlider(items: images, options: CarouselOptions(

                      enlargeCenterPage: true,
                    )))),
            Container(
              margin: EdgeInsets.all(20),
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: FOREGROUND_COLOR,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
