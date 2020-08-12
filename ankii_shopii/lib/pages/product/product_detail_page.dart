import 'dart:async';

import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/blocs/shop_bloc/bloc.dart';
import 'package:ankiishopii/blocs/shop_bloc/event.dart';
import 'package:ankiishopii/blocs/shop_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/account/login_page.dart';
import 'package:ankiishopii/pages/cart/cart_page.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
import 'package:ankiishopii/pages/shop_account/shop_account_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/add_to_cart_effect.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/animated_button.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/image_viewer.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  ShopAccountBloc shopAccountBloc = ShopAccountBloc();

  //CartBloc cartBloc;
  StreamController _scrollStreamController = BehaviorSubject();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cartBloc = BlocProvider.of<CartBloc>(context);
    bloc.add(GetProductById(widget.product.id));
    shopAccountBloc.add(GetShopAccount(widget.product.shopUsername));
    _scrollController.addListener(() {
      bool isScrollUp = _scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      _scrollStreamController.sink.add(isScrollUp);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    shopAccountBloc.close();
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
                  Align(
                      alignment: Alignment.topCenter,
                      child: buildAppBar(state.product))
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
                (product) => Container(
                  margin: EdgeInsets.only(left: 10, bottom: 15),
                  child: CustomProductGridItem(
                    width: 150,
                    backgroundColor: FOREGROUND_COLOR,
                    showQuickAction: false,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (b) => ProductDetailPage(product))),
                    elevation: 5,
                    product: product,
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
                      height: kToolbarHeight,
                      margin: EdgeInsets.only(
                          top: ScreenHelper.getPaddingTop(context) + 5,
                          left: 5,
                          right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CustomAnimatedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: BACKGROUND_COLOR,
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: PRIMARY_TEXT_COLOR,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              CustomAnimatedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                                color: BACKGROUND_COLOR,
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) => SearchPage())),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: PRIMARY_TEXT_COLOR,
                                  ),
                                ),
                              ),
                              currentLogin != null
                                  ? CustomAnimatedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 0,
                                      color: BACKGROUND_COLOR,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (b) => CartPage()));
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: CartWidget(
                                            cartIconKey,
                                            size: 20,
                                            color: PRIMARY_TEXT_COLOR,
                                          )),
                                    )
                                  : Container(),
                            ],
                          )
                        ],
                      ),
                    ));
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
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget buildInfo(ProductModel productModel) {
    return Container(
      constraints:
          BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.65),
      margin: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context) + 180),
      padding: EdgeInsets.only(bottom: 100, left: 10, right: 10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, -2), blurRadius: 2)
          ],
          color: BACKGROUND_COLOR,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.store,
                  size: 20,
                  color: PRIMARY_TEXT_COLOR,
                ),
                SizedBox(
                  width: 10,
                ),
//                BlocBuilder(
//                    cubit: shopAccountBloc,
//                    builder: (_, state) {
//                      if (state is ShopAccountLoaded) {
//                        return CustomOnTapWidget(
//                          onTap: () {
//                            Navigator.push(context,
//                                MaterialPageRoute(builder: (b) => ShopAccountDetailPage(state.shopAccountModel)));
//                          },
//                          child: Text(
//                            state.shopAccountModel.name,
//                            style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
//                          ),
//                        );
//                      } else {
//                        return CustomDotLoading(
//                          primaryColor: FOREGROUND_COLOR,
//                          secondaryColor: BACKGROUND_COLOR,
//                        );
//                      }
//                    }),
                CustomOnTapWidget(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (b) => ShopAccountDetailPage(
                                productModel.shopUsername)));
                  },
                  child: Text(
                    productModel.shopUsername,
                    style: TEXT_STYLE_PRIMARY.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: double.maxFinite,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  productModel.name,
                  style: TEXT_STYLE_PRIMARY.copyWith(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  numberToMoneyString(productModel.price),
                  style: TEXT_STYLE_PRIMARY.copyWith(
                      color: PRICE_COLOR_PRIMARY,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Description', style: TEXT_STYLE_PRIMARY),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                          productModel.description != null &&
                                  productModel.description.length > 0
                              ? productModel.description
                              : 'No Description',
                          style: TEXT_STYLE_PRIMARY),
                    )
                  ],
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Images', style: TEXT_STYLE_PRIMARY),
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10),
                        child: _buildCarousel(productModel.productImage))
                  ],
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text('Reviews', style: TEXT_STYLE_PRIMARY),
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                          productModel.description != null &&
                                  productModel.description.length > 0
                              ? productModel.description
                              : 'No Review',
                          style: TEXT_STYLE_PRIMARY),
                    )
                  ],
                ),
              )),
          Container(
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text('Related', style: TEXT_STYLE_PRIMARY),
                  children: <Widget>[
                    Container(
                        child: buildRelated(productModel.category.product))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<ProductImageModel> images) {
    if (widget.product.image != null) {
      images.add(ProductImageModel(image: widget.product.image));
    }
    if (images != null && images.length > 0) {
      return CustomOnTapWidget(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (b) => ImagesViewer(images
                      .map((image) => Image.network(image.image))
                      .toList())));
        },
        child: CarouselSlider(
            items: images
                .map((image) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(image.image),
                                fit: BoxFit.cover)),
                      ),
                    ))
                .toList(),
            options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2))),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text('No Image'),
      );
    }
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
                    height: kBottomNavigationBarHeight + 10,
                    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: BACKGROUND_COLOR,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround, //
                      children: <Widget>[
                        CustomAnimatedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: BACKGROUND_COLOR,
                          onTap: () {
                            if (currentLogin == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (b) => LoginPage()));
                              return;
                            }
                            bloc.add(DoFavorite(productModel,
                                isDoFromListProducts: false));
                            bloc.add(GetProductById(widget.product.id));
                          },
                          child: Container(
                              width: kBottomNavigationBarHeight - 5,
                              height: kBottomNavigationBarHeight,
                              alignment: Alignment.center,
                              //margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                productModel.isFavoriteByCurrentUser
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: FOREGROUND_COLOR,
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: CustomAnimatedButton(
                          color: FOREGROUND_COLOR,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          elevation: 1,
                          onTap: () {
                            if (currentLogin == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (b) => LoginPage()));
                              return;
                            }
                            showMyModalBottomSheet(productModel);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Get it',
                                textAlign: TextAlign.center,
                                style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                    fontSize: 20),
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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
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
                            backgroundImage: CachedNetworkImageProvider(
                                widget.product.image),
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
                                style: TEXT_STYLE_PRIMARY.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                numberToMoneyString(widget.product.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TEXT_STYLE_PRIMARY.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: PRICE_COLOR_PRIMARY),
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
                        Text('Quantity', style: TEXT_STYLE_PRIMARY),
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
                                      quantityController.text =
                                          quantity.toString();
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: FOREGROUND_COLOR,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.remove,
                                    color: FORE_TEXT_COLOR,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 50,
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: PRIMARY_COLOR.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    // enabled: false,
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.center,
                                    style: TEXT_STYLE_PRIMARY.copyWith(
                                        fontWeight: FontWeight.bold),
                                    cursorColor: FOREGROUND_COLOR,
                                    decoration: InputDecoration.collapsed()
                                        .copyWith(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 5)),
                                  ),
                                ),
                              ),
                              CustomOnTapWidget(
                                onTap: () {
                                  // print(quantity);

                                  setState(() {
                                    quantity++;
                                    quantityController.text =
                                        quantity.toString();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: FOREGROUND_COLOR,
                                      borderRadius: BorderRadius.circular(50)),
                                  child:
                                      Icon(Icons.add, color: FORE_TEXT_COLOR),
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
                        Text('Size', style: TEXT_STYLE_PRIMARY),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: FOREGROUND_COLOR,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                'S',
                                style: TEXT_STYLE_ON_FOREGROUND,
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: FOREGROUND_COLOR,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('M', style: TEXT_STYLE_ON_FOREGROUND),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: FOREGROUND_COLOR,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('L', style: TEXT_STYLE_ON_FOREGROUND),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  color: FOREGROUND_COLOR,
                                  borderRadius: BorderRadius.circular(30)),
                              child:
                                  Text('XL', style: TEXT_STYLE_ON_FOREGROUND),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      updateCartIconPosition(cartIconKey: cartIconKey);
                      await showAddToCartAnimation(context,
                          overlayWidget: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: BACKGROUND_COLOR,
                                borderRadius: BorderRadius.circular(100)),
                            child: Text(
                              quantityController.text,
                              style: TEXT_STYLE_PRIMARY.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          start: CustomPosition(
                              ScreenHelper.getWidth(context) * 0.7,
                              ScreenHelper.getHeight(context) * 0.9),
                          end: CustomPosition(
                              cartIconPositionDx, cartIconPositionDy));
                      await addToCart(context,
                          productID: productModel.id,
                          count: int.parse(quantityController.text));

                      Navigator.pop(context);
                    },
                    color: FOREGROUND_COLOR,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Add To Cart',
                          textAlign: TextAlign.center,
                          style:
                              TEXT_STYLE_ON_FOREGROUND.copyWith(fontSize: 16),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
