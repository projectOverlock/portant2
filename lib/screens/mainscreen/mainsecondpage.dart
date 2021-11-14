import 'package:flutter/material.dart';

import 'firstpages/first_in_first.dart';
import 'firstpages/forth_in_first.dart';
import 'firstpages/second_in_first.dart';
import 'firstpages/third_in_first.dart';

class mainsecondpage extends StatelessWidget {
  const mainsecondpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _myLegth = 4;
    return DefaultTabController(
        length: _myLegth,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 10,
            backgroundColor: Colors.red,
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.red,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              labelColor: Colors.white,
              labelStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  text: "첫번쨰",
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

          ]),
        ));
  }
}
