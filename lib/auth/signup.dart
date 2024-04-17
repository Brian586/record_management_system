import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/config.dart';

import '../widgets/custom_wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name="";
  String email="";
  String password="";
  String confirmPassword="";
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body:Center(
        child: CustomWrapper(
          maxWidth: 500.0,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0,),
                Text('Sign Up',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Name",
                    labelText: "Name"
                  ),
                  onChanged: (value) {
                    name=value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "example@gmail.com",
                    labelText: "Email"
                  ),
                  onChanged: (value) {
                    email=value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "Password"
                  ),
                  onChanged: (value) {
                    password=value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                 TextFormField(
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    labelText: "Confirm Password"
                  ),
                  onChanged: (value) {
                    confirmPassword=value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (password != confirmPassword){
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(onPressed:(){
                  if(_formKey.currentState!.validate()) {
                    print("Name: $name");
                    print("Email: $email");

                    print("Password: $password");

                  }
                }, child: Text("Sign up", style: TextStyle(color: Colors.white),)),
                const SizedBox(height: 20,),
                 Row(
                 children: [
                  Text("Already have an account?"),
                 TextButton(onPressed: (){
                  context.go("/login");
                 }, child:  Text("Login",style: TextStyle(color:Config.themeColor ),))
                 ], 
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}