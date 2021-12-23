import 'dart:convert';

import '../../bloc/auth_bloc.dart';
import '../../model/user_info.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/membership/membership_benefits.dart';
import '../../ui/membership/membership_card_screen.dart';
import '../../ui/membership/membership_inapp_webview_screen.dart';
import '../../ui/membership/model/membership_info.dart';
import '../../ui/membership/widgets/payments_widget_new.dart';
import '../../ui/people_list_page.dart';
import '../../ui/tabs/user_info_membership_card.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'app_localizations.dart';

class UserInfoTabInappWebview extends StatefulWidget {
  final String departmentName;
  final String userName;
  final String clientId;
  final String title;
  final UserInfoMemberShipObject membershipInfo;
  final bool superProfile;

  const UserInfoTabInappWebview(
      {Key key,
      @required this.departmentName,
      @required this.userName,
      @required this.clientId,
      this.membershipInfo,
      this.superProfile,
      this.title})
      : super(key: key);

  @override
  _UserInfoTabInappWebviewState createState() =>
      _UserInfoTabInappWebviewState();
}

class _UserInfoTabInappWebviewState extends State<UserInfoTabInappWebview> {
  InAppWebViewController _webViewController;

  bool _isCancelled;
  http.Response _httpResponse;
  String _receiptNumber;
  String role;
  String departmentName;
  String environmentShortCode;
  bool _isLoading = true;
  var popupMenuList = List<PopupMenuEntry<Object>>();
  List<String> membershipFlow;
  String subMainDept = "";
  UserInfo nameLoggedIn;
  @override
  void initState() {
    super.initState();
    // if(AppPreferences().promoDeparmentName!=AppPreferences().deptmentName){

    departmentName = AppPreferences().promoDeparmentName;
    environmentShortCode = AppPreferences().environmentShortCode;
    role = AppPreferences().role;
    subMainDept = AppPreferences().deptmentName;
    nameLoggedIn = AppPreferences().userInfo;
    // }else{
    // departmentName="null";
    // }
    // print("Testing IN DHINAKNANAKKAN");
    // print("subMainDept --$subMainDept");
    // print("departmentName ---> $departmentName");
    // print(nameLoggedIn.toJson());
    // print(widget.membershipInfo.membershipStatus);

    // print(
    //   "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?"
    //   "clientId=${widget.clientId}"
    //   "&departmentName=${widget.departmentName}"
    //   "&userName=${widget.userName}"
    //   "&loggedInRole=${role}"
    //   "&page=editUser"
    //   "&subMainDept=$subMainDept"
    //   "&rootdepartmentName=${departmentName}"
    //   "&mode=Edit"
    //   "&env_code=$environmentShortCode",
    // );
    getMembershipFlow();
    // initializeAd();
    showMemebershipBenefitsOption();
  }

  getMembershipFlow() async {
    membershipFlow = List<String>();
    membershipFlow = await AppPreferences.getMembershipWorkFlow();

    debugPrint("Membership flow --> $membershipFlow");
    debugPrint("Membership flow length --> ${membershipFlow.length}");
  }

  showMemebershipBenefitsOption() async {
    var data = await AppPreferences.getMembershipBenefitsContent();
    debugPrint("data --> $data");

    if (data != null && data.toString().isNotEmpty) {
      popupMenuList.add(
        PopupMenuItem(
          height: 20,
          child: Text(
            "Membership Benefits",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: -1,
        ),
      );
    }

    if (widget.membershipInfo != null &&
        widget.membershipInfo.membershipStatus == APPROVED) {
      print("widget.membershipInfo");
      print(widget.membershipInfo.membershipId);
      print(widget.membershipInfo.membershipStatus);

      popupMenuList.add(
        PopupMenuDivider(
          height: 10,
        ),
      );

      popupMenuList.add(
        PopupMenuItem(
          height: 20,
          child: Text(
            'Membership Card',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: 0,
        ),
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () async {
        //     if (AppPreferences().role == Constants.supervisorRole) {
        //       await Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => NavigationHomeScreen(
        //                     drawerIndex: Constants.PAGE_ID_PEOPLE_LIST,
        //                   )),
        //           ModalRoute.withName(Routes.navigatorHomeScreen));
        //     } else {
        //       Navigator.pop(context);
        //     }
        //   },
        // ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(widget.title != null ? widget.title : "Profile"),
        actions: popupMenuList.length > 0
            ? [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return popupMenuList;
                  },
                  onCanceled: () {},
                  onSelected: (value) {
                    if (value != 0) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MembershipBenefits(),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserInfoMembershipCardScreen(
                              membershipInfo: widget.membershipInfo),
                        ),
                      );
                    }
                  },
                  offset: Offset(0, 50),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const ShapeDecoration(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      // color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigationHomeScreen(
                                  drawerIndex: Constants.PAGE_ID_HOME,
                                )),
                        ModalRoute.withName(Routes.navigatorHomeScreen));
                  },
                )
              ]
            : [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigationHomeScreen(
                                  drawerIndex: Constants.PAGE_ID_HOME,
                                )),
                        ModalRoute.withName(Routes.navigatorHomeScreen));
                  },
                )
              ],
      ),

      // AppBar(
      //   centerTitle: true,

      //   backgroundColor: AppColors.primaryColor,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back),
      //   onPressed: () async {
      //     if (AppPreferences().role == Constants.supervisorRole) {
      //       await Navigator.pushAndRemoveUntil(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => NavigationHomeScreen(
      //                     drawerIndex: Constants.PAGE_ID_PEOPLE_LIST,
      //                   )),
      //           ModalRoute.withName(Routes.navigatorHomeScreen));
      //     } else {
      //       Navigator.pop(context);
      //     }
      //   },
      // ),
      //   // title: Text(AppLocalizations.of(context).translate("key_profile")),
      //   title: Text(widget.title != null ? widget.title : "Profile"),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: Stack(children: [
                InAppWebView(
                  initialUrl:
                      // "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_editorial.html?"
                      // "clientId=${widget.clientId}"
                      // "&departmentName=${widget.departmentName}"
                      // "&userName=${widget.userName}"
                      // "&page=editUser"
                      // "&rootdepartmentName=${departmentName}"
                      // "&env_code=$environmentShortCode",
                      "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?"
                      "clientId=${widget.clientId}"
                      "&departmentName=${widget.departmentName}"
                      "&userName=${widget.userName}"
                      "&loggedInRole=${role}"
                      "&page=editUser"
                      "&subMainDept=$subMainDept"
                      "&rootdepartmentName=${departmentName}"
                      "&mode=Edit"
                      "&env_code=$environmentShortCode",
                  initialHeaders: {},
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
                                              "_receiptNumber --->54 $_receiptNumber");
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
                          // debugPrint("UserList Testing Payment");
                          // debugPrint("userMembershipHandlerWithArgs --> $args");
                          // debugPrint("User_info_inapp_webview");
                          // debugPrint("args --- $args");
                          // debugPrint("args --- ${args[2]}");
                          Map<String, dynamic> jsonS = args[1];
                          // debugPrint("Getting Json Keys");

                          // for (final name in jsonS.keys) {
                          //   final value = jsonS[name];
                          //   print(
                          //       '$name,$value'); // prints entries like "AED,3.672940"
                          // }

                          if (args.isNotEmpty && args[2] == false) {
                            int statusCode = args[0];
                            String toastMsg = "User updated successfully";
                            String toastMsg1 =
                                "Membership updated successfully";
                            /* if (statusCode == 200 || statusCode == 204) {
                              Fluttertoast.showToast(
                                  msg: toastMsg1,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                  gravity: ToastGravity.TOP);

                              // if (AppPreferences().role ==
                              //     Constants.supervisorRole) {
                              //   Navigator.pop(context, true);
                              //                                 Navigator.pop(context, true);

                              // } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PeopleListPage()),
                                  ModalRoute.withName(Routes.peopleListScreen));
                              // }
                            } else if (statusCode == 201 || statusCode == 202) {
                              Fluttertoast.showToast(
                                  msg: statusCode == 200 ? toastMsg1 : toastMsg,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                  gravity: ToastGravity.TOP);

                              // if (AppPreferences().role ==
                              //     Constants.supervisorRole) {
                              //   Navigator.pop(context, true);
                              // } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PeopleListPage()),
                                  ModalRoute.withName(Routes.peopleListScreen));
                              // }
                            } */
                            if ((jsonS["membershipApprovalStatus"] == null ||
                                    jsonS["membershipApprovalStatus"].isEmpty ||
                                    jsonS["membershipApprovalStatus"] == "") &&
                                (statusCode > 199 && statusCode < 300)) {
                              Fluttertoast.showToast(
                                  msg: toastMsg,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                  gravity: ToastGravity.TOP);
                              if (AppPreferences().role ==
                                  Constants.supervisorRole) {
                                if ((widget.superProfile == null ||
                                    widget.superProfile == false)) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationHomeScreen(
                                                drawerIndex: Constants
                                                    .PAGE_ID_PEOPLE_LIST,
                                              )),
                                      ModalRoute.withName(
                                          Routes.navigatorHomeScreen));
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationHomeScreen()),
                                      ModalRoute.withName(
                                          Routes.navigatorHomeScreen));
                                }
                              } else
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationHomeScreen()),
                                    ModalRoute.withName(
                                        Routes.navigatorHomeScreen));
                            } else if (membershipFlow
                                .contains(jsonS["membershipApprovalStatus"]))

                            /* jsonS["membershipApprovalStatus"] == "Rejected" ||
                                jsonS["membershipApprovalStatus"] ==
                                    "Approved" ||
                                jsonS["membershipApprovalStatus"] ==
                                    "Pending Payment" ||
                                jsonS["membershipApprovalStatus"] ==
                                    "Under Review" ||
                                jsonS["membershipApprovalStatus"] ==
                                    "Pending Approval") */
                            {
                              Fluttertoast.showToast(
                                  msg: toastMsg1,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                  gravity: ToastGravity.TOP);

                              if (AppPreferences().role ==
                                  Constants.supervisorRole) {
                                if ((widget.superProfile == null ||
                                    widget.superProfile == false)) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationHomeScreen(
                                                drawerIndex: Constants
                                                    .PAGE_ID_PEOPLE_LIST,
                                              )),
                                      ModalRoute.withName(
                                          Routes.navigatorHomeScreen));
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NavigationHomeScreen()),
                                      ModalRoute.withName(
                                          Routes.navigatorHomeScreen));
                                }
                              } else
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
                            debugPrint(args[1].toString());
                            debugPrint(args[0]);
                            Map<String, dynamic> paymentData = args[1];
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
                                                "_receiptNumber -5--> $_receiptNumber");
                                          },
                                          phoneNumber: payeePhoneNumber,
                                          totalAmount: totalAmount,
                                          transactionType:
                                              TransactionType.MEMBERSHIP,
                                          currency: currency,
                                          paymentDescription:
                                              paymentDescription,
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
              ])),
            ),

            /// Show Banner Ad
            // getSivisoftAdWidget(),
          ],
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
