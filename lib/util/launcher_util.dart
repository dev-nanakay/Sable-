import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static launchCaller(String number) async {
    String url = "tel:${number}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  LauncherUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    return openUrl(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  }

  static Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open url.';
    }
  }
}
