import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/services/map_service.dart';

class ProjectCard extends StatelessWidget {
  final String? name;
  final DateTime? startDate;
  final String? description;
  final LatLng coordinates;
  final int? status;

  ProjectCard(
      {@required this.name,
      @required this.startDate,
      @required this.description,
      required this.coordinates,
      required this.status});

  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    return GestureDetector(
      onTap: () {
        print("Card");
        mapService.focusMap(coordinates: coordinates);
      },
      child: Card(
        child: ListTile(
            leading: CircleAvatar(),
            title: Text(name!),
            subtitle: Text(description!),
            trailing: Image.asset("${imagesStatus[status!]}")),
      ),
    );
  }
}
