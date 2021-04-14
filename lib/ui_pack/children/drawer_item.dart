import 'package:flutter/material.dart';
import 'package:uitemplate/ui_pack/children/sub_drawer_item.dart';

class DrawerItem {
  final IconData? icon;
  final String? text;
  final Widget? content;
  final List<SubDrawerItems>? subItems;
  DrawerItem(
      {@required this.icon,
      @required this.text,
      this.subItems,
      @required this.content});
}
