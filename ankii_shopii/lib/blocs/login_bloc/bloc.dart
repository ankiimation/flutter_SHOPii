import 'package:ankiishopii/blocs/login_bloc/event.dart';
import 'package:ankiishopii/blocs/login_bloc/service.dart';
import 'package:ankiishopii/blocs/login_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInit());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoginNow) {
      yield* mapLoginNowToState(event);
    }
  }

  Stream<LoginState> mapLoginNowToState(LoginNow event) async* {
    var rs = await LoginService().logIn(event.username, event.password);
    if (rs != null) {
      yield LoginSuccessfully(rs);
    } else {
      yield LoginFailed();
    }
  }
}
