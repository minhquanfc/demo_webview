import 'package:demo_webview/main.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:lottie/lottie.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterSeconds: const MyHomePage(),
      seconds: 3,
      title: const Text('Welcome In SplashScreen',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.blueAccent
    );
  }
}
