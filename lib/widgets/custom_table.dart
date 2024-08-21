import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../config.dart';
import '../models/my_column.dart';
import 'custom_scrollbar.dart';

class CustomTable extends StatefulWidget {
  final DataGridSource dataSource;
  final List<MyColumn> columns;
  final bool? showCheckboxColumn;
  final SelectionMode? selectionMode;
  final DataGridController? controller;
  final List<String>? alignRightItems;
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
      this.alignRightItems = const [],
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

  double paddingAndOtherDistances(SizingInformation sizingInformation) {
    bool isDesktop = sizingInformation.isDesktop;

    double scrollbarWidth =
        isDesktop ? Config.scrollbarWidth : Config.scrollbarWidthMobile;

    return 10.0 + (widget.showCheckboxColumn! ? 50.0 : 0.0) + scrollbarWidth;
  }

  double calculateWidth(SizingInformation sizingInformation, Size size,
      MyColumn column, double drawerWidth) {
    double modifiedDrawerWidth =
        sizingInformation.isDesktop ? drawerWidth : 0.0;
    double currentWidth = (size.width -
        (modifiedDrawerWidth + paddingAndOtherDistances(sizingInformation)));
    double columnsWidth = 0.0;
    widget.columns.forEach((element) {
      columnsWidth += element.width;
    });

    if (currentWidth > columnsWidth) {
      double ratio = column.width / columnsWidth;
      return (currentWidth * ratio);
      // return currentWidth / widget.columns.length;
    } else {
      return column.width;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return CustomScrollBar(
          controller: _controller,
          width: 6.0,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
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
                // rowHeight: 40.0,
                footerHeight: widget.footerHeight!,
                headerRowHeight: widget.headerRowHeight!,
                shrinkWrapRows: true,
                shrinkWrapColumns: true,
                horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                verticalScrollPhysics: const AlwaysScrollableScrollPhysics(),
                gridLinesVisibility: GridLinesVisibility.horizontal,
                columnWidthMode: ColumnWidthMode
                    .fill, // This line ensures columns fill the available width
                columns: List.generate(widget.columns.length, (index) {
                  MyColumn myColumn = widget.columns[index];
                  List<String> alignRightItems = [];
                  alignRightItems.addAll(widget.alignRightItems!);
                  alignRightItems.add("actions");
                  bool alignRight =
                      alignRightItems.contains(myColumn.columnName);

                  return GridColumn(
                      width: calculateWidth(sizingInformation, size, myColumn,
                          Config.firstSectionMaxWidth),
                      // columnWidthMode: ColumnWidthMode.fitByColumnName,
                      allowEditing: true,
                      allowSorting: false,
                      autoFitPadding:
                          const EdgeInsets.symmetric(horizontal: 1.0),
                      columnName: myColumn.columnName,
                      label: Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: alignRight ? 10.0 : 0.0),
                        child: Align(
                          alignment: alignRight
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            myColumn.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
      },
    );
  }
}
