import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/forgot_password.dart';
import 'package:sac_wallet/screens/onboarding_page.dart';
import 'package:sac_wallet/screens/register_page.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/keyboard.dart';

import '../widget/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  late TextEditingController emailCT, passwordCT;
  bool isLoading = false;
  String? emailError, passwordError;

  bool validateEmail() {
    if (emailCT.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter your email",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      setState(() {
        emailError = "Enter Email Address";
      });
      return false;
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(emailCT.text)) {
      setState(() {
        emailError = 'Please enter a valid email Address';
      });
      return false;
    }
    setState(() {
      emailError = null;
    });
    return true;
  }

  bool validatePassword() {
    if (passwordCT.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter your password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      setState(() {
        passwordError = "Enter Password!";
      });
      return false;
    }
    setState(() {
      passwordError = null;
    });
    return true;
  }

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  login() async {
    String email = emailCT.text;
    String password = passwordCT.text;
    if (validateEmail() && validatePassword()) {
      try {
        setLoading(true);

        bool isSuccess =
            await UserRepository().login(email: email, password: password);
        if (isSuccess) {
          emailCT.clear();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => OnBoardingScreen()),
          );
        } else {
          Fluttertoast.showToast(
              msg: "Failed login!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Failed login! ${e}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } finally {
        setLoading(false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    emailCT = TextEditingController();
    passwordCT = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    const EdgeInsetsGeometry inputPadding =
        EdgeInsets.only(left: 12.0, bottom: 18, top: 18);

    return Scaffold(
      body: Stack(
        /* overflow: Overflow.visible, */
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/app_icon.png",
                    width: screenWidth * 0.2, height: screenHeight * 0.1),
                /*SizedBox(height: 5),
                Text("Log In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.MAIN_COLOR_SCHEME),),*/
                SizedBox(height: screenHeight * 0.02),
                Container(
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: screenWidth,
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: emailCT,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: validateEmail,
                    decoration: new InputDecoration(
                      labelText: "Email",
                      errorText: emailError,
                      contentPadding: inputPadding,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 1.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: screenWidth,
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: passwordCT,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onEditingComplete: validatePassword,
                    decoration: new InputDecoration(
                      labelText: "Password",
                      errorText: passwordError,
                      contentPadding: inputPadding,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 1.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                InkWell(
                  onTap: () {
                    KeyBoardFunctions.hideKeyBoard(context);
                    login();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.NEW_MAIN_COLOR_SCHEME),
                    child: Center(
                      child: Text("Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Not a Member?  ",
                        style: TextStyle(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME,
                            fontSize: 14)),
                    RawMaterialButton(
                      onPressed: () async {
                        GlobalValue.user = await UserRepository().getUser();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      child: Text("Create an Account",
                          style: TextStyle(
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: RawMaterialButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPassword(
                                    email: emailCT.text,
                                  )));
                        },
                        child: Text("Forgot Password",
                            style: TextStyle(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          LoadingScreen(
              inAsyncCall: isLoading,
              mesage: "Logging in...",
              dismissible: false)
        ],
      ),
    );
  }
}
