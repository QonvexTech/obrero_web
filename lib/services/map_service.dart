import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uitemplate/models/mapInfo_model.dart';

class MapService extends ChangeNotifier {
  Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  //MAP
  bool _showInfoWindow = false;
  bool _tempHidden = false;
  MapInfo? _info;
  double? _leftMargin;
  double? _topMargin;

  void rebuildInfoWindow() {
    notifyListeners();
  }

  void updateUser(MapInfo info) {
    _info = info;
  }

  void updateVisibility(bool visibility) {
    _showInfoWindow = visibility;
  }

  void updateInfoWindow(
    BuildContext context,
    GoogleMapController controller,
    LatLng location,
    double infoWindowWidth,
    double markerOffset,
  ) async {
    ScreenCoordinate screenCoordinate =
        await controller.getScreenCoordinate(location);
    double devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (infoWindowWidth / 2);
    double top =
        (screenCoordinate.y.toDouble() / devicePixelRatio) - markerOffset;
    if (left < 0 || top < 0) {
      _tempHidden = true;
    } else {
      _tempHidden = false;
      _leftMargin = left;
      _topMargin = top;
    }
  }

  bool get showInfoWindow =>
      (_showInfoWindow == true && _tempHidden == false) ? true : false;

  double get leftMargin => _leftMargin!;

  double get topMargin => _topMargin!;

  MapInfo get info => _info!;

  LocationData get locationData => _locationData!;

  checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await _location.getLocation();
  }
}
