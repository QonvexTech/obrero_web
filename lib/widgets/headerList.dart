import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/view/dashboard/tracker.dart';
import 'package:uitemplate/widgets/adding_button.dart';

class HeaderList extends StatelessWidget {
  final Widget? toPage;
  final String? title;
  final Function? search;
  final TextEditingController? searchController;
  HeaderList(
      {Key? key,
      required this.search,
      required this.searchController,
      required this.toPage,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var employeeService = Provider.of<EmployeeSevice>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AdaptiveContainer(children: [
        AdaptiveItem(
          height: 50,
          width: Theme.of(context).textTheme.headline5!.fontSize! * 5,
          content: Center(
            child: Text(
              title!,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
        AdaptiveItem(
            height: 50,
            content: Row(
              children: [
                Expanded(
                  child: Container(
                      child: Theme(
                    data: ThemeData(
                      primaryColor: Palette.drawerColor,
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        search!(value);
                      },
                      cursorColor: Palette.drawerColor,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black12),
                          prefixIcon: Icon(Icons.search),
                          hintText: "Recherche",
                          border: InputBorder.none),
                    ),
                  )),
                ),
                Expanded(child: Container()),
                title == "Employee"
                    ? Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            //SHOW MAP MONITOR
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                    backgroundColor: Palette.contentBackground,
                                    content: Stack(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Column(
                                              children: [
                                                MaterialButton(
                                                  color: Palette.drawerColor,
                                                  onPressed: () {
                                                    employeeService
                                                        .timeOutAllUser()
                                                        .then((value) {
                                                      if (value.isNotEmpty) {
                                                        Fluttertoast.showToast(
                                                            webBgColor:
                                                                "linear-gradient(to right, #5585E5, #5585E5)",
                                                            msg: value,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                2,
                                                            fontSize: 16.0);
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Time Out All Users",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MySpacer.medium,
                                                ),
                                                Expanded(child: TrackerPage()),
                                              ],
                                            )),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            splashRadius: 15,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.monitor,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: MySpacer.small,
                              ),
                              Text(
                                "Monitor All Users",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  width: MySpacer.medium,
                ),
                Container(
                  height: 40,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: AddingButton(addingPage: toPage, buttonText: "Créer"),
                ),
              ],
            ))
      ]),
    );
  }
}
