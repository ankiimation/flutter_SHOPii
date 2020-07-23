import 'package:ankiishopii/blocs/delivery_address_bloc/event.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/service.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryAddressBloc extends Bloc<DeliveryAddressEvent, DeliveryAddressState> {
  DeliveryAddressBloc() : super(DeliveryAddressLoading());

  @override
  Stream<DeliveryAddressState> mapEventToState(DeliveryAddressEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetAllDeliveryAddresses) {
      yield* mapGetAllDeliveryAddressesToState(event);
    } else if (event is GetDeliveryAddress) {
      yield* mapGetDeliveryAddressToState(event);
    }
  }

  Stream<DeliveryAddressState> mapGetAllDeliveryAddressesToState(GetAllDeliveryAddresses event) async* {
    var rs = await DeliveryAddressService().getAll();
    if (rs != null) {
      yield AllDeliveryAddressesLoaded(rs);
    } else {
      yield DeliveryAddressLoadFailed();
    }
  }

  Stream<DeliveryAddressState> mapGetDeliveryAddressToState(GetDeliveryAddress event) async* {
    var rs = await DeliveryAddressService().get(event.id);
    if (rs != null) {
      yield DeliveryAddressLoaded(rs);
    } else {
      yield DeliveryAddressLoadFailed();
    }
  }
}
