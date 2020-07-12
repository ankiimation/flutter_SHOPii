import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/constant.dart';

class CustomListItem extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String price;
  final Color priceTextColor;
  final Color addToCartButtonColor;
  final String description;
  final Function onTap;
  final Function onAddToCart;
  final Color backgroundColor;

  CustomListItem(
      {this.backgroundColor = BACKGROUND_COLOR,
      this.image,
      this.title,
      this.price,
      this.description,
      this.onTap,
      this.onAddToCart,
      this.addToCartButtonColor = PRIMARY_COLOR,
      this.priceTextColor = Colors.red});

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
            padding: EdgeInsets.only(
                left: height - 50, top: 10, bottom: 10, right: 10),
            child: Container(
              padding:
                  EdgeInsets.only(left: 60, top: 10, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      price ?? '0đ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          letterSpacing: 1.2,
                          color: priceTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: PRIMARY_COLOR,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        InkWell(
                          onTap: onAddToCart,
                          child: Container(
                              child: Icon(
                            Icons.add_shopping_cart,
                            color: addToCartButtonColor,
                            size: 20,
                          )),
                        )
                      ],
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
