import 'package:ankiishopii/blocs/shop_bloc/event.dart';
import 'package:ankiishopii/blocs/shop_bloc/service.dart';
import 'package:ankiishopii/blocs/shop_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopAccountBloc extends Bloc<ShopAccountEvent, ShopAccountState> {
  ShopAccountBloc() : super(ShopAccountLoading());

  @override
  Stream<ShopAccountState> mapEventToState(ShopAccountEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetShopAccount) {
      yield* mapGetAccountToState(event);
    }
  }

  Stream<ShopAccountState> mapGetAccountToState(GetShopAccount event) async* {
    var rs = await ShopAccountService().getShopAccount(event.username);
    if (rs != null) {
      yield ShopAccountLoaded(rs);
    } else {
      yield ShopAccountError();
    }
  }
}
