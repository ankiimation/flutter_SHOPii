import 'dart:convert';
import 'dart:math';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/blocs/favorite_bloc/service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/models/favorite_model.dart';
import 'package:ankiishopii/models/product_model.dart';

class ProductService extends BlocService<ProductModel> {
  @override
  Future<ProductModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get(PRODUCT_ENDPOINT + "/$id");
    if (rs.statusCode == 200) {
      var json = jsonDecode(rs.body);
      // print(jsonList.toList());
      var product = ProductModel.fromJson(json);
      product = _checkIsFavoriteByCurrentUser(product);
      return product;
    }
    return null;
  }

  @override
  Future<List<ProductModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll

    var rs = await HttpHelper.get(PRODUCT_ENDPOINT +
        '?${getQueryString({'from': from, 'limit': limit})}');
    if (rs.statusCode == 200) {
      var jsonList = jsonDecode(rs.body) as List;
      // print(jsonList.toList());
      var products = jsonList.map((j) => ProductModel.fromJson(j)).toList();
      for (var product in products) {
        product = _checkIsFavoriteByCurrentUser(product);
      }
      return products;
    }
    return null;
  }

  ProductModel _checkIsFavoriteByCurrentUser(ProductModel product) {
    var favorite =
        FavoriteService().getFavoriteFromLocalByProductId(product.id);
    if (favorite != null) {
      product.isFavoriteByCurrentUser = favorite.isfavorite;
    }
    return product;
  }

  ProductModel _checkIsFavoriteByFavoriteModel(
      {ProductModel productModel, FavoriteModel favoriteModel}) {
    if (favoriteModel != null) {
      productModel.isFavoriteByCurrentUser = favoriteModel.isfavorite;
    }
    return productModel;
  }

  Future<ProductModel> doFavorite(ProductModel productModel) async {
    var favorite =
        await FavoriteService().doFavorite(productID: productModel.id);
    var rs = _checkIsFavoriteByFavoriteModel(
        productModel: productModel, favoriteModel: favorite);
    // print(jsonEncode(rs.isFavoriteByCurrentUser));
    return rs;
  }

  Future<List<ProductModel>> getAllWithCategoryId(int categoryID,
      {int from = 0, int limit}) async {
    // TODO: implement getAll
    var rs = await HttpHelper.get(PRODUCT_ENDPOINT +
        "?categoryID=$categoryID" +
        '&${getQueryString({'from': from, 'limit': limit})}');
    if (rs.statusCode == 200) {
      var jsonList = jsonDecode(rs.body) as List;
      // print(jsonList.toList());
      var products = jsonList.map((j) => ProductModel.fromJson(j)).toList();
      for (var product in products) {
        product = _checkIsFavoriteByCurrentUser(product);
      }
      return products;
    }
    return null;
  }

  Future<List<ProductModel>> getProductsForYou() async {
    if (currentLogin != null) {
      var rs = await HttpHelper.get(PRODUCT_ENDPOINT + "/foryou",
          bearerToken: currentLogin.token);
      if (rs.statusCode == 200) {
        var jsonList = jsonDecode(rs.body) as List;
        var products = jsonList.map((j) => ProductModel.fromJson(j)).toList();
        for (var product in products) {
          product = _checkIsFavoriteByCurrentUser(product);
        }
        return products;
      }
      return null;
    }
    return getAll(limit: 10, from: Random().nextInt(10));
  }

  Future<List<ProductModel>> searchProduct(String keyword,
      {int limit, int from = 0}) async {
    if (currentLogin != null) {
      var rs = await HttpHelper.post(
          PRODUCT_ENDPOINT +
              "/search?${getQueryString({
                'keyword': keyword,
                'from': from,
                'limit': limit
              })}",
          {},
          bearerToken: currentLogin.token);
      if (rs.statusCode == 200) {
        var jsonList = jsonDecode(rs.body) as List;
        var products = jsonList.map((j) => ProductModel.fromJson(j)).toList();
        for (var product in products) {
          product = _checkIsFavoriteByCurrentUser(product);
        }
        return products;
      }
      return null;
    }
    return getAll(limit: 10, from: Random().nextInt(10));
  }
}
