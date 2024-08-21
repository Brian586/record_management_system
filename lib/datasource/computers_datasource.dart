import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record_management_system/models/computer.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../common_functions/delete_record.dart';
import '../config.dart';
import '../pages/add_computer.dart';

class ComputersDataSource extends DataGridSource {
  List<DataGridRow> _computers = [];

  ComputersDataSource(
      {required BuildContext context, required List<Computer> computers}) {
    _computers = computers
        .map<DataGridRow>((computer) => DataGridRow(cells: [
              DataGridCell(
                  columnName: computersColumns[0].columnName,
                  value: computer.computerid),
              DataGridCell(
                  columnName: computersColumns[1].columnName,
                  value: computer.computername),
              DataGridCell(
                  columnName: computersColumns[2].columnName,
                  value: computer.condition),
              DataGridCell(
                  columnName: computersColumns[3].columnName,
                  value: DateFormat("dd MMM yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(computer.timestamp))),
              DataGridCell<Map<String, dynamic>>(
                  columnName: computersColumns[4].columnName,
                  value: {
                    "id": computer.timestamp.toString(),
                    "context": context,
                  })
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _computers;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      bool isActions = dataGridCell.columnName == "actions";
      return Container(
        alignment: isActions ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        child: isActions
            ? buildCompActions(dataGridCell)
            : Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

Widget buildCompActions(dataGridCell) {
  String computerID = dataGridCell.value["id"];
  BuildContext context = dataGridCell.value["context"];

  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton.icon(
          onPressed: () async {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (c) {
                  return AlertDialog(
                    // title: const Text("Add Computer"),
                    content: SizedBox(
                      height: 325,
                      width: 400,
                      child: AddComputer(
                        computerID: computerID,
                        recordAction: RecordAction.edit,
                        exitPopup: (v) => Navigator.pop(context, v),
                      ),
                    ),
                  );
                });
          },
          icon: const Icon(
            Icons.edit_rounded,
            size: 15.0,
            color: Colors.grey,
          ),
          label: const Text(
            "Edit",
            style: TextStyle(color: Colors.grey),
          )),
      TextButton.icon(
          onPressed: () async {
            await deleteRecord(
                context: context,
                title: "Delete Record",
                description: "Do you wish to delete this record?",
                deleteFn: () async {
                  DocumentSnapshot doc =
                      await Config.computersCollection.doc(computerID).get();

                  if (doc.exists) {
                    await doc.reference.delete();
                  }

                  return "success";
                });
          },
          icon: const Icon(
            Icons.delete_forever_outlined,
            size: 15.0,
            color: Colors.red,
          ),
          label: const Text(
            "Delete",
            style: TextStyle(color: Colors.red),
          )),
    ],
  );
}
