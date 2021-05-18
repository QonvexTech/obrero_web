import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;

class MapService extends ChangeNotifier {
  final containerKey = GlobalKey();
  double _zoom = 15.0;
  LatLng coordinates = LatLng(48.864716, 2.349014);
  Location _location = Location();
  bool? _serviceEnabled;
  String addressGeo = "";
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  GoogleMapController? mapController;
  bool _gesture = true;
  TextEditingController location = TextEditingController();
  TextEditingController address = TextEditingController();
  void setLocation(value) {
    location.text = value;
  }

  void setAddress(value) {
    address.text = value;
  }

  //---------------------------- CUSTOM INFO  WINDOW
  ProjectModel? _project;
  bool _showInfoWindow = false;
  bool _tempHidden = false;

  double? _leftMargin;
  double? _topMargin;

  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;

  void rebuildInfoWindow() {
    notifyListeners();
  }

  void updateProject(ProjectModel project) {
    _project = project;
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
    try {
      var screenCoordinate = await controller.getVisibleRegion();
      double devicePixelRatio =
          Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
      double left = (double.parse(screenCoordinate.northeast.toString())) -
          (infoWindowWidth / 2);
      double top = (double.parse(screenCoordinate.southwest.toString()) /
              devicePixelRatio) -
          markerOffset;
      if (left < 0 || top < 0) {
        _tempHidden = true;
      } else {
        _tempHidden = false;
        _leftMargin = left;
        _topMargin = top;
      }
    } catch (e) {
      print("custom error $e");
    }
  }

  bool get showInfoWindow =>
      (_showInfoWindow == true && _tempHidden == false) ? true : false;

  double get leftMargin => _leftMargin!;

  double get topMargin => _topMargin!;

  ProjectModel get project => project;

  //-------------------------

  get gesture => _gesture;

  set gesture(value) {
    _gesture = value;
    notifyListeners();
  }

  Set<Marker> _markers = {};
  get zoom => _zoom;
  get markers => _markers;

  void removeDefaultMarker() {
    _markers.removeWhere((element) => element.markerId.value == "temp");
    notifyListeners();
  }

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

  mapInit(List<ProjectModel> projects, context, List imagesStatus) async {
    if (_markers.length > 0) {
      coordinates = _markers.first.position;
      location.text =
          "${coordinates.latitude.toString()}, ${coordinates.longitude.toString()}";
      findLocalByCoordinates(
          coordinates.latitude.toString(), coordinates.longitude.toString());
    }
    _markers.clear();
    try {
      for (ProjectModel project in projects) {
        _markers.add(Marker(
            onTap: () {
              mapController!
                  .showMarkerInfoWindow(MarkerId(project.id.toString()));
            },
            zIndex: 20,
            infoWindow: InfoWindow(
                onTap: () {
                  print("x");
                },
                title: project.name,
                snippet: project.address.toString()),
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

  void setCoordinates({LatLng? coord, BuildContext? context}) async {
    Marker toRemove = _markers.firstWhere(
        (element) => element.mapsId.value == "temp",
        orElse: () => Marker(markerId: MarkerId("temp")));

    if (_markers.contains(toRemove)) {
      _markers.remove(toRemove);
    } else {
      if (coord != null) {
        coordinates = coord;
        location.text =
            "${coord.latitude.toString()}, ${coord.longitude.toString()}";
        findLocalByCoordinates(
            coord.latitude.toString(), coord.longitude.toString());
      }
      Marker defMarker = Marker(
          onTap: () {},
          zIndex: 20,
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), "assets/icons/green.png"),
          markerId: MarkerId("temp"),
          position: coord!);

      _markers.add(defMarker);
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

  void focusMap({required LatLng coordinates, required markerId}) {
    mapController!
        .animateCamera(CameraUpdate.newLatLng(coordinates))
        .whenComplete(() {
      mapController!.showMarkerInfoWindow(MarkerId(markerId));
    });
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

  Future findLocalByCoordinates(String lat, String lang) async {
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
        addressGeo = data["plus_code"]["compound_code"] ?? "$lat , $lang";
        address.text = addressGeo;

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
