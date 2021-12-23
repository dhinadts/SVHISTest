import '../../../ui/membership/bloc/membership_event.dart';
import '../../../utils/app_pref_secure.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

import '../../../bloc/people_list_bloc.dart';
import '../../../ui_utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../custom_drawer/navigation_home_screen.dart';
import '../../membership/api/membership_api_client.dart';
import '../repository/diabetes_risk_score_api_client.dart';
import 'membership_riskscore_list_tab.dart';
import 'non_membership_riskscore_list_tab.dart';
import 'prospective_user_riskscore_list_tab.dart';

class DiabetesRiskScoreTab extends StatefulWidget {
  final String title;
  const DiabetesRiskScoreTab({
    Key key,
    this.title,
  }) : super(key: key);
  @override
  _DiabetesRiskScoreTabState createState() => _DiabetesRiskScoreTabState();
}

class _DiabetesRiskScoreTabState extends State<DiabetesRiskScoreTab> {
  int membershipCount = 0;
  int nonMembershipCount = 0;
  int prospectsCount = 0;

  final MembershipApiClient _membershipApiClient =
      MembershipApiClient(httpClient: http.Client());
  final DiabetesRiskScoreApiClient _riskScoreApiClient =
      DiabetesRiskScoreApiClient(
    httpClient: http.Client(),
  );

  PeopleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    fetchMembershipCount();
    fetchNonMembershipCount();
    fetchProspectsCount();
  }

  fetchMembershipCount() async {
    _bloc = new PeopleListBloc(context);
    /*_bloc.fetchSecondaryUserList(
        parentUserName: '',
        departmentName: widget.departmentName,
        isFromAddUserFamily: false);*/
    _bloc.fetchPeopleList(
        onlyPrimary: false,
        departmentName: AppPreferences().deptmentName,
        membershipType: "Member");
    _bloc.peopleListFetcher.listen((value) {
      setState(() {
        membershipCount = value.peopleResponse.length;
      });
    });
    /* final membershipList =
        await _membershipApiClient.filterMembershipList("Approved");
    if (membershipList != null) {
      setState(() {
        membershipCount = membershipList.length;
      });
    } */
  }

  fetchNonMembershipCount() {
    _bloc = new PeopleListBloc(context);
    // _bloc.fetchNonMembershipList();
    _bloc.fetchPeopleList(
        onlyPrimary: false,
        departmentName: AppPreferences().deptmentName,
        membershipType: "User");

    _bloc.peopleListFetcher.listen((value) {
      if (value != null) {
        setState(() {
          nonMembershipCount = value.peopleResponse.length;
        });
      }
    });
  }

  fetchProspectsCount() async {
    final healthScoreList =
        await _riskScoreApiClient.getHealthScoreHistoryListForProspects("");
    if (healthScoreList != null) {
      setState(() {
        prospectsCount = healthScoreList.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.title == null ? "Diabetes Risk Score" : widget.title),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  //replaceHome();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationHomeScreen()),
                      ModalRoute.withName(Routes.dashBoard));
                }),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.tabBarIndicatorColor,
            tabs: [
              Tab(
                child: (membershipCount > -1)
                    ? Column(
                        children: [
                          Text(
                            "Members",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GFBadge(
                              child: Text(
                                "$membershipCount",
                                style: TextStyle(color: Colors.black),
                              ),
                              color: Colors.white,
                              shape: GFBadgeShape.pills,
                              size: GFSize.MEDIUM,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "Members",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
              ),
              Tab(
                child: (nonMembershipCount > -1)
                    ? Column(
                        children: [
                          Text(
                            "Non-Members",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GFBadge(
                              child: Text(
                                "$nonMembershipCount",
                                style: TextStyle(color: Colors.black),
                              ),
                              color: Colors.white,
                              shape: GFBadgeShape.pills,
                              size: GFSize.MEDIUM,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "Non-Members",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
              ),
              Tab(
                child: (prospectsCount > -1)
                    ? Column(
                        children: [
                          Text(
                            "Prospects",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GFBadge(
                              child: Text(
                                "$prospectsCount",
                                style: TextStyle(color: Colors.black),
                              ),
                              color: Colors.white,
                              shape: GFBadgeShape.pills,
                              size: GFSize.MEDIUM,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "Prospects",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
              ),
            ],
          ),
        ),
        body: TabBarView(
            physics: ScrollPhysics(parent: PageScrollPhysics()),
            children: [
              MembershipRiskScoreListTab(),
              NonMembershipRiskScoreListTab(),
              ProspectiveUserRiskscoreListTab(
                updateCallback: (bool result) {
                  if (result) {
                    fetchProspectsCount();
                  }
                },
              ),
            ]),
      ),
    );
  }
}
