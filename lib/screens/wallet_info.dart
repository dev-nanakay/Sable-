import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';
import 'package:sac_wallet/Constants/AppColor.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/util/global.dart';
import 'package:sac_wallet/util/pdf_util.dart';

class WalletInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<WalletInfo> {
  // Show/Hide the visibility of generate button
  bool isShareVisible = true;
  String? mnemonicText, privateKey;
  List<String> arrayWords = [];
  User? user;
  String? data;

  @override
  void initState() {
    super.initState();
    user = GlobalValue.getCurrentUser;
    getDetails();
    data = "Mnemonic: $mnemonicText" + "\n" + "Private Key: $privateKey";
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

  void getDetails() {
    setState(() {
      mnemonicText = user!.mnemonic;
      arrayWords = user!.mnemonic!.split(' ');
      privateKey = user!.privateKey;
    });
  }

  // Generate pdf and save to device
  Future<void> clickGeneratePDFButton() async {
    // TODO:
    try {
      pw.Document pdf = PdfUtil.generatePDF(data!);
      /*  await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save()); */
      Fluttertoast.showToast(msg: "Generating PDF");
    } catch (Exception) {
      Fluttertoast.showToast(msg: "Error occurred while generating PDF");
    }
  }

  Future<void> clickMailToButton() async {
    try {
      pw.Document pdf = PdfUtil.generatePDF(data!);

      // Write pdf to a temporary file
      final output = await getTemporaryDirectory();
      String tempPath = "${output.path}/sac.pdf";
      final file = File(tempPath);
      final savedPdf = await pdf.save();
      await file.writeAsBytes(savedPdf);

      final MailOptions mailOptions = MailOptions(
          body: "Please keep this secure.",
          subject:
              'Your Sable Assent wallet secret seed phrase and Private Key',
          attachments: [tempPath]);
      await FlutterMailer.send(mailOptions);
    } catch (Exception) {
      Fluttertoast.showToast(msg: "Error occurred while sharing");
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
          title: Text("Mnemonic and Private Keys",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(/* /* overflow: Overflow.visible, */ */ children: <Widget>[
          Container(
              child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text("Mnemonic:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
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
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text("Private Key:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                      height: 100,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Card(
                          // borderOnForeground: true,
                          shadowColor: Colors.black87,
                          child: Center(
                            child: Text(
                              "$privateKey",
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
                ]),
          )),
        ]));
  }
}
