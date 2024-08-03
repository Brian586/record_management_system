import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/models/sewing_machine.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SewingMachinesDataSource extends DataGridSource {
  List<DataGridRow> _sewingmachines = [];

  SewingMachinesDataSource({required List<SewingMachine> sewingmachines}) {
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
                      DateTime.fromMillisecondsSinceEpoch(machine.timestamp)))
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _sewingmachines;

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
