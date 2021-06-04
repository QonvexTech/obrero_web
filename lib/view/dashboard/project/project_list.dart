import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_details.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/view/dashboard/project/project_details.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/sample_table.dart';
import 'package:uitemplate/widgets/tablePagination.dart';

class ProjectList extends StatefulWidget {
  final bool? assignUser;
  final int? owner;

  const ProjectList({Key? key, required this.assignUser, this.owner = 00})
      : super(key: key);
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  void initState() {
    Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
    PaginationService pageService = Provider.of<PaginationService>(context);

    if (projectProvider.projects == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Palette.contentBackground,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          SizedBox(
            height: MySpacer.medium,
          ),
          HeaderList(
            toPage: ProjectAddScreen(),
            title: "Project",
            search: projectProvider.search,
            searchController: projectProvider.searchController,
          ),
          SizedBox(
            height: MySpacer.large,
          ),
          projectProvider.projects.length == 0
              ? Expanded(
                  child: Container(
                  color: Palette.contentBackground,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.search,
                            size: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      Text("Projet introuvable")
                    ],
                  )),
                ))
              : Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          AllTable(
                            datas: projectProvider.projects,
                            rowWidget: rowWidget(
                              context,
                              projectProvider.projects,
                              projectProvider.removeProject,
                              projectProvider.setPage,
                              projectProvider,
                            ),
                            rowWidgetMobile: rowWidgetMobile(
                              context,
                              projectProvider.projects,
                              projectProvider.removeProject,
                              projectProvider.setPage,
                              projectProvider,
                              widget.owner!,
                              widget.assignUser!,
                            ),
                            headersMobile: ["NOM DU SITE", "OWNER", "ADDRESS"],
                            headers: [
                              "NOM DU SITE",
                              "OWNER",
                              "ADDRESS",
                              "AREA SIZE",
                              "START DATE",
                              "END DATE"
                            ],
                            assignUser: widget.assignUser,
                          ),
                          SizedBox(
                            height: MySpacer.small,
                          ),
                          pageControll(pageService, projectProvider.pagination,
                              context, projectProvider.projects.length)
                        ],
                      ),
                    ),
                  ),
                ),
          SizedBox(
            height: MySpacer.large,
          )
        ],
      ),
    );
  }
}

List<TableRow> rowWidgetMobile(
  BuildContext context,
  List<ProjectModel> datas,
  Function remove,
  Function setPage,
  ProjectProvider projectProvider,
  int owner,
  bool assignUser,
) {
  return [
    for (ProjectModel data in datas)
      TableRow(children: [
        GestureDetector(
          child: TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () {
                    projectProvider.projectOnDetails = data;
                    setPage(
                        page: ProjectDetails(
                      fromPage: "project",
                    ));
                  },
                  child: Text(
                    data.name!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ))),
        ),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  setPage(
                      page: CustomerDetails(
                    customer: data.owner,
                    fromPage: "project",
                  ));
                },
                child: Text(
                  "${data.owner!.fname} ${data.owner!.lname}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "${data.address}",
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: assignUser
              ? Center(
                  child: Container(
                      child: MaterialButton(
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Container()),
                                data.assigneeIds!.contains(owner)
                                    ? Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.green,
                                      ),
                                SizedBox(width: MySpacer.small),
                                Text(data.assigneeIds!.contains(owner)
                                    ? "Resign"
                                    : "Assign"),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
                          onPressed: () {})))
              : PopupMenuButton(
                  padding: EdgeInsets.all(0),
                  offset: Offset(0, 40),
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: Palette.drawerColor,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Palette.drawerColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          backgroundColor:
                                              Palette.contentBackground,
                                          content: ProjectAddScreen(
                                            projectToEdit: data,
                                          )));
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            backgroundColor:
                                                Palette.contentBackground,
                                            content: Expanded(
                                              child: Container(
                                                height: 70,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(
                                                          width: MySpacer.small,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Are you sure to delete "),
                                                            Container(
                                                              width: 100,
                                                              child: Text(
                                                                "${data.name}?",
                                                                style: TextStyle(
                                                                    color: Palette
                                                                        .drawerColor),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: MySpacer.small,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MaterialButton(
                                                          color: Colors.grey,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              MySpacer.medium,
                                                        ),
                                                        MaterialButton(
                                                          color: Palette
                                                              .drawerColor,
                                                          onPressed: () {
                                                            remove(id: data.id);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Confirm",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Palette.drawerColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
        ),
      ])
  ];
}

List<TableRow> rowWidget(
  BuildContext context,
  List<ProjectModel> datas,
  Function remove,
  Function setPage,
  ProjectProvider projectProvider,
) {
  return [
    for (ProjectModel data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                onPressed: () {
                  projectProvider.projectOnDetails = data;
                  setPage(
                      page: ProjectDetails(
                    fromPage: "project",
                  ));
                },
                child: Text(
                  data.name!,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                onPressed: () {
                  setPage(
                      page: CustomerDetails(
                    customer: data.owner,
                    fromPage: "project",
                  ));
                },
                child: Text(
                  "${data.owner!.fname} ${data.owner!.lname}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "${data.address}",
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.areaSize.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                DateFormat('MMM dd, yyyy', 'fr_FR')
                    .format(data.startDate!)
                    .inCaps,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                DateFormat('MMM dd, yyyy', 'fr_FR')
                    .format(data.endDate!)
                    .inCaps,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  print("Assign");
                },
                icon: Icon(
                  Icons.add_circle_outlined,
                  color: Palette.drawerColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          backgroundColor: Palette.contentBackground,
                          content: ProjectAddScreen(
                            projectToEdit: data,
                          )));
                },
                icon: Icon(
                  Icons.edit,
                  color: Palette.drawerColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Palette.contentBackground,
                            content: Expanded(
                              child: Container(
                                height: 70,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: MySpacer.small,
                                        ),
                                        Row(
                                          children: [
                                            Text("Are you sure to delete "),
                                            Container(
                                              width: 100,
                                              child: Text(
                                                "${data.name}?",
                                                style: TextStyle(
                                                    color: Palette.drawerColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: MySpacer.small,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          color: Colors.grey,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        SizedBox(
                                          width: MySpacer.medium,
                                        ),
                                        MaterialButton(
                                          color: Palette.drawerColor,
                                          onPressed: () {
                                            remove(id: data.id);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Confirm",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                icon: Icon(
                  Icons.delete,
                  color: Palette.drawerColor,
                ),
              )
            ],
          ),
        ),
      ])
  ];
}
