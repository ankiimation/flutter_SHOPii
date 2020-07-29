import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';

class CartService extends BlocService<OrderingModel> {
  @override
  Future<OrderingModel> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<OrderingModel>> getAll({int from = 0, int limit}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  Future<List<OrderingModel>> getCurrentCart() async {
    var rs = await HttpHelper.get(CART_ENDPOINT, bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var jsonArray = jsonDecode(rs.body) as List;
      return jsonArray.map((json) => OrderingModel.fromJson(json)).toList();
    }
    return null;
  }

  Future<OrderingModel> addToCart(int productId, int count) async {
    var rs = await HttpHelper.post(ORDERING_ENDPOINT + "/cart", {"productID": productId, "count": count},
        bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      return OrderingModel.fromJson(json);
    }
    return null;
  }
}
