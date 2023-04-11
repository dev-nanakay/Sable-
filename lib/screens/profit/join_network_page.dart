import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';

import '../../model/profit.dart';
import '../../model/user.dart';
import '../../util/global.dart';
import '../../widget/loading.dart';

class JoinNetworkPage extends StatefulWidget {
  @override
  _JoinNetworkPageState createState() => _JoinNetworkPageState();
}

class _JoinNetworkPageState extends State<JoinNetworkPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  late TextEditingController nameCT, phoneCT, emailCT, orgNameCT;
  int statusIndex = 0, locationIndex = 0;
  bool isLoading = false;

  List<String> statusList = <String>[
    "Currently listed on the Sable Assent Registry",
    "Register Now(To partner, you must be currently be a Registered Black Business)"
  ];
  List<String> locationList = <String>[
    "Africa",
    "N. America",
    "S. America",
    "Caribbean Islands",
    "Asia",
    "Antarctica",
    "Australia",
    "Europe"
  ];

  addNonProfitData() async {
    String name = nameCT.text;
    String email = emailCT.text;
    String phone = phoneCT.text;
    String organization = orgNameCT.text;

    if (name.isEmpty) {
      Fluttertoast.showToast(msg: "Enter name");
      return;
    }

    if (phone.isEmpty) {
      Fluttertoast.showToast(msg: "Enter phone number");
      return;
    }

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Enter email address");
      return;
    }

    if (organization.isEmpty) {
      Fluttertoast.showToast(msg: "Enter organization name");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Random random = new Random();
    User user = GlobalValue.getCurrentUser;

    Profit profit = new Profit(
        id: "${random.nextInt(1000)}",
        profitName: name,
        userName: user.name,
        userWalletAddress: user.walletAddress ?? '-',
        email: email,
        phone: phone,
        organization: organization,
        location: locationList[locationIndex],
        status: statusList[statusIndex]);
    bool isSuccess = true;
    if (isSuccess) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Successfully added your Non Profit data");
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Failed!");
    }
  }

  @override
  void initState() {
    super.initState();
    nameCT = new TextEditingController();
    emailCT = new TextEditingController();
    phoneCT = new TextEditingController();
    orgNameCT = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return PinLockWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          title: Text("Register Your Business",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Are you part of a governmental organization, non-profit, or NGO that plays a vital role in the development of Pan-African Economies? If so, we'd love to learn more about you.",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text("Non-Profit Enrollment",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Name:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: nameCT,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Enter Name",
                                  contentPadding: EdgeInsets.all(2)),
                              keyboardType: TextInputType.text,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Email:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: emailCT,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Enter email",
                                  contentPadding: EdgeInsets.all(2)),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Phone:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: phoneCT,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Enter phone number",
                                  contentPadding: EdgeInsets.all(2)),
                              keyboardType: TextInputType.phone,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Name of Organization:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: orgNameCT,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Enter organization name",
                                  contentPadding: EdgeInsets.all(2)),
                              keyboardType: TextInputType.text,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Location:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: locationList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                value: locationList[locationIndex],
                                onChanged: (newValue) {
                                  setState(() {
                                    locationIndex =
                                        locationList.indexOf(newValue!);
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Status:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.7,
                            padding: EdgeInsets.only(top: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isDense: true,
                                isExpanded: true,
                                items: statusList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3),
                                  );
                                }).toList(),
                                value: statusList[statusIndex],
                                onChanged: (newValue) {
                                  setState(() {
                                    statusIndex = statusList.indexOf(newValue!);
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        addNonProfitData();
                      },
                      child: Container(
                          width: screenWidth,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text("SUBMIT",
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            LoadingScreen(
              inAsyncCall: isLoading,
              dismissible: false,
              mesage: "Adding as Non-Profit...",
            )
          ],
        ),
      ),
    );
  }
}
