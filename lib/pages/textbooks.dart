import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/datasource/textbook_source.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/pages/add_textbook.dart';
import 'package:record_management_system/widgets/circular_progress.dart';
import 'package:record_management_system/widgets/custom_header.dart';
import 'package:record_management_system/widgets/custom_table.dart';

import '../models/textbook.dart';

class Textbooks extends StatefulWidget {
  const Textbooks({super.key});

  @override
  State<Textbooks> createState() => _TextbooksState();
}

class _TextbooksState extends State<Textbooks> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeader(title: "Textbooks"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("textbooks")
              .orderBy("timestamp", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgress();
            } else {
              List<Textbook> textbooks = [];

              snapshot.data!.docs.forEach((element) {
                Textbook textbook = Textbook.fromDocument(element);

                textbooks.add(textbook);
              });

              return CustomTable(
                  dataSource: TextbookDataSource(textbooks: textbooks),
                  columns: textbooksColumns);
            }
          },
        ),
        AddTextbook()
      ],
    );
  }
}
