import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../app_state.dart';
import '../../main.dart';
import '../writepage.dart';
import '../details.dart';
import '../rewrite_page.dart';
import 'common_list/common_list_main.dart';

class list1 extends StatelessWidget {
  final String colNameFormFB;

  list1(this.colNameFormFB);

  // 필드명
  final String fnName = "name";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";
  final String userID = "nickName";

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newDescCon = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isScrollingDown = false;
  double bottomBarHeight = 150; // set bottom bar height

  @override
  Widget build(BuildContext context) {
    final String colName = colNameFormFB;
    return commonlistmain(colName);
    // Create Document
  }


}
