import 'package:equatable/equatable.dart';

class FavoriteEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class GetCurrentFavoriteFromProductId extends FavoriteEvent{
  final int productID;

  GetCurrentFavoriteFromProductId(this.productID);
  @override
  // TODO: implement props
  List<Object> get props => [productID];
}