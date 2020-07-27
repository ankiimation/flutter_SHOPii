import 'dart:async';

import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/account/login_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/add_to_cart_effect.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailPage extends StatefulWidget {
  static const String routeName = 'productDetailPage';
  final ProductModel product;

  ProductDetailPage(this.product);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<CartWidgetState> cartIconKey = GlobalKey();
  ProductBloc bloc = ProductBloc(ProductLoading());

  //CartBloc cartBloc;
  StreamController _scrollStreamController = BehaviorSubject();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cartBloc = BlocProvider.of<CartBloc>(context);
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
      key: _scaffoldKey,
      backgroundColor: FOREGROUND_COLOR,
      body: BlocBuilder(
          cubit: bloc,
          builder: (context, state) {
            if (state is ProductLoaded) {
              return Stack(
                children: <Widget>[
                  Container(child: buildAvatar(state.product)),
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
                  buildAppBar(state.product)
                ],
              );
            } else if (state is ProductLoadingError) {
              return Center(
                child: CustomErrorWidget(),
              );
            } else {
              return Center(
                child: CustomDotLoading(),
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
                (product) => CustomOnTapWidget(
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
                                  numberToMoneyString(product.price),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: DEFAULT_TEXT_STYLE.copyWith(
                                    color: PRICE_COLOR,
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

  Widget buildAppBar(ProductModel productModel) {
    return StreamBuilder(
        stream: _scrollStreamController.stream,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: snapshot.hasData && snapshot.data == true
                ? null
                : Container(
                    decoration: BoxDecoration(
                        color: BACKGROUND_COLOR.withOpacity(0.8),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                    child: InPageAppBar(
                      showBackground: true,
                      cartIconKey: cartIconKey,
                      title: productModel.name,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
          );
        });
  }

  Widget buildAvatar(ProductModel productModel) {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(bottom: ScreenHelper.getHeight(context) * 0.6),
        child: Container(
          height: ScreenHelper.getHeight(context),
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
      constraints: BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.65),
      margin: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context) + 180),
      padding: EdgeInsets.only(bottom: 100, left: 10, right: 10),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, -2), blurRadius: 2)],
          color: BACKGROUND_COLOR,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: <Widget>[
          Container(
              width: double.maxFinite,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  numberToMoneyString(productModel.price),
                  style: DEFAULT_TEXT_STYLE.copyWith(color: PRICE_COLOR, fontSize: 30, fontWeight: FontWeight.bold),
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
    double radius = 25;
    return StreamBuilder(
        stream: _scrollStreamController.stream,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            child: snapshot.hasData && snapshot.data == true
                ? null
                : Container(
                    height: 50,
                    // margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, -3))],
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround, //
                      children: <Widget>[
                        CustomOnTapWidget(
                          onTap: () {
                            if (currentLogin == null) {
                              Navigator.push(context, MaterialPageRoute(builder: (b) => LoginPage()));
                              return;
                            }
                            bloc.add(DoFavorite(productModel, isDoFromListProducts: false));
                            bloc.add(GetProductById(widget.product.id));
                          },
                          child: Container(
                              width: ScreenHelper.getWidth(context) * 0.25,
                              // alignment: Alignment.center,
                              //margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: BACKGROUND_COLOR,
                                  //  boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(-2, -2), blurRadius: 3)],
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(radius))),
                              child: Icon(
                                productModel.isFavoriteByCurrentUser ? Icons.favorite : Icons.favorite_border,
                                color: PRIMARY_COLOR,
                              )),
                        ),
                        Expanded(
                            child: CustomOnTapWidget(
                          onTap: () {
                            if (currentLogin == null) {
                              Navigator.push(context, MaterialPageRoute(builder: (b) => LoginPage()));
                              return;
                            }
                            showMyModalBottomSheet(productModel);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: FOREGROUND_COLOR,
                                  //  boxShadow: [
//                                      BoxShadow(color: Colors.black26, offset: Offset(-2, -2), blurRadius: 3)
//                                    ],
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(radius))),
                              child: Text(
                                'Get it',
                                textAlign: TextAlign.center,
                                style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20),
                              )),
                        ))
                      ],
                    ),
                  ),
          );
        });
  }

  showMyModalBottomSheet(ProductModel productModel) {
    var quantityController = TextEditingController();
    quantityController.text = 1.toString();
    int quantity = int.parse(quantityController.text);
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            margin: EdgeInsets.symmetric(horizontal: 20),
            //   height: ScreenHelper.getHeight(context) * 0.4,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            backgroundColor: FOREGROUND_COLOR,
                            radius: 45,
                            backgroundImage: CachedNetworkImageProvider(widget.product.image),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                numberToMoneyString(widget.product.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: DEFAULT_TEXT_STYLE.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: PRICE_COLOR),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Quantity'),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              CustomOnTapWidget(
                                onTap: () {
                                  // print(quantity);
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                      quantityController.text = quantity.toString();
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(3),
                                  decoration:
                                      BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(50)),
                                  child: Icon(Icons.remove),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 50,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: PRIMARY_COLOR.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    enabled: false,
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
                                    cursorColor: FOREGROUND_COLOR,
                                    decoration: InputDecoration.collapsed()
                                        .copyWith(isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                                  ),
                                ),
                              ),
                              CustomOnTapWidget(
                                onTap: () {
                                  // print(quantity);

                                  setState(() {
                                    quantity++;
                                    quantityController.text = quantity.toString();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(3),
                                  decoration:
                                      BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(50)),
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Size'),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                                  BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(30)),
                              child: Text('S'),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                                  BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(30)),
                              child: Text('M'),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                                  BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(30)),
                              child: Text('L'),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                                  BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(30)),
                              child: Text('XL'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomOnTapWidget(
                    onTap: () async {
                      updateCartIconPosition(cartIconKey: cartIconKey);
                      addToCart(context, productID: productModel.id, count: int.parse(quantityController.text));
                      await showAddToCartAnimation(context,
                          overlayWidget: CircleAvatar(
                            backgroundColor: BACKGROUND_COLOR,
                            radius: 10,
                            child: Text(
                              quantityController.text,
                              style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          start: CustomPosition(
                              ScreenHelper.getWidth(context) * 0.7, ScreenHelper.getHeight(context) * 0.9),
                          end: CustomPosition(cartIconPositionDx, cartIconPositionDy));

                      Navigator.pop(context);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: FOREGROUND_COLOR,
                          //  boxShadow: [
//                                      BoxShadow(color: Colors.black26, offset: Offset(-2, -2), blurRadius: 3)
//                                    ],
                        ),
                        child: Text(
                          'Add To Cart',
                          textAlign: TextAlign.center,
                          style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
