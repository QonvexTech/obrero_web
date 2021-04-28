import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/ui_pack/children/drawer_item.dart';
import 'package:uitemplate/view/dashboard/settings/general_settings.dart';
import 'package:uitemplate/widgets/notifications.dart';

class ResponsiveScaffold extends StatefulWidget {
  final BuildContext? context;
  final Widget? title;
  final Color backgroundColor;
  final Color? drawerBackgroundColor;
  final List<DrawerItem>? drawerItems;
  late Widget? body;

  final OverlayState? overlayState;

  ResponsiveScaffold(
      {this.context,
      this.overlayState,
      this.title,
      this.drawerItems,
      this.body,
      this.backgroundColor = Colors.white,
      this.drawerBackgroundColor});

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
    if (widget.body == null) {
      widget.body = Container(
        color: Colors.white,
      );
    }
    if (mounted) {
      setState(() {
        showDrawerText = drawerWidth == maximumDrawerWidth;
        if (widget.drawerItems != null) {
          for (var item in widget.drawerItems!) {
            if (item.content != null && item.subItems == null) {
              _selectedContent = item.content;
              break;
            }
          }
        }
      });
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
  dynamic _selectedContent;
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

  void onDragEnd(DragEndDetails details) {
    if (dragStartAt > maximumDrawerWidth - 100) {
      if (dragStartAt > dragEndAt) {
        setState(() {
          drawerWidth = minimumDrawerWidth;
        });
      } else {
        setState(() {
          drawerWidth = maximumDrawerWidth;
        });
      }
    } else {
      if (dragEndAt > maximumDrawerWidth - 100) {
        setState(() {
          drawerWidth = maximumDrawerWidth;
        });
      } else {
        setState(() {
          drawerWidth = minimumDrawerWidth;
        });
      }
    }
    setState(() {
      dragStartAt = minimumDrawerWidth;
    });
  }

  void onDragStart(DragStartDetails details) {
    setState(() {
      dragStartAt = details.localPosition.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      //   DesktopWindow.setMinWindowSize(Size(500, 700));
      // }
      //check if tablet or not
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
                              if (widget.title != null) ...{
                                Container(
                                  height: 60,
                                  alignment: AlignmentDirectional.centerStart,
                                  margin: const EdgeInsets.only(left: 15),
                                  child: widget.title,
                                )
                              },
                            ],
                          )),
                      Expanded(
                          child: ListView(
                        children: [
                          if (widget.drawerItems != null) ...{
                            for (var item in widget.drawerItems!) ...{
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
                                                _selectedContent = item.content;
                                              });
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
                                                  _selectedContent =
                                                      sub_items.content;
                                                });
                                              }
                                            : null,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35),
                                        child: Row(
                                          children: [
                                            if (_selectedDrawerItem ==
                                                item) ...{
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
                    children: [
                      //leading
                      if (widget.drawerItems != null) ...{
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
                      },
                      if (widget.title != null) ...{
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          alignment: AlignmentDirectional.centerStart,
                          child: widget.title,
                        ),
                      },
                      Spacer(),

                      //errpr on stream
                      Container(child: NotificationCard()),
                      PopupMenuButton(
                          offset: Offset(0, 50),
                          icon: FittedBox(
                            child: Row(
                              children: [
                                CircleAvatar(),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Container(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.red,
                                          ),
                                          SizedBox(
                                            height: MySpacer.medium,
                                          ),
                                          Text(profileData!.firstName!),
                                          Text(profileData!.email!),
                                          SizedBox(
                                            height: MySpacer.medium,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.black38,
                                                )),
                                            child: MaterialButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedContent =
                                                        GeneralSettings();
                                                  });
                                                },
                                                child: Text("Manage Account")),
                                          ),
                                          SizedBox(
                                            height: MySpacer.medium,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, "/login");
                                                },
                                                child: Text("logout"),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ]),
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
                                  print(showDrawerText);
                                },
                                duration: Duration(milliseconds: 100),
                                width: drawerWidth,
                                height: MediaQuery.of(context).size.height,
                                color: widget.drawerBackgroundColor,
                                child: ListView(
                                  children: [
                                    for (DrawerItem item
                                        in widget.drawerItems!) ...{
                                      Container(
                                        color: _selectedContent == item.content
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
                                                  color: _selectedContent ==
                                                          item.content
                                                      ? Palette.drawerColor
                                                      : Colors.white,
                                                ),
                                                onSelected: (value) {
                                                  setState(() {
                                                    _selectedContent = value;
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
                                                              _selectedContent =
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
                                                        color:
                                                            _selectedContent ==
                                                                    item.content
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
                                                              color: _selectedContent ==
                                                                      item
                                                                          .content
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
                                                      Icon(_selectedDrawerItem ==
                                                              item
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down)
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
                                              color: _selectedContent ==
                                                      sub_items.content
                                                  ? Colors.grey[200]
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
                                                          _selectedContent =
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
                                                        color: Colors.white,
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
                                                              color:
                                                                  Colors.white),
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
                          Expanded(child: _selectedContent)
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
    });
  }
}
