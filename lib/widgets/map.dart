import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/utils/hand_cursor.dart';

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
    return Stack(
      children: [
        GoogleMap(
            scrollGesturesEnabled: mapService.gesture,
            onMapCreated: (controller) {
              setState(() {
                mapService.mapController = controller;
              });
            },
            buildingsEnabled: true,
            mapType: MapType.none,
            myLocationEnabled: true,
            markers: mapService.markers,
            onTap: mapService.gesture
                ? (position) {
                    mapService.setCoordinates(coord: position);
                  }
                : null,
            initialCameraPosition: CameraPosition(
                target: mapService.coordinates, zoom: mapService.zoom)),
        // Positioned(
        //   bottom: 110,
        //   right: 10,
        //   child: HandCursor(
        //     onHoverFunc: () {
        //       mapService.gesture = false;
        //     },
        //     onExitFun: () {
        //       mapService.gesture = true;
        //     },
        //     child: MaterialButton(
        //       onPressed: () {
        //         print("focus");
        //       },
        //       child: Icon(
        //         Icons.center_focus_strong,
        //         color: Colors.red,
        //         size: 50,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
