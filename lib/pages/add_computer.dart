import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_management_system/common_functions/custom_toast.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/models/computer.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';
import 'package:record_management_system/widgets/progress_widget.dart';

class AddComputer extends StatefulWidget {
  final String computerID;
  final RecordAction recordAction;
  final void Function(String) exitPopup;
  const AddComputer(
      {super.key,
      required this.computerID,
      required this.recordAction,
      required this.exitPopup});

  @override
  State<AddComputer> createState() => _AddComputerState();
}

class _AddComputerState extends State<AddComputer> {
  TextEditingController idCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController conditionCtrl = TextEditingController();
  bool isloading = false;

  Computer? oldComputer;

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
        await Config.computersCollection.doc(widget.computerID).get();

    oldComputer = Computer.fromDocument(doc);

    setState(() {
      idCtrl.text = oldComputer!.computerid;
      nameCtrl.text = oldComputer!.computername;
      conditionCtrl.text = oldComputer!.condition;
      isloading = false;
    });
  }

  void saveComputerInfo() async {
    setState(() {
      isloading = true;
    });

    try {
      if (widget.recordAction == RecordAction.add) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;

        Computer computer = Computer(
            computerid: idCtrl.text.trim(),
            computername: nameCtrl.text.trim(),
            condition: conditionCtrl.text.trim(),
            timestamp: timestamp);

        await Config.computersCollection
            .doc(timestamp.toString())
            .set(computer.toMap());
      } else {
        Computer computer = Computer(
            computerid: idCtrl.text.trim(),
            computername: nameCtrl.text.trim(),
            condition: conditionCtrl.text.trim(),
            timestamp: oldComputer!.timestamp);

        await Config.computersCollection
            .doc(oldComputer!.timestamp.toString())
            .update(computer.toMap());
      }

      showCustomToast("Saved successfully", type: "");

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
                        ? "Add Computer"
                        : "Edit Computer Details",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    controller: idCtrl,
                    decoration: const InputDecoration(
                        labelText: "Computer ID", hintText: "1,2,3..."),
                  ),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: "Computer Name",
                        hintText: "Type something here"),
                  ),
                  TextFormField(
                    controller: conditionCtrl,
                    decoration: const InputDecoration(
                        labelText: "Computer Condition",
                        hintText: "Enter condition"),
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
                                conditionCtrl.text.isNotEmpty) {
                              saveComputerInfo();
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
