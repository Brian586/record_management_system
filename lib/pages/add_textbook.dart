import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:record_management_system/models/textbook.dart';
import 'package:record_management_system/widgets/circular_progress.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';

class AddTextbook extends StatefulWidget {
  const AddTextbook({super.key});

  @override
  State<AddTextbook> createState() => _AddTextbookState();
}

class _AddTextbookState extends State<AddTextbook> {
  String id = "";
  String name = "";
  String subject = "";
  String condition = "";
  int level = 1;
  bool isloading = false;

  void saveTextbookInfo() async {
    setState(() {
      isloading = true;
    });

    try {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      print(timestamp);

      Textbook textbook = Textbook(
          id: id,
          name: name,
          subject: subject,
          condition: condition,
          level: level,
          timestamp: timestamp);

      await FirebaseFirestore.instance
          .collection("textbooks")
          .doc(timestamp.toString())
          .set(textbook.toMap());

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
                  "New textbook",
                  style: TextStyle(fontSize: 20.0),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Textbook ID", hintText: "1,2,3..."),
                  onChanged: (value) {
                    id = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Textbook Name",
                      hintText: "Type something here"),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Textbook Subject",
                      hintText: " Enter subject"),
                  onChanged: (value) {
                    subject = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Textbook Condition",
                      hintText: "Enter condition"),
                  onChanged: (value) {
                    condition = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Textbook Level", hintText: "1,2,3..."),
                  onChanged: (value) {
                    level = int.parse(value);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (id.isNotEmpty &&
                          name.isNotEmpty &&
                          subject.isNotEmpty &&
                          condition.isNotEmpty &&
                          level > 0) {
                        saveTextbookInfo();
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
