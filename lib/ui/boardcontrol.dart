import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'Topic/common_list/common_list_main.dart';

//익명게시판

class boardContol extends StatefulWidget {
  final String mylevel;
  final String miltype;
  final String joinMilitary;
  final String corpType;

  boardContol(this.mylevel, this.miltype, this.joinMilitary, this.corpType);


  @override
  _boardContolState createState() => _boardContolState();
}

class _boardContolState extends State<boardContol> {
  @override
  Widget build(BuildContext context) {


    int _myLegth = 4;

    return DefaultTabController(
      length: _myLegth,
      initialIndex: 1,
      child: Scaffold(
        appBar:

        AppBar(
          toolbarHeight: 0,

          backgroundColor: kPrimaryColor,
          //title: myTopBar(),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: kPrimaryColor,
            unselectedLabelColor: Colors.white.withOpacity(0.3),

            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              // Tab(
              //   text: "폭로",
              // ),
              Tab(
                text: "${widget.mylevel}",
              ),
              Tab(
                text: "${widget.miltype}",
              ),
              Tab(
                text: "동기",
              ),
              Tab(
                text: "${widget.corpType}",
              ),

            ],
          ),
        ),
        body: TabBarView(children: <Widget>[
          // soWonList(),
          commonlistmain(widget.mylevel),
          commonlistmain(widget.miltype),
          commonlistmain(widget.joinMilitary),
          commonlistmain(widget.corpType),


          //listLevel(),
        ]),

      ),
    );
  }
}
