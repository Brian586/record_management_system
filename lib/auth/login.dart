import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/config.dart';

import '../widgets/custom_wrapper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    
  String email="";
  String password="";

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
                Text('Login',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                
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
                 
                const SizedBox(height: 20.0,),
                ElevatedButton(onPressed:(){
                  if(_formKey.currentState!.validate()) {
                   
                  }
                }, child: const Text("Sign in", style: TextStyle(color: Colors.white),)),
                const SizedBox(height: 20,),
                 Row(
                 children: [
                  Text("Don't have an account?"),
                 TextButton(onPressed: (){
                  context.go("/signup");
                 }, child:  Text("Sign Up",style: TextStyle(color:Config.themeColor ),))
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