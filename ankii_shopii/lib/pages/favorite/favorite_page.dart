import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritePage extends StatefulWidget {
  static const String pageRoute = 'favoritePage';
  final ScrollController scrollController;

  FavoritePage(this.scrollController);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  GlobalKey<CartWidgetState> cartIconKey = GlobalKey();
  ProductBloc bloc = ProductBloc(ProductLoading());

  Future _doFavorite(ProductModel productModel) async {
    setState(() {
      productModel.isFavoriteByCurrentUser =
          !productModel.isFavoriteByCurrentUser;
    });
    await ProductService().doFavorite(productModel);
    bloc.add(GetAllProducts());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(GetAllProducts());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Column(
        children: <Widget>[
          InPageAppBar(
            cartIconKey: cartIconKey,
            title: 'Favorite',
          ),
          Expanded(
              child: BlocBuilder(
                  cubit: bloc,
                  builder: (context, state) {
                    if (state is ListProductsLoaded)
                      return buildFavorite(state.products);
                    else if (state is ProductLoadingError)
                      return Center(
                        child: CustomErrorWidget(),
                      );
                    else
                      return Center(
                        child: CustomDotLoading(),
                      );
                  })),
        ],
      ),
    );
  }

  Widget buildFavorite(List<ProductModel> products) {
    var categories = products
        .where((product) => product.isFavoriteByCurrentUser)
        .map((product) => product.category.name)
        .toSet()
        .toList();

    if (categories.isEmpty) {
      return Center(
          child: Text(
        'No favorite!',
        style: TEXT_STYLE_PRIMARY.copyWith(fontStyle: FontStyle.italic),
      ));
    }
    return CustomTabView(
        hideIcon: true,
//        barShadow: true,
        backgroundColor: BACKGROUND_COLOR,
        children: categories.map((categoryName) {
          var favoriteProducts = products.where((product) =>
              product.category.name == categoryName &&
              product.isFavoriteByCurrentUser);
          return CustomTabViewItem(
              label: categoryName,
              icon: Icons.favorite,
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 100),
                  child: Column(
                      children: favoriteProducts
                          .map((favoriteProduct) => CustomProductListItem(
                                elevation: 10,
                                cartIconKey: cartIconKey,
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (b) => ProductDetailPage(
                                              favoriteProduct)));
                                  bloc.add(GetAllProducts());
                                },
                                onFavourite: () {
                                  _doFavorite(favoriteProduct);
                                },
                                onAddToCart: () async {
                                  // LoadingDialog.showLoadingDialog(context);
                                  await addToCart(context,
                                      productID: favoriteProduct.id, count: 1);
                                  //LoadingDialog.hideLoadingDialog(context);
                                },
                                product: favoriteProduct,
                                backgroundColor: FOREGROUND_COLOR,
                              ))
                          .toList()),
                ),
              ));
        }).toList());
  }
}
