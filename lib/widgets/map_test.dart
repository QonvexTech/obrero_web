import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

LatLng? _initialPositon;

Future<LatLng> _getPosition() async {
  final Location location = Location();
  if (!await location.serviceEnabled()) {
    if (!await location.requestService()) throw 'GPS service is disabled';
  }
  if (await location.hasPermission() == PermissionStatus.denied) {
    if (await location.requestPermission() != PermissionStatus.granted)
      throw 'No GPS permissions';
  }
  final data = await location.getLocation();
  return LatLng(data.latitude!, data.longitude!);
}

class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  GoogleMapController? _controller;

  final origCtrl = TextEditingController();

  final destCtrl = TextEditingController();

  final polylines = Set<Polyline>();

  final markers = Set<Marker>();

  final geoMethods = GeoMethods(
    googleApiKey: 'GOOGLE_API_KEY',
    language: 'fr',
    country: 'fr',

    /// commented for use case
    countryCodes: [
      /// to autocomplete addresses from multicountry
      'ec', //ecuador
      'co', //colombia
      'ar', //argentina
      'es', //españa
      'br', //brazil
    ],
  );

  void init() async {
    _initialPositon = await _getPosition();
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Plugin example app'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              rotateGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _initialPositon!,
                zoom: 14.5,
              ),
              onMapCreated: (GoogleMapController controller) =>
                  _controller = controller,
            ),
          ),
          RouteSearchBox(
            /// we need to specify a countryCode to get routes because countryCode parameter was commented
            geoMethods: geoMethods.copyWith(countryCodeParam: 'er'),
            originCtrl: origCtrl,
            destinationCtrl: destCtrl,
            builder: (context, originBuilder, destinationBuilder,
                {waypointBuilder, getDirections, relocate, waypointsMgr}) {
              if (origCtrl.text.isEmpty)
                relocate!(AddressId.origin, _initialPositon!.toCoords());
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                color: Colors.green[50],
                height: 150.0,
                child: Column(
                  children: [
                    TextField(
                      controller: origCtrl,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => originBuilder.buildDefault(
                          builder: AddressDialogBuilder(),
                          onDone: (address) => null,
                        ),
                      ),
                    ),
                    TextField(
                      controller: destCtrl,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => destinationBuilder.buildDefault(
                          builder: AddressDialogBuilder(),
                          onDone: (address) => null,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text('Points'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) =>
                                  Waypoints(waypointsMgr, waypointBuilder),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          child: Text('Relocate'),
                          onPressed: () async => relocate!(AddressId.origin,
                              Coords.fromJson(_getPosition())),
                        ),
                        ElevatedButton(
                          child: Text('Search'),
                          onPressed: () async {
                            try {
                              final result = await getDirections!();
                              markers.clear();
                              polylines.clear();
                              markers.addAll([
                                Marker(
                                    markerId: MarkerId('origin'),
                                    position: result.origin.coords!),
                                Marker(
                                    markerId: MarkerId('dest'),
                                    position: result.destination.coords!)
                              ]);
                              result.waypoints.asMap().forEach((key, value) =>
                                  markers.add(Marker(
                                      markerId: MarkerId('point$key'),
                                      position: value.coords!)));
                              polylines.add(Polyline(
                                polylineId: PolylineId('result'),
                                points: result.points,
                                color: Colors.blue,
                                width: 5,
                              ));
                              setState(() {});
                              await _controller!.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      result.bounds, 60.0));
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Waypoints extends StatelessWidget {
  const Waypoints(this.waypointsMgr, this.waypointBuilder);

  final WaypointsManager? waypointsMgr;
  final AddressSearchBuilder? waypointBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => waypointBuilder!.buildDefault(
                builder: AddressDialogBuilder(),
                onDone: (address) => null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
