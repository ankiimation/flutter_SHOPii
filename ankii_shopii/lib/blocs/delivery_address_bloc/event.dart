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
