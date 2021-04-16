import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';

class TablePagination extends StatelessWidget {
  final Function toFetch;

  const TablePagination({Key? key, required this.toFetch}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PaginationService pageService = Provider.of<PaginationService>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
          minWidth: 100,
          onPressed: pageService.getPrev
              ? () {
                  pageService.prevPage(toFetch);
                }
              : null,
          child: Text(
            "Previous",
            style: TextStyle(
                color: pageService.getPrev ? Palette.drawerColor : Colors.grey),
          ),
        ),
        for (var index = 1; index <= pageService.lastPage!; index++)
          MaterialButton(
            minWidth: 50,
            color: pageService.page == index
                ? Palette.drawerColor
                : Palette.contentBackground,
            onPressed: () {
              pageService.setTablePage(index, toFetch);
            },
            child: Text((index).toString()),
          ),
        MaterialButton(
          minWidth: 100,
          onPressed: pageService.getNext
              ? () {
                  pageService.nextPage(toFetch);
                }
              : null,
          child: Text(
            "Next",
            style: TextStyle(
                color: pageService.getNext ? Palette.drawerColor : Colors.grey),
          ),
        )
      ],
    );
  }
}
