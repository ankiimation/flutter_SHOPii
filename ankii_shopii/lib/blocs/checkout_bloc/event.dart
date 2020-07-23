import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CheckoutEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class GetCheckout extends CheckoutEvent{
  final OrderingModel orderingModel;

  GetCheckout(this.orderingModel);
  @override
  // TODO: implement props
  List<Object> get props => [orderingModel];
}
class DoCheckout extends CheckoutEvent {
  final OrderingModel orderingModel;
  final int status;
  final int deliveryId;

  DoCheckout({@required this.orderingModel, this.status = 0, this.deliveryId = -1});

  @override
  // TODO: implement props
  List<Object> get props => [orderingModel, status, deliveryId];
}
