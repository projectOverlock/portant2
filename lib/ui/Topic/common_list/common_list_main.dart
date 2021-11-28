import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../../constants.dart';
import '../../details.dart';
import '../../writepage.dart';

class commonlistmain extends StatelessWidget {
  final String colNameFormFB;

   commonlistmain(this.colNameFormFB );
  final String fnName = "name";
  final String fnDescription = "description";
  final String fnDatetime = "datetime";
  final String userID = "nickName";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isScrollingDown = false;
  double bottomBarHeight = 150; // set bottom bar height

  @override
  Widget build(BuildContext context) {

    final String colName = colNameFormFB;
    final query = MediaQuery.of(context);
    final size = query.size;
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
                height: 30,
                child: Card(
                    child: Center(
                        child:  Text(
                          '$colName 게시판 입니다. 군사보안과 매너를 지켜주세요.',
                          style: const TextStyle(fontSize: 12),
                        )))),
            SizedBox(
              height: size.height - bottomBarHeight,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(colName)
                    .orderBy(fnDatetime, descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return  Text("Error: ${snapshot.error}");
                  }
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
                          return Card(
                            elevation: 2,
                            child: InkWell(
                              // Read Document
                              onTap: () {
                                appState.currentAction = PageAction(
                                    state: PageState.addPage,
                                    widget: Details(
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
                                    ),
                                    page: DetailsPageConfig);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) =>  ;
                                int view = document["pageView"];
                                view++;
                                FirebaseFirestore.instance
                                    .collection(colName)
                                    .doc(document.id)
                                    .update({"pageView": view});

                                // showDocument(document.id, appState);
                              },
                              // Update or Delete Document
                              // onLongPress: () {
                              //   showUpdateOrDeleteDocDialog(document, context);
                              // },
                              child: Container(
                                //height: size.height * 0.3,
                                padding:
                                const EdgeInsets.only(top: 8, bottom: 4),
                                child: Column(
                                  children: <Widget>[
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          //bottom: 8.0,
                                            left: 12,
                                            right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width: size.width * 0.8,
                                              child: Text(
                                                document[fnName].toString()+" ...["+document["replys"].toString()+"]",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 10.0,
                                            left: 15,
                                            right: 25),
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            document[fnDescription],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                letterSpacing: 0.2,
                                                height: 1.2),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    Column(
                                      children: [
                                        if (document["uid"] == _auth.currentUser!.uid) Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Container(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(document[userID]+"(내가쓴글)",
                                                    style: TextStyle(
                                                        color: Colors.amber[800]
                                                        ,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ) else Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Container(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: const [
                                                Text("익명의 군인",
                                                    style: TextStyle(
                                                      color:kPrimaryColor,
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Divider(),
                                        SizedBox(
                                          height: 30,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Row(
                                              children: <Widget>[
                                                TextButton.icon(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.view_agenda,
                                                      size: 10,
                                                      color: Colors.grey,
                                                    ),
                                                    label: Text(
                                                      document["pageView"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    )),
                                                TextButton.icon(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.favorite_border,
                                                        size: 10,
                                                        color: Colors.grey),
                                                    label: Text(
                                                        document["likes"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                            Colors.grey))),
                                                TextButton.icon(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons
                                                            .do_disturb_off_rounded,
                                                        size: 10,
                                                        color: Colors.grey),
                                                    label: Text(
                                                        document["hates"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                            Colors.grey))),
                                                TextButton.icon(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.add_comment,
                                                        size: 10,
                                                        color: Colors.grey),
                                                    label: Text(
                                                        document["replys"]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                            Colors.grey))),
                                                const Spacer(),
                                                TextButton(
                                                    onPressed: () {  },
                                                    child: Text(
                                                      dt
                                                          .substring(2, 13)
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
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
          child: const Icon(Icons.add),
          onPressed: () {
            appState.currentAction = PageAction(
                state: PageState.addPage,
                page: WritePageConfig,
                widget: WritePages(colName));
          },



          backgroundColor: kPrimaryColor,
        ));
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }}
