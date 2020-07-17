import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/product_model.dart';

class ProductService extends BlocService<ProductModel> {
  @override
  Future<ProductModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get(PRODUCT_ENDPOINT + "/$id");
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      // print(jsonList.toList());
      return ProductModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<List<ProductModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll

    var rs = await HttpHelper.get(PRODUCT_ENDPOINT + '?${getQueryString({'from': from, 'limit': limit})}');
    if (rs.statusCode == 200) {
      var jsonList = jsonDecode(rs.body) as List;
      // print(jsonList.toList());
      return jsonList.map((j) => ProductModel.fromJson(j)).toList();
    }
    return null;
  }

  Future<List<ProductModel>> getAllWithCategoryId(int categoryID, {int from = 0, int limit}) async {
    // TODO: implement getAll
    var rs = await HttpHelper.get(
        PRODUCT_ENDPOINT + "?categoryID=$categoryID" + '&${getQueryString({'from': from, 'limit': limit})}');
    if (rs.statusCode == 200) {
      var jsonList = jsonDecode(rs.body) as List;
      // print(jsonList.toList());
      return jsonList.map((j) => ProductModel.fromJson(j)).toList();
    }
    return null;
  }
}
