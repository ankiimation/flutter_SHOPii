import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
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
  final CategoryModel category;

  ProductPage({this.category});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductBloc bloc = ProductBloc(ListProductsLoading());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.category == null) {
      bloc.add(GetAllProducts());
    } else {
      bloc.add(GetAllProductsViaCategoryId(widget.category.id));
    }
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
                  if (state is ListProductsLoadingError) {
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (b) => ProductDetailPage(product)));
              },
              image: CachedNetworkImageProvider(product.image),
              title: product.name,
              price: product.price.toString() + "đ",
              priceTextColor: Colors.red,
              backgroundColor: FOREGROUND_COLOR,
            ))
        .toList();
    return Column(children: children);
  }
}
