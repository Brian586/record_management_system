import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:record_management_system/models/computer.dart';
import 'package:record_management_system/widgets/circular_progress.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';

class AddComputer extends StatefulWidget {
  const AddComputer({super.key});

  @override
  State<AddComputer> createState() => _AddComputerState();
}

class _AddComputerState extends State<AddComputer> {
  String id = "";
  String name = "";
  String condition = "";
  bool isloading = false;

  void saveComputerInfo() async {
    setState(() {
      isloading = true;
    });

    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      print(timestamp);

      Computer computer = Computer(
          computerid: id,
          computername: name,
          condition: condition,
          timestamp: timestamp);

      await FirebaseFirestore.instance
          .collection("computers")
          .doc(timestamp.toString())
          .set(computer.toMap());

      Fluttertoast.showToast(msg: "uploaded successfully");

      setState(() {
        isloading = false;
      });
    } catch (error) {
      Fluttertoast.showToast(msg: "an error occured");

      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomWrapper(
      maxWidth: 500.0,
      child: isloading
          ? CircularProgress()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New computer",
                  style: TextStyle(fontSize: 20.0),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Computer ID", hintText: "1,2,3..."),
                  onChanged: (value) {
                    id = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Computer Name",
                      hintText: "Type something here"),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Computer Condition",
                      hintText: "Enter condition"),
                  onChanged: (value) {
                    condition = value;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (id.isNotEmpty &&
                          name.isNotEmpty &&
                          condition.isNotEmpty) {
                        saveComputerInfo();
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
    );
  }
}
