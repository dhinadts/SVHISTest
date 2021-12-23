import 'dart:convert';

import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/membership/api/membership_api_client.dart';
import '../../ui/membership/membership_card_screen.dart';
import '../../ui/membership/model/membership_info.dart';
import '../../ui/membership/repo/membership_repo.dart';
import '../../ui/membership/widgets/payments_widget_new.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import 'membership_benefits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

const String APPROVED = "Approved";

class MembershipInappWebviewScreen extends StatefulWidget {
  final String clientId;
  final String departmentName;
  final String userName;
  final String loggedInRole;
  final String membershipId;
  final MembershipInfo membershipInfo;
  final String title;
  final String memberShipEnableMode;

  const MembershipInappWebviewScreen(
      {Key key,
      @required this.clientId,
      @required this.departmentName,
      @required this.userName,
      @required this.loggedInRole,
      @required this.membershipId,
      this.title,
      this.memberShipEnableMode,
      this.membershipInfo})
      : super(key: key);
  @override
  _MembershipInappWebviewScreenState createState() =>
      _MembershipInappWebviewScreenState();
}

class _MembershipInappWebviewScreenState
    extends State<MembershipInappWebviewScreen> {
  InAppWebViewController _webViewController;

  bool _isCancelled;
  http.Response _httpResponse;
  String _receiptNumber;
  var popupMenuList = List<PopupMenuEntry<Object>>();
  String departmentName;
  String environmentShortCode = "";
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    //getCameraPermission();
    showMemebershipBenefitsOption();
    // if(AppPreferences().promoDeparmentName!=AppPreferences().deptmentName){
    departmentName = AppPreferences().promoDeparmentName;
    environmentShortCode = AppPreferences().environmentShortCode;
    // }else{
    // departmentName="null";
    // }
    // print(
    //     "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/member_editorial.html?clientId=${widget.clientId}&departmentName=${widget.departmentName}&userName=${widget.userName}&loggedInRole=${widget.loggedInRole}&membershipId=${widget.membershipId}&rootdepartmentName=${departmentName}&mode=${widget.memberShipEnableMode}&env_code=$environmentShortCode");

    /// Initialize Admob
    initializeAd();
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
      if (popupMenuList.length > 0) {
        popupMenuList.add(
          PopupMenuDivider(
            height: 10,
          ),
        );
      }

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

  // getCameraPermission() async {
  //   PermissionHandler permissionHandler = PermissionHandler();
  //   PermissionStatus permissionStatus =
  //       await permissionHandler.checkPermissionStatus(PermissionGroup.camera);
  //   permissionStatus = (await permissionHandler
  //       .requestPermissions([PermissionGroup.camera]))[PermissionGroup.camera];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("Membership Information"),
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
                          builder: (context) => MembershipCardScreen(
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: Stack(children: [
                InAppWebView(
                  // TODO: Dynamic URL formation
                  // initialUrl:"${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/${AppPreferences().deptmentName}-Membership.html?clientId=${widget.clientId}&departmentName=${widget.departmentName}&userName=${widget.userName}&loggedInRole=${widget.loggedInRole}&membershipId=${widget.membershipId}",
                  initialUrl:
                      "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/member_editorial.html?clientId=${widget.clientId}&departmentName=${widget.departmentName}&userName=${widget.userName}&loggedInRole=${widget.loggedInRole}&membershipId=${widget.membershipId}&rootdepartmentName=${departmentName}&mode=${widget.memberShipEnableMode}&env_code=$environmentShortCode",
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
                      android: AndroidInAppWebViewOptions()),
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
                                              "_receiptNumber 16Nov---> $_receiptNumber");
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
                        handlerName: "handlerMembershipWithArgs",
                        callback: (args) {
                          if (args.isNotEmpty) {
                            int statusCode = args[0];
                            String toastMsg = "Membership added successfully";
                            String toastMsg1 =
                                "Membership updated successfully";
                            if (statusCode == 200 || statusCode == 204) {
                              Fluttertoast.showToast(
                                  msg: toastMsg1,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                  gravity: ToastGravity.TOP);

                              if (AppPreferences().role ==
                                  Constants.supervisorRole) {
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationHomeScreen()),
                                    ModalRoute.withName(
                                        Routes.navigatorHomeScreen));
                              }
                            } else if (statusCode == 201 || statusCode == 202) {
                              Fluttertoast.showToast(
                                  msg: statusCode == 200 ? toastMsg1 : toastMsg,
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 5,
                                  gravity: ToastGravity.TOP);

                              if (AppPreferences().role ==
                                  Constants.supervisorRole) {
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationHomeScreen()),
                                    ModalRoute.withName(
                                        Routes.navigatorHomeScreen));
                              }
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
                  /*  onLoadHttpError: (controller, url, errorCode, errorMessage) {
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
            getSivisoftAdWidget(),
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

// @override
// Widget build(BuildContext context) {
//   // TODO: implement build
//   throw UnimplementedError();
// }
