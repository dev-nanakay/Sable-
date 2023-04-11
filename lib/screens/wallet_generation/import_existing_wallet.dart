import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/client/user_client.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/util/eth_util.dart';
import 'package:sac_wallet/util/keyboard.dart';
import 'package:sac_wallet/widget/loading.dart';

import '../pin/create_pin.dart';

class ImportExistingWallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImportExistingWalletPageState();
}

class _ImportExistingWalletPageState extends State<ImportExistingWallet> {
  late TextEditingController passphrase;

  // Show/Hide the visibility of generate button
  bool isGenerateVisible = true;
  bool isLoading = false;

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  // Goto verification Step
  void clickNextButton() async {
    KeyBoardFunctions.hideKeyBoard(context);
    try {
      setLoading(true);
      String validationError = EthUtil.verifyMnemonic(passphrase.text);

      if (validationError != null) {
        Fluttertoast.showToast(msg: validationError);
      } else {
        String privateKey = EthUtil.generatePrivateKey(passphrase.text);
        String walletAddress = await EthUtil.generateWalletAddress(privateKey);

        UserRepository userRepository = new UserRepository();
        await UserClient()
            .updateWalletAddressOnServer(walletAddress: walletAddress);
        await userRepository.addPrivateKey(privateKey: privateKey);
        await userRepository.addWalletAddress(walletAddress: walletAddress);
        await userRepository.updateMnemonic(
            mnemonicText: passphrase.text.trim());

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreatePin()));
      }
    } catch (Exception) {
      Fluttertoast.showToast(msg: "Error importing wallet");
    } finally {
      setLoading(false);
    }
  }

  @override
  void initState() {
    super.initState();
    passphrase = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Restore Wallet", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(/* overflow: Overflow.visible, */ children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Enter your secret twelve words phrase here to restore your wallet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Card(
                      child: Center(
                          child: TextField(
                    controller: passphrase,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ))),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
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
                        child: Text("Restore Wallet",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    onTap: () {
                      clickNextButton();
                    },
                  ),
                ),
              ],
            ),
          ),
          LoadingScreen(
              inAsyncCall: isLoading, mesage: "Loading", dismissible: false),
        ]));
  }
}
