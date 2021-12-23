import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  final String url;

  const WebViewWidget({Key key, @required this.url}) : super(key: key);

  @override
  WebViewState createState() => WebViewState(url);
}

class WebViewState extends State<WebViewWidget> {
  String url;
  bool isWebPageLoading = true;
  final _key = UniqueKey();
  final Set<Factory> gestureRecognizers =
      [Factory(() => EagerGestureRecognizer())].toSet();

  WebViewState(String url) {
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //     title:
      //         Text(this.title, style: TextStyle(fontWeight: FontWeight.w700)),
      //     centerTitle: true),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: gestureRecognizers,
            onWebViewCreated: (controller) {},
            onPageFinished: (finish) {
              setState(() {
                isWebPageLoading = false;
              });
            },
          ),
          isWebPageLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
