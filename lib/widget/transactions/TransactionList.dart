import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sac_wallet/model/transactions_model.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/ethereum_repository.dart';
import 'package:sac_wallet/screens/transaction_details.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/sactousd.dart';
import 'package:sac_wallet/util/text_util.dart';

class TransactionList extends StatefulWidget {
  final List<TransactionsModel> transactions;

  TransactionList(this.transactions);

  @override
  State<StatefulWidget> createState() => _TransactionList();
}

class _TransactionList extends State<TransactionList> {
  List<TransactionsModel> transactions = const [], transactionsWithoutFees = const [];
  List<TransactionsModel> NewTransactions = const [];
  User currentUser = GlobalValue.getCurrentUser;
  double screenWidth = 10.0, screenHeight = 20.0;

  @override
  void initState() {
    super.initState();
    transactions = widget.transactions;
    transactionAssigner();
    newTransactionFetcher();
  }

  transactionAssigner() {
    print("No. of Transactions: " + transactions.length.toString());
    transactionsWithoutFees = transactions;
    for (int i = 0; i < transactionsWithoutFees.length; i++) {
      if (transactionsWithoutFees[i].type == "Fees") {
        transactionsWithoutFees.removeAt(i);
      }
    }
  }

  newTransactionFetcher() async {
    NewTransactions = await EthereumRepository()
        .getTransactionHistory(address: currentUser.walletAddress!);
    transactions = NewTransactions;
    transactionAssigner();
  }

  String checksendReceiveTransaction(TransactionsModel transaction) {
    String transactionUser = '';
    if (transaction.type == 'Receive') {
      transactionUser =
          'From: ${TextUtil().formatAddressText(transaction.from)}';
    } else {
      transactionUser = 'To: ${TextUtil().formatAddressText(transaction.to)}';
    }
    return transactionUser;
  }

  String checkAmountTransaction(TransactionsModel transaction) {
    String transactionAmount = '';
    if (transaction.type == 'Receive') {
      transactionAmount = "+\$" +
          "${TextUtil().formatText(SACToUSD().SACToUSDConverttoString(transaction.value), 10)}";
    } else {
      transactionAmount = "-\$" +
          "${TextUtil().formatText(SACToUSD().SACToUSDConverttoString(transaction.value), 10)}";
    }
    return transactionAmount;
  }
  

  Color checkColor(TransactionsModel transaction) {
    Color color = Colors.black;
    if (transaction.type == 'Receive') {
      color = Colors.green;
    } else {
      color = Colors.red;
    }
    return color;
  }
  // listOfBusiness(TransactionsModel transaction) {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       padding: EdgeInsets.only(bottom: 10.0),
  //       controller: scrollController,
  //       itemCount: transactionsWithoutFees.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return CardView(Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Row(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: <Widget>[
  //                 Image.asset(
  //                   "assets/images/app_icon.png",
  //                   height: 80,
  //                   width: 80,
  //                 ),
  //                 SizedBox(width: 10,),
  //                 Column(children: <Widget>[
  //                   Text(transaction.type),
  //                   SizedBox(height: 02.0,),
  //                   Text(transaction.type),
  //                   SizedBox(height: 02.0,),
  //                 ],)
  //               ],
  //             )
  //           ],
  //         ));
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
        child: Column(
            children: transactionsWithoutFees
                .map(
                  (transaction) => Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TransactionDetails(transaction, transactions)));
                      },
                      child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin:
                              EdgeInsets.only(left: 5.0, right: 5.0, top: 7),
                          child: ListTile(
                              leading: Image.asset(
                                "assets/images/app_icon.png",
                                height: 40,
                                width: 40,
                              ),
                              title: Text(
                                  checksendReceiveTransaction(transaction),
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.black)),
                              subtitle: Container(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  DateFormat('MM-dd-yyyy HH:mm')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              BigInt.parse(
                                                          transaction.timeStamp)
                                                      .toInt() *
                                                  1000))
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.only(top: 12.0),
                                child: Text(
                                  checkAmountTransaction(transaction),
                                  style: TextStyle(
                                      color: checkColor(transaction),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ))),
                    ),
                  ),
                )
                .toList())); // end of container
  }
}
