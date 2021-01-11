import 'dart:async';

import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DynamicGoogleMap extends StatefulWidget {
  final String initAddress;

  DynamicGoogleMap({this.initAddress});

  @override
  _DynamicGoogleMapState createState() => _DynamicGoogleMapState();
}

class _DynamicGoogleMapState extends State<DynamicGoogleMap> {
  final Completer<GoogleMapController> completer = Completer();
  final Geolocator geoLocator = Geolocator();
  final searchTextController = TextEditingController();

  Placemark currentPlace;
  double currentLat = 0;
  double currentLong = 0;
  List<LatLng> currentDirection = [];

  Future _onDragDone() async {
    LoadingDialog.showLoadingDialog(context);
    try {
      var places = await geoLocator.placemarkFromCoordinates(currentLat, currentLong);

      setState(() {
        currentPlace = places.first;
      });
      LoadingDialog.hideLoadingDialog(context);
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      // LoadingDialog.showMessage(context, text: 'Err!!');
      setState(() {
        currentPlace = null;
      });
    }
  }

  Future _onDrag(CameraPosition cameraPosition) async {
    double lat = cameraPosition.target.latitude;
    double long = cameraPosition.target.longitude;

    currentLat = lat;
    currentLong = long;

    print(lat.toString() + long.toString());
  }

  Future _gotoCurrentLocation() async {
    try {
      var myLocation = await geoLocator.getCurrentPosition();
      _gotoPosition(LatLng(myLocation.latitude, myLocation.longitude));
      var myPlace = await geoLocator.placemarkFromPosition(myLocation);
      setState(() {
        currentPlace = myPlace.first;
      });
    } catch (e) {}
  }

  Future<LatLng> _getLatLongFromAddress(String address) async {
    var rs = (await geoLocator.placemarkFromAddress(address)).first.position;
    return LatLng(rs.latitude, rs.longitude);
  }

  Future<bool> _gotoAddress(String address) async {
    LoadingDialog.showLoadingDialog(context, text: 'Searching...');
    try {
      List<Placemark> pos = await geoLocator.placemarkFromAddress(address);
      if (pos != null && pos.length > 0) {
        LoadingDialog.hideLoadingDialog(context);
        var first = pos.first;
        _gotoPosition(LatLng(first.position.latitude, first.position.longitude));
        String address =
            '${first.name}, ${first.thoroughfare}, ${first.subLocality}, ${first.subAdministrativeArea}, ${first.administrativeArea}';
        //print(first.toJson());
        setState(() {
          currentPlace = first;
        });
        print(address);

        return true;
      }
      return false;
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);

      print(e);
      return false;
    }
  }

  _gotoPosition(LatLng latLng) async {
    final GoogleMapController controller = await completer.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: latLng,
      zoom: 20,
    )));
  }

  String _getFullAddressString(Placemark place) {
    if (place == null) return 'unknown';
    return '${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.administrativeArea}';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchTextController.text = widget.initAddress ?? '';
    Future.delayed(Duration(seconds: 2), () {
      if (widget.initAddress != null && widget.initAddress.length > 0) {
        _gotoAddress(widget.initAddress).then((result) {
          if (result == false) {
            _gotoCurrentLocation();
          }
        });
      } else {
        _gotoCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: BACKGROUND_COLOR,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: (googleMapController) {
              completer.complete(googleMapController);
            },
            initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            onCameraMove: _onDrag,
            onCameraIdle: _onDragDone,
            polylines: Set<Polyline>()
              ..add(Polyline(
                  polylineId: PolylineId('thanhDa'),
                  width: 5,
                  points: currentDirection,
                  color: PRIMARY_COLOR,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap)),
          ),
          Center(
            child: Icon(
              Icons.my_location,
              color: PRIMARY_COLOR,
            ),
          ),
          buildTop(),
          Align(alignment: Alignment.bottomLeft, child: buildInfoPanel())
        ],
      ),
    );
  }

  Widget buildTop() {
    return Container(
      padding: EdgeInsets.only(top: ScreenHelper.getPaddingTop(context) + 10, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
            color: BACKGROUND_COLOR.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: FOREGROUND_COLOR, width: 5)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: searchTextController,
                onFieldSubmitted: (t) async {
                  FocusScope.of(context).unfocus();
                  bool rs = await _gotoAddress(searchTextController.text);
                  if (rs == false) {
                    LoadingDialog.showMessage(context, text: 'Not found!');
                  }
                },
                decoration: InputDecoration(
                    hintText: 'Search Your Location', contentPadding: EdgeInsets.all(10), border: InputBorder.none),
              ),
            ),
            CustomOnTapWidget(
              onTap: () async {
                FocusScope.of(context).unfocus();
                bool rs = await _gotoAddress(searchTextController.text);
                if (rs == false) {
                  LoadingDialog.showMessage(context, text: 'Not found!');
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.search,
                  color: PRIMARY_COLOR,
                ),
              ),
            ),
            CustomOnTapWidget(
              onTap: () {
                FocusScope.of(context).unfocus();
                _gotoCurrentLocation();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.location_on,
                  color: PRIMARY_COLOR,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoPanel() {
    return currentPlace != null
        ? Container(
            decoration: BoxDecoration(
                color: BACKGROUND_COLOR,
                boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(3, -3), blurRadius: 3)],
                borderRadius: BorderRadius.only(topRight: Radius.circular(15))),
            width: ScreenHelper.getWidth(context) * 0.8,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Address:',
                          style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Text(
                          '${_getFullAddressString(currentPlace)}',
                          style: TEXT_STYLE_PRIMARY.copyWith(fontSize: 16),
                        )),
                        IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () async {
                              PolylinePoints polylinePoints = PolylinePoints();
                              var thanhDa = await _getLatLongFromAddress('cu xa thanh da');
                              var choBaChieu = await _getLatLongFromAddress('cho ba chieu');
                              var cauKinhThanhDa = await _getLatLongFromAddress('vong xoay hang xanh');
                              var duongBachDang = await _getLatLongFromAddress('ts24');

//
//                              PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//                                googleMapAPIKey,
//                                PointLatLng(thanhDa.latitude, thanhDa.latitude),
//                                PointLatLng(choBaChieu.latitude, choBaChieu.latitude),
//                              );

                              setState(() {
                                currentDirection.add(thanhDa);
                                currentDirection.add(choBaChieu);
                                currentDirection.add(cauKinhThanhDa);
                                currentDirection.add(duongBachDang);
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Geo:',
                          style: TEXT_STYLE_PRIMARY.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('${currentPlace.position.latitude}'),
                            Text('${currentPlace.position.longitude}'),
                          ],
                        ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                color: BACKGROUND_COLOR,
                                child: Text(
                                  'Cancel',
                                  style: TEXT_STYLE_PRIMARY,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                })),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: RaisedButton(
                                color: FOREGROUND_COLOR,
                                child: Text(
                                  'OK',
                                  style: TEXT_STYLE_ON_FOREGROUND.copyWith(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, currentPlace);
                                }))
                      ],
                    )
                  ],
                ),
              ),
            ))
        : Container();
  }
}

class StaticGoogleMap extends StatelessWidget {
  final double lat;
  final double long;

  StaticGoogleMap(this.lat, this.long);

  final Completer<GoogleMapController> completer = Completer();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Stack(
        children: <Widget>[
          GoogleMap(
//              liteModeEnabled: true,
              onMapCreated: (googleMapController) {
                completer.complete(googleMapController);
              },
              scrollGesturesEnabled: false,
              initialCameraPosition: CameraPosition(target: LatLng(lat, long))),
          Center(
              child: Icon(
            Icons.location_searching,
          ))
        ],
      ),
    );
  }

  gotoPosition(LatLng latLng) async {
    final GoogleMapController controller = await completer.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: latLng,
      zoom: 20,
    )));
  }
}
