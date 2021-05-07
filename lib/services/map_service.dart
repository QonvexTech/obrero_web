import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;

class MapService extends ChangeNotifier {
  double _zoom = 15.0;
  LatLng coordinates = LatLng(28.709106207008052, 77.09902385711672);
  Location _location = Location();
  bool? _serviceEnabled;
  String _addressGeo = "";

  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  GoogleMapController? mapController;
  CameraPosition cameraPosition = CameraPosition(
      target: LatLng(28.709106207008052, 77.09902385711672), zoom: 15.0);

  Set<Marker> _markers = {};
  get zoom => _zoom;
  get markers => _markers;
  get addressGeo => _addressGeo;

  // Future setAddress(latitude, longitude) async {
  //   var address =
  //       await Geocoder.google("AIzaSyBDdhTPKSLQlm6zmF_OEdFL2rUupPYF_JI")
  //           .findAddressesFromCoordinates(Coordinates(latitude, longitude));
  //   _addressGeo = address.first.toString();
  // }

  // static Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  mapInit(List<ProjectModel> projects) async {
    if (_markers.length > 0) {
      coordinates = _markers.first.position;
      findLocalByCoordinates(coordinates.latitude, coordinates.longitude);
    }
    _markers.clear();
    try {
      for (ProjectModel project in projects) {
        _markers.add(Marker(
            zIndex: 20,
            infoWindow: InfoWindow(
                title: project.name, snippet: project.coordinates.toString()),
            icon: await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(), imagesStatus[project.status!]),
            markerId: MarkerId(project.id.toString()),
            position: project.coordinates!));
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    print("markers : ${_markers.length}");
    notifyListeners();
  }

  void setCoordinates({LatLng? coord}) async {
    if (coord != null) {
      coordinates = coord;
      findLocalByCoordinates(coordinates.latitude, coordinates.longitude);
    }
    if (_markers.isEmpty) {
      _markers.add(Marker(
          zIndex: 20,
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), "assets/icons/green.png"),
          markerId: MarkerId("temp"),
          position: coord!));
    } else {
      _markers.clear();
    }
    notifyListeners();
  }

  // void addNewMarker(LatLng coord) {
  //   Marker newMarker = Marker(markerId: MarkerId("value"), position: coord);
  //   _markers.add(newMarker);
  //   notifyListeners();
  // }

  // void changePosition(MarkerId markerId) {
  //   final Marker marker = markers[markerId]!;
  //   final LatLng current = marker.position;
  //   final Offset offset = Offset(
  //     coordinates.latitude - current.latitude,
  //     coordinates.longitude - current.longitude,
  //   );

  //   markers[markerId] = marker.copyWith(
  //     positionParam: LatLng(
  //       coordinates.latitude + offset.dy,
  //       coordinates.longitude + offset.dx,
  //     ),
  //   );
  //   notifyListeners();
  // }

  void focusMap({required LatLng coordinates}) {
    mapController!.animateCamera(CameraUpdate.newLatLng(coordinates));
    notifyListeners();
  }

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

  Future findLocalByCoordinates(double lat, double lang) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lang&location_type=ROOFTOP&result_type=street_address&key=AIzaSyBDdhTPKSLQlm6zmF_OEdFL2rUupPYF_JI");
    try {
      var response = await http.post(url, headers: {
        "Accept": "application/json",
        // "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        print(data);
        _addressGeo = data["plus_code"]["compound_code"];
        notifyListeners();
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }

    // return
  }
}
