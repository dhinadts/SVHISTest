import 'dart:io';

import '../login/login_screen.dart';
import '../login/utils.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupInappWebview extends StatefulWidget {
  final String departmentName;
  final String clientId;

  const SignupInappWebview(
      {Key key, @required this.departmentName, @required this.clientId})
      : super(key: key);
  @override
  _SignupInappWebviewState createState() => _SignupInappWebviewState();
}

class _SignupInappWebviewState extends State<SignupInappWebview> {
  InAppWebViewController _webViewController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<String> appColor;

  String departmentName;
  String environmentShortCode;
  bool _isLoading = true;
  @override
  void initState() {
    appColor = getColor();
    // if(AppPreferences().promoDeparmentName!=AppPreferences().deptmentName){
    departmentName = AppPreferences().promoDeparmentName;
    environmentShortCode = AppPreferences().environmentShortCode;
    // }else{
    // departmentName="null";
    // }
    print(
        "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?"
        "clientId=${widget.clientId}"
        "&departmentName=${widget.departmentName}"
        "&userName=null&page=signup"
        "&rootdepartmentName=${departmentName}"
        "&loggedInRole=null"
        "&mode=null"
        "&env_code=$environmentShortCode");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    await AppPreferences.setCountry("");
    return true; // return true if the route to be popped
  }

  Future<String> getColor() async {
    var data = await AppPreferences.getAppColor();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: FutureBuilder(
          future: appColor,
          builder: (context, snp) {
            // print(snp.data);
            if (snp.connectionState == ConnectionState.done && snp.hasData) {
              return Scaffold(
                  key: _scaffoldKey,
                  appBar: new AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: HexColor(snp.data),
                    centerTitle: true,
                    title: new Text(
                        AppLocalizations.of(context).translate("key_signup"),
                        style: TextStyle(color: Colors.white)),
                  ),
                  body: SafeArea(
                      child: Container(
                          child: Stack(children: [
                    InAppWebView(
                      initialUrl:
                          // "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_editorial.html?"
                          // "clientId=${widget.clientId}"
                          // "&departmentName=${widget.departmentName}"
                          // "&userName=null&page=signup"
                          // "&rootdepartmentName=${departmentName}"
                          // "&env_code=$environmentShortCode",
                          widget.departmentName == "SVHISTest"
                              ? "${AppPreferences().hostUrl}/sites/STV/signUpMessage.html"
                              : "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?"
                                  "clientId=${widget.clientId}"
                                  "&departmentName=${widget.departmentName}"
                                  "&userName=null&page=signup"
                                  "&rootdepartmentName=${departmentName}"
                                  "&loggedInRole=null"
                                  "&mode=null"
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

                        _webViewController.addJavaScriptHandler(
                          handlerName: "OutNavHandler",
                          callback: (args) {
                            if (args.isNotEmpty) {
                              launch(args[0]);
                            }
                          },
                        );

                        _webViewController.addJavaScriptHandler(
                            handlerName: "userMembershipHandlerWithArgs",
                            callback: (args) {
                              debugPrint("SignUp page Testing");
                              debugPrint(args.toString());
                              // debugPrint(args[0]);

                              if (args.isNotEmpty) {
                                int statusCode = args[0];
                                if (statusCode == 201 || statusCode == 200) {
                                  Utils.toasterMessage(
                                      AppLocalizations.of(context).translate(
                                          "key_usercreatedsuccessfully"));
                                  AppPreferences.setSignUpStatus(true);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      ModalRoute.withName(Routes.login));
                                } else {
                                  Map<String, dynamic> response = args[1];
                                  String messageBody = response["message"];
                                  // print("messageBody");
                                  // print(messageBody);
                                  // print(response);
                                  AlertUtils.showAlertDialog(
                                      context,
                                      (messageBody != null &&
                                              messageBody.isNotEmpty)
                                          ? messageBody
                                          : AppLocalizations.of(context)
                                              .translate(
                                                  "key_somethingwentwrong"));
                                }
                              }
                            });
                      },
                      onLoadStart:
                          (InAppWebViewController controller, String url) {
                        debugPrint("onLoadStart $url");
                      },
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {
                        debugPrint("onLoadStop $url");
                        _isLoading = false;
                        setState(() {});
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {},
                      onUpdateVisitedHistory:
                          (InAppWebViewController controller, String url,
                              bool androidIsReload) {
                        debugPrint("onUpdateVisitedHistory $url");
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        debugPrint("consoleMessage --> $consoleMessage");
                      },
                      /* onLoadHttpError:
                          (controller, url, errorCode, errorMessage) {
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
                  ]))));
            } else {
              return Scaffold(body: Container());
            }
          }),
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
