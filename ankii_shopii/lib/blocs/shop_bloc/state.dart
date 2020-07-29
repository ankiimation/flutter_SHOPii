import 'package:ankiishopii/models/shop_account_model.dart';
import 'package:equatable/equatable.dart';

class ShopAccountState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ShopAccountLoaded extends ShopAccountState {
  final ShopAccountModel shopAccountModel;

  ShopAccountLoaded(this.shopAccountModel);

  @override
  // TODO: implement props
  List<Object> get props => [shopAccountModel];
}

class ShopAccountLoading extends ShopAccountState {}

class ShopAccountError extends ShopAccountState {}
