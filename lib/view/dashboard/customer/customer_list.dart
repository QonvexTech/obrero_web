import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_add.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/sample_table.dart';
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AllTable(
                      datas: customerService.customers,
                      rowWidget: rowWidget(context, customerService.customers,
                          customerService.removeCustomer),
                      rowWidgetMobile: rowWidgetMobile(
                          context,
                          customerService.customers,
                          customerService.removeCustomer),
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
                  TablePagination(paginationModel: customerService.pagination)
                ],
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
    BuildContext context, List<CustomerModel> datas, Function remove) {
  return [
    for (var data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data.fname!,
                overflow: TextOverflow.ellipsis,
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
              offset: Offset(-40, 20),
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
                                      content: CustomerAdd(
                                        customerToEdit: data,
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

List<TableRow> rowWidget(
    BuildContext context, List<CustomerModel> datas, Function remove) {
  return [
    for (var data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.fname!,
                overflow: TextOverflow.ellipsis,
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
                data.adress!,
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
                          content: CustomerAdd()));
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