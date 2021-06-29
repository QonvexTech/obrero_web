import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControls {
  void focusMap(
      {required LatLng coordinates,
      required markerId,
      required mapController}) {
    mapController!.showMarkerInfoWindow(MarkerId(markerId));
    mapController!.moveCamera(CameraUpdate.newLatLng(coordinates));
    // notifyListeners();
  }
}
