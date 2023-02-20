import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:sac_wallet/exceptions/validation_exception.dart';
import 'package:sac_wallet/model/business.dart';
import 'package:sac_wallet/repository/sqlite_user_repository.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/util/APIRequestHelper.dart';
import 'package:sac_wallet/util/ResponseMap.dart';
import 'package:sac_wallet/util/api_config.dart';
import 'package:sac_wallet/util/database_creator.dart';
import 'package:sac_wallet/util/global.dart';

import '../model/user.dart';

class UserClient {
  UserClient() {
    dbInitialize();
  }

  dbInitialize() async {
    await DatabaseCreator().initDatabase();
  }

  Future<bool> register(
      {required String name,
      required String username,
      required String email,
      required String phoneNumber,
      required String password}) async {
    bool isRegistrationsuccessful = false;
    var requestBody = {
      'name': name,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };

    ResponseMap response = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().REGISTRATION_URL ?? '', jsonEncode(requestBody));

    if (response.responseCode == 200) {
      if (response.body != null) {
        isRegistrationsuccessful = true;
      }
    }
    return isRegistrationsuccessful;
  }

  Future<bool> login({required String email, required String password}) async {
    bool isLoginSuccessful = false;
    var requestBody = {'email': email, 'password': password};

    ResponseMap response = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().LOGIN_URL ?? '', jsonEncode(requestBody));

    if (response.responseCode == 200) {
      final resp = json.decode(response.body);
      final user = resp["user"];
      print(user["phoneNumberVerified"].runtimeType);
      final userAccessToken = resp["userAccessToken"];
      User currentUser = User.fromJson(user);
      currentUser.dbid = "1";
      currentUser.userAccessToken = userAccessToken;
      await RepositoryServiceUser.addUser(currentUser);
      GlobalValue.setCurrentUser = currentUser;
      print(GlobalValue.getCurrentUser.toString());
      isLoginSuccessful = true;
      print(currentUser.toString());
    } else {
      print("Login failed with response code: ${response.responseCode}");
    }
    return isLoginSuccessful;
  }

  Future<User?> getUser() async {
    User? currentUser = await RepositoryServiceUser.getUser();
    return currentUser;
  }

  Future<bool> addPin({required String pin}) async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result = await RepositoryServiceUser.updatePin(currentUser!, pin);
    return result;
  }

  Future<bool> verifyPin({required String pin}) async {
    User? currentUser = await RepositoryServiceUser.getUser();
    return pin == currentUser!.pin;
  }

  Future<bool> addPrivateKey({required String privateKey}) async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result =
        await RepositoryServiceUser.updatePrivateKey(currentUser!, privateKey);
    return result;
  }

  Future<bool> addWalletAddress({required String walletAddress}) async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result = await RepositoryServiceUser.updateWalletAddress(
        currentUser!, walletAddress);
    return result;
  }

  Future<bool> updateMnemonic({required String mnemonicText}) async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result =
        await RepositoryServiceUser.updateMnemonic(currentUser!, mnemonicText);
    return result;
  }

  Future<bool> updateIncorrectAttempts(
      {required int attempts, required String time}) async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result = await RepositoryServiceUser.updateIncorrectAttempt(
        currentUser!, attempts, time);
    return result;
  }

  Future<bool> incrementIncorrectAttempts() async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result = await RepositoryServiceUser.incrementIncorrectAttempts(
        currentUser!, DateTime.now().millisecondsSinceEpoch.toString());
    return result;
  }

  Future<bool> updatePhoneVerificationStatus() async {
    User? currentUser = await RepositoryServiceUser.getUser();
    bool result = await RepositoryServiceUser.updatePhoneVerificationStatus(
        currentUser!, "1");
    return result;
  }

//   Future<String> uploadPhoto({required String uid, File imgFile}) async {
//     StorageUploadTask task = photoRef.child(uid + ".jpg").putFile(imgFile);
//     await task.onComplete;
//     String downloadUrl = await photoRef.child(uid + ".jpg").getDownloadURL();
//     return downloadUrl;
//   }
  Future<bool> forgotPassword({required String email}) async {
    if (email == null) throw new Exception("Invalid email");
    var requestBody = {
      'email': email,
    };
    var body = json.encode(requestBody);
    ResponseMap responseMap = await APIRequestHelper()
        .doPostRequest(ApiConfig.getConfig().USER_RESET_PASSWORD!, body);
    if (responseMap.responseCode == 200) {
      return true;
    } else {
      throw new Exception("Request Failed: " + responseMap.error);
    }
  }

  Future<bool> setNewPasswordWithOTP(
      {required String email,
      required String otp,
      required String password,
      required String passwordConfirm}) async {
    if (email == null) throw new ValidationException("Invalid email");
    if (otp == null || otp.length != 6)
      throw new ValidationException("Invalid Verification Code");
    if (password != passwordConfirm)
      throw new ValidationException(
          "Password and confirm password do not match");
    var requestBody = {'email': email, 'otp': otp, 'newPassword': password};
    var body = json.encode(requestBody);
    ResponseMap responseMap = await APIRequestHelper()
        .doPostRequest(ApiConfig.getConfig().USER_NEW_PASSWORD!, body);
    if (responseMap.responseCode == 200) {
      return true;
    } else {
      throw new Exception("Request Failed: " + responseMap.error);
    }
  }

  Future<bool> updateWalletAddressOnServer(
      {required String walletAddress}) async {
    if (walletAddress == null)
      throw ValidationException("Invalid Wallet Address");
    var requestBody = {
      'walletAddress': walletAddress,
    };
    var body = json.encode(requestBody);
    User? currentUser = await UserRepository().getUser();
    ResponseMap responseMap = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().ADD_WALLET_ADDRESS!, body,
        authToken: currentUser!.userAccessToken);

    if (responseMap.responseCode == 200) {
      if (responseMap.body != null) {
        return true;
      }
    } else {
      throw Exception("Error: ${responseMap.error}");
    }
    return false;
  }

  Future<bool> getOTP() async {
    User? currentUser = await UserRepository().getUser() ;

    Map<String, String> requestBody = {"phoneNumber": currentUser!.phoneNumber};

    ResponseMap response = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().GET_OTP!, json.encode(requestBody),
        authToken: currentUser!.userAccessToken);

    if (response.responseCode == 200) {
      if (response.body != null) {
        return true;
      }
    } else {
      throw Exception("${response.body} ${response.responseCode}");
    }
    return false;
  }

  Future<bool> verifyPhoneNumber({required String otp}) async {
    if (otp == null)
      throw ValidationException("Verification code cannot be empty");
    User? currentUser = await UserRepository().getUser();

    var requestBody = {"phoneNumber": currentUser!.phoneNumber, "otp": otp};

    ResponseMap response = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().VERIFY_OTP!, json.encode(requestBody),
        authToken: currentUser!.userAccessToken);

    if (response.responseCode == 200) {
      if (response.body != null) {
        return true;
      }
    } else {
      throw Exception("${response.responseCode} ${response.body} ");
    }
    return false;
  }

  Future<String> checkReferralCode({required String referralCode}) async {
    var requestBody = {"referralCode": referralCode};

    http.Response response = await http.post(Uri.parse(
        ApiConfig.getConfig().CHECK_REFERRAL_CODE!.toLowerCase()),
        body: jsonEncode(requestBody),
        headers: {
          "Authorization": "",
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      if (response.body != null) {
        print(response.body);
        return response.body;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return response.body;
  }

  Future<String> addReferral(
      {required String referralCode, required String email}) async {
    var requestBody = {"toemail": email, "referralCode": referralCode};

    http.Response response = await http.post(Uri.parse(ApiConfig.getConfig().ADD_REFERRAL!.toLowerCase()),
        body: jsonEncode(requestBody),
        headers: {
          "Authorization": "",
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      if (response.body != null) {
        return response.body;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return response.body;
  }

  Future<String> getAllReferral({required String referralCode}) async {
    var requestBody = {"referralCode": referralCode};

    http.Response response = await http.post(Uri.parse(
        ApiConfig.getConfig().GET_ALL_REFERRAL.toString()),
        body: jsonEncode(requestBody),
        headers: {
          "Authorization": "",
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      if (response.body != null) {
        var referralsResponse = json.decode(response.body);
        return referralsResponse["referrals"];
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return jsonDecode(response.body);
  }

  Future<String> checkReferralStatus() async {
    User? currentUser = await UserRepository().getUser();
    var requestBody = {
      "toemail": currentUser!.email,
    };

    http.Response response = await http.post(Uri.parse(
        ApiConfig.getConfig().CHECK_REFERRAL_STATUS.toString()),
        body: jsonEncode(requestBody),
        headers: {
          "Authorization": "",
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      if (response.body != null) {
        return response.body;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return jsonDecode(response.body);
  }

  Future<String> contactUs(
      {required String subject, required String message}) async {
    User? currentUser = await UserRepository().getUser();
    var requestBody = {"contact_type": subject, "user_message": message};

    ResponseMap response = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().CONTACT_US!, json.encode(requestBody),
        authToken: currentUser!.userAccessToken);

    if (response.responseCode == 200) {
      if (response.body != null) {
        return response.body;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return response.body;
  }

  Future<List<User>> getUsers() async {
    User? currentUser = await UserRepository().getUser();
    var requestBody = {"email": currentUser!.email};
    http.Response response = await http.post(Uri.parse(
        ApiConfig.getConfig().GET_ALL_USERS.toString()),
        body: jsonEncode(requestBody),
        headers: {
          "Authorization": "Bearer " + currentUser.userAccessToken,
          "Content-Type": "application/json",
        });
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (response.body != null) {
        result = result["users"];
        List<User> users;
        List<dynamic> histories = result;
        users = histories.map((item) {
          return User.fromJson(item);
        }).toList();
        return users;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return [];
  }

  Future<bool> checkUsername(String username) async {
    Map<String, dynamic> requestBody = {"username": username};
    ResponseMap responseMap = await APIRequestHelper().doPostRequest(
        ApiConfig.getConfig().CHECK_USERNAME!, json.encode(requestBody));

    if (responseMap.responseCode == 200) {
      if (responseMap.body != null) {
        var response = json.decode(responseMap.body);

        bool userExists = response["userExists"];
        return userExists;
      }
    } else {
      throw new Exception("Error: ${responseMap.body}");
    }
    return true;
  }

  Future<List<Business>> getBusiness() async {
    User? currentUser = await UserRepository().getUser();
    List<Business> business = [];

    http.Response response =
        await http.get(Uri.parse(ApiConfig.getConfig().GET_ALL_BUSINESS.toString()), headers: {
      "Authorization": "Bearer " + currentUser!.userAccessToken,
      "Content-Type": "application/json",
    });
    print(response);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (response.body != null) {
//        result = result["business"];
        List<dynamic> histories = result;
        business = histories.map((item) {
          return Business.fromJson(item);
        }).toList();
        return business;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return business;
  }

  Future<List<Business>> getMyBusiness() async {
    User? currentUser = await UserRepository().getUser();
    List<Business> business = [];

    http.Response response =
        await http.get(Uri.parse(ApiConfig.getConfig().GET_ALL_BUSINESS.toString()), headers: {
      "Authorization": "Bearer " + currentUser!.userAccessToken,
      "Content-Type": "application/json",
    });
    print(response);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (response.body != null) {
//        result = result["business"];
        List<dynamic> histories = result;
        business = histories.map((item) {
          return Business.fromJson(item);
        }).toList();
        return business;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return business;
  }

  Future<List<Business>> getBusinessNearMe(
      {required double lat,
      required double long,
      double maxDistance = 1000}) async {
    User? currentUser = await UserRepository().getUser();
    List<Business> business = [];
    //if (maxDistance == null) maxDistance = 10000;

    final Map<String, String> queryParameters = {
      "latitude": lat.toString(),
      "longitude": long.toString(),
      "maxDistance": maxDistance.toString()
    };
    final uri = Uri(queryParameters: queryParameters);

    http.Response response = await http.get(Uri.parse(
        "${ApiConfig.getConfig().GET_ALL_BUSINESS_NEAR_ME}?${uri.query}"),
        headers: {
          "Authorization": "Bearer " + currentUser!.userAccessToken,
          "Content-Type": "application/json",
        });
    print(response);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (response.body != null) {
//        result = result["business"];
        List<dynamic> histories = result;
        business = histories.map((item) {
          return Business.fromJson(item);
        }).toList();
        return business;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return business;
  }

  Future<User> getUserById({required String userId}) async {
    User? currentUser = await UserRepository().getUser();
    late User user;
    if (userId == null) throw ValidationException("User id is empty");

    final Map<String, String> queryParameters = {"id": userId};
    final uri = Uri(queryParameters: queryParameters);

    http.Response response = await http
        .get(Uri.parse("${ApiConfig.getConfig().GET_USER_BY_ID}?${uri.query}"), headers: {
      "Authorization": "Bearer " + currentUser!.userAccessToken,
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (response.body != null) {
//        result = result["business"];
        user = User.fromJson(result);
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return user;
  }

  Future<List<String>> getCategories() async {
    User? currentUser = await UserRepository().getUser();

    http.Response response =
        await http.get(Uri.parse(ApiConfig.getConfig().GET_CATEGORIES.toString()), headers: {
      "Authorization": "Bearer " + currentUser!.userAccessToken,
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (response.body != null) {
        List<dynamic> histories = result;
        List<String> categories = histories.map((item) {
          return item as String;
        }).toList();
        return categories;
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
    return [];
  }

  Future<bool> addBusiness(Business business) async {
    User? currentUser = await UserRepository().getUser();
    var requestBody = {
      "name": business.name,
      "email": business.email,
      "phoneNumber": business.phoneNumber,
      "websiteUrl": business.websiteUrl,
      "address": {
        "houseNumber": "123",
        "streetName": "abc",
        "city": "cityName",
        "state": "CA",
        "country": "US",
        "zipCode": "11211"
      },
      "location": {
        "latitude": business.location!.coordinates[1],
        "longitude": business.location!.coordinates[0]
      },
      "category": business.category,
      "description": business.description,
      "foundationYear": business.foundationYear
    };

    http.Response response = await http.post(Uri.parse(ApiConfig.getConfig().ADD_BUSINESS.toString()),
        body: jsonEncode(requestBody),
        headers: {
          "Authorization": "Bearer " + currentUser!.userAccessToken,
          "Content-Type": "application/json",
        });
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error: ${response.body}");
    }
  }
}
