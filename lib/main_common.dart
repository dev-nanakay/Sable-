import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/create_import_wallet.dart';
import 'package:sac_wallet/screens/main_page.dart';
import 'package:sac_wallet/screens/pin/create_pin.dart';
import 'package:sac_wallet/screens/pin/verify_pin.dart';
import 'package:sac_wallet/screens/splash_screen.dart';
import 'package:sac_wallet/util/database_creator.dart';
import 'package:sac_wallet/util/global.dart';

//void main() => runApp(MyApp());

void mainCommon() {
  // Here would be background init code, if any
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  Future<User> getUser() async {
    await DatabaseCreator().initDatabase();
    return (await UserRepository().getUser())!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<User>(
          future: getUser(),
          builder: (BuildContext context, AsyncSnapshot<User> user) {
            if (user.connectionState != ConnectionState.done)
              return SplashScreen();
            if (user.hasData) {
              User model = user.data!;
              GlobalValue.setCurrentUser = model;
              // User is not logged in
              if (model.userAccessToken == null ||
                  model.userAccessToken == "") {
               // return OnBoardingScreen();
                return MainPage();
              }
              if ((model.privateKey == null || model.privateKey == "") ||
                  (model.walletAddress == null && model.walletAddress == "")) {
                // Either private key or wallet address is not available. Goto Create Wallet
                return CreateImportWallet();
              }
              if (model.pin == null || model.pin == "") {
                return CreatePin();
              }
              return VerifyPin(onDone: "MAIN");
            }
            if(user.hasError){
              print(user.error);
            }
            //return OnBoardingScreen();
            return MainPage();
          },
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
