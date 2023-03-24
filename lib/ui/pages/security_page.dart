import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  var loadingPercentage = 0;
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      
      ..loadRequest(Uri.parse(
          'https://docs.google.com/document/d/1z_IfgOZCVrP5231pX9fxn9xKBkXfDkor/edit?usp=sharing&ouid=114950754689161446777&rtpof=true&sd=true'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Пользовательское соглашение'),
        flexibleSpace: const AppGradientGeneral(),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          const Center(
            child: CircularProgressIndicator(
            ),
          ),
      ],
    ),
      ),
    );
  }
}
