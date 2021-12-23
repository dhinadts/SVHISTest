import 'dart:convert';

import 'package:Memberly/repo/common_repository.dart';
import 'package:Memberly/ui/diabetes_risk_score/model/health_score.dart';

import '../model/people.dart';
import '../ui_utils/icon_utils.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import '../ui/diabetes_risk_score/repository/diabetes_risk_score_api_client.dart';
import 'package:http/http.dart' as http;

class PeopleListItem extends StatefulWidget {
  final People people;
  final GestureTapCallback onPress;
  final bool selectedValue;
  final bool isCameFromSubscription;
  final bool isCameFromDiabetesRiskScore;
  final bool hasRiskScore;
  final void Function(People, bool) addRemoveSubscriberFromPeopleList;
  final bool isGlobalSearch;

  PeopleListItem(this.people,
      {this.onPress,
      this.selectedValue: false,
      this.isCameFromSubscription: false,
      this.isCameFromDiabetesRiskScore: false,
      this.hasRiskScore,
      this.addRemoveSubscriberFromPeopleList,
      this.isGlobalSearch: false});

  @override
  _PeopleListItemState createState() => _PeopleListItemState();
}

class _PeopleListItemState extends State<PeopleListItem> {
  bool valueSelected = false;
  bool isMembershipEnabled = true;
  bool isexpaned = false;
  int expireMembershipInDays;
  String address = '';
  bool isMembershipApplicable = AppPreferences().isMembershipApplicable == null
      ? false
      : AppPreferences().isMembershipApplicable;
  // final DiabetesRiskScoreApiClient diabetesRiskScoreApiClient;
  List<HealthScore> hasRiskScore1;

  @override
  void initState() {
    super.initState();
    if (widget.isCameFromDiabetesRiskScore == true) {
      getHealthScoreHistoryList(widget.people.userName);
    } else {}
  }

  Future<Map<String, String>> createHeader(
      {String userName, String departmentName}) async {
    Map<String, String> header = {};
    String username = userName ?? await AppPreferences.getUsername();
    if (departmentName != null) {
      header.putIfAbsent(
          WebserviceConstants.departmentName, () => departmentName);
    }
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(WebserviceConstants.username, () => username);
    return header;
  }

  getHealthScoreHistoryList(String userName) async {
    http.Client httpClient;
    String deptName = await AppPreferences.getDeptName();
    List<HealthScore> healthScoreList;
    final url = WebserviceConstants.baseFilingURL +
        WebserviceConstants.healthScore +
        "${WebserviceConstants.departments}$deptName${WebserviceConstants.users}$userName";
    Map<String, String> header = await createHeader(
      userName: userName,
      departmentName: deptName,
    );
    debugPrint("getHealthScoreHistoryList url --> $url");
    debugPrint("getHealthScoreHistoryList header --> $header");

    http.Response response = await http.get(url, headers: header);
    // debugPrint("getHealthScoreHistoryList response --> ${response.body}");
    // debugPrint(
    //     "getHealthScoreHistoryList response statuscode--> ${response.statusCode}");
    if (response.statusCode == WebserviceHelper.WEB_SUCCESS_STATUS_CODE) {
      List<dynamic> data = jsonDecode(response.body);
      healthScoreList = data.map((data) => HealthScore.fromJson(data)).toList();
      setState(() {
        hasRiskScore1 = healthScoreList;
      });
      // return healthScoreList;
    } else {
      setState(() {
        hasRiskScore1 = [];
      });
      // return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("people --> ${widget.people.toJson()}");
    // if (widget.people.membershipType == "Member") {
    //   if (widget.people.membershipEntitlements != null) {
    //     if (widget.people.membershipEntitlements['expiryDate'] != null) {
    //       expireMembershipInDays = DateUtils.getDateTimeFromISOString(
    //               widget.people.membershipEntitlements['expiryDate'])
    //           .difference(DateTime.now())
    //           .inDays;
    //       print(expireMembershipInDays);
    //     } else {
    //       expireMembershipInDays = 0;
    //     }
    //   } else {
    //     expireMembershipInDays = 0;
    //   }
    // }

    if (widget.people?.cityName != null) {
      address = '${widget.people?.cityName}';
    }
    if (widget.people?.stateName != null) {
      if (address.isNotEmpty) {
        address = address + ', ';
      }
      address = address + '${widget.people?.stateName}';
    }
    if (widget.people?.countryName != null) {
      if (address.isNotEmpty) {
        address = address + ', ';
      }
      address = address + '${widget.people?.countryName}';
    }
    if (widget.people?.zipCode != null) {
      if (address.isNotEmpty) {
        address = address + ', ';
      }
      address = address + '${widget.people?.zipCode}';
    }
    if (address.isEmpty) {
      address = 'Address not available';
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 2.0,
      ),
      child: isMembershipApplicable &&
              widget.people.membershipType == "Member" &&
              widget.people.membershipEntitlements != null &&
              widget.isCameFromDiabetesRiskScore == false
          ? ExpansionPanelList(
              expansionCallback: (index, value) {
                setState(() {
                  isexpaned = !isexpaned;
                });
                // debugPrint(
                //     "${widget.people.membershipEntitlements['membershipType']}");
                // debugPrint("widget.people.membershipType");
                // debugPrint(widget.people.membershipType);
              },
              expandedHeaderPadding: EdgeInsets.zero,
              elevation: 0,
              dividerColor: Colors.grey,
              children: [
                  ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) =>
                          getItem(),
                      body: widget.people.membershipType == "Member" &&
                              widget.people.membershipEntitlements != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12, top: 12, bottom: 12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Id: "),
                                      Text(
                                          "${widget.people.membershipEntitlements['membershipId']}")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Status: "),
                                      Text(
                                          "${widget.people.membershipEntitlements['membershipStatus']}")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Type: "),
                                      Text(
                                          "${widget.people.membershipEntitlements['membershipType'] == null || widget.people.membershipEntitlements['membershipType'].isEmpty ? "Subscribed" : widget.people.membershipEntitlements['membershipType']}")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Expire Status"),
                                      Container(
                                        color:
                                            /* widget.people.membershipEntitlements[
                                                            'membershipType'] !=
                                                        "Life" && */
                                            widget.people.membershipStatus !=
                                                    "Active"
                                                ? Colors.red
                                                : Colors.green,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: Text(
                                              // widget.people.membershipEntitlements['membershipType'] != "Life" ?
                                              "${widget.people.membershipStatus}",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      isExpanded: isexpaned)
                ])
          : getItem(),
    );
  }

  splitAndAssign(String date) {
    List<String> arr = date.split("/");
    if (arr.length == 3) {
      return getUserAge(
          DateTime(int.parse(arr[2]), int.parse(arr[0]), int.parse(arr[1])));
    }
  }

  getUserAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  getItem() {
/*     String checkType = "", checkTypeLetter = "";
    Color checkTypeColor = Colors.grey;
    bool checkCondt = false;
    if (widget.people.membershipEntitlements == null ||
        widget.people.membershipEntitlements.isEmpty) {
      setState(() {
        checkCondt = false;
      });
    } else {
      setState(() {
        checkCondt = true;
        checkType = widget.people.membershipEntitlements['membershipType'];
        if (checkType == "Life") {
          checkTypeColor = Colors.red;
          checkTypeLetter = "L";
        } else if (checkType == "Subscribed") {
          checkTypeColor = Colors.green;
          checkTypeLetter = "S";
        }
      });
    } */
    return InkWell(
        onTap: widget.onPress,
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 2),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                      child: Row(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                              height: 55,
                              width: 55,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(32.0),
                                      child: (widget.people.profileImage !=
                                                  null) &&
                                              widget.people.profileImage
                                                      .length >
                                                  0
                                          ? Image.memory(
                                              base64Decode(
                                                  widget.people.profileImage),
                                              fit: BoxFit.fitWidth,
                                              width: double.maxFinite,
                                              height: double.maxFinite,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace stackTrace) {
                                                return Image.asset(
                                                    "assets/images/userInfo.png");
                                              },
                                            )
                                          : Image.asset(
                                              "assets/images/userInfo.png")),
                                  widget.people.membershipEntitlements ==
                                              null ||
                                          widget.people.membershipEntitlements
                                              .isEmpty
                                      ? SizedBox.shrink()
                                      : Align(
                                          alignment: Alignment(1, 1),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0))),
                                            child: !isMembershipApplicable
                                                ? SizedBox()
                                                : widget.people
                                                            .membershipType ==
                                                        "User"
                                                    ? Container()
                                                    : CircleAvatar(
                                                        radius: 10.0,
                                                        backgroundColor: widget
                                                                        .people
                                                                        .membershipEntitlements[
                                                                    'membershipType'] ==
                                                                "Life"
                                                            ? Colors.red
                                                            : widget.people
                                                                        .membershipType ==
                                                                    "Member"
                                                                ? Colors.green
                                                                : Colors
                                                                    .transparent,

                                                        /* widget
                                                                    .people
                                                                    .membershipEntitlements[
                                                                'membershipType'] ==
                                                            null
                                                        ? Colors.green
                                                        : (widget.people.membershipEntitlements[
                                                                    'membershipType'] ==
                                                                "Life"
                                                            ? Colors.red
                                                            : Colors
                                                                .grey), */ // checkTypeColor,
                                                        child: Center(
                                                          child: Text(
                                                            widget.people.membershipEntitlements[
                                                                        'membershipType'] ==
                                                                    "Life"
                                                                ? "L"
                                                                : widget.people
                                                                            .membershipType ==
                                                                        "Member"
                                                                    ? "S"
                                                                    : "",
                                                            /* widget.people.membershipEntitlements[
                                                                    'membershipType'] ==
                                                                null
                                                            ? "S"
                                                            : (widget.people.membershipEntitlements[
                                                                        'membershipType'] ==
                                                                    "Life"
                                                                ? "L"
                                                                : "" ),*/
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                          ))
                                ],
                              ))
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${widget.people?.lastName}'.length > 0
                                ? '${widget.people?.firstName} ${widget.people?.lastName}'
                                : '${widget.people?.firstName}',
                            // '${people?.lastName}, ${people?.firstName}',
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          widget.isGlobalSearch
                              ? Text("${widget.people?.departmentName}")
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .4,
                                child: Text(
                                  address,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              widget.isCameFromSubscription
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          .1,
                                      height: 20.0,
                                      child: new Checkbox(
                                        value: widget.selectedValue
                                            ? widget.selectedValue
                                            : valueSelected,
                                        activeColor: widget.selectedValue
                                            ? Colors.grey
                                            : Colors.blue[900],
                                        onChanged: (bool value) {
                                          // if(value){
                                          setState(() {
                                            // print(
                                            // "Value of check box clicked $value");
                                            valueSelected = value;
                                            if (value) {
                                              widget
                                                  .addRemoveSubscriberFromPeopleList(
                                                      widget.people, true);
                                              // addUserToList(widget.people);
                                            } else {
                                              widget
                                                  .addRemoveSubscriberFromPeopleList(
                                                      widget.people, false);
                                              // removeUserFromList(widget.people);
                                            }
                                          });
                                          // print("Value of check box clicked $value");

//                                          }else{
//                                            print("Value of check box UnClicked $value");
//                                          }
                                        },
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          Text(
                            DateUtils.convertUTCToLocalTime(
                                widget.people.lastReportedDate ??
                                    widget.people.modifiedOn),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )),
                    ],
                  )),
                  SizedBox(
                    width: 35,
                  ),
                  widget.isCameFromDiabetesRiskScore == true
                      ? hasRiskScore1 == null
                          ? SizedBox.shrink()
                          : hasRiskScore1.length == 0
                              ? SizedBox.shrink()
                              : Icon(
                                  // Icons.wysiwyg,
                                  Icons.verified,
                                  // Icons.where_to_vote,
                                  color: Colors.green,
                                )
                      : SizedBox(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

              // Container(
              //   width: double.infinity,
              //   //margin: EdgeInsets.symmetric(horizontal: 7),
              //   height: 1,
              //   color: AppColors.borderLine,
              // ),
              // Container(
              //   width: double.infinity,
              //   //margin: EdgeInsets.symmetric(horizontal: 7),
              //   height: 5,
              //   color: AppColors.borderShadow,
              // ),
            ],
          ),
        ));
  }
}
