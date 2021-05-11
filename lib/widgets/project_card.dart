import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/project/project_details.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel? project;

  const ProjectCard({Key? key, this.project}) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SettingsHelper {
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    DashboardService dashboardService = Provider.of<DashboardService>(context);
    return GestureDetector(
        onTap: () {
          mapService.focusMap(coordinates: widget.project!.coordinates!);
          dashboardService.selectedPrject = widget.project!.id;
        },
        child: AnimatedContainer(
          width: 200,
          duration: Duration(milliseconds: 200),
          child: Card(
              elevation: dashboardService.selectedProject == widget.project!.id
                  ? 5
                  : 0,
              child: Stack(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Palette.contentBackground,
                      backgroundImage: widget.project!.images!.length > 0
                          ? fetchImage(
                              netWorkImage: widget.project!.images![0].url)
                          : AssetImage('images/emptyImage.jpg'),
                    ),
                    title: Row(
                      children: [
                        Text(widget.project!.name!),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "${months[widget.project!.startDate!.month]} ${widget.project!.startDate!.day}, ${widget.project!.startDate!.year}",
                            style: TextStyle(color: Colors.black12),
                          ),
                        ),
                        Expanded(child: Container()),
                        IconButton(
                          onPressed: () {
                            mapService.focusMap(
                                coordinates: widget.project!.coordinates!);
                            dashboardService.selectedPrject =
                                widget.project!.id;
                            print("icon");
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    backgroundColor: Palette.contentBackground,
                                    content: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: ProjectDetails(
                                          projectModel: widget.project,
                                          fromPage: "dashboard"),
                                    )));
                          },
                          icon: Icon(
                            Icons.more_horiz_rounded,
                            color: Palette.drawerColor,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(widget.project!.description!),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Icon(
                      Icons.circle,
                      color: statusColors[widget.project!.status!],
                      size: 15,
                    ),
                  )
                ],
              )),
        ));
  }
}
