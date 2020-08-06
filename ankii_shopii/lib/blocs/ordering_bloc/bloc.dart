import 'package:ankiishopii/blocs/checkout_bloc/service.dart';
import 'package:ankiishopii/blocs/ordering_bloc/event.dart';
import 'package:ankiishopii/blocs/ordering_bloc/service.dart';
import 'package:ankiishopii/blocs/ordering_bloc/state.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderingBloc extends Bloc<OrderingEvent, OrderingState> {
  OrderingBloc(OrderingState initialState) : super(initialState);

  @override
  Stream<OrderingState> mapEventToState(OrderingEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetOrdering) {
      yield* mapGetOrderingToState(event);
    } else if (event is GetAllOrdering) {
      yield* mapGetAllOrderingToState(event);
    }
  }

  Stream<OrderingState> mapGetOrderingToState(GetOrdering event) async* {
    var rs = await OrderingService().get(event.id);
    if (rs != null) {
      rs.orderingDetail = rs.orderingDetail.where((od) => od.count > 0).toList();
      yield OrderingLoaded(rs);
    } else {
      yield OrderingLoadError();
    }
  }

  Stream<OrderingState> mapGetAllOrderingToState(GetAllOrdering event) async* {
    try {
      var rs = await OrderingService().getAll();
      if (rs != null) {
        yield AllOrderingLoaded(rs);
      } else {
        yield AllOrderingLoadError('Null');
      }
    } catch (e) {
      yield AllOrderingLoadError('Not Logged In');
    }
  }

  cancelOrdering(int orderingId) async {
    await OrderingService().cancelOrdering(orderingId);
  }
}
