import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/models/category_model.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = 'productPage';
  final CategoryModel category;

  ProductPage({this.category});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  GlobalKey cartGlobalKey = GlobalKey();
  ProductBloc bloc = ProductBloc(ProductLoading());

  void refresh() {
    if (widget.category == null) {
      bloc.add(GetAllProducts());
    } else {
      bloc.add(GetAllProductsByCategoryId(widget.category.id));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InPageAppBar(
              cartIconKey: cartGlobalKey,
              leading: GestureDetector(
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              title: widget.category != null ? widget.category.name : 'Tất cả',
            ),
            BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  if (state is ProductLoadingError) {
                    return Center(
                      child: CustomErrorWidget(),
                    );
                  } else if (state is ListProductsLoaded) {
                    return buildProducts(state.products);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget buildProducts(List<ProductModel> products) {
    List<Widget> children = products
        .map<Widget>((product) => CustomProductListItem(
              cartIconKey: cartGlobalKey,
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (b) => ProductDetailPage(product)));
                refresh();
              },
              product: product,
              priceTextColor: Colors.red,
              backgroundColor: FOREGROUND_COLOR,
              isFavorite: product.isFavoriteByCurrentUser,
              onFavourite: () {
                bloc.add(DoFavorite(product));

                refresh();
              },
              onAddToCart: () {
                addToCart(context, productID: product.id);
              },
            ))
        .toList();
    return Column(children: children);
  }
}
