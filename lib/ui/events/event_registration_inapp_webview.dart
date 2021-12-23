import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import "../custom_drawer/custom_app_bar.dart";
import "../../utils/app_preferences.dart";
import "../../ui/events/event_new_feed.dart";
import "../../repo/common_repository.dart";
import "../../ui/events/user_event.dart";
import "../../ui/custom_drawer/navigation_home_screen.dart";
import "../../utils/constants.dart";
import "../../utils/routes.dart";
import "../../utils/alert_utils.dart";
import '../../ui_utils/app_colors.dart';
import "dart:convert";
import '../../ui/membership/widgets/payment_cancel_dialog.dart';
import '../../ui/membership/widgets/payments_widget.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/app_preferences.dart';
import 'event_new_feed.dart';
import 'user_event.dart';
import 'events_new_bloc.dart';
import "package:http/http.dart" as http;

class EventRegistrationInAppWebView extends StatefulWidget {
  final UserEvent event;
  final EventFeed eventFeed;
  EventRegistrationInAppWebView({this.event, this.eventFeed});
  @override
  _EventRegistrationInAppWebViewState createState() =>
      _EventRegistrationInAppWebViewState();
}

class _EventRegistrationInAppWebViewState
    extends State<EventRegistrationInAppWebView> {
  String environmentShortCode = "";
  double paymentPrice;
  bool paymentScreenEnabled = false;
  EventsBloc _eventBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map eventRegisterSubmissionData;
  initState() {
    _eventBloc = EventsBloc(context);
    environmentShortCode = AppPreferences().environmentShortCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
          title: "Event Registration",
          pageId: null,
        ),
        body: paymentScreenEnabled
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 380,
                    //height: 280,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            child: Container(
                              //color: AppColors.primaryColor,
                              color: Color(0xFF1A237E),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Payment method",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PaymentCancellationDialog(
                                                      onTap: () {
                                                        setState(() {
                                                          paymentScreenEnabled =
                                                              false;
                                                        });
                                                      },
                                                    ));
                                          },
                                          color: Colors.white),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          child: Container(
                            color: AppColors.primaryColor,
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16.0),
                              height:
                                  MediaQuery.of(context).size.height * 1 / 1.6,
                              child: PaymentsWidget(
                                totalAmount: paymentPrice,
                                name: AppPreferences().username,
                                isOnlyCard: true,
                                email: AppPreferences().userInfo.emailId,
                                phoneNumber: AppPreferences().userInfo.mobileNo,
                                departmentName:
                                    widget.eventFeed.eventDepartment,
                                paymentDescription:
                                    "Event Fee for ${widget.eventFeed.eventName}",
                                paymentStatus: (bool payStatus,
                                    String paymentMode,
                                    String requestId) async {
                                  // debugPrint("event payStatus --> $payStatus");
                                  // debugPrint(
                                  //     "event paymentMode --> $paymentMode");
                                  // debugPrint("event requestId --> $requestId");
                                  setState(() {
                                    paymentScreenEnabled = false;
                                  });
                                  if (payStatus) {
                                    makeEventRegistrationPayment(paymentPrice);
                                    // _doEventRegisteration();
                                  }
                                },
                                transactionType: TransactionType.EVENT,
                                globalKey: _scaffoldKey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        clearCache: true,
                        cacheEnabled: false,
                        incognito: true)),
                initialUrl:
                    // "http://localhost:8080/assets/member_editorial.html?eventName=${widget.eventFeed.eventName}&department=${AppPreferences().deptmentName}&envCode=${environmentShortCode}&clientId=${AppPreferences().clientId}&eventId=${widget.eventFeed.eventId}&username=${AppPreferences().username}&sessionName=${widget.event.sessionName}",
                    "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/event-${widget.event.eventId}.html",
                onLoadStart: (InAppWebViewController controller, String url) {
                  debugPrint("onLoadStart $url");
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  debugPrint("onLoadStop $url");
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
                onWebViewCreated: (InAppWebViewController controller) {
                  controller.addJavaScriptHandler(
                      handlerName: "eventHandlerRequest",
                      callback: (args) {
                        return {"data": widget.eventFeed.toJson()};
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'eventHandlerResponse',
                      callback: (args) async {
                        // debugPrint("handlerPayWithArgs --> $args");
                        // if (args.isNotEmpty) {
                        //   Map<String, dynamic> response = json.decode(args[0]);
                        //   if (response["status"] == 200) {
                        //     setState(() {
                        //       price = response['price']+0.0;
                        //       paymentScreenEnabled = true;
                        //     });
                        //     // Navigator.pushAndRemoveUntil(
                        //     //     context,
                        //     //     MaterialPageRoute(
                        //     //         builder: (context) => NavigationHomeScreen(
                        //     //               drawerIndex:
                        //     //                   Constants.PAGE_ID_EVENTS_LIST,
                        //     //             )),
                        //     //     ModalRoute.withName(Routes.navigatorHomeScreen));
                        //   }
                        // } else {
                        //   Navigator.pop(context);
                        // }
                        if (args.isNotEmpty) {
                          debugPrint("handlerPayWithArgs --> $args");
                          var handlerPayload = json.decode(args[0]);
                          eventRegisterSubmissionData = handlerPayload;
                          http.Response response = await http.get(
                              "${WebserviceConstants.baseAdminURL}/miscellous-scheme-detailList?department_name=${AppPreferences().deptmentName}&sourceModuleId=${widget.event.eventId}");
                          if (response.statusCode > 199 &&
                              response.statusCode < 300) {
                            List paymentDetails = json.decode(response.body);
                            double price = 0;
                            if (handlerPayload['membershipId'] != null &&
                                handlerPayload['membershipId']
                                    .toString()
                                    .trim()
                                    .isNotEmpty) {
                              http.Response membershipValidationResponse =
                                  await http.get(WebserviceConstants
                                          .baseFilingURL +
                                      "/membership/form/dynamic/${handlerPayload['membershipId']}");
                              if (membershipValidationResponse.statusCode ==
                                  500) {
                                AlertUtils.showAlertDialog(
                                    context,
                                    json.decode(membershipValidationResponse
                                        .body)["message"]);
                              } else {
                                if (paymentDetails[0]["schemeFeeType"].trim() ==
                                    "USER") {
                                  price =
                                      paymentDetails[0]["schemeActivePrice"];
                                } else {
                                  price =
                                      paymentDetails[1]["schemeActivePrice"];
                                }
                                // makeEventRegistrationPayment(price);
                                setState(() {
                                  paymentPrice = price;
                                  paymentScreenEnabled = true;
                                });
                              }
                            } else {
                              if (paymentDetails[0]["schemeFeeType"].trim() ==
                                  "NON-USER") {
                                price = paymentDetails[0]["schemeActivePrice"];
                              } else {
                                price = paymentDetails[1]["schemeActivePrice"];
                              }
                              //  makeEventRegistrationPayment(price);
                              setState(() {
                                paymentPrice = price;
                                paymentScreenEnabled = true;
                              });
                            }
                          } else {}
                        }
                      });
                }));
  }

  makeEventRegistrationPayment(price) async {
    String eventRegisterSubmissionDataStr =
        json.encode(eventRegisterSubmissionData);

    String test = json.encode({
      "status": "REGISTERED",
      "eventRegisterSubmissionData": eventRegisterSubmissionDataStr
    });

    String url = WebserviceConstants.baseEventFeedURL +
        "/invitee/${AppPreferences().deptmentName}/${AppPreferences().username}/${widget.event.eventId}/${widget.event.sessionName}";
    print(url);
    print("test  :  " + test.toString());
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: test);
    if (response.statusCode > 199 && response.statusCode < 300) {
      setState(() {
        paymentPrice = price + 0.0;
        _doEventRegisteration();
      });
    } else {}
  }

  _doEventRegisteration() async {
    showDialog(
      context: context,
      builder: (context) => Container(
        color: Colors.black.withAlpha(128),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    final success = await _eventBloc.registerEvent(widget.event);
    Navigator.of(context).pop();
    if (success) {
      // widget.refresh();
      // Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(
                    drawerIndex: Constants.PAGE_ID_EVENTS_LIST,
                  )),
          ModalRoute.withName(Routes.navigatorHomeScreen));
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Error registering")));
    }
  }
}
