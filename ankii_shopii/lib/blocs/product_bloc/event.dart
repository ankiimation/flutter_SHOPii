import 'package:ankiishopii/models/product_model.dart';
import 'package:equatable/equatable.dart';

class ProductEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetAllProducts extends ProductEvent {}

class GetAllProductsByCategoryId extends ProductEvent {
  final int categoryID;

  GetAllProductsByCategoryId(this.categoryID);
}


class GetProductsForYou extends ProductEvent{}

class GetProductById extends ProductEvent {
  final int productID;

  GetProductById(this.productID);
}

class SearchProduct extends ProductEvent{
  final String keyword;

  SearchProduct(this.keyword);
}

class DoFavorite extends ProductEvent {
  final ProductModel product;
  final bool isDoFromListProducts;

  DoFavorite(this.product, {this.isDoFromListProducts = true});
}
