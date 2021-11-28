import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/components/coustom_bottom_nav_bar.dart';
import 'package:overlock/ui/boardcontrol.dart';
import 'package:overlock/ui/fixedboard.dart';
import 'package:overlock/ui/userInfo/newSettings.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

//로그인 후 메인페이지 입니다.
CollectionReference users = FirebaseFirestore.instance.collection('users');

class ListItems extends StatefulWidget {
  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  String kakaoAppKey = "d39f9b18ce4b5918be97413cf6f09c17";

  @override
  Widget build(BuildContext context) {
    // final query = MediaQuery.of(context);
    // final size = query.size;

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      "status": "Online",
    }); //로그인 시 온라인으로 상태 변경
    // KakaoContext.clientId = kakaoAppKey;

    return DefaultTabController(
            // 탭컨트롤
            initialIndex: 1, // 초기인덱스는 익명게시판으로 설정
            length: 3,
            child: Scaffold(
              body: FutureBuilder<DocumentSnapshot>(
                  future: users.doc(_auth.currentUser!.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      );
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.yellow),
                          ),

                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        //좌우 스크롤 안되도록 설정
                        children: <Widget>[
                          fixedBoards(),
                          boardContol(data['level'], data['miltype'],
                              data['joinMilitary'], data['corpType']),
                          // 익명게시판
                          newSettings(data['level'], data['miltype'],
                              data['joinMilitary'], data['corpType'])
                          // 온라인 동기 게시판
                        ],
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  }),
              bottomNavigationBar: const CustomBottomNavBar(), //바텀바
            ));
  }
}

