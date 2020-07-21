import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';

class OrderingService extends BlocService<OrderingModel> {
  @override
  Future<OrderingModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get(ORDERING_ENDPOINT, bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      return OrderingModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<List<OrderingModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll
    var rs = await HttpHelper.get(ORDERING_ENDPOINT, bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var jsonArray = jsonDecode(rs.body) as List;
      return jsonArray.map((json) => OrderingModel.fromJson(json)).toList();
    }
    return null;
  }
}
