import 'package:ankiishopii/models/account_model.dart';
import 'package:equatable/equatable.dart';

class AccountState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class AccountLoaded extends AccountState{
  final AccountModel account;

  AccountLoaded(this.account);
  @override
  // TODO: implement props
  List<Object> get props => [account];
}
class AccountLoadingFailed extends AccountState{}
class AccountLoading extends AccountState{}