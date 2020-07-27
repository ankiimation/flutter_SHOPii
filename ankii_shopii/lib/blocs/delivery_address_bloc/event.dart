import 'package:ankiishopii/models/account_model.dart';
import 'package:equatable/equatable.dart';

class DeliveryAddressEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetAllDeliveryAddresses extends DeliveryAddressEvent {}

class GetDeliveryAddress extends DeliveryAddressEvent {
  final int id;

  GetDeliveryAddress(this.id);

  @override
  // TODO: implement props

  List<Object> get props => [id];
}

class SetDefaultDeliveryAddress extends DeliveryAddressEvent {
  final int id;

  SetDefaultDeliveryAddress(this.id);

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class AddDeliveryAddress extends DeliveryAddressEvent {
  final DeliveryAddressModel deliveryAddressModel;

  AddDeliveryAddress(this.deliveryAddressModel);

  @override
  // TODO: implement props
  List<Object> get props => [deliveryAddressModel];
}
