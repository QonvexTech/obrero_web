import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';

Widget pageControll(PaginationService pageService,
    PaginationModel paginationModel, context, int viewingEntries) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            children: [
              Text("Affichage"),
              SizedBox(
                width: MySpacer.small,
              ),
              PopupMenuButton(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  offset: Offset(0, 40),
                  child: Row(
                    children: [
                      Text(viewingEntries.toString()),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                  itemBuilder: (context) => [
                        for (var x = 10;
                            x < paginationModel.totalEntries + 1;
                            x += 10)
                          PopupMenuItem(
                            child: GestureDetector(
                                onTap: () {
                                  pageService.updatePerPage(x, paginationModel);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: double.infinity,
                                    height: 40,
                                    child: Center(child: Text("$x")))),
                          ),
                        PopupMenuItem(
                          child: GestureDetector(
                              onTap: () {
                                pageService.updatePerPage(
                                    paginationModel.totalEntries,
                                    paginationModel);
                                Navigator.pop(context);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  width: double.infinity,
                                  height: 40,
                                  child: Center(child: Text("All")))),
                        ),
                      ]),
              Text("sur ${paginationModel.totalEntries} enregistrements")
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                textColor: Palette.drawerColor,
                onPressed: paginationModel.isPrev
                    ? () {
                        pageService.prevPage(paginationModel);
                      }
                    : null,
                child: MediaQuery.of(context).size.width <= 500
                    ? Icon(
                        Icons.arrow_back_ios,
                      )
                    : Text(
                        "Préc.",
                        style: TextStyle(
                            color: paginationModel.isPrev
                                ? Palette.drawerColor
                                : Colors.grey),
                      ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width <= 500
                    ? 80
                    : 60 * double.parse(paginationModel.lastPage.toString()) -
                        1,
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
                onPressed: paginationModel.isNext
                    ? () {
                        pageService.nextPage(paginationModel);
                      }
                    : null,
                child: MediaQuery.of(context).size.width <= 500
                    ? Icon(Icons.arrow_forward_ios)
                    : Text(
                        "Suiv.",
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
    ),
  );
}
