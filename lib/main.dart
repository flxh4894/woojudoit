import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woojudoit/src/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '우주두잇',
      theme: ThemeData(
        fontFamily: 'AppleSDGothicNeo',
        primarySwatch: Colors.blue,
      ),
      home: HomePage()
    );
  }
}