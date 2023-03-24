import 'package:mobi_kg/const/app_fonts.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        flexibleSpace: const AppGradientGeneral(),
        title: Text('about'.tr),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.shade100),
          child: Text(
        "aboutText".tr,
        style: AppFonts.w500s18,
        textAlign: TextAlign.center,
      )),
    );
  }
}
