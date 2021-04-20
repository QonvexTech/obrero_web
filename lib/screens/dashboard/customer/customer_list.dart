import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_add.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_details.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/tablePagination.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          SizedBox(
            height: MySpacer.medium,
          ),
          HeaderList(toPage: CustomerAdd(), title: "Customer"),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
            child: Container(
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
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('EMAIL',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('TÉLÉPHONE',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('ADDRESSE',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('PROJET STATUS',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('DETAILS',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Container()),
                    ],
                    rows: [
                      for (CustomerModel customer in customerService.customers)
                        DataRow(
                            selected: customer.isSelected,
                            onSelectChanged: (value) {
                              print(value);
                              setState(() {
                                customer.isSelected = value!;
                              });
                            },
                            cells: [
                              DataCell(Text(
                                  "${customer.fname!} ${customer.lname!}")),
                              DataCell(Text(customer.email!)),
                              DataCell(Text(customer.contactNumber!)),
                              DataCell(Text(customer.adress!)),
                              DataCell(Text(
                                customer.status!.status == 1
                                    ? "Terminate"
                                    : "En cours",
                                style: TextStyle(
                                    color: customer.status!.status == 1
                                        ? Colors.green
                                        : Colors.orange),
                              )),
                              DataCell(TextButton(
                                  onPressed: () {
                                    customerService.setPage(CustomerDetails(
                                      customer: customer,
                                    ));
                                  },
                                  child: Text("Details"))),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                              backgroundColor:
                                                  Palette.contentBackground,
                                              content: CustomerAdd(
                                                customerToEdit: customer,
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
                                      print(customer.id);
                                      customerService.removeCustomer(
                                          id: customer.id!);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Palette.drawerColor,
                                    ),
                                  )
                                ],
                              ))
                            ])
                    ])),
          ),
          TablePagination(
            paginationModel: customerService.pagination,
          ),
          SizedBox(
            height: MySpacer.large,
          )
        ],
      ),
    );
  }
}
