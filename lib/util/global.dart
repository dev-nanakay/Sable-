import '../model/user.dart';

class GlobalValue {
  static User? user;
  static String? privateKey;

  static set setCurrentUser(User user) {
    GlobalValue.user = user;
  }

  static User get getCurrentUser => GlobalValue.user!;

  static set setPrivateKey(String key) {
    GlobalValue.privateKey = key;
  }
  static String get getPrivateKey => GlobalValue.privateKey!;
}