import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlock/screens/login/login.dart';

import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '테스트',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
     getPages: [
       GetPage(name: "/", page: () =>MyHomePage()),
       GetPage(name: "/login", page: () =>Login())
     ],

    );
  }
}

