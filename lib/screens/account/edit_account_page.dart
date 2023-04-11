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
    fontSize: 14.0,
  );

  final TextStyle inputLabelStyle = TextStyle(
      color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold);

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
      bool isSuccess = true;
      print("isSuccess value: $isSuccess");
      if (isSuccess) {
        setState(() {
          isLoading = false;
        });
        GlobalValue.setCurrentUser = user;
        Fluttertoast.showToast(msg: "Successfully updated!");
        Navigator.of(context).pop(true);
      }
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
      backgroundColor: AppColor.MAIN_BG,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
        iconTheme: new IconThemeData(color: Colors.white),
        title: Text("Edit My Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        Container(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*  Text(
                      "PROFILE PICTURE",
                      style: headerStyle,
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                        elevation: 0.5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 0,
                        ),
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                child: isImageLoading
                                        ? Avatar(
                                            image: new AssetImage(
                                                    "assets/images/loading.gif"),
                                            radius: 40,
                                            backgroundColor: Colors.white,
                                            borderColor: Colors.grey.shade300,
                                            borderWidth: 4.0,
                                          )
                                    : Avatar(
                                        image: user.photo == null
                                            ? new AssetImage(
                                                "assests/images/default_profile.png")
                                            : CachedNetworkImageProvider(
                                                user.photo),
                                        radius: 40,
                                        backgroundColor: Colors.white,
                                        borderColor: Colors.grey.shade300,
                                        borderWidth: 4.0,
                                      ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left:
                                      (MediaQuery.of(context).size.width / 2) -
                                          20,
                                  top: 10),
                              child: MaterialButton(
                                color: Colors.white,
                                shape: CircleBorder(),
                                elevation: 0,
                                child: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_) => CustomDialog(this));
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 90),
                              child: Column(
                                children: <Widget>[
                                  /* ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: user.photo != null
                                      ? CachedNetworkImageProvider(user.photo)
                                      : new AssetImage(
                                      "assets/images/default_profile.png"),
                                ),
                                title: Text(user.name != null ? user.name : "-"),
                                onTap: () {},
                              ),*/
                                  _buildDivider(),
                                  SwitchListTile(
                                    activeColor: Colors.blue,
                                    value: true,
                                    title: Text("Diable/Enable Chat"),
                                    onChanged: (val) {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),*/
                    const SizedBox(height: 10.0),
                    Text(
                      "ACCOUNT INFORMATION",
                      style: headerStyle,
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 0,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name:", style: inputLabelStyle),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: nameCT,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Name",
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text("Country:", style: inputLabelStyle),
                            Container(
                                padding: EdgeInsets.only(top: 10),
                                child: InkWell(
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      width: screenWidth,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Center(
                                        child: Text(country,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                      )),
                                )),
                            const SizedBox(height: 16.0),
                            Text("Decription:", style: inputLabelStyle),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: descriptionCT,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter a profile description",
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "SOCIAL MEDIA INFORMATION",
                      style: headerStyle,
                    ),
                    const SizedBox(height: 10.0),
                    Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 0,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("My Facebook Page:",
                                    style: inputLabelStyle),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: facebookCT,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "facebook.com/mypage",
                                    ),
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Text("My Instagram Page:",
                                    style: inputLabelStyle),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: instagramCT,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "instagram.com/mypage",
                                    ),
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Text("My Twitter Page:",
                                    style: inputLabelStyle),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: twitterCT,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "twitter.com/mypage",
                                    ),
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Text("My Linkedin Page:",
                                    style: inputLabelStyle),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: linkedinCT,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "linkedin.com/mypage",
                                    ),
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ]),
                        )),
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
                  ]),
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
          children: <Widget>[],
        ),
      ),
    );
  }
}
