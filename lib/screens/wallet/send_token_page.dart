import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:sac_wallet/screens/transactions/confirmation_screen.dart';
import 'package:sac_wallet/screens/user_list.dart';
import 'package:sac_wallet/util/eth_util.dart';
import 'package:sac_wallet/util/keyboard.dart';
import 'package:sac_wallet/util/validator.dart';

import '../../model/user.dart';
import '../../util/global.dart';
import '../../widget/loading.dart';

//String address;

class SendTokenPage extends StatefulWidget {
  final String? walletAddress;

  SendTokenPage({this.walletAddress});

  @override
  _SendTokenPageState createState() => _SendTokenPageState();
}

class _SendTokenPageState extends State<SendTokenPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  User currentUser = GlobalValue.getCurrentUser;
  late TextEditingController toAddressCT, amountCT;
  bool isCertified = true;
  bool isLoading = false;

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  List<String> tokenOptions = <String>[
    "Sable Coin(SAC)",
    "Bitcoin(BTC)",
    "Ether(ETH)",
    "Send Cash"
  ];
  int tokenIndex = 0;

  Future scanBarcodeNormal() async {
    String barcodeScanRes = "";

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);

    List<String> resSplit = barcodeScanRes.split(":");
    if (resSplit.length == 2) {
      barcodeScanRes = resSplit[1];
    }
    if (Validator.recipientAddressValidityChecker(barcodeScanRes)) {
      setState(() {
        toAddressCT.text = barcodeScanRes;
      });
    } else {
      setState(() {
        Fluttertoast.showToast(msg: "Invalid Address!!");
      });
    }
  }

  String padByZero(String value, int finalLength) {
    while (value.length < finalLength) {
      value = "0" + value;
    }
    return value;
  }

  void doTransfer() async {
    String amount = amountCT.text.trim();
    if (!Validator.validateAmount(amount)) {
      Fluttertoast.showToast(msg: "Incorrect amount ${amount}");
      return;
    }
    String toAddress = toAddressCT.text.trim();

    if (!Validator.recipientAddressValidityChecker(toAddress)) {
      Fluttertoast.showToast(msg: "Invalid recipient address: ${toAddress}");
      return;
    }

    try {
      setLoading(true);
      String txHash = await EthUtil.doTransfer(currentUser, amount, toAddress);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
                txHash: txHash,
              )));
    } on InsufficientBalanceException {
      Fluttertoast.showToast(
          msg: "You have insufficient funds for this transaction");
    } on UnExpectedResponseException catch (e) {
      Fluttertoast.showToast(msg: e.cause);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not process");
    } finally {
      setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.walletAddress);
    toAddressCT = new TextEditingController(text: widget.walletAddress ?? "");
    amountCT = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final TextStyle inputLabelStyle = TextStyle(
        color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold);
    return PinLockWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Send Tokens", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth,
                        height: 60,
                        child: Card(
                            child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(" Select Token:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ),
                            Expanded(
                                child: Container(
                              child: Text(
                                "Sable Coin(SAC1)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                          ],
                        ))),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 60,
                      child: Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 20,
                              child: Text("Amount:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ),
                            Expanded(
                              flex: 80,
                              child: Container(
                                padding: EdgeInsets.only(top: 12, right: 12),
                                child: TextField(
                                  controller: amountCT,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: '',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      child: Text(" Send to:", style: inputLabelStyle),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 60,
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 80,
                              child: TextField(
                                controller: toAddressCT,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "0xe1063...",
                                ),
                                keyboardType: TextInputType.url,
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: ElevatedButton(
                                child: ImageIcon(
                                  AssetImage("assets/images/qr-code.png"),
                                  semanticLabel: 'Scan QR',
                                ),
                                onPressed: () {
                                  scanBarcodeNormal();
                                },
                                style: ElevatedButton.styleFrom(elevation: 0),
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: IconButton(
                                icon: Icon(Icons.contacts),
                                iconSize: 30,
                                onPressed: () async {
                                  String? result = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              UserListPage()));
                                  if (result != null) {
                                    setState(() {
                                      toAddressCT.text = result;
                                    });
                                  }
                                },
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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
                            child: Text("Send",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        onTap: () {
                          KeyBoardFunctions.hideKeyBoard(context);
                          doTransfer();
                        },
                      ),
                    ),
                    // SizedBox(height: 10.0),
                    // Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text("Send to:",
                    //           style: inputLabelStyle),
                    //       Container(
                    //         padding: EdgeInsets.only(top: 10),
                    //         child: TextField(
                    //           controller: toAddressCT,
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(),
                    //             hintText: "0xe1063...",
                    //           ),
                    //           keyboardType: TextInputType.url,
                    //         ),
                    //       ),
                    //     ]
                    // ),
                    // const SizedBox(height: 10.0),
                    // SizedBox(height: 40),
                    // Container(
                    //   padding: EdgeInsets.only(left: 20, right: 20),
                    //   child: GestureDetector(
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Colors.blue,
                    //         ),
                    //         child: Center(
                    //           child: Text("Send Token",
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 18,
                    //                   fontWeight: FontWeight.bold)),
                    //         ),
                    //       ),
                    //       onTap: () {
                    //         sendToken();
                    //       }),
                    // ),
//                   /*Container(
//                     alignment: Alignment.topLeft,
//                     child: RichText(
//                       text: TextSpan(
//                           children: [
//                             TextSpan(
//                                 text: "Name: ",
//                                 style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)
//                             ),
//                             TextSpan(
//                                 text: currentUser.name,
//                                 style: TextStyle(color: Colors.black, fontSize: 15)
//                             )
//                           ]
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   RichText(
//                     text: TextSpan(
//                         children: [
//                           TextSpan(
//                               text: "My Wallet: ",
//                               style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)
//                           ),
//                           TextSpan(
//                               text: currentUser.walletAddress,
//                               style: TextStyle(color: Colors.black, fontSize: 15)
//                           )
//                         ]
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   Container(
//                     child: Text("Transaction Information", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),*/
//                   SizedBox(height: 10),
//                   Container(
//                     padding: EdgeInsets.only(left: 10, right: 10),
//                     width: screenWidth,
//                     height: 70,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.grey.shade300)
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text("Select Token:", style: TextStyle(color: Colors.black, fontSize: 15)),
//                         Container(
// //                          child: DropdownButtonHideUnderline(
// //                            child: DropdownButton<String>(
// //                              items: tokenOptions.map((value){
// //                                return DropdownMenuItem<String>(
// //                                  value: value,
// //                                  child: Text(value, style: TextStyle(color: Colors.black, fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 3),
// //                                );
// //                              }).toList(),
// //                              value: tokenOptions[tokenIndex],
// //                              onChanged: (newValue) {
// //                                setState(() {
// //                                  tokenIndex = tokenOptions.indexOf(newValue);
// //                                });
// //                              },
// //                            ),
// //                          ),
//                           child: Text("Stable Coin(SAC)", style: TextStyle(color: Colors.black),),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
                    // Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Text("Send to:", style: inputLabelStyle),
                    //       Container(
                    //         padding: EdgeInsets.only(top: 10),
                    //         child: TextField(
                    //           controller: toAddressCT,
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(),
                    //             hintText: "0xe1063...",
                    //           ),
                    //           keyboardType: TextInputType.url,
                    //         ),
                    //       ),
                    //     ]),
                    // SizedBox(height: 10.0),
                    /* Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Send to:", style: TextStyle(color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: Expanded(child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: toAddressCT,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "0xe1063...",
                              ),
                              keyboardType: TextInputType.text,
                            ),)
                          )
                        ],
                      ),
                    ),*/
//                  Container(
//                    padding: EdgeInsets.only(left: 10, right: 10),
//                    width: screenWidth,
//                    height: 50,
//                    decoration: BoxDecoration(
//                        color: Colors.white,
//                        border: Border.all(color: Colors.grey.shade300)
//                    ),
//                    child: Row(
//                      mainAxisSize: MainAxisSize.max,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text("Private Key:", style: TextStyle(color: Colors.black87, fontSize: 15)),
//                        Container(
//                          width: screenWidth * 0.7,
//                          padding: EdgeInsets.only(top: 10),
//                          child: Center(child: Text(GlobalValue.getPrivateKey, style: TextStyle(color: Colors.black))),
//                        )
//                      ],
//                    ),
//                  ),
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
                    //       Text("Amount:", style: TextStyle(color: Colors.black87, fontSize: 15)),
                    //       Container(
                    //         width: screenWidth * 0.5,
                    //         padding: EdgeInsets.only(top: 10),
                    //         child: TextField(
                    //           controller: amountCT,
                    //           decoration: InputDecoration(
                    //             border: OutlineInputBorder(
                    //               borderSide: BorderSide.none,
                    //             ),
                    //             hintText: "amount",
                    //           ),
                    //           keyboardType: TextInputType.number,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // FlatButton(
                    //   child: Text("Scan OR"),
                    //   onPressed: () {
                    //     scanBarcodeNormal();
                    //   },
                    // ),

                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10, right: 10),
                    //   width: screenWidth,
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey.shade300)),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text("I certify the above is true.", style: TextStyle(color: Colors.black87, fontSize: 15)),
                    //       Switch(
                    //         value: isCertified,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isCertified = value;
                    //           });
                    //         },
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 40),
                    // InkWell(
                    //   onTap: () {
                    //     sendToken();
                    //   },
                    //   child: Container(
                    //     width: screenWidth,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue,
                    //     ),
                    //     child: Center(
                    //       child: Text("SEND", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            LoadingScreen(
              inAsyncCall: isLoading,
              dismissible: false,
              mesage: "Sending token...",
            )
          ],
        ),
      ),
    );
  }
}
