import 'package:ankiishopii/blocs/account_bloc/state.dart';
import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/state.dart';
import 'package:ankiishopii/blocs/login_bloc/bloc.dart';
import 'package:ankiishopii/blocs/login_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/pages/cart/cart_page.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final EdgeInsets padding;
  final Color primaryColor;
  final Color backgroundColor;
  final AppBar appBar;

  CustomAppBar(
      {Key key, this.padding, this.backgroundColor = BACKGROUND_COLOR, this.primaryColor = PRIMARY_COLOR, this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
//          boxShadow: [
//        BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 3)]
      ),
      child: Container(
        padding: padding,
        child: appBar ??
            AppBar(
              elevation: 0,
              backgroundColor: backgroundColor,
            ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class InPageAppBar extends StatelessWidget {
  final GlobalKey cartIconKey;
  final String title;
  final Widget titleWidget;
  final Widget leading;
  final bool isLoggedIn;
  final bool showCartButton;
  final bool showBackground;

  const InPageAppBar(
      {this.showBackground = false,
      this.titleWidget,
      this.cartIconKey,
      this.title,
      this.leading,
      this.isLoggedIn = true,
      this.showCartButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 20, top: ScreenHelper.getPaddingTop(context) + 10),
      child: Row(
        children: <Widget>[
          Container(margin: EdgeInsets.only(right: this.leading != null ? 10 : 0), child: this.leading),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: titleWidget ??
                      Text(
                        title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 30),
                      ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (b) => SearchPage()));
                      },
                      child: Icon(
                        Icons.search,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                    showCartButton
                        ? BlocBuilder(
                            bloc: BlocProvider.of<LoginBloc>(context),
                            builder: (context, state) {
                              if (state is LoginSuccessfully) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (b) => CartPage()));
                                  },
                                  child: CartWidget(cartIconKey),
                                );
                              }
                              return Container();
                            })
                        : Container(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CartWidget extends StatelessWidget {
  final GlobalKey cartKey;

  CartWidget(this.cartKey);

  @override
  Widget build(BuildContext context) {
    refreshCart(context);
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocBuilder(
              bloc: BlocProvider.of<CartBloc>(context),
              builder: (_, state) {
                if (state is CartLoaded) {
                  var totalCount = 0;
                  for (var item in state.cart.orderingDetail) {
                    totalCount += item.count;
                  }
                  if (totalCount == 0) return Container();
                  return Text(
                    totalCount.toString(),
                    style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
                  );
                } else {
                  return Container();
                }
              }),
          Icon(
            Icons.shopping_cart,
            key: cartKey,
            color: PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }
}
