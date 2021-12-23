import '../ui/custom_drawer/newsfeed_inapp_webview_screen.dart';
import '../utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'custom_drawer/custom_app_bar.dart';

class NewsFeedScreen extends StatefulWidget {
  final String title;
  NewsFeedScreen({this.title});
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            title: widget.title == null ? "News Feed" : widget.title,
            pageId: Constants.PAGE_ID_NEWSFEED),
        body: ShowNewsFeedInAppWebViewScreen(
          webViewHeight: MediaQuery.of(context).size.height * 0.85,
        ));
  }
}
