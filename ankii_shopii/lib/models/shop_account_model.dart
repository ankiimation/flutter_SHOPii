class ShopAccountModel {
  String username;
  String password;
  String name;
  String address;
  String phoneNumber;
  String image;
  String coverImage;
  String latitude;
  String longitude;

  ShopAccountModel(
      {this.username, this.password, this.name, this.address, this.phoneNumber, this.image, this.coverImage});

  ShopAccountModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    image = json['image'];
    coverImage = json['coverImage'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['image'] = this.image;
    data['coverImage'] = this.coverImage;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
