import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/util/global.dart';

class KeyBackup extends StatefulWidget {
  _KeyBackupPage createState() => _KeyBackupPage();
}

class _KeyBackupPage extends State<KeyBackup> {
  User currentUser = GlobalValue.getCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Private Keys", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                    height: 150,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Card(
                        // borderOnForeground: true,
                        shadowColor: Colors.black87,
                        child: Center(
                          child: Text(
                            currentUser.mnemonic != null
                                ? currentUser.mnemonic!
                                : 'Private Keys',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87),
                          ),
                        ))),
              ]),
        ));
  }
}
