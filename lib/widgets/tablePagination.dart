import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';

class TablePagination extends StatelessWidget {
  final PaginationModel paginationModel;
  final int showingLength;

  const TablePagination({
    Key? key,
    required this.showingLength,
    required this.paginationModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PaginationService pageService = Provider.of<PaginationService>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Text("Showing"),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: pageService.perPageController,
                    onChanged: (value) {
                      try {
                        pageService.customPerPage(
                            paginationModel, int.parse(value));
                      } catch (e) {
                        print(e);
                      }
                    },
                    decoration: InputDecoration(hintText: "$showingLength"),
                  ),
                ),
              ),
              Text("of ${paginationModel.totalEntries} entries")
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width / 10,
                textColor: Palette.drawerColor,
                onPressed: paginationModel.isPrev
                    ? () {
                        pageService.prevPage(paginationModel);
                      }
                    : null,
                child: MediaQuery.of(context).size.width <= 400
                    ? Icon(
                        Icons.arrow_back_ios,
                      )
                    : Text(
                        "Prev",
                        style: TextStyle(
                            color: paginationModel.isPrev
                                ? Palette.drawerColor
                                : Colors.grey),
                      ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4.7,
                height: 50,
                child: ListView.builder(
                  controller: pageService.scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: paginationModel.lastPage,
                  itemBuilder: (_, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: MaterialButton(
                        textColor: this.paginationModel.page == (index + 1)
                            ? Colors.white
                            : Colors.black,
                        padding: EdgeInsets.all(8),
                        minWidth: 50,
                        color: this.paginationModel.page == (index + 1)
                            ? Palette.drawerColor
                            : Palette.contentBackground,
                        onPressed: () {
                          pageService.setTablePage(
                              (index + 1), paginationModel);
                          print("set");
                        },
                        child: Text((index + 1).toString()),
                      ),
                    );
                  },
                ),
              ),
              MaterialButton(
                textColor: Palette.drawerColor,
                minWidth: MediaQuery.of(context).size.width / 10,
                onPressed: paginationModel.isNext
                    ? () {
                        pageService.nextPage(paginationModel);
                      }
                    : null,
                child: MediaQuery.of(context).size.width <= 400
                    ? Icon(Icons.arrow_forward_ios)
                    : Text(
                        "Next",
                        style: TextStyle(
                            color: paginationModel.isNext
                                ? Palette.drawerColor
                                : Colors.grey),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
