class MyColumn {
  String columnName;
  String title;
  double width;
  MyColumn(
      {required this.columnName, required this.title, required this.width});
}

List<MyColumn> textbooksColumns = [
  MyColumn(
    columnName: "id",
    title: "Textbook id",
    width: 100.0,
  ),
  MyColumn(
    columnName: "name",
    title: "Name",
    width: 200.0,
  ),
  MyColumn(
    columnName: "subject",
    title: "Subject",
    width: 100.0,
  ),
  MyColumn(
    columnName: "level",
    title: "Level",
    width: 100.0,
  ),
  MyColumn(
    columnName: "condition",
    title: "Condition",
    width: 100.0,
  ),
  MyColumn(
    columnName: "created",
    title: "Date uploaded",
    width: 100.0,
  ),
];

List<MyColumn> computersColumns = [
  MyColumn(columnName: "id", title: "Computer id", width: 150.0),
  MyColumn(columnName: "name", title: "Computer Name", width: 150.0),
  MyColumn(columnName: "condition", title: "Condition", width: 150.0),
  MyColumn(columnName: "date", title: "date", width: 150.0),
];
