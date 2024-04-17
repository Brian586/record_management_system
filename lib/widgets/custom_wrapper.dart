import 'package:flutter/material.dart';

class CustomWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const CustomWrapper({super.key, required this.child, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child,);
  }
}