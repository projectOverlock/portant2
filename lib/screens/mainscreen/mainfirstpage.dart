import 'package:flutter/material.dart';
import 'package:overlock/screens/mainscreen/firstpages/first_in_first.dart';
import 'package:overlock/screens/mainscreen/firstpages/forth_in_first.dart';
import 'package:overlock/screens/mainscreen/firstpages/second_in_first.dart';
import 'package:overlock/screens/mainscreen/firstpages/third_in_first.dart';

class mainfirstpage extends StatelessWidget {
  const mainfirstpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _myLegth = 4;

    return DefaultTabController(
        length: _myLegth,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10,
            backgroundColor: Colors.white,
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.red,
              labelColor: Colors.red[800],
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  text: "첫번",
                ),
                Tab(
                  text: "두번째",
                ),
                Tab(
                  text: "세번쨰",
                ),
                Tab(
                  text: "네번쨰",
                ),
              ],
            ),
          ),
          body: const TabBarView(children: <Widget>[
            firstinfirst(),
            secondinfirst(),
            thirdinfirst(),
            forthinfirst(),
            //listLevel(),
          ]),
        ));
  }
}
