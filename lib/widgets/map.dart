import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/map_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final LatLng _latLng = LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;

  Set<Marker> _markers = {};

  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context, listen: false);
    _markers.add(
      Marker(
        markerId: MarkerId("marker_id"),
        position: _latLng,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "I am here",
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      color: Colors.white,
                                    ),
                          )
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Triangle.isosceles(
                //   edge: Edge.BOTTOM,
                //   child: Container(
                //     color: Colors.blue,
                //     width: 20.0,
                //     height: 10.0,
                //   ),
                // ),
              ],
            ),
            _latLng,
          );
        },
      ),
    );

    return Stack(
      children: <Widget>[
        GoogleMap(
            onTap: (position) {
              mapService
                  .setCoordinates("${position.latitude},${position.longitude}");
              print(position);
            },
            initialCameraPosition:
                CameraPosition(target: _latLng, zoom: _zoom)),
        // GoogleMap(
        //   onTap: (position) {
        //     print("tapping");
        //     // _customInfoWindowController.hideInfoWindow!();
        //     mapService.coordinates([position.latitude, position.longitude]);
        //   },
        //   // onCameraMove: (position) {
        //   //   _customInfoWindowController.onCameraMove!();
        //   // },
        //   // onMapCreated: (GoogleMapController controller) async {
        //   //   _customInfoWindowController.googleMapController = controller;
        //   // },
        //   markers: _markers,
        //   initialCameraPosition: CameraPosition(
        //     target: _latLng,
        //     zoom: _zoom,
        //   ),
        // ),
        CustomInfoWindow(
          controller: _customInfoWindowController,
          height: 75,
          width: 150,
          offset: 50,
        ),
      ],
    );
  }

  // Marker createMark({required LatLng coord}) {
  //   return Marker(
  //       markerId: MarkerId("NewMarker${_markers.length + 1}"), position: coord);
  // }
}
