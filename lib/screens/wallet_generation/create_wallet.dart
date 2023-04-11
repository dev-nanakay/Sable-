import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/client/user_client.dart';
import 'package:sac_wallet/repository/user_repository.dart';
import 'package:sac_wallet/screens/pin/create_pin.dart';
import 'package:sac_wallet/util/eth_util.dart';
import 'package:sac_wallet/util/pdf_util.dart';
import 'package:sac_wallet/util/text_util.dart';
import 'package:sac_wallet/widget/loading.dart';

class CreateWallet extends StatefulWidget {
  final String passphrase;

  CreateWallet({Key? key, required this.passphrase}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWallet> {
  // Show/Hide the visibility of generate button
  bool isShareVisible = true;
  String? mnemonicText;
  List<String> arrayWords = [];

  bool isLoading = false;

  void setLoading(loading) => setState(() {
        isLoading = loading;
      });

  @override
  void initState() {
    super.initState();
    getMnemonicPassphrase();
  }

  void clickShareButton() {
    setState(() {
      isShareVisible = !isShareVisible;
    });
  }

  void toggleShareVisible() {
    setState(() {
      isShareVisible = !isShareVisible;
    });
  }

  void getMnemonicPassphrase() {
    setState(() {
      mnemonicText = widget.passphrase;
      arrayWords = widget.passphrase.split(' ');
    });
  }

  // Generate pdf and save to device
  Future<void> clickGeneratePDFButton() async {
    // TODO:
    try {
      setLoading(true);

      pw.Document pdf = PdfUtil.generatePDF(mnemonicText!);
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
      Fluttertoast.showToast(msg: "Generating PDF");
    } catch (Exception) {
      Fluttertoast.showToast(msg: "Error occurred while generating PDF");
    } finally {
      setLoading(false);
    }
  }

  Future<void> clickMailToButton() async {
    try {
      setLoading(true);

      pw.Document pdf = PdfUtil.generatePDF(mnemonicText!);

      // Write pdf to a temporary file
      final output = await getTemporaryDirectory();
      String tempPath = "${output.path}/sac.pdf";
      final file = File(tempPath);
      final savedPdf = await pdf.save();
      await file.writeAsBytes(savedPdf);

      final MailOptions mailOptions = MailOptions(
          body: "Please keep this secure.",
          subject: 'Your Sable Assent wallet secret seed phrase',
          attachments: [tempPath]);
      await FlutterMailer.send(mailOptions);
    } catch (Exception) {
      Fluttertoast.showToast(msg: "Error occurred while sharing");
    } finally {
      setLoading(false);
    }
  }

  // Goto verification Step
  void clickNextButton() async {
    // await UserRepository().updateMnemonic(mnemonicText: mnemonicText.trim());
    try {
      setLoading(true);
      String privateKey = EthUtil.generatePrivateKey(mnemonicText!);
      String walletAddress = await EthUtil.generateWalletAddress(privateKey);

      UserRepository userRepository = new UserRepository();
      await UserClient()
          .updateWalletAddressOnServer(walletAddress: walletAddress);
      await userRepository.addPrivateKey(privateKey: privateKey);
      await userRepository.addWalletAddress(walletAddress: walletAddress);
      await userRepository.updateMnemonic(mnemonicText: mnemonicText!.trim());

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreatePin()));
    } catch (Exception) {
      Fluttertoast.showToast(msg: "An error occurred");
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColor.NEW_MAIN_COLOR_SCHEME,
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text("Private Keys and recovery",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(/* overflow: Overflow.visible, */ children: <Widget>[
          Container(
              child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                      height: 100,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                          // borderOnForeground: true,
                          shadowColor: Colors.black87,
                          child: Center(
                            child: Text(
                              "$mnemonicText",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      TextUtil.INSTRUCTION4,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: AppColor.NEW_MAIN_COLOR_SCHEME),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      // padding: EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 50,
                            child: Container(
                              // padding: EdgeInsets.only(left: 30, right: 30),
                              child: GestureDetector(
                                  child: Container(
                                      //width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/printer.png",
                                            width: 30,
                                            height: 30,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text("Save PDF",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                  onTap: () {
                                    // pdf call
                                    clickGeneratePDFButton();
                                    toggleShareVisible();
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 50,
                            child: Container(
                              // padding: EdgeInsets.only(left: 30, right: 30),
                              child: GestureDetector(
                                child: Container(
                                  //   width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.NEW_MAIN_COLOR_SCHEME,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/mail.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text("Email Pdf",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // email call
                                  clickMailToButton();
                                  toggleShareVisible();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //),
                  SizedBox(
                    height: 15,
                  ),
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
                          child: Text("I've backed up the wallet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      onTap: clickNextButton,
                    ),
                  ),
                ]),
          )),
          LoadingScreen(
              inAsyncCall: isLoading, mesage: "Loading", dismissible: false)
        ]));
  }
}
