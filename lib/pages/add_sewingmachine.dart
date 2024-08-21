import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/models/sewing_machine.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';
import 'package:record_management_system/widgets/progress_widget.dart';

import '../common_functions/custom_toast.dart';
import '../config.dart';

class AddSewingMachine extends StatefulWidget {
  final String sewingMachineID;
  final RecordAction recordAction;
  final void Function(String) exitPopup;
  const AddSewingMachine(
      {super.key,
      required this.sewingMachineID,
      required this.recordAction,
      required this.exitPopup});

  @override
  State<AddSewingMachine> createState() => _AddSewingMachineState();
}

class _AddSewingMachineState extends State<AddSewingMachine> {
  TextEditingController idCtrl = TextEditingController();
  TextEditingController conditionCtrl = TextEditingController();
  bool loading = false;

  SewingMachine? oldSewingMachine;

  @override
  void initState() {
    super.initState();

    if (widget.recordAction == RecordAction.edit) {
      getRecordInfo();
    }
  }

  Future<void> getRecordInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot doc =
        await Config.sewingmachinesCollection.doc(widget.sewingMachineID).get();

    oldSewingMachine = SewingMachine.fromDocument(doc);

    setState(() {
      idCtrl.text = oldSewingMachine!.id;
      conditionCtrl.text = oldSewingMachine!.condition;
      loading = false;
    });
  }

  Future<void> saveToDb() async {
    setState(() {
      loading = true;
    });

    try {
      if (widget.recordAction == RecordAction.add) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        SewingMachine sewingMachine = SewingMachine(
            id: idCtrl.text.trim(),
            condition: conditionCtrl.text.trim(),
            timestamp: timestamp);

        await FirebaseFirestore.instance
            .collection('sewingmachines')
            .doc(sewingMachine.timestamp.toString())
            .set(sewingMachine.toMap());
      } else {
        SewingMachine sewingMachine = SewingMachine(
            id: idCtrl.text.trim(),
            condition: conditionCtrl.text.trim(),
            timestamp: oldSewingMachine!.timestamp);

        await FirebaseFirestore.instance
            .collection('sewingmachines')
            .doc(sewingMachine.timestamp.toString())
            .update(sewingMachine.toMap());
      }

      showCustomToast('saved successfully', type: "");

      setState(() {
        loading = false;
        idCtrl.clear();
        conditionCtrl.clear();
      });

      widget.exitPopup("success");
    } catch (error) {
      showCustomToast("an error occured", type: "error");

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? circularProgress()
        : CustomWrapper(
            maxWidth: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.recordAction == RecordAction.add
                        ? 'Add Sewing Machine'
                        : 'Edit Sewing Machine',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    controller: idCtrl,
                    decoration: const InputDecoration(
                        labelText: "Sewing Machine id", hintText: "1,2,3..."),
                  ),
                  TextFormField(
                    controller: conditionCtrl,
                    decoration: const InputDecoration(
                        labelText: "Sewing Machine condition",
                        hintText: "eg, good or poor"),
                  ),
                  const SizedBox(height: 20),
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
                              conditionCtrl.text.isNotEmpty) {
                            saveToDb();
                          }
                        },
                        child: Text(
                          widget.recordAction == RecordAction.add
                              ? "Save"
                              : "Update",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
