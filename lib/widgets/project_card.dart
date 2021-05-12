import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/project/project_details.dart';
import 'package:universal_html/html.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel? project;

  const ProjectCard({Key? key, this.project}) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SettingsHelper {
  bool viewMore = false;
  @override
  Widget build(BuildContext context) {
    MapService mapService = Provider.of<MapService>(context);
    DashboardService dashboardService = Provider.of<DashboardService>(context);
    return GestureDetector(
        onTap: () {
          mapService.focusMap(
              coordinates: widget.project!.coordinates!,
              markerId: widget.project!.id.toString());
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Du ${months[widget.project!.startDate!.month]} ${widget.project!.startDate!.day}, ${widget.project!.startDate!.year} Au ${months[widget.project!.endDate!.month]} ${widget.project!.endDate!.day}, ${widget.project!.endDate!.year}",
                                style: TextStyle(color: Colors.black12),
                              ),
                            ),
                            Expanded(child: Container()),
                            IconButton(
                              onPressed: () {
                                mapService.focusMap(
                                    coordinates: widget.project!.coordinates!,
                                    markerId: widget.project!.id.toString());
                                dashboardService.selectedPrject =
                                    widget.project!.id;
                                print("icon");
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
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.project!.description!),
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
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 59,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
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
                                                padding: const EdgeInsets.only(
                                                    right: 20),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 15,
                                                      color: statusColors[0],
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
                      top: 5,
                      left: 5,
                      child: Image.asset(
                        imagesStatus[0],
                        width: 20,
                      ))
                ],
              )),
        ));
  }
}
