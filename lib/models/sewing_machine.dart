import 'package:cloud_firestore/cloud_firestore.dart';

class SewingMachine {
  String id;
  String condition;
  int timestamp;

  SewingMachine({
    required this.id,
    required this.condition,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'condition': condition,
      'timestamp': timestamp,
    };
  }

  factory SewingMachine.fromDocument(DocumentSnapshot doc) {
    return SewingMachine(
      id: doc['id'],
      condition: doc['condition'],
      timestamp: doc['timestamp'],
    );
  }
}
