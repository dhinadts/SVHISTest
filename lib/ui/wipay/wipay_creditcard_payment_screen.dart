import 'dart:io';

import '../../model/user_info.dart';
import '../../repo/common_repository.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../membership/model/payment_info.dart';
import 'dart:developer' as developer;

class WiPayCreditCardPaymentScreen extends StatefulWidget {
  final Function(bool) paymentStatus;
  final PaymentInfo paymentInfo;

  const WiPayCreditCardPaymentScreen(
      {Key key, this.paymentInfo, this.paymentStatus})
      : super(key: key);

  @override
  _WiPayCreditCardPaymentScreenState createState() =>
      _WiPayCreditCardPaymentScreenState();
}

class _WiPayCreditCardPaymentScreenState
    extends State<WiPayCreditCardPaymentScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  bool showCloseBtn = false;
  String userFullName = "";
  String userName = "";

  var showLoader = false;

  @override
  void initState() {
    super.initState();
    getuserFullName();
  }

  Future<void> getuserFullName() async {
    UserInfo userInfo = await AppPreferences.getUserInfo();
    userName = await AppPreferences.getUsername();

    if (userInfo.firstName != null) userFullName += userInfo.firstName + " ";
    if (userInfo.lastName != null) userFullName += userInfo.lastName;

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
                  Navigator.pop(context, true);
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => NavigationHomeScreen()),
                  //     ModalRoute.withName(Routes.dashBoard));
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
          backgroundColor: AppColors.primaryColor,
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
                    child: userFullName != null && userFullName.length > 0
                        ? InAppWebView(
                            // initialUrl: "https://qa.servicedx.com/filing/payment/wpi/initiate?email=gowtham403481%40gmail.com&name=TestDK%20Test&payment_source=MOBILE&phone=7548848772&request_id=29c8ea34-4020-4d85-a965-fa1e044d91f5&total=140",
                            initialUrl: AppPreferences().apiURL +
                                "/filing" +
                                "/payment/wpi/initiate?" +
                                "total=${widget.paymentInfo.totalAmount.toInt()}&phone=${widget.paymentInfo.payeePhoneNumber}&name=${widget.paymentInfo.payeeName}&department_name=${widget.paymentInfo.departmentName}&email=${widget.paymentInfo.payeeEmail}&payment_source=${widget.paymentInfo.paymentSource}&request_id=${widget.paymentInfo.requestId}&currency=${widget.paymentInfo.currency}&payment_description=${widget.paymentInfo.paymentDescription}&transaction_type=${widget.paymentInfo.transactionType}&${WebserviceConstants.userFullNameParam}$userFullName&user_name=$userName",
                            initialHeaders: {},
                            initialOptions: InAppWebViewGroupOptions(
                                crossPlatform: InAppWebViewOptions(
                              debuggingEnabled: true,
                              supportZoom: false,
                            )),
                            onWebViewCreated:
                                (InAppWebViewController controller) {
                              webView = controller;
                            },
                            iosOnDidReceiveServerRedirectForProvisionalNavigation:
                                (value) async {
                              debugPrint(
                                  "iosOnDidReceiveServerRedirectForProvisionalNavigation  --> ${await value.getUrl()}");

                              String returnUrl =
                                  Uri.decodeFull(await value.getUrl());
                              if (returnUrl.contains("status=success") ||
                                  returnUrl.contains("status=failed")) {
                                Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  setState(() {
                                    showCloseBtn = true;
                                  });
                                });
                              }
                            },
                            onLoadStart: (InAppWebViewController controller,
                                String url) async {
                              setState(() {
                                this.url = url;
                                if (Platform.isAndroid) {
                                  if (url.contains("status=success") ||
                                      url.contains("status=failed")) {
                                    // setState(() {
                                    //   showLoader = true;
                                    // });
                                    // Future.delayed(const Duration(seconds: 10),
                                    //     () async {
                                    //   setState(() {
                                    //     showCloseBtn = true;
                                    //     showLoader = false;
                                    //   });
                                    // });
                                  }
                                }
                                debugPrint("onLoadStart --> $url");
                              });
                            },
                            onLoadStop: (InAppWebViewController controller,
                                String url) async {
                              setState(() {
                                this.url = url;
                                debugPrint("onLoadStop --> $url");
                                if (url.endsWith('processed')) {
                                  setState(() {
                                    showLoader = true;
                                  });
                                  Future.delayed(const Duration(seconds: 7),
                                      () async {
                                    setState(() {
                                      showCloseBtn = true;
                                      showLoader = false;
                                    });
                                  });
                                }
                              });
                            },
                            onProgressChanged:
                                (InAppWebViewController controller,
                                    int progress) {
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
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
              ],
            ),
            showLoader
                ? Container(
                    color: Color(0x80000000),
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 12,
                          ),
                          Text('Please wait ...'),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
