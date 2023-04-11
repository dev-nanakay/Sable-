import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/util/database_creator.dart';

class RepositoryServiceUser {
  static Future<User?> getUser() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.userTable}''';

    final data = await db!.rawQuery(sql);
    if (data.length > 0) {
      return User.fromJson(data.first);
    } else {
      return null;
    }
  }

  static Future<void> addUser(User user) async {
    print(user.dbid);
    await db!.delete(DatabaseCreator.userTable,
        where: "${DatabaseCreator.dbid} = 1");
    await db!.insert(
      DatabaseCreator.userTable,
      user.toJson(),
    );
  }

  static Future<void> deleteUser(User user) async {
    final sql = '''DELETE FROM ${DatabaseCreator.userTable}
    WHERE ${DatabaseCreator.dbid} = ?
    ''';

    List<dynamic> params = [user.dbid];
    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete user', sql,);
  }

  static Future<int> usersCount() async {
    final List<Map<String, dynamic>> data = await db!
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.userTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

  static Future<bool> updatePin(User user, String pin) async {
    final sql = '''
    UPDATE ${DatabaseCreator.userTable}
      SET ${DatabaseCreator.pin} = ?
      WHERE ${DatabaseCreator.dbid} = ?
    ''';
    List<dynamic> params = [pin, user.dbid];

    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update Pin', sql);
    return result > 0;
  }

  static Future<bool> verifyPin(User user, String pin) async {
    final sql = '''
    SELECT ${DatabaseCreator.pin} from ${DatabaseCreator.userTable}
      WHERE ${DatabaseCreator.dbid}
    ''';
    List<dynamic> params = [user.dbid];

    final result = await db!.rawQuery(sql, params);
    print(result);

    final currentUserMap = result[0];

    if (currentUserMap.containsKey(DatabaseCreator.pin)) {
      if (currentUserMap[DatabaseCreator.pin] == pin) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> updatePrivateKey(User user, String privateKey) async {
    final sql = '''
    UPDATE ${DatabaseCreator.userTable}
      SET ${DatabaseCreator.privateKey} = ?
      WHERE ${DatabaseCreator.dbid} = ?
    ''';
    List<dynamic> params = [privateKey, user.dbid];

    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog(
        'Update Private key', sql);
    return result > 0;
  }

  static Future<bool> updateMnemonic(User user, String mnemonicText) async {
    final sql = '''
    UPDATE ${DatabaseCreator.userTable}
      SET ${DatabaseCreator.mnemonic} = ?
      WHERE ${DatabaseCreator.dbid} = ?
    ''';
    List<dynamic> params = [mnemonicText, user.dbid];

    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update Mnemonic', sql);
    return result > 0;
  }

  static Future<bool> updateWalletAddress(
      User user, String walletAddress) async {
    final sql = '''
    UPDATE ${DatabaseCreator.userTable}
      SET ${DatabaseCreator.walletAddress} = ?
      WHERE ${DatabaseCreator.dbid} = ?
    ''';
    List<dynamic> params = [walletAddress, user.dbid];

    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog(
        'Update Wallet Address', sql);
    return result > 0;
  }

  static Future<bool> updateIncorrectAttempt(
      User user, int number, String time) async {
    final sql = '''
    UPDATE ${DatabaseCreator.userTable}
      SET ${DatabaseCreator.incorrectAttempts} = ?,
      ${DatabaseCreator.incorrectAttemptsTime} = ?
      WHERE ${DatabaseCreator.dbid} = ?
    ''';
    List<dynamic> params = [number, time, user.dbid];

    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog(
        'Update Incorrect Attempt', sql);
    return result > 0;
  }

  static Future<bool> incrementIncorrectAttempts(User user, String time) async {
    return updateIncorrectAttempt(
        user,
        user.incorrectAttempts != null
            ? (int.tryParse(user.incorrectAttempts!) ?? 0) + 1
            : 1,
        time);
  }

  static Future<bool> updatePhoneVerificationStatus(
      User user, String status) async {
    final sql = '''
    UPDATE ${DatabaseCreator.userTable}
      SET ${DatabaseCreator.phoneNumberVerified} = ?
      WHERE ${DatabaseCreator.dbid} = ?
    ''';
    List<dynamic> params = [status, user.dbid];

    final result = await db!.rawUpdate(sql, params);

    DatabaseCreator.databaseLog(
        'Update Phone Verification Status', sql);
    return result > 0;
  }
}
