import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/datasource/computers_datasource.dart';
import 'package:record_management_system/models/computer.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/pages/add_computer.dart';
import 'package:record_management_system/widgets/custom_button.dart';
import 'package:record_management_system/widgets/custom_container.dart';
import 'package:record_management_system/widgets/custom_table.dart';
import 'package:record_management_system/widgets/custom_title.dart';
import 'package:record_management_system/widgets/progress_widget.dart';

class Computers extends StatefulWidget {
  const Computers({super.key});

  @override
  State<Computers> createState() => _ComputersState();
}

class _ComputersState extends State<Computers> {
  Future<void> addComputer(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return AlertDialog(
            content: SizedBox(
              height: 325,
              width: 400,
              child: AddComputer(
                computerID: "",
                recordAction: RecordAction.add,
                exitPopup: (v) => Navigator.pop(context, v),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTitle(title: "Computers"),
        StreamBuilder<QuerySnapshot>(
          stream: Config.computersCollection
              .orderBy("timestamp", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else {
              List<Computer> computers = [];

              snapshot.data!.docs.forEach((element) {
                Computer computer = Computer.fromDocument(element);
                computers.add(computer);
              });

              return CustomContainer(
                containerInsidePadding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SecondaryTitle(
                        iconData: Icons.computer,
                        title: "Available Computers",
                        showDivider: false,
                        secondaryWidget: BorderButton(
                            title: "Add",
                            iconData: Icons.add_rounded,
                            color: Config.themeColor,
                            isActive: true,
                            onPressed: () => addComputer(context)),
                      ),
                    ),
                    CustomTable(
                        dataSource: ComputersDataSource(
                            context: context, computers: computers),
                        columns: computersColumns),
                    const SizedBox(height: 20.0)
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
