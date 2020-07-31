import 'dart:async';
import 'dart:math';

import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/app_icon.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/custom_sliver_appbar.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
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
  ProductBloc productForYouBloc = ProductBloc(ProductLoading())..add(GetProductsForYou());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: CustomScrollView(controller: widget.scrollController, slivers: <Widget>[
        buildAppBar(),
//        SliverToBoxAdapter(
//          child: InPageAppBar(
//            showSearchButton: false,
//            cartIconKey: _cartIconKey,
//            title: 'Home',
//          ),
//        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
        SliverToBoxAdapter(child: buildForYou()),
        SliverToBoxAdapter(
          child: buildCategories(),
        )
      ]),
    );
  }

  Widget buildAppBar() {
    return SliverPersistentHeader(
      delegate: CustomSliverAppBar(expandedHeight: 200, cartIconKey: _cartIconKey),
      pinned: true,
    );

//    return SliverAppBar(
//      backgroundColor: BACKGROUND_COLOR,
//      pinned: true,
//      floating: true,
//      expandedHeight: 200,
//      flexibleSpace: LayoutBuilder(builder: (_, constraints) {
//        var top = constraints.biggest.height;
//        return FlexibleSpaceBar(
//            centerTitle: true,
//            title: AnimatedOpacity(
//                duration: Duration(milliseconds: 300),
//                //opacity: top == 80.0 ? 1.0 : 0.0,
//                opacity: 1.0,
//                child: Container(
//                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                  color: BACKGROUND_COLOR.withOpacity(0.8),
//                  child: Row(
//                    children: <Widget>[Text('Home')],
//                  ),
//                )),
//            background: Image.network(
//              "https://assets.lightspeedhq.com/img/2019/07/8aac85b2-blog_foodpresentationtipsfromtopchefs.jpg",
//              fit: BoxFit.cover,
//            ));
//      }),
//    );
  }

  Widget buildForYou() {
    return BlocBuilder(
        cubit: productForYouBloc,
        builder: (context, state) {
          if (state is ListProductsLoaded) {
            return Container(
              margin: EdgeInsets.only(top: _topBottomMargin, bottom: _topBottomMargin),
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
                                    margin: EdgeInsets.only(left: 10),
                                    child: CustomProductGridItem(
                                      cartIconKey: _cartIconKey,
                                      product: product,
                                      isFavorite: product.isFavoriteByCurrentUser,
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (b) => ProductDetailPage(product)));
                                      },
                                      onFavourite: () async {
                                        setState(() {
                                          product.isFavoriteByCurrentUser = !product.isFavoriteByCurrentUser;
                                        });
                                        await ProductService().doFavorite(product);
                                        //productForYouBloc.add(GetProductsForYou());
                                      },
                                      onAddToCart: () {
                                        addToCart(context, productID: product.id);
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

  Widget buildCategories() {
    return Container(
      height: 1000,
    );
  }
}
