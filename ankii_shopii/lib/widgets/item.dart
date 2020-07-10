import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String price;
  final String description;
  final Function onTap;
  final Color backgroundColor;

  CustomListItem(
      {this.backgroundColor = BACKGROUND_COLOR, this.image, this.title, this.price, this.description, this.onTap});

  @override
  Widget build(BuildContext context) {
    double height = 100;
    // TODO: implement build
    return Container(
      height: height,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: height - 50, top: 10, bottom: 10, right: 10),
            child: Container(
              padding: EdgeInsets.only(left: 60, top: 10, right: 20, bottom: 10),
              decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title ?? 'Title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: PRIMARY_COLOR, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      price ?? '0đ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(letterSpacing: 1.2, color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      description ?? 'Description',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: PRIMARY_COLOR, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: height,
            height: height,
            child: CircleAvatar(
              backgroundColor: backgroundColor,
              child: Container(
                width: height - 15,
                height: height - 15,
                child: CircleAvatar(
                  backgroundColor: Colors.yellow,
                  backgroundImage: image,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
