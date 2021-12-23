import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SampleInAppWebViewAlertBox extends StatefulWidget {
  final String link;

  const SampleInAppWebViewAlertBox({Key key, this.link}) : super(key: key);

  @override
  _SampleInAppWebViewAlertBoxState createState() => _SampleInAppWebViewAlertBoxState();
}

class _SampleInAppWebViewAlertBoxState extends State<SampleInAppWebViewAlertBox> {

  InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
    margin:
    EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1),
    height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
    child:  Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 18.0,
            bottom: 10.0
          ),
          margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0,0),
                    blurRadius: 2.0,
                    spreadRadius: 2.0
                )
              ]
    ),
          child: Column(
            children: [
              Expanded(
                child: InAppWebView(
                initialUrl: widget.link,
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Close"),
                  )
                ],
              )
            ],
          ),
        ),
      Positioned(
          right: 5.0,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 16.0,
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
      ),
      ]
    ),
    )
    );
  }
}