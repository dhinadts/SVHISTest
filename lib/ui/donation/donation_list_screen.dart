import 'dart:convert';

import '../../repo/common_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/donation/donation_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/icon_utils.dart';

import '../../utils/alert_utils.dart';

import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import '../../widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:math' as math;
import 'package:group_list_view/group_list_view.dart';

class DonationListScreen extends StatefulWidget {
  final String title;
  const DonationListScreen({Key key, this.title}) : super(key: key);
  @override
  DonationListScreenState createState() => DonationListScreenState();
}

class DonationListScreenState extends State<DonationListScreen>
    with TickerProviderStateMixin {
  bool isDataLoaded = false;
  bool isDataEmpty = false;
  List<Donation> donationList = [];
  String currency;
  String currencySuffix;

  Map<String, List<Donation>> _donationCauseElements = {};

  @override
  void initState() {
    super.initState();

    _fetchDonationListData();
    getCurrency();

    /// Initialize Admob
    initializeAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.title != null ? widget.title : "Donation",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //replaceHome();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()),
                    ModalRoute.withName(Routes.dashBoard));
              })
        ],
      ),
      body: Container(
        color: Color(0xFFF2F3F8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: !isDataLoaded
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListLoading(),
                )
              : !isDataEmpty
                  ? donationList.length == 0
                      ? noDataWidget()
                      : Column(
                          children: [
                            Expanded(
                              child: GroupListView(
                                sectionsCount:
                                    _donationCauseElements.keys.toList().length,
                                countOfItemInSection: (int section) {
                                  return _donationCauseElements.values
                                      .toList()[section]
                                      .length;
                                },
                                itemBuilder:
                                    (BuildContext context, IndexPath index) {
                                  return InkWell(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DonationScreen(
                                            dObj: _donationCauseElements.values
                                                    .toList()[index.section]
                                                [index.index],
                                            title: _donationCauseElements.values
                                                .toList()[index.section]
                                                    [index.index]
                                                .causeTitle,
                                            callbackForDonationUpdate:
                                                (bool isDonationUpdated) {
                                              if (isDonationUpdated) {
                                                _fetchDonationListData();
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: donationListItem(
                                        _donationCauseElements.values
                                                .toList()[index.section]
                                            [index.index],
                                        index.index),
                                  );
                                },
                                groupHeaderBuilder:
                                    (BuildContext context, int section) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Text(
                                      _donationCauseElements.keys
                                          .toList()[section],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 2),
                                sectionSeparatorBuilder: (context, section) =>
                                    SizedBox(height: 2),
                              ),
                            ),

                            /// Show Banner Ad
                            getSivisoftAdWidget(),
                          ],
                        )
                  // ListView.builder(
                  //     primary: false,
                  //     shrinkWrap: true,
                  //     itemCount: donationList.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return InkWell(
                  //         onTap: () async {
                  //           await Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => DonationScreen(
                  //                 dObj: donationList[index],
                  //                 title: donationList[index].causeTitle,
                  //                 callbackForDonationUpdate:
                  //                     (bool isDonationUpdated) {
                  //                   if (isDonationUpdated) {
                  //                     _fetchDonationListData();
                  //                   }
                  //                 },
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //         child:
                  //             donationListItem(donationList[index], index),
                  //       );
                  //     })
                  : Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Container(
                            child: Text("No data available"),
                          )),
                    ),
        ),
      ),
    );
  }

  Widget noDataWidget() {
    return Center(child: Text("No data available"));
  }

  Widget donationListItem(Donation dObj, int index) {
    String startDate = dObj.startDate.length > 0
        ? DateUtils.convertUTCToLocalTime(dObj.startDate).split(" ").first
        : "";
    String endDate = dObj.endDate.length > 0
        ? DateUtils.convertUTCToLocalTime(dObj.endDate).split(" ").first
        : "";
    return (dObj.isFundRaiser)
        ? fundRaiserWidget(dObj, startDate, endDate, index)
        : nonFundRaiserWidget(dObj, index);
    // : Card(
    //     margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    //     elevation: 1.0,
    //     shape:
    //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     child: InkWell(
    //       borderRadius: BorderRadius.circular(6),
    //       onTap: () async {
    //         await Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => DonationScreen(
    //               dObj: dObj,
    //               title: dObj.causeTitle,
    //               callbackForDonationUpdate: (bool isDonationUpdated) {
    //                 if (isDonationUpdated) {
    //                   _fetchDonationListData();
    //                 }
    //               },
    //             ),
    //           ),
    //         );
    //       },
    //       child: Padding(
    //         padding:
    //             const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             if (!dObj.isFundRaiser) causeTitleWidget(dObj.causeTitle),

    //             // if (dObj.isFundRaiser) const Divider(),
    //             // dObj.isFundRaiser
    //             //     ? Row(
    //             //         children: [
    //             //           Expanded(
    //             //             child: raisedFundWidget(dObj),
    //             //           ),
    //             //           if (endDate != '')
    //             //             Container(height: 40, width: 2, color: Colors.grey),
    //             //           if (endDate != '')
    //             //             Expanded(
    //             //               child: Column(children: [
    //             //                 Text('Ends on'),
    //             //                 Text(endDate),
    //             //               ]),
    //             //             ),
    //             //         ],
    //             //       )
    //             //     : Container(),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
  }

  Widget nonFundRaiserWidget(Donation donationObj, int index) {
    return Row(
      children: [
        SizedBox(width: 2),
        Container(
          width: 28,
          height: 28,
          child: Center(
            child: Text((index + 1).toString()),
          ),
        ),
        Expanded(
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 2, right: 4, top: 4, bottom: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color(0xFF3A5160).withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: causeTitleWidget(donationObj.causeTitle),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget fundRaiserWidget(
      Donation donationObj, String startDate, String endDate, int index) {
    double percentage = 0;
    double circlePercent = 0;
    percentage = (donationObj.achieved_amount / donationObj.targetAmount) * 100;
    circlePercent = (donationObj.achieved_amount / donationObj.targetAmount);

    if (circlePercent > 10) {
      circlePercent = 1.0;
    } else {
      circlePercent = circlePercent / 10;
    }
    circlePercent =
        !circlePercent.isNaN && !circlePercent.isInfinite ? circlePercent : 0;
    percentage = !percentage.isInfinite && !percentage.isNaN ? percentage : 0;

    return Row(
      children: [
        SizedBox(width: 2),
        Container(
          width: 28,
          height: 28,
          child: Center(
            child: Text((index + 1).toString()),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 2, right: 4, top: 4, bottom: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xFF3A5160).withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${donationObj.causeTitle}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (endDate != '')
                                  SizedBox(
                                    height: 3,
                                  ),
                                if (endDate != '')
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          "Ends on $endDate",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF3A5160)
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Raised - ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3A5160)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        currency +
                                            donationObj.achieved_amount
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    // Padding(
                                    // SizedBox(width: 5),
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     color: Color(0xFFFAFAFA),
                                    //     shape: BoxShape.circle,
                                    //     boxShadow: <BoxShadow>[
                                    //       BoxShadow(
                                    //           color: Color(0xFF2633C5)
                                    //               .withOpacity(0.4),
                                    //           offset: const Offset(4.0, 4.0),
                                    //           blurRadius: 8.0),
                                    //     ],
                                    //   ),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(6.0),
                                    //     child: Icon(
                                    //       Icons.north,
                                    //       color: Color(0xFF2633C5),
                                    //       size: 16,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.0),
                                    ),
                                    border: new Border.all(
                                        width: 4,
                                        color:
                                            Color(0xFF2633C5).withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        percentage.toStringAsFixed(1) + "%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomPaint(
                                  painter: CurvePainter(
                                    colors: [
                                      Colors.red,
                                      Colors.yellow,
                                      Colors.blue,
                                      Colors.green,
                                    ],
                                    angle: ((percentage / 100) * 360),
                                  ),
                                  child: SizedBox(
                                    width: 78,
                                    height: 78,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget causeTitleWidget(String causeTitle) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "$causeTitle",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Widget raisedFundWidget(Donation donationObj) {
  //   double percentage = 0;
  //   double circlePercent = 0;
  //   percentage = (donationObj.achieved_amount / donationObj.targetAmount) * 100;
  //   circlePercent = (donationObj.achieved_amount / donationObj.targetAmount);

  //   if (circlePercent > 10) {
  //     circlePercent = 1.0;
  //   } else {
  //     circlePercent = circlePercent / 10;
  //   }
  //   circlePercent =
  //       !circlePercent.isNaN && !circlePercent.isInfinite ? circlePercent : 0;
  //   percentage = !percentage.isInfinite && !percentage.isNaN ? percentage : 0;

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       CircularPercentIndicator(
  //         radius: 50.0,
  //         lineWidth: 5.0,
  //         percent: circlePercent,
  //         center: new Text(
  //           percentage.toInt().toString() + "%",
  //           style: TextStyles.textStyle10,
  //         ),
  //         progressColor: Colors.green,
  //       ),
  //       SizedBox(width: 10),
  //       Column(children: [
  //         Text(
  //           'Raised',
  //           style: TextStyles.textStyle19,
  //         ),
  //         Text(currency + donationObj.achieved_amount.toString()),
  //       ]),
  //       SizedBox(width: 20),
  //     ],
  //   );
  // }

  Future<void> _fetchDonationListData() async {
    String clientId = await AppPreferences.getClientId();

    Map<String, String> header = {};
    String username = await AppPreferences.getUsername();
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);

    header.putIfAbsent("clientid", () => clientId);
    final url = WebserviceConstants.baseFilingURL +
        "/donationcause/client/status/${clientId}/LIVE";
    debugPrint("donationcause url --> $url");
    final response = await http.get(url, headers: header);
    debugPrint("donationcause response --> ${response.body}");
    if (response.statusCode == 200) {
      List donationCauseList = jsonDecode(response.body);
      donationList.clear();
      if (donationCauseList != null) {
        Donation donationObj = Donation.fromJson({
          "createdBy": "",
          "createdOn": "",
          "modifiedBy": "",
          "modifiedOn": "",
          "active": true,
          "comments": "",
          "causeId": "General",
          "clientId": "${clientId}",
          "cause_title": "General",
          "causeBody":
              "Charitable deeds are just not to help someone in need. Charity improves the self, makes you happy and contented. Charity is a privilege and makes one empowering if you think you're ready to help, we are here to help you co-ordinate!",
          "causeBodyMime": "test.html",
          "collectionStatus": "LIVE",
          "endDate": "",
          "hashtags": "",
          "isFundRaiser": false,
          "achieved_amount": 0.0,
          "minAmount": 5.0,
          "receiptRequired": true,
          "startDate": "",
          "supportingDocs": null,
          "targetAmount": 5000,
        });
        donationList.add(donationObj);
        for (int i = 0; i < donationCauseList.length; i++) {
          Donation dObj = Donation.fromJson(donationCauseList[i]);
          if (dObj.collectionStatus == "LIVE") {
            donationList.add(dObj);
          }
        }

        List<Donation> fundRaiserList = [];
        List<Donation> nonFundRaiserList = [];

        for (var item in donationList) {
          if (item.isFundRaiser != null && item.isFundRaiser) {
            fundRaiserList.add(item);
          } else {
            nonFundRaiserList.add(item);
          }
        }
        donationList.clear();

        donationList.addAll(fundRaiserList);
        donationList.addAll(nonFundRaiserList);
        if (fundRaiserList.length > 0)
          _donationCauseElements["Fund Raiser Causes"] = fundRaiserList;
        if (nonFundRaiserList.length > 0)
          _donationCauseElements["General Causes"] = nonFundRaiserList;
      }
    } else {
      String errorMsg = jsonDecode(response.body)['message'] as String;
      AlertUtils.showAlertDialog(
          context,
          errorMsg != null && errorMsg.isNotEmpty
              ? errorMsg
              : AppPreferences().getApisErrorMessage);
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  getCurrency() async {
    String defaultCurrency = await AppPreferences.getDefaultCurrency();
    setState(() {
      currency = defaultCurrency;
      if (currency == "INR") {
        currency = '\u{20B9} ';
      } else {
        currency = '\u{0024} ';
      }
    });
  }
}

class Donation {
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  bool active;
  String comments;
  String causeId;
  String clientId;
  String causeTitle;
  String causeBody;
  String causeBodyMime;
  String collectionStatus;
  String endDate;
  String hashtags;
  bool isFundRaiser;
  double achieved_amount;
  double minAmount;
  bool receiptRequired;
  String startDate;
  String supportingDocs;
  double targetAmount;
  Donation({
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.active,
    this.comments,
    this.causeId,
    this.clientId,
    this.causeTitle,
    this.causeBody,
    this.causeBodyMime,
    this.collectionStatus,
    this.endDate,
    this.hashtags,
    this.isFundRaiser,
    this.achieved_amount,
    this.minAmount,
    this.receiptRequired,
    this.startDate,
    this.supportingDocs,
    this.targetAmount,
  });

  Donation.fromJson(Map<String, dynamic> data) {
    createdBy = data['createdBy'] ?? "";
    createdOn = data['createdOn'] ?? "";
    modifiedBy = data['modifiedBy'] ?? "";
    modifiedOn = data['modifiedOn'] ?? "";
    active = data['active'] ?? false;
    comments = data['comments'] ?? "";
    causeId = data['causeId'] ?? "";
    clientId = data['client_id'] ?? "";
    causeTitle = data['cause_title'] ?? "";
    causeBody = data['cause_body'] ?? "";
    causeBodyMime = data['cause_body_mime'] ?? "";
    collectionStatus = data['collection_status'] ?? "";
    endDate = data['end_date'] ?? "";
    hashtags = data['hashtags'] ?? "";
    isFundRaiser = data['isFundRaiser'] ?? "";
    achieved_amount = data['achieved_amount'] ?? 0.0;
    minAmount = data['min_amount'] ?? 0.0;
    receiptRequired = data['receipt_required'] ?? false;
    startDate = data['start_date'] ?? "";
    supportingDocs = data['supporting_docs'] ?? "";
    targetAmount = data['target_amount'] ?? 0.0;
    // targetAmount = 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['active'] = this.active;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['active'] = this.active;
    data['comments'] = this.comments;
    data['causeId'] = this.causeId;
    data['client_id'] = this.clientId;
    data['cause_title'] = this.causeTitle;
    data['cause_body'] = this.causeBody;
    data['cause_body_mime'] = this.causeBodyMime;
    data['collection_status'] = this.collectionStatus;
    data['end_date'] = this.endDate;
    data['hashtags'] = this.hashtags;
    data['isFundRaiser'] = this.isFundRaiser;
    data['achieved_amount'] = this.achieved_amount;
    data['min_amount'] = this.minAmount;
    data['receipt_required'] = this.receiptRequired;
    data['start_date'] = this.startDate;
    data['supporting_docs'] = this.supportingDocs;
    data['target_amount'] = this.targetAmount;

    return data;
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 8;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 10;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 11;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 7 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
