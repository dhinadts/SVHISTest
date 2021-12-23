import 'dart:convert';

import '../ui/tabs/app_localizations.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_drawer/custom_app_bar.dart';
import 'custom_drawer/navigation_home_screen.dart';
import 'membership/widgets/payments_widget_new.dart';

import 'package:http/http.dart' as http;

bool toastmsg = false;

class UserInformationInappWebViewScreen extends StatefulWidget {
  final String departmentName;
  final String clientId;
  final String title;

  const UserInformationInappWebViewScreen(
      {Key key,
      @required this.departmentName,
      @required this.clientId,
      this.title})
      : super(key: key);

  @override
  _UserInformationInappWebViewScreenState createState() =>
      _UserInformationInappWebViewScreenState();
}

class _UserInformationInappWebViewScreenState
    extends State<UserInformationInappWebViewScreen> {
  InAppWebViewController _webViewController;

  bool _isCancelled;
  http.Response _httpResponse;
  String _receiptNumber;
  String role;
  String departmentName;
  String environmentShortCode;
  bool _isLoading = true;
  List<String> membershipFlow;
  @override
  void initState() {
    super.initState();

    // if(AppPreferences().promoDeparmentName!=AppPreferences().deptmentName){
    departmentName = AppPreferences().promoDeparmentName;
    environmentShortCode = AppPreferences().environmentShortCode;
    role = AppPreferences().role;
    // }else{
    // departmentName="null";
    // }
    getMembershipFlow();
  }

  getMembershipFlow() async {
    membershipFlow = List<String>();
    membershipFlow = await AppPreferences.getMembershipWorkFlow();

    debugPrint("Membership flow --> $membershipFlow");
    debugPrint("Membership flow length --> ${membershipFlow.length}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.title,
          // AppLocalizations.of(context).translate("key_userinformation"),
          pageId: Constants.PAGE_ID_ADD_A_PERSON),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              InAppWebView(
                initialUrl:
                    // "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_editorial.html?"
                    // "clientId=${widget.clientId}"
                    // "&departmentName=${widget.departmentName}"
                    // "&userName=null"
                    // "&page=addUser"
                    // "&rootdepartmentName=${departmentName}"
                    // "&env_code=$environmentShortCode",
                    "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?"
                    "clientId=${widget.clientId}"
                    "&departmentName=${widget.departmentName}"
                    "&userName=null"
                    "&loggedInRole=User"
                    "&page=addUser"
                    "&mode=null"
                    "&rootdepartmentName=${departmentName}"
                    "&env_code=$environmentShortCode",
                initialHeaders: {},
                contextMenu: ContextMenu(),
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      clearCache: true,
                      javaScriptEnabled: true,
                      supportZoom: false,
                    ),
                    android: AndroidInAppWebViewOptions(
                      useHybridComposition: true,
                    )),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;

                  // _webViewController.addJavaScriptHandler(
                  //     handlerName: "userMembershipHandlerWithArgs",
                  //     callback: (args) {
                  //       debugPrint("DHinakaran Testing");
                  //       debugPrint("userMembershipHandlerWithArgs --> $args");
                  //       if (args.isNotEmpty) {
                  //         int statusCode = args[0];
                  //         Map<String, dynamic> response = args[1];
                  //         // debugPrint("response --> $response");
                  //         if (statusCode == 201 || statusCode == 200) {
                  //           Fluttertoast.showToast(
                  //               msg: AppLocalizations.of(context)
                  //                   .translate("key_usercreatedsuccessfully"),
                  //               toastLength: Toast.LENGTH_LONG,
                  //               timeInSecForIosWeb: 5,
                  //               gravity: ToastGravity.TOP);

                  //           /*String userName = response["userName"];
                  //       String gender = response["gender"];
                  //       Navigator.pushNamed(context, Routes.historyScreen,
                  //           arguments: Args(
                  //               arg: null, username: userName, gender: gender));*/
                  //           Navigator.pushAndRemoveUntil(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       NavigationHomeScreen()),
                  //               ModalRoute.withName(Routes.dashBoard));
                  //         } else {
                  //           String messageBody = response["message"];
                  //           AlertUtils.showAlertDialog(
                  //               context,
                  //               (messageBody != null && messageBody.isNotEmpty)
                  //                   ? messageBody
                  //                   : AppLocalizations.of(context)
                  //                       .translate("key_somethingwentwrong"));
                  //         }
                  //       }
                  //     });

                  _webViewController.addJavaScriptHandler(
                    handlerName: "handlerPayWithArgs",
                    callback: (args) async {
                      debugPrint("handlerPayWithArgs --> $args");

                      if (args.isNotEmpty) {
                        Map<String, dynamic> paymentData = args[0];
                        if (paymentData != null) {
                          String payeeName =
                              paymentData.containsKey("payeeName")
                                  ? paymentData["payeeName"]
                                  : "";
                          double totalAmount =
                              paymentData.containsKey("totalAmount")
                                  ? double.tryParse(
                                      paymentData["totalAmount"].toString())
                                  : 0.0;
                          String payeePhoneNumber =
                              paymentData.containsKey("payeePhoneNumber")
                                  ? paymentData["payeePhoneNumber"]
                                  : "";
                          String payeeEmail =
                              paymentData.containsKey("payeeEmail")
                                  ? paymentData["payeeEmail"]
                                  : "";
                          String paymentDescription =
                              paymentData.containsKey("paymentDescription")
                                  ? paymentData["paymentDescription"]
                                  : "";
                          String currency =
                              await AppPreferences.getDefaultCurrency();
                          _isCancelled = null;
                          _httpResponse = null;
                          _receiptNumber = null;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentsWidgetNew(
                                      email: payeeEmail,
                                      name: payeeName,
                                      paymentStatus: (bool isCancelled,
                                          http.Response httpResponse,
                                          String receiptNumber) {
                                        _isCancelled = isCancelled;
                                        _httpResponse = httpResponse;
                                        _receiptNumber = receiptNumber;

                                        debugPrint(
                                            "paymentStatus callback called....");
                                        debugPrint(
                                            "_isCancelled ---> $_isCancelled");
                                        if (_httpResponse != null) {
                                          debugPrint(
                                              "_httpResponse ---> ${jsonDecode(_httpResponse.body)}");
                                        }

                                        debugPrint(
                                            "_receiptNumber ---> 99 $_receiptNumber");
                                      },
                                      phoneNumber: payeePhoneNumber,
                                      totalAmount: totalAmount,
                                      transactionType:
                                          TransactionType.MEMBERSHIP,
                                      currency: currency,
                                      paymentDescription: paymentDescription,
                                      departmentName: widget.departmentName,
                                    ),
                                fullscreenDialog: true),
                          );

                          return {
                            'isCancelled': _isCancelled,
                            'receiptNumber': _receiptNumber,
                            'response': (_httpResponse != null)
                                ? jsonDecode(_httpResponse.body)
                                : _httpResponse,
                          };
                        }
                      }
                    },
                  );

                  _webViewController.addJavaScriptHandler(
                      handlerName: "userMembershipHandlerWithArgs",
                      callback: (args) async {
                        String toastMsg = "User created successfully";

                        String toastMsg2 = "Membership created successfully";

                        Map<String, dynamic> jsonS = args[1];
                        // // debugPrint("Getting Json Keys");
                        // print(jsonS.keys);
                        // for (final name in jsonS.keys) {
                        //   final value = jsonS[name];
                        //   print(
                        //       '$name,$value'); // prints entries like "AED,3.672940"
                        // }
// membershipApprovalStatus = "" ++ membershipApprovalStatus = ""

                        if (args.isNotEmpty && args[2] == false) {
                          int statusCode = args[0];
                          // debugPrint("statusCode  -- ${statusCode}");

                          if ((jsonS["membershipApprovalStatus"] == null ||
                                  jsonS["membershipApprovalStatus"].isEmpty ||
                                  jsonS["membershipApprovalStatus"] == "") &&
                              (statusCode > 199 && statusCode < 300)) {
                            // debugPrint(
                            //     "membershipApprovalStatus  -- ${jsonS["membershipApprovalStatus"]}");
                            Fluttertoast.showToast(
                                msg: toastMsg,
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
                          } else if (membershipFlow
                              .contains(jsonS["membershipApprovalStatus"]))
                          /* 
                            jsonS["membershipApprovalStatus"] == "Rejected" ||
                              jsonS["membershipApprovalStatus"] == "Approved" ||
                              jsonS["membershipApprovalStatus"] ==
                                  "Pending Payment" ||
                              jsonS["membershipApprovalStatus"] ==
                                  "Under Review" ||
                              jsonS["membershipApprovalStatus"] ==
                                  "Pending Approval") */
                          {
                            Fluttertoast.showToast(
                                msg: toastMsg2,
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
                          }
                          /* if (statusCode == 200 || statusCode == 204) {
                          }  */
                          // else if (statusCode == 201 || statusCode == 202) {
                          else {
                            Map<String, dynamic> obj = args[1];

                            String errorMsg = obj['message'] as String;
                            if (errorMsg != null &&
                                errorMsg.isNotEmpty &&
                                errorMsg == "Receipt No Already Exists") {}
                            AlertUtils.showAlertDialog(
                                context,
                                errorMsg != null && errorMsg.isNotEmpty
                                    ? errorMsg
                                    : AppPreferences().getApisErrorMessage);
                          }
                        } else {
                          debugPrint("Payment options");
                          // debugPrint(args[2].toString());
                          // debugPrint(args[1].toString());
                          // debugPrint(jsonEncode(args[1]));

                          // debugPrint(args[0]);
                          Map<String, dynamic> paymentData = args[1];
                          // print(payment);
                          if (paymentData != null) {
                            String payeeName =
                                paymentData.containsKey("payeeName")
                                    ? paymentData["payeeName"]
                                    : "";
                            double totalAmount =
                                paymentData.containsKey("totalAmount")
                                    ? double.tryParse(
                                        paymentData["totalAmount"].toString())
                                    : 0.0;
                            String payeePhoneNumber =
                                paymentData.containsKey("payeePhoneNumber")
                                    ? paymentData["payeePhoneNumber"]
                                    : "";
                            String payeeEmail =
                                paymentData.containsKey("payeeEmail")
                                    ? paymentData["payeeEmail"]
                                    : "";
                            String paymentDescription =
                                paymentData.containsKey("paymentDescription")
                                    ? paymentData["paymentDescription"]
                                    : "";
                            String currency =
                                await AppPreferences.getDefaultCurrency();
                            _isCancelled = null;
                            _httpResponse = null;
                            _receiptNumber = null;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentsWidgetNew(
                                        email: payeeEmail,
                                        name: payeeName,
                                        paymentStatus: (bool isCancelled,
                                            http.Response httpResponse,
                                            String receiptNumber) {
                                          _isCancelled = isCancelled;
                                          _httpResponse = httpResponse;
                                          _receiptNumber = receiptNumber;

                                          debugPrint(
                                              "paymentStatus callback called....");
                                          debugPrint(
                                              "_isCancelled ---> $_isCancelled");
                                          if (_httpResponse != null) {
                                            debugPrint(
                                                "_httpResponse ---> ${jsonDecode(_httpResponse.body)}");
                                          }

                                          debugPrint(
                                              "_receiptNumber --->tt $_receiptNumber");
                                        },
                                        phoneNumber: payeePhoneNumber,
                                        totalAmount: totalAmount,
                                        transactionType:
                                            TransactionType.MEMBERSHIP,
                                        currency: currency,
                                        paymentDescription: paymentDescription,
                                        departmentName: widget.departmentName,
                                      ),
                                  fullscreenDialog: true),
                            );

                            setState(() {
                              toastmsg = true;
                            });
                            return {
                              'isCancelled': _isCancelled,
                              'receiptNumber': _receiptNumber,
                              'response': (_httpResponse != null)
                                  ? jsonDecode(_httpResponse.body)
                                  : _httpResponse,
                            };
                          }
                        }
                      });
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  debugPrint("onLoadStart $url");
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  debugPrint("onLoadStop $url");
                  _isLoading = false;
                  setState(() {});
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {},
                onUpdateVisitedHistory: (InAppWebViewController controller,
                    String url, bool androidIsReload) {
                  debugPrint("onUpdateVisitedHistory $url");
                },
                onConsoleMessage: (controller, consoleMessage) {
                  debugPrint("consoleMessage --> $consoleMessage");
                },
                /* onLoadHttpError: (controller, url, errorCode, errorMessage) {
              if (errorCode >= 400 && errorCode <= 499) {
                _webViewController.loadFile(
                    assetFilePath: "assets/static/400.html");
              } else if (errorCode >= 500) {
                _webViewController.loadFile(
                    assetFilePath: "assets/static/500.html");
              }
            }, */
              ),
              _isLoading ? Center(child: centerLoader()) : Stack()
            ],
          ),
        ),
      ),
    );
  }

  Widget centerLoader() {
    return Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ));
  }
}
