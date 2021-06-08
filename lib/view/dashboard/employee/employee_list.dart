import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/employee/employee_add.dart';
import 'package:uitemplate/view/dashboard/employee/employee_details.dart';
import 'package:uitemplate/view/dashboard/employee/employee_projects.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/sample_table.dart';
import 'package:uitemplate/widgets/tablePagination.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeService = Provider.of<EmployeeSevice>(context);
    PaginationService pageService = Provider.of<PaginationService>(context);

    return employeeService.users == null
        ? Container(
            color: Palette.contentBackground,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            color: Palette.contentBackground,
            child: Column(
              children: [
                SizedBox(
                  height: MySpacer.medium,
                ),
                HeaderList(
                  toPage: EmployeeAdd(),
                  title: "Employee",
                  search: employeeService.search,
                  searchController: employeeService.searchController,
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
                employeeService.users!.length == 0
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
                            Text("Employé introuvable")
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
                                  datas: employeeService.users,
                                  rowWidget: rowWidget(
                                      context,
                                      employeeService.users!,
                                      employeeService.removeUser,
                                      employeeService.setPageScreen),
                                  rowWidgetMobile: rowWidgetMobile(
                                      context,
                                      employeeService.users!,
                                      employeeService.removeUser,
                                      employeeService.setPageScreen),
                                  headersMobile: [
                                    "NOM",
                                    "EMAIL",
                                    "ADDRESSE",
                                    "ACTIONS"
                                  ],
                                  headers: [
                                    "NOM",
                                    "EMAIL",
                                    "TÉLÉPHONE",
                                    "ADDRESSE",
                                    "ACTIONS"
                                  ],
                                  assignUser: false,
                                ),
                                SizedBox(
                                  height: MySpacer.small,
                                ),
                                pageControll(
                                    pageService,
                                    employeeService.pagination,
                                    context,
                                    employeeService.users!.length)
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

List<TableRow> rowWidgetMobile(BuildContext context, List<EmployeesModel> datas,
    Function remove, Function setPage) {
  return [
    for (EmployeesModel data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  setPage(
                      page: EmployeeDetails(
                    employeesModel: data,
                  ));
                },
                child: Text(
                  "${data.fname!} ${data.lname!}",
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
                data.email!,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.address!,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
          child: PopupMenuButton(
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
                                Icons.work,
                                color: Palette.drawerColor,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        backgroundColor:
                                            Palette.contentBackground,
                                        content: EmployeeProjectsDetails(
                                          emplyoyee: data,
                                        )));
                              }),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      backgroundColor:
                                          Palette.contentBackground,
                                      content: EmployeeAdd(
                                        userToEdit: data,
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
                                                          .spaceBetween,
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
                                                        Text(
                                                            "${data.fname} ${data.lname}?",
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .drawerColor))
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
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    SizedBox(
                                                      width: MySpacer.medium,
                                                    ),
                                                    MaterialButton(
                                                      color:
                                                          Palette.drawerColor,
                                                      onPressed: () {
                                                        remove(id: data.id);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Confirm",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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

List<TableRow> rowWidget(BuildContext context, List<EmployeesModel> datas,
    Function remove, Function setPage) {
  return [
    for (EmployeesModel data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                onPressed: () {
                  setPage(
                      page: EmployeeDetails(
                    employeesModel: data,
                  ));
                },
                child: Text(
                  "${data.fname!} ${data.lname!}",
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
                data.email!,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.contactNumber!,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.address!,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.work,
                    color: Palette.drawerColor,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                            backgroundColor: Palette.contentBackground,
                            content: EmployeeProjectsDetails(
                              emplyoyee: data,
                            )));
                  }),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          backgroundColor: Palette.contentBackground,
                          content: EmployeeAdd(
                            userToEdit: data,
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
                                            Text("${data.fname} ${data.lname}?",
                                                style: TextStyle(
                                                    color: Palette.drawerColor))
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
