import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/client/user_client.dart';
import 'package:sac_wallet/model/business.dart';
import 'package:sac_wallet/screens/business/business_details.dart';
import 'package:sac_wallet/screens/registry/create_business_page.dart';
import 'package:sac_wallet/util/widget_file.dart';

class BusinessListPage extends StatefulWidget {
  final String dropDownKey;

  BusinessListPage({Key? key, required this.dropDownKey}) : super(key: key);

  BusinessListState createState() => BusinessListState();
}

class BusinessListState extends State<BusinessListPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: widget.dropDownKey == "Near Me"
                ? BusinessList(UserClient().getBusiness())
                : AddOwnBusiness()));
  }

  AddOwnBusiness() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          BusinessList(UserClient().getMyBusiness()),
          Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.NEW_MAIN_COLOR_SCHEME,
                  ),
                  child: Center(
                    child: Text("Add new business",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateBusinessPage()));
                },
              )),
        ],
      ),
    );
  }

  BusinessList(Future<List<Business>> getBusinesses) {
    return FutureBuilder(
        future: getBusinesses,
        builder: (context, AsyncSnapshot<List<Business>> snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Container(
              child: Center(child: Text("Loading...")),
            );
          }
          if (snap.hasData) {
            List<Business> business = snap.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 10.0),
              controller: scrollController,
              itemCount: business.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BusinessDetails(business[index])));
                  },
                  child: CardView(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // Expanded(
                          //   flex: 30,
                          ///child:
                          Image.asset(
                            "assets/images/app_icon.png",
                            height: 80,
                            width: 80,
                          ),
                          //),
                          SizedBox(
                            width: 10,
                          ),
                          // Expanded(
                          //   flex: 70,
                          //   child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(business[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black)),
                              SizedBox(
                                height: 05.0,
                              ),
                              Text(
                                  '${business[index].address!
                                      .streetName} ${','} ${business[index]
                                      .address!.city}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black)),
                              SizedBox(
                                height: 05.0,
                              ),
                              Text(business[index].phoneNumber,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black)),
                              SizedBox(
                                height: 02.0,
                              ),
                            ],
                          ),
                          // )
                        ],
                      )
                    ],
                  )),
                );
              },
            );
          } else {
            return Container(
              child: Text("Could not load"),
            );
          }
        });
  }
}
