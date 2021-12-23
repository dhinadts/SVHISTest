import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../utils/app_preferences.dart';
import '../repo/common_repository.dart';
import '../utils/alert_utils.dart';
import '../utils/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ElectionPollInAppWebView extends StatefulWidget {
  @override
  _ElectionPollInAppWebViewState createState() =>
      _ElectionPollInAppWebViewState();
}

class _ElectionPollInAppWebViewState extends State<ElectionPollInAppWebView> {
  String membershipId = "";
  String registerNumber = "";
  bool error = false;
  bool isLoading = true;
  InAppWebViewController _webViewController;
  @override
  initState() {
    getMembershipAndRegistrationNumber();
    super.initState();
  }

  getMembershipAndRegistrationNumber() async {
    http.Response response = await http.get(WebserviceConstants.baseFilingURL +
        "/membership/form/departments/${AppPreferences().deptmentName}/users/${AppPreferences().username}");
    setState(() {
      if (response.statusCode == 200) {
        isLoading = false;
        var resp = json.decode(response.body);
        membershipId = resp["membershipId"];
        registerNumber = resp["registeredNurse"];
      } else {
        isLoading = false;
        error = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Election Poll",
        pageId: null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error
              ? Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Error Loading the page")]),
                  ),
                )
              : InAppWebView(
                  initialUrl:
                      "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/election_poll.html?"
                      "firstName=${AppPreferences().userInfo.firstName}"
                      "&lastName=${AppPreferences().userInfo.lastName}"
                      "&membershipId=${membershipId}"
                      "&rnNumber=${registerNumber}",
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;

                    _webViewController.addJavaScriptHandler(
                        handlerName: "HandlerQuestionnaireWithArgs",
                        callback: (args) {
                          int statusCode = args[0];
                          // print("===> Ststuas code inappview");
                          // print(statusCode);
                          String toastMsg =
                              "Election Poll created successfully";
                          String toastMsg1 =
                              "Election Poll updated successfully";
                          if (statusCode == 200 || statusCode == 204) {
                            Fluttertoast.showToast(
                                msg: toastMsg1,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 5,
                                gravity: ToastGravity.TOP);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NavigationHomeScreen()),
                                ModalRoute.withName(
                                    Routes.navigatorHomeScreen));
                          } else if (statusCode == 201 || statusCode == 202) {
                            Fluttertoast.showToast(
                                msg: statusCode == 200 ? toastMsg1 : toastMsg,
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 5,
                                gravity: ToastGravity.TOP);

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NavigationHomeScreen()),
                                ModalRoute.withName(
                                    Routes.navigatorHomeScreen));
                          } else {
                            Map<String, dynamic> obj = args[1];

                            String errorMsg = obj['message'] as String;
                            if (errorMsg != null && errorMsg.isNotEmpty) {}
                            AlertUtils.showAlertDialog(
                                context,
                                errorMsg != null && errorMsg.isNotEmpty
                                    ? errorMsg
                                    : AppPreferences().getApisErrorMessage);
                          }
                        });
                  },
                ),
    );
  }
}
