import 'package:flutter/material.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/business/business_list.dart';
import 'package:sac_wallet/screens/business/map_view.dart';

class RegistryPage extends StatefulWidget {
  RegistryPageState createState() => RegistryPageState();
}

class RegistryPageState extends State<RegistryPage> {
  TabController? tabController;
  String selectedSubjectValue = "";
  bool pressed = true;
  Widget appBarTitle = Text('');

  List<String> subjectOptions = <String>["Near Me", "My Business"];
  int subjectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedSubjectValue = "Near Me";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: pressed ? _buildTitleWithDropDown(context) : Text('Hi'),
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          bottom: TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: "List",
              ),
              Tab(
                text: "Map",
              )
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            BusinessListPage(
              dropDownKey: selectedSubjectValue,
            ),
            BusinessListMapView()
          ],
        ),
      ),
    ));
  }

  Widget _buildTitleWithDropDown(BuildContext context) {
    //widget.currentState = this;
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          brightness: Brightness.dark),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: DropdownButton<String>(
            isExpanded: true,
            items: subjectOptions.map((value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
            }).toList(),
            value: subjectOptions[subjectIndex],
            onChanged: (newValue) {
              setState(() {
                subjectIndex = subjectOptions.indexOf(newValue!);
                selectedSubjectValue = newValue;
                print(selectedSubjectValue);
              });
            },
          ),
        ),
      ),
    );
  }
}

// class RegistryPage extends StatelessWidget {
//   double screenWidth = 0.0, screenHeight = 0.0;
//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
//         iconTheme: new IconThemeData(color: Colors.white),
//         title: Text("Register Your Business",
//             style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               ImageSlider([
//                 "assets/images/registry_slider_1.jpg",
//                 "assets/images/registry_slider_2.jpg",
//                 "assets/images/registry_slider_3.jpg"
//               ]),
//               SizedBox(height: 20),
//               Container(
//                 padding: EdgeInsets.all(10),
//                 child: Text(
//                   "Sable Assent is currently coordinating with Black owned business throughout the world to develop a Global Business Registry. Member businesses will be capable of accepting the Sable Assent Coin in exchange for products and services and will also be listed as featured companies on our website and mobile app.",
//                   style: TextStyle(color: Colors.black87, fontSize: 16),
//                   textAlign: TextAlign.center,
//                   overflow: TextOverflow.visible,
//                 ),
//               ),
//               SizedBox(height: 20),
//               InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => CreateBusinessPage()));
//                 },
//                 child: Container(
//                   margin: EdgeInsets.only(left: 30, right: 30),
//                   width: screenWidth,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: AppColor.NEW_MAIN_COLOR_SCHEME),
//                   // margin: EdgeInsets.all(10),
//                   // height: 50,
//                   // decoration: BoxDecoration(
//                   //   color: Colors.blue
//                   // ),
//                   child: Center(
//                     child: Text("Register your Business",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
