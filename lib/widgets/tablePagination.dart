import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';

Widget pageControll(
    PaginationService pageService, dynamic paginationModel, context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Row(
          children: [
            Text("Showing"),
            SizedBox(
              width: MySpacer.small,
            ),
            PopupMenuButton(
                padding: EdgeInsets.symmetric(horizontal: 10),
                offset: Offset(0, 40),
                child: Row(
                  children: [Text("10"), Icon(Icons.arrow_drop_down_sharp)],
                ),
                itemBuilder: (context) => [
                      for (var x = 1; x <= paginationModel.totalEntries; x++)
                        PopupMenuItem(
                          child: IconButton(
                              onPressed: () {
                                pageService.updatePerPage(x, paginationModel);
                                Navigator.pop(context);
                              },
                              icon: Center(child: Text("$x"))),
                        ),
                    ]),
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
                      textColor: paginationModel.page == (index + 1)
                          ? Colors.white
                          : Colors.black,
                      padding: EdgeInsets.all(8),
                      minWidth: 50,
                      color: paginationModel.page == (index + 1)
                          ? Palette.drawerColor
                          : Palette.contentBackground,
                      onPressed: () {
                        pageService.setTablePage((index + 1), paginationModel);
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
