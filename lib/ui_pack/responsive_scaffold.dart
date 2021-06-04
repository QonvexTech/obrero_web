import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/services/log_service.dart';
import 'package:uitemplate/services/notification_services.dart';
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
        content: null),
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

  void init() {
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
  bool activeSettings = false;
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
          : Consumer<ScaffoldService>(
              builder: (context, data, child) {
                return Drawer(
                  // MOBILE
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  onPressed: item.subItems != null &&
                                          item.subItems!.length > 0
                                      ? () {
                                          setState(() {
                                            if (_selectedDrawerItem == item) {
                                              _selectedDrawerItem = null;
                                              activeSettings = true;
                                            } else {}
                                          });
                                        }
                                      : item.content != null
                                          ? () {
                                              activeSettings = false;
                                              Navigator.of(context).pop(null);

                                              data.selectedContent =
                                                  item.content;
                                            }
                                          : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        Icon(
                                            _selectedDrawerItem == item
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            color: Colors.white),
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
                                      color: Palette.drawerColor,
                                      height:
                                          _selectedDrawerItem == item ? 60 : 0,
                                      duration: Duration(
                                          milliseconds: 100 *
                                              (item.subItems!
                                                      .indexOf(sub_items) +
                                                  1)),
                                      child: MaterialButton(
                                        onPressed: sub_items.content != null
                                            ? () {
                                                Navigator.of(context).pop(null);
                                                setState(() {
                                                  data.selectedContent =
                                                      sub_items.content;
                                                  _selectedDrawerItem = item;
                                                  activeSettings = true;
                                                });
                                              }
                                            : null,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: Row(
                                          children: [
                                            if (_selectedDrawerItem ==
                                                item) ...{
                                              Icon(sub_items.icon,
                                                  color: data.selectedContent ==
                                                              null &&
                                                          activeSettings
                                                      ? Palette.drawerColor
                                                      : Colors.white)
                                            },
                                            if (sub_items.title != null) ...{
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(sub_items.title!,
                                                    style: TextStyle(
                                                        color: Colors.white)),
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
                );
              },
            ),
      body: Consumer<ScaffoldService>(builder: (context, data, child) {
        return GestureDetector(
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

                      //NOTIFICATIONS
                      PopupMenuButton(
                        offset: Offset(50, 50),
                        icon: StreamBuilder<bool>(
                            stream: rxNotificationService.streamNewMessage$,
                            builder: (context, result) {
                              if (result.hasError) {
                                return Center(
                                  child: Text(
                                    "${result.error}",
                                  ),
                                );
                              }
                              if (result.hasData) {
                                return Stack(
                                  children: [
                                    Icon(Icons.notifications),
                                    result.data! == true
                                        ? Positioned(
                                            // draw a red marble
                                            top: 0.0,
                                            right: 0.0,
                                            child: new Icon(Icons.brightness_1,
                                                size: 8.0,
                                                color: Colors.redAccent),
                                          )
                                        : Container()
                                  ],
                                );
                              } else {
                                return Icon(Icons.notifications);
                              }
                            }),
                        itemBuilder: (BuildContext context) {
                          rxNotificationService.openMessage();
                          return [
                            PopupMenuItem(
                              child: Container(
                                width: 650,
                                // height: MediaQuery.of(context).size.height - 100,

                                child: StreamBuilder<List<LogModel>>(
                                    stream: logService.stream$,
                                    builder: (context, result) {
                                      if (result.hasError) {
                                        return Center(
                                          child: Text(
                                            "${result.error}",
                                          ),
                                        );
                                      }

                                      if (result.hasData &&
                                          result.data!.length > 0) {
                                        return Container(
                                          width: 650,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100,
                                          child: ListView(
                                            children: List.generate(
                                                result.data!.length,
                                                (index) => GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          data.selectedContent =
                                                              LogScreen();
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Card(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 3),
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxHeight:
                                                                      90),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .notification_important_rounded,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                      "${result.data![index].title}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    subtitle:
                                                                        Text(
                                                                      "${result.data![index].body}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width: 650,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: MySpacer.small,
                                                ),
                                                Image.asset(
                                                  "assets/images/emptynotification.png",
                                                  width: 50,
                                                ),
                                                SizedBox(
                                                  height: MySpacer.small,
                                                ),
                                                Text(
                                                    "Pas encore de notification")
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ),
                            )
                          ];
                        },
                      ),
                      profileData == null
                          ? CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.grey.shade100,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                          : PopupMenuButton(
                              onSelected: (val) async {
                                activeSettings = true;
                                if (val == 1) {
                                  setState(() {
                                    data.selectedContent = GeneralSettings();
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
                                              Text(
                                                  "${profileData!.firstName!}"),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                        color:
                                            data.selectedContent == item.content
                                                ? Colors.white
                                                : item.subItems != null
                                                    ? item.content == null &&
                                                            activeSettings
                                                        ? Colors.white
                                                        : Palette.drawerColor
                                                    : Palette.drawerColor,
                                        width: double.infinity,
                                        height: 60,
                                        child: item.subItems != null &&
                                                item.subItems!.length > 0 &&
                                                (!showDrawerText)
                                            ? PopupMenuButton(
                                                icon: Icon(
                                                  item.icon,
                                                  color: item.content == null &&
                                                          activeSettings
                                                      ? Palette.drawerColor
                                                      : Colors.white,
                                                ),
                                                onSelected: (value) {
                                                  setState(() {
                                                    activeSettings = true;
                                                    data.selectedContent =
                                                        value;
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
                                                        item.subItems!.length >
                                                            0
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
                                                              data.selectedContent =
                                                                  item.content;
                                                              activeSettings =
                                                                  false;
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
                                                        color: data.selectedContent ==
                                                                item.content
                                                            ? Palette
                                                                .drawerColor
                                                            : item.content ==
                                                                        null &&
                                                                    activeSettings
                                                                ? Palette
                                                                    .drawerColor
                                                                : Colors.white),
                                                    if (showDrawerText) ...{
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "${item.text}",
                                                          style: TextStyle(
                                                              color: data.selectedContent ==
                                                                      item
                                                                          .content
                                                                  ? Palette
                                                                      .drawerColor
                                                                  : item.content ==
                                                                              null &&
                                                                          activeSettings
                                                                      ? Palette
                                                                          .drawerColor
                                                                      : Colors
                                                                          .white),
                                                        ),
                                                      )
                                                    },
                                                    Spacer(),
                                                    if ((item.subItems !=
                                                                null &&
                                                            item.subItems!
                                                                    .length >
                                                                0) &&
                                                        showDrawerText) ...{
                                                      Icon(
                                                        _selectedDrawerItem == item
                                                            ? Icons
                                                                .keyboard_arrow_up
                                                            : Icons
                                                                .keyboard_arrow_down,
                                                        color: item.content ==
                                                                    null &&
                                                                activeSettings
                                                            ? Palette
                                                                .drawerColor
                                                            : Colors.white,
                                                      )
                                                    }
                                                  ],
                                                ),
                                              ),
                                      ),
                                      if ((item.subItems != null &&
                                              item.subItems!.length > 0) &&
                                          showDrawerText) ...{
                                        for (var sub_items
                                            in item.subItems!) ...{
                                          AnimatedContainer(
                                              width: double.infinity,
                                              color: data.selectedContent ==
                                                      sub_items.content
                                                  ? Colors.white38
                                                  : Colors.transparent,
                                              height:
                                                  _selectedDrawerItem == item
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
                                                          data.selectedContent =
                                                              sub_items.content;
                                                          activeSettings = true;
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
                                                        color:
                                                            data.selectedContent ==
                                                                    sub_items
                                                                        .content
                                                                ? Palette
                                                                    .drawerColor
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
                                                              color: data.selectedContent ==
                                                                      sub_items
                                                                          .content
                                                                  ? Palette
                                                                      .drawerColor
                                                                  : Colors
                                                                      .white),
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
                          Expanded(child: data.selectedContent)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
