import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';
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
