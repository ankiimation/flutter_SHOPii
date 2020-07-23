import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/account/login_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/add_to_cart_effect.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/constant.dart';

class CustomProductListItem extends StatelessWidget {
  final GlobalKey cartIconKey;
  final ProductModel product;
  final Color priceTextColor;
  final Color quickActionColor;

  final Function onTap;
  final Function onAddToCart;
  final Function onFavourite;
  final Color backgroundColor;
  final bool isFavorite;

  CustomProductListItem(
      {this.backgroundColor = BACKGROUND_COLOR,
      this.product,
      this.cartIconKey,
      this.onTap,
      this.onAddToCart,
      this.onFavourite,
      this.quickActionColor = PRIMARY_COLOR,
      this.priceTextColor = Colors.red,
      this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    GlobalKey inkwellKey = GlobalKey();
    double height = 100;
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: height - 50, top: 10, bottom: 10, right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 60, top: 10, right: 20, bottom: 10),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(100), bottomRight: Radius.circular(100))),
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
                              product.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: PRIMARY_COLOR, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              product.price.toString() ?? '0đ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  letterSpacing: 1.2, color: priceTextColor, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              product.description ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: PRIMARY_COLOR, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (currentLogin == null) {
                                  Navigator.push(context, MaterialPageRoute(builder: (b) => LoginPage()));
                                  return;
                                }
                                if (onFavourite != null) {
                                  onFavourite();
                                }
                              },
                              child: Container(
                                  child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: quickActionColor,
                                size: 20,
                              )),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              key: inkwellKey,
                              onTap: () {
                                if (currentLogin == null) {
                                  Navigator.push(context, MaterialPageRoute(builder: (b) => LoginPage()));
                                  return;
                                }
                                if (onAddToCart != null) {
                                  final RenderBox box = inkwellKey.currentContext.findRenderObject();
                                  final Offset position = box.globalToLocal(Offset.zero);
                                  var dx = position.dx * -1;
                                  var dy = position.dy * -1;
                                  print(dx.toString() + " - " + dy.toString());

                                  updateCartIconPosition(cartIconKey: cartIconKey);
                                  showAddToCartAnimation(context,
                                      start: CustomPosition(dx, dy),
                                      end: CustomPosition(cartIconPositionDx, cartIconPositionDy));
                                  onAddToCart();
                                }
                              },
                              child: Container(
                                  child: Icon(
                                Icons.add_shopping_cart,
                                color: quickActionColor,
                                size: 20,
                              )),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: height,
              height: height,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                child: Container(
                  width: height - 15,
                  height: height - 15,
                  child: CircleAvatar(
                    backgroundColor: backgroundColor,
                    backgroundImage: CachedNetworkImageProvider(product.image),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  final Color backgroundColor;

  CustomProductCartItem({
    this.backgroundColor = BACKGROUND_COLOR,
    this.cartItem,
    this.onTap,
    this.onDecreaseQuantity,
    this.onIncreaseQuantity,
    this.onDelete,
    this.quickActionColor = PRIMARY_COLOR,
    this.priceTextColor = Colors.red,
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: height - 100, top: 10, bottom: 10, right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 60, top: 10, right: 20, bottom: 10),
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
                              style: TextStyle(color: PRIMARY_COLOR, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.cartItem.product.description ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: PRIMARY_COLOR, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Total'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('Quantity'),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          (widget.cartItem.product.price * widget.cartItem.count).toString() ?? '0đ',
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
                                          GestureDetector(
                                            onTap: widget.onDecreaseQuantity,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(15)),
                                              child: Icon(Icons.arrow_left),
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
                                                controller: quantityController,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
                                                cursorColor: FOREGROUND_COLOR,
                                                decoration: InputDecoration.collapsed().copyWith(
                                                    isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: widget.onIncreaseQuantity,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(15)),
                                              child: Icon(Icons.arrow_right),
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
                    backgroundColor: widget.backgroundColor,
                    backgroundImage: CachedNetworkImageProvider(widget.cartItem.product.image),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onDelete,
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        Icons.close,
                        size: 20,
                      ))),
            ),
          ],
        ),
      ),
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
      {this.backgroundColor = BACKGROUND_COLOR,
      this.cartItem,
      this.onTap,
      this.onAddToCart,
      this.onFavourite,
      this.quickActionColor = PRIMARY_COLOR,
      this.priceTextColor = Colors.red,
      this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(100)),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundImage: CachedNetworkImageProvider(cartItem.product.image),
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
                      style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Price:', style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('${cartItem.product.price}',
                            textAlign: TextAlign.end,
                            style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Quantity:',
                            style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('x ${cartItem.count}',
                            textAlign: TextAlign.end,
                            style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total:', style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('${cartItem.count * cartItem.product.price}',
                            textAlign: TextAlign.end,
                            style: DEFAULT_TEXT_STYLE.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold, color: priceTextColor)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
