import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/widgets/custom_container.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../widgets/custom_title.dart';

class Dashboard extends StatefulWidget {
  final String userid;
  const Dashboard({super.key, required this.userid});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget buildDesktopUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: DashCard(userid: widget.userid, dashItem: dashItems[0])),
            Expanded(
                flex: 1,
                child: DashCard(userid: widget.userid, dashItem: dashItems[1])),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: DashCard(userid: widget.userid, dashItem: dashItems[2])),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ],
    );
  }

  Widget buildMobileUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(dashItems.length, (index) {
        return DashCard(userid: widget.userid, dashItem: dashItems[index]);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      bool isDesktop = sizingInfo.isDesktop || sizingInfo.isTablet;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTitle(title: "Dashboard"),
          if (isDesktop) ...[
            buildDesktopUI(),
          ] else ...[
            buildMobileUI()
          ]
        ],
      );
    });
  }
}

class DashCard extends StatelessWidget {
  final String userid;
  final DashItem dashItem;
  const DashCard({super.key, required this.dashItem, required this.userid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: dashItem.collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          int count = snapshot.data!.docs.length;

          return CustomContainer(
              color: dashItem.color,
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dashItem.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        count.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        dashItem.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10.0),
                      TextButton.icon(
                          onPressed: () {
                            GoRouter.of(context)
                                .go("/home/$userid/${dashItem.link}");
                          },
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          label: const Text("See Details"))
                    ],
                  )),
                  const SizedBox(width: 10.0),
                  Image.asset(
                    dashItem.imageUrl,
                    height: 200.0,
                    width: 200.0,
                    fit: BoxFit.contain,
                  )
                ],
              ));
        });
  }
}

class DashItem {
  String title;
  CollectionReference collectionReference;
  Color color;
  String description;
  String link;
  String imageUrl;

  DashItem(
      {required this.title,
      required this.collectionReference,
      required this.color,
      required this.description,
      required this.link,
      required this.imageUrl});
}

List<DashItem> dashItems = [
  DashItem(
      title: "TextBooks",
      collectionReference: Config.textbooksCollection,
      color: const Color.fromRGBO(233, 208, 216, 1.0),
      description: "Keep track of school textbooks in the system.",
      link: "textbooks",
      imageUrl: Config.textbooksImage),
  DashItem(
      title: "Sewing Machines",
      collectionReference: Config.sewingmachinesCollection,
      color: const Color.fromRGBO(254, 247, 238, 1.0),
      description: "Manage Sewing Machines enlisted in this system.",
      link: "sewing_machines",
      imageUrl: Config.sewingImage),
  DashItem(
      title: "Computers",
      collectionReference: Config.computersCollection,
      color: const Color.fromRGBO(208, 222, 255, 1.0),
      description: "Monitor the state and conditions of all computers.",
      link: "computers",
      imageUrl: Config.computerImage),
];
