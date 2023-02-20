import 'package:meta/meta.dart';
import 'package:sac_wallet/model/business.dart';
import 'package:sac_wallet/model/user.dart';

import '../client/user_client.dart';

class UserRepository {
  final UserClient userClient = new UserClient();

  Future<bool> register(
          {required String name,
          required String username,
          required String email,
          required String phoneNumber,
          required String password}) async =>
      await userClient.register(
          name: name,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          password: password);

  Future<bool> login(
          {required String email, required String password}) async =>
      await userClient.login(email: email, password: password);

  Future<bool> addPin({required String pin}) async =>
      userClient.addPin(pin: pin);

  Future<bool> addPrivateKey({required String privateKey}) async =>
      await userClient.addPrivateKey(privateKey: privateKey);

  Future<bool> addWalletAddress({required String walletAddress}) async =>
      await userClient.addWalletAddress(walletAddress: walletAddress);

  Future<bool> updateMnemonic({required String mnemonicText}) async =>
      await userClient.updateMnemonic(mnemonicText: mnemonicText);

  Future<bool> updateIncorrectAttempt(
          {required int attempts, required String time}) async =>
      await userClient.updateIncorrectAttempts(attempts: attempts, time: time);

  Future<bool> updatePhoneVerificationStatus() async =>
      await userClient.updatePhoneVerificationStatus();

  Future<bool> incrementIncorrectAttempt() async =>
      await userClient.incrementIncorrectAttempts();

  Future<User?> getUser() async => await userClient.getUser();

  Future<bool> verifyPin({required String pin}) async =>
      await userClient.verifyPin(pin: pin);

  Future<bool> getOTP() async => await userClient.getOTP();

  Future<bool> verifyPhoneNumber({required String otp}) async =>
      await userClient.verifyPhoneNumber(otp: otp);

  Future<String> checkReferralCode({required String referralCode}) async =>
      await userClient.checkReferralCode(referralCode: referralCode);

  Future<String> checkReferralStatus() async =>
      await userClient.checkReferralStatus();

  Future<String> getAllReferral({required String referralCode}) async =>
      await userClient.getAllReferral(referralCode: referralCode);

  Future<String> addReferral(
          {required String referralCode, required String email}) async =>
      await userClient.addReferral(referralCode: referralCode, email: email);

  Future<String> contactUs(
          {required String subject, required String message}) async =>
      await userClient.contactUs(subject: subject, message: message);

  Future<List<User>> getUsers() async => await userClient.getUsers();

  Future<List<Business>> getBusiness() async => userClient.getBusiness();

  Future<List<String>> getCategories() async => userClient.getCategories();

  Future<bool> addBusiness({required Business business}) async =>
      userClient.addBusiness(business);

// Future<String> uploadPhoto({required String uid, File imgFile}) async => await userClient.uploadPhoto(uid: uid, imgFile: imgFile);

}
