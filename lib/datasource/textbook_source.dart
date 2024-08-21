import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../common_functions/delete_record.dart';
import '../config.dart';
import '../models/textbook.dart';
import '../pages/add_textbook.dart';

class TextbookDataSource extends DataGridSource {
  List<DataGridRow> _textbooks = [];

  TextbookDataSource(
      {required BuildContext context, required List<Textbook> textbooks}) {
    _textbooks = textbooks
        .map<DataGridRow>((textbook) => DataGridRow(cells: [
              DataGridCell(
                  columnName: textbooksColumns[0].columnName,
                  value: textbook.id),
              DataGridCell(
                  columnName: textbooksColumns[1].columnName,
                  value: textbook.name),
              DataGridCell(
                  columnName: textbooksColumns[2].columnName,
                  value: textbook.subject),
              DataGridCell(
                  columnName: textbooksColumns[3].columnName,
                  value: textbook.level),
              DataGridCell(
                  columnName: textbooksColumns[4].columnName,
                  value: textbook.condition),
              DataGridCell(
                  columnName: textbooksColumns[5].columnName,
                  value: DateFormat("dd MMM yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(textbook.timestamp))),
              DataGridCell<Map<String, dynamic>>(
                  columnName: textbooksColumns[6].columnName,
                  value: {
                    "id": textbook.timestamp.toString(),
                    "context": context,
                  })
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _textbooks;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      bool isActions = dataGridCell.columnName == "actions";
      return Container(
        alignment: isActions ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        child: isActions
            ? buildTextBookActions(dataGridCell)
            : Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

Widget buildTextBookActions(dataGridCell) {
  String textbookID = dataGridCell.value["id"];
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
                      child: AddTextbook(
                        textbookID: textbookID,
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
                      await Config.textbooksCollection.doc(textbookID).get();

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
