import 'eth_util.dart';

class TimeUtil {
  static String getMinutesSeconds(int seconds) {
    int minutes = (seconds / 60).floor();
    seconds = seconds % 60;
    return "${EthUtil.padByZero(minutes.toString(), 2)}:${EthUtil.padByZero(seconds.toString(), 2)}";
  }
}
