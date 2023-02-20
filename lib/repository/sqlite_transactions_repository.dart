import 'package:sac_wallet/model/transactions_model.dart';
import 'package:sac_wallet/util/database_creator.dart';

class RepositoryServiceTransaction {
  static Future<List<TransactionsModel>> getAllTransactions() async {
    final sql =
        '''SELECT * FROM ${DatabaseCreator.transactionsTable} ORDER BY ${DatabaseCreator.timeStamp} DESC''';
    final List<Map<String, dynamic>> maps = await db!.rawQuery(sql);

    // Convert the List<Map<String, dynamic> into a List<TransactionsModel>.
    return List.generate(maps.length, (i) {
      return TransactionsModel(
          hash: maps[i]["hash"],
          timeStamp: maps[i]['timeStamp'],
          blockNumber: maps[i]['blockNumber'],
          nonce: maps[i]["nonce"],
          blockHash: maps[i]["blockHash"],
          from: maps[i]["fromuser"],
          contractAddress: maps[i]["contractAddress"],
          to: maps[i]["touser"],
          value: maps[i]["value"],
          tokenName: maps[i]["tokenName"],
          tokenSymbol: maps[i]["tokenSymbol"],
          tokenDecimal: maps[i]["tokenDecimal"],
          transactionIndex: maps[i]["transactionIndex"],
          gas: maps[i]["gas"],
          gasPrice: maps[i]["gasPrice"],
          gasUsed: maps[i]["gasUsed"],
          cumulativeGasUsed: maps[i]["cumulativeGasUsed"],
          input: maps[i]["input"],
          confirmations: maps[i]["confirmations"],
          type: maps[i]["type"]);
    });
  }

  static Future<TransactionsModel> getTransaction(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.transactionsTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db!.rawQuery(sql, params);

    final transaction = TransactionsModel.fromJSON(data.first);
    return transaction;
  }

  static Future<void> addTransaction(TransactionsModel transaction) async {
    await db!.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  static Future<void> addTransaction2(TransactionsModel transaction) async {
    final sql = '''INSERT INTO ${DatabaseCreator.transactionsTable} 
    VALUES ( ${transaction.hash}, ${transaction.timeStamp},${transaction.blockNumber}, ${transaction.nonce}, ${transaction.blockHash}, ${transaction.from},
    ${transaction.contractAddress}, ${transaction.to}, ${transaction.value}, ${transaction.tokenName}, ${transaction.tokenSymbol}, ${transaction.tokenDecimal},
    ${transaction.transactionIndex}, ${transaction.gas}, ${transaction.gasPrice}, ${transaction.gasUsed}, ${transaction.cumulativeGasUsed}, ${transaction.input}, ${transaction.confirmations})''';

    await db!.rawQuery(sql);
  }

  static Future<void> deleteTransaction(TransactionsModel transaction) async {
    final sql = '''DELETE FROM ${DatabaseCreator.transactionsTable}
    WHERE ${DatabaseCreator.blockNumber} = ?
    ''';

    List<dynamic> params = [transaction.blockNumber];
    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog(
        'Delete transaction $result', sql);
  }

  static Future<void> updateTransaction(TransactionsModel transaction) async {
    final sql = '''UPDATE ${DatabaseCreator.transactionsTable}
    SET ${DatabaseCreator.tokenName} = ?
    WHERE ${DatabaseCreator.blockNumber} = ?
    ''';

    List<dynamic> params = [transaction.tokenName, transaction.blockNumber];
    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog(
        'Update transaction', sql);
  }

  static Future<int> transactionsCount() async {
    final List<Map<String, dynamic>> data = await db!.rawQuery(
        '''SELECT COUNT(*) FROM ${DatabaseCreator.transactionsTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

  static Future<void> deleteAllTransaction() async {
    final sql = '''DELETE FROM ${DatabaseCreator.transactionsTable}''';

    final result = await db!.rawUpdate(sql);

    DatabaseCreator.databaseLog(
      'Delete transaction',
      sql,
      
    );
  }
}
