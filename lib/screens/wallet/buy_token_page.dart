import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr/qr.dart';
//import 'package:qr_flutter/qr_flutter.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:toast/toast.dart';

import '../../model/user.dart';
import '../../util/global.dart';
import '../../widget/loading.dart';

class BuyTokenPage extends StatefulWidget {
  @override
  _BuyTokenPageState createState() => _BuyTokenPageState();
}

class _BuyTokenPageState extends State<BuyTokenPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  User currentUser = GlobalValue.getCurrentUser;
  late TextEditingController unitCT;
  bool isApprovedTransaction = false;
  bool isLoading = false;

  List<String> tokenOptions = <String>[
    "Sable Coin(SAC)",
    "Bitcoin(BTC)",
    "Ether(ETH)"
  ];
  int tokenIndex = 0;

  buyToken() async {
    //String tokenName = tokenOptions[tokenIndex];
    String purchaseUnit = unitCT.text;

    if (purchaseUnit.isEmpty) {
      Toast.show("Enter unit for purchase");
      return;
    }

    if (!isApprovedTransaction) {
      Toast.show("Confirm approval of this transaction!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  void copyAddress() {
    // copy the address
    Clipboard.setData(ClipboardData(text: currentUser.walletAddress));
    Toast.show("Copied to clipboard!");
  }

  void clickOnDone() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    print(currentUser.walletAddress.toString());
//    walletBloc = new WalletBloc();
    unitCT = new TextEditingController();
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
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Receive or Deposit Tokens",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    /* Container(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Name: ",
                              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                              text: currentUser.name,
                              style: TextStyle(color: Colors.black, fontSize: 15)
                            )
                          ]
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: "My Wallet: ",
                                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: currentUser.walletAddress,
                                style: TextStyle(color: Colors.black, fontSize: 15)
                            )
                          ]
                      ),
                    ),
                  SizedBox(height: 40),*/
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   width: screenWidth,
                    //   height: 70,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey.shade300)
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text("Select Token:", style: TextStyle(color: Colors.black, fontSize: 15)),
                    //       Container(
                    //         child: DropdownButtonHideUnderline(
                    //           child: DropdownButton<String>(
                    //             items: tokenOptions.map((value){
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(value, style: TextStyle(color: Colors.black, fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 3),
                    //               );
                    //             }).toList(),
                    //             value: tokenOptions[tokenIndex],
                    //             onChanged: (newValue) {
                    //               setState(() {
                    //                 tokenIndex = tokenOptions.indexOf(newValue);
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   width: screenWidth,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey.shade300)
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text("Units to purchase:", style: TextStyle(color: Colors.black87, fontSize: 15)),
                    //       Container(
                    //         width: screenWidth * 0.5,
                    //         padding: EdgeInsets.only(top: 10),
                    //         child: TextField(
                    //           controller: unitCT,
                    //           decoration: InputDecoration(
                    //               border: OutlineInputBorder(
                    //                 borderSide: BorderSide.none,
                    //               ),
                    //               hintText: "1000",
                    //           ),
                    //           keyboardType: TextInputType.number,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   width: screenWidth,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey.shade300)
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text("I approve this transaction.", style: TextStyle(color: Colors.black87, fontSize: 15)),
                    //       Switch(
                    //         value: isApprovedTransaction,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isApprovedTransaction = value;
                    //           });
                    //         },
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 40),
                    // InkWell(
                    //   onTap: () {
                    //     buyToken();
                    //   },
                    //   child: Container(
                    //     width: screenWidth,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue,
                    //     ),
                    //     child: Center(
                    //       child: Text("BUY NOW",
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),

                    Center(
                      child: Container(
                        child: Card(
                         /*  child: QrImage(
                            data: currentUser.walletAddress,
                            size: 250,
                          ), */
                        ),
                      ),
                    ),
                    Text('Ask your friend to scan QR code to transfer',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Address:',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Card(
                        child: ElevatedButton(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 90,
                                  child: Text(currentUser.walletAddress,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(
                                height: 05,
                              ),
                              Expanded(
                                  flex: 10, child: Icon(Icons.content_copy)),
                            ],
                          ),
                          onPressed: () {
                            copyAddress();
                          },
                          style: ElevatedButton.styleFrom(elevation: 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    // SizedBox(height: screenHeight * 0.1),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                            ),
                            child: Center(
                              child: Text("Done",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          onTap: () {
                            clickOnDone();
                          }),
                    ),
                  ],
                ),
              ),
            ),
            LoadingScreen(
              inAsyncCall: isLoading,
              dismissible: false,
              mesage: "Buying token...",
            )
          ],
        ),
      ),
    );
  }
}
