import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';

import '../../widget/image_slider.dart';
import 'join_network_page.dart';

class ProfitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PinLockWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Non Profit", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              ImageSlider([
                "assets/images/profit_slider_1.jpg",
                "assets/images/profit_slider_2.jpg",
                "assets/images/profit_slider_3.jpg"
              ]),
              SizedBox(height: 10),
              Container(
                child: Text(
                  "Together, we can do more.",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Sable Assent could not do this work on our own. Economic hardships faced by Africans throughtout the diaspora are too complicated for one organization to solve alone. We are proud to work with other NGO's and non profit organizations who share our mission and vision.",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => JoinNetworkPage()));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text("Join the Network",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
