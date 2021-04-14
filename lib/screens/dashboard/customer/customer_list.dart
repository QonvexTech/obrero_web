import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_add.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/widgets/adding_button.dart';
import 'package:uitemplate/widgets/searchBox.dart';

class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          SizedBox(
            height: MySpacer.large,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Clients",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Container(width: 300, child: SearchBox()),
                Icon(Icons.filter_list),
                Expanded(child: Container()),

                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.chevron_left),
                // ),
                // Text("Page ${customerService.page}"),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.chevron_right),
                // ),
                AddingButton(
                  addingPage: CustomerAdd(),
                  buttonText: "Créer",
                )
              ],
            ),
          ),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
              child: customerService.customers.length <= 0
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.now_widgets),
                        Text("No clients Yet")
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
                            DataColumn(
                                label: Text('PROJET STATUS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(label: Container()),
                          ],
                          rows: [
                            // for (CustomerModel customer in customerService.customers)
                            ...widgetRows(customerService)
                          ]))),
        ],
      ),
    );
  }
}

List<DataRow> widgetRows(CustomerService customerService) {
  return [
    for (CustomerModel customer in customerService.customers)
      DataRow(
          // selected: isSelected,
          // onSelectChanged: (value) => toggle(value),
          cells: [
            DataCell(Text(customer.fname!)),
            DataCell(Text(customer.email!)),
            DataCell(Text(customer.contactNumber!)),
            DataCell(Text(customer.adress!)),
            DataCell(Text(
              customer.status!.status == 1 ? "Terminate" : "En cours",
              style: TextStyle(
                  color: customer.status!.status == 1
                      ? Colors.green
                      : Colors.orange),
            )),
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
                    customerService.removeCustomer(customer.id!);
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
