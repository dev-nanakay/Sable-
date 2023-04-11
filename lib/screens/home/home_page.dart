import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/ethereum_repository.dart';
import 'package:sac_wallet/screens/transactions/transactions_page.dart';
import 'package:sac_wallet/screens/wallet/affiliate.dart';
import 'package:sac_wallet/screens/wallet/buy_token_page.dart';
import 'package:sac_wallet/screens/wallet/send_token_page.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/sactousd.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User currentUser = GlobalValue.getCurrentUser;
  String currentBalance = '';

  Timer? _timer;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void startTimer() async {
    EthereumRepository()
        .getBalance(address: currentUser.walletAddress!)
        .then((value) {
      setState(() {
        currentBalance = value;
      });
    });
    const oneSec = const Duration(seconds: 15);
    if (_timer == null || !_timer!.isActive) {
      _timer = new Timer.periodic(oneSec, (Timer timer) async {
        try {
          String value = await EthereumRepository()
              .getBalance(address: currentUser.walletAddress!);
          if (value != currentBalance) {
            setState(() {
              currentBalance = value;
            });
          }
        } catch (e) {}
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        child: new Stack(
          children: <Widget>[
            Container(
              child: Container(
                decoration: new BoxDecoration(
                    color: AppColor.NEW_MAIN_COLOR_SCHEME,
//                      gradient: LinearGradient(
//                          colors: AppColor.MAIN_COLOR_SCHEME
//                      ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    )),
                padding: EdgeInsets.all(20),
                height: (MediaQuery.of(context).size.height / 2.7) + 10,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        child: Text("Total Balance",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16.0)),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Center(child: Container(
                        child: Text(
                          currentBalance == null ? "...." :
                          /* "${FlutterMoneyFormatter(
                              amount: SACToUSD().SACToUSDConvert(
                                  currentBalance)).output.symbolOnLeft}", */
                          "${SACToUSD().SACToUSDConvert(
                                  currentBalance)}",
                          style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 0.5,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        "S@${currentUser.username}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        "${currentUser.email}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ),
                    //SizedBox(height: 35,)
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: (MediaQuery
                        .of(context)
                        .size
                        .height / 2.7) - 35),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _sectionCard(context, "assets/images/receive.png",
                            "Receive Token", BuyTokenPage()),
                        _sectionCard(context, "assets/images/send_token.png",
                            "Send Token", SendTokenPage()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _sectionCard(
                            context,
                            "assets/images/transaction_history.png",
                            "Transaction History",
                            TransactionsPage()),
                        _sectionCard(context, "assets/images/money.png",
                            "Affiliate", Affiliate()),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(BuildContext context, String imgPath, String title,
      widget) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget));
        },
        child: Container(
          width: 160,
          height: 160,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imgPath,
                  width: 60.0,
                ),
                SizedBox(height: 10,),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }
}
