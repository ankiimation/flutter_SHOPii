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

  Future<DeliveryAddressModel> addDeliveryAddress(DeliveryAddressModel deliveryAddressModel) async {
    var rs = await HttpHelper.post(
        DELIVERY_ADDRESS_ENDPOINT,
        {
          "fullname": deliveryAddressModel.fullname,
          "address": deliveryAddressModel.address,
          "phoneNumber": deliveryAddressModel.phoneNumber,
          "latitude": deliveryAddressModel.latitude,
          "longitude": deliveryAddressModel.longitude
        },
        bearerToken: currentLogin.token);
     print(rs.body);
    if (rs.statusCode == 200) {
      var jsonObject = jsonDecode(rs.body);
      return DeliveryAddressModel.fromJson(jsonObject);
    }
    return null;
  }
}
