import 'dart:async';
import 'dart:convert';

import 'package:ankiishopii/blocs/checkout_bloc/bloc.dart';
import 'package:ankiishopii/blocs/checkout_bloc/event.dart';
import 'package:ankiishopii/blocs/checkout_bloc/service.dart';
import 'package:ankiishopii/blocs/checkout_bloc/state.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/bloc.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/event.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/state.dart';
import 'package:ankiishopii/blocs/ordering_bloc/bloc.dart';
import 'package:ankiishopii/blocs/ordering_bloc/event.dart';
import 'package:ankiishopii/blocs/ordering_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/main.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/navigator/navigator_page.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../checkout/check_out_page.dart';

class OrderingDetailPage extends StatefulWidget {
  static const String routeName = 'orderingDetailPage';
  final OrderingModel orderingModel;

  OrderingDetailPage(this.orderingModel);

  @override
  _OrderingDetailPageState createState() => _OrderingDetailPageState();
}

class _OrderingDetailPageState extends State<OrderingDetailPage> {
  OrderingBloc bloc = OrderingBloc(OrderingLoading());
  DeliveryAddressBloc deliveryAddressBloc = DeliveryAddressBloc();
  ScrollController _scrollController = ScrollController();
  StreamController _scrollStreamController = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(GetOrdering(widget.orderingModel.id));
    deliveryAddressBloc.add(GetDeliveryAddress(widget.orderingModel.deliveryId));
    _scrollController.addListener(() {
      bool isScrollUp = _scrollController.position.userScrollDirection == ScrollDirection.reverse;
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
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            if (state is OrderingLoaded) {
              return Column(
                children: <Widget>[
                  Expanded(
                      child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        buildAppBar(state.orderingModel),
                        buildTotal(state.orderingModel),
                        buildCreatedDate(state.orderingModel),
                        buildStatus(state.orderingModel),
                        buildDivider(),
                        buildDelivery(state.orderingModel),
                        buildDivider(),
                        buildPaymentMethod(),
                        buildDivider(),
                        buildListOrderDetail(state.orderingModel.orderingDetail),
                      ],
                    ),
                  ))
                ],
              );
            }
            return Center(
              child: Text('error'),
            );
          }),
    );
  }

  Widget buildAppBar(OrderingModel orderingModel) {
    return InPageAppBar(
      title: 'Order: ${orderingModel.id.toString()}',
      showCartButton: false,
      leading: GestureDetector(
        onTap: () {
//          navigatorPagedKey.currentState.currentIndex = 3;
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget buildCreatedDate(OrderingModel orderingModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Created At: '),
          Text(
            '${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderingModel.createdDate))}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: PRIMARY_COLOR),
          ),
        ],
      ),
    );
  }

  Widget buildStatus(OrderingModel orderingModel) {
    var statusCode = orderingModel.status;
    var statusString = "Processing";
    switch (statusCode) {
      case 1:
        statusString = "Processing";
        break;
      case 2:
        statusString = "Delivering";
        break;
      case 3:
        statusString = "Complete";
        break;
      case 4:
        statusString = "Cancelled";
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Status:'),
          Text(
            '$statusString',
            style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget buildTotal(OrderingModel orderingModel) {
    var total = 0;
    for (var orderDetail in orderingModel.orderingDetail) {
      total += orderDetail.count * orderDetail.product.price;
    }
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: BACKGROUND_COLOR,
      ),
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
                  style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$total đ',
                  style:
                      DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.redAccent),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget buildListOrderDetail(List<OrderingDetailModel> listOrderingDetail) {
    return Container(
      margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
      child: Column(
        children: listOrderingDetail.map<Widget>((od) {
          var product = od.product;
          return CustomProductCheckOutItem(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (b) => ProductDetailPage(product)));
            },
            backgroundColor: FOREGROUND_COLOR,
            cartItem: od,
          );
        }).toList(),
      ),
    );
  }

  Widget buildDelivery(OrderingModel orderingModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(10),
      child: BlocBuilder(
          bloc: deliveryAddressBloc,
          builder: (context, state) {
            if (state is DeliveryAddressLoaded) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(flex: 1, child: Text('Name:')),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                state.deliveryAddress.fullname,
                                textAlign: TextAlign.right,
                                style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
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
                            Expanded(flex: 1, child: Text('Address:')),
                            Expanded(
                              flex: 2,
                              child: Text(
                                state.deliveryAddress.address,
                                textAlign: TextAlign.right,
                                style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
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
                            Expanded(flex: 1, child: Text('Phone:')),
                            Expanded(
                              flex: 2,
                              child: Text(
                                state.deliveryAddress.phoneNumber,
                                textAlign: TextAlign.right,
                                style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          ],
                        ),
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
              Text('Payment Method:'),
              Text(
                'COD',
                style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
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

  Future<OrderingModel> confirmCheckout(OrderingModel orderingModel) async {
    setState(() {});
    var isCheckOutOk = await CheckoutService().checkOut(orderingModel, status: 1);
    if (isCheckOutOk != null) {
      await Future.delayed(Duration(seconds: 5));
      print(jsonEncode(isCheckOutOk));
      refreshCart(context);
      Navigator.pop(context);
    } else {
      setState(() {});
    }

    return isCheckOutOk;
  }
}
