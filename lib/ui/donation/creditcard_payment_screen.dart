import 'dart:io';

import '../../model/payment_info.dart';
import '../../repo/common_repository.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../model/user_info.dart';

class CreditCardPaymentScreen extends StatefulWidget {
  final Function(bool) paymentStatus;
  final PaymentInfo paymentInfo;

  const CreditCardPaymentScreen({Key key, this.paymentInfo, this.paymentStatus})
      : super(key: key);

  @override
  _CreditCardPaymentScreenState createState() =>
      _CreditCardPaymentScreenState();
}

class _CreditCardPaymentScreenState extends State<CreditCardPaymentScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  String userName = "";
  String userFullName = "";
  bool showCloseBtn = false;

  @override
  void initState() {
    super.initState();
    getuserFullName();
  }

  Future<void> getuserFullName() async {
    UserInfo userInfo = await AppPreferences.getUserInfo();
    userName = await AppPreferences.getUsername();
    if (userInfo.userFullName != null) {
      userFullName = userInfo.userFullName;
    } else {
      if (userInfo.firstName != null) userFullName += userInfo.firstName + " ";
      if (userInfo.lastName != null) userFullName += userInfo.lastName;
    }

    setState(() {});
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to cancel the Payment?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "No",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              FlatButton(
                onPressed: () {
                  // Navigator.pop(context, true);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationHomeScreen()),
                      ModalRoute.withName(Routes.dashBoard));
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment",
          ),
          centerTitle: true,
          automaticallyImplyLeading: !showCloseBtn,
          actions: <Widget>[
            if (showCloseBtn)
              FlatButton(
                  child: Text(
                    "Complete",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "processed");
                  })
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(
                  child: InAppWebView(
                    initialUrl: AppPreferences().apiURL +
                        "/filing" +
                        "/payment/wpi/initiate?" +
                        "total=${widget.paymentInfo.totalAmount}&phone=${widget.paymentInfo.payeePhoneNumber}&name=${widget.paymentInfo.payeeName}&email=${widget.paymentInfo.payeeEmail}&payment_source=${widget.paymentInfo.paymentSource}&request_id=${widget.paymentInfo.requestId}&currency=${widget.paymentInfo.currency}&payment_description=${widget.paymentInfo.paymentDescription}&transaction_type=${widget.paymentInfo.transactionType}&user_name=$userName",
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                    )),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    iosOnDidReceiveServerRedirectForProvisionalNavigation:
                        (value) async {
                      debugPrint(
                          "iosOnDidReceiveServerRedirectForProvisionalNavigation  --> ${await value.getUrl()}");

                      String returnUrl = Uri.decodeFull(await value.getUrl());
                      if (returnUrl.contains("status=success") ||
                          returnUrl.contains("status=failed")) {
                        Future.delayed(const Duration(milliseconds: 5),
                            () async {
                          setState(() {
                            showCloseBtn = true;
                          });
                        });
                      }
                    },
                    onLoadStart:
                        (InAppWebViewController controller, String url) async {
                      setState(() {
                        this.url = url;
                        if (Platform.isAndroid) {
                          if (url.contains("status=success") ||
                              url.contains("status=failed")) {
                            Future.delayed(const Duration(milliseconds: 5),
                                () async {
                              //setState(() {
                              showCloseBtn = true;
                              //});
                            });
                          }
                        }
                        debugPrint("onLoadStart --> $url");
                      });
                    },
                    onLoadStop:
                        (InAppWebViewController controller, String url) async {
                      setState(() {
                        this.url = url;
                        debugPrint("onLoadStop --> $url");
                      });
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                        debugPrint("onProgressChanged --> $progress");
                      });
                    },
                    /* onLoadHttpError:
                        (controller, url, errorCode, errorMessage) {
                      if (errorCode >= 400 && errorCode <= 499) {
                        webView.loadFile(
                            assetFilePath: "assets/static/400.html");
                      } else if (errorCode >= 500) {
                        webView.loadFile(
                            assetFilePath: "assets/static/500.html");
                      }
                    }, */
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
