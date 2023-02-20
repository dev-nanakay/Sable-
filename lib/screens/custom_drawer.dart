import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:sac_wallet/screens/contact_us.dart';
import 'package:sac_wallet/screens/pin/verify_pin.dart';
import 'package:sac_wallet/screens/wallet_info.dart';
import 'package:sac_wallet/util/api_config.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String versionString = "";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/home_background.jpg"),
                        fit: BoxFit.cover)),
                child: Image.asset("assets/images/nav_header_image.png"),
              ),
              Platform.isAndroid
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 1))),
                      child: _sideMenuRow(
                          context, "Lock", Icon(Icons.lock, size: 32.0), () {
                        SystemNavigator.pop();
                      }),
                    )
                  : Container(),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1))),
                child: _sideMenuRow(
                    context,
                    "Key Backup",
                    Icon(
                      Icons.text_fields,
                      size: 32.0,
                    ), () async {
                  String result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => VerifyPin(
                              onDone: "RETURN",
                            )),
                  );
                  print(result);
                  if (result != true) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => WalletInfo()));
                  }
                }),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1))),
                child: _sideMenuRow(
                    context, "Contact us", Icon(Icons.people, size: 32.0), () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContactUs()));
                }),
              ),
              SizedBox(height: 25),
              Container(
                // decoration: BoxDecoration(
                //     border:
                //         Border(top: BorderSide(color: Colors.grey, width: 1))),
                // Border(top: BorderSide(color: Colors.grey, width: 1))),
                child: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(child: Text(versionString)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sideMenuRow(BuildContext context, String title, Icon icon,
      Function() function) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: function,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String currentNet = ApiConfig.getConfig().ETHEREUM_NET == "api"
          ? "MAINNET"
          : ApiConfig.getConfig().ETHEREUM_NET.toUpperCase();
      setState(() {
        versionString =
            "${packageInfo.appName} ${packageInfo.version} (${packageInfo.buildNumber}) - ${currentNet}";
      });
    });
  }
}
