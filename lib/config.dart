import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

class Config {
  static const String appName = 'Record Management System';

  static const Color themeColor = Colors.blue;

  static const double firstSectionMaxWidth = 250.0;

  static const String authImage = "assets/images/auth.png";
  static const String profileImage = "assets/images/profile.png";

  static const String computerImage = "assets/images/computer.png";
  static const String sewingImage = "assets/images/sewing.png";
  static const String textbooksImage = "assets/images/textbooks.png";

  // SHADOWS
  static BoxShadow boxShadow = BoxShadow(
      color: Colors.black.withOpacity(0.05),
      offset: const Offset(0, 4.0),
      spreadRadius: 0.0,
      blurRadius: 16.0);

  // SCROLLBAR
  static const double scrollbarWidth = 12.0;
  static const double scrollbarWidthMobile = 3.0;

  // COLLECTION NAMES
  static const String users = "users";
  static const String computers = "computers";
  static const String textbooks = "textbooks";
  static const String sewingmachines = "sewingmachines";

  // COLLECTIONS
  static CollectionReference get usersCollection =>
      FirebaseFirestore.instance.collection(users);
  static CollectionReference get computersCollection =>
      FirebaseFirestore.instance.collection(computers);
  static CollectionReference get textbooksCollection =>
      FirebaseFirestore.instance.collection(textbooks);
  static CollectionReference get sewingmachinesCollection =>
      FirebaseFirestore.instance.collection(sewingmachines);
}

enum RecordAction {
  add,
  edit,
}
