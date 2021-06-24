import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/project/project_details.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel? project;
  final bool? lastIndex;

  const ProjectCard({Key? key, this.project, required this.lastIndex})
      : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SettingsHelper {
  bool viewMore = false;
  @override
  Widget build(BuildContext context) {
    DashboardService dashboardService = Provider.of<DashboardService>(context);
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
    MapService mapService = Provider.of<MapService>(context);
    return GestureDetector(
        onTap: () {
          dashboardService.focusMap(
              coordinates: widget.project!.coordinates!,
              markerId: widget.project!.id.toString());
          dashboardService.selectedPrject = widget.project!.id;
        },
        child: AnimatedContainer(
          margin: widget.lastIndex!
              ? EdgeInsets.only(bottom: 100)
              : EdgeInsets.only(bottom: 0.0),
          padding: EdgeInsets.symmetric(
              horizontal: dashboardService.selectedProject == widget.project!.id
                  ? 0
                  : 10),
          duration: Duration(milliseconds: 200),
          child: Card(
              elevation: dashboardService.selectedProject == widget.project!.id
                  ? 5
                  : 0,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: CircleAvatar(
                            backgroundColor: Palette.contentBackground,
                            backgroundImage: widget.project!.images!.length > 0
                                ? fetchImage(
                                    netWorkImage:
                                        widget.project!.images![0].url)
                                : AssetImage('images/emptyImage.jpg'),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.project!.name!),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Opacity(
                                        opacity: 0.6,
                                        child: Text(
                                          "Du ${months[widget.project!.startDate!.month]} ${widget.project!.startDate!.day}, ${widget.project!.startDate!.year} Au ${months[widget.project!.endDate!.month]} ${widget.project!.endDate!.day}, ${widget.project!.endDate!.year}",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                mapService.gesture = false;
                                dashboardService.focusMap(
                                    coordinates: widget.project!.coordinates!,
                                    markerId: widget.project!.id.toString());
                                dashboardService.selectedPrject =
                                    widget.project!.id;
                                print("icon");
                                projectProvider.projectOnDetails =
                                    widget.project;
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        backgroundColor:
                                            Palette.contentBackground,
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: ProjectDetails(
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
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(right: 50, bottom: 10),
                                width: viewMore
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Text(widget.project!.description!,
                                    maxLines: viewMore ? 5 : 2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            viewMore
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 5),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            viewMore = !viewMore;
                                          });
                                        },
                                        child: Text("Voir Plus")),
                                  ),
                          ],
                        ),
                      ),
                      viewMore
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 23, vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 59,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Address : ",
                                            ),
                                            Text(
                                              "${widget.project!.address}",
                                              style: boldText,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: MySpacer.small,
                                        ),
                                        Text(
                                          "Équipe sur place",
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 20),
                                          height: 40,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              for (var x = 0;
                                                  x <=
                                                      widget.project!.assignees!
                                                              .length -
                                                          1;
                                                  x++)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 15,
                                                        color: widget
                                                                    .project!
                                                                    .assignees![
                                                                        x]
                                                                    .userStatus ==
                                                                null
                                                            ? Colors.grey
                                                            : widget.project!
                                                                            .assignees![x].userStatus![
                                                                        "time_in"] !=
                                                                    null
                                                                ? widget.project!.assignees![x].userStatus![
                                                                            "time_out"] !=
                                                                        null
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .green
                                                                : Colors.grey,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          "${widget.project!.assignees![x].fname}")
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      viewMore
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 30, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          viewMore = !viewMore;
                                        });
                                      },
                                      child: Text("Voir Moins"))
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    child: colorsSettings.length > 0
                        ? Image.asset(
                            colorsSettings[widget.project!.status!]
                                .circleAsset!,
                            width: 20,
                          )
                        : SizedBox(),
                  )
                ],
              )),
        ));
  }
}
