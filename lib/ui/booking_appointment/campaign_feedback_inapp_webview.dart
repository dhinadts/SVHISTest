import 'dart:convert';

import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/membership/widgets/payments_widget_new.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class CampaignFeedbackWebviewScreen extends StatefulWidget {
  final String formId;
  final String departmentName;
  final String id;
  const CampaignFeedbackWebviewScreen(
      {Key key,
      @required this.formId,
      @required this.departmentName,
      @required this.id})
      : super(key: key);
  @override
  _CampaignFeedbackWebviewScreenState createState() =>
      _CampaignFeedbackWebviewScreenState();
}

class _CampaignFeedbackWebviewScreenState
    extends State<CampaignFeedbackWebviewScreen> {
  InAppWebViewController _webViewController;

  bool _isCancelled;
  http.Response _httpResponse;
  String _receiptNumber;
  var popupMenuList = List<PopupMenuEntry<Object>>();
  String departmentName;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    departmentName = AppPreferences().promoDeparmentName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text("Campaign Feedback Information"),
      ),
      body: SafeArea(
          child: Container(
              child: Stack(children: [
        InAppWebView(
          initialUrl:
              "https://qa-memberly.github.io/qa/sites/${widget.departmentName}/doctorfeedback.html?departmentName=${widget.departmentName}&formId=${widget.formId}&id=${widget.id}",
          //  "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/doctorfeedback.html?departmentName=${widget.departmentName}&formId=${widget.formId}&id=${widget.id}",
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
                handlerName: "DoctorFeedBackHandler",
                callback: (args) async {
                  debugPrint("handlerPayWithArgs --> $args");

                  if (args.isNotEmpty) {
                    int statusCode = args[0];
                    if (statusCode > 199 && statusCode < 299) {
                      Fluttertoast.showToast(
                          msg: "Campaign feedback form submitted successfully",
                          gravity: ToastGravity.TOP);

                      Navigator.pop(context, true);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Failed to submit campaign feedback form",
                          gravity: ToastGravity.TOP);
                    }
                  }
                });
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

// @override
// Widget build(BuildContext context) {
//   // TODO: implement build
//   throw UnimplementedError();
// }
