import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/transactions_model.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:sac_wallet/util/sactousd.dart';
import 'package:sac_wallet/util/text_util.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDetails extends StatelessWidget {
  late TransactionsModel transaction, feesTransaction;
  List<TransactionsModel> transactions;

  TransactionDetails(this.transaction, this.transactions) {
    feesTransactionSetter();
  }

  feesTransactionSetter() {
    if (this.transaction.type == "Send") {
      for (int i = 0; i < this.transactions.length; i++) {
        if (transaction.hashCode == transactions[i].hashCode) {
          feesTransaction = transactions[i];
          print("Fees: " + feesTransaction.value.toString());

          break;
        }
      }
    }
  }

  String checksendReceiveTransaction(TransactionsModel transaction) {
    String transactionUser = '';
    if (transaction.type == 'Receive') {
      transactionUser = '${transaction.from}';
    } else {
      transactionUser = '${transaction.to}';
    }
    return transactionUser;
  }

  String feesOfTransaction(TransactionsModel transaction) {
    String transactionFees = '';
    if (transaction.type == 'Receive') {
      transactionFees = '${transaction.gasUsed}';
    } else {
      transactionFees = '${transaction.to}';
    }
    return transactionFees;
  }

  @override
  Widget build(BuildContext context) {
    return PinLockWrapper(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
            iconTheme: new IconThemeData(color: Colors.white),
            automaticallyImplyLeading: true,
            title: Text("Transaction Details",
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/images/correct.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Center(
                      child: Text(
                        'Success',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Center(
                      child: Text(
                        "\$" +
                            "${TextUtil().formatText(SACToUSD().SACToUSDConverttoString(transaction.value), 11)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Transaction type",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      transaction.type == 'Send'
                                          ? 'Sent'
                                          : 'Receive',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 0.5,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Date/Time ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  BigInt.parse(transaction
                                                              .timeStamp)
                                                          .toInt() *
                                                      1000))
                                          .toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 0.5,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Amount ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      "${TextUtil().formatText(SACValue().SACtoString(transaction.value), 11)}" +
                                          " SAC1",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 0.5,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 30,
                                  child: Text(
                                    transaction.type == 'Receive'
                                        ? 'From'
                                        : 'To',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 70,
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                          checksendReceiveTransaction(
                                              transaction),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 0.5,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Blockchain Tx ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      child: ElevatedButton(
                                    child: Text("Blockchain URL",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: AppColor.MAIN_COLOR_SCHEME,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal)),
                                    onPressed: () {
                                      launch("https://etherscan.io/tx/" +
                                          "${transaction.hash}");
                                    },
                                    style:
                                        ElevatedButton.styleFrom(elevation: 0),
                                  )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 0.5,
                              color: Colors.black12,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            transaction.type == 'Send' &&
                                    feesTransaction != null
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 30,
                                        child: Text(
                                          "Fees",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 70,
                                        child: Container(
                                          child: Text(
                                              "${SACValue().SACtoString(feesTransaction.value.toString())}" +
                                                  " SAC1",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                      )
                                    ],
                                  )
                                : transaction.type == 'Send'
                                    ? Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 30,
                                            child: Text(
                                              "Gas",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 70,
                                            child: Container(
                                              child: Text(
                                                  "GWEI " +
                                                      '${transaction.gas}',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            ),
                                          )
                                        ],
                                      )
                                    : Row(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
