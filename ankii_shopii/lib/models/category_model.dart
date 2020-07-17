import 'package:ankiishopii/models/product_model.dart';

class CategoryModel {
  int id;
  String name;
  String description;
  String image;
  List<ProductModel> product;

  CategoryModel({this.id, this.name, this.description, this.image, this.product});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    if (json['product'] != null) {
      product = new List<ProductModel>();
      json['product'].forEach((v) {
        product.add(new ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.product != null) {
      data['product'] = this.product.map((v) => v.toJson()).toList();
    }
    return data;
  }
}