class PinConstants {
  static final PIN_LENGTH = 4;

  // convert minutes to milliseconds
  static final RETRY_INTERVAL = 5 * 60 * 1000;

  static final ALLOWED_ATTEMPTS = 5;

  static final PIN_LOCK_DURATION =
      2000; // 2 seconds (if more than 2 seconds in background, then lock the app.

  static String starPrint(String pin) {
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < pin.length; i++) {
      sb.write("*");
    }
    return sb.toString();
  }
}
