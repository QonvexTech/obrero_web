import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/employee/employee_add.dart';
import 'package:uitemplate/view/dashboard/employee/employee_details.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/sample_table.dart';
import 'package:uitemplate/widgets/tablePagination.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeService = Provider.of<EmployeeSevice>(context);
    PaginationService pageService = Provider.of<PaginationService>(context);
    pageService.loadperPageList(employeeService.pagination);
    return Container(
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    AllTable(
                        datas: employeeService.users,
                        rowWidget: rowWidget(
                            context,
                            employeeService.users,
                            employeeService.removeUser,
                            employeeService.setPageScreen),
                        rowWidgetMobile: rowWidgetMobile(
                            context,
                            employeeService.users,
                            employeeService.removeUser,
                            employeeService.setPageScreen),
                        headersMobile: [
                          "NOM",
                          "EMAIL",
                          "STATUS"
                        ],
                        headers: [
                          "NOM",
                          "EMAIL",
                          "TÉLÉPHONE",
                          "ADDRESSE",
                          "STATUS"
                        ]),
                    SizedBox(
                      height: MySpacer.small,
                    ),
                    pageControll(
                        pageService, employeeService.pagination, context)
                  ],
                ),
              ),
            ),
          ),
          //ROW PAGEr
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
                  setPage(page: EmployeeDetails());
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data.status.toString(),
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
                              remove(id: data.id);
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
                  setPage(page: EmployeeDetails());
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
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.status.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  remove(id: data.id);
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
