import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';

class ConfirmationScreen extends StatefulWidget {
  final String txHash;

  ConfirmationScreen({Key? key, required this.txHash}) : super(key: key);

  @override
  _ConfirmationScreenState createState() =>
      _ConfirmationScreenState(txHash: txHash);
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  String txHash;

  _ConfirmationScreenState({required this.txHash}) : super();

  @override
  Widget build(BuildContext context) {
    return PinLockWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   automaticallyImplyLeading: true,
        //   backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        //   iconTheme: new IconThemeData(color: Colors.white),
        //   title: Text("Confirmation", style: TextStyle(color: Colors.white)),
        //   centerTitle: true,
        // ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Stack(children: <Widget>[
            Container(
              color: AppColor.NEW_MAIN_COLOR_SCHEME,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Your Transaction was sent successfully!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 20,
                          child: Text("Tx Hash:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal)),
                        ),
                        Expanded(
                          flex: 80,
                          child: ElevatedButton(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 90,
                                    child: Text(
                                      txHash,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.content_copy,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  )
                                ]),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: txHash));
                              Fluttertoast.showToast(
                                  msg: "Copied to Clipboard");
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Icon(
                      Icons.done_outline,
                      color: Colors.white,
                      size: 60.0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      "To view the status and details of your transaction go to your wallet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Tap anywhere to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Text(
                  //     "Your transaction was sent successfully",
                  //     style: TextStyle(
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Expanded(
                  //         flex: 3,
                  //         child: Text("Tx Hash:",
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.normal)),
                  //       ),
                  //       Expanded(
                  //         flex: 5,
                  //         child: Container(
                  //           padding: EdgeInsets.only(top: 12, right: 12),
                  //           child: Text(
                  //             txHash,
                  //             textAlign: TextAlign.left,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //           flex: 2,
                  //           child: IconButton(
                  //             icon: Icon(Icons.content_copy),
                  //             onPressed: () {
                  //               Clipboard.setData(ClipboardData(text: txHash));
                  //               Fluttertoast.showToast(msg: "Copied", context);
                  //             },
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  // Expanded(
                  //   flex: 3,
                  //   child: Icon(
                  //     Icons.done_outline,
                  //     size: 75.0,
                  //   ),
                  // ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Text(
                  //     "To view the status and details of your transaction go to your wallet",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Text(
                  //     "Tap anywhere to continue",
                  //     style: TextStyle(
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
