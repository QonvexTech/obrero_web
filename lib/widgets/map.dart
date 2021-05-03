import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/map_service.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialCoord;
  const MapScreen({Key? key, this.initialCoord}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool firsTap = false;
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    return GoogleMap(
        buildingsEnabled: true,
        onMapCreated: (controller) {
          mapService.mapController = controller;
          mapService.setCoordinates();
        },
        mapType: MapType.none,
        myLocationEnabled: true,
        markers: mapService.markers,
        onTap: (position) {
          mapService.setCoordinates(coord: position);
        },
        initialCameraPosition: CameraPosition(
            target: widget.initialCoord == null
                ? mapService.coordinates
                : widget.initialCoord!,
            zoom: mapService.zoom));
  }
}
