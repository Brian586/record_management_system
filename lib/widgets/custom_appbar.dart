import 'package:flutter/material.dart';
import 'package:record_management_system/widgets/account_info.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomAppbar extends StatefulWidget {
  final String userid;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppbar(
      {super.key, required this.userid, required this.scaffoldKey});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(builder: (context, sizinInfo) {
      bool isMobile = sizinInfo.isMobile;
      bool isTablet = sizinInfo.isTablet;

      return Container(
        width: size.width,
        height: kToolbarHeight,
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 4.0),
              blurRadius: 10.0,
              spreadRadius: 10.0)
        ]),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10.0),
                  if (isTablet || isMobile) ...[
                    IconButton(
                        onPressed: () {
                          widget.scaffoldKey.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu_rounded)),
                    const SizedBox(width: 10.0)
                  ],
                  Text(isMobile ? "RMS" : "Record Management System"),
                ],
              ),
              AccountInfo(userid: widget.userid)
            ],
          ),
        ),
      );
    });
  }
}
