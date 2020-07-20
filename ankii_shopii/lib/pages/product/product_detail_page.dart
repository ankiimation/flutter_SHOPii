import 'dart:async';

import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  ProductDetailPage(this.product);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductBloc bloc = ProductBloc(ProductLoading());
  StreamController _scrollStreamController = StreamController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(GetProductById(widget.product.id));
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
      body: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is ProductLoaded) {
              return Stack(
                children: <Widget>[
                  buildAvatar(state.product),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: buildInfo(state.product),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: buildFloatingBottomBar(state.product),
                  ),
                  buildNavigator()
                ],
              );
            } else if (state is ProductLoadingError) {
              return Center(
                child: CustomErrorWidget(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget buildRelated(List<ProductModel> products) {
    products.removeWhere((product) => product.id == widget.product.id);
    return Container(
//      margin: EdgeInsets.only(top: _topBottomMargin, bottom: _topBottomMargin),
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: products
              .map(
                (product) => GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (b) => ProductDetailPage(product)));
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(left: products.indexOf(product) == 0 ? 20 : 0, right: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
//                              boxShadow: [
//                                BoxShadow(
//                                    color: Colors.black26,
//                                    offset: Offset(5, 5),
//                                    blurRadius: 5)
//                              ],
                        color: FOREGROUND_COLOR,
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
//
                                image: DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover),
                                color: PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: DEFAULT_TEXT_STYLE.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  product.price.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: DEFAULT_TEXT_STYLE.copyWith(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList()),
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

  Widget buildAvatar(ProductModel productModel) {
    return Container(
        alignment: Alignment.topCenter,
        child: Container(
          height: ScreenHelper.getHeight(context) * 0.35,
          width: ScreenHelper.getWidth(context),
          //  decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(productModel.image))),
          child: Image.network(
            productModel.image,
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget buildInfo(ProductModel productModel) {
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
                  productModel.name,
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
                      child: Text(productModel.description != null && productModel.description.length > 0
                          ? productModel.description
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
                      child: productModel.productImage != null && productModel.productImage.length > 0
                          ? _buildCarousel(productModel.productImage)
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
                      child: Text(productModel.description != null && productModel.description.length > 0
                          ? productModel.description
                          : 'No Review'),
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
                  title: Text('Related'),
                  children: <Widget>[Container(child: buildRelated(productModel.category.product))],
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

  Widget buildFloatingBottomBar(ProductModel productModel) {
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
                        GestureDetector(
                          onTap: () {
                            bloc.add(DoFavorite(productModel, isDoFromListProducts: false));
                            bloc.add(GetProductById(widget.product.id));
                          },
                          child: Container(
                              width: 50,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: BACKGROUND_COLOR,
                                  boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(-2, -2), blurRadius: 3)],
                                  borderRadius:
                                      BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                              child: Icon(
                                productModel.isFavoriteByCurrentUser ? Icons.favorite : Icons.favorite_border,
                                color: PRIMARY_COLOR,
                              )),
                        ),
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
