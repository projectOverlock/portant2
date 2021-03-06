import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:overlock/AdsTest/AdmobHelper.dart';
import 'package:overlock/AdsTest/AdsTester.dart';
import 'package:overlock/AdsTest/RewardedAdsExample.dart';
import 'package:overlock/main.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/ManagePage/ManageList.dart';
import 'package:overlock/ui/Topic/list4.dart';
import 'package:overlock/ui/userInfo/more_infor_new_user.dart';
import 'package:overlock/ui/userInfo/LevelSelector.dart';
import 'package:overlock/ui/userInfo/MilSelector.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

import '../../app_state.dart';
import '../../constants.dart';
import '../../main.dart';
import 'cupertinoDatePicker.dart';
import 'datePicker.dart';
import 'moreInformation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var userData;
String myEmail = "1";
String myCorpType = "2";
String myJoinMilitary = "3";
String myMiltype = "4";
String myName = "5";
String myLevel = "5";

class newSettings extends StatefulWidget {
  final String mylevel;
  final String miltype;
  final String joinMilitary;
  final String corpType;

  newSettings(this.mylevel, this.miltype, this.joinMilitary, this.corpType);

  @override
  _newSettingsState createState() => _newSettingsState();
}

class _newSettingsState extends State<newSettings> {
  late DateTime _chosenDateTime;

  @override
  Widget build(BuildContext context) {

    String userID = FirebaseAuth.instance.currentUser!.uid;
    final double _horizontalPadding = 11.0;
    final double _verticalPadding =10.0;
    final double _cardElevation =2;
    AdmobHelper admobHelper = new AdmobHelper();


    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: kPrimaryColor,
        title: const Text(
          '????????????',style: TextStyle(fontSize: 18 )
          ,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.grey[100],
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                  child: Card(
                    color: Colors.white70,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text("?????????"),
                          Divider(),
                          Text('??? ????????? : ${_auth.currentUser!.email}'),
                          Divider(),
                          Text('??? ????????? : ${_auth.currentUser!.displayName}'),
                          Divider(),
                          Text('?????? ?????? : ${widget.mylevel}'),
                          Divider(),
                          Text('?????? ?????? : ${widget.miltype}'),
                          Divider(),
                          Text('?????? ?????? : ${widget.joinMilitary}'),
                          Divider(),
                          Text('?????? ?????? : ${widget.corpType}'),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => moreInforNewUser()));
                      appState.currentAction = PageAction(state: PageState.addPage, page: MoreInforNewUserConfig, widget:moreInforNewUser() ); //?????????????????? ???????????????.
                          },
                    child: Card(
                      color: Colors.white,
                      elevation: _cardElevation,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        height: 40,
                        child: Center(child: Text("???????????? ??????")),
                      ),
                    ),
                  ),
                ),



                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                  child: InkWell(
                    onTap: () {
                      // _launchInWebViewOrVC('https://newoverlock.web.app');
                      _launchInBrowser('https://newoverlock.web.app');
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: _cardElevation,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        height: 40,
                        child: Center(child: Text("???????????? ??????")),
                      ),
                    ),
                  ),
                ),

                _auth.currentUser!.uid == 'w52YDoBc14WwHj2MjKGcngcjszg1' ?
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _horizontalPadding,
                          vertical: _verticalPadding),
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => moreInforNewUser()));
                          appState.currentAction = PageAction(state: PageState
                              .addWidget,
                              page: ManageListConfig,
                              widget: ManageList()); //?????????????????? ???????????????.
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: _cardElevation,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            height: 40,
                            child: Center(child: Text("????????? ??????")),
                          ),
                        ),
                      ),
                    )
                  :Container(),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                //   child: InkWell(
                //     onTap: () {
                //       admobHelper.loadRewardedAd();
                //     },
                //     child: Card(
                //       color: kPrimaryColor,
                //       elevation: _cardElevation,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15.0)),
                //       child: Container(
                //         height: 40,
                //         child: Center(child: Text("????????? ?????? ??????(????????????)", style: TextStyle(color: Colors.white),)),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: _verticalPadding),
                  child: InkWell(
                    onTap: () async {
                      appState.logout();
                    },
                    child: Card(
                      color: Colors.grey[50],
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                        child: Container(
                          height: 40,
                          child: Center(child: Text("?????? ??????", style: TextStyle(color: Colors.black),)),
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}



//Padding(
//   padding: const EdgeInsets.all(16.0),
//   child: InkWell(
//     onTap: () {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => milSelector()));
//     },
//     child: Card(
//       color: Colors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0)),
//       child: Container(
//         height: 40,
//         child: Text("????????????"),
//       ),
//     ),
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.all(16.0),
//   child: InkWell(
//     onTap: () {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => moreInformation()));
//     },
//     child: Card(
//       color: Colors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0)),
//       child: Container(
//         height: 40,
//         child: Text("???????????? ??????"),
//       ),
//     ),
//   ),
// ),
// Padding(
//   padding: const EdgeInsets.all(16.0),
//   child: InkWell(
//     onTap: () {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => datePicker()));
//     },
//     child: Card(
//       color: Colors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0)),
//       child: Container(
//         height: 40,
//         child: Text("?????? ???/??? ??????"),
//       ),
//     ),
//   ),
// ),


