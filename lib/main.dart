import 'package:flutter/material.dart';
import 'package:sac_wallet/app_config.dart';
import 'package:sac_wallet/util/api_config.dart';

import 'main_common.dart';

// Response from http://sac-api-v1.us-east-1.elasticbeanstalk.com/userCreate - {"id":"6433e0216984462bc9d43b0e"} - Code: 200
// I/flutter ( 5987): Was registration successful ? true

void main() {
  var configuredApp = AppConfig(
    config: ApiConfig(
        BASE_URL: "http://sac-api-v1.us-east-1.elasticbeanstalk.com/",
        ETHEREUM_NET: "api",
        CONTRACT_ADDRESS: "0x379f4b204AF5Ef9d1CE6A5fea8fdcd45bce02Aa9",
        kGoogleApiKey: "AIzaSyCGoZ8vILx_HjZ2ZaxRgl1IKrEN6MMy7lo",
        ETHERSCAN_API_KEY: "S6K3T35PJ29GS1QRJ3TSXP2QMPVZ4VBTXZ"),
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
