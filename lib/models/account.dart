import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
    String id;
    String name;
    String email;

Account({required this.id,required this.name,required this.email});

Map<String, dynamic> toMap(){
  return {
    'id':id,
    'name':name,
    'email':email
  };
}

factory Account.fromDocument(DocumentSnapshot map) {
  return Account(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    email: map['email'] ?? '',
  );

}}