import 'dart:io';

import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class InternalInappWebviewScreen extends StatefulWidget {
  final String title;
  final String pageURL;

  const InternalInappWebviewScreen(
      {Key key, @required this.title, @required this.pageURL})
      : super(key: key);

  @override
  _InternalInappWebviewScreenState createState() =>
      _InternalInappWebviewScreenState();
}

class _InternalInappWebviewScreenState
    extends State<InternalInappWebviewScreen> {
  InAppWebViewController _webViewController;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    debugPrint("InternalInappWebviewScreen --> title --> ${widget.title}");
    debugPrint("InternalInappWebviewScreen --> pageURL --> ${widget.pageURL}");
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
          title: widget.title, pageId: Constants.PAGE_ID_INAPP_WEBVIEW),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: Stack(children: [
                InAppWebView(
                  initialUrl: widget.pageURL,
                  initialHeaders: {},
                  contextMenu: ContextMenu(),
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: true,
                        useShouldOverrideUrlLoading: true,
                        cacheEnabled: true,
                        javaScriptEnabled: true,
                        supportZoom: false,
                      ),
                      android: AndroidInAppWebViewOptions()),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                    if (Platform.isAndroid)
                      _webViewController.android.clearHistory();
                    _webViewController.addJavaScriptHandler(
                      handlerName: "OutNavHandler",
                      callback: (args) {
                        if (args.isNotEmpty) {
                          launch(args[0]);
                        }
                      },
                    );
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    debugPrint("onLoadStart $url");
                  },
                  shouldOverrideUrlLoading:
                      (controller, shouldOverrideUrlLoadingRequest) async {
                    return ShouldOverrideUrlLoadingAction.ALLOW;
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
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ));
  }
}
