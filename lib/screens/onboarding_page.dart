import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sac_wallet/screens/main_page.dart';
import 'package:sac_wallet/screens/verify_phone_number.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => MainPage()),
    // );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => VerifyPhoneNumberPage(),
        ),
        (route) => false);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/${assetName}', width: 250.0),
      alignment: Alignment.bottomCenter,
    );
  }

  _openP2P() async {
    const url = 'https://p2pb2b.io?referral=5e70023e';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Toast.show("Failed to load Terms and agreement");
    }
  }

//  Widget _buildImage(String assetName) {
//    return Align(
//      child: Image.asset('assets/$assetName.jpg', width: 350.0),
//      alignment: Alignment.bottomCenter,
//    );
//  }
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Sable Assent",
          body:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer ",
          image: _buildImage('app_icon.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "About Us",
          body:
              "We are a digital ecosystem that embraces and supports the economic systems of the Black community and its consumers,"
              " businesses and non-profit organizations.",
          image: _buildImage('app_icon.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Send Tokens",
          body:
              "You can easily send tokens using their username or scanning their QR Code",
          image: _buildImage('send_token.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Receive Tokens",
          body: "Easily receive tokens using the QR Code or username",
          image: _buildImage('receive.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Join our mailing list",
          body: "Stay up to date with updates from us",
          image: Align(
            child: Icon(
              Icons.mail_outline,
              size: 100,
            ),
          ),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'Join',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title:
              "SableAssent's (SAC 1) Is Now Available For American Customers",
          body: "Stay up to date with updates from us",
          image: _buildImage('app_icon.png'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
              _openP2P();
            },
            child: const Text(
              'Buy Now',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      //skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
