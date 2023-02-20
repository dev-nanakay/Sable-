import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/wallet_generation/backup_phrase.dart';
import 'package:sac_wallet/screens/wallet_generation/import_existing_wallet.dart';

class CreateImportWallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateImportWalletPageState();
}

class _CreateImportWalletPageState extends State<CreateImportWallet> {
  // Import key from a keyphrase
  void clickImportButton() {
    // TODO: redirect to the import wallet page
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ImportExistingWallet()));
  }

  // Create a new keyphrase
  void clickCreateWalletButton() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BackUpPhrase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(/* overflow: Overflow.visible, */ children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "If you have seed phrase from a different wallet provider and you would like to restore your assets, please select “Restore Wallet”. Otherwise, select “Create New Wallet”.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
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
                              child: Text("Create New Wallet",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          onTap: () {
                            clickCreateWalletButton();
                          },
                        )),
                    SizedBox(
                      height: 15,
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
                            clickImportButton();
                          },
                        )),
                  ]))
        ]));
  }
}
