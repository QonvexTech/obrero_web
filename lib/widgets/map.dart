import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/map_service.dart';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool firsTap = false;
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    return GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapService.mapController = controller;
          });
        },
        buildingsEnabled: true,
        mapType: MapType.none,
        myLocationEnabled: true,
        markers: mapService.markers,
        onTap: (position) {
          mapService.setCoordinates(coord: position);
        },
        initialCameraPosition: CameraPosition(
            target: mapService.coordinates, zoom: mapService.zoom));
  }
}
