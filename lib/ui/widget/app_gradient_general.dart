import 'package:flutter/material.dart';

class AppGradientGeneral extends StatelessWidget {
  const AppGradientGeneral({
    super.key,  this.child = const Text('')
  });
  final  Widget child;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x6666daf5),
                Color(0x995eb1e3),
                Color(0xcc54c8f1),
                Color(0xff53c1f1),
          ])),
          child: child,
    );
  }
}