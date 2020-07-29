import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/product_model.dart';

class OrderingModel {
  int id;
  int deliveryId;
  int status;
  String username;
  String shopUsername;
  DeliveryAddressModel delivery;
  String createdDate;
  List<OrderingDetailModel> orderingDetail;

  OrderingModel(
      {this.id,
      this.deliveryId,
      this.status,
      this.delivery,
      this.orderingDetail,
      this.shopUsername,
      this.username,
      this.createdDate});

  OrderingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryId = json['deliveryId'];
    status = json['status'];
    username = json['username'];
    shopUsername = json['shopUsername'];
    createdDate = json['createdDate'];
    delivery = json['delivery'] != null ? new DeliveryAddressModel.fromJson(json['delivery']) : null;
    if (json['orderingDetail'] != null) {
      orderingDetail = new List<OrderingDetailModel>();
      json['orderingDetail'].forEach((v) {
        orderingDetail.add(new OrderingDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deliveryId'] = this.deliveryId;
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    data['username'] = this.username;
    data['shopUsername'] = this.shopUsername;
    if (this.delivery != null) {
      data['delivery'] = this.delivery.toJson();
    }
    if (this.orderingDetail != null) {
      data['orderingDetail'] = this.orderingDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderingDetailModel {
  int id;
  int orderingId;
  int productId;
  int count;
  ProductModel product;

  OrderingDetailModel({this.id, this.orderingId, this.productId, this.product, this.count = 0});

  OrderingDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderingId = json['orderingId'];
    productId = json['productId'];
    count = json['count'];
    product = json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderingId'] = this.orderingId;
    data['productId'] = this.productId;
    data['count'] = this.count;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}
