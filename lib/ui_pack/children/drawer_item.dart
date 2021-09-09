import 'package:flutter/material.dart';
import 'package:uitemplate/ui_pack/children/sub_drawer_item.dart';

class DrawerItem {
  final String? icon;
  final String? text;
  final Widget? content;
  bool? selected = false;
  final List<SubDrawerItems>? subItems;
  DrawerItem(
      {@required this.icon,
      @required this.text,
      this.subItems,
      this.selected,
      @required this.content});
}
