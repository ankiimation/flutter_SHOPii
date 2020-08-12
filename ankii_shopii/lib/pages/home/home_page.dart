import 'dart:async';
import 'dart:math';

import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/cart/cart_page.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/custom_sliver_appbar.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../themes/constant.dart';
import '../../themes/constant.dart';
import '../../themes/constant.dart';
import '../../themes/constant.dart';
import '../../themes/constant.dart';

const double _leftRightMargin = 20;
const double _topBottomMargin = 10;

class HomePage extends StatefulWidget {
  static const String routeName = "homePage";
  final ScrollController scrollController;

  HomePage(this.scrollController);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<CartWidgetState> _cartIconKey = GlobalKey();
  ProductBloc productForYouBloc = ProductBloc(ProductLoading())
    ..add(GetProductsForYou());

  double topBarHeight = kToolbarHeight + 150;
  bool _isScrollToAppBar = false;

  _refresh() {
    productForYouBloc.add(GetProductsForYou());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var reachedHeight = topBarHeight + ScreenHelper.getPaddingTop(context);
      widget.scrollController.addListener(() {
        var offset = widget.scrollController.offset;

//              - ScreenHelper.getPaddingTop(context) - kToolbarHeight;
        if (offset >= reachedHeight && _isScrollToAppBar == false) {
          if (this.mounted) {
            setState(() {
              _isScrollToAppBar = true;
              _cartIconKey = GlobalKey();
            });
          }
        } else if (offset < reachedHeight && _isScrollToAppBar == true) {
          if (this.mounted) {
            setState(() {
              _isScrollToAppBar = false;
              _cartIconKey = GlobalKey();
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    productForYouBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(children: <Widget>[
              buildBanner(),
              SizedBox(
                height: 20,
              ),
              buildForYou(),
              buildShops()
            ]),
          ),
          buildSearchBar()
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: _isScrollToAppBar
          ? Container(
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: ScreenHelper.getPaddingTop(context)),
              child: Card(
                color: BACKGROUND_COLOR,
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                        ),
                      )),
                      CustomOnTapWidget(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (b) => CartPage()));
                          },
                          child: CartWidget(
                              _isScrollToAppBar ? _cartIconKey : null))
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget buildBanner() {
    return Container(
      height: topBarHeight + 30,
      child: Stack(
        children: <Widget>[
          Container(
            height: topBarHeight,
            decoration: BoxDecoration(
                color: FOREGROUND_COLOR,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        "https://www.arcgis.com/sharing/rest/content/items/8f762395cd204552bb958ecb1b54339d/resources/1588745514029.jpeg?w=2932"),
                    fit: BoxFit.cover)),
          ),
          Positioned.fill(
            top: topBarHeight - 30,
            child: Card(
              child: Container(
                  width: ScreenHelper.getWidth(context),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 5, right: 5, bottom: 5),
                              hintText: 'Search',
                              border: InputBorder.none),
                        ),
                      )),
                      CustomOnTapWidget(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (b) => CartPage()));
                        },
                        child: CartWidget(
                          _isScrollToAppBar ? null : _cartIconKey,
                          size: 20,
                        ),
                      )
                    ],
                  )),
              color: BACKGROUND_COLOR,
            ),
          )
        ],
      ),
    );
  }

  Widget buildForYou() {
    return BlocBuilder(
        cubit: productForYouBloc,
        builder: (context, state) {
          if (state is ListProductsLoaded) {
            return Container(
              margin: EdgeInsets.only(
                  top: _topBottomMargin, bottom: _topBottomMargin),
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      'For you',
                      style: TEXT_STYLE_PRIMARY.copyWith(
                        color: PRIMARY_COLOR,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: state.products
                              .map<Widget>((product) => Container(
                                    margin:
                                        EdgeInsets.only(left: 10, bottom: 20),
                                    child: CustomProductGridItem(
                                      elevation: 5,
                                      cartIconKey: _cartIconKey,
                                      backgroundColor: FOREGROUND_COLOR,
                                      product: product,
                                      onTap: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (b) =>
                                                    ProductDetailPage(
                                                        product)));
                                        _refresh();
                                      },
                                      onFavourite: () async {
                                        setState(() {
                                          product.isFavoriteByCurrentUser =
                                              !product.isFavoriteByCurrentUser;
                                        });
                                        await ProductService()
                                            .doFavorite(product);
                                        //productForYouBloc.add(GetProductsForYou());
                                      },
                                      onAddToCart: () {
                                        addToCart(context,
                                            productID: product.id);
                                      },
                                    ),
                                  ))
                              .toList()
                                ..add(SizedBox(
                                  width: 10,
                                ))))
                ],
              ),
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
        });
  }

  Widget buildShops() {
    return Container(
      height: 500,
      color: FOREGROUND_COLOR,
    );
  }
}
