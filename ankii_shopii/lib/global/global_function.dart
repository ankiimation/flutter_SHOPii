import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/cart_bloc/service.dart';
import 'package:ankiishopii/blocs/login_bloc/bloc.dart';
import 'package:ankiishopii/blocs/login_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/add_to_cart_effect.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

addToCart(BuildContext context, {@required int productID, int count = 1}) async {
//  BlocProvider.of<CartBloc>(context).add(AddToCart(productID: productID, count: count));
  LoadingDialog.showLoadingDialog(context);

//  await Future.delayed(Duration(milliseconds: 2000));
  await CartService().addToCart(productID, count);

  LoadingDialog.hideLoadingDialog(context);
//
  refreshCart(context);
}

refreshCart(BuildContext context) async {
  BlocProvider.of<CartBloc>(context).add(LoadCart());
}

refreshLogin(BuildContext context) async {
  BlocProvider.of<LoginBloc>(context).add(GetCurrentLogin());
}

countOrderTotal(OrderingModel orderingModel) {
  var total = 0;
  for (var orderDetail in orderingModel.orderingDetail) {
    total += orderDetail.count * orderDetail.product.price;
  }
  return total;
}

String getOrderStatus(OrderingModel orderingModel) {
  var statusCode = orderingModel.status;
  switch (statusCode) {
    case 1:
      return "Processing";
      break;
    case 2:
      return "Delivering";
      break;
    case 3:
      return "Complete";
      break;
    case 4:
      return "Cancelled";
      break;
    default:
      return "Unknown";
  }
}

showAddToCartAnimation(BuildContext context,
    {@required CustomPosition start, @required CustomPosition end, Widget overlayWidget, Duration duration}) async {
  showGeneralDialog(
      transitionDuration: Duration(milliseconds: 100),
      barrierDismissible: false,
      context: context,
      pageBuilder: (_, aniOne, aniTwo) {
        return AddToCartAnimationOverlay(
          overlayWidget: overlayWidget,
          start: start,
          end: end,
        );
//
      });
  await Future.delayed(duration ?? Duration(milliseconds: 500));
  Navigator.pop(context);
}

double cartIconPositionDx = 0;
double cartIconPositionDy = 0;

updateCartIconPosition({GlobalKey<CartWidgetState> cartIconKey, Duration duration}) {
  if (cartIconKey != null) {
    try {
      cartIconKey.currentState.onAddToCart(duration: duration);
      final RenderBox box = cartIconKey.currentContext.findRenderObject();
      final Offset position = box.globalToLocal(Offset.zero);
      var dx = position.dx * -1;
      var dy = position.dy * -1;
      // print(dx.toString() + "_" + dy.toString());
      cartIconPositionDx = dx;
      cartIconPositionDy = dy;
    } catch (e) {}
  } else {
    cartIconPositionDy = -50;
  }
}
