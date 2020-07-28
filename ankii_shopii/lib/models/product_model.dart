import 'package:ankiishopii/models/category_model.dart';

import 'favorite_model.dart';

class ProductModel {
  int id;
  String name;
  String description;
  String image;
  int price;
  int categoryId;
  String shopUsername;
  CategoryModel category;
  List<ProductImageModel> productImage;
  List<FavoriteModel> favorite;
  bool isFavoriteByCurrentUser = false;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.categoryId,
      this.productImage,
      this.favorite,
      this.shopUsername,
      this.category});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    shopUsername = json['shopUsername'];
    categoryId = json['categoryId'];
    if (json['productImage'] != null) {
      productImage = new List<ProductImageModel>();
      json['productImage'].forEach((v) {
        productImage.add(new ProductImageModel.fromJson(v));
      });
    }
    if (json['favorite'] != null) {
      favorite = new List<FavoriteModel>();
      json['favorite'].forEach((v) {
        favorite.add(new FavoriteModel.fromJson(v));
      });
    }
    category = json['category'] != null ? new CategoryModel.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['shopUsername'] = this.shopUsername;
    data['categoryId'] = this.categoryId;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.productImage != null) {
      data['productImage'] = this.productImage.map((v) => v.toJson()).toList();
    }
    if (this.favorite != null) {
      data['favorite'] = this.favorite.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductImageModel {
  int id;
  int productId;
  String image;

  ProductImageModel({this.id, this.productId, this.image});

  ProductImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['image'] = this.image;
    return data;
  }
}
