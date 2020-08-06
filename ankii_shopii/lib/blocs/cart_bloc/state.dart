import 'package:ankiishopii/models/ordering_model.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CartLoaded extends CartState {
  List<OrderingModel> cart;

  CartLoaded(List<OrderingModel> cart) {
    List<OrderingModel> cartTemp = [];
    for (var ordering in cart) {
      if (!_isEmpty(ordering)) {
        ordering.orderingDetail = ordering.orderingDetail.where((od) => od.count > 0).toList();
        cartTemp.add(ordering);
      }
    }
    this.cart = cartTemp;
  }

  @override
  // TODO: implement props
  List<Object> get props => [cart];

  bool _isEmpty(OrderingModel orderingModel) {
    int totalQuantity = 0;
    for (var item in orderingModel.orderingDetail) {
      totalQuantity += item.count;
    }
    if (totalQuantity > 0) return false;
    return true;
  }
}

class CartError extends CartState {}

class CartLoading extends CartState {}
