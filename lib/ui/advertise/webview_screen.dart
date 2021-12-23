import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String articleUrl;
  final String title;

  WebViewExample(this.articleUrl, this.title);

  @override
  _WebViewExampleState createState() => _WebViewExampleState(articleUrl);
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  InAppWebViewController webView;
  String articleUrl;

  _WebViewExampleState(this.articleUrl);

  bool isWebLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.length > 0 ? widget.title : "News"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                Share.share(articleUrl);
              }),
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
            child: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
            initialUrl: articleUrl,
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                  preferredContentMode: UserPreferredContentMode.MOBILE),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {},
            onLoadStop: (InAppWebViewController controller, String url) async {
              setState(() {
                isWebLoading = false;
              });
            },
          ))
        ])),
        isWebLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container()
      ]),
      //floatingActionButton: favoriteButton(),
    );
  }
}
