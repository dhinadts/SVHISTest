import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/gestures.dart";
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_preferences.dart';

class ShowFlashCardInAppWebViewScreen extends StatefulWidget {
  final double webViewHeight;

  ShowFlashCardInAppWebViewScreen({this.webViewHeight});

  @override
  _ShowFlashCardInAppWebViewScreenState createState() =>
      _ShowFlashCardInAppWebViewScreenState();
}

class _ShowFlashCardInAppWebViewScreenState
    extends State<ShowFlashCardInAppWebViewScreen> {
  InAppWebViewController webView;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    print(
        "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/today_wishlist.html?userid=${AppPreferences().username}&deptid=${AppPreferences().deptmentName}");
    return Stack(
      children: [
        Container(
          height: widget.webViewHeight,
          padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
          child: InAppWebView(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            ].toSet(),
            initialUrl:
                // "https://memberly-app.github.io/sites/USEmbassyTT/newsfeed.html",
                "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/today_wishlist.html?userid=${AppPreferences().username}&deptid=${AppPreferences().deptmentName}",
            // "https://memberly-app.github.io/sites/TEST_PAGES/newsfeed.html",
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  debuggingEnabled: true,
                  minimumFontSize: 100,
                  cacheEnabled: true,
                  clearCache: false,
                  preferredContentMode: UserPreferredContentMode.MOBILE),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                )
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
              webView.addJavaScriptHandler(
                handlerName: "OutNavHandler",
                callback: (args) {
                  if (args.isNotEmpty) {
                    launch(args[0]);
                  }
                },
              );
            },
            onLoadStart: (InAppWebViewController controller, String url) {},
            onLoadStop:
                (InAppWebViewController controller, String url) async {},
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              if (progress == 100) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            /* onLoadHttpError: (controller, url, errorCode, errorMessage) {
                                if (errorCode >= 400 && errorCode <= 499) {
                                  webView.loadFile(assetFilePath: "assets/static/400.html");
                                } else if (errorCode >= 500) {
                                  webView.loadFile(assetFilePath: "assets/static/500.html");
                                }
                                }, */
          ),
        ),
        isLoading ? Center(child: CircularProgressIndicator()) : Stack(),
      ],
    );
  }
}
