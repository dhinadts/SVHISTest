import '../membership_screen.dart';
import 'membership_list_widget.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../ui_utils/app_colors.dart';
import '../../../ui_utils/icon_utils.dart';
import '../model/membership_info.dart';

final DateFormat gnatDobFormat = DateFormat("dd/MM/yyyy");
//final DateFormat originalDobFormat = DateFormat("MM/dd/yyyy");

class MembershipListItem extends StatefulWidget {
  final MembershipInfo membershipInfo;
  final GestureTapCallback onPress;
  final MembershipListWidgetSource membershipListWidgetSource;

  const MembershipListItem({
    Key key,
    @required this.membershipInfo,
    @required this.onPress,
    @required this.membershipListWidgetSource,
  }) : super(key: key);

  @override
  _MembershipListItemState createState() => _MembershipListItemState();
}

class _MembershipListItemState extends State<MembershipListItem> {
  bool isMembershipApplicable = AppPreferences().isMembershipApplicable == null
      ? false
      : AppPreferences().isMembershipApplicable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("membershipType --> ${membershipInfo.membershipType}");
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 7,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        widget.membershipInfo.downloadProfileURL == null ||
                                widget.membershipInfo.downloadProfileURL.isEmpty
                            ? Image.asset(
                                widget.membershipInfo.roleName ==
                                        Constants.supervisorRole
                                    ? "assets/images/ic_supervisor.png"
                                    : "assets/images/userInfo.png",
                                height: 55,
                                width: 55,
                              )
                            : Image.network(
                                widget.membershipInfo.downloadProfileURL,
                                height: 55,
                                width: 55,
                              ),
                        //Visibility(
                        //visible: membershipListWidgetSource ==
                        //MembershipListWidgetSource.RiskScore,
                        //child:
                        /* if (membershipInfo.roleName != Constants.supervisorRole)
                          membershipInfo.membershipType == LIFE &&
                                  membershipInfo.membershipStatus == "Approved"
                              ? Text("L")
                              : Text("S"), */
                        isMembershipApplicable &&
                                widget.membershipInfo.roleName != "Supervisor"
                            ? Align(
                                alignment: Alignment(1, 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2.0, color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: CircleAvatar(
                                    radius: 10.0,
                                    backgroundColor:
                                        widget.membershipInfo.membershipType ==
                                                LIFE
                                            ? Colors.red
                                            : Colors.green,
                                    child: Center(
                                      child: Text(
                                        widget.membershipInfo.membershipType ==
                                                    LIFE &&
                                                widget.membershipInfo
                                                        .membershipStatus ==
                                                    "Approved"
                                            ? "L"
                                            : "S",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ))
                            : SizedBox.shrink()
                        //),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '${widget.membershipInfo?.lastName}'.length > 0
                                ? '${widget.membershipInfo?.firstName} ${widget.membershipInfo?.lastName}'
                                : '${widget.membershipInfo?.firstName}',
                            maxLines: 3,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (widget.membershipInfo.roleName !=
                            Constants.supervisorRole)
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                      "${widget.membershipInfo.membershipId}"),
                                ),
                                SizedBox(width: 5),
                                if (widget.membershipListWidgetSource ==
                                        MembershipListWidgetSource.Membership ||
                                    widget.membershipListWidgetSource ==
                                        MembershipListWidgetSource
                                            .MembershipHierarchy)
                                  Container(
                                    decoration: new BoxDecoration(
                                        color: getMembershipStatusColor(widget
                                                    .membershipInfo
                                                    .membershipStatus ==
                                                APPROVED
                                            ? (isMembershipExpired(
                                                    widget.membershipInfo)
                                                ? EXPIRED
                                                : APPROVED)
                                            : widget.membershipInfo
                                                .membershipStatus),
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        widget.membershipInfo
                                                    .membershipStatus ==
                                                APPROVED
                                            ? (isMembershipExpired(
                                                    widget.membershipInfo)
                                                ? "  Expired - Pending Payment  "
                                                : "  ${getMembershipRemainingDays(widget.membershipInfo)}  ")
                                            : "  ${widget.membershipInfo.membershipStatus}  ",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )),
                                  )
                              ],
                            ),
                          ),
                        Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Text(
                                    // gnatDobFormat.format(originalDobFormat
                                    //     .parse(DateUtils.convertUTCToLocalTime(
                                    //         membershipInfo.modifiedOn))),
                                    DateUtils.convertUTCToLocalTime(
                                        widget.membershipInfo.modifiedOn),
                                    //membershipInfo.modifiedOn,
                                    style: TextStyle(fontSize: 13),
                                  )),
                                  Text(
                                    widget.membershipInfo.roleName ==
                                            Constants.supervisorRole
                                        ? "Role : ${widget.membershipInfo.roleName}"
                                        : "",
                                    style: TextStyle(fontSize: 13),
                                  )
                                ])),
                        /*Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            DateUtils.convertUTCToLocalTime(
                                membershipInfo.modifiedOn),
                          ),
                        ),*/
                      ],
                    )),
                  ],
                )),
                SizedBox(
                  width: 5,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              //margin: EdgeInsets.symmetric(horizontal: 7),
              height: 1,
              color: AppColors.borderLine,
            ),
            Container(
              width: double.infinity,
              //margin: EdgeInsets.symmetric(horizontal: 7),
              height: 5,
              color: AppColors.borderShadow,
            ),
          ],
        ),
      ),
    );
  }
}

Color getMembershipStatusColor(String status) {
  if (status == UNDER_REVIEW) {
    return Colors.blue;
  } else if (status == PENDING_PAYMENT) {
    return AppColors.arrivedColor;
  } else if (status == PENDING_APPROVAL) {
    return Colors.orange;
  } else if (status == REJECTED) {
    return Colors.red;
  } else if (status == APPROVED) {
    return Colors.green;
  } else if (status == EXPIRED) {
    return Colors.red;
  } else {
    return Colors.green;
  }
}
