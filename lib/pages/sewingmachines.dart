import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/datasource/sewingmachines_datasource.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/models/sewing_machine.dart';
import 'package:record_management_system/pages/add_sewingmachine.dart';
import 'package:record_management_system/widgets/custom_table.dart';

import '../widgets/circular_progress.dart';
import '../widgets/custom_header.dart';

class SewingMachines extends StatefulWidget {
  const SewingMachines({super.key});

  @override
  State<SewingMachines> createState() => _SewingMachinesState();
}

class _SewingMachinesState extends State<SewingMachines> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeader(title: "sewing machines"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("sewingmachines")
              .orderBy("timestamp", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgress();
            } else {
              List<SewingMachine> machines = [];

              snapshot.data!.docs.forEach((element) {
                SewingMachine machine = SewingMachine.fromDocument(element);
                machines.add(machine);
              });

              return CustomTable(
                  dataSource:
                      SewingMachinesDataSource(sewingmachines: machines),
                  columns: sewingMachineColumns);
            }
          },
        ),
        AddSewingMachine()
      ],
    );
  }
}
