import 'package:ankiishopii/models/account_model.dart';

class LoginModel {
  AccountModel account;
  String role;
  String token;

  LoginModel({this.account, this.role, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    account =
    json['account'] != null ? new AccountModel.fromJson(json['account']) : null;
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    data['role'] = this.role;
    data['token'] = this.token;
    return data;
  }
}