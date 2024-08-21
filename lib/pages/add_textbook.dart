import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/models/textbook.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';
import 'package:record_management_system/widgets/progress_widget.dart';

import '../common_functions/custom_toast.dart';

class AddTextbook extends StatefulWidget {
  final String textbookID;
  final RecordAction recordAction;
  final void Function(String) exitPopup;
  const AddTextbook(
      {super.key,
      required this.textbookID,
      required this.recordAction,
      required this.exitPopup});

  @override
  State<AddTextbook> createState() => _AddTextbookState();
}

class _AddTextbookState extends State<AddTextbook> {
  TextEditingController idCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController conditionCtrl = TextEditingController();
  TextEditingController levelCtrl = TextEditingController();
  bool isloading = false;

  Textbook? oldTextbook;

  @override
  void initState() {
    super.initState();

    if (widget.recordAction == RecordAction.edit) {
      getRecordInfo();
    }
  }

  Future<void> getRecordInfo() async {
    setState(() {
      isloading = true;
    });

    DocumentSnapshot doc =
        await Config.textbooksCollection.doc(widget.textbookID).get();

    oldTextbook = Textbook.fromDocument(doc);

    setState(() {
      idCtrl.text = oldTextbook!.id;
      nameCtrl.text = oldTextbook!.name;
      subjectCtrl.text = oldTextbook!.subject;
      levelCtrl.text = oldTextbook!.level.toString();
      conditionCtrl.text = oldTextbook!.condition;
      isloading = false;
    });
  }

  void saveTextbookInfo() async {
    setState(() {
      isloading = true;
    });

    try {
      if (widget.recordAction == RecordAction.add) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        Textbook textbook = Textbook(
            id: idCtrl.text.trim(),
            name: nameCtrl.text.trim(),
            subject: subjectCtrl.text.trim(),
            condition: conditionCtrl.text.trim(),
            level: int.parse(levelCtrl.text.trim()),
            timestamp: timestamp);

        await Config.textbooksCollection
            .doc(timestamp.toString())
            .set(textbook.toMap());
      } else {
        Textbook textbook = Textbook(
            id: idCtrl.text.trim(),
            name: nameCtrl.text.trim(),
            subject: subjectCtrl.text.trim(),
            condition: conditionCtrl.text.trim(),
            level: int.parse(levelCtrl.text.trim()),
            timestamp: oldTextbook!.timestamp);

        await Config.textbooksCollection
            .doc(textbook.timestamp.toString())
            .update(textbook.toMap());
      }

      showCustomToast("uploaded successfully", type: "");

      setState(() {
        isloading = false;
      });

      widget.exitPopup("success");
    } catch (error) {
      showCustomToast("an error occured", type: "error");
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomWrapper(
        maxWidth: 500.0,
        child: isloading
            ? circularProgress()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.recordAction == RecordAction.add
                        ? "Add Textbook"
                        : "Edit Textbook Details",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    controller: idCtrl,
                    decoration: const InputDecoration(
                        labelText: "Textbook ID", hintText: "1,2,3..."),
                  ),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: "Textbook Name",
                        hintText: "Type something here"),
                  ),
                  TextFormField(
                    controller: subjectCtrl,
                    decoration: const InputDecoration(
                        labelText: "Textbook Subject",
                        hintText: " Enter subject"),
                  ),
                  TextFormField(
                    controller: conditionCtrl,
                    decoration: const InputDecoration(
                        labelText: "Textbook Condition",
                        hintText: "Enter condition"),
                  ),
                  TextFormField(
                    controller: levelCtrl,
                    decoration: const InputDecoration(
                        labelText: "Textbook Level", hintText: "1,2,3..."),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () => widget.exitPopup("cancelled"),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          )),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                          onPressed: () {
                            if (idCtrl.text.isNotEmpty &&
                                nameCtrl.text.isNotEmpty &&
                                subjectCtrl.text.isNotEmpty &&
                                conditionCtrl.text.isNotEmpty &&
                                int.parse(levelCtrl.text.trim()) > 0) {
                              saveTextbookInfo();
                            }
                          },
                          child: Text(
                            widget.recordAction == RecordAction.add
                                ? "Save"
                                : "Update",
                            style: const TextStyle(color: Colors.white),
                          )),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
