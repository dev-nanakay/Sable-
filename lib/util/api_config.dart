import 'package:flutter/cupertino.dart';

class ApiConfig {
  static ApiConfig? staticConfig;

  static ApiConfig getConfig() {
    return staticConfig!;
  }

  String BASE_URL;
  String ETHEREUM_NET;
  String? REGISTRATION_URL;
  String? LOGIN_URL;
  String? USER_RESET_PASSWORD;
  String? USER_NEW_PASSWORD;

  String? GET_OTP;

  String? VERIFY_OTP;

  String? ADD_WALLET_ADDRESS;

  String? CHECK_REFERRAL_CODE;

  String? ADD_REFERRAL;

  String? GET_ALL_REFERRAL;

  String? CHECK_REFERRAL_STATUS;

  String? CONTACT_US;

  String? GET_ALL_USERS;

  String? CHECK_USERNAME;

  String? GET_ALL_BUSINESS;

  String? GET_MY_BUSINESS;

  String? GET_ALL_BUSINESS_NEAR_ME;

  String? GET_USER_BY_ID;

  String? GET_CATEGORIES;

  String? ADD_BUSINESS;

  String? CONTRACT_ADDRESS;

  String? EXCHANGE_RATE_API;

  String? ETHEREUM_ROPSTER_BASE_URL;

  String? ETHERSCAN_API_KEY;

  String? ETHERLESS_TRANSFER;

  String? FEES_API;

  String? NONCE_API;

  String? FILES_BASE;

  String? kGoogleApiKey;

  Map<String, String> headers = const {};

  ApiConfig(
      {required this.BASE_URL,
      required this.ETHEREUM_NET,
      required this.CONTRACT_ADDRESS,
      required this.kGoogleApiKey,
      required this.ETHERSCAN_API_KEY}) {
    if (staticConfig != null) {
      throw Exception("Multiple config initialization");
    }

    REGISTRATION_URL = "${BASE_URL}userCreate";

    LOGIN_URL = "${BASE_URL}userLogin";
    USER_RESET_PASSWORD = "${BASE_URL}userResetPassword";
    USER_NEW_PASSWORD = "${BASE_URL}userNewPassword";
    GET_OTP = "${BASE_URL}sendOTP";
    VERIFY_OTP = "${BASE_URL}verifyOTP";
    ADD_WALLET_ADDRESS = "${BASE_URL}addWalletAddress";
    CHECK_REFERRAL_CODE = "${BASE_URL}checkReferralCode";
    ADD_REFERRAL = "${BASE_URL}addReferral";
    GET_ALL_REFERRAL = "${BASE_URL}getAllReferrals";
    CHECK_REFERRAL_STATUS = "${BASE_URL}referralStatusUpdate";
    CONTACT_US = "${BASE_URL}contactUs";
    GET_ALL_USERS = "${BASE_URL}getAllUsers";
    CHECK_USERNAME = "${BASE_URL}checkUsername";
    GET_ALL_BUSINESS = "${BASE_URL}business/find";
    GET_MY_BUSINESS = "${BASE_URL}business/getMyBusiness";
    GET_ALL_BUSINESS_NEAR_ME = "${BASE_URL}business/nearMe";
    GET_USER_BY_ID = "${BASE_URL}getUserById";
    GET_CATEGORIES = "${BASE_URL}business/getCategories";
    ADD_BUSINESS = "${BASE_URL}business/create";

    headers = {'Content-Type': 'application/json'};

    EXCHANGE_RATE_API = "${BASE_URL}converter?from=SAC1&to=USD";

    // Ethereum Ropston URL's
    ETHEREUM_ROPSTER_BASE_URL = "https://${ETHEREUM_NET}.etherscan.io";

    ETHERLESS_TRANSFER = '${BASE_URL}transferEtherless';

    FEES_API = '${BASE_URL}fees';
    NONCE_API = '${BASE_URL}nonce';

    FILES_BASE = '${BASE_URL}files';

    // Init static config for use by others
    staticConfig = this;
  }
}
