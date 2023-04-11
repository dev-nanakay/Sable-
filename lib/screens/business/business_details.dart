import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/client/user_client.dart';
import 'package:sac_wallet/exceptions/validation_exception.dart';
import 'package:sac_wallet/model/business.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/screens/wallet/send_token_page.dart';
import 'package:sac_wallet/util/business_util.dart';
import 'package:sac_wallet/util/launcher_util.dart';
import 'package:sac_wallet/widget/image_slider.dart';

// class BusinessDetails extends StatefulWidget {

//   BusinessDetailsPageState createState() => BusinessDetailsPageState();
// }

Widget _BusinessDescription(String description) {
  return Visibility(
    visible: description != null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            description ?? "",
            textAlign: TextAlign.left,
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

Widget _InfoRow(Icon icon, String text, Function() clickHandler,
    {Icon? rightIcon}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: IconButton(
            icon: icon,
            onPressed: clickHandler,
          ),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: <Widget>[
              Text(text),
              Visibility(
                visible: rightIcon != null,
                child: Expanded(
                  flex: 1,
                  child: rightIcon ?? Container(),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _MapView(Business business) {
  return GoogleMap(
    mapType: MapType.normal,
    initialCameraPosition: CameraPosition(
        target: LatLng(business.location!.coordinates[1],
            business.location!.coordinates[0]),
        zoom: 12.0),
    onCameraMove: (CameraPosition position) {},
    zoomGesturesEnabled: true,
    markers: new HashSet.from([
      Marker(
        markerId: MarkerId(business.id),
        position: LatLng(business.location!.coordinates[1],
            business.location!.coordinates[0]),
        infoWindow: InfoWindow(
            title: '${business.name}', snippet: '${business.category}'),
      )
    ]),
  );
}

Widget _SocialMediaIcon({required FaIcon icon, String? link}) {
  return Visibility(
    visible: link != null,
    child: IconButton(
      icon: icon,
      onPressed: () {
        LauncherUtils.openUrl(link ?? '');
      },
    ),
  );
}

Widget _SocialMediaIcons(Business business) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      _SocialMediaIcon(
          icon: FaIcon(
            FontAwesomeIcons.facebook,
            color: Colors.blue,
          ),
          link: business.facebookUrl),
      _SocialMediaIcon(
          icon: FaIcon(
            FontAwesomeIcons.instagram,
            color: Colors.redAccent,
          ),
          link: business.instagramUrl),
      _SocialMediaIcon(
          icon: FaIcon(
            FontAwesomeIcons.twitter,
            color: Colors.blueAccent,
          ),
          link: business.instagramUrl),
      _SocialMediaIcon(
          icon: FaIcon(
            FontAwesomeIcons.at,
            color: Colors.redAccent,
          ),
          link: business.websiteUrl),
    ],
  );
}

Widget _RatingWidget(double numStars) {
  if (numStars > 5) throw ValidationException("stars can be max 5");
  List<Widget> stars = [];
  double temp = numStars;
  while (temp > 0) {
    stars.add(Icon((temp >= 1) ? Icons.star : Icons.star_half,
        color: Colors.orangeAccent));
    temp--;
  }
  int remaining = 5 - numStars.ceil();
  while (remaining > 0) {
    stars.add(Icon(Icons.star_border, color: Colors.grey));
    remaining--;
  }
  return Container(
    child: Row(
      children: stars,
    ),
  );
}

Widget _OwnerDetails(String userId) {
  return FutureBuilder(
      future: UserClient().getUserById(userId: userId),
      builder: (context, AsyncSnapshot<User> snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Container(
            child: Text("Loading"),
          );
        }
        if (snap.hasData) {
          User user = snap.data!;
          return Visibility(
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Owner's Details",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black)),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        _InfoRow(Icon(Icons.perm_contact_calendar), user.name,
                            () {}),
                        _InfoRow(Icon(Icons.account_balance_wallet),
                            "S@${user.username}", () {}),
                        _InfoRow(Icon(Icons.mail_outline), user.email, () {})
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Image.asset("assets/images/default_profile.png"),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.NEW_MAIN_COLOR_SCHEME,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Pay",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            Icon(Icons.add_to_home_screen, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      print(user.walletAddress);
                      if (user.walletAddress != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SendTokenPage(
                                  walletAddress: user.walletAddress,
                                )));
                      } else {
                        Fluttertoast.showToast(
                            msg: "The owner doesn't have a wallet");
                      }
                    },
                  )),
            ],
          ));
        } else {
          return Container(
            child: Text("Couldn't load data"),
          );
        }
      });
}

class BusinessDetails extends StatelessWidget {
  final Business business;

  BusinessDetails(this.business);

  String address(Business business) {
    String totalAddress = '';

    if (business.address!.houseNumber != null) {
      totalAddress += '${business.address!.houseNumber}';
    }
    if (business.address!.streetName != null) {
      totalAddress += ' ${business.address!.streetName}';
    }
    if (business.address!.city != null) {
      totalAddress += ' ${business.address!.city}';
    }
    if (business.address!.zipCode != null) {
      totalAddress += ' - ${business.address!.zipCode}';
    }
    if (business.address!.country != null) {
      totalAddress += ' ${business.address!.country}';
    }
    return totalAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        iconTheme: new IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Text("Details", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LauncherUtils.openMap(business.location!.coordinates[1],
              business.location!.coordinates[0]);
        },
        backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        child: Icon(Icons.directions_car),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ImageSlider(getImageUrls(business)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                            flex: 4,
                            child: Text(business.name,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34,
                                    color: Colors.black87))),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
//
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                              flex: 4,
                              child: Divider(
                                height: 0.8,
                                color: Colors.black26,
                              ))
                        ],
                      ),
                    ),
                    _InfoRow(
                        Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                        ),
                        address(business),
                        () {}),
                    _InfoRow(Icon(Icons.call, color: Colors.green),
                        business.phoneNumber, () {
                      LauncherUtils.launchCaller(business.phoneNumber);
                    }),
                    _InfoRow(Icon(Icons.timer, color: Colors.green),
                        'Weekdays 9AM - 8PM', () {}),
                    _InfoRow(Icon(Icons.category, color: Colors.purple),
                        business.category, () {}),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _BusinessDescription(business.description)),
                    Container(height: 300, child: _MapView(business)),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: _SocialMediaIcons(business)),
                    Divider(
                      height: 0.8,
                      color: Colors.black26,
                    ),
                    _OwnerDetails(business.userId),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
