import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/widget/loading.dart';

class EditAccountPage extends StatefulWidget {
  EditAccountPage({Key? key}) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  final nameCT = TextEditingController();
  final descriptionCT = TextEditingController();
  final facebookCT = TextEditingController();
  final twitterCT = TextEditingController();
  final instagramCT = TextEditingController();
  final linkedinCT = TextEditingController();
  bool enabledChat = false;
  String? serverImageUrl;
  String country = "Africa";
  User user = GlobalValue.getCurrentUser;
  bool isImageLoading = false;
  bool isLoading = false;

  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  changeProfile() async {
    String name = nameCT.text;
    String description = descriptionCT.text;
    String facebook = facebookCT.text;
    String twitter = twitterCT.text;
    String instagram = instagramCT.text;
    String linkedin = linkedinCT.text;
    String photo = serverImageUrl ?? '';

    user.country = country;
    user.description = description;
    print("description: $description");
    print("facebook: $facebook");
    print("twitter: $twitter");
    print("linkedin: $linkedin");

    try {
      if (name.isNotEmpty) {
        user.name = name;
      }

      if (facebook.isNotEmpty) {
        user.facebook_link = facebook;
      }

      if (twitter.isNotEmpty) {
        user.twitter_link = twitter;
      }

      if (instagram.isNotEmpty) {
        user.instagram_link = instagram;
      }

      if (linkedin.isNotEmpty) {
        user.linkedin_link = linkedin;
      }

      if (photo.isNotEmpty) {
        user.photo = photo;
      }

      setState(() {
        isLoading = true;
        user.name = name;
        user.facebook_link = facebook;
        user.twitter_link = twitter;
        user.instagram_link = instagram;
        user.linkedin_link = linkedin;
        user.photo = photo;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Failed!");
      print("Error: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    nameCT.text = user.name;
    descriptionCT.text = user.description ?? '';
    facebookCT.text = user.facebook_link ?? '';
    twitterCT.text = user.twitter_link ?? '';
    instagramCT.text = user.instagram_link ?? '';
    linkedinCT.text = user.linkedin_link ?? '';
    enabledChat = bool.fromEnvironment(user.enabledChat);
    serverImageUrl = user.photo;
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text("Edit My Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Profile Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Name:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Container(
                          width: screenWidth * 0.65,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: nameCT,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Enter Name",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("Country",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup<void>(
                          context: context,
                          builder: (context) {
                            return CountryPickerCupertino(
                              pickerSheetHeight: 300,
                              onValuePicked: (Country value) {
                                setState(() {
                                  country = value.name;
                                });
                              },
                            );
                          });
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Center(
                          child: Text(country,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        )),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Profile Picture",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 15),
                  Container(
                    //child: Image.asset("assets/images/default_profile.png", width: 100, height: 100, fit: BoxFit.fill),
                    child: !isImageLoading
                        ? (isImageLoading
                            ? Container(
                                width: double.infinity,
                                height: 450,
                                child: Image.asset("assets/images/loading.gif",
                                    width: 100, height: 100),
                              )
                            : Image.asset("assets/images/default_profile.png",
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.fill))
                        : CachedNetworkImage(
                            imageUrl: serverImageUrl!,
                            width: double.infinity,
                            height: 450,
                            fadeInDuration: Duration(milliseconds: 300),
                            fadeOutDuration: Duration(milliseconds: 300),
                            placeholder: (context, url) => Container(
                              width: double.infinity,
                              height: 450,
                              child: Image.asset("assets/images/loading.gif",
                                  width: 100, height: 100),
                            ),
                            fit: BoxFit.scaleDown,
                            placeholderFadeInDuration:
                                Duration(milliseconds: 300),
                          ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => CustomDialog(this));
                    },
                    child: Container(
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.green),
                      child: Center(
                        child: Text("Change Profile Picture",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Profile Description",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: screenHeight * 0.15,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: descriptionCT,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter a profile description",
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Facebook Page",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Enter Link:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Container(
                          width: screenWidth * 0.65,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: facebookCT,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "facebook.com/mypage",
                            ),
                            keyboardType: TextInputType.url,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Instagram Page",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Enter Link:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Container(
                          width: screenWidth * 0.65,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: instagramCT,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "instagram.com/mypage",
                            ),
                            keyboardType: TextInputType.url,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Twitter Page",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Enter Link:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Container(
                          width: screenWidth * 0.65,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: twitterCT,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "twitter.com/mypage",
                            ),
                            keyboardType: TextInputType.url,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("My Linkedin Page",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Enter Link:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Container(
                          width: screenWidth * 0.65,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: linkedinCT,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "linkedin.com/mypage",
                            ),
                            keyboardType: TextInputType.url,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Diable/Enable Chat",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15)),
                        Switch(
                          value: false,
                          onChanged: (value) {
                            print("Switch value: $value");
                            // setState(() {
                            //   enabledChat = value;
                            // });
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      print("Profile changed");
                      changeProfile();
                    },
                    child: Container(
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Center(
                        child: Text("Save Changes",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            )),
        LoadingScreen(
          inAsyncCall: isLoading,
          dismissible: false,
          mesage: "Changing profile...",
        )
      ]),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final _EditAccountPageState parent;

  CustomDialog(this.parent);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Choose..",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ListTile(
              onTap: () {
                //getImageData("camera");
                Navigator.of(context).pop(true);
              },
              leading: Icon(Icons.camera_alt, color: Colors.blue, size: 25),
              title: Text("Camera",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                getImageData("gallery");
                Navigator.of(context).pop(true);
              },
              leading: Icon(Icons.collections, color: Colors.blue, size: 25),
              title: Text("Gallery",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  getImageData(String sourceName) async {}
}
