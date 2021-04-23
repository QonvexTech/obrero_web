import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';

class TablePagination extends StatelessWidget {
  final PaginationModel paginationModel;
  const TablePagination({
    Key? key,
    required this.paginationModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PaginationService pageService = Provider.of<PaginationService>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [Text("Showing 10 of ${paginationModel.page} entries")],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: MediaQuery.of(context).size.width <= 400
                    ? Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      )
                    : Text(
                        "Next",
                        style: TextStyle(
                            color: paginationModel.isNext
                                ? Palette.drawerColor
                                : Colors.grey),
                      ),
              ),
              // MaterialButton(
              //   minWidth: 100,
              //   onPressed: this.paginationModel.isPrev
              //       ? () {
              //           pageService.prevPage(paginationModel);
              //         }
              //       : null,
              //   child: Text(
              //     "Previous",
              //     style: TextStyle(
              //         color: this.paginationModel.isPrev
              //             ? Palette.drawerColor
              //             : Colors.grey),
              //   ),
              // ),
              for (var index = 1;
                  index <= this.paginationModel.lastPage;
                  index++)
                MaterialButton(
                  minWidth: 50,
                  color: this.paginationModel.page == index
                      ? Palette.drawerColor
                      : Palette.contentBackground,
                  onPressed: () {
                    pageService.setTablePage(index, paginationModel);
                  },
                  child: Text((index).toString()),
                ),

              TextButton(
                onPressed: () {},
                child: MediaQuery.of(context).size.width <= 400
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      )
                    : Text(
                        "Next",
                        style: TextStyle(
                            color: paginationModel.isNext
                                ? Palette.drawerColor
                                : Colors.grey),
                      ),
              )
              // MaterialButton(
              //   minWidth: 100,
              //   onPressed: paginationModel.isNext
              //       ? () {
              //           pageService.nextPage(paginationModel);
              //         }
              //       : null,
              //   child: MediaQuery.of(context).size.width <= 400
              //       ? Icon(Icons.arrow_forward_ios)
              //       : Text(
              //           "Next",
              //           style: TextStyle(
              //               color: paginationModel.isNext
              //                   ? Palette.drawerColor
              //                   : Colors.grey),
              //         ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
