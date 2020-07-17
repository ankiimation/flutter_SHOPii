import 'package:ankiishopii/blocs/account_bloc/event.dart';
import 'package:ankiishopii/blocs/account_bloc/service.dart';
import 'package:ankiishopii/blocs/account_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(AccountState initialState) : super(initialState);

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetLocalAccount) {
    yield*  mapLoginEventToState(event);
    }
  }

  Stream<AccountState> mapLoginEventToState(GetLocalAccount event) async* {
    var rs = await AccountService().getAccountFromLocal();
    if (rs != null) {
      yield AccountLoaded(rs);
    } else {
      yield AccountLoadingFailed();
    }
  }
}
