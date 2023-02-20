import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        /* overflow: Overflow.visible, */
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/app_icon.png"),
                /*SizedBox(height: 5),
                Text("Log In", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColor.MAIN_COLOR_SCHEME),),*/
              ],
            ),
          )
        ],
      ),
    );
  }
}
