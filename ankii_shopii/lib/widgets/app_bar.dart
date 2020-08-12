import 'package:ankiishopii/blocs/account_bloc/state.dart';
import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/state.dart';
import 'package:ankiishopii/blocs/login_bloc/bloc.dart';
import 'package:ankiishopii/blocs/login_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/cart/cart_page.dart';
import 'package:ankiishopii/pages/search/search_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base/custom_ontap_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final EdgeInsets padding;
  final Color primaryColor;
  final Color backgroundColor;
  final AppBar appBar;

  CustomAppBar(
      {Key key,
      this.padding,
      this.backgroundColor = BACKGROUND_COLOR,
      this.primaryColor = PRIMARY_COLOR,
      this.appBar})
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
  final GlobalKey<CartWidgetState> cartIconKey;
  final String title;
  final Widget titleWidget;
  final Widget leading;
  final Color backgroundColor;
  final bool isLoggedIn;
  final bool showCartButton;
  final bool showAwesomeBackground;
  final bool showSearchButton;

  const InPageAppBar(
      {this.showAwesomeBackground = false,
      this.titleWidget,
      this.cartIconKey,
      this.title,
      this.leading,
      this.backgroundColor = BACKGROUND_COLOR,
      this.isLoggedIn = true,
      this.showSearchButton = true,
      this.showCartButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showAwesomeBackground ? null : backgroundColor,
      child: Container(
        height: 60,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
            left: 20, right: 20, top: ScreenHelper.getPaddingTop(context) + 10),
        child: Row(
          children: <Widget>[
            Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: this.leading != null ? 10 : 0),
                child: this.leading),
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
                          style: TEXT_STYLE_PRIMARY.copyWith(fontSize: 20),
                        ),
                  ),
                  Row(
                    children: <Widget>[
                      showSearchButton
                          ? CustomOnTapWidget(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) => SearchPage()));
                              },
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: PRIMARY_TEXT_COLOR,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 15,
                      ),
                      showCartButton
                          ? BlocBuilder(
                              cubit: BlocProvider.of<LoginBloc>(context),
                              builder: (context, state) {
                                if (state is LoginSuccessfully) {
                                  return CustomOnTapWidget(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) => CartPage()));
                                    },
                                    child: CartWidget(cartIconKey,size: 20,),
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
      ),
    );
  }
}

class CartWidget extends StatefulWidget {
  final GlobalKey cartKey;
  final double size;
  final Color color;

  CartWidget(this.cartKey, {this.size = 25, this.color = PRIMARY_COLOR})
      : super(key: cartKey);

  @override
  CartWidgetState createState() => CartWidgetState();
}

class CartWidgetState extends State<CartWidget> {
  bool _inProcess = false;

  onAddToCart({Duration duration}) {
    setState(() {
      _inProcess = true;
    });
    Future.delayed(duration ?? Duration(milliseconds: 600), () {
      refreshCart(context);
      setState(() {
        _inProcess = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocBuilder(
              cubit: BlocProvider.of<CartBloc>(context),
              builder: (_, state) {
                if (state is CartLoaded) {
                  var totalCount = 0;
                  for (OrderingModel ordering in state.cart) {
                    for (var od in ordering.orderingDetail) {
                      totalCount += od.count;
                    }
                  }
                  if (totalCount == 0) return Container();
                  return Text(
                    totalCount.toString(),
                    style: TEXT_STYLE_PRIMARY.copyWith(
                        color: widget.color,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.size / 2),
                  );
                } else {
                  return Container();
                }
              }),
          Icon(
            Icons.shopping_cart,
            //  key: widget.cartKey,
            color: widget.color,
            size: _inProcess ? widget.size * 1.2 : widget.size,
          )
        ],
      ),
    );
  }
}
