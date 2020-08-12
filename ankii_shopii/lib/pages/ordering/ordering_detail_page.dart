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
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/main.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/navigator/navigator_page.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/pages/shop_account/shop_account_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
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
    deliveryAddressBloc
        .add(GetDeliveryAddress(widget.orderingModel.deliveryId));
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
      onWillPop: () async {},
      child: Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: BlocBuilder(
            cubit: bloc,
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
                          buildCancel(state.orderingModel),
                          buildDivider(),
                          buildDelivery(state.orderingModel),
                          buildDivider(),
                          buildPaymentMethod(),
                          buildDivider(),
                          buildShopUsername(state.orderingModel),
                          buildListOrderDetail(
                              state.orderingModel.orderingDetail),
                        ],
                      ),
                    ))
                  ],
                );
              } else if (state is OrderingLoading) {
                return Center(
                  child: CustomDotLoading(),
                );
              }
              return Center(
                child: CustomEmptyWidget(),
              );
            }),
      ),
    );
  }

  Widget buildAppBar(OrderingModel orderingModel) {
    return InPageAppBar(
      title: 'Order: ${orderingModel.id.toString()}',
      showCartButton: false,
      leading: CustomOnTapWidget(
        onTap: () {
//          navigatorPagedKey.currentState.currentIndex = 3;
          changePageViewPage(3);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: PRIMARY_TEXT_COLOR,
          size: 20,
        ),
      ),
    );
  }

  Widget buildCreatedDate(OrderingModel orderingModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Created At: ',
            style: TEXT_STYLE_PRIMARY,
          ),
          Text(
            '${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderingModel.createdDate))}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TEXT_STYLE_PRIMARY.copyWith(
                fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildStatus(OrderingModel orderingModel) {
    var statusCode = orderingModel.status;
    var statusString = "Processing";
    var statusIcon = Icon(
      Icons.query_builder,
      size: 15,
      color: Colors.grey,
    );
    switch (statusCode) {
      case 1:
        statusString = "Processing";
        statusIcon = Icon(
          Icons.repeat,
          size: 20,
          color: Colors.amber,
        );
        break;
      case 2:
        statusString = "Delivering";
        statusIcon = Icon(
          Icons.local_shipping,
          size: 20,
          color: Colors.orange,
        );
        break;
      case 3:
        statusString = "Complete";
        statusIcon = Icon(
          Icons.check_circle,
          size: 20,
          color: Colors.green,
        );
        break;
      case 4:
        statusString = "Cancelled";
        statusIcon = Icon(
          Icons.cancel,
          size: 20,
          color: Colors.red,
        );
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Status:', style: TEXT_STYLE_PRIMARY),
          Row(
            children: <Widget>[
              Text(
                '$statusString',
                style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 5,
              ),
              statusIcon
            ],
          )
        ],
      ),
    );
  }

  Widget buildCancel(OrderingModel orderingModel) {
    return orderingModel.status == 1
        ? FlatButton(
            onPressed: () async {
              LoadingDialog.showConfirm(context,
                  text: 'Do you wanna cancel this order?', onYes: () async {
                LoadingDialog.showLoadingDialog(context,
                    text: 'Cancelling order...');
                await bloc.cancelOrdering(orderingModel.id);
                LoadingDialog.hideLoadingDialog(context);
                bloc.add(GetOrdering(orderingModel.id));
              }, onNo: () {});
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: PRIMARY_COLOR, width: 2)),
            child: Text(
              'Cancel order',
              style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
            ))
        : Container();
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
                  style:
                      TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }

  Widget buildShopUsername(OrderingModel orderingModel) {
    return CustomOnTapWidget(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (b) =>
                    ShopAccountDetailPage(orderingModel.shopUsername)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.store,
              size: 20,
              color: PRIMARY_TEXT_COLOR,
            ),
            SizedBox(
              width: 5,
            ),
            Text(orderingModel.shopUsername, style: TEXT_STYLE_PRIMARY),
          ],
        ),
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (b) => ProductDetailPage(product)));
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
          cubit: deliveryAddressBloc,
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
                            Expanded(
                                flex: 1,
                                child:
                                    Text('Name:', style: TEXT_STYLE_PRIMARY)),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                state.deliveryAddress.fullname,
                                textAlign: TextAlign.right,
                                style: TEXT_STYLE_PRIMARY.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
                                    fontWeight: FontWeight.bold, fontSize: 14),
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
                                child:
                                    Text('Phone:', style: TEXT_STYLE_PRIMARY)),
                            Expanded(
                              flex: 2,
                              child: Text(
                                state.deliveryAddress.phoneNumber,
                                textAlign: TextAlign.right,
                                style: TEXT_STYLE_PRIMARY.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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

  Future<OrderingModel> confirmCheckout(OrderingModel orderingModel) async {
    setState(() {});
    var isCheckOutOk =
        await CheckoutService().checkOut(orderingModel, status: 1);
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
