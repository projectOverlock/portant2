import 'package:flutter/material.dart';
import 'package:overlock/screens/mainscreen/mainfirstpage.dart';
import 'package:overlock/screens/mainscreen/mainsecondpage.dart';
import 'package:overlock/screens/mainscreen/mainthirdpage.dart';

import 'components/custom_botton_navbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
        // 탭컨트롤
        initialIndex: 0, // 초기인덱스는 익명게시판으로 설정
        length: 3,
        child: Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              //좌우 스크롤 안되도록 설정
              children: <Widget>[
                mainfirstpage(),
                mainsecondpage(),
                mainthirdpage()
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar()));
  }
}
