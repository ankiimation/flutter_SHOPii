import 'dart:convert';
import 'dart:io';
import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/category_model.dart';

class CategoryService extends BlocService<CategoryModel> {
  CategoryService._();

  static CategoryService _instance;

  factory CategoryService() {
    if (_instance == null) {
      _instance = CategoryService._();
    }
    return _instance;
  }

  @override
  Future<CategoryModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get(CATEGORY_ENDPOINT + "/$id");
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      // print(jsonList.toList());
      return CategoryModel.fromJson(json);
    }
    return null;
  }

  @override
  Future<List<CategoryModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll
    var rs = await HttpHelper.get(CATEGORY_ENDPOINT);
    if (rs.statusCode == 200) {
      var jsonList = jsonDecode(rs.body) as List;
      // print(jsonList.toList());
      return jsonList.map((j) => CategoryModel.fromJson(j)).toList();
    }
    return null;
  }
}
