import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/helpers/shared_preferences_helper.dart';
import 'package:ankiishopii/models/favorite_model.dart';
import 'package:flutter/material.dart';

class FavoriteService extends BlocService<FavoriteModel> {
  @override
  Future<FavoriteModel> get(int id) async {
    // TODO: implement get
    var rs = await HttpHelper.get(FAVORITE_ENDPOINT + '/$id', bearerToken: currentLogin.token);
    if (rs.statusCode == 200 || rs.statusCode == 201) {
      var jsonObject = jsonDecode(rs.body);
      var favorite = FavoriteModel.fromJson(jsonObject);
      _updateCurrentAccountFavorite(favorite);
      return favorite;
    }
    return null;
  }

  @override
  Future<List<FavoriteModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll
    var rs = await HttpHelper.get(FAVORITE_ENDPOINT, bearerToken: currentLogin.token);
    if (rs.statusCode == 200 || rs.statusCode == 201) {
      var jsonArray = jsonDecode(rs.body) as List;
      var favorites = jsonArray.map((json) => FavoriteModel.fromJson(json)).toList();
      await _updateCurrentAccountFavorites(favorites);
      return favorites;
    }
    return null;
  }

  Future _updateCurrentAccountFavorites(List<FavoriteModel> favorites) async {
    currentLogin.account.favorite = favorites;
    await LocalHelper.saveAccountToLocal(currentLogin);
  }

  Future _updateCurrentAccountFavorite(FavoriteModel favorite) async {
    var currentFavorite =
        currentLogin.account.favorite.firstWhere((favoriteTemp) => favoriteTemp.id == favorite.id, orElse: () => null);
    if (currentFavorite != null) {
      currentLogin.account.favorite.remove(currentFavorite);
    }
    currentLogin.account.favorite.add(favorite);
    await LocalHelper.saveAccountToLocal(currentLogin);
  }

  Future<FavoriteModel> doFavorite({@required int productID}) async {
    var rs = await HttpHelper.post(FAVORITE_ENDPOINT, {'productID': productID}, bearerToken: currentLogin.token);
    if (rs.statusCode == 200 || rs.statusCode == 201) {
      //  print(rs.body);
      var jsonObject = jsonDecode(rs.body);
      var favorite = FavoriteModel.fromJson(jsonObject);
      await _updateCurrentAccountFavorite(favorite);
      return favorite;
    }
    return null;
  }

  FavoriteModel getFavoriteFromLocalByProductId(int productID) {
    // print(currentLogin.account.favorite.map((e) => e.productId).toList());
    if (currentLogin == null) {
      return null;
    }
    return currentLogin.account.favorite.firstWhere((favorite) => favorite.productId == productID, orElse: () => null);
  }
}
