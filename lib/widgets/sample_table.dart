import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class AllTable extends StatelessWidget {
  final List<String>? headersMobile;
  final List<String>? headers;
  final List? datas;
  final List<TableRow>? rowWidget;
  final List<TableRow>? rowWidgetMobile;
  final bool? assignUser;

  const AllTable(
      {Key? key,
      required this.datas,
      required this.rowWidget,
      required this.rowWidgetMobile,
      required this.headersMobile,
      required this.headers,
      required this.assignUser})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
          color: Colors.black12, width: 1, style: BorderStyle.solid),
      children: [
        //HEADER
        MediaQuery.of(context).size.width <= 500 || assignUser!
            ? TableRow(
                decoration: BoxDecoration(color: Palette.drawerColor),
                children: [
                    for (var header in headersMobile!)
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                              height: 50,
                              child: Center(
                                  child: Text(
                                header,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )))),
                  ])
            : TableRow(
                decoration: BoxDecoration(color: Palette.drawerColor),
                children: [
                    for (var header in headers!)
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                              height: 50,
                              child: Center(
                                  child: Text(
                                header,
                                style: TextStyle(color: Colors.white),
                              )))),
                  ]),

        for (var row in MediaQuery.of(context).size.width <= 500 || assignUser!
            ? rowWidgetMobile!
            : rowWidget!)
          row
      ],
    );
  }
}
