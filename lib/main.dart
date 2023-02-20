import 'package:flutter/material.dart';
import 'package:sac_wallet/app_config.dart';
import 'package:sac_wallet/util/api_config.dart';

import 'main_common.dart';

void main() {
  var configuredApp = AppConfig(
    config: ApiConfig(
        BASE_URL: "https://api.sablecoin.co/",
        ETHEREUM_NET: "api",
        CONTRACT_ADDRESS: "0x379f4b204AF5Ef9d1CE6A5fea8fdcd45bce02Aa9",
        kGoogleApiKey: "AIzaSyCGoZ8vILx_HjZ2ZaxRgl1IKrEN6MMy7lo",
        ETHERSCAN_API_KEY: "S6K3T35PJ29GS1QRJ3TSXP2QMPVZ4VBTXZ"),
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
