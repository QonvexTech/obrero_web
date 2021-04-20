import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/screens/dashboard/employee/employee_add.dart';
import 'package:uitemplate/screens/dashboard/employee/employee_details.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/tablePagination.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeService = Provider.of<EmployeeSevice>(context);
    return Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          SizedBox(
            height: MySpacer.medium,
          ),
          HeaderList(toPage: EmployeeAdd(), title: "Employee"),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
              child: employeeService.users.length <= 0
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.now_widgets),
                        Text("No Employees Yet")
                      ],
                    ))
                  : Container(
                      width: double.infinity,
                      child: DataTable(
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
                                label: Text('NOM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('EMAIL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('TÉLÉPHONE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('ADDRESSE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(label: Container()),
                            DataColumn(label: Container()),
                          ],
                          rows: [
                            for (EmployeesModel user in employeeService.users)
                              DataRow(
                                  selected: user.isSelected,
                                  onSelectChanged: (value) {
                                    setState(() {
                                      user.isSelected = value!;
                                    });
                                  },
                                  cells: [
                                    DataCell(
                                        Text("${user.fname!} ${user.lname!}")),
                                    DataCell(Text(user.email!)),
                                    DataCell(Text(user.contactNumber!)),
                                    DataCell(Text(user.address!)),
                                    DataCell(TextButton(
                                        onPressed: () {
                                          employeeService.setActivePageScreen(
                                              EmployeeDetails());
                                        },
                                        child: Text("Details"))),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                    backgroundColor: Palette
                                                        .contentBackground,
                                                    content: EmployeeAdd(
                                                      userToEdit: user,
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
                                            print(user.id);
                                            employeeService.removeUser(
                                                id: user.id!);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Palette.drawerColor,
                                          ),
                                        )
                                      ],
                                    ))
                                  ])
                          ]))),
          //ROW PAGEr
          TablePagination(
            paginationModel: employeeService.pagination,
          ),
          SizedBox(
            height: MySpacer.large,
          )
        ],
      ),
    );
  }
}
