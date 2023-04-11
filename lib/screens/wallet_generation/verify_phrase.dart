import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/util/eth_util.dart';
import 'package:sac_wallet/widget/loading.dart';

import '../pin/create_pin.dart';

class VerifyPhrase extends StatefulWidget {
  final String passphrase;

  VerifyPhrase({Key? key, required this.passphrase}) : super(key: key);

  @override
  State<VerifyPhrase> createState() => _VerifyPhrasePageState();
}

class _MnemonicObject {
  String element;
  int index;

  _MnemonicObject(this.element, this.index);

  static getList(List<String> list) {
    List<_MnemonicObject> out = [];
    for (int i = 0; i < list.length; i++) {
      out.add(_MnemonicObject(list[i], i));
    }
    return out;
  }

  @override
  String toString() {
    return element;
  }

  /* @override
  bool operator ==(other) {
    return other.element == element && other.index == index;
  } */
}

class _VerifyPhrasePageState extends State<VerifyPhrase> {
  double screenWidth = 0.0, screenHeight = 0.0;
  String passphrase = "";

  List<_MnemonicObject> passphraseArray = [];

  List<_MnemonicObject> enteredPassphraseArray = [];

  String? passphraseCT;
  bool isNextButtonVisible = false;

  bool isLoading = false;

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  // Shuffle list randomly O(n)
  void shuffleList(List<dynamic> list) {
    Random random = new Random();
    int listLength = list.length;
    for (int i = 0; i < listLength; i++) {
      int randIndex = random.nextInt(listLength);
      dynamic temp = list[i];
      list[i] = list[randIndex];
      list[randIndex] = temp;
    }
  }

  @override
  void initState() {
    super.initState();
    // Split passphrase according to spaces
    passphraseArray = _MnemonicObject.getList(passphrase.split(' '));
    // Randomize the passphrase Array
    shuffleList(passphraseArray);

    enteredPassphraseArray = [];
  }

  bool checkIfListEqual(List<dynamic> list1, List<dynamic> list2) {
    Function eq = const ListEquality().equals;
    return eq(list1, list2);
  }

  void onClickVerifyButton() {
    if (checkIfListEqual(_MnemonicObject.getList(passphrase.split(" ")),
        enteredPassphraseArray)) {
      // Show next button
      setState(() {
        isNextButtonVisible = true;
      });
      Fluttertoast.showToast(msg: "Backup Mnemonic Match!");
    } else {
      setState(() {
        enteredPassphraseArray.clear();
        passphraseCT = enteredPassphraseArray.toString();
      });
      Fluttertoast.showToast(msg: "Invalid Mnemonic, please try again.");
    }
  }

  void onClickNextButton() async {
    try {
      setLoading(true);
      String privateKey = EthUtil.generatePrivateKey(passphrase);
      String walletAddress = await EthUtil.generateWalletAddress(privateKey);

      UserRepository userRepository = new UserRepository();

      await userRepository.addPrivateKey(privateKey: privateKey);
      await userRepository.addWalletAddress(walletAddress: walletAddress);

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreatePin()));
    } catch (Exception) {
      Fluttertoast.showToast(msg: "An error occurred");
    } finally {
      setLoading(false);
    }
  }

  void onClickClearButton() {
    setState(() {
      enteredPassphraseArray.clear();
      passphraseCT = enteredPassphraseArray.toString();
    });
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
          title: Text("Confirm BackUp", style: TextStyle(color: Colors.white)),
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
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Card(
                            // borderOnForeground: true,
                            shadowColor: Colors.black87,
                            child: Center(
                              child: Text(
                                enteredPassphraseArray != null
                                    ? enteredPassphraseArray.toString()
                                    : '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87),
                              ),
                            ))),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 190,
                      width: screenWidth,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 3.0,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          padding: const EdgeInsets.all(1.0),
                          children:
                              List.generate(passphraseArray.length, (index) {
                            _MnemonicObject element = passphraseArray[index];
                            return ElevatedButton(
                              key: ValueKey(element),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                backgroundColor:
                                    enteredPassphraseArray.contains(element)
                                        ? Color.fromRGBO(
                                            211, 211, 211, 1) //0,50,254
                                        : Color.fromRGBO(255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (!enteredPassphraseArray
                                      .contains(element)) {
                                    enteredPassphraseArray.add(element);
                                  } else {
                                    enteredPassphraseArray.remove(element);
                                  }
                                  // passphraseCT.text = enteredPassphraseArray.toString();
                                  passphraseCT =
                                      enteredPassphraseArray.toString();
                                });
                              },
                              child: Container(child: Text(element.element)),
                            );
                          })),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Visibility(
                    //   visible: !isNextButtonVisible,
                    //   child: Container(
                    //     padding: EdgeInsets.only(left: 30, right: 30),
                    //     child: GestureDetector(
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10),
                    //           color: Colors.blue,
                    //         ),
                    //         child: Center(
                    //           child: Text("Clear Mnemonic",
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 18,
                    //                   fontWeight: FontWeight.bold)),
                    //         ),
                    //       ),
                    //       onTap: () {
                    //         onClickClearButton();
                    //       },
                    //     ),
                    //   ),
                    //   // MaterialButton(
                    //   //     onPressed: onClickClearButton,
                    //   //     child: Text("Clear")
                    //   // )
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: !isNextButtonVisible,
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.NEW_MAIN_COLOR_SCHEME,
                            ),
                            child: Center(
                              child: Text("Verify Backup",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          onTap: () {
                            onClickVerifyButton();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isNextButtonVisible,
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
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
                            onClickNextButton();
                          },
                        ),
                      ),
                    )
                    // MaterialButton(
                    //     onPressed: onClickNextButton, child: Text("Next")))
                  ]),
            ),
          ),
          LoadingScreen(
              inAsyncCall: isLoading, mesage: "Loading", dismissible: false)
        ]));
  }
}
