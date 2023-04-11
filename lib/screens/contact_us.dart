import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/keyboard.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactusPageState createState() => _ContactusPageState();
}

class _ContactusPageState extends State<ContactUs> {
  late TextEditingController emailText, mainText;
  double screenWidth = 0.0, screenHeight = 0.0;
  String selectedSubjectValue = "";
  final FocusNode _focusNodeOfMainText = FocusNode();
  List<String> subjectOptions = <String>[
    "Comments",
    "Feedback",
    "Suggestions",
  ];
  int subjectIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailText = TextEditingController();
    //subjectText = TextEditingController();
    mainText = TextEditingController();
  }

  void sendEmail() async {
    String response = await UserRepository()
        .contactUs(subject: selectedSubjectValue, message: mainText.text);
    if (response == "Email Sent") {
      Fluttertoast.showToast(msg: "Email Sent");
    } else {
      Fluttertoast.showToast(msg: "Email Not Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text("Contact us", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              KeyBoardFunctions.hideKeyBoard(context);
              sendEmail();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 20,
                                  child: Text(
                                    'From :',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                flex: 80,
                                child: Text(
                                  GlobalValue.getCurrentUser.email,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 05.0,
                        ),
                        Divider(
                          height: 0.8,
                          color: Colors.black12,
                        ),
                        SizedBox(
                          height: 05.0,
                        ),
                        Container(
                          //  height: 30,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 30,
                                  child: Text(
                                    'Subject :',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  )),
                              Expanded(
                                flex: 70,
                                child: Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      items: subjectOptions.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3),
                                        );
                                      }).toList(),
                                      value: subjectOptions[subjectIndex],
                                      onChanged: (newValue) {
                                        setState(() {
                                          subjectIndex =
                                              subjectOptions.indexOf(newValue!);
                                          selectedSubjectValue = newValue;
                                          print(selectedSubjectValue);
                                        });
                                      },
                                      hint: Text('select the subject'),
                                    ),
                                  ),
                                ),
                              )
                              // SizedBox(
                              //   width: 10.0,
                              // ),
                              // Expanded(
                              //   flex: 80,
                              //   child: TextField(
                              //     controller: subjectText,
                              //     maxLines: null,
                              //     keyboardType: TextInputType.text,
                              //     textAlign: TextAlign.start,
                              //     decoration:
                              //         InputDecoration(border: InputBorder.none),
                              //     style: TextStyle(
                              //         fontSize: 16, color: Colors.black),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 05.0,
                        ),
                        Divider(
                          height: 0.8,
                          color: Colors.black12,
                        ),
                        SizedBox(
                          height: 05.0,
                        ),
                        Container(
                            padding: EdgeInsets.all(5.0),
                            child: KeyboardActions(
                              autoScroll: false,
                              config: KeyBoardFunctions.keyBoardDoneAction(
                                  context, _focusNodeOfMainText),
                              child: TextField(
                                focusNode: _focusNodeOfMainText,
                                controller: mainText,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Please Enter here'),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
