import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/business.dart';
import 'package:sac_wallet/model/location.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:sac_wallet/util/api_config.dart';

import '../../widget/loading.dart';

GoogleMapsPlaces _places =
    GoogleMapsPlaces(apiKey: ApiConfig.getConfig().kGoogleApiKey);
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class CreateBusinessPage extends StatefulWidget {
  @override
  _CreateBusinessPageState createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  late TextEditingController nameCT,
      descriptionCT,
      yearCT,
      phoneCT,
      emailCT,
      websiteCT,
      facebookCT,
      twitterCT,
      instagramCT;
  int CategoryIndex = 0, locationIndex = 0;
  bool isCertified = false;
  bool isLoading = false;
  String address = "";
  String countryCode = "";
  String? nameError,
      descriptionError,
      yearError,
      phoneError,
      emailError,
      websiteError;

  List<dynamic> Categories = [];

  double lat = 0.0, lng = 0.0;
  //Mode _mode = Mode.overlay;

  EdgeInsetsGeometry inputPadding =
      EdgeInsets.only(left: 12.0, bottom: 18, top: 18);

  addCompanyData() async {
    String name = nameCT.text;
    String description = descriptionCT.text;
    String category = Categories[CategoryIndex];
    String year = yearCT.text;
    String phone = phoneCT.text;
    String email = emailCT.text;
    String website = websiteCT.text;
    String facebook = facebookCT.text;
    String twitter = twitterCT.text;
    String instagram = instagramCT.text;

    if (!validateName() &&
        !validateEmail() &&
        !validatePhoneNumber() &&
        !validateFoundationYear() &&
        !validateDescription() &&
        !validateWebsite() &&
        !isCertified) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    MyLocation location = MyLocation(coordinates: [lng, lat]);

    Business business = Business(
        email: email,
        name: name,
        category: category,
        facebookUrl: facebook,
        twitterUrl: twitter,
        instagramUrl: instagram,
        phoneNumber: countryCode + phone,
        websiteUrl: website,
        location: location,
        foundationYear: year,
        description: description);

    try {
      bool isSuccess = await UserRepository().addBusiness(business: business);
      if (isSuccess) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Successfully added your company data");
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Failed!");
    }
  }

  @override
  void initState() {
    super.initState();
    nameCT = new TextEditingController();
    descriptionCT = new TextEditingController();
    yearCT = new TextEditingController();
    phoneCT = new TextEditingController();
    emailCT = new TextEditingController();
    websiteCT = new TextEditingController();
    facebookCT = new TextEditingController();
    twitterCT = new TextEditingController();
    instagramCT = new TextEditingController();
    Categories = [""];
    getCategories();
  }

  getCategories() async {
    var newCategories = await UserRepository().getCategories();
    setState(() {
      Categories = newCategories;
    });
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    /* Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: ApiConfig.getConfig().kGoogleApiKey!,
      onError: onError,
      mode: _mode,
    ); */

    // displayPrediction(p!, homeScaffoldKey.currentState!);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      lat = detail.result.geometry!.location.lat;
      lng = detail.result.geometry!.location.lng;
      setState(() {
        address = detail.result.formattedAddress!;
      });
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(homeScaffoldKey.currentContext!).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  void _onCountryCodeInit(CountryCode? countryCode) {
    this.countryCode = countryCode.toString();
    print(countryCode.toString());
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      this.countryCode = countryCode.toString();
      print(countryCode.toString());
    });
  }

  bool validateName() {
    if (nameCT.text.isEmpty) {
      setState(() {
        nameError = "Enter Company Name!";
      });
      return false;
    }
    setState(() {
      nameError = null;
    });
    return true;
  }

  bool validateDescription() {
    print(descriptionCT.text);
    if (descriptionCT.text.isEmpty) {
      setState(() {
        descriptionError = "Enter Description!";
      });
      return false;
    }
    setState(() {
      descriptionError = null;
    });
    return true;
  }

  bool validateFoundationYear() {
    print(yearCT.text);
    if (yearCT.text.isEmpty) {
      setState(() {
        yearError = "Enter Foundation Year!";
      });
      return false;
    } else {
      if (yearCT.text.length == 4) {
        var currentYear = new DateTime.now().year;
        if (currentYear < int.parse(yearCT.text)) {
          setState(() {
            yearError = "Foundation Year cannot be in future";
          });
          return false;
          ;
        }
      } else {
        setState(() {
          yearError = "Enter a valid year";
        });
        return false;
      }
    }
    setState(() {
      yearError = null;
    });
    return true;
  }

  bool validatePhoneNumber() {
    print(countryCode + phoneCT.text);
    if (phoneCT.text.isEmpty) {
      setState(() {
        phoneError = "Enter Phone Number!";
      });
      return false;
    } else {
      if (phoneCT.text.length == 10) {
        setState(() {
          phoneError = "Phone Number should be 10 digits";
        });
        return false;
      }
    }
    setState(() {
      phoneError = null;
    });
    return true;
  }

  bool validateEmail() {
    if (emailCT.text.isEmpty) {
      setState(() {
        emailError = "Enter Email Address";
      });
      return false;
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(emailCT.text)) {
      setState(() {
        emailError = 'Please enter a valid email Address';
      });
      return false;
    }
    setState(() {
      emailError = null;
    });
    return true;
  }

  bool validateWebsite() {
    if (websiteCT.text.isEmpty) {
      setState(() {
        websiteError = "Enter Website!";
      });
      return false;
    }
    setState(() {
      websiteError = null;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return PinLockWrapper(
      child: Scaffold(
        key: homeScaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          title: Text("Register Your Business",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,

                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: nameCT,
                        keyboardType: TextInputType.text,
                        onEditingComplete: validateName,
                        decoration: new InputDecoration(
                          labelText: 'Company Name',
                          errorText: nameError,
                          contentPadding: inputPadding,
                          labelStyle:
                              TextStyle(color: AppColor.NEW_MAIN_COLOR_SCHEME),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,

                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: descriptionCT,
                        keyboardType: TextInputType.text,
                        onEditingComplete: validateDescription,
                        decoration: new InputDecoration(
                          labelText: "Description",
                          errorText: descriptionError,
                          labelStyle:
                              TextStyle(color: AppColor.NEW_MAIN_COLOR_SCHEME),
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Select Industry:",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Container(
                            width: screenWidth * 0.5,
                            padding: EdgeInsets.only(top: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: Categories.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                                value: Categories[CategoryIndex],
                                onChanged: (newValue) {
                                  setState(() {
                                    CategoryIndex =
                                        Categories.indexOf(newValue);
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,

                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: yearCT,
                        keyboardType: TextInputType.number,
                        onEditingComplete: validateFoundationYear,
                        decoration: new InputDecoration(
                          labelText: "Foundation Year",
                          errorText: yearError,
                          labelStyle:
                              TextStyle(color: AppColor.NEW_MAIN_COLOR_SCHEME),
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    InkWell(
                      onTap: () {
                        _handlePressButton();
                      },
                      child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME,
                          ),
                          child: Center(
                            child: Text("Add Address",
                                style: TextStyle(color: Colors.white)),
                          )),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Address: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              address,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CountryCodePicker(
                            onChanged: _onCountryChange,
                            onInit: _onCountryCodeInit,
                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: 'US',
                            favorite: ['+1', 'US', '+91', 'IN'],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            //padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            width: screenWidth,

                            decoration: BoxDecoration(color: Colors.white),
                            child: TextField(
                              controller: phoneCT,
                              keyboardType: TextInputType.phone,
                              onEditingComplete: validatePhoneNumber,
                              decoration: new InputDecoration(
                                labelText: "Phone Number",
                                errorText: phoneError,
                                labelStyle: TextStyle(
                                    color: AppColor.NEW_MAIN_COLOR_SCHEME),
                                contentPadding: inputPadding,
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,

                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: emailCT,
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: validateEmail,
                        decoration: new InputDecoration(
                          labelText: "Email Address",
                          errorText: emailError,
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                          hintText: 'Enter Email',
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: websiteCT,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          labelText: "Website",
                          errorText: websiteError,
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: facebookCT,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          labelText: "Facebook Profile",
                          hintText: 'facebook.com/company',
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: twitterCT,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          labelText: "Twitter Profile",
                          hintText: 'twitter.com/company',
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      //padding: EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth,
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: instagramCT,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          labelText: "Instagram Profile",
                          hintText: 'instagram.com/company',
                          contentPadding: inputPadding,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
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
                          Text("I certify the above is true.",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 15)),
                          Switch(
                            value: isCertified,
                            onChanged: (value) {
                              setState(() {
                                isCertified = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        addCompanyData();
                      },
                      child: Container(
                          width: screenWidth,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColor.NEW_MAIN_COLOR_SCHEME,
                          ),
                          child: Center(
                            child: Text("Register my Black Business!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          )),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            LoadingScreen(
              inAsyncCall: isLoading,
              dismissible: false,
              mesage: "Adding as company...",
            )
          ],
        ),
      ),
    );
  }
}
