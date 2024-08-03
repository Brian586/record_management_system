import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:record_management_system/models/sewing_machine.dart';
import 'package:record_management_system/widgets/circular_progress.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';

class AddSewingMachine extends StatefulWidget {
  const AddSewingMachine({super.key});

  @override
  State<AddSewingMachine> createState() => _AddSewingMachineState();
}

class _AddSewingMachineState extends State<AddSewingMachine> {
  String id = '';
  String condition = '';
  bool loading = false;

  Future<void> saveToDb() async {
    setState(() {
      loading = true;
    });

    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      SewingMachine sewingMachine =
          SewingMachine(id: id, condition: condition, timestamp: timestamp);

      await FirebaseFirestore.instance
          .collection('sewingmachines')
          .doc(sewingMachine.timestamp.toString())
          .set(sewingMachine.toMap());

      Fluttertoast.showToast(msg: 'saved successfully');

      setState(() {
        loading = false;
        id = '';
        condition = '';
      });
    } catch (error) {
      print(error);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgress()
        : CustomWrapper(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add New Sewing Machine'),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Sewing Machine id", hintText: "1,2,3..."),
                  onChanged: (value) {
                    id = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Sewing Machine condition",
                      hintText: "eg, good or poor"),
                  onChanged: (value) {
                    condition = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (id.isNotEmpty && condition.isNotEmpty) {
                      saveToDb();
                    }
                  },
                  child: Text('Add'),
                )
              ],
            ),
            maxWidth: 500);
  }
}
