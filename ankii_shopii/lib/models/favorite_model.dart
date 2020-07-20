import 'package:ankiishopii/models/product_model.dart';

class FavoriteModel {
  int id;
  String username;
  int productId;
  ProductModel product;
  bool isfavorite;

  FavoriteModel({this.id, this.username, this.productId,this.isfavorite,this.product});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    productId = json['productId'];
    product =
    json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
    isfavorite = json['isfavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['productId'] = this.productId;
    data['isfavorite'] = this.isfavorite;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}
