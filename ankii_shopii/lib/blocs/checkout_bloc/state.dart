import 'package:ankiishopii/models/ordering_model.dart';
import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CheckoutLoaded extends CheckoutState {
  final OrderingModel checkoutModel;

  CheckoutLoaded(this.checkoutModel);

  @override
  // TODO: implement props
  List<Object> get props => [checkoutModel];
}

class DoCheckoutSuccessfully extends CheckoutState {}

class DoCheckoutLoading extends CheckoutState {}

class DoCheckoutFailed extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoadError extends CheckoutState {}

class CheckoutFailed extends CheckoutState {}
