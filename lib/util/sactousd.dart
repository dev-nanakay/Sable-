class SACToUSD {
  double SACToUSDConvert(String value) {
    return double.parse(
        (BigInt.parse(value) * BigInt.from(45) / BigInt.from(1e20))
            .toStringAsFixed(2));
  }

  String SACToUSDConverttoString(String value) {
    return (BigInt.parse(value) * BigInt.from(45) / BigInt.from(1e20))
        .toStringAsFixed(2);
  }

  String FeesApplied(String value) {
    return (BigInt.parse(value) / BigInt.from(1e18))
        .toStringAsFixed(2);
  }
}

class SACValue {
  String SACtoString(String value) {
    return (BigInt.parse(value) / BigInt.from(1e18))
        .toStringAsFixed(2);
  }
}
