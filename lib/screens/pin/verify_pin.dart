import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/pin/constants.dart';
import 'package:sac_wallet/util/time_util.dart';

import '../dashboard_page.dart';

class VerifyPin extends StatefulWidget {
  final String onDone;

  VerifyPin({required this.onDone});

  @override
  State<StatefulWidget> createState() => _VerifyPinPageState();
}

class _VerifyPinPageState extends State<VerifyPin> {
  String onDone = '';
  String pin = '';
  List<String> pinArray = [];
  Timer? _timer;
  int _start = 0;
  User? currentUser;

  void startTimer(int start) {
    _start = start;
    const oneSec = const Duration(seconds: 1);
    if (_timer == null || !_timer!.isActive) {
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
            } else {
              print(_start);
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

  final PIN_LENGTH = PinConstants.PIN_LENGTH;

  @override
  void initState() {
    super.initState();
    pin = "";
    pinArray = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '-1'];
    onDone = widget.onDone;
    UserRepository().getUser().then((value) {
      currentUser = value;

      int currentTime = DateTime.now().millisecondsSinceEpoch;

      int lastAttemptTime;
      if (currentUser!.incorrectAttemptsTime != null)
        lastAttemptTime =
            int.tryParse(currentUser!.incorrectAttemptsTime!) ?? 0;
      else {
        lastAttemptTime = 0;
      }
      int delta = currentTime - lastAttemptTime;
      if (value!.incorrectAttempts == null) value.incorrectAttempts = "0";
      if (int.tryParse(value.incorrectAttempts!)! >=
              PinConstants.ALLOWED_ATTEMPTS &&
          delta < PinConstants.RETRY_INTERVAL) {
        print("Delta");
        print((PinConstants.RETRY_INTERVAL - delta));
        Fluttertoast.showToast(
            msg:
                "Your wallet is locked for ${getRemainingTimeInMinutes(delta)} minutes since last attempt, try again later");
        if (_timer == null || !_timer!.isActive) {
          startTimer(((PinConstants.RETRY_INTERVAL - delta) / 1000).ceil());
        }
      }
    });
  }

  void onTapNumber(String numb) {
    if (pin.length < PIN_LENGTH) {
      setState(() {
        pin = pin + numb;
      });
    }
    if (pin.length == PIN_LENGTH) {
      pinVerification();
    }
  }

  void loginIfPinCorrect(int currentAttempts) async {
    UserRepository userRepository = UserRepository();

    if (pin.length == PIN_LENGTH) {
      bool wasSame = await userRepository.verifyPin(pin: pin);
      if (wasSame) {
        print("PIN Verified");
        print("PIN:::::$onDone");
        // Pin verified
        if (onDone == "MAIN") {
        print("PIN Verified:::::");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => DashboardPage(),
              ),
              (route) => false);
        } else {
          Navigator.pop(context, 'true');
        }
      } else {
        // update attempts
        await userRepository.incrementIncorrectAttempt();
        // Login Failure
        Fluttertoast.showToast(
            msg: "Invalid Pin. \n"
                "You have ${PinConstants.ALLOWED_ATTEMPTS - currentAttempts} attempts remaining");
        setState(() {
          pin = "";
        });
      }
    }
  }

  int getRemainingTimeInMinutes(int delta) =>
      ((PinConstants.RETRY_INTERVAL - delta) / 60000).ceil();

  void pinVerification() async {
    UserRepository userRepository = UserRepository();

    currentUser = await userRepository.getUser();
    int currentAttempts = 0;
    if (currentUser!.incorrectAttempts != null)
      currentAttempts = int.tryParse(currentUser!.incorrectAttempts!) ?? 0;

    if (currentAttempts < PinConstants.ALLOWED_ATTEMPTS) {
      loginIfPinCorrect(currentAttempts);
    } else {
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      int lastAttemptTime = int.tryParse(currentUser!.incorrectAttemptsTime!)!;

      int delta = currentTime - lastAttemptTime;
      if (currentAttempts + 1 == PinConstants.ALLOWED_ATTEMPTS &&
          !_timer!.isActive) {
        startTimer(((PinConstants.RETRY_INTERVAL - delta) / 1000).ceil());
      }
      if (delta < PinConstants.RETRY_INTERVAL) {
        Fluttertoast.showToast(
            msg:
                "Your wallet is locked for ${TimeUtil.getMinutesSeconds(((PinConstants.RETRY_INTERVAL - delta) / 1000).ceil())} minutes since last attempt, try again later");
        if (_timer != null || !_timer!.isActive) {
          startTimer(((PinConstants.RETRY_INTERVAL - delta) / 1000).ceil());
        }
      } else {
        userRepository.updateIncorrectAttempt(attempts: 0, time: '');
        loginIfPinCorrect(0);
      }
      setState(() {
        pin = "";
      });
    }
  }

  void removeLastDigit() {
    if (pin.length > 0) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Container(),
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title:
              Text("Unlock your wallet", style: TextStyle(color: Colors.white)),
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
                    Container(
                      child: Center(
                        child: Text(
                          _timer != null && _timer!.isActive
                              ? "Try again in ${TimeUtil.getMinutesSeconds(_start)} minutes"
                              : "Please enter your 4 digit pin to unlock the wallet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
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
                        PinConstants.starPrint(pin),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.black87,
                        ),
                      ))),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 75),
                        child: GridView.builder(
                            itemCount: pinArray.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String element = pinArray[index];
                              return Container(
                                  child: MaterialButton(
                                textColor: Colors.black,
                                key: ValueKey(element),
                                onPressed: () {
                                  if (element != '-1') {
                                    onTapNumber(element);
                                  }
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
                                            semanticLabel: 'Delete last digit',
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Text(element.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold))),
                              ));
                            },
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3))),
                  ]),
            ),
          )
        ]));

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: scaffold);
  }
}
