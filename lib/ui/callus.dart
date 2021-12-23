import 'dart:ui';

import 'package:Memberly/login/colors/color_info.dart';
import 'package:Memberly/login/stateLessWidget/upper_logo_widget.dart';
import 'package:Memberly/ui/custom_drawer/custom_app_bar.dart';
import 'package:Memberly/ui_utils/app_colors.dart';
import 'package:Memberly/utils/constants.dart';
import 'package:Memberly/widgets/submit_button.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CallUs extends StatelessWidget {
  final String title;
  CallUs({Key key, this.title}) : super(key: key);
  //  print(
  //      "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?");
  // InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title != null ? title : "Call Us",
        pageId: Constants.PAGE_ID_CALLUS,
      ),
      // AppBar(
      //   backgroundColor: AppColors.primaryColor,
      //   centerTitle: true,
      //   title: Text(title != null ? title : "Profile"),
      //   actions: [

      //   ],
      // ),
      /*      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UpperLogoWidgetDATT(showPoweredBy: true),
              // SubmitButton(
              //   text: "CALL US",
              //   onPress: () {
              //     launch("tel://1868 607 3288");
              //   },
              // ),
              new InkWell(
                child: new Container(
                    height: 50.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      // color: AppColors.arrivedColor.withOpacity(0.75),
                      color: AppColors.primaryColor,
                    ),
                    child: new Center(
                      child: new Text(
                        "CALL US",
                        style: TextStyle(
                          color: Color(ColorInfo.WHITE),
                          fontSize: 18.0,
                        ),
                      ),
                    )),
                onTap: () {
                  launch("tel://1868 607 3288");
                },
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
  */
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: Stack(children: [
                /* InAppWebView(
                  initialUrl: // "about:/blank",
                      "https://qa-memberly.github.io/qa/sites/DATT/ContactUs.html",
                  //       javascriptMode: JavascriptMode.unrestricted,
                  //       gestureNavigationEnabled: true,

                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptCanOpenWindowsAutomatically: true,
                        debuggingEnabled: true,
                        useShouldOverrideUrlLoading: true,
                        clearCache: true,
                        javaScriptEnabled: true,
                        supportZoom: false,
                      ),
                      android: AndroidInAppWebViewOptions(
                          useHybridComposition: true,
                          allowUniversalAccessFromFileURLs: true,
                          allowFileAccessFromFileURLs: true,
                          useOnRenderProcessGone: true,
                          supportMultipleWindows: true)),
                  onWebViewCreated: (InAppWebViewController controller) {
                    /* final ChromeSafariBrowser browser =
                        new ChromeSafariBrowser();
                    browser.open(
                        url:
                            "https://qa-memberly.github.io/qa/sites/DATT/ContactUs.html",
                        options: ChromeSafariBrowserClassOptions(
                            android: AndroidChromeCustomTabsOptions(
                                enableUrlBarHiding: true,
                                addDefaultShareMenuItem: false),
                            ios: IOSSafariOptions(barCollapsingEnabled: true))); */
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    debugPrint("onLoadStart $url");
                    if (url.contains("tel:")) {
                      launch(url);
                    }
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
                  /* onLoadHttpError: (controller, url, errorCode, errorMessage) {
                    if (errorCode >= 400 && errorCode <= 499) {
                      _webViewController.loadFile(
                          assetFilePath: "assets/static/400.html");
                    } else if (errorCode >= 500) {
                      _webViewController.loadFile(
                          assetFilePath: "assets/static/500.html");
                    }
                  }, */
                ), */

                WebView(
                  initialUrl:
                      'https://qa-memberly.github.io/qa/sites/DATT/ContactUs.html',
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    print("url --> ${request.url}");
                    if (request.url.contains("mailto:")) {
                      // _launchURL(request.url);
                      launch(request.url);
                      return NavigationDecision.prevent;
                    } else if (request.url.contains("tel:")) {
                      _launchURL(request.url);
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                )
              ])),
            ),

            /// Show Banner Ad
            // getSivisoftAdWidget(),
          ],
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
