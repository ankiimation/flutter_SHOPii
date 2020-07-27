import 'package:ankiishopii/blocs/delivery_address_bloc/service.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/models/account_model.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';

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
    if (phoneController.text.length > 10) {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              children: <Widget>[buildAppBar(), buildInput(), buildMap(), buildAddButton()],
            ),
          ),
        ));
  }

  Widget buildAppBar() {
    return InPageAppBar(
      showCartButton: false,
      title: 'Add Delivery',
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
          if(onValidName()==null && onValidAddress()==null && onValidPhone() == null){
            LoadingDialog.showLoadingDialog(context);
            String name = nameController.text;
            String address = addressController.text;
            String phone = phoneController.text;
            var deliveryAddress = DeliveryAddressModel(
              fullname: name,
              address: address,
              phoneNumber: phone
            );
            var rs = await DeliveryAddressService().addDeliveryAddress(deliveryAddress);
            if(rs!=null){
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
              style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
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
          ),
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
    return Container(
      margin: EdgeInsets.all(20),
      height: 250,
      width: double.maxFinite,
      color: Colors.green,
      child: Text('Map'),
    );
  }
}
