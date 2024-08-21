import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/models/drawer_item.dart';

class CustomDrawer extends StatefulWidget {
  final String userid;
  final bool isMobile;
  const CustomDrawer({super.key, required this.userid, required this.isMobile});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: 60.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                draweritems.length,
                (index) => ListTile(
                      onTap: () {
                        GoRouter.of(context).go(
                            "/home/${widget.userid}/${draweritems[index].id}");

                        if (widget.isMobile) {
                          Timer(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      leading: Icon(
                        draweritems[index].icon,
                        color: Colors.white,
                      ),
                      title: Text(
                        draweritems[index].title,
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
          ),
        ],
      ),
    );
  }
}
