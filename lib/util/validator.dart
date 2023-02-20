class Validator {
  static String? validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  static String? validatePassword(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }

  static String? validatePhoneNumber(String value) {
    Pattern pattern = r"^(?:[+0]9)?[0-9]{10}$";
    RegExp regex = new RegExp(pattern.toString());
    if(!regex.hasMatch(value))
      return 'Please enter a valid phone number.';
    else
      return null;
  }

  static String? validateNumber(String value) {
    Pattern pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Please enter a number.';
    else
      return null;
  }

  static String? validateMnemonic(String value) {
    // language=RegExp
    Pattern pattern = r'^(([a-z]+)[ ]){11}[a-z]*$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Invalid Mnemonic.';
    else
      return null;
  }

  static bool recipientAddressValidityChecker(String address) {
    address = address.toLowerCase();

    // language=RegExp
    RegExp regExp = RegExp(r"^0x[0-9a-f]{40}$");

    return regExp.hasMatch(address);
  }

  static bool validateAmount(String amount) {
    // language=RegExp
    RegExp regExp = RegExp(r"^[0-9]+(\.[0-9]+)?$");

    return regExp.hasMatch(amount);
  }

  static bool validateTransactionHash(String hash) {
    // language=RegExp
    RegExp regExp = RegExp(r"^0x([A-Fa-f0-9]{64})$");

    return regExp.hasMatch(hash);
  }
}