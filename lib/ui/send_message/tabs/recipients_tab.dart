import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../../ui_utils/app_colors.dart';
import '../../../utils/routes.dart';
import '../../custom_drawer/navigation_home_screen.dart';
import '../model/contact_info.dart';
import '../model/group_info.dart';
import '../model/committee_info.dart';
import 'contacts_tab.dart';
import 'groups_tab.dart';
import 'committee_tab.dart';
import '../../../utils/app_preferences.dart';

class RecipientsTabScreen extends StatefulWidget {
  final List<ContactInfo> contacts;
  final List<GroupInfo> groups;
  final List<CommitteeInfo> committees;
  final void Function(List<ContactInfo>, List<GroupInfo>, List<CommitteeInfo>)
      selectedRecipientsCallback;

  const RecipientsTabScreen(
      {Key key,
      this.selectedRecipientsCallback,
      this.contacts,
      this.groups,
      this.committees})
      : super(key: key);
  @override
  _RecipientsTabScreenState createState() => _RecipientsTabScreenState();
}

class _RecipientsTabScreenState extends State<RecipientsTabScreen>
    with TickerProviderStateMixin {
  GlobalKey<ContactListTabState> _contactListTabKey = GlobalKey();
  GlobalKey<GroupsTabState> _groupTabKey = GlobalKey();
  GlobalKey<CommitteeListTabState> _committeeTabKey = GlobalKey();

  int contactCount = 0;
  int committeeCount = 0;
  int groupCount = 0;
  int totalCount = 0;
  List<String> tabNames = ["Contact", "Group", "Committee"];
  int currentTab = 0;
  TabController _controller;
  List<ContactInfo> selectContacts = List<ContactInfo>();
  List<GroupInfo> selectedGroups = List<GroupInfo>();
  List<CommitteeInfo> selectedCommittee = List<CommitteeInfo>();

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3)
      // ..animateTo(20,duration: Duration(milliseconds: 100),curve: Curves.easeIn)
      ..addListener(() {
        setState(() {
          currentTab = _controller.index;
        });
      });
    selectContacts = widget.contacts;
    selectedGroups = widget.groups;
    selectedCommittee = widget.committees;
    totalCount = selectContacts.length +
        selectedGroups.length +
        selectedCommittee.length;
  }

  ContactInfo findContactByContactName(String contactName) {
    ContactInfo contactInfo;
    if (selectContacts.isNotEmpty) {
      selectContacts.forEach((v) {
        if (v.contactName != null && v.contactName == contactName) {
          contactInfo = v;
        }
      });
    }
    return contactInfo;
  }

  GroupInfo findGroupByName(String groupName) {
    GroupInfo groupInfo;
    if (selectedGroups.isNotEmpty) {
      selectedGroups.forEach((v) {
        if (v.groupName != null && v.groupName == groupName) {
          groupInfo = v;
        }
      });
    }
    return groupInfo;
  }

  CommitteeInfo findCommiteeByName(String committeeName) {
    CommitteeInfo committeeInfo;
    if (selectedCommittee.isNotEmpty) {
      selectedCommittee.forEach((v) {
        if (v.departmentName != null && v.committeeName == committeeName) {
          committeeInfo = v;
        }
      });
    }
    return committeeInfo;
  }

  Future<bool> _onBackPressed() {
    widget.selectedRecipientsCallback(
        selectContacts, selectedGroups, selectedCommittee);
    Navigator.pop(context, true);
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: AppColors.primaryColor,
      centerTitle: true,
      title: Text(
        "Select ${tabNames[currentTab]}",
        style: AppPreferences().isLanguageTamil()
            ? TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
            : TextStyle(color: Colors.white),
      ),
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
            }),
      ],
      bottom: TabBar(
        controller: _controller,
        indicatorColor: AppColors.tabBarIndicatorColor,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Contact",
                  style: TextStyle(color: Colors.white),
                ),
                // if (contactCount > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 5),
                //     child: GFBadge(
                //       child: Text(
                //         "$contactCount",
                //         style: TextStyle(color: Colors.black),
                //       ),
                //       color: Colors.white,
                //       shape: GFBadgeShape.pills,
                //       size: GFSize.MEDIUM,
                //     ),
                //   )
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Group", style: TextStyle(color: Colors.white)),
                // if (groupCount > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 5),
                //     child: GFBadge(
                //       child: Text(
                //         "$groupCount",
                //         style: TextStyle(color: Colors.black),
                //       ),
                //       color: Colors.white,
                //       shape: GFBadgeShape.pills,
                //       size: GFSize.MEDIUM,
                //     ),
                //   )
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Committee", style: TextStyle(color: Colors.white)),
                // if (groupCount > 0)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 5),
                //     child: GFBadge(
                //       child: Text(
                //         "$groupCount",
                //         style: TextStyle(color: Colors.black),
                //       ),
                //       color: Colors.white,
                //       shape: GFBadgeShape.pills,
                //       size: GFSize.MEDIUM,
                //     ),
                //   )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: buildAppBar(),
          body: Container(
            margin: EdgeInsets.only(bottom: 50),
            child: TabBarView(
              controller: _controller,
              physics: ScrollPhysics(parent: PageScrollPhysics()),
              children: [
                ContactListTab(
                  key: _contactListTabKey,
                  contacts: widget.contacts,
                  recordCountCallBack: (int recordsCount) {
                    setState(() {
                      contactCount = recordsCount;
                    });
                  },
                  contactChangeCallBack:
                      (ContactInfo contactInfo, bool isSelected) {
                    debugPrint("contactChangeCallBack called... $isSelected");
                    setState(() {
                      if (isSelected) {
                        selectContacts.add(contactInfo);
                      } else {
                        ContactInfo contactInfoTemp =
                            findContactByContactName(contactInfo.contactName);
                        selectContacts.remove(contactInfoTemp);
                      }
                      totalCount = selectContacts.length +
                          selectedGroups.length +
                          selectedCommittee.length;
                      // widget.selectedRecipientsCallback(
                      //     selectContacts, selectedGroups);
                    });
                  },
                ),
                GroupsTab(
                  key: _groupTabKey,
                  selectedGroups: widget.groups,
                  recordCountCallBack: (int recordsCount) {
                    setState(() {
                      groupCount = recordsCount;
                    });
                  },
                  groupChangeCallBack: (GroupInfo groupInfo, bool isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedGroups.add(groupInfo);
                      } else {
                        GroupInfo groupInfoTemp =
                            findGroupByName(groupInfo.groupName);
                        selectedGroups.remove(groupInfoTemp);
                      }
                      totalCount = selectContacts.length +
                          selectedGroups.length +
                          selectedCommittee.length;
                      // widget.selectedRecipientsCallback(
                      //     selectContacts, selectedGroups);
                    });
                  },
                ),
                CommitteeListTab(
                  key: _committeeTabKey,
                  committee: widget.committees,
                  recordCountCallBack: (int recordsCount) {
                    setState(() {
                      committeeCount = recordsCount;
                    });
                  },
                  committeeChangeCallBack:
                      (CommitteeInfo contactInfo, bool isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedCommittee.add(contactInfo);
                      } else {
                        CommitteeInfo committeeInfoTemp =
                            findCommiteeByName(contactInfo.committeeName);
                        selectedCommittee.remove(committeeInfoTemp);
                      }
                      totalCount = selectContacts.length +
                          selectedGroups.length +
                          selectedCommittee.length;
                      // widget.selectedRecipientsCallback(
                      //     selectContacts, selectedGroups);
                    });
                  },
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  child: FlatButton(
                    color: Colors.white,
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      //FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        selectedGroups.clear();
                        selectContacts.clear();
                        selectedCommittee.clear();
                        totalCount = selectContacts.length +
                            selectedGroups.length +
                            selectedCommittee.length;
                        _contactListTabKey.currentState.resetSelectedContacts();
                        if (_groupTabKey.currentState != null)
                          _groupTabKey.currentState.resetSelectedGroups();
                        if (_committeeTabKey.currentState != null)
                          _committeeTabKey.currentState.resetSelectedContacts();
                        widget.selectedRecipientsCallback(
                            selectContacts, selectedGroups, selectedCommittee);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.blue,
                          width: 2,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  height: 40,
                  width: 120,
                  child: RaisedButton(
                    color: AppColors.arrivedColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Select",
                          style: TextStyle(color: Colors.white),
                        ),
                        if (totalCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GFBadge(
                              child: Text(
                                "$totalCount",
                                style: TextStyle(color: Colors.black),
                              ),
                              color: Colors.white,
                              shape: GFBadgeShape.pills,
                              size: GFSize.MEDIUM,
                            ),
                          )
                      ],
                    ),
                    onPressed: () {
                      debugPrint("Select clicked...");
                      //FocusScope.of(context).requestFocus(FocusNode());
                      widget.selectedRecipientsCallback(
                          selectContacts, selectedGroups, selectedCommittee);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
