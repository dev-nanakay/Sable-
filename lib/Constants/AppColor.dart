import 'package:flutter/material.dart';

class AppColor {
  static final PRIMARY_COLOR = const Color(0xFF263238);
  //static final PRIMARY_COLOR = const Color(0xFF004ecb);
  static final Color DARK_BLACK = const Color(0xFF263238);
  static final Color GREEN = const Color(0xFF00c853);
  static final Color GREY = const Color(0xFF757575);
  static final Color RED = const Color(0xFFd32f2f);
  static final Color PINK = const Color(0xFFe91e63);
  static final Color MAIN_BG = const Color(0xFFdfe3ee);
  static final MAIN_COLOR_SCHEME = const Color(0xFF004ecb);
  static final BALANCE_COLOR = const Color(0xFF004ecb);
  static final DIVIDER_HOME_COLOR = const Color(0xFF004ecb);
  static final NEW_MAIN_COLOR_SCHEME = const Color.fromRGBO(33, 41, 63, 1);
  static final Color BURGUANDY = const Color(0xFFc2185b);
  static final Color YELLOW = const Color(0xFFffc107);

  // blue gradient
  static final Color BLUE_START = const Color(0xFF0575E6);
  static final Color BLUE_END = const Color(0xFF021B79);

  static final List<Color> PRIMARY_GRADIENT = [
    Color(0xFF00c6ff),
    Color(0xFF0072ff)
  ];

  static final List<Color> BACKGROUND_MAIN_GRADIENT = [
    Color(0xFF141E30),
    Color(0xFF243B55)
  ];

  List<Color> getGradient(final String start, final end) {
    Color startColorFinal = Color(0xFF753a88);
    Color endColorFinal = Color(0xFFcc2b5e);
    final String startColor = "0xFF${start}";
    final String endColor = "0xFF${end}";
    try {
      startColorFinal = Color(int.parse(startColor));
      endColorFinal = Color(int.parse(endColor));
    } on Exception catch (e) {
      print("Color code exception: ${e.toString()}");
    }
    return [startColorFinal, endColorFinal];
  }
}
