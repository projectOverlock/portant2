import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/userInfo/FirstDatePick.dart';
import 'package:overlock/ui/userInfo/moreInformation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_state.dart';
import '../constants.dart';
import 'userInfo/more_infor_new_user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  static final double _connerRadius = 8.0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _warningTextController = TextEditingController();

  late bool _success;
  String _userEmail = '';
  String email = '';
  String password = '';
  OutlineInputBorder _border = OutlineInputBorder();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    final query = MediaQuery.of(context);
    final size = query.size;
    final itemWidth = size.width;
    final itemHeight = itemWidth * (size.width / size.height);

    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: kPrimaryColor,
                      height: 50,
                    ),
                    
                    Container(
                      color: kPrimaryColor,
                      child: Image.asset('assets/images/splash_overlock1.png', width: 100, height: 100),
                    ),

                    Container(
                      color: kPrimaryColor,
                      height: 50,
                    ),
                    Container(
                      height: 10,
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "OVERLOCK",
                          style: TextStyle(
                            fontSize: 30,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "???????????? ????????? ?????? ?????? ????????? \n ??????????????? ????????? ???????????????.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, bottom: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: '?????????', hintText: "??????????????? ????????? ??????????????????."),
                        validator: validateEmail,
                        onSaved: (value) {
                          email = value!;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, bottom: 10),
                      child: TextFormField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(labelText: '?????????',hintText: "?????????,?????? ??? ?????? ??????????????????."),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '???????????? ??????????????????.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, bottom: 10),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: '????????????', hintText: "?????????, ?????? ??? ??????????????? ????????? 8????????? ???????????????."),
                        validator: validatepassword,
                        onSaved: (value) {
                          password = value!;
                        },
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: BorderSide(
                                color: kPrimaryColor,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _register(appState);

                                //appState.login();

                              }
                            },
                            child: const Text(
                              '????????????',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: const BorderSide(color: Colors.black),
                            ),
                            onPressed: () {
                              appState.currentAction =
                                  PageAction(state: PageState.pop);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _warningTextController.text,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: itemHeight * 0.4,
                    ),
                  ])),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

// Example code for registration.
  Future<void> _register(appState) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      await user!.updateProfile(displayName: _nicknameController.text);

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!;
        });
        String name = _nicknameController.text;
        user.updateProfile(displayName: name);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({
          "name": name,
          "email": _emailController.text,
          "uid": _auth.currentUser!.uid,
          "status": "Unavalible",
          "level": "???????????????????????????",
          "miltype": "???????????????????????????",
          "joinMilitary": "???????????????????????????",
          "corpType": "???????????????????????????",
        });
      } else {
        _success = false;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FirstDatePick(),
       ),
      );

      //appState.firstLoggedIn();


      // appState.currentAction = PageAction(
      //     state: PageState.addPage, page: FirstDatePickConfig);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _warningTextController.text = "??????????????? ????????? ?????? ???????????????.";
        setState(() {});
      } else if (e.code == 'email-already-in-use') {
        _warningTextController.text = "???????????? ???????????? ????????? ????????? ?????? ???????????????.";
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  String? validateEmail(value) {
    const String _fail =""'????????? ????????? ????????? ??????????????????'"";
    if (!value.contains('@')){

      return _fail;
    }
    return null;
  }



  String? validatepassword(value) {
    const String _fail = '??????????????? 8??? ?????? ?????????????????? ????????????.';

    if(value.length >8)
    {
      return value;
    }
    return null;

  }
}
