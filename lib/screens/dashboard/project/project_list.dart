import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/screens/dashboard/project/project_add.dart';
import 'package:uitemplate/screens/dashboard/project/project_details.dart';
import 'package:uitemplate/services/project_service.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectProvider projectService = Provider.of<ProjectProvider>(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
              ),
              Text("Page ${projectService.page}"),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
              MaterialButton(
                color: Palette.buttonsColor1,
                padding: EdgeInsets.all(5),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: ProjectAdd(),
                          ));
                },
                child: Row(
                  children: [Icon(Icons.add), Text("Project")],
                ),
              )
            ],
          ),
          Expanded(
              child: Container(
                  child: ListView(
            children: [
              Consumer<ProjectProvider>(
                builder: (context, data, child) {
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
                        // DataColumn(
                        //     label: Text('CLIENT',
                        //         style: TextStyle(fontWeight: FontWeight.bold))),
                        // DataColumn(
                        //     label: Text('COORDINATES',
                        //         style: TextStyle(fontWeight: FontWeight.bold))),
                        // DataColumn(
                        //     label: Text('ADRESSE',
                        //         style: TextStyle(fontWeight: FontWeight.bold))),
                        // DataColumn(
                        //     label: Text('PROJET STATUS',
                        //         style: TextStyle(fontWeight: FontWeight.bold))),

                        DataColumn(label: Container()),
                      ],
                      rows: [
                        for (ProjectModel project in data.projects)
                          ...widgetRows(context, project.name!, data)
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

List<DataRow> widgetRows(context, String name, ProjectProvider project) {
  return [
    DataRow(
        onSelectChanged: (value) {
          print("selec");
          print(value);
          project.setProjectScreen(ProjectDetails());
        },
        cells: [
          DataCell(
            Text(name),
          ),
          // DataCell(Text(date.toString())),
          // DataCell(Text(description.toString())),
          // DataCell(Text("${coordinates[0]}${coordinates[1]}")),
          // DataCell(Text(id.toString())),
          DataCell(Row(
            children: [
              Icon(
                Icons.edit,
                color: Palette.drawerColor,
              ),
              SizedBox(
                width: 50,
              ),
              IconButton(
                onPressed: () {
                  print("pressdelete");
                  // Provider.of<ProjectProvider>(context).removeProject();
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
