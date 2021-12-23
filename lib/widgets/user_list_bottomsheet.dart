import 'dart:convert';

import 'package:Memberly/repo/auth_repository.dart';

import '../bloc/user_info_validation_bloc.dart';
import '../model/passing_arg.dart';
import '../model/people.dart';
import '../model/user_info.dart';
import '../ui/advertise/adWidget.dart';
import '../ui/membership/membership_inapp_webview_screen.dart';
import '../ui/tabs/user_info_membership_card.dart';
import '../ui/tabs/user_info_tab_inapp_webview.dart';
import '../ui/user_additional_information.dart';
import '../utils/app_preferences.dart';
import '../utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UserListBottomSheet extends StatefulWidget {
  People people;
  UserInfoValidationBloc userInfoValidationBloc;
  void Function(String) successCallback;

  UserListBottomSheet(People _people,
      UserInfoValidationBloc _userInfoValidationBloc, _successCallback) {
    this.people = _people;
    this.userInfoValidationBloc = _userInfoValidationBloc;
    this.successCallback = _successCallback;
  }

  @override
  _UserListBottomSheetState createState() => _UserListBottomSheetState();
}

class _UserListBottomSheetState extends State<UserListBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool setMembership = false;
  String membershipType = "";
  String memberShipEnableMode = "";
  String defaultValueMembershipEnableMode = "NONE";
  @override
  void initState() {
    super.initState();
    getmemebrshipMode();

    initializeAd();
  }

  getmemebrshipMode() async {
    // print(AppPreferences().subdeptSupervisorUsermodAccessEnabled);
    String stringValue = AppPreferences().subdeptSupervisorUsermodAccessEnabled;

    String parentDept =
        AppPreferences().promoDeparmentName; // -- Parent Department Name
    String loggedinUserDepartment =
        AppPreferences().deptmentName; // --- Logged in department
    String role = AppPreferences().role; // --- Logged in department

    if (parentDept.toLowerCase() == loggedinUserDepartment.toLowerCase() &&
        role == Constants.supervisorRole) {
//mode=Edit hardcode this value for above condition
      setMembership = true;
      memberShipEnableMode = "Edit";
    } else if (parentDept.toLowerCase() !=
            loggedinUserDepartment.toLowerCase() &&
        role == Constants.supervisorRole) {
      if (stringValue != null &&
          stringValue.toLowerCase() ==
              defaultValueMembershipEnableMode.toLowerCase()) {
        setState(() {
          setMembership = false;
          memberShipEnableMode = stringValue;
        });
      } else {
        setState(() {
          setMembership = true;
          memberShipEnableMode = stringValue;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.people?.lastName}'.length > 0
                            ? '${widget.people?.firstName} ${widget.people?.lastName}'
                            : '${widget.people?.firstName}',
                        // '${people?.lastName}, ${people?.firstName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.people.emailId),
                      // const SizedBox(height: 4.0,),
                      Text(widget.people.mobileNo.contains("+")
                          ? widget.people.mobileNo
                          : "+" + widget.people.mobileNo),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              Image.asset("assets/images/ic_user_info_tab.png"),
                          title: Text(
                            "Profile",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  UserInfoMemberShipObject obj;
                                  if (widget.people.membershipEntitlements !=
                                      null) {
                                    obj = UserInfoMemberShipObject(
                                        membershipId: widget
                                                .people.membershipEntitlements[
                                            'membershipId'],
                                        membershipStatus: widget
                                                .people.membershipEntitlements[
                                            'membershipStatus'],
                                        approvedDate: widget
                                                .people.membershipEntitlements[
                                            'approvedDate'],
                                        gender: widget.people.gender ?? "",
                                        firstName:
                                            widget.people.firstName ?? "",
                                        lastName: widget.people.lastName ?? "",
                                        expiryDate: widget
                                                .people.membershipEntitlements[
                                            'expiryDate']);
                                  } else {
                                    obj = UserInfoMemberShipObject(
                                        membershipId: "",
                                        membershipStatus: "",
                                        approvedDate: "",
                                        gender: "",
                                        firstName: "",
                                        lastName: "",
                                        expiryDate: "");
                                  }
                                  var response = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              UserInfoTabInappWebview(
                                                userName:
                                                    widget.people.userName,
                                                departmentName: widget
                                                    .people.departmentName,
                                                clientId:
                                                    AppPreferences().clientId,
                                                membershipInfo: obj,
                                              )));

                                  if (response != null && response.isNotEmpty) {
                                    widget.successCallback(response);
                                  }
                                },
                                customBorder: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (AppPreferences().isAdditionalInformationAvl ??
                            false)
                          ListTile(
                            leading: Image.asset(
                                "assets/images/ic_additional_info.png"),
                            title: Text(
                              "Additional Information",
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            UserAdditionalInformationScreen(
                                          widget.userInfoValidationBloc,
                                          formKey,
                                          userName: widget.people.userName,
                                          firstName: widget.people.firstName,
                                          lastName: widget.people.lastName,
                                          deptName:
                                              widget.people.departmentName,
                                          gender:
                                              widget.people.gender ?? "male",
                                        ),
                                      ),
                                    );
                                  },
                                  customBorder: CircleBorder(),
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (AppPreferences().isCheckInAvl ?? false)
                          ListTile(
                            leading:
                                Image.asset("assets/images/ic_check_in.png"),
                            title: Text(
                              "Log Book",
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.checkInHistoryScreen,
                                        arguments: Args(people: widget.people));
                                  },
                                  customBorder: CircleBorder(),
                                  child: Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // if (setMembership &&
                        //     (AppPreferences().isMembershipApplicable ?? false))
                        true
                            ? Container()
                            : ListTile(
                                leading: Image.asset(
                                    "assets/images/membership.png",
                                    height: 35.0,
                                    width: 35.0),
                                title: Text(
                                  "Membership",
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Container(
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        final refresh = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MembershipInappWebviewScreen(
                                              departmentName:
                                                  widget.people.departmentName,
                                              userName: widget.people.userName,
                                              loggedInRole: "supervisor",
                                              membershipId: null,
                                              clientId:
                                                  AppPreferences().clientId,
                                              memberShipEnableMode:
                                                  memberShipEnableMode,
                                              title: "profile",
                                            ),
                                          ),
                                        );
                                        // updateListData(refresh);
                                      },
                                      customBorder: CircleBorder(),
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        // Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 15.0, right: 15.0, top: 10.0),
                        //     child:
                        //         // Text(
                        //         //   "Note :\nTo update the Profile (or) To become a Member, please click on the Edit icon(Pencil icon) next to Profile and choose the Membership plan on the Top and provide the relevant details to proceed further.",
                        //         //   style: TextStyle(fontSize: 10),
                        //         // ),
                        //         RichText(
                        //       text: TextSpan(
                        //         text: 'Note :\n',
                        //         style: DefaultTextStyle.of(context).style,
                        //         children: const <TextSpan>[
                        //           TextSpan(
                        //               text:
                        //                   "To update the Profile (or) To become a Member, please click on the Edit icon(Pencil icon) next to Profile and choose the Membership plan on the Top and provide the relevant details to proceed further.",
                        //               style: TextStyle(fontSize: 10)),
                        //         ],
                        //       ),
                        //     )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Show Banner Ad
          getSivisoftAdWidget(),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class UserProfileBottomSheet extends StatefulWidget {
  UserInfo user;

  UserInfoValidationBloc userInfoValidationBloc;
  bool superProfile;

  UserProfileBottomSheet(UserInfo _user,
      UserInfoValidationBloc _userInfoValidationBloc, bool superProfile) {
    this.user = _user;

    this.userInfoValidationBloc = _userInfoValidationBloc;
    this.superProfile = superProfile;
  }

  @override
  _UserProfileBottomSheetState createState() => _UserProfileBottomSheetState();
}

class _UserProfileBottomSheetState extends State<UserProfileBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool setMembership = false;
  String membershipType = "";
  String memberShipEnableMode = "";
  String defaultValueMembershipEnableMode = "NONE";

  @override
  void initState() {
    super.initState();

    // print("Membership type");
    // print(widget.user.membershipType);
    // print(widget.user.membershipStatus);
    // print(widget.user.hasMembership);
    print("Profile Image");
    print(widget.user.profileImage);
    print(widget.user.membershipEntitlements);
    getmemebrshipMode();
    // initializeAd();
    getuserinfo();
  }

  getuserinfo() async {
    // var membership = http.get(
    //     "https://prod.servicedx.com/admin/departments/Erin/users/TestShreyas1");
    // var a = membership;
    // print("${a["membershipEntitlements"]}");
    final _repository = AuthRepository();
    String username = await AppPreferences.getUsername();
    UserInfo getUserInfo = await _repository.getUserInfo(username);
    print("membershipEntitlements");
    print(getUserInfo.membershipEntitlements.toString());
  }

  getmemebrshipMode() async {
    // print(AppPreferences().subdeptSupervisorUsermodAccessEnabled);
    String stringValue = AppPreferences().subdeptSupervisorUsermodAccessEnabled;

    String parentDept =
        AppPreferences().promoDeparmentName; // -- Parent Department Name
    String loggedinUserDepartment =
        AppPreferences().deptmentName; // --- Logged in department
    String role = AppPreferences().role; // --- Logged in department

    if (parentDept.toLowerCase() == loggedinUserDepartment.toLowerCase() &&
        role == Constants.supervisorRole) {
//mode=Edit hardcode this value for above condition
      setMembership = true;
      memberShipEnableMode = "Edit";
    } else if (parentDept.toLowerCase() !=
            loggedinUserDepartment.toLowerCase() &&
        role == Constants.supervisorRole) {
      if (stringValue != null &&
          stringValue.toLowerCase() ==
              defaultValueMembershipEnableMode.toLowerCase()) {
        setState(() {
          setMembership = false;
          memberShipEnableMode = stringValue;
        });
      } else {
        setState(() {
          setMembership = true;
          memberShipEnableMode = stringValue;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user?.lastName}'.length > 0
                        ? '${widget.user?.firstName} ${widget.user?.lastName}'
                        : '${widget.user?.firstName}',
                    // '${people?.lastName}, ${people?.firstName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.user.emailId),
                  // const SizedBox(height: 4.0,),
                  Text(widget.user.mobileNo.contains("+")
                      ? widget.user.mobileNo
                      : "+" + widget.user.mobileNo),
                ],
              ),
            ),
            Divider(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading:
                        /* widget.user.profileImage == null ||
                            widget.user.profileImage.isEmpty */
                        /* ? */ Image.asset(
                            "assets/images/ic_user_info_tab.png")
                    /* : CircleAvatar(
                            radius: 15.0,
                            backgroundImage: MemoryImage(
                                base64Decode(widget.user.profileImage)), */
                    ,
                    title: Text(
                      "Profile",
                      // widget.user.membershipEntitlements == null ||
                      //         widget.user.membershipEntitlements.isEmpty ||
                      //         widget.user.membershipEntitlements == {}
                      //     ? "To Become Member"
                      //     : widget.user.membershipEntitlements[
                      //                 "membershipStatus"] ==
                      //             "Approved"
                      //         ? "Profile"
                      //         : "To Become Member",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          customBorder: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () {
                                // print("dddddd");
                                // print(widget.user.membershipStatus);
                                UserInfoMemberShipObject obj =
                                    UserInfoMemberShipObject(
                                        membershipId:
                                            widget.user
                                                    .membershipEntitlements[
                                                "membershipId"],
                                        membershipStatus:
                                            widget.user
                                                    .membershipEntitlements[
                                                "membershipStatus"],
                                        approvedDate:
                                            widget.user.membershipEntitlements[
                                                "approvedDate"],
                                        gender: widget.user.gender,
                                        firstName: widget.user.firstName,
                                        lastName: widget.user.lastName,
                                        expiryDate:
                                            widget.user.membershipEntitlements[
                                                "expiryDate"]);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserInfoTabInappWebview(
                                        superProfile: widget.superProfile,
                                        userName: widget.user.userName,
                                        departmentName:
                                            widget.user.departmentName,
                                        clientId: AppPreferences().clientId,
                                        title: "Profile",
                                        membershipInfo: obj,
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (AppPreferences().isAdditionalInformationAvl ?? false)
                    ListTile(
                      onTap: () {},
                      leading:
                          Image.asset("assets/images/ic_additional_info.png"),
                      title: Text(
                        "Additional Information",
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            customBorder: CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UserAdditionalInformationScreen(
                                        widget.userInfoValidationBloc,
                                        formKey,
                                        userName: widget.user.userName,
                                        firstName: widget.user.firstName,
                                        lastName: widget.user.lastName,
                                        deptName: widget.user.departmentName,
                                        gender: widget.user.gender ?? "male",
                                      ),
                                    ),
                                  );
                                  /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              UserAdditionalInformationScreen(
                                                userInfoValidationBloc,
                                                formKey,
                                                userName: user.userName,
                                                deptName:
                                                    AppPreferences().deptmentName,
                                                gender: user.gender ?? "male",
                                              ))); */
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (AppPreferences().isCheckInAvl ?? false)
                    ListTile(
                      onTap: () {
                        /* Navigator.pushNamed(context, Routes.checkInHistoryScreen,
                            arguments: Args(user: user)); */
                      },
                      // onTap: () {},
                      leading: Image.asset("assets/images/ic_check_in.png"),
                      title: Text(
                        "Log Book",
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            customBorder: CircleBorder(),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.checkInHistoryScreen,
                                      arguments: Args(
                                          userFullName:
                                              widget.user.userFullName.length ==
                                                      0
                                                  ? widget.user.userName
                                                  : widget.user.userFullName));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // widget.user.membershipEntitlements == null ||
                  //         widget.user.membershipEntitlements.isEmpty ||
                  //         widget.user.membershipEntitlements == {}
                  // ?
                  Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      child:
                          // Text(
                          //   "Note :\nTo update the Profile (or) To become a Member, please click on the Edit icon(Pencil icon) next to Profile and choose the Membership plan on the Top and provide the relevant details to proceed further.",
                          //   style: TextStyle(fontSize: 10),
                          // ),
                          RichText(
                        text: TextSpan(
                          text: 'Note :\n',
                          style: DefaultTextStyle.of(context).style,
                          children: const <TextSpan>[
                            TextSpan(
                                text:
                                    "To update the Profile (or) To become a Member, please click on the Edit icon(Pencil icon) next to Profile and choose the Membership plan on the Top and provide the relevant details to proceed further.",
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      )),
                  // : SizedBox.shrink(),

                  /*     ListTile(
                    leading: Image.asset("assets/images/membership.png",
                        height: 35.0, width: 35.0),
                    title: Text(
                      "Membership",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          customBorder: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: IconButton(
                              onPressed: () async {
                                final refresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MembershipInappWebviewScreen(
                                      departmentName: widget.user.departmentName,
                                      userName: widget.user.userName,
                                      loggedInRole: "user",
                                      membershipId: null,
                                      clientId: AppPreferences().clientId,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
               */
                ],
              ),
            )),
          ]),
        ),

        /// Show Banner Ad
        getSivisoftAdWidget(),
      ],
    ));
  }
}
