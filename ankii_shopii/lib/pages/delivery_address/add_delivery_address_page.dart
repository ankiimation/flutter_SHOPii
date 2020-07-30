import 'dart:async';

import 'package:ankiishopii/blocs/delivery_address_bloc/service.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/google_map/custom_google_map.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddDeliveryAddressPage extends StatefulWidget {
  @override
  _AddDeliveryAddressPageState createState() => _AddDeliveryAddressPageState();
}

class _AddDeliveryAddressPageState extends State<AddDeliveryAddressPage> {
  bool _isLoading = false;
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var phoneController = TextEditingController();

  String validName;
  String validAddress;
  String validPhone;

  bool _mapLoadedSuccessfully = false;
  Placemark currentPlace;
  StaticGoogleMap googleMapWidget;

  String onValidName() {
    if (nameController.text.length > 0) {
      setState(() {
        validName = null;
      });
      return null;
    }
    setState(() {
      validName = 'Name not valid';
    });
    return 'Name not valid';
  }

  String onValidAddress() {
    if (addressController.text.length > 0) {
      setState(() {
        validAddress = null;
      });
      return null;
    }
    setState(() {
      validAddress = 'Address not valid';
    });
    return 'Address not valid';
  }

  String onValidPhone() {
    if (phoneController.text.length >= 10 && phoneController.text.length <= 15) {
      setState(() {
        validPhone = null;
      });

      return null;
    }
    setState(() {
      validPhone = 'Phone not valid';
    });

    return 'Phone not valid';
  }

  Future updateWithLatLong(double lat, double long) async {
    try {
      LoadingDialog.showLoadingDialog(context);
      List<Placemark> pos = await Geolocator().placemarkFromCoordinates(lat, long);
      if (pos != null && pos.length > 0) {
        var first = pos.first;
        googleMapWidget.gotoPosition(LatLng(first.position.latitude, first.position.longitude));
        String address =
            '${first.name}, ${first.thoroughfare}, ${first.subLocality}, ${first.subAdministrativeArea}, ${first.administrativeArea}';
        //print(first.toJson());
        setState(() {
          addressController.text = address;
          currentPlace = first;
          _mapLoadedSuccessfully = true;
        });
        LoadingDialog.hideLoadingDialog(context);
      }
    } catch (e) {
      print(e);
      LoadingDialog.hideLoadingDialog(context);
      setState(() {
        _mapLoadedSuccessfully = false;
      });
    }
  }

  Future updateMap(String address) async {
    try {
      LoadingDialog.showLoadingDialog(context);
      List<Placemark> pos = await Geolocator().placemarkFromAddress(address);
      if (pos != null && pos.length > 0) {
        var first = pos.first;
        googleMapWidget.gotoPosition(LatLng(first.position.latitude, first.position.longitude));
        String address =
            '${first.name}, ${first.thoroughfare}, ${first.subLocality}, ${first.subAdministrativeArea}, ${first.administrativeArea}';
        //print(first.toJson());
        setState(() {
          addressController.text = address;
          currentPlace = first;
          _mapLoadedSuccessfully = true;
        });
        LoadingDialog.hideLoadingDialog(context);
      }
    } catch (e) {
      print(e);
      LoadingDialog.hideLoadingDialog(context);
      setState(() {
        _mapLoadedSuccessfully = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleMapWidget = StaticGoogleMap(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: Container(
          constraints: BoxConstraints(minHeight: ScreenHelper.getSafeHeight(context)),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                buildAppBar(),
                buildInput(),
                buildAddButton(),
                buildMap(),
              ],
            ),
          ),
        ));
  }

  Widget buildAppBar() {
    return InPageAppBar(
      showCartButton: false,
      title: 'Add Delivery Address',
      leading: CustomOnTapWidget(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget buildAddButton() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
      child: RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () async {
          if (onValidName() == null && onValidAddress() == null && onValidPhone() == null) {
            LoadingDialog.showLoadingDialog(context);
            String name = nameController.text;
            String address = addressController.text;
            String phone = phoneController.text;
            var deliveryAddress = DeliveryAddressModel(
                fullname: name,
                address: address,
                phoneNumber: phone,
                longitude: currentPlace?.position?.longitude.toString(),
                latitude: currentPlace?.position?.latitude.toString());
            var rs = await DeliveryAddressService().addDeliveryAddress(deliveryAddress);
            if (rs != null) {
              Navigator.pop(context);
            }
            LoadingDialog.hideLoadingDialog(context);
          }
        },
        color: FOREGROUND_COLOR,
        padding: EdgeInsets.all(15),
        child: Container(
            alignment: Alignment.center,
            child: Text(
              'Add',
              style: TEXT_STYLE_ON_FOREGROUND.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget buildInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//          Container(
//              margin: EdgeInsets.only(top: 10, left: 20),
//              child: Text(
//                'Login',
//                style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 25),
//              )),
        Container(
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          decoration: BoxDecoration(
              color: BACKGROUND_COLOR,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: FOREGROUND_COLOR, width: 2)),
          child: TextFormField(
            controller: nameController,
            onChanged: (s) {
              onValidName();
            },
            decoration: InputDecoration(
              errorText: validName,
              labelText: 'Full Name',
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          decoration: BoxDecoration(
              color: BACKGROUND_COLOR,
              border: Border.all(color: FOREGROUND_COLOR, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: addressController,
                  onChanged: (s) {
                    onValidAddress();
                  },
                  decoration: InputDecoration(
                    errorText: validAddress,
                    labelText: 'Address',
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                  ),
                  maxLines: 5,
                  minLines: 1,
                ),
              ),
              CustomOnTapWidget(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  await updateMap(addressController.text);
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      _mapLoadedSuccessfully ? Icons.my_location : Icons.location_searching,
                      color: FOREGROUND_COLOR,
                    )),
              ),
            ],
          ),
        ),
        CustomOnTapWidget(
          onTap: () async {
            var rs = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (b) => DynamicGoogleMap(
                          initAddress: addressController.text,
                        )));
            if (rs != null && rs is Placemark) {
              updateWithLatLong(rs.position.latitude, rs.position.longitude);
            }
          },
          child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.all(5),
              child: Text(
                'Search in Map',
                style: TEXT_STYLE_PRIMARY.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: FOREGROUND_COLOR),
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          decoration: BoxDecoration(
              color: BACKGROUND_COLOR,
              border: Border.all(color: FOREGROUND_COLOR, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (s) {
              onValidPhone();
            },
            controller: phoneController,
            decoration: InputDecoration(
              errorText: validPhone,
              labelText: 'Phone Number',
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMap() {
    return _mapLoadedSuccessfully
        ? Container(
            margin: EdgeInsets.all(20),
            height: 300,
            width: double.maxFinite,
            decoration: BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(30)),
            child: googleMapWidget,
          )
        : Container();
  }
}
