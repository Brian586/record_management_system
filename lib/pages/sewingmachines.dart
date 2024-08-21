import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/datasource/sewingmachines_datasource.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/models/sewing_machine.dart';
import 'package:record_management_system/pages/add_sewingmachine.dart';
import 'package:record_management_system/widgets/custom_container.dart';
import 'package:record_management_system/widgets/custom_table.dart';
import 'package:record_management_system/widgets/progress_widget.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_title.dart';

class SewingMachines extends StatefulWidget {
  const SewingMachines({super.key});

  @override
  State<SewingMachines> createState() => _SewingMachinesState();
}

class _SewingMachinesState extends State<SewingMachines> {
  Future<void> addSewingMachine(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return AlertDialog(
            content: SizedBox(
              height: 325,
              width: 400,
              child: AddSewingMachine(
                sewingMachineID: "",
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
        const CustomTitle(title: "Sewing Machines"),
        StreamBuilder<QuerySnapshot>(
          stream: Config.sewingmachinesCollection
              .orderBy("timestamp", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else {
              List<SewingMachine> machines = [];

              snapshot.data!.docs.forEach((element) {
                SewingMachine machine = SewingMachine.fromDocument(element);
                machines.add(machine);
              });

              return CustomContainer(
                containerInsidePadding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SecondaryTitle(
                        iconData: Icons.iron_rounded,
                        title: "Available Sewing Machines",
                        showDivider: false,
                        secondaryWidget: BorderButton(
                            title: "Add",
                            iconData: Icons.add_rounded,
                            color: Config.themeColor,
                            isActive: true,
                            onPressed: () => addSewingMachine(context)),
                      ),
                    ),
                    CustomTable(
                        dataSource: SewingMachinesDataSource(
                            context: context, sewingmachines: machines),
                        columns: sewingMachineColumns),
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
