import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/models/drawer_item.dart';

class CustomDrawer extends StatefulWidget {
  final String userid;
  const CustomDrawer({super.key, required this.userid});

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
