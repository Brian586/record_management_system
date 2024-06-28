import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:record_management_system/pages/computers.dart';
import 'package:record_management_system/pages/dashboard.dart';
import 'package:record_management_system/pages/textbooks.dart';
import 'package:record_management_system/widgets/custom_appbar.dart';
import 'package:record_management_system/widgets/custom_drawer.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  final String userid;
  final String currentpage;
  const HomePage({super.key, required this.userid, required this.currentpage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget buildBody() {
    switch (widget.currentpage) {
      case "dashboard":
        return Dashboard();
      case "textbooks":
        return Textbooks();
      case "sewing_machines":
        return Text("sewing_machines");
      case "computers":
        return Computers();
      case "settings":
        return Text("settings");
      default:
        return Text("error");
    }
  }

  Widget desktoplayout() {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250.0,
            child: CustomDrawer(
              userid: widget.userid,
            ),
          ),
          Expanded(
              child: Column(
            children: [
              CustomAppbar(),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: buildBody(),
                ),
              ))
            ],
          ))
        ],
      ),
    );
  }

  Widget mobileLayout() {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(size.width, 55.0), child: CustomAppbar()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: buildBody(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (p0) => desktoplayout(),
      tablet: (p0) => mobileLayout(),
      mobile: (p0) => mobileLayout(),
      watch: (p0) => Container(),
    );
  }
}
