import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class GeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Types de Warning",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: MySpacer.medium,
                ),
                Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscingaadadfbv elit, sed do eius  mod tempor incididunt ut labore et dolore magnmagnaaliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                SizedBox(
                  height: MySpacer.medium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Text("ORDINAIRE")
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Text("MEDIUM")
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Text("IMPORTANT")
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Text("FIXÉ")
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container())
      ],
    ));
  }
}
