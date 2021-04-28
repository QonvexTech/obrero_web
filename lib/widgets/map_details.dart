import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/map_service.dart';

class MapDetails extends StatelessWidget {
  final int myCrossAxis;
  final Color mapColor;
  final List<ProjectModel>? project;

  const MapDetails(
      {Key? key,
      this.myCrossAxis = 2,
      this.mapColor = Colors.green,
      required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    return GridView.count(
      childAspectRatio: 15,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(project!.length, (index) {
        return GridTile(
            child: GestureDetector(
          onTap: () {
            print("Locate Map");
            mapService.setCoordinates(coord: project![index].coordinates!);
          },
          child: Container(
              child: Center(
                  child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: mapColor),
              ),
              SizedBox(
                width: MySpacer.small,
              ),
              Text(project![index].name!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                width: MySpacer.large,
              ),
              Flexible(
                child: Text(
                  project![index].coordinates!.latitude.toString() +
                      " , " +
                      project![index].coordinates!.longitude.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ))),
        ));
      }),
    );
  }
}
