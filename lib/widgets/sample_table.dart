import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_add.dart';

class TableExample extends StatefulWidget {
  @override
  _TableExampleState createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return Table(
      border: TableBorder.all(
          color: Colors.black26, width: 1, style: BorderStyle.solid),
      children: [
        //HEADER
        MediaQuery.of(context).size.width <= 400
            ? TableRow(
                decoration: BoxDecoration(color: Palette.drawerColor),
                children: [
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'NOM',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'EMAIL',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'STATUS',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              '',
                              style: TextStyle(color: Colors.white),
                            )))),
                  ])
            : TableRow(
                decoration: BoxDecoration(color: Palette.drawerColor),
                children: [
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'NOM',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'EMAIL',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'TÉLÉPHONE',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'ADDRESSE',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              'STATUS',
                              style: TextStyle(color: Colors.white),
                            )))),
                    TableCell(
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                              '',
                              style: TextStyle(color: Colors.white),
                            )))),
                  ]),
        for (CustomerModel customer in customerService.customers)
          MediaQuery.of(context).size.width <= 400
              ? TableRow(children: [
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
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
                                    content: CustomerAdd(
                                      customerToEdit: customer,
                                    )));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Palette.drawerColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            print(customer.id);
                            customerService.removeCustomer(id: customer.id!);
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
              : TableRow(children: [
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Center(child: Text('val'))),
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
                                    content: CustomerAdd(
                                      customerToEdit: customer,
                                    )));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Palette.drawerColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            print(customer.id);
                            customerService.removeCustomer(id: customer.id!);
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
        // TableRow(children: [
        //   TableCell(child: Center(child: Text('Value'))),
        //   TableCell(
        //     child: Center(child: Text('Value')),
        //   ),
        //   TableCell(child: Center(child: Text('Value'))),
        //   TableCell(child: Center(child: Text('Value'))),
        // ]),
        // TableRow(children: [
        //   TableCell(child: Center(child: Text('Value'))),
        //   TableCell(
        //     child: Center(child: Text('Value')),
        //   ),
        //   TableCell(child: Center(child: Text('Value'))),
        //   TableCell(child: Center(child: Text('Value'))),
        // ])
      ],
    );
  }
}
