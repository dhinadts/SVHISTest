import '../../../model/passing_arg.dart';
import '../../../model/people.dart';
import '../membership_screen.dart';
import '../model/membership_info.dart';
import 'membership_list_item.dart';
import '../../../utils/app_preferences.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import 'package:flutter/material.dart';

import '../membership_inapp_webview_screen.dart';

enum MembershipListWidgetSource { Membership, RiskScore, MembershipHierarchy }

class MembershipListWidget extends StatelessWidget {
  final List<MembershipInfo> membershipInfoList;
  final MembershipListWidgetSource membershipListWidgetSource;
  final void Function(bool) successCallback;

  const MembershipListWidget({
    Key key,
    @required this.membershipInfoList,
    @required this.successCallback,
    @required this.membershipListWidgetSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: membershipInfoList.length,
          itemBuilder: (BuildContext context, int index) {
            return MembershipListItem(
              onPress: () async {
                debugPrint(
                    "Membership Status --> ${membershipInfoList[index].membershipStatus}");
                debugPrint(membershipInfoList[index].roleName);

                String membershipType =
                    membershipInfoList[index].membershipType ?? "";

                if (AppPreferences().role == Constants.supervisorRole &&
                    membershipType == LIFE) {
//supervisor not allowed to see lifetime user membership
                } else {
                  if (membershipInfoList[index].roleName !=
                      Constants
                          .supervisorRole) if (membershipListWidgetSource ==
                      MembershipListWidgetSource.Membership) {
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            /*MembershipScreen(
                        membershipId: membershipInfoList == null
                            ? List()
                            : membershipInfoList[index].membershipId,
                      ),*/

                            MembershipInappWebviewScreen(
                          departmentName:
                              membershipInfoList[index].departmentName,
                          userName: membershipInfoList[index].userName,
                          loggedInRole: "supervisor",
                          membershipId: membershipInfoList[index].membershipId,
                          clientId: AppPreferences().clientId,
                          membershipInfo: membershipInfoList[index],
                        ),
                      ),
                    );
                    successCallback(refresh);
                  } else if (membershipInfoList[index].roleName !=
                      Constants
                          .supervisorRole) if (membershipListWidgetSource ==
                      MembershipListWidgetSource.MembershipHierarchy) {
                    final refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            /*MembershipScreen(
                          membershipId: membershipInfoList == null
                              ? List()
                              : membershipInfoList[index].membershipId,
                          isCameHierarchyFrom: true),*/
                            MembershipInappWebviewScreen(
                          departmentName:
                              membershipInfoList[index].departmentName,
                          userName: membershipInfoList[index].userName,
                          loggedInRole: "supervisor",
                          membershipId: membershipInfoList[index].membershipId,
                          clientId: AppPreferences().clientId,
                          membershipInfo: membershipInfoList[index],
                        ),
                      ),
                    );
                    successCallback(refresh);
                  } else {
                    People people = People();
                    people.userName = membershipInfoList[index].userName;
                    debugPrint("userName --> ${people.userName}");
                    people.firstName = membershipInfoList[index].firstName;
                    people.lastName = membershipInfoList[index].lastName;
                    Navigator.pushNamed(context, Routes.diabetesRiskScoreList,
                        arguments: Args(people: people));
                  }
                }
              },
              membershipInfo: membershipInfoList[index],
              membershipListWidgetSource: membershipListWidgetSource,
            );
          },
        ),
      ],
    );
  }
}
