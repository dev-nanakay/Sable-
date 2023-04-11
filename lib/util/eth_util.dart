import 'dart:convert';
import 'dart:typed_data';

import 'package:charge_wallet_sdk/charge_wallet_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/util/validator.dart';
import 'package:web3dart/crypto.dart';
import 'api_config.dart';


class EthUtil {
  static final ETH_PREAMBLE = "\x19Ethereum Signed Message:\n32";

  static String generatePrivateKey(String text) {
    String privateKey = Web3.privateKeyFromMnemonic(text);
    return privateKey;
  }

  static Future<bool> approvalCallback() async {
    return true;
  }

  static Future<String> generateWalletAddress(String privateKey) async {
    // init web3 module
    Web3 web3 = new Web3();

    // set web3 credentials with private key
    await web3.setCredentials(privateKey);

    // get account address
    String accountAddress = await web3.getAddress();

    return accountAddress;
  }

  static String verifyMnemonic(String mnemonic) {
    List<String> passphraseSplit = mnemonic.trim().split(' ');
    if (passphraseSplit.length != 12) {
      return "Mnemonic should have 12 words";
    }
    return Validator.validateMnemonic(mnemonic) ?? '';
  }

  static String generateMnemonic() {
    return Web3.generateMnemonic();
  }

  static String padByZero(String value, int finalLength) {
    while (value.length < finalLength) {
      value = "0" + value;
    }
    return value;
  }

  static BigInt getBigIntForAmount(String amount,) {
    return BigInt.from((double.parse(amount) * 100000).truncate()) *
        BigInt.from(1e13);
  }

  /**
   * Example hash: //ab6bb09183f247b2f16fda5817bec80c3b849114
      //fee7e17105e8b4b8f7f005f1244e297d6273851d
      //80c32b275a8137b8d9af10bcebb5482f5aa25cac
      //000000000000000000000000000000000000000000000000016345785d8a0000
      //000000000000000000000000000000000000000000000000456aac7f8e810000
      //00000001
      //000000000000000000000000000000000000000000000000000000005f0dcb1c
   */
  static Future<String> doTransfer(User currentUser, String transferAmount,
      String recipientAddress) async {
    try {
      BigInt amount = getBigIntForAmount(transferAmount);

      Map obj = {};
      obj["token"] = ApiConfig.getConfig().CONTRACT_ADDRESS;
      obj["sender"] = currentUser.walletAddress;
      obj["receipient"] = recipientAddress.toLowerCase();
      obj["amount"] = amount.toString();
      http.Response feesResult = await http
          .get(Uri.parse('${ApiConfig.getConfig().FEES_API}?amount=' + obj["amount"]));
      var feesResponse = jsonDecode(feesResult.body);
      obj["fees"] = feesResponse["value"];
      http.Response nonceResult = await http
          .get(Uri.parse('${ApiConfig.getConfig().NONCE_API}?sender=' + obj["sender"]));
      var nonceResponse = jsonDecode(nonceResult.body);
      obj["nonce"] = nonceResponse["value"];
      obj["time"] = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();

      String message = '0x';
      message += padByZero(obj["token"].substring(2), 40);
      message += padByZero(obj["sender"].substring(2), 40);
      message += padByZero(obj["receipient"].substring(2), 40);
      message += padByZero(BigInt.parse(obj["amount"]).toRadixString(16), 64);
      message += padByZero(BigInt.parse(obj["fees"]).toRadixString(16), 64);
      message += padByZero(BigInt.parse(obj["nonce"]).toRadixString(16), 8);
      message +=
          padByZero(BigInt.parse(obj["time"].toString()).toRadixString(16), 64);

      Uint8List message2 = keccak256(hexToBytes(message));
      Uint8List message4 = Uint8List.fromList(utf8.encode(ETH_PREAMBLE));
      message4 = Uint8List.fromList(message4 + message2);
      Uint8List message5 = keccak256(message4);
      MsgSignature signature = sign(
          message5, hexToBytes(currentUser.privateKey!));

      obj["signature"] = "0x" +
          padByZero(signature.r.toRadixString(16), 64) +
          padByZero(signature.s.toRadixString(16), 64) +
          padByZero(signature.v.toRadixString(16), 2);
      http.Response response = await http.post(
          Uri.parse(ApiConfig.getConfig().ETHERLESS_TRANSFER.toString()),
          body: jsonEncode(obj),
          headers: {
            "Authorization": "",
            "Content-Type": "application/json",
          });
      String txHash = response.body;
      if (txHash == "Insufficient balance.") {
        throw InsufficientBalanceException();
      } else if (Validator.validateTransactionHash(txHash)) {
        return txHash;
      } else {
        throw UnExpectedResponseException(txHash);
      }
    } catch (e) {
      throw UnExpectedResponseException(e.toString());
      print(e.toString());
    }
  }
}

class InsufficientBalanceException implements Exception {
}


class UnExpectedResponseException implements Exception {
  String cause;

  UnExpectedResponseException(this.cause);
}
