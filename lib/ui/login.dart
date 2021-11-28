import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_state.dart';
import '../constants.dart';
import 'splash_content.dart';

bool isLoggedIn = false;
bool isLoading = false;
late User currentUser;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
  final String currentUserId = '';
}

int currentPage = 0;
List<Map<String, String>> splashData = [
  {
    "text": "오버로크에 오신걸 환영합니다.\n 오버로크는 군인을 위한 익명 소통 서비스입니다.",
    "image": "assets/images/splash_1.png"
  },
  {
    "text": "온라인 소원수리에 참여하세요. \n 군 내부 문제를 함께 고민하고, 세상에 알리겠습니다.",
    "image": "assets/images/splash_2.png"
  },
  {
    "text": "온라인 동기를 사귀세요. \n 온라인에는 여러분의 5000명의 동기가 있습니다.",
    "image": "assets/images/splash_3.png"
  },
];

class _LoginState extends State<Login> {

  late SharedPreferences prefs;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _warningTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final OutlineInputBorder _border = const OutlineInputBorder();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    _passwordController.text = appState.password;
    _emailController.text = appState.emailAddress;


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 25,
                  child: PageView.builder(  //어플리케이션 소개 페이지 생성(상단)
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                      image: splashData[index]["image"],
                      text: splashData[index]['text'],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate( // 색인 표시
                            splashData.length,
                            (index) => buildDot(index: index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 10),
                  child: buildTextFormField( // 이메일 주소(아이디 입력)
                      "Email Address", _emailController, false),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 10),
                  child:
                      buildTextFormField("Password", _passwordController, true),// 비번 입력
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
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => agreePage()));
                             appState.agreePage();

                          // appState.currentAction = PageAction(
                          //     state: PageState.addPage,
                          //     page: CreateAccountPageConfig);
                        },
                        child: const Text(
                          '계정 생성',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
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
                          side: const BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),

                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _signInWithEmailAndPassword(appState);
                          }
                         // appState.login();
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(color: Colors.white),
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
                child: Text(_warningTextController.text, style: const TextStyle(color: Colors.red),),
              )
              ,
                TextButton( child: const Text("비밀번호 찾기",style: TextStyle(color: Colors.black)),
                  onPressed:(){
                  appState.findPassword();
                  }
                  //PageAction(state: PageState.addPage, page: ResetScreenConfig, widget: ResetScreen());}
                      //()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ResetScreen()))
                  ,)
                ,
                const Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  TextFormField buildTextFormField(
      String labelText, TextEditingController controller, bool isPassword) {
    return TextFormField(
        keyboardType: isPassword?  TextInputType.text:TextInputType.emailAddress,
        cursorColor: kPrimaryColor,
        obscureText: isPassword ? true : false,
        controller: controller,
        validator:  isPassword? validatepassword :validateEmail,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: labelText,
          filled: false,
          fillColor: Colors.black45,
          border: _border,
          errorBorder: _border.copyWith(
              borderSide: const BorderSide(color: kPrimaryColor, width: 2)),
          enabledBorder: _border.copyWith(
              borderSide: const BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: _border.copyWith(
              borderSide: const BorderSide(color: kPrimaryColor, width: 1)),
          errorStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          hintStyle: const TextStyle(color: Colors.black),
        ));
  }

  Future<void> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
  }

  Future<void> _signInWithEmailAndPassword(AppState appState) async {
    try {


      appState.login();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _warningTextController.text="입력하신 이메일로 가입한 유저는 없습니다.";
        setState(() {

        });
      } else if (e.code == 'wrong-password') {
        _warningTextController.text ="비밀번호를 다시 확인해주시기 바랍니다.";
        setState(() {

        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  String? validateEmail(value) {
    const String _fail =""'유효한 이메일 주소를 입력해주세요'"";
    if (!value.contains('@')){

      return _fail;
    }
    return null;
  }



  String? validatepassword(value) {

    if(value.length >8)
    {
      return value;
    }
    return null;

  }


}
