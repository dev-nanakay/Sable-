import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/wallet_generation/create_wallet.dart';
import 'package:sac_wallet/util/text_util.dart';
//import 'package:wallet_core/wallet_core.dart';

class BackUpPhrase extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BackUpPhrasePageState();
}

class _BackUpPhrasePageState extends State<BackUpPhrase> {
  String? mnemonicPhrase;

  void createMnemonicPassphrase() {
    String mnemonic = "r4545giomimrogmeroige"; //Web3.generateMnemonic();
    setState(() {
      mnemonicPhrase = mnemonic;
    });
  }

  void clickContinueButton() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateWallet(
              passphrase: mnemonicPhrase ?? "n/a",
            )));
  }

  @override
  void initState() {
    createMnemonicPassphrase();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text("Private Keys and Recovery",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(/* overflow: Overflow.visible, */ children: <Widget>[
        Container(
            child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                    height: 100,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                        // borderOnForeground: true,
                        shadowColor: Colors.black87,
                        child: Center(
                          child: Text(
                            "${mnemonicPhrase}",
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
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    TextUtil.INSTRUCTION1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: AppColor.NEW_MAIN_COLOR_SCHEME),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    TextUtil.INSTRUCTION2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: AppColor.NEW_MAIN_COLOR_SCHEME),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                // Container(
                //   padding: EdgeInsets.only(left: 20, right: 20),
                //   child: Text(
                //     TextUtil.INSTRUCTION3,
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //         color: AppColor.NEW_MAIN_COLOR_SCHEME),
                //   ),
                // ),
                SizedBox(height: 20),
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
                        child: Text("Continue",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    onTap: () {
                      clickContinueButton();
                    },
                  ),
                ),
              ]),
        ))
      ]),
    );
  }
}
