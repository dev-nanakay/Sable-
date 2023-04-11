import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/dashboard_page.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/widget/loading.dart';

import 'constants.dart';

class CreatePin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePin> {
  final PIN_LENGTH = PinConstants.PIN_LENGTH;

  bool isNextButtonVisible = false;
  bool verifyPin = false;
  String pin = '';
  String pinAgain = '';
  List<String> pinArray = [];
  bool isLoading = false;

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  @override
  void initState() {
    super.initState();
    isNextButtonVisible = true;
    pin = "";
    pinAgain = "";
    verifyPin = false;
    pinArray = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '-1'];
  }

  void onTapNumber(String numb) {
    int number = int.parse(numb);
    if (!verifyPin) {
      if (pin.length < PIN_LENGTH) {
        setState(() {
          pin = pin + number.toString();
        });
      }
      if (pin.length == PIN_LENGTH) {
        setState(() {
          verifyPin = true;
        });
      }
      //  else {
      //   Fluttertoast.showToast(msg: "Pin length should be ${PIN_LENGTH}");
      // }
    } else {
      if (pinAgain.length < PIN_LENGTH) {
        setState(() {
          pinAgain = pinAgain + number.toString();
        });
      }
      if (pinAgain.length == PIN_LENGTH) {
        pinVerification();
      }
    }
  }

  void pinVerification() async {
    // confirm pin and show error if necessary
    if (pin == pinAgain) {
      // Save pin and redirect to next page
      try {
        setLoading(true);
        Fluttertoast.showToast(msg: "Pin confirmed");
        await UserRepository().addPin(pin: pin);

        GlobalValue.setCurrentUser = (await UserRepository().getUser())!;
        print("USER:" + GlobalValue.user.toString());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
            (route) => false);
      } catch (Exception) {
        Fluttertoast.showToast(msg: "Error setting pin");
      } finally {
        setLoading(false);
      }
    } else {
      Fluttertoast.showToast(msg: "Pin does not match. Please try again.");
      setState(() {
        // reset all
        // pin = "";
        pinAgain = "";
        // verifyPin = false;
      });
    }
  }

  void removeLastDigit() {
    if (!verifyPin) {
      if (pin.length > 0) {
        setState(() {
          pin = pin.substring(0, pin.length - 1);
        });
      }
    } else {
      if (pinAgain.length > 0) {
        setState(() {
          pinAgain = pinAgain.substring(0, pinAgain.length - 1);
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    // Instead of popping current page, go to enter pin if verifyPin is not true.
    if (verifyPin) {
      setState(() {
        verifyPin = false;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text(verifyPin ? "Confirm Pin" : "Set a new Pin",
                  style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            resizeToAvoidBottomInset: false,
            body: Stack(children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "This pin will be used to unlock the app.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 80,
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Card(
                            child: Center(
                                child: Text(
                              verifyPin
                                  ? PinConstants.starPrint(pinAgain)
                                  : PinConstants.starPrint(pin),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Colors.black87,
                              ),
                            )),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 75),
                            child: GridView.builder(
                                itemCount: pinArray.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // Start from 1 and end with 0
                                  // int element = (index + 1) % 10;
                                  String element = pinArray[index];
                                  return Container(
                                      child: MaterialButton(
                                    textColor: Colors.black,
                                    key: ValueKey(element),
                                    onPressed: () {
                                      element == '-1'
                                          ? print('nothing')
                                          : setState(() {
                                              onTapNumber(element);
                                            });
                                    },
                                    child: element == '-1'
                                        ? Container(
                                            child: MaterialButton(
                                              onPressed: () {
                                                removeLastDigit();
                                              },
                                              child: Icon(
                                                Icons.backspace,
                                                size: 24.0,
                                                semanticLabel:
                                                    'Text to announce in accessibility modes',
                                              ),
                                            ),
                                          )
                                        : Container(
                                            child: Text(element.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 36,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                  ));
                                },
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3))),

                        // verifyPin
                        //     ? Container()
                        //     : Visibility(
                        //         child: Container(
                        //           padding: EdgeInsets.only(left: 30, right: 30),
                        //           child: GestureDetector(
                        //             child: Container(
                        //               width: MediaQuery.of(context).size.width,
                        //               height: 50,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(10),
                        //                 color: Colors.blue,
                        //               ),
                        //               child: Center(
                        //                 child: Text('Next',
                        //                     style: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 18,
                        //                         fontWeight: FontWeight.bold)),
                        //               ),
                        //             ),
                        //             onTap: () async {
                        //               if (!verifyPin) {
                        //                 if (pin.length == PIN_LENGTH) {
                        //                   setState(() {
                        //                     verifyPin = true;
                        //                   });
                        //                 } else {
                        //                   Fluttertoast.showToast(msg:
                        //                       "Pin length should be ${PIN_LENGTH}",
                        //                       context);
                        //                 }
                        //                 // } else {
                        //                 //   // confirm pin and show error if necessary
                        //                 //   if (pin == pinAgain) {
                        //                 //     // Save pin and redirect to next page
                        //                 //     Fluttertoast.showToast(msg: "Pin confirmed");
                        //                 //     await userBloc.addPin(pin: pin);

                        //                 //   GlobalValue.setCurrentUser =
                        //                 //       await UserRepository().getUser();
                        //                 //   print(
                        //                 //       "USER:" + GlobalValue.user.toString());
                        //                 //   Navigator.of(context).pushAndRemoveUntil(
                        //                 //       MaterialPageRoute(
                        //                 //         builder: (context) => DashboardPage(),
                        //                 //       ),
                        //                 //       (route) => false);
                        //                 // } else {
                        //                 //   Fluttertoast.showToast(msg:
                        //                 //       "Pin does not match. Please try again.",
                        //                 //       context);
                        //                 // }
                        //               }
                        //             },
                        //           ),
                        //         ),
                        //       ),
                        //  SizedBox(height: 10),
                        // Visibility(
                        //   visible: verifyPin,
                        //   child: Container(
                        //     padding: EdgeInsets.only(left: 30, right: 30),
                        //     child: GestureDetector(
                        //       child: Container(
                        //         width: MediaQuery.of(context).size.width,
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: AppColor.MAIN_COLOR_SCHEME,
                        //         ),
                        //         child: Center(
                        //           child: Text("Try again",
                        //               style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.bold)),
                        //                 //     GlobalValue.setCurrentUser =
                        //                 //         await UserRepository().getUser();
                        //                 //     print(
                        //                 //         "USER:" + GlobalValue.user.toString());
                        //                 //     Navigator.of(context).push(
                        //                 //         MaterialPageRoute(
                        //                 //             builder: (context) =>
                        //                 //                 DashboardPage()));
                        //                 //   } else {
                        //                 //     Fluttertoast.showToast(msg:
                        //                 //         "Pin does not match. Please try again.",
                        //                 //         context);
                        //                 //         setState(() {
                        //                 //   // reset all
                        //                 //   pin = "";
                        //                 //   pinAgain = "";
                        //                 //  // verifyPin = false;
                        //                 // }
                        //                 // );
                        //                 //   }
                        //               }
                        //             },
                        //           ),
                        //         ),
                        //       ),
                        // SizedBox(height: 10),
                        // Visibility(
                        //   visible: verifyPin,
                        //   child: Container(
                        //     padding: EdgeInsets.only(left: 30, right: 30),
                        //     child: GestureDetector(
                        //       child: Container(
                        //         width: MediaQuery.of(context).size.width,
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: AppColor.MAIN_COLOR_SCHEME,
                        //         ),
                        //         child: Center(
                        //           child: Text("Try again",
                        //               style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.bold)),
                        //         ),
                        //       ),
                        //       onTap: () {
                        //         setState(() {
                        //           // reset all
                        //           pin = "";
                        //           pinAgain = "";
                        //           verifyPin = false;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // )
                      ]),
                ),
              ),
              LoadingScreen(
                  inAsyncCall: isLoading, mesage: "Loading", dismissible: false)
            ])));
  }
}
