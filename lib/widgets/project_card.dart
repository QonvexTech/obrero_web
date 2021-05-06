import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_image_model.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/settings/helper.dart';

class ProjectCard extends StatefulWidget {
  final String? name;
  final DateTime? startDate;
  final String? description;
  final LatLng coordinates;
  final int? status;
  final List<ProjectImageModel>? picture;

  ProjectCard(
      {@required this.name,
      @required this.startDate,
      @required this.description,
      required this.coordinates,
      required this.status,
      required this.picture});

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SettingsHelper {
  @override
  void initState() {
    // print(widget.picture!.length);
    print(widget.coordinates);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    return GestureDetector(
      onTap: () {
        mapService.focusMap(coordinates: widget.coordinates);
      },
      child: Card(
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Palette.contentBackground,
              backgroundImage: widget.picture!.length > 0
                  ? fetchImage(netWorkImage: widget.picture![0].url)
                  : AssetImage('images/emptyImage.jpg'),
            ),
            title: Text(widget.name!),
            subtitle: Text(widget.description!),
            trailing: Image.asset("${imagesStatus[widget.status!]}")),
      ),
    );
  }
}
