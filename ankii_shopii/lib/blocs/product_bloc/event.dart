import 'package:equatable/equatable.dart';

class ProductEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetAllProducts extends ProductEvent {}

class GetAllProductsViaCategoryId extends ProductEvent {
  final int categoryID;
  GetAllProductsViaCategoryId(this.categoryID);
}
