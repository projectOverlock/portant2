import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/Chat/ChatRoom.dart';
import 'package:overlock/Chat/Methods.dart';
import 'package:overlock/constants.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/userInfo/more_infor_new_user.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late Map<String, dynamic> userMap;
  List userList = [];

  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int itemCountNum =0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    onStart();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  void onStart() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("status", isEqualTo: "Online")
        .get()
        .then((value) {
      setState(() {
        userList.length = value.docs.length;
        itemCountNum = value.docs.length;
        for (int i = 0; i < value.docs.length; i++) {
          userList[i] = (value.docs[i].data());
        }
        isLoading = false;
      });
      //print(userMap);
    });
  }

  void onSearch() async {
    if(_search.text =="")
      {
        onStart();
      }
    else {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      setState(() {
        isLoading = true;
      });

      await _firestore
          .collection('users')
          .where("name", isEqualTo: _search.text)
          .get()
          .then((value) {
        setState(() {
          userList[0] = value.docs[0].data();
          itemCountNum = value.docs.length;
          // for (int i = 0; i < value.docs.length; i++) {
          //   userList.add(value.docs[i].data());
          //   print(value.docs[i].data());
          // }

          isLoading = false;
          FocusScope.of(context).requestFocus(FocusNode());


        });
        //print(userMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("???????????????",style: TextStyle(fontSize: 18 )),
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 18,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => moreInforNewUser(),
                  ),
                );
              },
              // onPressed: () => appState.currentAction = PageAction(
              //     state: PageState.addPage, page: SettingsPageConfig),
            ),
          ],
        ),
        backgroundColor: kPrimaryColor,
        // actions: [
        //   IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        // ],
      ),
      body:
      // isLoading
      //     ? Center(
      //         //?????????????????? ?????? ??????????????? ????????????. ???????????? ??????????????? ????????? ???????????????..
      //         child: Container(
      //           height: size.height / 20,
      //           width: size.height / 20,
      //           child: CircularProgressIndicator(),
      //         ),
      //       )
      //     :
      Column(
              //???????????? ???????????? ????????? ????????????.
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "?????? ???????????? ???????????????." , hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  // ?????? ??????
                  onPressed: onSearch, //onSearch ??????
                  child: Text("??????", style: TextStyle(fontSize: 12)),
                ),
                // SizedBox(
                //   height: size.height / 30,
                // ),
               Expanded(
                 child: ListView.builder(
                   itemCount: itemCountNum,
                   itemBuilder: (BuildContext context, int index){
                     return ListTile(
                       onTap: () {
                         String roomId = chatRoomId(
                             _auth.currentUser!.displayName.toString(), userList[index]['name']);

                         Navigator.of(context).push(
                           MaterialPageRoute(
                             builder: (_) => ChatRoom(
                               chatRoomId: roomId,
                               userMap: userList[index],
                             ),
                           ),
                         );
                       },
                       leading: Icon(Icons.account_box, color: Colors.black),
                       title: Text(
                         userList[index]['name'],
                         style: TextStyle(
                           color: Colors.black,
                           fontSize: 14,
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                       subtitle: Text(userList[index]['email'], style: TextStyle(fontSize: 12),
                       ),
                       trailing: Icon(Icons.chat, color: Colors.black),
                     );

                   }
                 ),
               ),


              ],
            ),
    );
  }
}
