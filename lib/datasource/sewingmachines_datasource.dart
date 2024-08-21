import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/models/sewing_machine.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../common_functions/delete_record.dart';
import '../config.dart';
import '../pages/add_sewingmachine.dart';

class SewingMachinesDataSource extends DataGridSource {
  List<DataGridRow> _sewingmachines = [];

  SewingMachinesDataSource(
      {required BuildContext context,
      required List<SewingMachine> sewingmachines}) {
    _sewingmachines = sewingmachines
        .map<DataGridRow>((machine) => DataGridRow(cells: [
              DataGridCell(
                  columnName: sewingMachineColumns[0].columnName,
                  value: machine.id),
              DataGridCell(
                  columnName: sewingMachineColumns[1].columnName,
                  value: machine.condition),
              DataGridCell(
                  columnName: sewingMachineColumns[2].columnName,
                  value: DateFormat("dd MMM yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(machine.timestamp))),
              DataGridCell<Map<String, dynamic>>(
                  columnName: sewingMachineColumns[3].columnName,
                  value: {
                    "id": machine.timestamp.toString(),
                    "context": context,
                  })
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _sewingmachines;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      bool isActions = dataGridCell.columnName == "actions";
      return Container(
        alignment: isActions ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        child: isActions
            ? buildMachineActions(dataGridCell)
            : Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

Widget buildMachineActions(dataGridCell) {
  String machineID = dataGridCell.value["id"];
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
                    content: SizedBox(
                      height: 325,
                      width: 400,
                      child: AddSewingMachine(
                        sewingMachineID: machineID,
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
                  DocumentSnapshot doc = await Config.sewingmachinesCollection
                      .doc(machineID)
                      .get();

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
