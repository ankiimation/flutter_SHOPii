import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';

class OrderingService extends BlocService<OrderingModel> {
  @override
  Future<OrderingModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get('$ORDERING_ENDPOINT/$id', bearerToken: currentLogin.token);
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
      var orderings = jsonArray.map((json) => OrderingModel.fromJson(json)).toList();
      orderings = orderings.where((o) => o.status != 0).toList();
      for (var order in orderings) {
        var ods = order.orderingDetail;
        for (var od in ods) {
          if (od.product == null) {
            od.product = await ProductService().get(od.productId);
          }
        }
      }
      return orderings;
    }
    return null;
  }

  Future<OrderingModel> cancelOrdering(int orderingId) async {
    var rs = await HttpHelper.post(ORDERING_ENDPOINT + "/cancel", {"orderingId": orderingId},
        bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      return OrderingModel.fromJson(json);
    }
    return null;
  }
}
