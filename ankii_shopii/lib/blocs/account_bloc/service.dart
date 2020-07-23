import 'dart:convert';

import 'package:ankiishopii/blocs/bloc_service.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/http_helper.dart';
import 'package:ankiishopii/helpers/shared_preferences_helper.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/login_model.dart';

class AccountService extends BlocService<AccountModel> {
  @override
  Future<AccountModel> get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<AccountModel>> getAll({int from = 0, int limit}) async {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  Future<AccountModel> getAccountFromLocal() async {
    var login = await LocalHelper.getAccountFromLocal();
    currentLogin = login;
    if (login != null) return login.account;
    return null;
  }

  Future<AccountModel> updateAccountInfoToLocal(AccountModel accountModel) async {
    var login = await LocalHelper.getAccountFromLocal();
    login.account = accountModel;
    var account = await LocalHelper.saveAccountToLocal(login);
    return account;
  }
}
