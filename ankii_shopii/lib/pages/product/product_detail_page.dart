import 'dart:async';

import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  ProductDetailPage(this.product);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  StreamController _scrollStreamController = StreamController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      bool isScrollUp = _scrollController.position.userScrollDirection == ScrollDirection.reverse;
      _scrollStreamController.sink.add(isScrollUp);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FOREGROUND_COLOR,
      body: Stack(
        children: <Widget>[
          buildAvatar(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: buildInfo(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildFloatingBottomBar(),
          ),
          buildNavigator()
        ],
      ),
    );
  }

  Widget buildNavigator() {
    return Container(
        margin: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                color: PRIMARY_COLOR,
                onPressed: () {
                  print('test');
                  Navigator.pop(context);
                }),
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 20,
                  color: PRIMARY_COLOR,
                ),
                onPressed: () {}),
          ],
        ));
  }

  Widget buildAvatar() {
    return Container(
      padding: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context), bottom: 30),
      alignment: Alignment.topCenter,
      child: CircleAvatar(
        radius: 70,
        backgroundImage: CachedNetworkImageProvider(widget.product.image),
      ),
    );
  }

  Widget buildInfo() {
    return Container(
      constraints: BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.7),
      margin: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context) + 180),
      padding: EdgeInsets.only(bottom: 50, left: 10, right: 10),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, -2), blurRadius: 2)],
          color: BACKGROUND_COLOR,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: <Widget>[
          Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  widget.product.name,
                  style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Description'),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(widget.product.description != null && widget.product.description.length > 0
                          ? widget.product.description
                          : 'No Description'),
                    )
                  ],
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Images'),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: widget.product.productImage != null && widget.product.productImage.length > 0
                          ? _buildCarousel(widget.product.productImage)
                          : Text('No Image'),
                    )
                  ],
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text('Reviews'),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(widget.product.description != null && widget.product.description.length > 0
                          ? widget.product.description
                          : 'No Review'),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<ProductImageModel> images) {
    return CarouselSlider(
        items: images
            .map((image) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(image: CachedNetworkImageProvider(image.image))),
                ))
            .toList(),
        options: CarouselOptions(enlargeCenterPage: true, autoPlay: true, autoPlayInterval: Duration(seconds: 2)));
  }

  Widget buildFloatingBottomBar() {
    return StreamBuilder(
        stream: _scrollStreamController.stream,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            child: snapshot.hasData && snapshot.data == true
                ? null
                : Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround, //
                      children: <Widget>[
                        Container(
                            width: 50,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: BACKGROUND_COLOR,
                                boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(-2, -2), blurRadius: 3)],
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                            child: Icon(
                              Icons.favorite_border,
                              color: PRIMARY_COLOR,
                            )),
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: FOREGROUND_COLOR,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black26, offset: Offset(-2, -2), blurRadius: 3)
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
                                child: Text(
                                  'Get it',
                                  textAlign: TextAlign.center,
                                  style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20),
                                )))
                      ],
                    ),
                  ),
          );
        });
  }
}
