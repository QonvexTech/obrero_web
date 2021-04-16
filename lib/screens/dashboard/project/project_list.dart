import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/screens/dashboard/project/project_add.dart';
import 'package:uitemplate/services/project_service.dart';
import 'package:uitemplate/widgets/headerList.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          SizedBox(
            height: MySpacer.medium,
          ),
          HeaderList(toPage: ProjectAdd(), title: "Project"),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
              child: Container(
                  child: ListView(
            children: [
              Consumer<ProjectProvider>(
                builder: (context, data, child) {
                  if (data.projects.length <= 0) {
                    return Container(
                        width: 200,
                        height: 200,
                        child: Column(
                          children: [
                            Icon(Icons.now_widgets),
                            Text("No project Yet")
                          ],
                        ));
                  }
                  return DataTable(
                      headingTextStyle: TextStyle(color: Colors.white),
                      headingRowColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Palette.drawerColor.withOpacity(0.5);
                        } else {
                          return Palette.drawerColor;
                        }
                      }),
                      showCheckboxColumn: true,
                      columns: [
                        DataColumn(
                            label: Text('NOM DU SITE',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('OWNER',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('LOCATION',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('AREA SIZE',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('START DATE',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('END DATE',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Container()),
                      ],
                      rows: [
                        for (ProjectModel project in data.projects)
                          ...widgetRows(context, data, project)
                      ]);
                },
              )
            ],
          ))),
        ],
      ),
    );
  }
}

List<DataRow> widgetRows(
    context, ProjectProvider projectProvider, ProjectModel projectModel) {
  return [
    DataRow(
        onSelectChanged: (value) {
          print("selec");
          // projectProvider.setProjectScreen(ProjectDetails());
        },
        cells: [
          DataCell(
            Text(projectModel.name!),
          ),
          DataCell(Text(projectModel.customerId!.toString())),
          DataCell(Text(projectModel.coordinates.toString())),
          DataCell(Text(projectModel.areaSize.toString())),
          DataCell(Text(projectModel.startDate.toString())),
          DataCell(Text(projectModel.endDate.toString())),
          DataCell(Row(
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          backgroundColor: Palette.contentBackground,
                          content: ProjectAdd(
                            projectToEdit: projectModel,
                          )));
                },
                icon: Icon(
                  Icons.edit,
                  color: Palette.drawerColor,
                ),
              ),
              SizedBox(
                width: 50,
              ),
              IconButton(
                onPressed: () {
                  print("pressdelete");
                  projectProvider.removeProject(id: projectModel.id!);
                },
                icon: Icon(
                  Icons.delete,
                  color: Palette.drawerColor,
                ),
              )
            ],
          ))
        ])
  ];
}
