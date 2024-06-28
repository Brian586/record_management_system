import 'package:cloud_firestore/cloud_firestore.dart';

class Computer {
  String computerid;
  String computername;
  String condition;
  int timestamp;

  Computer({
    required this.computerid,
    required this.computername,
    required this.condition,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "computerid": computerid,
      "computername": computername,
      "condition": condition,
      "timestamp": timestamp,
    };
  }

  factory Computer.fromDocument(DocumentSnapshot doc) {
    return Computer(
      computerid: doc["computerid"],
      computername: doc["computername"],
      condition: doc["condition"],
      timestamp: doc["timestamp"],
    );
  }
}
