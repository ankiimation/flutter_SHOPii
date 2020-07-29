import 'package:equatable/equatable.dart';

class ShopAccountEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class GetShopAccount extends ShopAccountEvent{
  final String username;

  GetShopAccount(this.username);
  @override
  // TODO: implement props
  List<Object> get props => [username];
}