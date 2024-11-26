import 'package:flutter/material.dart';
import 'package:portfoliobuilders/screens/Login.dart';
import 'package:portfoliobuilders/screens/otpvarify.dart';

import 'package:portfoliobuilders/screens/splashscreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  SplashScreen(),
    );
  }
}
