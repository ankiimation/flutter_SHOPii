import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/account/login_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/add_to_cart_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/constant.dart';
import 'base/custom_ontap_widget.dart';

class CustomProductListItem extends StatefulWidget {
  final GlobalKey cartIconKey;
  final ProductModel product;
  final Color priceTextColor;
  final Color quickActionColor;

  final Function onTap;
  final Function onAddToCart;
  final Function onFavourite;
  final Color backgroundColor;
  final bool showQuickActionButtons;
  final double elevation;

  CustomProductListItem({
    this.backgroundColor = BACKGROUND_COLOR,
    this.product,
    this.cartIconKey,
    this.onTap,
    this.onAddToCart,
    this.onFavourite,
    this.showQuickActionButtons = true,
    this.quickActionColor = FORE_TEXT_COLOR,
    this.priceTextColor = PRICE_COLOR_ON_FORE,
    this.elevation = 1,
  });

  @override
  _CustomProductListItemState createState() => _CustomProductListItemState();
}

class _CustomProductListItemState extends State<CustomProductListItem>
    with SingleTickerProviderStateMixin {
  final double height = 120;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey inkwellKey = GlobalKey();

    // TODO: implement build
    return Container(
      height: height,
      margin:
          EdgeInsets.only(left: 20, right: 20, bottom: widget.elevation + 10),
      child: RaisedButton(
        onPressed: widget.onTap,
        elevation: widget.elevation,
        color: widget.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.only(top: 10, right: 15, left: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              buildImage(),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: buildInfo()),
                    SizedBox(
                      width: 10,
                    ),
                    buildQuickActionButton(context, inkwellKey)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Container(
      width: height - 20,
      height: height - 20,
      child: Card(
        elevation: 5,
        color: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.product.image),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget buildInfo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.product.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            numberToMoneyString(widget.product.price) ?? '0đ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                letterSpacing: 1.2,
                color: widget.priceTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
//                          Expanded(
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.store,
//                                  size: 20,
//                                ),
//                                SizedBox(
//                                  width: 5,
//                                ),
//                                Text(
//                                  product.shopUsername,
//                                  maxLines: 1,
//                                  overflow: TextOverflow.ellipsis,
//                                  style: TextStyle(letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.bold),
//                                ),
//                              ],
//                            ),
//                          ),
          Text(
            widget.product.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildQuickActionButton(BuildContext context, GlobalKey onTapKey) {
    return widget.showQuickActionButtons
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CustomOnTapWidget(
                onTap: () {
                  if (currentLogin == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (b) => LoginPage()));
                    return;
                  }
                  if (widget.onFavourite != null) {
                    widget.onFavourite();
                  }
                },
                child: Container(
                    child: Icon(
                  widget.product.isFavoriteByCurrentUser
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.quickActionColor,
                  size: 25,
                )),
              ),
              ClipOval(
                child: Material(
                  color: widget.quickActionColor, // button color
                  child: InkWell(
                    key: onTapKey,
                    splashColor: widget.backgroundColor, // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: widget.backgroundColor,
                        )),
                    onTap: () async {
                      if (currentLogin == null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (b) => LoginPage()));
                        return;
                      }
                      if (widget.onAddToCart != null) {
                        final RenderBox box =
                            onTapKey.currentContext.findRenderObject();
                        final Offset position = box.globalToLocal(Offset.zero);
                        var dx = position.dx * -1;
                        var dy = position.dy * -1;
                        //print(dx.toString() + " - " + dy.toString());

                        updateCartIconPosition(cartIconKey: widget.cartIconKey);

                        await showAddToCartAnimation(context,
                            start: CustomPosition(dx, dy),
                            end: CustomPosition(
                                cartIconPositionDx, cartIconPositionDy));
                        widget.onAddToCart();
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}

class CustomProductCartItem extends StatefulWidget {
  final OrderingDetailModel cartItem;
  final Color priceTextColor;
  final Color quickActionColor;
  final Function onTap;
  final Function onDelete;
  final Function onIncreaseQuantity;
  final Function onDecreaseQuantity;
  final Function(int) onTextSubmit;
  final Color backgroundColor;

  CustomProductCartItem({
    this.backgroundColor = BACKGROUND_COLOR,
    this.cartItem,
    this.onTap,
    this.onDecreaseQuantity,
    this.onIncreaseQuantity,
    this.onDelete,
    this.onTextSubmit,
    this.quickActionColor = PRIMARY_COLOR,
    this.priceTextColor = PRICE_COLOR_ON_FORE,
  });

  @override
  _CustomProductCartItemState createState() => _CustomProductCartItemState();
}

class _CustomProductCartItemState extends State<CustomProductCartItem> {
  var quantityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = 150;
    quantityController.text = widget.cartItem.count.toString();
    // TODO: implement build
    return CustomOnTapWidget(
      onTap: widget.onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: height - 100, top: 10, bottom: 10, right: 10),
              child: Container(
                padding:
                    EdgeInsets.only(left: 60, top: 10, right: 20, bottom: 10),
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.cartItem.product.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.cartItem.product.description ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Total',
                                      style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Quantity',
                                      style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          numberToMoneyString(widget.cartItem
                                                          .product.price *
                                                      widget.cartItem.count)
                                                  .toString() ??
                                              '0đ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              letterSpacing: 1.2,
                                              color: widget.priceTextColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          CustomOnTapWidget(
                                            onTap: widget.onDecreaseQuantity,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                  color: BACKGROUND_COLOR
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: widget.cartItem.count > 1
                                                  ? Icon(Icons.remove)
                                                  : Icon(
                                                      Icons.delete_outline,
                                                      color:
                                                          PRICE_COLOR_PRIMARY,
                                                    ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 50,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: PRIMARY_COLOR
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: TextFormField(
                                                controller: quantityController,
                                                //enabled: false,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onFieldSubmitted:
                                                    (quantityString) {
                                                  int quantity =
                                                      int.parse(quantityString);
                                                  if (widget.onTextSubmit !=
                                                      null) {
                                                    widget
                                                        .onTextSubmit(quantity);
                                                  }
                                                },
                                                textAlign: TextAlign.center,
                                                style: TEXT_STYLE_ON_FOREGROUND
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                cursorColor: FOREGROUND_COLOR,
                                                decoration: InputDecoration
                                                        .collapsed(hintText: '')
                                                    .copyWith(
                                                        hintText: '',
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5)),
                                              ),
                                            ),
                                          ),
                                          CustomOnTapWidget(
                                            onTap: widget.onIncreaseQuantity,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              margin: EdgeInsets.only(left: 5),
                                              decoration: BoxDecoration(
                                                  color: BACKGROUND_COLOR
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: widget.backgroundColor,
                child: Container(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: PRIMARY_COLOR,
                    backgroundImage: CachedNetworkImageProvider(
                        widget.cartItem.product.image),
                  ),
                ),
              ),
            ),
            CustomOnTapWidget(
              onTap: widget.onDelete,
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: widget.backgroundColor,
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: FORE_TEXT_COLOR,
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProductGridItem extends StatefulWidget {
  final GlobalKey cartIconKey;
  final ProductModel product;
  final Color priceTextColor;
  final Color quickActionColor;
  final double width;

  final Function onTap;
  final Function onAddToCart;
  final Function onFavourite;
  final Color backgroundColor;
  final double elevation;
  final bool showQuickAction;

  CustomProductGridItem(
      {this.cartIconKey,
      this.product,
      this.priceTextColor = PRICE_COLOR_PRIMARY,
      this.quickActionColor = FORE_TEXT_COLOR,
      this.width = 150,
      this.onTap,
      this.onAddToCart,
      this.onFavourite,
      this.backgroundColor = BACKGROUND_COLOR,
      this.elevation = 1,
      this.showQuickAction = true});

  @override
  _CustomProductGridItemState createState() => _CustomProductGridItemState();
}

class _CustomProductGridItemState extends State<CustomProductGridItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.width * 1.3;
    return Container(
//      margin: EdgeInsets.only(bottom: widget.elevation),
      width: widget.width,
      height: height,
      child: RaisedButton(
        color: widget.backgroundColor,
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(10),
        onPressed: () {
          widget.onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
//
                    image: DecorationImage(
                        image: NetworkImage(widget.product.image),
                        fit: BoxFit.cover),
                    color: PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: <Widget>[
                Text(
                  widget.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  numberToMoneyString(widget.product.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                    color: PRICE_COLOR_ON_FORE,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.showQuickAction ? buildQuickAction() : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuickAction() {
    GlobalKey addToCartIconKey = GlobalKey();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomOnTapWidget(
          onTap: () {
            if (currentLogin == null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (b) => LoginPage()));
              return;
            }
            if (widget.onFavourite != null) {
              widget.onFavourite();
            }
          },
          child: Icon(
            widget.product.isFavoriteByCurrentUser
                ? Icons.favorite
                : Icons.favorite_border,
            size: 25,
            color: FORE_TEXT_COLOR,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ClipOval(
          child: Material(
            color: widget.quickActionColor, // button color
            child: InkWell(
              key: addToCartIconKey,
              splashColor: widget.backgroundColor,
              // inkwell color
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: widget.backgroundColor,
                  )),
              onTap: () async {
                if (currentLogin == null) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (b) => LoginPage()));
                  return;
                }
                if (widget.onAddToCart != null) {
                  final RenderBox box =
                      addToCartIconKey.currentContext.findRenderObject();
                  final Offset position = box.globalToLocal(Offset.zero);
                  var dx = position.dx * -1;
                  var dy = position.dy * -1;
                  //print(dx.toString() + " - " + dy.toString());

                  updateCartIconPosition(cartIconKey: widget.cartIconKey);

                  await showAddToCartAnimation(context,
                      start: CustomPosition(dx, dy),
                      end: CustomPosition(
                          cartIconPositionDx, cartIconPositionDy));
                  widget.onAddToCart();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomProductCheckOutItem extends StatelessWidget {
  final OrderingDetailModel cartItem;
  final Color priceTextColor;
  final Color quickActionColor;

  final Function onTap;
  final Function onAddToCart;
  final Function onFavourite;
  final Color backgroundColor;
  final bool isFavorite;

  CustomProductCheckOutItem(
      {this.backgroundColor = FOREGROUND_COLOR,
      this.cartItem,
      this.onTap,
      this.onAddToCart,
      this.onFavourite,
      this.quickActionColor = PRIMARY_COLOR,
      this.priceTextColor = PRICE_COLOR_ON_FORE,
      this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return CustomOnTapWidget(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(100)),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    CachedNetworkImageProvider(cartItem.product.image),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        cartItem.product.name,
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Price:',
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('${numberToMoneyString(cartItem.product.price)}',
                              textAlign: TextAlign.end,
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Quantity:',
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('x ${cartItem.count}',
                              textAlign: TextAlign.end,
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Total:',
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(
                              '${numberToMoneyString(cartItem.count * cartItem.product.price)}',
                              textAlign: TextAlign.end,
                              style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: priceTextColor)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
