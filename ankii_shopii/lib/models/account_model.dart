import 'package:ankiishopii/models/favorite_model.dart';

class AccountModel {
  String username;
  String password;
  String phoneNumber;
  String fullname;
  String address;
  String image;
  int defaultDeliveryId;
  List<DeliveryAddressModel> deliveryAddress;
  List<FavoriteModel> favorite;

  AccountModel(
      {this.favorite,
      this.username,
      this.password,
      this.phoneNumber,
      this.fullname,
      this.address,
      this.image,
      this.deliveryAddress,
      this.defaultDeliveryId});

  AccountModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    fullname = json['fullname'];
    image = json['image'];
    defaultDeliveryId = json['defaultDeliveryId'];
    address = json['address'];
    if (json['deliveryAddress'] != null) {
      deliveryAddress = new List<DeliveryAddressModel>();
      json['deliveryAddress'].forEach((v) {
        deliveryAddress.add(new DeliveryAddressModel.fromJson(v));
      });
    }
    if (json['favorite'] != null) {
      favorite = new List<FavoriteModel>();
      json['favorite'].forEach((v) {
        favorite.add(new FavoriteModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;
    data['fullname'] = this.fullname;
    data['address'] = this.address;
    data['image'] = this.image;
    data['defaultDeliveryId'] = this.defaultDeliveryId;
    if (this.deliveryAddress != null) {
      data['deliveryAddress'] = this.deliveryAddress.map((v) => v.toJson()).toList();
    }
    if (this.favorite != null) {
      data['favorite'] = this.favorite.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryAddressModel {
  int id;
  String username;
  String phoneNumber;
  String fullname;
  String address;
  String latitude;
  String longitude;

  DeliveryAddressModel(
      {this.id, this.username, this.phoneNumber, this.fullname, this.address, this.latitude, this.longitude});

  DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    phoneNumber = json['phoneNumber'];
    fullname = json['fullname'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['phoneNumber'] = this.phoneNumber;
    data['fullname'] = this.fullname;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
