import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/models/account.dart';

import '../widgets/custom_wrapper.dart';
import '../widgets/progress_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  void createUserAccount() async {
    setState(() {
      isloading = true;
    });
    if (password == confirmPassword) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // create user object
        Account user = Account(
          id: credential.user!.uid,
          name: name,
          email: email,
        );
        // add user to firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toMap());

        setState(() {
          isloading = false;
        });

        GoRouter.of(context).go("/home/${user.id}/dashboard");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
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
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Name", labelText: "Name"),
                          onChanged: (value) {
                            name = value;
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
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Confirm Password",
                              labelText: "Confirm Password"),
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else if (password != confirmPassword) {
                              return "Passwords do not match";
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
                                createUserAccount();
                              }
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(color: Colors.white),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  context.go("/login");
                                },
                                child: const Text(
                                  "Login",
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
