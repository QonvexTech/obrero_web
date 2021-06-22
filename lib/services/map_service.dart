import 'dart:convert';
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

  void changeAreaSize(area, coord) {
    _circles.removeWhere((element) => element.circleId.value == "temp");
    _circles.add(Circle(
        fillColor: Color.fromRGBO(60, 120, 225, 0.2),
        circleId: CircleId(
          "temp",
        ),
        radius: area / 2,
        strokeWidth: 1,
        strokeColor: Colors.black12,
        center: coord));
    notifyListeners();
  }

  void removeDefaultMarker() {
    _markers.removeWhere((element) => element.markerId.value == "temp");
    _circles.removeWhere((element) => element.circleId.value == "temp");
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

  mapInit(List<ProjectModel> projects, context) async {
    if (_markers.length > 0) {
      coordinates = _markers.first.position;
      location.text =
          "${coordinates.latitude.toString()}, ${coordinates.longitude.toString()}";
      findLocalByCoordinates(
          coordinates.latitude.toString(), coordinates.longitude.toString());
      _markers.clear();
      _circles.clear();
    }

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
                colorsSettings[project.status!].circleAsset!),
            markerId: MarkerId(project.id.toString()),
            position: project.coordinates!));

        _circles.add(Circle(
            fillColor: Color.fromRGBO(60, 120, 225, 0.2),
            circleId: CircleId(
              project.id.toString(),
            ),
            radius: 1000 / project.areaSize!,
            strokeWidth: 1,
            strokeColor: Colors.black12,
            center: project.coordinates!));
      }
      print("CIRCLE: ${_circles.length}");
    } catch (e) {
      print(e);
    }
    print("markers : ${_markers.length}");

    notifyListeners();
  }

  void setCoordinates(
      {LatLng? coord, BuildContext? context, double? areaSize}) async {
    Marker toRemove = _markers.firstWhere(
        (element) => element.mapsId.value == "temp",
        orElse: () => Marker(markerId: MarkerId("temp")));

    Circle toRemoveCircle = _circles.firstWhere(
        (element) => element.mapsId.value == "temp",
        orElse: () => Circle(circleId: CircleId("temp")));

    if (_markers.contains(toRemove)) {
      _markers.remove(toRemove);
      _circles.remove(toRemoveCircle);
    } else {
      if (coord != null) {
        coordinates = coord;
        location.text =
            "${coord.latitude.toString()}, ${coord.longitude.toString()}";
        findLocalByCoordinates(
            coord.latitude.toString(), coord.longitude.toString());
      }

      //TODO: always color green
      Marker defMarker = Marker(
          onTap: () {},
          zIndex: 20,
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(), "assets/icons/green.png"),
          markerId: MarkerId("temp"),
          position: coord!);

      Circle defCircle = Circle(
          fillColor: Color.fromRGBO(60, 120, 225, 0.2),
          circleId: CircleId(
            "temp",
          ),
          radius: 1000 / areaSize!,
          strokeWidth: 1,
          strokeColor: Colors.black12,
          center: coord);

      _markers.add(defMarker);
      _circles.add(defCircle);
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
        var splitAdd = addressGeo.split(" ");
        splitAdd.removeAt(0);
        var concatenate = StringBuffer();

        splitAdd.forEach((item) {
          concatenate.write(item + " ");
        });
        address.text = concatenate.toString();

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
