import '../../model/notice_board_response.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui_utils/icon_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ModalInsideModal extends StatelessWidget {
  NewNotification note;
  final bool reverse = false;
  String createdDate = "";
  var isHtml = false;
  InAppWebViewController _webViewController;

/*  const ModalInsideModal(NewNotification notification, {
    Key key,
    this.reverse = false, this.note
  }) : super(key: key);*/

  ModalInsideModal(NewNotification notification) {
    this.note = notification;
  }

  // String formatedHtmlText() {
  //   print(note.message);
  //   String htmlText = """
  //   <html>
  //   <head>
  //   <meta name="viewport" content="width=device-width, initial-scale=1.0">
  //   </head>
  //     Message</br></br>
  //     ${note.message}</br></br>
  //     Type</br>
  //     ${note.type}</br></br>
  //     Created On</br>
  //     ${note.createdOn}</br></br>
  //     Created By</br>
  //     ${note.createdBy}</br>
  //     <html>
  //   """;
  //   return htmlText;
  // }

  @override
  Widget build(BuildContext context) {
    initializeAd();
    note.message = note.message.replaceAll("\n", "<br/>");
    if (note.message.contains('<html>')) {
      note.message = note.message.split('<html>').join(
          '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>');
    } else {
      note.message =
          '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>' +
              note.message;
    }

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Container(), middle: Text('Notification Details')),
        child: SafeArea(
          bottom: true,
          /*    child: Container(
                constraints: BoxConstraints.expand(),
                child: Flexible(*/
          // child: InAppWebView(
          //     initialData: InAppWebViewInitialData(data: formatedHtmlText()),
          //     initialOptions: InAppWebViewGroupOptions(
          //         crossPlatform: InAppWebViewOptions(
          //           debuggingEnabled: true,
          //           useShouldOverrideUrlLoading: true,
          //           javaScriptEnabled: true,
          //           supportZoom: false,
          //         ),
          //         android: AndroidInAppWebViewOptions()),
          //     onWebViewCreated: (InAppWebViewController controller) {
          //       _webViewController = controller;

          //       _webViewController.addJavaScriptHandler(
          //         handlerName: "OutNavHandler",
          //         callback: (args) {
          //           if (args.isNotEmpty) {
          //             launch(args[0]);
          //           }
          //         },
          //       );
          //     }),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white30,
                  child: Column(children: [
                    (note.subject != null && note.subject.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 5.0, left: 25, right: 25, bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Subject",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    (note.subject != null && note.subject.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 0, left: 25, right: 25, bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    note.subject.toString().trim(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Message",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0.0, left: 25.0, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey[300], width: 2.0)),
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: InAppWebView(
                          initialData: InAppWebViewInitialData(
                            data: note.message,
                          ),
                          initialOptions: InAppWebViewGroupOptions(
                              crossPlatform: InAppWebViewOptions(
                                debuggingEnabled: true,
                                useShouldOverrideUrlLoading: true,
                                javaScriptEnabled: true,
                                supportZoom: false,
                              ),
                              android: AndroidInAppWebViewOptions()),
                          onWebViewCreated:
                              (InAppWebViewController controller) {
                            _webViewController = controller;

                            _webViewController.addJavaScriptHandler(
                              handlerName: "OutNavHandler",
                              callback: (args) {
                                if (args.isNotEmpty) {
                                  launch(args[0]);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 25, left: 25, right: 25, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Type : " + note.type,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 0, left: 25, right: 25, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Sent On : " +
                                "${DateUtils.convertUTCToLocalTime(note.createdOn)}",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: 0, left: 25, right: 25, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Sent By : " + note.createdBy,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),

              /// Show Banner Ad
              getSivisoftAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  String setCreatedDate(String _date) {
    List<String> createdDate;
    if (_date.split('T') != null) {
      createdDate = _date.split('T');
    }
    if (createdDate[0] != null) {
      return createdDate[0];
    } else {
      return "";
    }
  }
}
