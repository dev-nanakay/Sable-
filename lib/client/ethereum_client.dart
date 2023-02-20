import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sac_wallet/model/transactions_model.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/sqlite_transactions_repository.dart';
import 'package:sac_wallet/util/api_config.dart';
import 'package:sac_wallet/util/database_creator.dart';
import 'package:sac_wallet/util/global.dart';

class EthereumClient {
  EthereumClient() {
    dbInitialize();
  }

  late User user;

  dbInitialize() async {
    await DatabaseCreator().initDatabase();
    user = GlobalValue.getCurrentUser;
  }

  Future<List<TransactionsModel>> getTransactionHistory(
      {required String address}) async {
    // Getting block no of previous transaction
    String startBlock = '0';
    var AllTransactions =
        await RepositoryServiceTransaction.getAllTransactions();
    if (AllTransactions.length != 0) {
      startBlock = (int.parse(AllTransactions[0].blockNumber) + 1).toString();
    }

    //fetching new transactions
    String url =
        "${ApiConfig.getConfig().ETHEREUM_ROPSTER_BASE_URL}/api?module=account&action=tokentx&contractaddress=${ApiConfig.getConfig().CONTRACT_ADDRESS}&address=$address&startblock=$startBlock&endblock=999999999&sort=asc&apikey=${ApiConfig.getConfig().ETHERSCAN_API_KEY}";

    print(url);

    var response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body);

    if (result != null) {
      result = result["result"];
      List<TransactionsModel> transactions;
      List<dynamic> histories = result;
      transactions = histories.map((item) {
        TransactionsModel t = TransactionsModel.fromJSON(item);
        if (t.from == user.walletAddress) {
          if (t.to == ApiConfig.getConfig().CONTRACT_ADDRESS) {
            t.type = "Fees";
            return t;
          }
          t.type = "Send";
        } else if (t.to == user.walletAddress) {
          t.type = "Receive";
        }
        return t;
      }).toList();

      // Adding new transactions to local db
      for (int i = 0; i < transactions.length; i++) {
        await RepositoryServiceTransaction.addTransaction(transactions[i]);
      }
    }

    List<TransactionsModel> transactions =
        await RepositoryServiceTransaction.getAllTransactions();
    return transactions;
  }

  Future<List<TransactionsModel>> getTransactionHistoryfromDB(
      {required String address}) async {
    List<TransactionsModel> transactions =
        await RepositoryServiceTransaction.getAllTransactions();
    if (transactions.length == 0) {
      return getTransactionHistory(address: address);
    }
    print(transactions);
    return transactions;
  }

  Future<String?> getBalance({required String address}) async {
    //fetching balance
    String url = "${ApiConfig.getConfig().ETHEREUM_ROPSTER_BASE_URL}/api?module=account&action=tokenbalance&contractaddress=${ApiConfig.getConfig().CONTRACT_ADDRESS}&address=$address&tag=latest&apikey=${ApiConfig.getConfig().ETHERSCAN_API_KEY}";

    print(url);
    var response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body);

    if (result != null) {
      result = result["result"];
      return result;
    }
    return null;
  }

  Future<bool> deleteAllTransactions() async {
    await RepositoryServiceTransaction.deleteAllTransaction();
    if (await RepositoryServiceTransaction.transactionsCount() == 0) {
      return true;
    }
    return false;
  }
}
