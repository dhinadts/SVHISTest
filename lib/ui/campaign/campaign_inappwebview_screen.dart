import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CampaignInAppWebViewScreen extends StatefulWidget {
  // final CampaignModel campaignModel;
  final String userName;
  final String departmentName;
  final String referenceID;
  final bool enableFeedback;

  CampaignInAppWebViewScreen(
      {this.userName,
      this.departmentName,
      this.referenceID,
      this.enableFeedback});

  @override
  _CampaignInAppWebViewScreenState createState() =>
      _CampaignInAppWebViewScreenState();
}

class _CampaignInAppWebViewScreenState
    extends State<CampaignInAppWebViewScreen> {
  InAppWebViewController _webViewController;
  String environmentShortCode;
  String formID_user_category = '';
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    environmentShortCode = AppPreferences().environmentShortCode;
    if (widget.referenceID != null) {
      formID_user_category =
          '&formID=${widget.referenceID}&userCategory=${AppPreferences().userCategory}';
    }
    // printing();
  }

  printing() {
    print(widget.userName);
    print(widget.departmentName);

    print("widget.referenceID");
    print(widget.referenceID);
    print(
        "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?"
        "departmentName=${widget.departmentName}"
        "&userName=${widget.userName}"
        "&env_code=$environmentShortCode$formID_user_category");

    print(widget.enableFeedback != null &&
            widget.enableFeedback &&
            AppPreferences().userCategory.toLowerCase() == "doctor"
        ? "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?"
            "departmentName=${widget.departmentName}"
            "&userName=${widget.userName}"
            "&env_code=$environmentShortCode$formID_user_category"
            "&feedback=edit"
        : "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?"
            "departmentName=${widget.departmentName}"
            "&userName=${widget.userName}"
            "&env_code=$environmentShortCode$formID_user_category");
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(
    // "CAMPAIGN_FORMIO_URL : ${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/${widget.campaignModel.formName}.html?role=user&departmentName=${AppPreferences().deptmentName}&userName=${AppPreferences().username}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("Campaign"),
        actions: [
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              //replaceHome();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()),
                  ModalRoute.withName(Routes.dashBoard));
            },
          ),
        ],
      ),
      // https://memberly-app.github.io/sites/ISDHealth/Sleep-Apnea.html?role=user&departmentName=GNAT&userName=Charan
      body: SafeArea(
          child: Container(
              child: Stack(children: [
        InAppWebView(
          initialUrl:
              //  "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/${widget.campaignModel.formName}.html?role=user&departmentName=${AppPreferences().deptmentName}&userName=${AppPreferences().username}",
              widget.enableFeedback != null &&
                      widget.enableFeedback &&
                      AppPreferences().userCategory.toLowerCase() == "doctor"
                  ? "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?"
                      "departmentName=${widget.departmentName}"
                      "&userName=${widget.userName}"
                      "&env_code=$environmentShortCode$formID_user_category"
                      "&feedback=edit"
                  : "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?"
                      "departmentName=${widget.departmentName}"
                      "&userName=${widget.userName}"
                      "&env_code=$environmentShortCode$formID_user_category",

          // "https://qa-memberly.github.io/qa/sites/ISDHealth/doctorfeedback.html?departmentName=ISDHealth&userName=priya",
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
              handlerName: "DoctorFeedBackHandler",
              callback: (args) {
                if (args.isNotEmpty) {
                  int statusCode = args[0];
                  print("===> Ststuas code inappview");
                  print(statusCode);
                  String toastMsg = "Feedback created successfully";
                  String toastMsg1 = "Feedback updated successfully";
                  if (statusCode == 200 || statusCode == 204) {
                    Fluttertoast.showToast(
                        msg: toastMsg1,
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 5,
                        gravity: ToastGravity.TOP);
                  } else if (statusCode == 201 || statusCode == 202) {
                    Fluttertoast.showToast(
                        msg: statusCode == 200 ? toastMsg1 : toastMsg,
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 5,
                        gravity: ToastGravity.TOP);

                    Navigator.pop(context, true);
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
                }
              },
            );
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            debugPrint("onLoadStart $url");
          },
          onLoadStop: (InAppWebViewController controller, String url) async {
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
      ]))),
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
