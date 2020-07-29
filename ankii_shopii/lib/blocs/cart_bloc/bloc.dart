import 'dart:async';

import 'package:ankiishopii/blocs/cart_bloc/event.dart';
import 'package:ankiishopii/blocs/cart_bloc/service.dart';
import 'package:ankiishopii/blocs/cart_bloc/state.dart';
import 'package:ankiishopii/main.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Timer _cartChangingTimer;

onCartChange(Function onAddToCart) {
  if (_cartChangingTimer != null) _cartChangingTimer.cancel();
  _cartChangingTimer = Timer(Duration(seconds: 2), onAddToCart);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoadCart) {
      yield* mapLoadCartEventToState(event);
    } else if (event is AddToCart) {
      yield* mapAddToCartCartEventToState(event);
    }
  }

  Stream<CartState> mapLoadCartEventToState(LoadCart event) async* {
    var rs = await CartService().getCurrentCart();
    if (rs != null) {
      yield CartLoaded(rs);
    } else {
      yield CartError();
    }
  }

  Stream<CartState> mapAddToCartCartEventToState(AddToCart event) async* {
    await Future.delayed(Duration(seconds: 2));
    var rs = await CartService().addToCart(event.productID, event.count);
    var refreshCart = await CartService().getCurrentCart();
    if (rs != null) {
      yield CartLoaded(refreshCart);
    } else {
      yield CartError();
    }
  }
}
