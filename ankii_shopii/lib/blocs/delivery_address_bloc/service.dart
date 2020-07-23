import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/account_model.dart';

class DeliveryAddressService extends BlocService<DeliveryAddressModel> {
  @override
  Future<DeliveryAddressModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get('$DELIVERY_ADDRESS_ENDPOINT/$id', bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      return DeliveryAddressModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<List<DeliveryAddressModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll
    var rs = await HttpHelper.get(DELIVERY_ADDRESS_ENDPOINT, bearerToken: currentLogin.token);
    if (rs.statusCode == 200) {
      var jsonArray = jsonDecode(rs.body) as List;
      return jsonArray.map((j) => DeliveryAddressModel.fromJson(j)).toList();
    }
    return null;
  }
}
