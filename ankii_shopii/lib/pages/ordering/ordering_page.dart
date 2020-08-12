import 'package:ankiishopii/blocs/ordering_bloc/bloc.dart';
import 'package:ankiishopii/blocs/ordering_bloc/event.dart';
import 'package:ankiishopii/blocs/ordering_bloc/state.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/ordering/ordering_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/notification_item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderingPage extends StatefulWidget {
  static const routeName = "orderingPage";
  final ScrollController scrollController;

  OrderingPage(this.scrollController);

  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  OrderingBloc bloc = OrderingBloc(AllOrderingLoading());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(GetAllOrdering());
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
      body: Column(
        children: <Widget>[
          InPageAppBar(
            title: 'Orders',
          ),
          BlocBuilder(
              cubit: bloc,
              builder: (context, state) {
                if (state is AllOrderingLoaded) {
                  return Expanded(
                      child: buildOrdersWithFilter(state.orderings));
                } else if (state is AllOrderingLoadError) {
                  return Center(
                    child: CustomErrorWidget(
                      error: state.error,
                    ),
                  );
                } else {
                  return Center(
                    child: CustomDotLoading(),
                  );
                }
              }),
        ],
      ),
    );
  }

//  Widget buildOrders(List<OrderingModel> orders) {
//    orders = orders.reversed.toList();
//    return Container(
//      margin: EdgeInsets.only(left: 20, right: 20),
//      child: Column(
//        children: orders.map((o) {
//          return CustomOnTapWidget(
//            onTap: () async {
//              await Navigator.push(context,
//                  MaterialPageRoute(builder: (b) => OrderingDetailPage(o)));
//            },
//            child: Container(
//              width: double.maxFinite,
//              margin: EdgeInsets.only(
//                  top: orders.indexOf(o) == 0 ? 10 : 0, bottom: 10),
//              child: CustomOrderItem(
//                elevation: 10,
//                orderingModel: o,
//              ),
//            ),
//          );
//        }).toList(),
//      ),
//    );
//  }

  Widget buildOrdersWithFilter(List<OrderingModel> orders) {
    orders = orders.reversed.toList();
    var orderStatusList =
        orders.map<int>((order) => order.status).toSet().toList()
          ..sort((int a, int b) {
            return a.compareTo(b);
          });
    return Container(
      child: CustomTabView(
          alwaysShowLabel: true,
//          barShadow: true,
          children: [
            CustomTabViewItem(
                icon: Icons.list,
                label: 'All',
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: widget.scrollController,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 100),
                    child: Column(
                      children: orders
                          .map<Widget>((o) => Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: CustomOrderItem(
                                  elevation: 10,
                                  orderingModel: o,
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (b) =>
                                                OrderingDetailPage(o)));
                                    bloc.add(GetAllOrdering());
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ))
          ]..addAll(orderStatusList.map<CustomTabViewItem>((status) {
              String label = status == 1
                  ? 'Processing'
                  : status == 2
                      ? 'Delivering'
                      : status == 3 ? 'Completed' : "Cancelled";
              IconData icon = status == 1
                  ? Icons.repeat
                  : status == 2
                      ? Icons.local_shipping
                      : status == 3 ? Icons.check_circle : Icons.cancel;
              Color color = status == 1
                  ? Color(0xffFFCC2E)
                  : status == 2
                      ? Colors.orange
                      : status == 3 ? Colors.green : Colors.red;
              return CustomTabViewItem(
                  icon: icon,
                  label: label,
                  color: color,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: widget.scrollController,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 100),
                      child: Column(
                        children: orders
                            .where((o) => o.status == status)
                            .map<Widget>((o) => Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: CustomOrderItem(
                                    elevation: 10,
                                    orderingModel: o,
                                    onTap: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (b) =>
                                                  OrderingDetailPage(o)));
                                      bloc.add(GetAllOrdering());
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ));
            }).toList())),
    );
  }
}
