import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/blocs/shop_bloc/bloc.dart';
import 'package:ankiishopii/blocs/shop_bloc/event.dart';
import 'package:ankiishopii/blocs/shop_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/models/shop_account_model.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/pages/product/product_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopAccountDetailPage extends StatefulWidget {
  final String shopAccountUsername;

  // final ShopAccountModel shopAccountModel;

  ShopAccountDetailPage(this.shopAccountUsername);

  @override
  _ShopAccountDetailPageState createState() => _ShopAccountDetailPageState();
}

class _ShopAccountDetailPageState extends State<ShopAccountDetailPage> {
  GlobalKey<CartWidgetState> cartIconKey = GlobalKey();
  ShopAccountBloc bloc = ShopAccountBloc();
  ProductBloc productBloc = ProductBloc(ProductLoading());

  void _refresh() {
    productBloc.add(GetAllProducts());
  }

  Future _doFavorite(ProductModel product) async {
    setState(() {
      product.isFavoriteByCurrentUser = !product.isFavoriteByCurrentUser;
    });
    await ProductService().doFavorite(product);
    _refresh();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(GetShopAccount(widget.shopAccountUsername));
    productBloc.add(GetAllProducts());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: BlocBuilder(
          cubit: bloc,
          builder: (context, state) {
            if (state is ShopAccountLoaded) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    buildAppBar(),
                    buildAvatar(state.shopAccountModel),
                    buildInfo(state.shopAccountModel),
                    buildProducts()
                  ],
                ),
              );
            } else if (state is ShopAccountError) {
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

  Widget buildAppBar() {
    return InPageAppBar(
      cartIconKey: cartIconKey,
      leading: CustomOnTapWidget(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget buildAvatar(ShopAccountModel shopAccountModel) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 200,
      width: double.maxFinite,
      child: Stack(
        children: <Widget>[
          Container(
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        '${shopAccountModel.coverImage}'),
                    fit: BoxFit.cover)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: BACKGROUND_COLOR,
              radius: 50,
              child: CircleAvatar(
                  radius: 40,
                  backgroundColor: FOREGROUND_COLOR,
                  backgroundImage:
                      CachedNetworkImageProvider('${shopAccountModel.image}')),
            ),
          )
        ],
      ),
    );
  }

  Widget buildInfo(ShopAccountModel shopAccountModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.store),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  shopAccountModel.name,
                  style: TEXT_STYLE_PRIMARY.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.location_on),
              SizedBox(
                width: 10,
              ),
              Text(
                shopAccountModel.address,
                style: TEXT_STYLE_PRIMARY.copyWith(
                    fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.phone),
              SizedBox(
                width: 10,
              ),
              Text(
                shopAccountModel.phoneNumber,
                style: TEXT_STYLE_PRIMARY.copyWith(
                    fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _buildRate()
        ],
      ),
    );
  }

  Widget _buildRate() {
    return Row(
      children: <Widget>[
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star),
        Icon(Icons.star_half),
        Icon(Icons.star_border),
      ],
    );
  }

  Widget buildProducts() {
    return BlocBuilder(
        cubit: productBloc,
        builder: (_, state) {
          if (state is ListProductsLoaded) {
            var products = state.products
                .where((product) =>
                    product.shopUsername == widget.shopAccountUsername)
                .toList();
            return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  children: products
                      .map<Widget>((product) => Container(
                            margin: EdgeInsets.all(5),
                            child: CustomProductGridItem(
                              elevation: 5,
                              width: ScreenHelper.getWidth(context) * 0.45,
                              onTap: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) =>
                                            ProductDetailPage(product)));
                                _refresh();
                              },
                              cartIconKey: cartIconKey,
                              product: product,
                              backgroundColor: FOREGROUND_COLOR,
                              onFavourite: () async {
                                _doFavorite(product);
                              },
                              onAddToCart: () {
                                addToCart(context, productID: product.id);
                              },
                            ),
                          ))
                      .toList(),
                ));
          }
          return Container();
        });
  }
}
