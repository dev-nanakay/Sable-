import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/transactions_model.dart';
import 'package:sac_wallet/screens/wallet/send_token_page.dart';
import 'package:sac_wallet/widget/transactions/TransactionList.dart';

class TransactionHistory extends StatelessWidget {
  final List<TransactionsModel> transactions;

  TransactionHistory(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TransactionList(transactions),
          SizedBox(
            height: 10,
          ),
          transactions.length == 0
              ? Container(
                  child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "No Transactions",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/no_transactions.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.NEW_MAIN_COLOR_SCHEME,
                          ),
                          child: Center(
                            child: Text("Send Token",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SendTokenPage()));
                        },
                      ),
                    )
                  ],
                ))
              : SizedBox(
                  height: 30,
                )
        ],
      ),
    );
  }
}
