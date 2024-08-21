import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/datasource/textbook_source.dart';
import 'package:record_management_system/models/my_column.dart';
import 'package:record_management_system/pages/add_textbook.dart';
import 'package:record_management_system/widgets/custom_container.dart';
import 'package:record_management_system/widgets/custom_table.dart';
import 'package:record_management_system/widgets/progress_widget.dart';

import '../models/textbook.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_title.dart';

class Textbooks extends StatefulWidget {
  const Textbooks({super.key});

  @override
  State<Textbooks> createState() => _TextbooksState();
}

class _TextbooksState extends State<Textbooks> {
  Future<void> addTextbook(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) {
          return AlertDialog(
            content: SizedBox(
              height: 325,
              width: 400,
              child: AddTextbook(
                textbookID: "",
                recordAction: RecordAction.add,
                exitPopup: (v) => Navigator.pop(context, v),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTitle(title: "Textbooks"),
        StreamBuilder<QuerySnapshot>(
          stream: Config.textbooksCollection
              .orderBy("timestamp", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            } else {
              List<Textbook> textbooks = [];

              snapshot.data!.docs.forEach((element) {
                Textbook textbook = Textbook.fromDocument(element);

                textbooks.add(textbook);
              });

              return CustomContainer(
                containerInsidePadding: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SecondaryTitle(
                        iconData: Icons.menu_book_rounded,
                        title: "Available TextBooks",
                        showDivider: false,
                        secondaryWidget: BorderButton(
                            title: "Add",
                            iconData: Icons.add_rounded,
                            color: Config.themeColor,
                            isActive: true,
                            onPressed: () => addTextbook(context)),
                      ),
                    ),
                    CustomTable(
                        dataSource: TextbookDataSource(
                            context: context, textbooks: textbooks),
                        columns: textbooksColumns),
                    const SizedBox(height: 20.0)
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
