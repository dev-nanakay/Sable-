import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/transactions_model.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/ethereum_repository.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/widget/transactions/TransactionHistory.dart';

class TransactionsPage extends StatefulWidget {
  TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  User? currentUser;

  late Future<List<TransactionsModel>> transactions;

  @override
  void initState() {
    currentUser = GlobalValue.getCurrentUser;
    print(currentUser!.walletAddress);
    transactions = EthereumRepository()
        .getTransactionHistoryfromDB(address: currentUser!.walletAddress!);
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
            title: Text("Transactions", style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
                child: Column(
              children: <Widget>[
                /* Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20),
                        child: Text("Transaction History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),),
                      ),*/
                FutureBuilder<List<TransactionsModel>>(
                    future: transactions,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TransactionsModel>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text(' none ');
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return new Center(
                            child: new CircularProgressIndicator(),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          return Container(
                            padding: EdgeInsets.all(0),
                            child: Container(
                                child: TransactionHistory(snapshot.data!)),
                          );
                      }
                     // return null;
                    }),
              ],
            )),
          )),
    );
  }
}
