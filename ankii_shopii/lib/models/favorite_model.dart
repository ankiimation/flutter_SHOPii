class FavoriteModel {
  int id;
  String username;
  int productId;

  FavoriteModel({this.id, this.username, this.productId});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['productId'] = this.productId;
    return data;
  }
}
