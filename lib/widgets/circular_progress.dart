import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(child: SizedBox(height: 50.0,width: 50.0, child: CircularProgressIndicator()));
  }
}