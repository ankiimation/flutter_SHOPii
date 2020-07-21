import 'package:ankiishopii/models/ordering_model.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  final OrderingModel cart;

  CartLoaded(this.cart) {
    this.cart.orderingDetail = this.cart.orderingDetail.where((od) => od.count > 0).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [cart];
}

class CartError extends CartState {}

class CartLoading extends CartState {}
