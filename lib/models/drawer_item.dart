import 'package:flutter/material.dart';

class DrawerItem {
  final String id;
  final String title;

  final IconData icon;
  const DrawerItem({
    required this.id,
    required this.title,
    required this.icon,
  });
}

List<DrawerItem> draweritems = [
  DrawerItem(id: "dashboard", title: "Dashboard", icon: Icons.home_rounded),
  DrawerItem(id: "textbooks", title: "Textbooks", icon: Icons.menu_book),
  DrawerItem(id: "sewing_machines", title: "Sewing Machines", icon: Icons.iron),
  DrawerItem(id: "computers", title: "Computers", icon: Icons.computer),
  DrawerItem(id: "settings", title: "Settings", icon: Icons.settings),
];
