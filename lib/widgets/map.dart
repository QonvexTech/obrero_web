import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/models/mapInfo_model.dart';
import 'package:uitemplate/services/map_service.dart';

class MapScreen extends StatefulWidget {
  final LatLng center = LatLng(28.7041, 77.1025);
  final double zoom = 15.0;
  Set<Marker> _markers = {};
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  late Set<Marker> markers = Set.from(widget._markers);
  late Marker myMarker = this.markers.first;

  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;
  List<Marker> dat = [];
  final Map<String, MapInfo> _infoList = {
    "joker": MapInfo("joker", LatLng(28.7041, 77.1025)),
    "batman": MapInfo("joker", LatLng(28.7041, 77.1025)),
  };
  void _oncreated(GoogleMapController controller) {
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    MapService providerObject = Provider.of<MapService>(context, listen: false);
    _infoList.forEach(
      (k, v) => markers.add(
        Marker(
          markerId: MarkerId(v.projectName),
          position: v.location,
          onTap: () {
            providerObject.updateInfoWindow(
              context,
              mapController!,
              v.location,
              _infoWindowWidth,
              _markerOffset,
            );
            providerObject.updateUser(v);
            providerObject.updateVisibility(true);
            providerObject.rebuildInfoWindow();
          },
        ),
      ),
    );
    return Container(
      child: Consumer<MapService>(
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              child!,
              Positioned(
                left: 0,
                top: 0,
                child: Visibility(
                  visible: providerObject.showInfoWindow,
                  child: (providerObject.info == null ||
                          !providerObject.showInfoWindow)
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(
                            left: providerObject.leftMargin,
                            top: providerObject.topMargin,
                          ),
// Custom InfoWindow Widget starts here
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: new LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xffffe6cc),
                                    ],
                                    end: Alignment.bottomCenter,
                                    begin: Alignment.topCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                height: 100,
                                width: 250,
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // Image.network(
                                    //   providerObject.user.image,
                                    //   height: 75,
                                    // ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "This is text",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45,
                                          ),
                                        ),
                                        IconTheme(
                                          data: IconThemeData(
                                            color: Colors.red,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: List.generate(
                                              5,
                                              (index) {
                                                return Icon(
                                                  Icons.star_border,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Triangle.isosceles(
                              //   edge: Edge.BOTTOM,
                              //   child: Container(
                              //     color: Color(0xffffe6cc),
                              //     width: 20.0,
                              //     height: 15.0,
                              //   ),
                              // ),
                            ],
                          ),
// Custom InfoWindow Widget ends here
                        ),
                ),
              ),
            ],
          );
        },
        child: Positioned(
          child: GoogleMap(
            onTap: (position) {
              if (providerObject.showInfoWindow) {
                providerObject.updateVisibility(false);
                providerObject.rebuildInfoWindow();
              }
            },
            onCameraMove: (position) {
              if (providerObject.info != null) {
                providerObject.updateInfoWindow(
                  context,
                  mapController!,
                  providerObject.info.location,
                  _infoWindowWidth,
                  _markerOffset,
                );
                providerObject.rebuildInfoWindow();
              }
            },
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: widget.center,
              zoom: widget.zoom,
            ),
          ),
        ),
      ),
    );
  }

  Marker createMark({required LatLng coord}) {
    return Marker(
        markerId: MarkerId("NewMarker${markers.length + 1}"), position: coord);
  }
}
