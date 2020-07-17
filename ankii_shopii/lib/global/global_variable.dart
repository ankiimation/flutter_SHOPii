import 'package:ankiishopii/helpers/shared_preferences_helper.dart';
import 'package:ankiishopii/models/login_model.dart';


getGlobal() async {
  var login = await LocalHelper.getAccountFromLocal();
  currentLogin = login;
}
LoginModel currentLogin;