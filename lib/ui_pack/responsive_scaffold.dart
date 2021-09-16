import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/autentication.dart';
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
        icon: "assets/icons/dashboard.svg",
        text: "Tableau de bord",
        content: DashBoardScreen()),
    DrawerItem(
        icon: "assets/icons/people.svg",
        text: "Clients",
        content: CustomerScreen()),
    DrawerItem(
        icon: "assets/icons/pin_drop.svg",
        text: "Chantiers",
        content: ProjectScreen()),
    DrawerItem(
        icon: "assets/icons/person_pin.svg",
        text: "Employés",
        content: EmployeeScreen()),
    DrawerItem(
        icon: "assets/icons/logs.svg", text: "Pointage", content: LogScreen()),
    DrawerItem(
        icon: "assets/icons/chat.svg",
        text: "Pushs",
        content: MessageScreen(
          recepients: [],
        )),
    DrawerItem(
        icon: "assets/icons/settings.svg",
        text: "Préférences",
        subItems: [
          SubDrawerItems(
              icon: "assets/icons/warning.svg",
              title: "Alerte",
              content: WarningSettings()),
          SubDrawerItems(
              icon: "assets/icons/admin_settings.svg",
              title: "General",
              content: GeneralSettings())
        ],
        content: null),
  ];

  @override
  _ResponsiveScaffoldState createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  Future initializeFirebase() async {
    print("INIT FIREBASE");
    await FireBase().init(context: context);
  }

  @override
  void initState() {
    init();
    this.initializeFirebase().whenComplete(() async {
      try {
        var fcmToken = await FireBase().fcmToken;
        if (fcmToken != null) {
          auth.addToken();
        }
      } catch (e) {
        print(e);
      }
    });
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
      showDrawerText = true;

      drawerWidth = maximumDrawerWidth;
    }

    ScaffoldService scaffoldService = Provider.of<ScaffoldService>(context);

    return Scaffold(
      key: _key,
      drawer: Drawer(
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Image.asset(
                              'assets/icons/logo.png',
                              height: 50,
                            ),
                          ))
                    ],
                  )),
              Expanded(
                child: AnimatedContainer(
                  onEnd: () {
                    setState(() {
                      showDrawerText = drawerWidth == maximumDrawerWidth;
                    });
                  },
                  duration: Duration(milliseconds: 100),
                  width: drawerWidth,
                  height: MediaQuery.of(context).size.height,
                  color: Palette.drawerColor,
                  child: ListView(
                    children: [
                      for (DrawerItem item in widget.drawerItems) ...{
                        Container(
                          color: scaffoldService.selectedContent == item.content
                              ? Colors.white
                              : item.subItems != null
                                  ? item.content == null && activeSettings
                                      ? Colors.white
                                      : Palette.drawerColor
                                  : Palette.drawerColor,
                          width: double.infinity,
                          height: 60,
                          child: item.subItems != null &&
                                  item.subItems!.length > 0 &&
                                  (!showDrawerText)
                              ? PopupMenuButton(
                                  tooltip: "Settings",
                                  icon: SvgPicture.asset(
                                    item.content == null && activeSettings
                                        ? item.icon!.replaceAll(".svg", "2.svg")
                                        : item.icon!,
                                    semanticsLabel: item.text,
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      activeSettings = true;
                                    });
                                    scaffoldService.selectedContent = value;
                                  },
                                  offset: Offset(60, 0),
                                  itemBuilder: (_) => [
                                    for (var sub_items in item.subItems!) ...{
                                      PopupMenuItem(
                                        value: sub_items.content,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                sub_items.icon!.replaceAll(
                                                    ".svg", "2.svg"),
                                                semanticsLabel:
                                                    sub_items.title),
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
                                      )
                                    }
                                  ],
                                )
                              : MaterialButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  onPressed: item.subItems != null &&
                                          item.subItems!.length > 0
                                      ? () {
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
                                              scaffoldService.selectedContent =
                                                  item.content;
                                              setState(() {
                                                activeSettings = false;
                                              });
                                              Navigator.pop(context);
                                            }
                                          : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          scaffoldService.selectedContent ==
                                                  item.content
                                              ? item.icon!
                                                  .replaceAll(".svg", "2.svg")
                                              : item.icon!,
                                          semanticsLabel: item.text),
                                      if (showDrawerText) ...{
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${item.text}",
                                            style: TextStyle(
                                                color: scaffoldService
                                                            .selectedContent ==
                                                        item.content
                                                    ? Palette.drawerColor
                                                    : item.content == null &&
                                                            activeSettings
                                                        ? Palette.drawerColor
                                                        : Colors.white),
                                          ),
                                        )
                                      },
                                      Spacer(),
                                      if ((item.subItems != null &&
                                              item.subItems!.length > 0) &&
                                          showDrawerText) ...{
                                        Icon(
                                          _selectedDrawerItem == item
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: item.content == null &&
                                                  activeSettings
                                              ? Palette.drawerColor
                                              : Colors.white,
                                        )
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
                                color: scaffoldService.selectedContent ==
                                        sub_items.content
                                    ? Colors.white38
                                    : Colors.transparent,
                                height: _selectedDrawerItem == item ? 60 : 0,
                                duration: Duration(
                                    milliseconds: 100 *
                                        (item.subItems!.indexOf(sub_items) +
                                            1)),
                                child: MaterialButton(
                                  onPressed: sub_items.content != null
                                      ? () {
                                          scaffoldService.selectedContent =
                                              sub_items.content;
                                          setState(() {
                                            activeSettings = true;
                                            Navigator.pop(context);
                                          });
                                        }
                                      : null,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  child: Row(
                                    children: [
                                      if (_selectedDrawerItem == item) ...{
                                        SvgPicture.asset(
                                            scaffoldService.selectedContent ==
                                                    sub_items.content
                                                ? sub_items.icon!
                                                    .replaceAll(".svg", "2.svg")
                                                : sub_items.icon!,
                                            semanticsLabel: sub_items.title)
                                      },
                                      if (sub_items.title != null) ...{
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            sub_items.title!,
                                            style: TextStyle(
                                                color: scaffoldService
                                                            .selectedContent ==
                                                        sub_items.content
                                                    ? Palette.drawerColor
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
                      tooltip: "Notifications",
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
                                        height:
                                            MediaQuery.of(context).size.height -
                                                100,
                                        child: ListView(
                                          children: List.generate(
                                              result.data!.length,
                                              (index) => GestureDetector(
                                                    onTap: () {
                                                      scaffoldService
                                                              .selectedContent =
                                                          LogScreen();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Card(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 3),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                constraints:
                                                                    BoxConstraints(
                                                                        maxHeight:
                                                                            90),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
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
                                                                          title:
                                                                              Text(
                                                                            "${result.data![index].title}",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                          subtitle:
                                                                              Text(
                                                                            "${result.data![index].body}",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: MySpacer
                                                                    .small,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          right: 10,
                                                          child: Text(
                                                            "${months[DateTime.parse(result.data![index].created_at!).month]} ${DateTime.parse(result.data![index].created_at!).day}, ${DateTime.parse(result.data![index].created_at!).year}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black26,
                                                                fontSize: 13),
                                                          ),
                                                        )
                                                      ],
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
                                                width: 25,
                                              ),
                                              SizedBox(
                                                height: MySpacer.small,
                                              ),
                                              Text("Pas encore de notification")
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
                            tooltip: "Admin Profile",
                            onSelected: (val) async {
                              activeSettings = true;
                              if (val == 1) {
                                scaffoldService.selectedContent =
                                    GeneralSettings();
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
                                          "Déconnexion",
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
                          AnimatedContainer(
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
                                for (DrawerItem item in widget.drawerItems) ...{
                                  Container(
                                    color: scaffoldService.selectedContent ==
                                            item.content
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
                                            tooltip: "Settings",
                                            icon: SvgPicture.asset(
                                                item.content == null &&
                                                        activeSettings
                                                    ? item.icon!.replaceAll(
                                                        ".svg", "2.svg")
                                                    : item.icon!,
                                                semanticsLabel: item.text),
                                            onSelected: (value) {
                                              setState(() {
                                                activeSettings = true;
                                              });
                                              scaffoldService.selectedContent =
                                                  value;
                                            },
                                            offset: Offset(60, 0),
                                            itemBuilder: (_) => [
                                              for (var sub_items
                                                  in item.subItems!) ...{
                                                PopupMenuItem(
                                                  value: sub_items.content,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          sub_items.icon!,
                                                          semanticsLabel:
                                                              sub_items.title),
                                                      if (sub_items.title !=
                                                          null) ...{
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              sub_items.title!),
                                                        )
                                                      }
                                                    ],
                                                  ),
                                                )
                                              }
                                            ],
                                          )
                                        : MaterialButton(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25),
                                            onPressed: item.subItems != null &&
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
                                                        scaffoldService
                                                                .selectedContent =
                                                            item.content;
                                                        setState(() {
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
                                                SvgPicture.asset(
                                                    scaffoldService
                                                                .selectedContent ==
                                                            item.content
                                                        ? item.icon!.replaceAll(
                                                            ".svg", "2.svg")
                                                        : item.content ==
                                                                    null &&
                                                                activeSettings
                                                            ? item.icon!
                                                                .replaceAll(
                                                                    ".svg",
                                                                    "2.svg")
                                                            : item.icon!,
                                                    semanticsLabel: item.text),
                                                if (showDrawerText) ...{
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${item.text}",
                                                      style: TextStyle(
                                                          color: scaffoldService
                                                                      .selectedContent ==
                                                                  item.content
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
                                                if ((item.subItems != null &&
                                                        item.subItems!.length >
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
                                                        ? Palette.drawerColor
                                                        : Colors.white,
                                                  )
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
                                          color:
                                              scaffoldService.selectedContent ==
                                                      sub_items.content
                                                  ? Colors.white38
                                                  : Colors.transparent,
                                          height: _selectedDrawerItem == item
                                              ? 60
                                              : 0,
                                          duration: Duration(
                                              milliseconds: 100 *
                                                  (item.subItems!
                                                          .indexOf(sub_items) +
                                                      1)),
                                          child: MaterialButton(
                                            onPressed: sub_items.content != null
                                                ? () {
                                                    scaffoldService
                                                            .selectedContent =
                                                        sub_items.content;
                                                    setState(() {
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
                                                  SvgPicture.asset(
                                                      scaffoldService
                                                                  .selectedContent ==
                                                              sub_items.content
                                                          ? sub_items.icon!
                                                              .replaceAll(
                                                                  ".svg",
                                                                  "2.svg")
                                                          : sub_items.icon!,
                                                      semanticsLabel:
                                                          'Acme Logo')
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
                                                          color: scaffoldService
                                                                      .selectedContent ==
                                                                  sub_items
                                                                      .content
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
                        },
                        Expanded(child: scaffoldService.selectedContent)
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
