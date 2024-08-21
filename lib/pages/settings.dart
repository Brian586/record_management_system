import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/common_functions/custom_toast.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/models/account.dart';
import 'package:record_management_system/widgets/custom_container.dart';

import '../widgets/custom_title.dart';
import '../widgets/custom_wrapper.dart';
import '../widgets/progress_widget.dart';

class SettingsPage extends StatefulWidget {
  final String userid;
  const SettingsPage({super.key, required this.userid});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  Account? account;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  Future<void> getUserInfo() async {
    setState(() {
      isloading = true;
    });

    DocumentSnapshot doc =
        await Config.usersCollection.doc(widget.userid).get();

    account = Account.fromDocument(doc);

    setState(() {
      nameCtrl.text = account!.name;
      emailCtrl.text = account!.email;
      isloading = false;
    });
  }

  void updateUserAccount() async {
    setState(() {
      isloading = true;
    });
    try {
      // create user object
      Account user = Account(
        id: account!.id,
        name: nameCtrl.text,
        email: emailCtrl.text,
      );
      // add user to firestore
      await Config.usersCollection.doc(user.id).update(user.toMap());

      showCustomToast("Updated Successfully", type: "");

      setState(() {
        isloading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isloading = false;
      });
    }
  }

  Widget personalInfo() {
    return CustomContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Information",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: nameCtrl,
              decoration:
                  const InputDecoration(hintText: "Name", labelText: "Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              readOnly: true,
              controller: emailCtrl,
              decoration: const InputDecoration(
                  hintText: "example@gmail.com", labelText: "Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUserAccount();
                  }
                },
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutSection() {
    return CustomContainer(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Logout",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 20.0),
        const Text(
            "Do you wish to log out of your account? You can  always log back in later."),
        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                GoRouter.of(context).go("/");
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTitle(title: "Settings"),
        isloading
            ? circularProgress()
            : CustomWrapper(
                maxWidth: 800.0,
                child: Column(
                  children: [personalInfo(), logoutSection()],
                ),
              ),
      ],
    );
  }
}
