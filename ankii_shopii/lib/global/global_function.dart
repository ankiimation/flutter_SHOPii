import 'package:ankiishopii/blocs/cart_bloc/bloc.dart';
import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/login_bloc/bloc.dart';
import 'package:ankiishopii/blocs/login_bloc/event.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/add_to_cart_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

addToCart(BuildContext context, {@required int productID, int count = 1}) async {
  BlocProvider.of<CartBloc>(context).add(AddToCart(productID: productID, count: count));
}

refreshCart(BuildContext context) async {
  BlocProvider.of<CartBloc>(context).add(LoadCart());
}

refeshLogin(BuildContext context) async {
  BlocProvider.of<LoginBloc>(context).add(GetCurrentLogin());
}

showAddToCartAnimation(BuildContext context,
    {@required CustomPosition start, @required CustomPosition end, Widget overlayWidget}) async {
  showGeneralDialog(
      transitionDuration: Duration(milliseconds: 100),
      barrierDismissible: false,
      context: context,
      pageBuilder: (_, aniOne, aniTwo) {
        return AddToCartAnimationOverlayTest(
          overlayWidget: overlayWidget,
          start: start,
          end: end,
        );
        return AddToCartAnimationOverlay(
          start: CustomPosition(ScreenHelper.getWidth(context) - 100, ScreenHelper.getPaddingTop(context) + 100),
          end: CustomPosition(ScreenHelper.getWidth(context) - 50, ScreenHelper.getPaddingTop(context)),
        );
      });
  await Future.delayed(Duration(milliseconds: 500));
  Navigator.pop(context);
}

double cartIconPositionDx = 0;
double cartIconPositionDy = 0;

updateCartIconPosition({GlobalKey cartIconKey}) {
  if (cartIconKey != null) {
    try {
      final RenderBox box = cartIconKey.currentContext.findRenderObject();
      final Offset position = box.globalToLocal(Offset.zero);
      var dx = position.dx * -1;
      var dy = position.dy * -1;
      print(dx.toString() + "_" + dy.toString());
      cartIconPositionDx = dx;
      cartIconPositionDy = dy;
    } catch (e) {}
  } else {
    cartIconPositionDy = -50;
  }
}
