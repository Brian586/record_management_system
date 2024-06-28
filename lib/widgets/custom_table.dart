import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../config.dart';
import '../models/my_column.dart';

class CustomTable extends StatefulWidget {
  final DataGridSource dataSource;
  final List<MyColumn> columns;
  final bool? showCheckboxColumn;
  final SelectionMode? selectionMode;
  final DataGridController? controller;
  final void Function(List<DataGridRow>, List<DataGridRow>)? onSelectionChanged;
  final Widget? footer;
  final bool? allowEditing;
  final EditingGestureType? editingGestureType;
  final double? headerRowHeight;
  final double? footerHeight;
  final int? rowsPerPage;
  const CustomTable(
      {super.key,
      required this.dataSource,
      required this.columns,
      this.showCheckboxColumn = false,
      this.selectionMode = SelectionMode.none,
      this.controller,
      this.onSelectionChanged,
      this.footer,
      this.rowsPerPage,
      this.allowEditing = true,
      this.editingGestureType = EditingGestureType.doubleTap,
      this.headerRowHeight = 50.0,
      this.footerHeight = 49.0});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
              headerHoverColor: Colors.white.withOpacity(0.3),
              headerColor: Config.themeColor.withOpacity(0.5)),
          child: SfDataGrid(
            showCheckboxColumn: widget.showCheckboxColumn!,
            selectionMode: widget.selectionMode!,
            onSelectionChanged: widget.onSelectionChanged,
            controller: widget.controller,
            source: widget.dataSource,
            rowsPerPage: widget.rowsPerPage,
            allowSorting: true,
            allowSwiping: false,
            allowEditing: widget.allowEditing!,
            editingGestureType: widget.editingGestureType!,
            navigationMode: GridNavigationMode.cell,
            isScrollbarAlwaysShown: true,
            rowHeight: 30.0,
            footerHeight: widget.footerHeight!,
            headerRowHeight: widget.headerRowHeight!,
            shrinkWrapRows: true,
            shrinkWrapColumns: true,
            horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
            verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
            gridLinesVisibility: GridLinesVisibility.horizontal,
            columns: List.generate(widget.columns.length, (index) {
              MyColumn myColumn = widget.columns[index];

              return GridColumn(
                  width: myColumn.width,
                  // columnWidthMode: ColumnWidthMode.fitByColumnName,
                  allowEditing: true,
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  columnName: myColumn.columnName,
                  label: Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        myColumn.title,
                        // style: const TextStyle(fontSize: 11.0),
                        // style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ));
            }),
            footer: widget.footer,
          ),
        ),
      ),
    );
  }
}
