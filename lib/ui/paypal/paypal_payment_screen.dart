import 'dart:convert';
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

class PayPalPaymentScreen extends StatefulWidget {
  final Function(bool) paymentStatus;
  final PaymentInfo paymentInfo;

  const PayPalPaymentScreen({Key key, this.paymentInfo, this.paymentStatus})
      : super(key: key);

  @override
  _PayPalPaymentScreenState createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  bool showCloseBtn = false;
  String userFullName = "";
  String userName = "";

  @override
  void initState() {
    super.initState();

    debugPrint("Payment Informations inside PAYAPAL    " +
        jsonEncode(widget.paymentInfo));
    debugPrint("URL inside PAYPAL ---->    ");
    debugPrint(AppPreferences().apiURL +
        "/filing" +
        "/payment/PYPL/initiate?" +
        "total=${widget.paymentInfo.totalAmount}&phone=${widget.paymentInfo.payeePhoneNumber}&name=${widget.paymentInfo.payeeName}&department_name=${widget.paymentInfo.departmentName}&email=${widget.paymentInfo.payeeEmail}&payment_source=${widget.paymentInfo.paymentSource}&request_id=${widget.paymentInfo.requestId}&currency=${widget.paymentInfo.currency}&payment_description=${widget.paymentInfo.paymentDescription}&transaction_type=${widget.paymentInfo.transactionType}&");
    debugPrint("${WebserviceConstants.userFullNameParam}$userFullName");

    getuserFullName();
  }

  Future<void> getuserFullName() async {
    UserInfo userInfo = await AppPreferences.getUserInfo();
    userName = await AppPreferences.getUsername();

    if (userInfo.firstName != null) userFullName += userInfo.firstName + " ";
    if (userInfo.lastName != null) userFullName += userInfo.lastName;

    setState(() {});

    /* UserInfo userInfo = await AppPreferences.getUserInfo();
userName = await AppPreferences.getUsername();
    if (userInfo.userFullName != null) {
      userFullName = userInfo.userFullName;
    } else {
      if (userInfo.firstName != null) userFullName += userInfo.firstName + " ";
      if (userInfo.lastName != null) userFullName += userInfo.lastName;
    }

    setState(() {}); */
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
                            initialUrl: AppPreferences().apiURL +
                                "/filing" +
                                "/payment/PYPL/initiate?" +
                                "total=${widget.paymentInfo.totalAmount}&phone=${widget.paymentInfo.payeePhoneNumber}&name=${widget.paymentInfo.payeeName}&department_name=${widget.paymentInfo.departmentName}&email=${widget.paymentInfo.payeeEmail}&payment_source=${widget.paymentInfo.paymentSource}&request_id=${widget.paymentInfo.requestId}&currency=${widget.paymentInfo.currency}&payment_description=${widget.paymentInfo.paymentDescription}&transaction_type=${widget.paymentInfo.transactionType}&${WebserviceConstants.userFullNameParam}$userFullName&user_name=$userName",
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
                            },
                            onLoadStart: (InAppWebViewController controller,
                                String url) async {
                              setState(() {
                                this.url = url;
                                debugPrint("onLoadStart --> $url");
                                final uri = Uri.parse(url);
                                if (uri.queryParameters
                                    .containsKey('PayerID')) {
                                  final payerID =
                                      uri.queryParameters['PayerID'];
                                  if (payerID != null) {
                                    Future.delayed(
                                        const Duration(milliseconds: 5),
                                        () async {
                                      setState(() {
                                        showCloseBtn = true;
                                      });
                                    });
                                  }
                                }
                              });
                            },
                            onLoadStop: (InAppWebViewController controller,
                                String url) async {
                              setState(() {
                                this.url = url;
                                debugPrint("onLoadStop --> $url");
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
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
