import 'dart:async';
import 'dart:convert';
import 'package:ankiishopii/blocs/account_bloc/service.dart';
import 'package:ankiishopii/blocs/checkout_bloc/bloc.dart';
import 'package:ankiishopii/blocs/checkout_bloc/event.dart';
import 'package:ankiishopii/blocs/checkout_bloc/service.dart';
import 'package:ankiishopii/blocs/checkout_bloc/state.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/bloc.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/event.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/delivery_address/delivery_address_page.dart';
import 'package:ankiishopii/pages/navigator/navigator_page.dart';
import 'package:ankiishopii/pages/ordering/ordering_detail_page.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutPage extends StatefulWidget {
  static const String routeName = 'checkoutPage';
  final List<OrderingModel> cart;

  CheckOutPage(this.cart);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  CheckoutBloc bloc = CheckoutBloc();
  DeliveryAddressBloc deliveryAddressBloc = DeliveryAddressBloc();
  ScrollController _scrollController = ScrollController();
  StreamController _scrollStreamController = StreamController();
  bool _isDoingCheckoutConfirm = false;
  int _chosenDeliveryId = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // bloc.add(GetCheckout(widget.cart));

    var ordering = widget.cart.first;
    if (ordering.deliveryId != -1) {
      _chosenDeliveryId = ordering.deliveryId;
      deliveryAddressBloc.add(GetDeliveryAddress(ordering.deliveryId));
    } else {
      _chosenDeliveryId = currentLogin.account.defaultDeliveryId;
      deliveryAddressBloc
          .add(GetDeliveryAddress(currentLogin.account.defaultDeliveryId));
    }

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
    bloc.close();
    deliveryAddressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          backgroundColor: BACKGROUND_COLOR,
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        buildAppBar(),
                        buildDivider(),
                        buildDelivery(widget.cart),
                        buildDivider(),
                        buildPaymentMethod(),
                        buildDivider(),
                        buildListOrderDetail(widget.cart),
                      ],
                    ),
                  ))
                ],
              ),
              buildBottomBar(widget.cart)
            ],
          )),
    );
  }

  Widget buildAppBar() {
    return InPageAppBar(
      title: 'Check Out',
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

  Widget buildBottomBar(List<OrderingModel> orderingModels) {
    var total = 0;
    List<OrderingDetailModel> orderingDetail = [];
    for (OrderingModel ordering in orderingModels) {
      for (var od in ordering.orderingDetail) {
        orderingDetail.add(od);
      }
    }
    for (var od in orderingDetail) {
      var eachTotal = od.count * od.product.price;
      total += eachTotal;
    }

    bool _canCheckout = true;
    for (var ordering in orderingModels) {
      if (_chosenDeliveryId == -1 || ordering.status > 0) _canCheckout = false;
      break;
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: StreamBuilder(
          stream: _scrollStreamController.stream,
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 100),
              child: snapshot.hasData && snapshot.data == true
                  ? null
                  : Container(
                      height: kBottomNavigationBarHeight,
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: BACKGROUND_COLOR,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${numberToMoneyString(total)}',
                                  style: TEXT_STYLE_PRIMARY.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: PRICE_COLOR_PRIMARY),
                                )
                              ],
                            ),
                          )),
                          !_canCheckout || _isDoingCheckoutConfirm
                              ? Container()
                              : CustomOnTapWidget(
                                  onTap: () {
                                    if (!_isDoingCheckoutConfirm) {
                                      LoadingDialog.showLoadingDialog(context,
                                          text: 'Processing...',
                                          hideOnBackButton: false);

                                      confirmCheckout(orderingModels);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: kBottomNavigationBarHeight,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: FOREGROUND_COLOR,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      Icons.check,
                                      size: 25,
                                      color: BACKGROUND_COLOR,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
            );
          }),
    );
  }

  Widget buildListOrderDetail(List<OrderingModel> cart) {
    List<OrderingDetailModel> listOrderingDetail = [];
    for (OrderingModel ordering in cart) {
      for (var od in ordering.orderingDetail) {
        listOrderingDetail.add(od);
      }
    }
    return Container(
      margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
      child: Column(
          children: cart
              .map<Widget>((ordering) => Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5, top: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.store,
                              color: PRIMARY_TEXT_COLOR,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(ordering.shopUsername,
                                style: TEXT_STYLE_PRIMARY),
                          ],
                        ),
                      ),
                      Column(
                        children: listOrderingDetail
                            .where((od) => od.orderingId == ordering.id)
                            .map<Widget>((od) {
                          var product = od.product;
                          return CustomProductCheckOutItem(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (b) =>
                                          ProductDetailPage(product)));
                            },
                            backgroundColor: FOREGROUND_COLOR,
                            cartItem: od,
                          );
                        }).toList(),
                      ),
                    ],
                  ))
              .toList()),
    );
  }

  Widget buildDelivery(List<OrderingModel> orderingModels) {
    OrderingModel firstOrdering = orderingModels.first;
    return CustomOnTapWidget(
      onTap: () async {
        await showAddressChooserDialog(firstOrdering);
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.all(10),
        child: BlocBuilder(
            cubit: deliveryAddressBloc,
            builder: (context, state) {
              if (state is DeliveryAddressLoaded) {
                firstOrdering.deliveryId = state.deliveryAddress.id;
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Name:',
                                    style: TEXT_STYLE_PRIMARY,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  state.deliveryAddress.fullname,
                                  textAlign: TextAlign.right,
                                  style: TEXT_STYLE_PRIMARY.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Text('Address:',
                                      style: TEXT_STYLE_PRIMARY)),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  state.deliveryAddress.address,
                                  textAlign: TextAlign.right,
                                  style: TEXT_STYLE_PRIMARY.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Text('Phone:',
                                      style: TEXT_STYLE_PRIMARY)),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  state.deliveryAddress.phoneNumber,
                                  textAlign: TextAlign.right,
                                  style: TEXT_STYLE_PRIMARY.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '(Tap to change Delivery Information)',
                            style: TEXT_STYLE_PRIMARY.copyWith(
                                fontSize: 8, fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: Text('Please select Delivery Address'),
                );
              }
            }),
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Payment Method:', style: TEXT_STYLE_PRIMARY),
              Text(
                'COD',
                style: TEXT_STYLE_PRIMARY.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 1,
      color: Colors.black26,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    );
  }

  showAddressChooserDialog(OrderingModel orderingModel) async {
    var rs = await showDialog(
      builder: (_) {
        return Dialog(
            child: DeliveryAddressPage(
          currentCheckout: orderingModel,
          isDialog: true,
        ));
      },
      context: context,
      barrierDismissible: false,
    );
    if (rs != null && rs is DeliveryAddressModel) {
      _chosenDeliveryId = rs.id;
      LoadingDialog.showLoadingDialog(context);

      //await Future.delayed(Duration(seconds: 2));
      //await CheckoutService().checkOut(ordering, deliveryId: rs.id);
      deliveryAddressBloc.add(GetDeliveryAddress(rs.id));
      setState(() {
        _chosenDeliveryId = rs.id;
      });
      LoadingDialog.hideLoadingDialog(context);
    }
  }

  Future<List<OrderingModel>> confirmCheckout(
      List<OrderingModel> orderingModels) async {
    setState(() {
      _isDoingCheckoutConfirm = true;
    });
    List<OrderingModel> isAllCheckOutOk = [];
    for (var ordering in orderingModels) {
      var isCheckoutOk = await CheckoutService()
          .checkOut(ordering, status: 1, deliveryId: _chosenDeliveryId);
      if (isCheckoutOk != null) {
        isAllCheckOutOk.add(isCheckoutOk);
      }
    }
    if (isAllCheckOutOk.length > 0) {
      await Future.delayed(Duration(seconds: 5));
      print(jsonEncode(isAllCheckOutOk));
      refreshCart(context);
      changePageViewPage(3);
      Navigator.popUntil(context, (route) => route.isFirst);
//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (b) => OrderingDetailPage(orderingModel)));
    } else {
      setState(() {
        _isDoingCheckoutConfirm = false;
      });
    }

    return isAllCheckOutOk;
  }
}
