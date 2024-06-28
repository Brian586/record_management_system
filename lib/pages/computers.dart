import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/datasource/computers_datasource.dart';
import 'package:record_management_system/models/computer.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/pages/add_computer.dart';
import 'package:record_management_system/widgets/circular_progress.dart';
import 'package:record_management_system/widgets/custom_header.dart';
import 'package:record_management_system/widgets/custom_table.dart';

class Computers extends StatefulWidget {
  const Computers({super.key});

  @override
  State<Computers> createState() => _ComputersState();
}

class _ComputersState extends State<Computers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeader(title: "computers"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("computers")
              .orderBy("timestamp", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgress();
            } else {
              List<Computer> computers = [];

              snapshot.data!.docs.forEach((element) {
                Computer computer = Computer.fromDocument(element);
                computers.add(computer);
              });

              return CustomTable(
                  dataSource: ComputersDataSource(computers: computers),
                  columns: computersColumns);
            }
          },
        ),
        AddComputer()
      ],
    );
  }
}
