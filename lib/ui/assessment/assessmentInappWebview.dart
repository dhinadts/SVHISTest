import '../advertise/adWidget.dart';
import '../custom_drawer/custom_app_bar.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import '../custom_drawer/navigation_home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PatientAssessmentInappWebview extends StatefulWidget {
  final String title;
  final String departmentName;
  final String userName;
  final String emailId;
  final String mobileNo;
  final String formId;
  final String userCategory;

  const PatientAssessmentInappWebview(
      {Key key,
      this.title,
      this.departmentName,
      this.userName,
      this.emailId,
      this.userCategory,
      this.formId,
      this.mobileNo})
      : super(key: key);
  @override
  _PatientAssessmentInappWebviewState createState() =>
      _PatientAssessmentInappWebviewState();
}

class _PatientAssessmentInappWebviewState
    extends State<PatientAssessmentInappWebview> {
  InAppWebViewController _webViewController;

  String environmentShortCode;
  String url = "";

  @override
  void initState() {
    environmentShortCode = AppPreferences().environmentShortCode;
    if (widget.formId == null) {
      url =
          "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/SleepApnea.html?"
          "departmentName=${widget.departmentName}"
          "&userName=${widget.userName}"
          "&emailId=${widget.emailId}"
          "&mobileNo=${widget.mobileNo}";
    } else {
      url =
          "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?"
          "departmentName=${widget.departmentName}"
          "&userName=${widget.userName}"
          "&env_code=$environmentShortCode&formID=${widget.formId}&userCategory=${widget.userCategory}";
    }

    super.initState();

    initializeAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: widget.title == null ? "Assessment" : widget.title,
          pageId: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: InAppWebView(
                  initialUrl:
                      // "https://memberly-app.github.io/sites/ISDHealth/SleepApnea.html",
                      url,
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                          debuggingEnabled: true,
                          minimumFontSize: 100,
                          cacheEnabled: true,
                          clearCache: false,
                          preferredContentMode:
                              UserPreferredContentMode.MOBILE),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;

                    _webViewController.addJavaScriptHandler(
                        handlerName: "HandlerQuestionnaireWithArgs",
                        callback: (args) {
                          int statusCode = args[0];
                          print("===> Ststuas code inappview");
                          print(statusCode);
                          String toastMsg = "Assessment created successfully";
                          String toastMsg1 = "Assessment updated successfully";
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
                  onLoadStart: (InAppWebViewController controller, String url) {
                    debugPrint("onLoadStart $url");
                  },
                  onLoadStop:
                      (InAppWebViewController controller, String url) async {
                    debugPrint("onLoadStop $url");
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
              ),

              /// Show Banner Ad
              getSivisoftAdWidget(),
            ],
          ),
        ));
  }
}
