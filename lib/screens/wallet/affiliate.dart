import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:share_plus/share_plus.dart';

class Affiliate extends StatefulWidget {
  @override
  _AffiliateState createState() => _AffiliateState();
}

class _AffiliateState extends State<Affiliate> {
  var referrals;
  User? currentUser;

  share(BuildContext context) {
    final RenderBox box = context.findAncestorRenderObjectOfType()!;
    Share.share(
        "Earn Rewards on User signing in with Referral Code and Verifying Phone Number!! Your Referral Code is ${currentUser!.referralCode}",
        subject: "SAC1 Wallet App Referral",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  getReferrals() async {
    var referralsResponse = await UserRepository()
        .getAllReferral(referralCode: currentUser!.referralCode);
    setState(() {
      referrals = referralsResponse;
    });
  }

  checkReferralStatus() async {
    String response = await UserRepository().checkReferralStatus();
  }

  @override
  void initState() {
    super.initState();
    currentUser = GlobalValue.getCurrentUser;
    referrals = "0";
    getReferrals();
    checkReferralStatus();
  }

  @override
  Widget build(BuildContext context) {
    return PinLockWrapper(
      child: Scaffold(
        backgroundColor: AppColor.MAIN_BG,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Affiliate", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          height: 90,
                          child: Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Members Referred",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    referrals,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Container(
                          height: 90,
                          child: Card(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Rewards Earned",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Your Referral Code is " + currentUser!.referralCode,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
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
                        child: Text("Refer",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    onTap: () {
                      share(context);
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
