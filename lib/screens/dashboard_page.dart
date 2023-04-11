import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/screens/account/edit_account_page.dart';
import 'package:sac_wallet/screens/custom_drawer.dart';
import 'package:sac_wallet/screens/lock_wrapper.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/text_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_page.dart';
import '../widget/loading.dart';
import 'account/account_page.dart';
import 'home/home_page.dart';
import 'profit/profit_page.dart';
import 'registry/registry_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double screenWidth = 0.0, screenHeight = 0.0;
  int navigation_current_index = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPrivateKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        TextUtil.PRIVATE_KEY, GlobalValue.getCurrentUser.privateKey!);
  }

  Widget getPageFromIndex(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return AccountPage();
      case 2:
        return RegistryPage();
      case 4:
        return ProfitPage();
      case 5:
        return EditAccountPage();
      default:
        return HomePage();
    }
  }

  Widget getTitleFromIndex(int index) {
    switch (index) {
      case 0:
        return Text("SABLE ASSENT", style: TextStyle(color: Colors.white));
      case 1:
        return Text("My Account", style: TextStyle(color: Colors.white));
      case 2:
        return Text("Business", style: TextStyle(color: Colors.white));
      case 3:
        return Text("Empowering Global Trade",
            style: TextStyle(color: Colors.white));
      case 4:
        return Text("Global Non-Profit Network",
            style: TextStyle(color: Colors.white));
      default:
        return Text("SABLE ASSENT", style: TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return PinLockWrapper(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: AppColor.MAIN_BG,
            appBar: AppBar(
              backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
              title: getTitleFromIndex(navigation_current_index),
              centerTitle: true,
              elevation: 0.0,
              iconTheme: new IconThemeData(color: Colors.white),
              actions: <Widget>[
                Visibility(
                  visible: navigation_current_index == 1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAccountPage()));
                      setState(() {});
                    },
                    icon: Icon(Icons.edit, color: Colors.white, size: 25),
                  ),
                )
              ],
            ),
            drawer: CustomDrawer(),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 6,
              selectedItemColor: AppColor.NEW_MAIN_COLOR_SCHEME,
              unselectedItemColor: Colors.grey,
              currentIndex: navigation_current_index,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "My Account"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.assignment), label: "Business"),
              ],
              onTap: (index) async {
                if (index == 5) {
                  setState(() {
                    isLoading = true;
                  });
                  bool isSuccess = await true;
                  if (isSuccess) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route route) => false);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    Fluttertoast.showToast(msg: "Failed!");
                  }
                } else {
                  setState(() {
                    navigation_current_index = index;
                  });
                }
              },
            ),
            body: getPageFromIndex(navigation_current_index),
          ),
          LoadingScreen(
            inAsyncCall: isLoading,
            mesage: "Logging out...",
            dismissible: false,
          )
        ],
      ),
    );
  }
}
