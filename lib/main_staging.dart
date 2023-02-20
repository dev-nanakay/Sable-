import 'package:flutter/material.dart';
import 'package:sac_wallet/app_config.dart';
import 'package:sac_wallet/util/api_config.dart';

import 'main_common.dart';

void main() {
  var configuredApp = AppConfig(
    config: ApiConfig(
        BASE_URL: "https://stagingapi.sablecoin.co/",
//        BASE_URL: "http://10.0.2.2:3000/",
        ETHEREUM_NET: "ropsten",
        CONTRACT_ADDRESS: "0xab6bb09183f247b2f16fda5817bec80c3b849114",
        kGoogleApiKey: "AIzaSyCGoZ8vILx_HjZ2ZaxRgl1IKrEN6MMy7lo",
        ETHERSCAN_API_KEY: "S6K3T35PJ29GS1QRJ3TSXP2QMPVZ4VBTXZ"),
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}
