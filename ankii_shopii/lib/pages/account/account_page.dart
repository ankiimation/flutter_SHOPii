import 'package:ankiishopii/blocs/account_bloc/bloc.dart';
import 'package:ankiishopii/blocs/account_bloc/event.dart';
import 'package:ankiishopii/blocs/account_bloc/state.dart';
import 'package:ankiishopii/blocs/login_bloc/service.dart';
import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/pages/account/login_page.dart';
import 'package:ankiishopii/pages/delivery_address/delivery_address_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  final ScrollController scrollController;

  AccountPage(this.scrollController);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountBloc bloc = AccountBloc(AccountLoading())..add(GetLocalAccount());

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FOREGROUND_COLOR,
      body: Container(
        padding: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context)),
        child: BlocBuilder(
            cubit: bloc,
            builder: (context, state) {
              if (state is AccountLoaded) {
                return Stack(
                  children: <Widget>[
                    buildAvatar(state.account),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                          controller: widget.scrollController,
                          child: buildProfile(state.account)),
                    )
                  ],
                );
              } else if (state is AccountLoadingFailed) {
                return Center(child: buildLogInButton());
              } else {
                return Center(
                  child: CustomDotLoading(),
                );
              }
            }),
      ),
    );
  }

  Widget buildAvatar(AccountModel accountModel) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: accountModel.image != null
                ? CachedNetworkImageProvider(accountModel.image)
                : null,
            child: accountModel.image != null
                ? null
                : Icon(
                    Icons.account_circle,
                    size: 70,
                    color: FOREGROUND_COLOR,
                  ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            accountModel.fullname ?? 'Lê Nguyên Khoa',
            style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget buildProfile(AccountModel account) {
    return Column(
      children: <Widget>[
        Container(
          constraints:
              BoxConstraints(minHeight: ScreenHelper.getHeight(context) * 0.7),
          margin: EdgeInsets.only(top: 200),
          padding: EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, offset: Offset(0, -3), blurRadius: 5)
              ],
              color: BACKGROUND_COLOR,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: <Widget>[
              _buildInfoItem(key: 'Username', value: account.username),
              _buildDivider(),
              _buildInfoItem(key: 'Phone', value: account.phoneNumber),
              _buildDivider(),
              _buildInfoItem(key: 'Address', value: account.address),
              _buildDivider(),
              CustomOnTapWidget(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (b) => DeliveryAddressPage()));
                  },
                  child: _buildInfoItem(
                      key: 'Delivery Addresses', value: '<Tap to view>')),
              SizedBox(
                height: 50,
              ),
              buildLogoutButton()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      color: PRIMARY_COLOR.withOpacity(0),
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }

  Widget _buildInfoItem({String key, String value}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(key ?? '', style: TEXT_STYLE_PRIMARY),
          Text(
            value ?? '<empty>',
            style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildLogInButton() {
    return RaisedButton(
      elevation: 0,
      onPressed: () async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (b) => LoginPage()));
        bloc.add(GetLocalAccount());
      },
      color: BACKGROUND_COLOR,
      child: Container(
        child: Text(
          'Log In',
          style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  Widget buildLogoutButton() {
    return RaisedButton(
      elevation: 0,
      onPressed: () async {
        await LoginService().logOut();
        refreshLogin(context);
        bloc.add(GetLocalAccount());
      },
      color: FOREGROUND_COLOR,
      child: Container(
        child: Text('Log Out', style: TEXT_STYLE_ON_FOREGROUND),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
