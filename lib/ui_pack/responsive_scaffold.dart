import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/services/scaffold_service.dart';
import 'package:uitemplate/ui_pack/children/drawer_item.dart';
import 'package:uitemplate/view/dashboard/customer/customer_screen.dart';
import 'package:uitemplate/view/dashboard/dashboard_screen.dart';
import 'package:uitemplate/view/dashboard/employee/employee_screen.dart';
import 'package:uitemplate/view/dashboard/logs/log_screen.dart';
import 'package:uitemplate/view/dashboard/messages/message_screen.dart';
import 'package:uitemplate/view/dashboard/project/project_screen.dart';
import 'package:uitemplate/view/dashboard/settings/change_password_settings.dart';
import 'package:uitemplate/view/dashboard/settings/general_settings.dart';
import 'package:uitemplate/view/dashboard/settings/warnings/warning_settings.dart';
import 'package:uitemplate/widgets/notifications.dart';
import 'children/sub_drawer_item.dart';

class ResponsiveScaffold extends StatefulWidget {
  final List<DrawerItem> drawerItems = [
    DrawerItem(
        icon: Icons.dashboard, text: "Dashboard", content: DashBoardScreen()),
    DrawerItem(
        icon: Icons.people, text: "Customers", content: CustomerScreen()),
    DrawerItem(
        icon: Icons.pin_drop_outlined,
        text: "Chantiers",
        content: ProjectScreen()),
    DrawerItem(
        icon: Icons.person_pin_circle_outlined,
        text: "Employee",
        content: EmployeeScreen()),
    DrawerItem(icon: Icons.list, text: "Logs", content: LogScreen()),
    DrawerItem(
        icon: Icons.message,
        text: "Pushs",
        content: MessageScreen(
          recepients: [],
        )),
    DrawerItem(
        icon: Icons.settings,
        text: "Préférences",
        subItems: [
          SubDrawerItems(
              icon: Icons.warning,
              title: "Warning",
              content: WarningSettings()),
          SubDrawerItems(
              icon: Icons.all_out, title: "General", content: GeneralSettings())
        ],
        content: Container(
          color: Colors.red,
        )),
  ];

  @override
  _ResponsiveScaffoldState createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  void initializeFirebase() async {
    await FireBase().init(context: context);
  }

  @override
  void initState() {
    init();
    this.initializeFirebase();
    super.initState();
  }

  void init() async {
    showDrawerText = drawerWidth == maximumDrawerWidth;

    for (var item in widget.drawerItems) {
      if (item.content != null && item.subItems == null) {
        Provider.of<ScaffoldService>(context, listen: false).init(item.content);
        break;
      }
    }
  }

  double drawerWidth = 60;
  double maximumDrawerWidth = 300;
  bool showTextField = false;
  double minimumDrawerWidth = 0.0;
  double dragEndAt = 0.0;
  double dragStartAt = 0.0;
  bool showDrawerText = true;
  bool _showDrawer = false;
  DrawerItem? _selectedDrawerItem;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  void onUpdate(DragUpdateDetails details) {
    setState(() {
      if (details.localPosition.dx <= maximumDrawerWidth &&
          details.localPosition.dx >= minimumDrawerWidth) {
        drawerWidth = details.localPosition.dx;
      }
      dragEndAt = details.localPosition.dx;
    });
  }

  ImageProvider fetchImage({required var netWorkImage}) {
    if (netWorkImage == null || netWorkImage == "") {
      return AssetImage('icons/admin_icon.png');
    } else {
      return NetworkImage("https://obrero.checkmy.dev$netWorkImage");
    }
  }

  // void onDragEnd(DragEndDetails details) {
  //   if (dragStartAt > maximumDrawerWidth - 100) {
  //     if (dragStartAt > dragEndAt) {
  //       setState(() {
  //         drawerWidth = minimumDrawerWidth;
  //       });
  //     } else {
  //       setState(() {
  //         drawerWidth = maximumDrawerWidth;
  //       });
  //     }
  //   } else {
  //     if (dragEndAt > maximumDrawerWidth - 100) {
  //       setState(() {
  //         drawerWidth = maximumDrawerWidth;
  //       });
  //     } else {
  //       setState(() {
  //         drawerWidth = minimumDrawerWidth;
  //       });
  //     }
  //   }
  //   setState(() {
  //     dragStartAt = minimumDrawerWidth;
  //   });
  // }

  // void onDragStart(DragStartDetails details) {
  //   setState(() {
  //     dragStartAt = details.localPosition.dx;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ScaffoldService scaff = Provider.of<ScaffoldService>(context);
    if (MediaQuery.of(context).size.width > 900 &&
        MediaQuery.of(context).size.width < 1600) {
      minimumDrawerWidth = 60;
      if (!_showDrawer) {
        drawerWidth = minimumDrawerWidth;
        showDrawerText = false;
        _showDrawer = true;
      }
    } else if (MediaQuery.of(context).size.width > 1600) {
      minimumDrawerWidth = 60;
      if (_showDrawer) {
        _showDrawer = false;
        drawerWidth = maximumDrawerWidth;
        showDrawerText = true;
      }
    } else {
      minimumDrawerWidth = 0;
      if (_showDrawer) {
        drawerWidth = minimumDrawerWidth;
      }
      _showDrawer = false;
//          drawerWidth = maximumDrawerWidth;
    }

    return Scaffold(
      key: _key,
      drawer: MediaQuery.of(context).size.width > 900
          ? null
          : Drawer(
              child: Container(
                color: Palette.drawerColor,
                width: 500,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: AlignmentDirectional.centerStart,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                Navigator.of(context).pop(null);
                              },
                            ),
                            Container(
                                height: 60,
                                alignment: AlignmentDirectional.centerStart,
                                margin: const EdgeInsets.only(left: 15),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Image.asset(
                                    'assets/icons/logo.png',
                                    height: 50,
                                  ),
                                ))
                          ],
                        )),
                    Expanded(
                        child: ListView(
                      children: [
                        for (var item in widget.drawerItems) ...{
                          Container(
                            width: double.infinity,
                            color: Palette.drawerColor,
                            height: 60,
                            child: MaterialButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              onPressed: item.subItems != null &&
                                      item.subItems!.length > 0
                                  ? () {
                                      Navigator.of(context).pop(null);
                                      setState(() {
                                        if (_selectedDrawerItem == item) {
                                          _selectedDrawerItem = null;
                                        } else {
                                          _selectedDrawerItem = item;
                                        }
                                      });
                                    }
                                  : item.content != null
                                      ? () {
                                          Navigator.of(context).pop(null);
                                          setState(() {
                                            scaff.selectedContent =
                                                item.content;
                                          });
                                        }
                                      : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.icon,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${item.text}",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if ((item.subItems != null &&
                                      item.subItems!.length > 0)) ...{
                                    Icon(_selectedDrawerItem == item
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down)
                                  }
                                ],
                              ),
                            ),
                          ),
                          if ((item.subItems != null &&
                              item.subItems!.length > 0)) ...{
                            for (var sub_items in item.subItems!) ...{
                              AnimatedContainer(
                                  width: double.infinity,
                                  color: Palette.contentBackground,
                                  height: _selectedDrawerItem == item ? 60 : 0,
                                  duration: Duration(
                                      milliseconds: 100 *
                                          (item.subItems!.indexOf(sub_items) +
                                              1)),
                                  child: MaterialButton(
                                    onPressed: sub_items.content != null
                                        ? () {
                                            Navigator.of(context).pop(null);
                                            setState(() {
                                              scaff.selectedContent =
                                                  sub_items.content;
                                            });
                                          }
                                        : null,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    child: Row(
                                      children: [
                                        if (_selectedDrawerItem == item) ...{
                                          Icon(sub_items.icon),
                                        },
                                        if (sub_items.title != null) ...{
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(sub_items.title!),
                                          )
                                        }
                                      ],
                                    ),
                                  ))
                            }
                          }
                        }
                      ],
                    ))
                  ],
                ),
              ),
            ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            showTextField = false;
          });
        },
        // onHorizontalDragStart:
        //     MediaQuery.of(context).size.width > 900 ? onDragStart : null,
        // onHorizontalDragUpdate:
        //     MediaQuery.of(context).size.width > 900 ? onUpdate : null,
        // onHorizontalDragEnd:
        //     MediaQuery.of(context).size.width > 900 ? onDragEnd : null,
        child: Container(
          constraints: BoxConstraints(minWidth: 350.0, minHeight: 400.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Palette.contentBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 2,
                      offset: Offset(0, 3))
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //leading

                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        if (MediaQuery.of(context).size.width > 900) {
                          setState(() {
                            drawerWidth = drawerWidth == minimumDrawerWidth
                                ? maximumDrawerWidth
                                : minimumDrawerWidth;
                          });
                        } else {
                          _key.currentState!.openDrawer();
                        }
                      },
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image.asset(
                          'assets/icons/logo.png',
                          height: 50,
                        ),
                      ),
                    ),

                    Spacer(),
                    NotificationCard(),
                    profileData == null
                        ? CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.grey.shade100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                        : PopupMenuButton(
                            onSelected: (val) async {
                              if (val == 1) {
                                setState(() {
                                  scaff.selectedContent = GeneralSettings();
                                });
                              } else if (val == 2) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                        backgroundColor:
                                            Palette.contentBackground,
                                        content: ChangePassword()));
                              } else {
                                await DataCacher().removeCredentials(context);
                              }
                            },
                            offset: Offset(0, 50),
                            icon: FittedBox(
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  backgroundImage: fetchImage(
                                      netWorkImage: profileData!.picture)),
                            ),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Container(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              backgroundImage: fetchImage(
                                                netWorkImage:
                                                    profileData!.picture,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MySpacer.medium,
                                            ),
                                            Text("${profileData!.firstName!}"),
                                            Text("${profileData!.email!}"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Center(
                                      child: Text("Changer le mot de passe",
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Logout",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Row(
                      children: [
                        if (MediaQuery.of(context).size.width > 900) ...{
                          GestureDetector(
                            child: AnimatedContainer(
                              onEnd: () {
                                setState(() {
                                  showDrawerText =
                                      drawerWidth == maximumDrawerWidth;
                                });
                              },
                              duration: Duration(milliseconds: 100),
                              width: drawerWidth,
                              height: MediaQuery.of(context).size.height,
                              color: Palette.drawerColor,
                              child: ListView(
                                children: [
                                  for (DrawerItem item
                                      in widget.drawerItems) ...{
                                    Container(
                                      color: scaff.selectedContent.toString() ==
                                              item.content.toString()
                                          ? Colors.white
                                          : Palette.drawerColor,
                                      width: double.infinity,
                                      height: 60,
                                      child: item.subItems != null &&
                                              item.subItems!.length > 0 &&
                                              (!showDrawerText)
                                          ? PopupMenuButton(
                                              icon: Icon(
                                                item.icon,
                                                color: scaff.selectedContent
                                                            .toString() ==
                                                        item.content.toString()
                                                    ? Palette.drawerColor
                                                    : Colors.white,
                                              ),
                                              onSelected: (value) {
                                                setState(() {
                                                  scaff.selectedContent = value;
                                                });
                                              },
                                              offset: Offset(60, 0),
                                              itemBuilder: (_) => [
                                                for (var sub_items
                                                    in item.subItems!) ...{
                                                  PopupMenuItem(
                                                    value: sub_items.content,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          sub_items.icon,
                                                        ),
                                                        if (sub_items.title !=
                                                            null) ...{
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                sub_items
                                                                    .title!),
                                                          )
                                                        }
                                                      ],
                                                    ),
                                                  )
                                                }
                                              ],
                                            )
                                          : MaterialButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25),
                                              onPressed: item.subItems !=
                                                          null &&
                                                      item.subItems!.length > 0
                                                  ? () {
                                                      setState(() {
                                                        if (_selectedDrawerItem ==
                                                            item) {
                                                          _selectedDrawerItem =
                                                              null;
                                                        } else {
                                                          _selectedDrawerItem =
                                                              item;
                                                        }
                                                      });
                                                    }
                                                  : item.content != null
                                                      ? () {
                                                          setState(() {
                                                            scaff.selectedContent =
                                                                item.content;
                                                          });
                                                        }
                                                      : null,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(item.icon,
                                                      color: scaff.selectedContent
                                                                  .toString() ==
                                                              item.content
                                                                  .toString()
                                                          ? Palette.drawerColor
                                                          : Colors.white),
                                                  if (showDrawerText) ...{
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${item.text}",
                                                        style: TextStyle(
                                                            color: scaff.selectedContent
                                                                        .toString() ==
                                                                    item.content
                                                                        .toString()
                                                                ? Palette
                                                                    .drawerColor
                                                                : Colors.white),
                                                      ),
                                                    )
                                                  },
                                                  Spacer(),
                                                  if ((item.subItems != null &&
                                                          item.subItems!
                                                                  .length >
                                                              0) &&
                                                      showDrawerText) ...{
                                                    Icon(
                                                      _selectedDrawerItem ==
                                                              item
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color: Colors.white,
                                                    )
                                                  }
                                                ],
                                              ),
                                            ),
                                    ),
                                    if ((item.subItems != null &&
                                            item.subItems!.length > 0) &&
                                        showDrawerText) ...{
                                      for (var sub_items in item.subItems!) ...{
                                        AnimatedContainer(
                                            width: double.infinity,
                                            color: scaff.selectedContent
                                                        .toString() ==
                                                    sub_items.content.toString()
                                                ? Colors.white
                                                : Colors.transparent,
                                            height: _selectedDrawerItem == item
                                                ? 60
                                                : 0,
                                            duration: Duration(
                                                milliseconds: 100 *
                                                    (item.subItems!.indexOf(
                                                            sub_items) +
                                                        1)),
                                            child: MaterialButton(
                                              onPressed: sub_items.content !=
                                                      null
                                                  ? () {
                                                      setState(() {
                                                        scaff.selectedContent =
                                                            sub_items.content;
                                                      });
                                                    }
                                                  : null,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 35),
                                              child: Row(
                                                children: [
                                                  if (_selectedDrawerItem ==
                                                      item) ...{
                                                    Icon(
                                                      sub_items.icon,
                                                      color: scaff.selectedContent
                                                                  .toString() ==
                                                              sub_items.content
                                                                  .toString()
                                                          ? Palette.drawerColor
                                                          : Colors.white,
                                                    ),
                                                  },
                                                  if (sub_items.title !=
                                                      null) ...{
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        sub_items.title!,
                                                        style: TextStyle(
                                                            color: scaff.selectedContent
                                                                        .toString() ==
                                                                    sub_items
                                                                        .content
                                                                        .toString()
                                                                ? Palette
                                                                    .drawerColor
                                                                : Colors.white),
                                                      ),
                                                    )
                                                  }
                                                ],
                                              ),
                                            ))
                                      }
                                    }
                                  }
                                ],
                              ),
                            ),
                          )
                        },
                        Expanded(child: scaff.selectedContent)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
