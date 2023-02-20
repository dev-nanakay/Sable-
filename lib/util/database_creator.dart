import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? db;

class DatabaseCreator {
  static const userTable = 'users';
  static const id = '_id';
  static const dbid = 'dbid';
  static const userAccessToken = 'userAccessToken';
  static const name = 'name';
  static const description = 'description';
  static const email = 'email';
  static const phoneNumber = 'phoneNumber';
  static const photo = 'photo';
  static const country = 'country';
  static const walletAddress = 'walletAddress';
  static const facebook_link = 'facebook_link';
  static const twitter_link = 'twitter_link';
  static const instagram_link = 'instagram_link';
  static const linkedin_link = 'linkedin_link';
  static const enabledChat = 'enabledChat';
  static const privateKey = 'privateKey';
  static const publicKey = 'publicKey';
  static const username = 'username';
  static const pin = 'pin';
  static const mnemonic = "mnemonic";
  static const incorrectAttemptsTime = "incorrectAttemptsTime";
  static const incorrectAttempts = "incorrectAttempts";
  static const referralCode = "referralCode";
  static const phoneNumberVerified = "phoneNumberVerified";
  static const emailVerified = "emailVerified";

  static const transactionsTable = 'transactions';
  static const blockNumber = "blockNumber";
  static const timeStamp = 'timeStamp';
  static const hash = 'hash';
  static const nonce = 'nonce';
  static const blockHash = 'blockHash';
  static const from = 'fromuser';
  static const contractAddress = 'contractAddress';
  static const to = 'touser';
  static const value = 'value';
  static const tokenName = 'tokenName';
  static const tokenSymbol = 'tokenSymbol';
  static const tokenDecimal = 'tokenDecimal';
  static const transactionIndex = 'transactionIndex';
  static const gas = 'gas';
  static const gasPrice = 'gasPrice';
  static const gasUsed = 'gasUsed';
  static const cumulativeGasUsed = 'cumulativeGasUsed';
  static const input = 'input';
  static const confirmations = 'confirmations';
  static const type = 'type';

  Future<void> createUserTable(Database db) async {
    final userSql = '''CREATE TABLE $userTable
    (
       $id TEXT,
       $dbid TEXT PRIMARY KEY,
       $userAccessToken TEXT,
       $name TEXT,
       $description TEXT,
       $email TEXT,
       $phoneNumber TEXT,
       $photo TEXT,
       $country TEXT,
       $walletAddress TEXT,
       $facebook_link TEXT,
       $twitter_link TEXT,
       $instagram_link TEXT,
       $linkedin_link TEXT,
       $enabledChat TEXT,
       $privateKey TEXT,
       $publicKey TEXT,
       $username TEXT,
       $pin TEXT,
       $mnemonic TEXT,
       $incorrectAttemptsTime TEXT,
       $incorrectAttempts TEXT,
       $referralCode TEXT,
       $phoneNumberVerified TEXT,
       $emailVerified TEXT
    )''';

    await db.execute(userSql);
  }

  Future<void> createTransactionsTable(Database db) async {
    final transactionSql = '''CREATE TABLE $transactionsTable
    (
      $hash TEXT,
      $timeStamp TEXT,
      $blockNumber TEXT,
      $nonce TEXT,
      $blockHash TEXT,
      $from TEXT,
      $contractAddress TEXT,
      $to TEXT,
      $value TEXT,
      $tokenName TEXT,
      $tokenSymbol TEXT,
      $tokenDecimal TEXT,  
      $transactionIndex TEXT,
      $gas TEXT,
      $gasPrice TEXT,
      $gasUsed TEXT,
      $cumulativeGasUsed TEXT,
      $input TEXT,
      $confirmations TEXT,
      $type TEXT
    )''';

    await db.execute(transactionSql);
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (!await Directory(dirname(path)).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('sable_db.db');
    db = await openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future<void> onCreate(Database db, int version) async {
    await createUserTable(db);
    await createTransactionsTable(db);
  }

// For Database operations
  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult = const [],
      int? insertAndUpdateQueryResult,
      List<dynamic> params = const []]) {
    print(functionName);
    print(sql);
    if (params != []) {
      print(params);
    }
    if (selectQueryResult != []) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }
}
