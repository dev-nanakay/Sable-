import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/client/user_client.dart';
import 'package:sac_wallet/exceptions/validation_exception.dart';
import 'package:sac_wallet/util/keyboard.dart';
import 'package:sac_wallet/util/time_util.dart';
import 'package:sac_wallet/util/validator.dart';
import 'package:sac_wallet/widget/loading.dart';

class ForgotPassword extends StatefulWidget {
  final String email;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();

  ForgotPassword({required this.email});
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailCT, passwordCT, confirmPasswordCT, otpCT;

  // receive email from login page if present
  String email = '';

  UserClient? userClient;

  bool isLoading = false;

  int numOTPAttempts = 0;

  void incrementOTPAttempts() => setState(() {
        numOTPAttempts = numOTPAttempts + 1;
      });

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  bool sendOTPDisabled = false;

  void setOTPDisabled(loading) => setState(() {
        sendOTPDisabled = loading;
      });

  Timer? _timer = Timer.periodic(Duration(seconds: 10), (t) {});
  int _start = 0;

  void startTimer(int start) {
    _start = start;
    const oneSec = const Duration(seconds: 10);
    if (_timer == null || !_timer!.isActive) {
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              sendOTPDisabled = false;
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailCT = new TextEditingController();
    emailCT.text = widget.email;
    passwordCT = new TextEditingController();
    confirmPasswordCT = new TextEditingController();
    otpCT = new TextEditingController();

    userClient = UserClient();
  }

  void sendOTP() async {
    String emailText = emailCT.text;
    if (emailText == "" || Validator.validateEmail(emailText) != null) {
      print("Invalid email");
      return;
    }
    emailText = emailText.trim();
    try {
      setLoading(true);
      setOTPDisabled(true);
      startTimer(1 * 60);
      incrementOTPAttempts();
      await UserClient().forgotPassword(email: emailCT.text);
    } on ValidationException catch (e) {
      print("Error: ${e.cause}");
      setOTPDisabled(false);
    } catch (e) {
      print("Server Error: ${e}");
      setOTPDisabled(false);
    } finally {
      setLoading(false);
    }
  }

  void resetPassword() async {
    String emailText = emailCT.text;
    String otp = otpCT.text;
    String password = passwordCT.text;
    String confirmPassword = confirmPasswordCT.text;
    try {
      setLoading(true);
      await UserClient().setNewPasswordWithOTP(
          email: emailText,
          otp: otp,
          password: password,
          passwordConfirm: confirmPassword);

      Fluttertoast.showToast(msg: "Password reset successful");
      Navigator.of(context).pop();
    } on ValidationException catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.cause}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Server Error: ${e}");
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Container(
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(left: 10, right: 0),
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextField(
                          controller: emailCT,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                            contentPadding: inputPadding,
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1.0),
                            ),
                            hintText: 'Enter Email',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50,
                        child: RawMaterialButton(
                          onPressed: sendOTPDisabled ? null : sendOTP,
                          child: Text(
                              _timer != null && _timer!.isActive
                                  ? "${TimeUtil.getMinutesSeconds(_start)}"
                                  : (numOTPAttempts > 0
                                      ? "Resend Verification Code"
                                      : "Send Verification Code"),
                              style: TextStyle(
                                  color: sendOTPDisabled
                                      ? Color.fromRGBO(0, 0, 0, 0.5)
                                      : AppColor.NEW_MAIN_COLOR_SCHEME,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Visibility(
                  visible: numOTPAttempts > 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextField(
                          controller: otpCT,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            contentPadding: inputPadding,
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1.0),
                            ),
                            hintText: 'Enter 6 digit code from email',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextField(
                          controller: passwordCT,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            contentPadding: inputPadding,
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1.0),
                            ),
                            hintText: 'Enter Password',
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        //padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextField(
                          controller: confirmPasswordCT,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            contentPadding: inputPadding,
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black12, width: 1.0),
                            ),
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      InkWell(
                        onTap: () {
                          KeyBoardFunctions.hideKeyBoard(context);
                          resetPassword();
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: screenWidth,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.NEW_MAIN_COLOR_SCHEME),
                          child: Center(
                            child: Text("Reset Password",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          LoadingScreen(
              inAsyncCall: isLoading, mesage: "Loading ...", dismissible: false)
        ],
      ),
    );
  }
}
