import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/textbook.dart';

class TextbookDataSource extends DataGridSource {
  List<DataGridRow> _textbooks = [];

  TextbookDataSource({required List<Textbook> textbooks}) {
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
                      DateTime.fromMillisecondsSinceEpoch(textbook.timestamp)))
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _textbooks;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
