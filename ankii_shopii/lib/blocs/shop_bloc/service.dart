import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/shop_account_model.dart';

class ShopAccountService extends BlocService<ShopAccountModel> {
  @override
  Future<ShopAccountModel> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<ShopAccountModel>> getAll({int from = 0, int limit}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  Future<ShopAccountModel> getShopAccount(String username) async {
    var rs = await HttpHelper.get(SHOP_ACCOUNT_ENDPOINT + "/$username");
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      return ShopAccountModel.fromJson(json);
    }
    return null;
  }
}
