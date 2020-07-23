import 'package:ankiishopii/models/account_model.dart';
import 'package:equatable/equatable.dart';

class DeliveryAddressState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AllDeliveryAddressesLoaded extends DeliveryAddressState {
  final List<DeliveryAddressModel> deliveryAddresses;

  AllDeliveryAddressesLoaded(this.deliveryAddresses);

  @override
  // TODO: implement props
  List<Object> get props => [deliveryAddresses];
}

class DeliveryAddressLoaded extends DeliveryAddressState {
  final DeliveryAddressModel deliveryAddress;

  DeliveryAddressLoaded(this.deliveryAddress);

  @override
  // TODO: implement props
  List<Object> get props => [deliveryAddress];
}

class DeliveryAddressLoading extends DeliveryAddressState {}

class DeliveryAddressLoadFailed extends DeliveryAddressState {}
