import 'package:equatable/equatable.dart';

class OrderingEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetAllOrdering extends OrderingEvent{}
class GetOrdering extends OrderingEvent {
  final int id;

  GetOrdering(this.id);

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
