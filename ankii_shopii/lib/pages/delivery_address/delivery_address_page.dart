import 'package:ankiishopii/blocs/account_bloc/service.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/bloc.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/event.dart';
import 'package:ankiishopii/blocs/delivery_address_bloc/state.dart';
import 'package:ankiishopii/global/global_variable.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/delivery_address/add_delivery_address_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryAddressPage extends StatefulWidget {
  final OrderingModel currentCheckout;
  final bool isDialog;

  DeliveryAddressPage({this.currentCheckout, this.isDialog = false});

  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  DeliveryAddressBloc bloc = DeliveryAddressBloc();

  _setDefaultDeliveryAddress(int id) async {
    setState(() {
      currentLogin.account.defaultDeliveryId = id;
    });
    await AccountService().updateDefaultDeliveryId(id);
    bloc.add(GetAllDeliveryAddresses());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.add(GetAllDeliveryAddresses());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Container(
        child: SingleChildScrollView(
          child: BlocBuilder(
              cubit: bloc,
              builder: (context, state) {
                if (state is AllDeliveryAddressesLoaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      !widget.isDialog
                          ? InPageAppBar(
                              title: 'Delivery Addresses',
                              showCartButton: false,
                              leading: CustomOnTapWidget(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back_ios),
                              ),
                            )
                          : Container(),
                      buildAddNewAddressButton(),
                      buildListAddress(state.deliveryAddresses),
                    ],
                  );
                } else if (state is DeliveryAddressLoading) {
                  return Center(
                    child: CustomDotLoading(),
                  );
                }
                return Center(
                  child: Text('You dont have any addresses!!'),
                );
              }),
        ),
      ),
    );
  }

  Widget buildAddNewAddressButton() {
    return CustomOnTapWidget(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (b) => AddDeliveryAddressPage()));
        bloc.add(GetAllDeliveryAddresses());
      },
      child: Container(
          color: PRIMARY_COLOR,
          width: double.maxFinite,
          height: 50,
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.add,
            color: FORE_TEXT_COLOR,
          )),
    );
  }

  Widget buildListAddress(List<DeliveryAddressModel> deliveryAddresses) {
    deliveryAddresses = deliveryAddresses.reversed.toList();
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: deliveryAddresses
            .map<Widget>((address) => Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: addressItem(address)))
            .toList());
  }

  Widget addressItem(DeliveryAddressModel deliveryAddressModel) {
    bool isDefault =
        deliveryAddressModel.id == currentLogin.account.defaultDeliveryId;
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: CustomOnTapWidget(
                onTap: () async {
                  // AccountService accountService = AccountService();
                  if (isDefault) {
                    _setDefaultDeliveryAddress(-1);
                    //bloc.add(GetAllDeliveryAddresses());
                  } else {
                    _setDefaultDeliveryAddress(deliveryAddressModel.id);

                    // bloc.add(GetAllDeliveryAddresses());
                  }
                  //   print('Current: ' + currentLogin.account.defaultDeliveryId.toString());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: 30,
                  color: isDefault
                      ? PRIMARY_COLOR
                      : PRIMARY_COLOR.withOpacity(0.1),
                  child: isDefault
                      ? Text(
                          'Default Address',
                          style: TEXT_STYLE_PRIMARY.copyWith(
                              fontWeight: FontWeight.bold,
                              color: FOREGROUND_COLOR),
                        )
                      : Text(
                          'Tap to set default delivery address',
                          style: TEXT_STYLE_PRIMARY.copyWith(fontSize: 12),
                        ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                CustomOnTapWidget(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      color: FOREGROUND_COLOR,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    )),
                CustomOnTapWidget(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      color: PRICE_COLOR_PRIMARY,
                      child: Icon(
                        Icons.delete,
                        color: BACKGROUND_COLOR,
                        size: 20,
                      ),
                    )),
              ],
            )
          ],
        ),
        CustomOnTapWidget(
          onTap: () {
            Navigator.pop(context, deliveryAddressModel);
          },
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FOREGROUND_COLOR,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text(
                            'Name:',
                            style: TEXT_STYLE_ON_FOREGROUND,
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          deliveryAddressModel.fullname,
                          textAlign: TextAlign.right,
                          style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Text('Address:',
                              style: TEXT_STYLE_ON_FOREGROUND)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          deliveryAddressModel.address,
                          textAlign: TextAlign.right,
                          style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child:
                              Text('Phone:', style: TEXT_STYLE_ON_FOREGROUND)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          deliveryAddressModel.phoneNumber,
                          textAlign: TextAlign.right,
                          style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
