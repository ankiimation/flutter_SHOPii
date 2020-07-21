import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CartEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final int productID;
  final int count;

  AddToCart({@required this.productID, this.count = 1});

  @override
  // TODO: implement props
  List<Object> get props => [productID, count];
}
