import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record_management_system/config.dart';
import 'package:record_management_system/routes.dart';
import 'package:record_management_system/widgets/custom_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title:Config.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Config.themeColor),
        useMaterial3: false,),
        routerConfig: CustomRoutes.router,

    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displaySplash();
  }

  void displaySplash() {
    Timer(const Duration(seconds: 3), () { 
      GoRouter.of(context).go('/login');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(child: Text(Config.appName),),
    );
  }
}