import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/create_import_wallet.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/keyboard.dart';

import '../widget/loading.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  @override
  _VerifyPhoneNumberPageState createState() => _VerifyPhoneNumberPageState();
}

class _VerifyPhoneNumberPageState extends State<VerifyPhoneNumberPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  late TextEditingController otpCT;
  late UserRepository userRepository;
  bool isLoading = false;
  User? user;

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  getOTP() async {
    try {
      bool isSuccess = await userRepository.getOTP();
      if (isSuccess) {
        setLoading(true);

        Fluttertoast.showToast(
            msg: "Verification Code Sent!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black);
      } else {
        throw new Exception("Failed");
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Verification Code Send Failed!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } finally {
      setLoading(false);
    }
  }

  verifyPhoneNumber() async {
    String otp = otpCT.text;
    if (otp.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter your Verification Code",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }

    try {
      setLoading(true);
      bool isSuccess = await userRepository.verifyPhoneNumber(otp: otp);
      if (isSuccess) {
        otpCT.clear();
        await userRepository.updatePhoneVerificationStatus();
        GlobalValue.setCurrentUser = (await userRepository.getUser())!;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => CreateImportWallet(),
            ),
            (route) => false);
      } else {
        throw new Exception("Network failed");
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Code verification Failed!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } finally {
      setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    userRepository = new UserRepository();
    user = GlobalValue.getCurrentUser;
    otpCT = TextEditingController();
    getOTP();
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
                Text(
                  "Verification Code has be sent to ${user!.phoneNumber}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: screenWidth,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: otpCT,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      contentPadding: inputPadding,
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 1.0),
                      ),
                      hintText: 'Enter Verification Code',
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: getOTP,
                  child: Text("Resend Verification Code",
                      style: TextStyle(
                          color: AppColor.NEW_MAIN_COLOR_SCHEME,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(height: screenHeight * 0.02),
                InkWell(
                  onTap: () {
                    KeyBoardFunctions.hideKeyBoard(context);
                    verifyPhoneNumber();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.NEW_MAIN_COLOR_SCHEME),
                    child: Center(
                      child: Text("Verify Verification Code",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                RawMaterialButton(
                  onPressed: () async {
                    GlobalValue.user = await UserRepository().getUser();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateImportWallet()));
                  },
                  child: Text("Skip Verification ->",
                      style: TextStyle(
                          color: AppColor.NEW_MAIN_COLOR_SCHEME,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          LoadingScreen(
              inAsyncCall: isLoading,
              mesage: "Verifying Phone Number...",
              dismissible: false)
        ],
      ),
    );
  }
}
