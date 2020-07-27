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
import 'package:ankiishopii/widgets/notification_item.dart';
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: widget.scrollController,
        child: Column(
          children: <Widget>[
            InPageAppBar(
              title: 'Orders',
            ),
            BlocBuilder(
                cubit: bloc,
                builder: (context, state) {
                  if (state is AllOrderingLoaded) {
                    return buildOrders(state.orderings);
                  } else if (state is AllOrderingLoadError) {
                    return Center(
                      child: CustomErrorWidget(
                        error: state.error,
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget buildOrders(List<OrderingModel> orders) {
    orders = orders.reversed.toList();
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: orders.map((o) {
          return CustomOnTapWidget(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (b) => OrderingDetailPage(o)));
            },
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: orders.indexOf(o) == 0 ? 10 : 0, bottom: 10),
              child: CustomOrderItem(
                orderingModel: o,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
