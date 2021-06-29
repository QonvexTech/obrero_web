import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/user_location_model.dart';
import 'package:uitemplate/services/firestore_service.dart';
import 'package:uitemplate/services/map_service.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final FirestoreService _firestoreService = FirestoreService.instance;

  late MapService mapService = Provider.of<MapService>(
    context,
  );
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: _firestoreService.firebaseInit,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.collectionReference.snapshots(),
              builder: (_, firestoreSnap) {
                if (firestoreSnap.hasError) {
                  return Center(
                    child: Text("SERVER ERROR : ${firestoreSnap.error}"),
                  );
                }
                if (firestoreSnap.hasData) {
                  List<UserLocationModel> data = firestoreSnap.data!.docs
                      .toList()
                      .map((DocumentSnapshot documentSnapshot) {
                    Map<String, dynamic> mappedData =
                        documentSnapshot.data() as Map<String, dynamic>;
                    return UserLocationModel.fromJson(mappedData);
                  }).toList();
                  Set<Marker> markers;
                  markers = data
                      .map((e) => new Marker(
                          markerId: MarkerId("${e.id + Random().nextInt(20)}"),
                          visible: e.isActive,
                          position: LatLng(
                              double.parse(e.location.split(',')[0].toString()),
                              double.parse(
                                  e.location.split(',')[1].toString()))))
                      .toSet();
                  markers.addAll(mapService.markers);
                  Completer<GoogleMapController> _controller = Completer();
                  return GoogleMap(
                    scrollGesturesEnabled: mapService.gesture,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
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
                    markers: markers,
                    circles: mapService.circles,
                  );
                }
                return Center(
                  child: Text("Connecting..."),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
