import 'package:ankiishopii/blocs/checkout_bloc/event.dart';
import 'package:ankiishopii/blocs/checkout_bloc/service.dart';
import 'package:ankiishopii/blocs/checkout_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutLoading());

  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetCheckout) {
      yield* mapGetCheckoutToState(event);
    }
    if (event is DoCheckout) {
      yield* mapDoCheckoutToState(event);
    }
  }

  Stream<CheckoutState> mapGetCheckoutToState(GetCheckout event) async* {
    var rs = await CheckoutService().get(event.orderingModel.id);
    if (rs != null) {
      rs.orderingDetail = rs.orderingDetail.where((od) => od.count > 0).toList();
      yield CheckoutLoaded(rs);
    } else {
      yield CheckoutLoadError();
    }
  }

  Stream<CheckoutState> mapDoCheckoutToState(DoCheckout event) async* {
    var rs = await CheckoutService().checkOut(event.orderingModel, status: event.status, deliveryId: event.deliveryId);
    if (rs != null) {
      rs.orderingDetail = rs.orderingDetail.where((od) => od.count > 0).toList();
      yield DoCheckoutSuccessfully();
    } else {
      yield DoCheckoutFailed();
    }
  }
}
