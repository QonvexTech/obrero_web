import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/map_service.dart';

class MapScreen extends StatefulWidget {
  final List<ProjectModel>? projects;
  const MapScreen({Key? key, this.projects}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);

    return GoogleMap(
        // mapType: MapType.satellite,
        myLocationEnabled: true,
        markers: mapService.markers,
        onTap: (position) {
          mapService.setCoordinates(position);
        },
        initialCameraPosition: CameraPosition(
            target: mapService.coordinates, zoom: mapService.zoom));
  }
}
