import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/config.dart';

import '../widgets/custom_wrapper.dart';
import '../widgets/progress_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  void loginUser() async {
    setState(() {
      isloading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot doc =
          await Config.usersCollection.doc(credential.user!.uid).get();

      if (doc.exists) {
        GoRouter.of(context).go("/home/${doc.id}/dashboard");
      }

      setState(() {
        isloading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: isloading
          ? circularProgress()
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomWrapper(
                  maxWidth: 500.0,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Image.asset(
                          Config.authImage,
                          height: 150.0,
                          width: 150.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "example@gmail.com",
                              labelText: "Email"),
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Password", labelText: "Password"),
                          onChanged: (value) {
                            password = value;
                          },
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
                                loginUser();
                              }
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(color: Colors.white),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  context.go("/signup");
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: Config.themeColor),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
