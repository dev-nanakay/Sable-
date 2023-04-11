import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/client/user_client.dart';
import 'package:sac_wallet/exceptions/validation_exception.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/login_page.dart';
import 'package:sac_wallet/util/keyboard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/loading.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  late TextEditingController nameCT,
      usernameCT,
      emailCT,
      phoneNumberCT,
      passwordCT,
      confPasswordCT,
      referralCodeCT;
  bool isUserAgreement = false;
  bool isLoading = false;
  String countryCode = "";
  late UserRepository userRepository;
  String? nameError,
      usernameError,
      phoneNumberError,
      emailError,
      passwordError,
      confPasswordError;

  bool userExists = false;

  final _usernameFocusNode = FocusNode();

  bool validateName() {
    if (nameCT.text.isEmpty) {
      setState(() {
        nameError = "Enter Name!";
      });
      return false;
    }
    setState(() {
      nameError = null;
    });
    return true;
  }

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

  bool validatePhoneNumber() {
    print(countryCode + phoneNumberCT.text);
    if (phoneNumberCT.text.isEmpty) {
      setState(() {
        phoneNumberError = "Enter Phone Number!";
      });
      return false;
    } else {
      if (phoneNumberCT.text.length == 10) {
        setState(() {
          phoneNumberError = "Phone Number should be 10 digits";
        });
        return false;
      }
    }
    setState(() {
      phoneNumberError = null;
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

  bool validateConfPassword() {
    if (passwordCT.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Enter your Confirm password",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      setState(() {
        passwordError = "Enter Confirm Password!";
      });
      return false;
    }
    setState(() {
      passwordError = null;
    });
    return true;
  }

  void _onCountryCodeInit(CountryCode? countryCode) {
    this.countryCode = countryCode.toString();
    print(countryCode.toString());
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      this.countryCode = countryCode.toString();
      print(countryCode.toString());
    });
  }

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  register(BuildContext context) async {
    String name = nameCT.text;
    String username = usernameCT.text;
    String email = emailCT.text;
    String phoneNumber = phoneNumberCT.text;
    String password = passwordCT.text;
    String confPassword = confPasswordCT.text;
    String referralCode = referralCodeCT.text;

    if (!validateName() &&
        !validateEmail() &&
        !validatePassword() &&
        !validateConfPassword() &&
        !validatePhoneNumber() &&
        username.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fill all forms",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }
    if (!isUserAgreement) {
      Fluttertoast.showToast(
          msg: "You should agree to User Agreement.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }

    if (password != confPassword) {
      Fluttertoast.showToast(
          msg: "Password and confirm password do not match.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }

    try {
      setLoading(true);
      String? checkReferralCode;
      print(referralCode);
      if (referralCode != null && referralCode.trim() != "") {
        checkReferralCode =
            await userRepository.checkReferralCode(referralCode: referralCode);
      }
      if (checkReferralCode != "Invalid Referral Code!" ||
          referralCode.isEmpty) {
        bool isSuccess = await userRepository.register(
            name: name,
            username: username,
            email: email,
            phoneNumber: countryCode + phoneNumber,
            password: password);

        print("Was registration successful ? ${isSuccess}");

        if (!isSuccess) {
          Fluttertoast.showToast(
              msg: "Email or Password already in use",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white);
          Fluttertoast.showToast(msg: "Failed!");
        } else {
          if (referralCode != null && referralCode.trim() != "") {
            String response = await userRepository.addReferral(
                referralCode: referralCode, email: email);

            Fluttertoast.showToast(
                msg: "Referral Added! Note: " + response,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.greenAccent,
                textColor: Colors.black);
          }
          Fluttertoast.showToast(msg: "Successfully registered!");
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
    } on ValidationException catch (e) {
      Fluttertoast.showToast(
          msg: "Error: ${e.cause}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error: ${e}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } finally {
      setLoading(false);
    }
  }

  _viewTermsAndAgreement() async {
    const url = 'https://sableassent.net/wpautoterms/terms-of-use/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Failed to load Terms and agreement");
    }
  }

  void changeUsernameFocus() {
    String username = usernameCT.text.trim();

    if (username != null && username.isNotEmpty) {
      UserClient().checkUsername(username).then((res) {
        setState(() {
          userExists = res;
          print("UserExists ${userExists}");
        });
      }).catchError((err) {
        Fluttertoast.showToast(msg: "Error checking username");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameCT = TextEditingController();
    usernameCT = TextEditingController();
    emailCT = TextEditingController();
    phoneNumberCT = TextEditingController();
    referralCodeCT = TextEditingController();
    passwordCT = TextEditingController();
    confPasswordCT = TextEditingController();
    userRepository = UserRepository();
    _usernameFocusNode.addListener(changeUsernameFocus);
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
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Image.asset("assets/images/app_icon.png",
                      width: screenWidth * 0.2, height: screenHeight * 0.1),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    //padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    decoration: BoxDecoration(color: Colors.white),

                    child: TextField(
                      controller: nameCT,
                      keyboardType: TextInputType.text,
                      onEditingComplete: validateName,
                      decoration: new InputDecoration(
                        labelText: "Name",
                        errorText: nameError,
                        contentPadding: inputPadding,
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              width: 1.0),
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
                      controller: usernameCT,
                      focusNode: _usernameFocusNode,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        labelText: "Username",
                        errorText: userExists ? "Username already taken" : null,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CountryCodePicker(
                          onChanged: _onCountryChange,
                          onInit: _onCountryCodeInit,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'US',
                          favorite: ['+1', 'US', '+91', 'IN'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: screenWidth,
                          decoration: BoxDecoration(color: Colors.white),
                          child: TextField(
                            controller: phoneNumberCT,
                            keyboardType: TextInputType.phone,
                            onEditingComplete: validatePhoneNumber,
                            decoration: new InputDecoration(
                              labelText: "PhoneNumber",
                              errorText: phoneNumberError,
                              contentPadding: inputPadding,
                              border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black12, width: 1.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextField(
                      controller: referralCodeCT,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        contentPadding: inputPadding,
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0),
                        ),
                        hintText: 'Enter Referral Code',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
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
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              width: 1.0),
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
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextField(
                      controller: confPasswordCT,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onEditingComplete: validateConfPassword,
                      decoration: new InputDecoration(
                        labelText: "Confirm Password",
                        errorText: confPasswordError,
                        contentPadding: inputPadding,
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black12, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isUserAgreement = !isUserAgreement;
                        });
                      },
                      child: Row(
                        //mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isUserAgreement
                                        ? Colors.blue
                                        : Colors.black45),
                                shape: BoxShape.circle,
                                color: isUserAgreement
                                    ? Colors.blue
                                    : Colors.white),
                            child: Center(
                              child: Icon(Icons.check,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text("I agree to the user agreement.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  InkWell(
                    onTap: () {
                      KeyBoardFunctions.hideKeyBoard(context);
                      register(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.NEW_MAIN_COLOR_SCHEME),
                      child: Center(
                        child: Text("Register",
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
                      Text("Already a Member?",
                          style: TextStyle(
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              fontSize: 14)),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginPage()));
                        },
                        child: Text("LOGIN ",
                            style: TextStyle(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      _viewTermsAndAgreement();
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserAgreementPage()));
                    },
                    child: Text("View this app's user agreement",
                        style: TextStyle(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME,
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          LoadingScreen(
            inAsyncCall: isLoading,
            mesage: "Signing up...",
            dismissible: false,
          )
        ],
      ),
      //)
    );
  }
}
