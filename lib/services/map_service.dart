import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uitemplate/models/project_model.dart';

class MapService extends ChangeNotifier {
  double _zoom = 15.0;
  Location _location = Location();
  bool? _serviceEnabled;
  LatLng coordinates = LatLng(28.709106207008052, 77.09902385711672);
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  Set<Marker> _markers = {};

  get zoom => _zoom;
  get markers => _markers;

  mapInit(List<ProjectModel> projects) {
    for (var project in projects) {
      _markers.add(Marker(
          markerId: MarkerId(project.id.toString()),
          position: project.coordinates!));
    }
    notifyListeners();
  }

  void setCoordinates(LatLng coord) {
    coordinates = coord;
    notifyListeners();
  }

  // LatLng convertedCoord(String value) {
  //   return LatLng(
  //       double.parse(value.split(",")[0]), double.parse(value.split(",")[1]));
  // }

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
