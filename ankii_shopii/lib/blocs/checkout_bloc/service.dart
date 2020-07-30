import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';

class CheckoutService extends BlocService<OrderingModel> {
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
      return jsonArray.map((j) => OrderingModel.fromJson(j)).toList();
    }
    return null;
  }

//  Future<List<OrderingModel>> getCheckOut(List<OrderingModel> orderingModels) async {
//    var rs = await HttpHelper.get(ORDERING_ENDPOINT, bearerToken: currentLogin.token);
//    if (rs.statusCode == 200) {
//      var jsonArray = jsonDecode(rs.body) as List;
//      return jsonArray
//          .map<OrderingModel>((j) => OrderingModel.fromJson(j))
//          .where((orderingModel) => orderingModel.status == 0)
//          .toList();
//    }
//    return null;
//  }

  Future<OrderingModel> checkOut(OrderingModel orderingModel, {int status, int deliveryId}) async {
    var rs = await HttpHelper.post(
        CHECKOUT_ENDPOINT,
        {
          "orderingId": orderingModel.id,
          "deliveryId": deliveryId ?? orderingModel.deliveryId,
          "status": status ?? orderingModel.status
        },
        bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      return OrderingModel.fromJson(json);
    }
    return null;
  }
}
