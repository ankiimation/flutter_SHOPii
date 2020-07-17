class ProductModel {
  int id;
  String name;
  String description;
  String image;
  int price;
  int categoryId;
  List<ProductImageModel> productImage;

  ProductModel({this.id, this.name, this.description, this.image, this.price, this.categoryId, this.productImage});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    categoryId = json['categoryId'];
    if (json['productImage'] != null) {
      productImage = new List<ProductImageModel>();
      json['productImage'].forEach((v) {
        productImage.add(new ProductImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['categoryId'] = this.categoryId;
    if (this.productImage != null) {
      data['productImage'] = this.productImage.map((v) => v.toJson()).toList();
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
