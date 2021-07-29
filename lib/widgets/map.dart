import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';

class MapScreen extends StatefulWidget {
  final bool? setCoord;
  final Function? onCreate;
  final double areaSize;
  final bool isEdit;
  final String projectId;
  const MapScreen({
    required this.projectId,
    required this.isEdit,
    required this.setCoord,
    required this.onCreate,
    required this.areaSize,
    Key? key,
  }) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    ProjectAddService projectAddScreen =
        Provider.of<ProjectAddService>(context);
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
                      widget.onCreate!();
                    });
                  },
                  myLocationButtonEnabled: true,
                  rotateGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: initialPositon,
                    zoom: mapService.zoom,
                  ),
                  buildingsEnabled: true,
                  mapType: MapType.none,
                  myLocationEnabled: true,
                  markers: mapService.markers,
                  circles: mapService.circles,
                  onTap: (LatLng coord) {
                    if (widget.setCoord!) {
                      setState(() {
                        mapService.setCoordinates(
                            projectservice: projectAddScreen,
                            coord: coord,
                            context: context,
                            areaSize: widget.areaSize,
                            isEdit: widget.isEdit,
                            projectId: widget.projectId,
                            isClick: true);
                        ;
                      });
                    }
                  },
                ),
              ),
      ],
    );
  }
}
