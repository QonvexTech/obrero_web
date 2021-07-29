import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/project/project_add_service.dart';

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

  String _address = "";
  TextEditingController location = TextEditingController();
  //

  // TextEditingController get address => _address;

  void focusMap({required LatLng coordinates, required markerId}) {
    mapController!.showMarkerInfoWindow(MarkerId(markerId));
    mapController!
        .moveCamera(CameraUpdate.newLatLng(coordinates))
        .whenComplete(() {});

    // notifyListeners();
  }

  get address => _address;

  int statusDefault = 0;
  void setLocation(value) {
    location.text = value;
  }

  void setStatus(value) {
    statusDefault = value;
    notifyListeners();
  }

  get gesture => _gesture;

  set gesture(value) {
    _gesture = value;
    notifyListeners();
  }

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  get zoom => _zoom;
  get markers => _markers;
  get circles => _circles;

  markersAdd(value) {
    _markers.add(value);
    notifyListeners();
  }

  mapClear(String projectId) {
    _circles.removeWhere((element) => element.circleId.value == projectId);
    _markers.removeWhere((element) => element.markerId.value == projectId);
    notifyListeners();
  }

  void changeAreaSize(area, coord, bool isEdit, String id) {
    if (isEdit) {
      _circles.removeWhere((element) => element.circleId.value == id);
      _circles.add(Circle(
          fillColor: Color.fromRGBO(60, 120, 225, 0.1),
          circleId: CircleId(
            id,
          ),
          radius: area,
          strokeWidth: 1,
          strokeColor: Colors.black12,
          center: coord));
    } else {
      _circles.removeWhere((element) => element.circleId.value == "temp");
      _circles.add(Circle(
          fillColor: Color.fromRGBO(60, 120, 225, 0.1),
          circleId: CircleId(
            "temp",
          ),
          radius: area,
          strokeWidth: 1,
          strokeColor: Colors.black12,
          center: coord));
    }

    notifyListeners();
  }

  void removeDefaultMarker() {
    _markers.removeWhere((element) => element.markerId.value == "temp");
    _circles.removeWhere((element) => element.circleId.value == "temp");
    notifyListeners();
  }

  Future mapInit(List<ProjectModel> projects, context) async {
    _markers.clear();
    _circles.clear();
    if (_markers.length > 0) {
      coordinates = _markers.first.position;
      location.text =
          "${coordinates.latitude.toString()}, ${coordinates.longitude.toString()}";
      findLocalByCoordinates(
        coordinates.latitude.toString(),
        coordinates.longitude.toString(),
      );
    }

    if (projects.length > 0) {
      try {
        for (ProjectModel project in projects) {
          _markers.add(Marker(
              onTap: () {
                try {
                  mapController!
                      .showMarkerInfoWindow(MarkerId(project.id.toString()));
                } catch (e) {
                  print(e);
                }
              },
              infoWindow: InfoWindow(
                  title: project.name, snippet: project.address.toString()),
              icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(),
                  colorsSettingsStatus[project.status!].circleAsset!),
              markerId: MarkerId(project.id.toString()),
              position: project.coordinates!));

          _circles.add(Circle(
              fillColor: Color.fromRGBO(60, 120, 225, 0.1),
              circleId: CircleId(
                project.id.toString(),
              ),
              radius: project.areaSize!,
              strokeWidth: 1,
              strokeColor: Colors.black12,
              center: project.coordinates!));
        }
        print("CIRCLE: ${_circles.length}");
      } catch (e) {
        print(e);
      }
    }

    notifyListeners();
  }

  Future setCoordinates(
      {LatLng? coord,
      var projectservice,
      BuildContext? context,
      double? areaSize,
      bool? isEdit,
      String? projectId,
      required bool? isClick}) async {
    Marker? toRemove;
    Circle? toRemoveCircle;
    if (isEdit!) {
      toRemove = _markers.firstWhere(
          (element) => element.mapsId.value == projectId,
          orElse: () => Marker(markerId: MarkerId(projectId!)));

      toRemoveCircle = _circles.firstWhere(
          (element) => element.mapsId.value == projectId,
          orElse: () => Circle(circleId: CircleId(projectId!)));
    } else {
      toRemove = _markers.firstWhere(
          (element) => element.mapsId.value == "temp",
          orElse: () => Marker(markerId: MarkerId("temp")));

      toRemoveCircle = _circles.firstWhere(
          (element) => element.mapsId.value == "temp",
          orElse: () => Circle(circleId: CircleId("temp")));
    }
    Marker defMarker;
    Circle defCircle;

    if (_markers.contains(toRemove)) {
      _markers.remove(toRemove);
      _circles.remove(toRemoveCircle);
      notifyListeners();
    } else {
      if (coord != null) {
        coordinates = coord;
        location.text =
            "${coord.latitude.toString()}, ${coord.longitude.toString()}";

        findLocalByCoordinates(
            coordinates.latitude.toString(), coordinates.longitude.toString(),
            projectAddService: projectservice);
      }

      //TODO: always color green

      if (isEdit) {
        defMarker = Marker(
            onTap: () {},
            zIndex: 20,
            icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(),
                colorsSettingsStatus[statusDefault].circleAsset!),
            markerId: MarkerId(projectId!),
            position: coord!);

        defCircle = Circle(
            fillColor: Color.fromRGBO(60, 120, 225, 0.1),
            circleId: CircleId(
              projectId,
            ),
            radius: areaSize!,
            strokeWidth: 1,
            strokeColor: Colors.black12,
            center: coord);
      } else {
        defMarker = Marker(
            onTap: () {},
            zIndex: 20,
            icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(),
                colorsSettingsStatus[statusDefault].circleAsset!),
            markerId: MarkerId("temp"),
            position: coord!);

        defCircle = Circle(
            fillColor: Color.fromRGBO(60, 120, 225, 0.1),
            circleId: CircleId(
              "temp",
            ),
            radius: areaSize!,
            strokeWidth: 1,
            strokeColor: Colors.black12,
            center: coord);
      }

      _markers.add(defMarker);
      _circles.add(defCircle);
      notifyListeners();
    }

    if (!isClick!) {
      mapController!.moveCamera(CameraUpdate.newLatLng(coordinates));
    }

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

  Future findLocalByCoordinates(String lat, String lang,
      {var projectAddService}) async {
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
        var splitAdd = addressGeo.split(" ");
        splitAdd.removeAt(0);
        var concatenate = StringBuffer();

        splitAdd.forEach((item) {
          concatenate.write(item + " ");
        });

        _address = concatenate.toString();
        notifyListeners();
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    projectAddService.setaddressController = _address;
    notifyListeners();
    notifyListeners();
    return "";
  }
}
