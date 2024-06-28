import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record_management_system/models/computer.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ComputersDataSource extends DataGridSource {
  List<DataGridRow> _computers = [];

  ComputersDataSource({required List<Computer> computers}) {
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
                      DateTime.fromMillisecondsSinceEpoch(computer.timestamp)))
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _computers;

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
