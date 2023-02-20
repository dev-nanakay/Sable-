import 'package:flutter/cupertino.dart';
import 'package:sac_wallet/client/ethereum_client.dart';
import 'package:sac_wallet/model/transactions_model.dart';

class EthereumRepository {
  final EthereumClient ethereumClient = new EthereumClient();

  Future<List<TransactionsModel>> getTransactionHistory(
          {required String address, int? limit}) async =>
      await ethereumClient.getTransactionHistory(address: address);

  Future<List<TransactionsModel>> getTransactionHistoryfromDB(
          {required String address}) async =>
      await ethereumClient.getTransactionHistoryfromDB(address: address);

  Future<String> getBalance({required String address}) async =>
      await ethereumClient.getBalance(address: address) ?? "";

  Future<bool> deleteAllTransactions() async =>
      await ethereumClient.deleteAllTransactions();
}
