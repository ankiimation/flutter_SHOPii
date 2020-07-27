import 'package:ankiishopii/models/ordering_model.dart';
import 'package:equatable/equatable.dart';

class OrderingState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OrderingLoaded extends OrderingState {
  final OrderingModel orderingModel;

  OrderingLoaded(this.orderingModel);

  @override
  // TODO: implement props
  List<Object> get props => [orderingModel];
}

class OrderingLoadError extends OrderingState{

}
class OrderingLoading extends OrderingState{

}


class AllOrderingLoaded extends OrderingState {
  final List<OrderingModel> orderings;

  AllOrderingLoaded(this.orderings);

  @override
  // TODO: implement props
  List<Object> get props => [orderings];
}

class AllOrderingLoadError extends OrderingState{
  final String error;

  AllOrderingLoadError(this.error);
  @override
  // TODO: implement props
  List<Object> get props => [error];
}
class AllOrderingLoading extends OrderingState{

}
