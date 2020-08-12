import 'dart:async';

import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/cart_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/models/product_model.dart';
import 'package:ankiishopii/pages/account/login_page.dart';
import 'package:ankiishopii/pages/checkout/check_out_page.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  static const String routeName = 'cart';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartBloc bloc;
  ScrollController _scrollController = ScrollController();
  StreamController _scrollStreamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = BlocProvider.of<CartBloc>(context);
    _scrollController.addListener(() {
      bool isScrollUp = _scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      _scrollStreamController.sink.add(isScrollUp);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: BlocBuilder(
          cubit: bloc,
          builder: (context, state) {
            if (state is CartLoaded) {
              return Stack(
                children: <Widget>[
                  Container(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          buildAppBar(),
                          buildCartDetail(state.cart)
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: buildNavigation(state.cart))
                ],
              );
            } else if (state is CartError) {
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

  Widget buildNavigation(List<OrderingModel> cart) {
    List<OrderingDetailModel> orderingDetail = [];
    for (OrderingModel ordering in cart) {
      for (var od in ordering.orderingDetail) {
        orderingDetail.add(od);
      }
    }
    if (orderingDetail.length > 0) {
      int total = 0;
      for (var od in orderingDetail) {
        var eachTotal = od.count * od.product.price;
        total += eachTotal;
      }
      return StreamBuilder(
          stream: _scrollStreamController.stream,
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              child: snapshot.hasData && snapshot.data == true
                  ? null
                  : Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: BACKGROUND_COLOR,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      height: 55,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Total:',
                                  style: TEXT_STYLE_PRIMARY.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  numberToMoneyString(total),
                                  style: TEXT_STYLE_PRIMARY.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: PRICE_COLOR_PRIMARY),
                                )
                              ],
                            ),
                          )),
                          CustomOnTapWidget(
                            onTap: () async {
                              if (currentLogin == null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) => LoginPage()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (b) => CheckOutPage(cart)));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              height: 55,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: FOREGROUND_COLOR,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(
                                Icons.forward,
                                size: 25,
                                color: FORE_TEXT_COLOR,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          });
    }
    return Container();
  }

  Widget buildAppBar() {
    return InPageAppBar(
      title: 'Cart',
      showCartButton: false,
      leading: CustomOnTapWidget(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: PRIMARY_TEXT_COLOR,
          size: 20,
        ),
      ),
    );
  }

  Widget buildCartDetail(List<OrderingModel> cart) {
    List<OrderingDetailModel> orderingDetail = [];
    for (OrderingModel ordering in cart) {
      for (var od in ordering.orderingDetail) {
        orderingDetail.add(od);
      }
    }

    // and later, before the timer goes off...
    if (orderingDetail.length > 0) {
      return Container(
        child: Column(
            children: cart.map<Widget>((ordering) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.store,
                      color: PRIMARY_TEXT_COLOR,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      ordering.shopUsername,
                      style: TEXT_STYLE_PRIMARY,
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: orderingDetail
                      .where((od) => od.orderingId == ordering.id)
                      .toList()
                      .map<Widget>((od) {
                    var product = od.product;
                    return CustomProductCartItem(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (b) => ProductDetailPage(product)));
                      },
                      onDelete: () {
                        _removeFromCartConfirmDialog(
                            product: product,
                            onYes: () async {
//                      bloc.add(AddToCart(productID: product.id, count: od.count * -1));
                              //  LoadingDialog.showLoadingDialog(context, text: 'Removing...');
                              await addToCart(context,
                                  productID: product.id, count: od.count * -1);
                              // LoadingDialog.hideLoadingDialog(context);
                            });
                      },
                      onTextSubmit: (quantity) async {
                        int count = quantity - od.count;
                        if (od.count + count <= 0) {
                          _removeFromCartConfirmDialog(
                              product: product,
                              onNo: () async {
                                refreshCart(context);
                              },
                              onYes: () async {
//                        bloc.add(AddToCart(productID: product.id, count: -1));
                                //    LoadingDialog.showLoadingDialog(context, text: 'Removing...');
                                await addToCart(context,
                                    productID: product.id,
                                    count: od.count * -1);
                                //  LoadingDialog.hideLoadingDialog(context);
                              });
                        } else {
                          await addToCart(context,
                              productID: product.id,
                              count: quantity - od.count);
                        }
                      },
                      onIncreaseQuantity: () async {
//                _onIncreaseItem(od);
//                bloc.add(AddToCart(productID: product.id, count: 1));
                        //LoadingDialog.showLoadingDialog(context, text: 'Adding...');
                        FocusScope.of(context).unfocus();
                        await addToCart(context,
                            productID: product.id, count: 1);

                        //  LoadingDialog.hideLoadingDialog(context);
                      },
                      onDecreaseQuantity: () async {
                        FocusScope.of(context).unfocus();
                        if (od.count - 1 <= 0) {
                          _removeFromCartConfirmDialog(
                              product: product,
                              onYes: () async {
//                        bloc.add(AddToCart(productID: product.id, count: -1));
                                //    LoadingDialog.showLoadingDialog(context, text: 'Removing...');
                                await addToCart(context,
                                    productID: product.id, count: -1);
                                //  LoadingDialog.hideLoadingDialog(context);
                              });
                        } else {
//                  _onDecreaseItem(od);
//                  bloc.add(AddToCart(productID: product.id, count: -1));
                          // LoadingDialog.showLoadingDialog(context, text: 'Removing...');
                          await addToCart(context,
                              productID: product.id, count: -1);
                          //  LoadingDialog.hideLoadingDialog(context);
                        }
                      },
                      backgroundColor: FOREGROUND_COLOR,
                      cartItem: od,
                    );
                  }).toList()
                        ..add(Container(
                          height: 60,
                        )),
                ),
              ),
            ],
          );
        }).toList()),
      );
    }
    return Container(
      height: ScreenHelper.getSafeHeight(context),
      alignment: Alignment.center,
      child: CustomEmptyWidget(
        backgroundColor: FOREGROUND_COLOR,
        title: Icon(
          Icons.remove_shopping_cart,
          color: PRIMARY_COLOR,
          size: 50,
        ),
      ),
    );
  }

  Timer _increaseTimer;
  int _increasedValue = 0;

  _onIncreaseItem(OrderingDetailModel od) {
    if (_increaseTimer != null) {
      _increaseTimer.cancel();
      //   _increasedValue = 0;
    }
    setState(() {
      od.count++;
      _increasedValue++;
    });
    _increaseTimer = Timer(Duration(seconds: 1), () async {
      print('CART ADD:' + _increasedValue.toString());
      bloc.add(AddToCart(productID: od.product.id, count: _increasedValue));
      _increasedValue = 0;
    });
  }

  Timer _decreaseTimer;
  int _decreaseValue = 0;

  _onDecreaseItem(OrderingDetailModel od) {
    if (_decreaseTimer != null) {
      _decreaseTimer.cancel();
      //  _decreaseValue = 0;

    }
    setState(() {
      od.count--;
      _decreaseValue--;
    });
    _decreaseTimer = Timer(Duration(seconds: 1), () async {
      print('CART DECREASED:' + _decreaseValue.toString());
      bloc.add(AddToCart(productID: od.product.id, count: _decreaseValue));
      _decreaseValue = 0;
    });
  }

  _removeFromCartConfirmDialog(
      {@required ProductModel product,
      @required Function onYes,
      Function onNo}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: FOREGROUND_COLOR, width: 2)),
            backgroundColor: BACKGROUND_COLOR,
            title: Text(product.name),
            content: Text('You wanna remove this item from cart?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    await onYes();
                    Navigator.pop(context);
                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: () async {
                    if (onNo != null) await onNo();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TEXT_STYLE_PRIMARY.copyWith(
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }
}
