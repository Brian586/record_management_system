import 'package:cloud_firestore/cloud_firestore.dart';

class Textbook {
  String id;
  String name;
  String subject;
  String condition;
  int level;
  int timestamp;

  Textbook(
      {required this.id,
      required this.name,
      required this.subject,
      required this.condition,
      required this.level,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'condition': condition,
      'level': level,
      'timestamp': timestamp,
    };
  }

  factory Textbook.fromDocument(DocumentSnapshot doc) {
    return Textbook(
        id: doc['id'],
        name: doc['name'],
        subject: doc['subject'],
        condition: doc['condition'],
        level: doc['level'],
        timestamp: doc['timestamp']);
  }
}
