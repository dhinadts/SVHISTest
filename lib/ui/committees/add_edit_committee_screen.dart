import 'dart:convert';

import '../../ui/hierarchical/bloc/department_bloc.dart';
import '../../ui/reset_password_screen.dart';
import '../../utils/validation_utils.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../login/utils/custom_progress_dialog.dart';
import '../../model/user_info.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/network_check.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../utils/app_preferences.dart';
import '../../utils/routes.dart';
import '../../widgets/linked_lable_checkbox.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/submit_button.dart';
import '../custom_drawer/navigation_home_screen.dart';
import '../settings_screen.dart';
import 'bloc/committees_bloc.dart';
import 'committee_roles_screen.dart';
import 'model/committee_data.dart';

class AddEditCommitteeScreen extends StatefulWidget {
  final String committeeName;
  final String committeeDepartmentName;
  final bool isUpdate;

  const AddEditCommitteeScreen(
      {Key key,
      this.committeeName,
      this.isUpdate = false,
      this.committeeDepartmentName})
      : super(key: key);

  @override
  _AddEditCommitteeScreenState createState() => _AddEditCommitteeScreenState();
}

bool waiting = false;

class _AddEditCommitteeScreenState extends State<AddEditCommitteeScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _autoValidate = false;
  bool isDataLoaded = false;

  //bool isMemberListUserLoaded = false;
  List departmentList = new List();

  List<DropdownMenuItem<String>> memberTypeList = [];

  Map<String, List<SelectedMemberListUser>> committeeMemberMap = new Map();
  List<SelectedMemberListUser> userList = new List();
  List<SelectedMemberListUser> filteredUserList = new List();

  bool update = false;

  TextEditingController committeeNameController = new TextEditingController();

  TextEditingController jointTeamController = new TextEditingController();

  TextEditingController committeeStrengthController =
      new TextEditingController();
  TextEditingController aboutCommitteeController = new TextEditingController();
  TextEditingController commentsController = new TextEditingController();

  TextEditingController companyPoliciesController = new TextEditingController();
  TextEditingController membersDoDontController = new TextEditingController();
  TextEditingController committeeDocumentsController =
      new TextEditingController();
  TextEditingController committeeMembersController =
      new TextEditingController();

  TextEditingController committeeNameDialogController = TextEditingController();
  TextEditingController committeeTitleDialogController =
      TextEditingController();
  double popupMenuItemHeight = 40;
  bool active = true;
  bool companyPoliciesUploaded = false;
  bool membersDoDontUploaded = false;
  bool committeeDocumentsUploaded = false;
  bool committeeMembersUploaded = false;

  FilePickerResult companyPoliciesFile;
  FilePickerResult membersDoDontFile;
  FilePickerResult committeeDocumentsFile;
  FilePickerResult committeeMembersFile;

  List<CommitteeMembers> committeeMembersList = [];
  String filterUser = "";
  List<String> filterUserCategory = ["User", "Supervisor"];
  bool isFirstLoad = true;
  bool isCommitteeDetailsExpandedOpened = false;

  TextEditingController searchController = new TextEditingController();

  CommitteeData committeeData;

  List<dynamic> selectedUserList = List<dynamic>();
  bool isDepartmentUserListLoaded = false;

  void _activeChanged(bool newValue) => setState(() {
        active = newValue;
      });

  void _companyPoliciesChanged(bool newValue) => setState(() {
        companyPoliciesUploaded = newValue;

        if (companyPoliciesUploaded) {
        } else {
          companyPoliciesController.clear();
          companyPoliciesFile = null;
        }
      });

  void _membersDoDontChanged(bool newValue) => setState(() {
        membersDoDontUploaded = newValue;

        if (membersDoDontUploaded) {
        } else {
          membersDoDontController.clear();
          membersDoDontFile = null;
        }
      });

  void _committeeDocumentsChanged(bool newValue) => setState(() {
        committeeDocumentsUploaded = newValue;
        if (committeeDocumentsUploaded) {
        } else {
          committeeDocumentsController.clear();
          committeeDocumentsFile = null;
        }
      });

  void _committeeMembersChanged(bool newValue) => setState(() {
        committeeMembersUploaded = newValue;
        if (committeeMembersUploaded) {
        } else {
          committeeMembersController.clear();
          committeeMembersFile = null;
        }
      });

  ExpandableController _commiteeDetailsExpandableController;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  initState() {
    /* flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification); */
    if (AppPreferences().isMembershipApplicable) {
      filterUserCategory.add("Member");
    }
    if (widget.isUpdate) {
      update = true;
      CommitteesBloc committeesBloc = CommitteesBloc(context);
      committeesBloc.getCommittee(
          widget.committeeName, widget.committeeDepartmentName);
      committeesBloc.committeeDataFetcher.listen((value) {
        committeeData = value;
        print(value.memberTypes.toString());
        getDepartmentList();
        getCommitteeRoleDefinitionList();
        //print("committeeData members ${committeeData.members}");
        committeeNameController.text = committeeData.committeeName;
        active = committeeData.active;
        committeeStrengthController.text = committeeData.committeeStrength;
        commentsController.text = committeeData.comments;
        selectedUserList = committeeData.members;

        List<CommitteeMembers> committeeMemberTypesList = new List();
        List<DropdownMenuItem<String>> committeeMemberTypeList = new List();
        //List<CommitteeMembers> committeeMemberTypesList = new List();
        if (committeeData.memberTypes != null) {
          committeeData.memberTypes.forEach((element) {
            committeeMemberTypesList.add(CommitteeMembers(element));
            committeeMemberTypeList.add(
                DropdownMenuItem(child: Text("$element"), value: "$element"));
          });
        }

        committeeMembersList = committeeMemberTypesList;
        memberTypeList = committeeMemberTypeList;

        //print("selectedUserList $selectedUserList");
      });
    } else {
      getDepartmentList();
      getCommitteeRoleDefinitionList();
    }
    super.initState();

    initializeAd();
  }

  Widget myPopMenu() {
    return PopupMenuButton(
        offset: Offset(0, 50),
        child: Container(
          width: 48,
          height: 48,
          decoration: const ShapeDecoration(
            color: Colors.blueGrey,
            shape: CircleBorder(),
          ),
          child: Icon(
            Icons.filter_list,
            color: Colors.white,
          ),
        ),
        onSelected: (value) {
          switch (value) {
            case -1:
              break;
            case 1:
              setState(() {
                filterUser = "User";
                onSearchTextChanged(searchController.text);
              });
              break;
            case 2:
              setState(() {
                filterUser = "Member";
                onSearchTextChanged(searchController.text);
              });
              break;
            case 3:
              setState(() {
                filterUser = "";
                searchController.clear();
                onSearchTextChanged(searchController.text);
              });
              break;
            default:
              setState(() {
                filterUser = "";
                searchController.clear();
                onSearchTextChanged(searchController.text);
              });
              break;
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                height: popupMenuItemHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter by Category",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.cancel,
                      size: 30.0,
                    ),
                  ],
                ),
                value: -1,
              ),
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text('User'),
                      )
                    ],
                  )),
              filterUserCategory.contains("Member")
                  ? PopupMenuItem(
                      value: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("Member"),
                      ),
                    )
                  : PopupMenuItem(
                      height: 0,
                      child: null,
                    ),
              PopupMenuItem(
                height: popupMenuItemHeight,
                child: Text(
                  "Clear",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                value: -1,
              ),
              PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text('All'),
                      )
                    ],
                  )),
            ]);
  }
  /* Future _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    print("testing....");
    print(obj);
    print(obj['isSuccess']);
    if (obj['isSuccess']) {
      // OpenFile.open(obj['filePath']);

      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SettingsScreen(title: "Testing"),
      //   ),
      // ).catchError((onError) => print("ERROR on CLICK : $onError"));

      await Future.delayed(
        const Duration(milliseconds: 200),
        () => MyAppState.navigatorKey.currentState.push(
          MaterialPageRoute(
            builder: (context) => SettingsScreen(title: "Testing"),
          ),
        ),
      );
      // Fluttertoast.showToast(msg: "Test", gravity: ToastGravity.TOP);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
    /* try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(title: "Testing"),
        ),
      );
    } catch (e) {
      print("Error: ${e.toString()}");
    } */

    if (json == "success") {
      // OpenFile.open(obj['filePath']);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(title: "Testing"),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('error'),
        ),
      );
    }
  } */

  getCommitteeRoleDefinitionList() async {
    CommitteesBloc committeesBloc = CommitteesBloc(context);
    committeesBloc.getCommitteeRoleDefinitionList();
    committeesBloc.committeeMembersListFetcher.listen((value) {
      if (value != null) {
        committeeMembersList.clear();
        memberTypeList.clear();
        value.forEach((v) {
          committeeMembersList.add(CommitteeMembers(v));
          memberTypeList.add(DropdownMenuItem(child: Text("$v"), value: "$v"));
        });

        setState(() {});
      }
    });
  }

  getDepartmentList() async {
    DepartmentBloc departmentBloc = DepartmentBloc(context);
    departmentBloc.getDepartment();
    departmentBloc.departmentFetcher.listen((value) {
      if (ValidationUtils.isSuccessResponse(value.status)
          // &&
          //     value.subDepartments != null &&
          //     value.subDepartments.length > 0
          ) {
        departmentList.clear();
        departmentList.add({
          "value": AppPreferences().deptmentName,
          "display": AppPreferences().deptmentName,
        });

        if (value.subDepartments != null) {
          for (var i = 0; i < value.subDepartments.length; i++) {
            // String departmentData = v;
            departmentList.add({
              "value": value.subDepartments[i].departmentName.toString(),
              "display": value.subDepartments[i].departmentName.toString()
            });
          }
        }
        // CommitteesBloc committeesBloc = CommitteesBloc(context);
        // committeesBloc.getDepartmentList();
        // committeesBloc.departmentListFetcher.listen((value) {
        // print("Value getDepartmentList $value");
        // if (value != null) {
        //   for (String v in value) {
        //     String departmentData = v;
        //     departmentList.add({
        //       "value": departmentData.toString(),
        //       "display": departmentData.toString()
        //     });
        //   }

        setState(() {
          //print("Value departmentList ${departmentList}");
          List<String> departmentNames = [];
          if (update) {
            String teamJointText = "";

            int index = 1;
            if (committeeData.groups != null) {
              committeeData.groups.forEach((element) {
                if (index == 1)
                  teamJointText = element;
                else
                  teamJointText = teamJointText + ", " + element;
                index += index;
              });
            }

            jointTeamController.text = teamJointText;
          } else {
            //jointTeamController.text = departmentList[0]["value"];
            jointTeamController.text = AppPreferences().deptmentName;
          }

          List<String> selectedJointGroup = jointTeamController.text.split(",");
          selectedJointGroup.forEach((element) {
            departmentNames.add(element.trim());
          });

          getDepartmentUserList(departmentNames);
          isDataLoaded = true;
        });
      }
    });
  }

  getDepartmentUserList(List<String> departmentNames) {
    setState(() {
      isDepartmentUserListLoaded = false;
    });
    CommitteesBloc committeesBloc = CommitteesBloc(context);
    committeesBloc.getDepartmentUserList(departmentNames);
    committeesBloc.departmentUserListFetcher.listen((value) {
      //print("Value getDepartmentUserList $value");
      if (isFirstLoad) {
        isFirstLoad = false;
      } else {
        committeeStrengthController.text = "";
        //selectedUserList.clear();
      }

      userList = new List<SelectedMemberListUser>();
      if (value != null && value.length > 0) {
        for (int i = 0; i < value.length; i++) {
          userList.add(SelectedMemberListUser(
              value[i].departmentName,
              value[i].userName,
              false,
              "Member",
              value[i].firstName,
              value[i].lastName,
              value[i].membershipType == "Member"
                  ? "Member"
                  : value[i].roleName));
        }
        var tempList =
            userList.where((element) => element.role == "Supervisor").toList();
        userList.removeWhere((element) => element.role == "Supervisor");
        userList = [...tempList, ...userList];

        List<dynamic> tempSelectedUserList = new List<dynamic>();
        selectedUserList.forEach((element) {
          tempSelectedUserList.add(element);
        });

        selectedUserList.clear();

        //selectedUserList = committeeData.members;
        //committeeStrengthController.text = selectedUserList.length.toString();
        for (int i = 0; i < userList.length; i++) {
          for (int j = 0; j < tempSelectedUserList?.length; j++) {
            if (userList[i].username == tempSelectedUserList[j]['userName']) {
              Map<String, dynamic> selectedUser = {};
              selectedUser['memberDepartment'] = userList[i].departmentName;
              selectedUser['memberType'] = userList[i].memberType;
              selectedUser['firstName'] = userList[i].firstName;
              selectedUser['lastName'] = userList[i].lastName;
              selectedUser['userName'] = userList[i].username;
              selectedUser['roleName'] = userList[i].role;

              selectedUserList.add(selectedUser);

              userList[i].checkboxValue = true;
              userList[i].memberType = tempSelectedUserList[j]["memberType"];
              break;
            }
          }
        }
        //}
        setState(() {
          isDepartmentUserListLoaded = true;
          if (selectedUserList.length > 0) {
            committeeStrengthController.text =
                selectedUserList.length.toString();
          }
        });
      } else {
        debugPrint("Else condition....");
        setState(() {
          isDepartmentUserListLoaded = true;
        });
        userList.clear();
        filteredUserList.clear();
      }
    });
  }

  getMemberTypeList() {
    committeeMembersList.forEach((title) {
      memberTypeList
          .add(DropdownMenuItem(child: Text("$title"), value: "$title"));
    });
  }

  Widget memberListUsers() {
    return !isDepartmentUserListLoaded
        ? Container(
            //padding: EdgeInsets.only(top: AppUIDimens.paddingSmall),
            //margin: EdgeInsets.all(6),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(4),
            //     border: Border.all(color: Colors.blueAccent, width: 3)),
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width * 1,
            child: ListLoading(
              itemCount: 8,
            ),
          )
        : Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 1,
            child: (userList.length == 0) ||
                    (filteredUserList.length == 0 &&
                        searchController.text.isNotEmpty)
                ? Center(child: Text("No data available"))
                : Stack(
                    children: <Widget>[
                      Scrollbar(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 2),
                          itemCount: filteredUserList.length != 0 ||
                                  searchController.text.isNotEmpty
                              ? filteredUserList.length
                              : userList.length,
                          itemBuilder: (context, index) {
                            return filterUser == userList[index].role ||
                                    filterUser.isEmpty
                                ? userListItemWidget(
                                    filteredUserList.length != 0 ||
                                            searchController.text.isNotEmpty
                                        ? filteredUserList[index]
                                        : userList[index])
                                : Container();

                            // filterUser == ""
                            //     ? userListItemWidget(
                            //         filteredUserList.length != 0 ||
                            //                 searchController.text.isNotEmpty
                            //             ? filteredUserList[index]
                            //             : userList[index])
                            //     : userListItemWidget(
                            //         filteredUserList.length != 0 ||
                            //                 searchController.text.isNotEmpty
                            //             ? filteredUserList[index]
                            //             : userList[index]);
                          },
                        ),
                      ),
                      // if (userList.length == 0 || userList.isEmpty)
                      //   Align(child: Text("No data available")),
                    ],
                  ),
          );
  }

  Widget userListItemWidget(SelectedMemberListUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(
                "${user?.firstName} ${user.lastName}",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
            )),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppUIDimens.paddingMedium),
              margin: EdgeInsets.only(
                  right: AppUIDimens.paddingXSmall,
                  left: AppUIDimens.paddingSmall,
                  top: 5),
              decoration: BoxDecoration(
                  color: user?.role == "User" ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                user?.role,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            LinkedLabelCheckbox(
              padding: EdgeInsets.only(left: 1),
              value: user.checkboxValue,
              onChanged: (bool newValue) {
                setState(() {
                  user.checkboxValue = !user.checkboxValue;
                  if (newValue) {
                    Map<String, dynamic> selectedUser = {};
                    selectedUser['memberDepartment'] = user.departmentName;
                    selectedUser['memberType'] = user.memberType;
                    selectedUser['firstName'] = user.firstName;
                    selectedUser['lastName'] = user.lastName;
                    selectedUser['userName'] = user.username;
                    selectedUser['roleName'] = user.role;

                    selectedUserList.add(selectedUser);
                  } else {
                    for (int index = 0;
                        index < selectedUserList.length;
                        index++) {
                      Map<String, dynamic> selectedUser =
                          selectedUserList[index];

                      if (user.username == selectedUser["userName"]) {
                        selectedUserList.removeAt(index);
                        break;
                      }
                    }
                  }

                  if (selectedUserList.length > 0) {
                    committeeStrengthController.text =
                        selectedUserList.length.toString();
                  } else {
                    committeeStrengthController.text = "";
                  }
                });
              },
              label: "",
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!user.checkboxValue) {
                    Fluttertoast.showToast(
                        timeInSecForIosWeb: 5,
                        msg:
                            "Role can’t be assigned to someone who is not a part of this committee",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP);
                  }
                },
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(right: AppUIDimens.paddingSmall),
                  child: Theme(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: user.memberType,
                        items: memberTypeList ?? [],
                        onChanged: (selectedValue) {
                          if (user.checkboxValue) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              user.memberType = selectedValue;
                            });
                          } else {
                            Fluttertoast.showToast(
                                timeInSecForIosWeb: 5,
                                msg:
                                    "Role can’t be assigned to someone who is not a part of this committee",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP);
                          }
                        },
                      ),
                    ),
                    data: new ThemeData.light(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          //margin: EdgeInsets.symmetric(horizontal: 15),
          height: 1,
          color: AppColors.borderLine,
        ),
        Container(
          width: double.infinity,
          //margin: EdgeInsets.symmetric(horizontal: 15),
          height: 3,
          color: AppColors.borderShadow,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      context = context;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          update ? "Edit Committee" : "Create Committee",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen(
                            drawerIndex: Constants.PAGE_ID_COMMITTEES,
                          )),
                  ModalRoute.withName(Routes.navigatorHomeScreen));
            }),
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
            },
          ),
          waiting
              ? PopupMenuButton(
                  itemBuilder: (context) {
                    var list = List<PopupMenuEntry<Object>>();
                    list.add(
                      PopupMenuItem(
                        height: 40,
                        child: Text(
                          "Role Definition",
                        ),
                        value: -1,
                      ),
                    );
                    return list;
                  },
                  offset: Offset(0, 50),
                  onCanceled: () {},
                  onSelected: (value) {
                    var duplicates = new List();
                    for (var i = 0; i < userList.length; i++) {
                      duplicates.add(userList[i].memberType);
                    }
                    // print("length users- ${userList.length}");
                    var removedDuplicates = duplicates.toSet().toList();

                    // print(duplicates);
                    // print(removedDuplicates);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommitteeRoleScreen(
                          memberTypes: removedDuplicates,
                          selectedCommitteeMembersList: committeeMembersList,
                          teamOrGroup: jointTeamController.text,
                          updateSelectedCommitteeMembersList:
                              (committeeMembersUpdated) {
                            committeeMembersList.clear();
                            memberTypeList.clear();

                            committeeMembersUpdated.forEach((v) {
                              committeeMembersList
                                  .add(CommitteeMembers(v.title));
                              memberTypeList.add(DropdownMenuItem(
                                  child: Text("${v.title}"),
                                  value: "${v.title}"));
                            });
                            setState(() {});
                            debugPrint(
                                "committeeMembers count is --> ${committeeMembersUpdated.length}");
                          },
                          // rollChangeCallBack: (committeeMember, bool status) {
                          //   debugPrint("roll change --> $committeeMember, $status");
                          // },
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  ),
                  //onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CommitteeRoleScreen(
                  //       selectedCommitteeMembersList: committeeMembersList,
                  //       teamOrGroup: jointTeamController.text,
                  //       updateSelectedCommitteeMembersList:
                  //           (committeeMembersUpdated) {
                  //         committeeMembersList.clear();
                  //         memberTypeList.clear();

                  //         committeeMembersUpdated.forEach((v) {
                  //           committeeMembersList.add(CommitteeMembers(v.title));
                  //           memberTypeList.add(DropdownMenuItem(
                  //               child: Text("${v.title}"), value: "${v.title}"));
                  //         });
                  //         setState(() {});
                  //         debugPrint(
                  //             "committeeMembers count is --> ${committeeMembersUpdated.length}");
                  //       },
                  //       // rollChangeCallBack: (committeeMember, bool status) {
                  //       //   debugPrint("roll change --> $committeeMember, $status");
                  //       // },
                  //     ),
                  //   ),
                  // );
                  //},
                )
              : SizedBox.shrink(),
          //onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CommitteeRoleScreen(
          //       selectedCommitteeMembersList: committeeMembersList,
          //       teamOrGroup: jointTeamController.text,
          //       updateSelectedCommitteeMembersList:
          //           (committeeMembersUpdated) {
          //         committeeMembersList.clear();
          //         memberTypeList.clear();

          //         committeeMembersUpdated.forEach((v) {
          //           committeeMembersList.add(CommitteeMembers(v.title));
          //           memberTypeList.add(DropdownMenuItem(
          //               child: Text("${v.title}"), value: "${v.title}"));
          //         });
          //         setState(() {});
          //         debugPrint(
          //             "committeeMembers count is --> ${committeeMembersUpdated.length}");
          //       },
          //       // rollChangeCallBack: (committeeMember, bool status) {
          //       //   debugPrint("roll change --> $committeeMember, $status");
          //       // },
          //     ),
          //   ),
          // );
          //},
          // ),
          //),
        ],
      ),
      body: isDepartmentUserListLoaded // && waiting
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              committeeDetailsWidget(),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: committeeMembersListWidget(),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: uploadOptionsWidget(),
                              // ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Stack(
                                children: [
                                  SubmitButton(
                                    text: update ? "Update" : "Create",
                                    color: waiting
                                        ? AppColors.arrivedColor
                                        : Colors.grey,
                                    onPress: !waiting
                                        ? null
                                        : () {
                                            //if (waiting) {
                                            onSubmitClick(context);
                                            //} else {
                                            // FocusScope.of(context)
                                            //     .requestFocus(FocusNode());
                                            // showDialog(
                                            //     context: context,
                                            //     builder: (BuildContext context) {
                                            //       return CircularProgressIndicator();
                                            //     });
                                            //}
                                          },
                                  ),
                                  /* waiting
                                    ? SizedBox()
                                    : Positioned(
                                        left: 20.0,
                                        top: 8,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ))), */
                                ],
                              ),

                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  getSivisoftAdWidget(),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  committeeDetailsWidget() {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ScrollOnExpand(
          child: Builder(
            builder: (context) {
              _commiteeDetailsExpandableController =
                  ExpandableController.of(context);
              if (!isCommitteeDetailsExpandedOpened) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  isCommitteeDetailsExpandedOpened = true;
                  _commiteeDetailsExpandableController.toggle();
                });
              }
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Column(
                  children: <Widget>[
                    ExpandablePanel(
                      header: Container(
                        width: double.infinity,
                        height: 50,
                        color: AppColors.primaryColor,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Committee Details",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      expanded: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AppUIDimens.paddingMedium,
                                    top: 0,
                                    bottom: 0,
                                    right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Text("Name "),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            update
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppUIDimens.paddingSmall,
                                          top: 2,
                                          bottom: 0,
                                          right: AppUIDimens.paddingSmall),
                                      child: TextFormField(
                                        controller: committeeNameController,
                                        enabled: false,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 16),
                                          hintText: "Name",
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                        ),
//
                                        onSaved: (String val) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          committeeNameController.text = val;
                                        },
                                      ),
                                    ),
                                  )
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppUIDimens.paddingSmall,
                                          top: 2,
                                          bottom: 0,
                                          right: AppUIDimens.paddingSmall),
                                      child: TextFormField(
                                        controller: committeeNameController,
                                        enabled: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 16),
                                          hintText: "Name",
                                          fillColor: Colors.transparent,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                        ),
                                        onSaved: (String val) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          committeeNameController.text = val;
                                        },
                                      ),
                                    ),
                                  ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AppUIDimens.paddingMedium,
                                    top: 10,
                                    bottom: 2,
                                    right: AppUIDimens.paddingSmall),
                                child: Text("Team/Group"),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AppUIDimens.paddingSmall,
                                    top: 2,
                                    bottom: 1,
                                    right: AppUIDimens.paddingSmall),
                                child: TextFormField(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _showMultiSelect(context);
                                  },
                                  enableInteractiveSelection: false,
                                  controller: jointTeamController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 16),
                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.arrow_drop_down),
                                        onPressed: () {}),
                                    hintText: "",
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: AppUIDimens.paddingMedium, top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Active",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Checkbox(
                                      value: active, onChanged: _activeChanged),
                                ],
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppUIDimens.paddingMedium,
                                      top: 0,
                                      bottom: 0,
                                      right: AppUIDimens.paddingSmall),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "About the committee",
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AppUIDimens.paddingSmall,
                                    top: 2,
                                    bottom: 0,
                                    right: AppUIDimens.paddingSmall),
                                child: TextFormField(
                                  controller: commentsController,
                                  maxLines: 3,
                                  maxLength: 120,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    hintText: "About the committee",
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                  onSaved: (String val) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    commentsController.text = val;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  committeeMembersListWidget() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              //controller: expandableController,

              header: Container(
                width: double.infinity,
                height: 50,
                color: AppColors.primaryColor,
                child: Container(
                  //alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Members Listing",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      if (committeeStrengthController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: GFBadge(
                            child: Text(
                              "${committeeStrengthController.text}",
                              style: TextStyle(color: Colors.black),
                            ),
                            color: Colors.white,
                            shape: GFBadgeShape.pills,
                            size: GFSize.MEDIUM,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              expanded: !waiting
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          // (userList != null && userList.length > 0)
                          //     ?
                          Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, right: 10, bottom: 10),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 16),
                                      labelText: 'Search by Name',
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    onChanged: onSearchTextChanged,
                                  ),
                                ),
                              ),
                              AppPreferences().isMembershipApplicable
                                  ? myPopMenu()
                                  : Container()
                            ],
                          ),
                          memberListUsers(),
                        ],
                      )
                      //: Align(child: Text("No data available")),
                      // (update
                      //     ? Align(child: Text("No data available"))
                      //     : Container()),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    filteredUserList.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < userList.length; i++) {
      if (userList[i].firstName.toLowerCase().contains(text.toLowerCase()) ||
          userList[i].lastName.toLowerCase().contains(text.toLowerCase())) {
        if (filterUser == userList[i].role) {
          filteredUserList.add(userList[i]);
        } else if (filterUser.isEmpty) {
          filteredUserList.add(userList[i]);
        }
      }
    }

    setState(() {});
  }

  uploadOptionsWidget() {
    debugPrint("uploadOptionsWidget");
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: <Widget>[
            ExpandablePanel(
              //controller: expandableController,
              header: Container(
                width: double.infinity,
                height: 50,
                color: AppColors.primaryColor,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Uploads",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              expanded: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 130, child: Text("Company policies")),
                          Container(
                            width: 50,
                            child: Checkbox(
                                value: companyPoliciesUploaded,
                                onChanged: _companyPoliciesChanged),
                          ),
                          InkWell(
                            onTap: () async {
                              // companyPoliciesFile = await FilePicker.getFile();

                              companyPoliciesFile =
                                  await FilePicker.platform.pickFiles();

                              if (companyPoliciesFile != null) {
                                PlatformFile file =
                                    companyPoliciesFile.files.first;

                                // print(
                                //     "Company policies file.name ${file.name}");
                                // print(
                                //     "Company policies file.bytes ${file.bytes}");
                                // print(
                                //     "Company policies file.size ${file.size}");
                                // print(
                                //     "Company policies file.extension ${file.extension}");
                                // print(
                                //     "Company policies file.path ${file.path}");

                                setState(() {
                                  companyPoliciesUploaded = true;
                                  companyPoliciesController.text = file.name;
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.arrivedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                    child: Text(
                                  "Browse File",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                      companyPoliciesController.text.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 180.0,
                                    child: Text(companyPoliciesController.text,
                                        style: TextStyle(color: Colors.blue))),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGrassGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                        child: Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      bottomBorder(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 130, child: Text("Member Do & Don'ts")),
                          Container(
                            width: 50,
                            child: Checkbox(
                                value: membersDoDontUploaded,
                                onChanged: _membersDoDontChanged),
                          ),
                          InkWell(
                            onTap: () async {
                              // companyPoliciesFile = await FilePicker.getFile();

                              membersDoDontFile =
                                  await FilePicker.platform.pickFiles();

                              if (membersDoDontFile != null) {
                                PlatformFile file =
                                    membersDoDontFile.files.first;

                                // print(
                                //     "Company policies file.name ${file.name}");
                                // print(
                                //     "Company policies file.bytes ${file.bytes}");
                                // print(
                                //     "Company policies file.size ${file.size}");
                                // print(
                                //     "Company policies file.extension ${file.extension}");
                                // print(
                                //     "Company policies file.path ${file.path}");

                                setState(() {
                                  membersDoDontUploaded = true;
                                  membersDoDontController.text = file.name;
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.arrivedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                    child: Text(
                                  "Browse File",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                      membersDoDontController.text.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 180.0,
                                    child: Text(membersDoDontController.text,
                                        style: TextStyle(color: Colors.blue))),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGrassGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                        child: Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      bottomBorder(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 130, child: Text("Committee Documents")),
                          Container(
                            width: 50,
                            child: Checkbox(
                                value: committeeDocumentsUploaded,
                                onChanged: _committeeDocumentsChanged),
                          ),
                          InkWell(
                            onTap: () async {
                              // companyPoliciesFile = await FilePicker.getFile();

                              committeeDocumentsFile =
                                  await FilePicker.platform.pickFiles();

                              if (committeeDocumentsFile != null) {
                                PlatformFile file =
                                    committeeDocumentsFile.files.first;

                                // print(
                                //     "Company policies file.name ${file.name}");
                                // print(
                                //     "Company policies file.bytes ${file.bytes}");
                                // print(
                                //     "Company policies file.size ${file.size}");
                                // print(
                                //     "Company policies file.extension ${file.extension}");
                                // print(
                                //     "Company policies file.path ${file.path}");

                                setState(() {
                                  committeeDocumentsUploaded = true;
                                  committeeDocumentsController.text = file.name;
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.arrivedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                    child: Text(
                                  "Browse File",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                      committeeDocumentsController.text.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 180.0,
                                    child: Text(
                                        committeeDocumentsController.text,
                                        style: TextStyle(color: Colors.blue))),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGrassGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                        child: Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      bottomBorder(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 130, child: Text("Committee Members")),
                          Container(
                            width: 50,
                            child: Checkbox(
                                value: committeeMembersUploaded,
                                onChanged: _committeeMembersChanged),
                          ),
                          InkWell(
                            onTap: () async {
                              // companyPoliciesFile = await FilePicker.getFile();

                              committeeMembersFile =
                                  await FilePicker.platform.pickFiles();

                              if (committeeMembersFile != null) {
                                PlatformFile file =
                                    committeeMembersFile.files.first;

                                // print(
                                //     "Company policies file.name ${file.name}");
                                // print(
                                //     "Company policies file.bytes ${file.bytes}");
                                // print(
                                //     "Company policies file.size ${file.size}");
                                // print(
                                //     "Company policies file.extension ${file.extension}");
                                // print(
                                //     "Company policies file.path ${file.path}");

                                setState(() {
                                  committeeMembersUploaded = true;
                                  committeeMembersController.text = file.name;
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.arrivedColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                    child: Text(
                                  "Browse File",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      committeeMembersController.text.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 180.0,
                                    child: Text(
                                      committeeMembersController.text,
                                      style: TextStyle(color: Colors.blue),
                                    )),
                                Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.darkGrassGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                        child: Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  )),
              tapHeaderToExpand: true,
              hasIcon: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomBorder() {
    return Column(
      children: [
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
    );
  }

  Widget committeeMemberListItem(UserInfo userData) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(userData.userName),
          Icon(
            Icons.delete_outline,
            color: Colors.black,
          )
        ],
      ),
    );
  }

//  committeeMembersCheckbox() {
//    return Container(
//      padding: EdgeInsets.only(left: 15.0, top: 5, right: 15.0),
//      child: Row(
//        //mainAxisAlignment: MainAxisAlignment.spaceAround,
//        children: [
//          Container(
//            width: 150,
//            child: Column(
//              children: [
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Text(
//                      "Chairperson",
//                      style: TextStyle(fontWeight: FontWeight.bold),
//                    ),
//                  ],
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Text(
//                      "Secretary",
//                      style: TextStyle(fontWeight: FontWeight.bold),
//                    ),
//                  ],
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Container(
//                      child: Flexible(
//                        child: Text(
//                          "Health/Safety Officer",
//                          style: TextStyle(fontWeight: FontWeight.bold),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Container(
//                      child: Flexible(
//                        child: Text(
//                          "Team members",
//                          style: TextStyle(fontWeight: FontWeight.bold),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//          // SizedBox(width: 50.0,),
//          // width: 250,
//          Container(
//            width: 150,
//            child: Column(
//              children: [
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Container(
//                      child: Flexible(
//                        child: Text(
//                          "Volunteer/Co-ordinators",
//                          style: TextStyle(fontWeight: FontWeight.bold),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Text(
//                      "Treasurer",
//                      style: TextStyle(fontWeight: FontWeight.bold),
//                    ),
//                  ],
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: [
//                    Checkbox(
//                        value: rememberMe, onChanged: _onRememberMeChanged),
//                    Container(
//                      child: Flexible(
//                        child: Text(
//                          "Marketing Promotion Officer",
//                          style: TextStyle(fontWeight: FontWeight.bold),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  getItemRelatedTagList(String itemName) async {
    var connectivityResult = await NetworkCheck().check();
    if (connectivityResult) {
      //  getItemRelatedTagListApiCall(itemName);

    } else {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 5,
          msg: Constants.NO_INTERNET_CONNECTION,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP);
    }
  }

//  getItemRelatedTagListApiCall(String itemName){
//    CustomProgressLoader.showLoader(context);
//    recommendedTags="";
//    //tagsController.clear();
//
//    StaticDetailsBloc itemsListBloc = StaticDetailsBloc(context);
//    itemsList = new List();
//    itemsListBloc.fetchItemRelatedTagList(itemName);
//    itemsListBloc.itemRelatedTagListFetcher.listen((value) async {
//
//      //  print("Value of tags $value");
//
//      setState(() {
//        recommendedTags = value;
//        // itemsList.add(element);
//
//        tagsController.text = recommendedTags;
//      });
//
//
//    });
//
//
//    CustomProgressLoader.cancelLoader(context);
//  }

  List<MultiSelectDialogItem<int>> multiItem = List();
  var valuestopopulate = {};

  void populateMultiselect() {
    int count = 1;
    departmentList.forEach((department) {
      valuestopopulate[count] = department["value"];
      count += count;
    });
    for (int v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;
    List<String> selectedJointGroup = jointTeamController.text.split(", ");
    List<int> initialSelectedValue = [];
    // debugPrint("selectedJointGroup --> $selectedJointGroup");
    // debugPrint("valuestopopulate --> $valuestopopulate");
    selectedJointGroup.forEach((element) {
      valuestopopulate.forEach((key, value) {
        if (value == element.trim()) initialSelectedValue.add(key);
      });
    });

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: initialSelectedValue.toSet(),
        );
      },
    );

    debugPrint("selectedValues --> $selectedValues");
    if (selectedValues != null) getvaluefromkey(selectedValues);
  }

  void getvaluefromkey(Set selection) {
    String teamJointText = "";
    if (selection != null) {
      int index = 1;
      for (int x in selection.toList()) {
        if (index == 1)
          teamJointText = valuestopopulate[x];
        else
          teamJointText = teamJointText + ", " + valuestopopulate[x];
        debugPrint("getvaluefromkey --> ${valuestopopulate[x]}");
        index += index;
      }
      if (teamJointText.isEmpty) teamJointText = AppPreferences().deptmentName;
      jointTeamController.text = teamJointText;
    }
    List<String> departmentNames = [];
    List<String> selectedJointGroup = jointTeamController.text.split(",");
    selectedJointGroup.forEach((element) {
      departmentNames.add(element.trim());
    });
    getDepartmentUserList(departmentNames);
  }

  void onSubmitClick(BuildContext context) {
    _validateInputsForNewRequest(context);
  }

  void _validateInputsForNewRequest(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // print("Value of Item ${itemController.text}");
      if (committeeNameController.text.isNotEmpty) {
        //   print("Value of Item ${itemController.text}");
        var connectivityResult = await NetworkCheck().check();
        if (connectivityResult) {
          apiCall(context);
        } else {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: Constants.NO_INTERNET_CONNECTION,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        }
      } else {
        setState(() {
          _autoValidate = true;
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: "Please fill or check the mandatory fields",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP);
        });
      }

      /* setState(() {
        waiting = true;
      }); */
    } else {
      setState(() {
        _autoValidate = true;
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Please fill or check the mandatory fields",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      });
    }
  }

  apiCall(BuildContext context) async {
    CommitteeData committeeData = new CommitteeData();
    if (userList != null) {
      List<Map<String, dynamic>> membersData = new List();
      userList.forEach((element) {
        if (element.checkboxValue) {
          Map<String, dynamic> mapData = new Map();

          mapData["memberDepartment"] = element.departmentName;
          mapData["userName"] = element.username;
          mapData["memberType"] = element.memberType;
          mapData["firstName"] = element.firstName;
          mapData["lastName"] = element.lastName;
          mapData["roleName"] = element.role;

          membersData.add(mapData);
        }
      });

      if (membersData.length == 0) {
        //members not added .Show alert
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Please select committee member",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        return;
      }
    }

    committeeData.committeeName = committeeNameController.text.toString();
    //committeeData.committeeType = committeeTypeController.text.toString();
    if (widget.isUpdate) {
      committeeData.departmentName = widget.committeeDepartmentName;
    } else {
      committeeData.departmentName = AppPreferences().deptmentName;
    }

    if (jointTeamController.text.toString().isNotEmpty) {
      committeeData.groups = jointTeamController.text.toString().split(", ");
    }
    committeeData.active = active;
    committeeData.committeeStrength =
        committeeStrengthController.text.toString();
    committeeData.comments = commentsController.text.toString();
    committeeData.members = userList;
    List<String> committeeMemberTypes = new List();
    committeeMembersList.forEach((element) {
      committeeMemberTypes.add(element.title);
    });
    committeeData.memberTypes = committeeMemberTypes;

    CustomProgressLoader.showLoader(context);
    debugPrint("committeeData.members  ${committeeData.members}");
    debugPrint("committeeData.members count  ${committeeData.members.length}");

    CommitteesBloc _bloc = new CommitteesBloc(context);
    _bloc.createOrUpdateCommittee(committeeData, companyPoliciesFile,
        isUpdate: update);
    _bloc.committeeCreateFetcher.listen((response) async {
      // print("Response Status createOrUpdateCommittee ${response.status}");
      setState(() {
        waiting = true;
      });
      if (response.status == 201) {
        Map<String, dynamic> result1 = {
          'isSuccess': false,
          'onClick': null,
          'error': null,
        }; //    print("Hello Pranay Request submission is successful");

        // Map downloadStatus = {};

        /* final android = AndroidNotificationDetails(
            'channel id', 'channel name', 'channel description',
            priority: Priority.high, importance: Importance.max);
        final iOS = IOSNotificationDetails();
        final platform = NotificationDetails(android: android, iOS: iOS);
        final json = "success";
        result1['isSuccess'] = true;
        result1['onClick'] = "success";

        await flutterLocalNotificationsPlugin.show(
            0, // notification id
            'success',
            'Welcome to Committe',
            platform,
            payload: jsonEncode(result1));*/

        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Committee created successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
        Navigator.pop(context, true);

        //widget.callbackForRefreshCommittee(true);

        // Navigator.pop(context);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
        //     ModalRoute.withName(Routes.committeeListScreen));
        //Navigator.pushReplacementNamed(context, Routes.committeeListScreen);
      } else if (response.status == 200) {
        // localNotification();
        Map<String, dynamic> result1 = {
          'isSuccess': false,
          'onClick': null,
          'error': null,
        }; //    print("Hello Pranay Request submission is successful");

        /*final android = AndroidNotificationDetails(
            'channel id', 'channel name', 'channel description',
            priority: Priority.high, importance: Importance.max);
        final iOS = IOSNotificationDetails();
        final platform = NotificationDetails(android: android, iOS: iOS);
        final json = "success";
        result1['isSuccess'] = true;
        result1['onClick'] = "success";

        await flutterLocalNotificationsPlugin.show(
            0, // notification id
            'Success',
            'Welcome to Committe',
            platform,
            payload: jsonEncode(result1));*/
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "Committee updated successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
        Navigator.pop(context, true);

        //widget.callbackForRefreshCommittee(true);

        // Navigator.pop(context);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
        //     ModalRoute.withName(Routes.committeeListScreen));
        //Navigator.pushReplacementNamed(context, Routes.committeeListScreen);
      } else if (response.status == 400) {
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: response.error,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
        CustomProgressLoader.cancelLoader(context);
      } else {
        CustomProgressLoader.cancelLoader(context);
        // Navigator.pushReplacementNamed(context, Routes.committeeListScreen);
        Fluttertoast.showToast(
            msg: response?.error ?? AppPreferences().getApisErrorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP);
      }
    });
  }

  localNotification() async {
    // var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // final android = AndroidInitializationSettings('ic_launcher');
    // final iOS = IOSInitializationSettings();
    // final initSettings = InitializationSettings(android: android, iOS: iOS);

    // flutterLocalNotificationsPlugin.initialize(initSettings,
    //     onSelectNotification: _onSelectNotification);
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  }

  fn() async {
    try {
      Route route = MaterialPageRoute(
          builder: (context) => SettingsScreen(title: "Testing"));

      Navigator.push(context, route);
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SettingsScreen(title: "Testing"),
      //   ),
      // );
    } catch (e) {
      print("error:");
      print(e.toString());
      print("Dhinakaran");
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResetPassword(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      debugPrint('pagetogo: 1');
      // Navigator.of(context, rootNavigator: true).pop();
      // await Future.delayed(
      //     const Duration(milliseconds: 10),
      //     () => Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => SettingsScreen(title: "Testing"),
      //           ),
      //         ));
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return SettingsScreen(title: "Testing");
      }));
      // MyApp.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => ResetPassword()));
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SettingsScreen(title: "Testing"),
      //   ),
      // );

      print("Test8ibng");
    }
  }

  /// Written by Balvinder on 15 Apr 2021
  void initializeAd() async {
    Admob.initialize();
    var adID = await getAppId();
    print("=============================> Ad Id ====== $adID");
    FirebaseAdMob.instance.initialize(appId: adID);
  }

  Future<String> getAppId() async {
    var adId = await AppPreferences.getAdAppId();
    return adId;
  }

  Future<String> getAdBannerProp() async {
    var bannerData = await AppPreferences.getAdUnitBanner();
    var bannerId = bannerData.toString().split(',')[0];
    print("========================> bannerId $bannerId");
    return bannerId;
  }

  Widget getSivisoftAdWidget() {
    return FutureBuilder(
      future: getAdBannerProp(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data == null) return Container();
        return AdmobBanner(
          adUnitId: snapshot.data,
          adSize: AdmobBannerSize.BANNER,
          listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
        );
      },
    );
  }

  /// End here
}

class SelectedMemberListUser {
  String departmentName;
  String username;
  bool checkboxValue;
  String memberType;
  String firstName;
  String lastName;
  String role;

  SelectedMemberListUser(this.departmentName, this.username, this.checkboxValue,
      this.memberType, this.firstName, this.lastName, this.role);
}

class CommitteeMembers {
  final String title;
  bool selected = true;

  CommitteeMembers(
    this.title,
  );
}

// Multiselect
class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
      waiting = false;
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
    /* if (waiting == false) {
      CustomProgressLoader.showLoader(context);
      
    } else
      CustomProgressLoader.cancelLoader(context);
      if (waiting) Navigator.pop(context); */
    BuildContext dialogContext;

    waiting == false
        ? showDialog(
            context: context,
            // barrierDismissible: true,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 10), () {
                // if (waiting) {
                //   Navigator.of(context).pop(true);
                // }
                Navigator.of(context).pop(true);
              });
              // if(waiting){Navigator.of(context).pop(true);}
              dialogContext = context;
              return Container(
                  height: 50.0,
                  width: 50.0,
                  child: Center(child: CircularProgressIndicator()));
            })
        : Navigator.pop(dialogContext);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Team/Group'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

class DialOuge extends StatefulWidget {
  DialOuge({Key key, bool wating}) : super(key: key);

  @override
  _DialOugeState createState() => _DialOugeState();
}

class _DialOugeState extends State<DialOuge> {
  @override
  Widget build(BuildContext context) {
    return waiting == false
        ? Container(height: 50.0, width: 10, child: CircularProgressIndicator())
        : Opacity(opacity: 1.0);
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
