import 'package:flutter/material.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/pages/computers.dart';
import 'package:record_management_system/pages/dashboard.dart';
import 'package:record_management_system/pages/settings.dart';
import 'package:record_management_system/pages/sewingmachines.dart';
import 'package:record_management_system/pages/textbooks.dart';
import 'package:record_management_system/widgets/custom_appbar.dart';
import 'package:record_management_system/widgets/custom_drawer.dart';
import 'package:record_management_system/widgets/custom_scrollbar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  final String userid;
  final String currentpage;
  const HomePage({super.key, required this.userid, required this.currentpage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBody() {
    switch (widget.currentpage) {
      case "dashboard":
        return Dashboard(
          userid: widget.userid,
        );
      case "textbooks":
        return const Textbooks();
      case "sewing_machines":
        return const SewingMachines();
      case "computers":
        return const Computers();
      case "settings":
        return SettingsPage(userid: widget.userid);
      default:
        return const Text("error");
    }
  }

  Widget desktoplayout() {
    return Scaffold(
      key: scaffoldKey,
      body: Row(
        children: [
          SizedBox(
            width: Config.firstSectionMaxWidth,
            child: CustomDrawer(
              userid: widget.userid,
              isMobile: false,
            ),
          ),
          Expanded(
              child: Column(
            children: [
              CustomAppbar(
                userid: widget.userid,
                scaffoldKey: scaffoldKey,
              ),
              Expanded(
                  child: CustomScrollBar(
                controller: _controller,
                child: SingleChildScrollView(
                  controller: _controller,
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
      key: scaffoldKey,
      drawer: CustomDrawer(
        userid: widget.userid,
        isMobile: true,
      ),
      appBar: PreferredSize(
          preferredSize: Size(size.width, kToolbarHeight),
          child: CustomAppbar(
            userid: widget.userid,
            scaffoldKey: scaffoldKey,
          )),
      body: CustomScrollBar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
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
