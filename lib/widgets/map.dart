import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/services/map_service.dart';

class MapScreen extends StatefulWidget {
  final bool? setCoord;
  const MapScreen({
    this.setCoord,
    Key? key,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);

    return Stack(
      children: [
        initialPositon == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : InkWell(
                onHover: (value) {
                  print(value);
                },
                child: GoogleMap(
                  scrollGesturesEnabled: mapService.gesture,
                  onMapCreated: (controller) {
                    setState(() {
                      mapService.mapController = controller;
                    });
                  },
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: initialPositon!,
                    zoom: mapService.zoom,
                  ),
                  buildingsEnabled: true,
                  mapType: MapType.none,
                  myLocationEnabled: true,
                  markers: mapService.markers,
                ),
              ),
      ],
    );
  }
}
