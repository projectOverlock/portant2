import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[800],
      height: 70,
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.transparent,
        tabs: <Widget> [

          Tab(
            icon: Icon(Icons.auto_stories, size:18 ), child: Text('정보공유', style: TextStyle(fontSize: 12),),
          ),

          Tab(
            icon: Icon(Icons.article_outlined, size:18 ), child: Text('관심게시판', style: TextStyle(fontSize: 10),),
          ),

          Tab(
            icon: Icon(Icons.settings,  size:18 ), child: Text('계정정보', style: TextStyle(fontSize: 10),),
          ),

          //계급별 게시판
        ],
      ),

    );
  }
}
