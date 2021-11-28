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
import '../rewrite_page.dart';
import 'WriteManagerPage.dart';
import 'newsDetails.dart';

class newsList extends StatelessWidget {
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
    final String colName = "newsList";
    final query = MediaQuery.of(context);
    final size = query.size;
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              child: SizedBox(
                  height: 30,
                  child: Card(
                      child: Center(
                          child: Text(
                    '${colName} 게시판 입니다. 군사보안과 매너를 지켜주세요.',
                    style: TextStyle(fontSize: 12),
                  )))),
            ),
            Container(
              height: size.height - bottomBarHeight,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(colName)
                    .orderBy(fnDatetime, descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text("Error: ${snapshot.error}");
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Scaffold(
                        backgroundColor: Colors.grey[200],
                      );
                    default:
                      return ListView(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot document) {
                          Timestamp ts = document[fnDatetime];
                          String dt = timestampToStrDateTime(ts);
                          String ShortDt = dt.substring(0, 10);
                          String username = document[userID];
                          String imageurlFromServer = document["imageurl"].toString();
                          return Card(
                            elevation: 0.5,
                            child: InkWell(
                              // Read Document
                              onTap: () {
                                appState.currentAction = PageAction(
                                    state: PageState.addPage,
                                    widget: newsDetails(
                                      document[fnName],
                                      document[userID],
                                      document[fnDescription],
                                      document.id,
                                      colName,
                                      document["pageView"].toString(),
                                      document["likes"].toString(),
                                      document["hates"].toString(),
                                      document["replys"].toString(),
                                      document["uid"].toString(),
                                      document["imageurl"].toString()
                                    ),
                                    page: DetailsPageConfig);
                                int view = document["pageView"];
                                view++;
                                FirebaseFirestore.instance
                                    .collection(colName)
                                    .doc(document.id)
                                    .update({"pageView": view});
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 4),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          //bottom: 8.0,
                                          left: 12,
                                          right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: imageurlFromServer ==
                                                    "noImage"
                                                ? Container(
                                              color: Colors.amber,
                                            )
                                                : SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: Image.network(
                                                        imageurlFromServer),
                                                  ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.8,
                                            child: Text(
                                              document[fnName].toString() +
                                                  " ...[" +
                                                  document["replys"]
                                                      .toString() +
                                                  "]",
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Row(
                                          children: <Widget>[
                                            TextButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.view_agenda,
                                                  size: 10,
                                                  color: Colors.grey,
                                                ),
                                                label: Text(
                                                  document["pageView"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey),
                                                )),
                                            TextButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                    Icons.favorite_border,
                                                    size: 10,
                                                    color: Colors.grey),
                                                label: Text(
                                                    document["likes"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey))),
                                            TextButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                    Icons
                                                        .do_disturb_off_rounded,
                                                    size: 10,
                                                    color: Colors.grey),
                                                label: Text(
                                                    document["hates"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey))),
                                            TextButton.icon(
                                                onPressed: () {},
                                                icon: Icon(Icons.add_comment,
                                                    size: 10,
                                                    color: Colors.grey),
                                                label: Text(
                                                    document["replys"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey))),
                                            Spacer(),
                                            TextButton(
                                                onPressed: () {  },
                                                child: Text(
                                              dt.substring(2, 13).toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            appState.currentAction = PageAction(
                state: PageState.addPage,
                page: WritePageConfig,
                widget: WriteMangerPage());
          },

          //     () => Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => WritePages(colName)),
          // ),
          // onPressed: () => appState.currentAction =
          //     PageAction(state: PageState.addPage, page: CartPageConfig),

          backgroundColor: kPrimaryColor,
        ));
    // Create Document
  }

  /// Firestore CRUD Logic

// 문서 생성 (Create)
  void createDoc(String name, String description) {
    FirebaseFirestore.instance.collection("newsList").add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
    });
  }

// 문서 조회 (Read)
  void showDocument(String documentID, appState) {
    FirebaseFirestore.instance
        .collection("newsList")
        .doc(documentID)
        .get()
        .then((doc) {
      showReadDocSnackBar(doc, appState);
    });
  }

  void showReadDocSnackBar(DocumentSnapshot doc, appState) {
    appState.currentAction =
        PageAction(state: PageState.addPage, page: DetailsPageConfig);
  }

// 문서 갱신 (Update)
  void updateDoc(String docID, String name, String description) {
    FirebaseFirestore.instance.collection("newsList").doc(docID).update({
      fnName: name,
      fnDescription: description,
    });
  }

// 문서 삭제 (Delete)

  void deleteDoc(String docID) {
    FirebaseFirestore.instance.collection("newsList").doc(docID).delete();
  }

  void showCreateDocDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Document"),
          content: Container(
            height: 500,
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _newNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _newDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                _newNameCon.clear();
                _newDescCon.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Create"),
              onPressed: () {
                if (_newDescCon.text.isNotEmpty &&
                    _newNameCon.text.isNotEmpty) {
                  createDoc(_newNameCon.text, _newDescCon.text);
                }
                _newNameCon.clear();
                _newDescCon.clear();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void showContentsMoreButtonDialog(DocumentSnapshot doc, context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Update/Delete Document"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]);
        });
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc, context) {
    _undNameCon.text = doc[fnName];
    _undDescCon.text = doc[fnDescription];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update/Delete Document"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _undNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _undDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                _undNameCon.clear();
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () {
                if (_undNameCon.text.isNotEmpty &&
                    _undDescCon.text.isNotEmpty) {
                  updateDoc(doc.id, _undNameCon.text, _undDescCon.text);
                }
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                deleteDoc(doc.id);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
