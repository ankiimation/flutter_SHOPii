import 'package:ankiishopii/models/product_model.dart';
import 'package:equatable/equatable.dart';

class ProductState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ListProductsLoaded extends ProductState {
  final List<ProductModel> products;

  ListProductsLoaded(this.products);
  @override
  // TODO: implement props
  List<Object> get props => [products];
}

class ProductLoaded extends ProductState{
  final ProductModel product;

  ProductLoaded(this.product);
  @override
  // TODO: implement props
  List<Object> get props => [product];
}

class ProductLoadingError extends ProductState {}

class ProductLoading extends ProductState {}
