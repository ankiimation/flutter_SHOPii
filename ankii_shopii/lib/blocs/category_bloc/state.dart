import 'package:ankiishopii/models/category_model.dart';
import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoriesLoaded(this.categories);

  @override
  // TODO: implement props
  List<Object> get props => [categories];
}

class CategoriesLoading extends CategoryState {}

class CategoriesLoadingError extends CategoryState {
  final String error;

  CategoriesLoadingError(this.error);
  @override
  // TODO: implement props
  List<Object> get props => [error];
}
