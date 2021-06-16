import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/settings/tableHelper.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_add.dart';
import 'package:uitemplate/view/dashboard/customer/customer_details.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/sample_table.dart';
import 'package:uitemplate/widgets/tablePagination.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> with TableHelper {
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerService>(context, listen: false).fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    try {
      CustomerService customerService = Provider.of<CustomerService>(context);
      PaginationService pageService = Provider.of<PaginationService>(context);
      return customerService.customers == null && customerService.loader
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
                    toPage: CustomerAdd(),
                    title: "Customer",
                    search: customerService.search,
                    searchController: customerService.searchController,
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  customerService.customers.length == 0
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
                                    size:
                                        MediaQuery.of(context).size.width * 0.1,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              Text("client introuvable")
                            ],
                          )),
                        ))
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  AllTable(
                                    datas: customerService.customers,
                                    rowWidget: rowWidget(
                                        context,
                                        customerService.customers,
                                        customerService.removeCustomer,
                                        customerService.setPage),
                                    rowWidgetMobile: rowWidgetMobile(
                                      context,
                                      customerService.customers,
                                      customerService.removeCustomer,
                                      customerService.setPage,
                                    ),
                                    headersMobile: [
                                      "NOM",
                                      "EMAIL",
                                      "STATUS",
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
                                      customerService.pagination,
                                      context,
                                      customerService.customers.length)
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
    } catch (e) {
      return Container(
        child: Text("Error Occurd $e"),
      );
    }
  }
}

List<TableRow> rowWidgetMobile(BuildContext context, List<CustomerModel> datas,
    Function remove, Function setPage) {
  return [
    for (CustomerModel data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  setPage(
                      page: CustomerDetails(
                    customer: data,
                    fromPage: "customer",
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
                      statusTitles[data.status!.status == null
                          ? 0
                          : data.status!.status!],
                      style: TextStyle(
                          color: colorsSettings[data.status!.status == null
                                  ? 0
                                  : data.status!.status!]
                              .color),
                      overflow: TextOverflow.ellipsis,
                    )))),
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
                              TableHelper.showDeleteCard(
                                  context,
                                  data.fname.toString() +
                                      " " +
                                      data.fname.toString(),
                                  remove,
                                  data.id);
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
  List<CustomerModel> datas,
  Function remove,
  Function setPage,
) {
  return [
    for (CustomerModel data in datas)
      TableRow(children: [
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                onPressed: () {
                  setPage(
                      page: CustomerDetails(
                    customer: data,
                    fromPage: "customer",
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
                data.adress!,
                overflow: TextOverflow.ellipsis,
              ),
            ))),
        // TableCell(
        //     verticalAlignment: TableCellVerticalAlignment.middle,
        //     child: Center(
        //         child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 8),
        //       child: Consumer<ColorChangeService>(
        //         builder: (context, color, child) {
        //           return Text(
        //             statusTitles[
        //                 data.status!.status == null ? 0 : data.status!.status!],
        //             style: TextStyle(
        //                 color: color.statusColors[data.status!.status == null
        //                     ? 0
        //                     : data.status!.status!]),
        //             overflow: TextOverflow.ellipsis,
        //           );
        //         },
        //       ),
        //     ))),
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
                  TableHelper.showDeleteCard(
                      context,
                      data.fname.toString() + " " + data.fname.toString(),
                      remove,
                      data.id);
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
