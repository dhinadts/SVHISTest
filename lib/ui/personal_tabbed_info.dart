import '../bloc/user_info_validation_bloc.dart';
import '../ui/custom_drawer/custom_app_bar.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui/tabs/history_tab_screen.dart';
import '../ui/tabs/user_info_tab_inapp_webview.dart';
import '../ui/tabs/user_info_tab_screen.dart';
import '../ui_utils/app_colors.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ui/tabs/history_tab_screen.dart';

class PersonalTabbedInfoScreen extends StatefulWidget {
  UserInfoValidationBloc actionBloc;

  PersonalTabbedInfoScreen({this.actionBloc});

  @override
  PersonalTabbedInfoState createState() => PersonalTabbedInfoState();
}

class PersonalTabbedInfoState extends State<PersonalTabbedInfoScreen> {
  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> symptomsFormKey = GlobalKey<FormState>();
  bool showFab = false;
  final GlobalKey<FormState> ailmentFormKey = GlobalKey<FormState>();
  UserInfoValidationBloc userBloc;
  bool isHistoryTabOpened = false;
  UserInfoValidationBloc ailmentBloc;
  String genderSelected = "";
  List<Tab> tabs = [];
  List<Widget> tabscreens = [];
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    userBloc = UserInfoValidationBloc(context);
//    symptomsBloc = UserInfoValidationBloc(context);
    ailmentBloc = UserInfoValidationBloc(context);
    widget.actionBloc.actionTrigger.listen((value) {
      if (value) {
        updateProfileData();
      }
    });
    // print("$userFormKey $symptomsFormKey  $ailmentFormKey");
    getProfileHistoryInfo();
    super.initState();
  }

  getProfileHistoryInfo() async {
    bool isHistoryEnabled = await AppPreferences.getProfileHistoryEnabled();
    getTabs();
    getTabScreens();
    if (!isHistoryEnabled) {
      setState(() {
        tabs.removeLast();
        tabscreens.removeLast();
      });
    }
  }

  getTabs() {
    setState(() {
      tabs = [
        Tab(
          //icon: Image.asset("assets/images/ic_user_info_tab.png"),
          child: Text(
            AppLocalizations.of(context).translate("key_profile"),
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        /*Tab(
                  icon: Image.asset("assets/images/ic_symptoms_tab.png"),
                  child: Text(
                    AppLocalizations.of(context).translate("key_symptoms"),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  )),*/
        Tab(
            // icon: Image.asset("assets/images/ic_ailments_tab.png"),
            child: Text(
          AppLocalizations.of(context).translate("key_history"),
          style: TextStyle(fontSize: 16, color: Colors.white),
        )),
      ];
    });
  }

  getTabScreens() {
    setState(() {
      tabscreens = [
        //User(),
        UserInformationTabScreen(
          userBloc,
          userFormKey,
          delegate: (newData) => setState(() {
            genderSelected = newData;
          }),
        ),
        // SymptomTabDynamicScreen(
        //   symptomsBloc,
        //   symptomsFormKey,
        // ),
        // AdditionalAilmentTabDynamicScreen(ailmentBloc, ailmentFormKey),
        /*SymptomTabScreen(
              symptomsBloc,
              symptomsFormKey,
            ),*/
        HistoryTabScreen(
          ailmentBloc,
          ailmentFormKey,
          onOpen: (isOpen) {
            //setState(() {
            isHistoryTabOpened = isOpen;
            //});
          },
          gender: genderSelected,
        )
//            AdditionalAilmentTabScreen(ailmentBloc, ailmentFormKey),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setGlobalContext(context);
    return /*DefaultTabController(
      length: 2,
      child: */
        Scaffold(
      // appBar: AppBar(
      // flexibleSpace: SafeArea(
      //   child: TabBar(
      //     tabs: [
      //       Tab(
      //         icon: Image.asset("assets/images/ic_user_info_tab.png"),
      //         child: Text(
      //           AppLocalizations.of(context).translate("key_profile"),
      //           style: TextStyle(
      //             fontSize: 11,
      //           ),
      //         ),
      //       ),
      //       Tab(
      //           icon: Image.asset("assets/images/ic_symptoms_tab.png"),
      //           child: Text(
      //             AppLocalizations.of(context).translate("key_symptoms"),
      //             style: TextStyle(
      //               fontSize: 11,
      //             ),
      //           )),
      //       Tab(
      //           icon: Image.asset("assets/images/ic_ailments_tab.png"),
      //           child: Text(
      //             AppLocalizations.of(context).translate("key_ailments"),
      //             style: TextStyle(
      //               fontSize: 11,
      //             ),
      //           )),

      //     ],
      //   ),
      // ),
      // ),
      appBar: CustomAppBar(
        title:
            AppLocalizations.of(context).translate("key_personalinformation"),
        pageId: Constants.PAGE_PERSONAL_INFORMATION,
        actionBloc: widget.actionBloc,
        // tabBar: TabBar(
        //   indicatorColor: AppColors.tabBarIndicatorColor,
        //   tabs: [
        //     Tab(
        //       //icon: Image.asset("assets/images/ic_user_info_tab.png"),
        //       child: Text(
        //         AppLocalizations.of(context).translate("key_profile"),
        //         style: TextStyle(fontSize: 16),
        //       ),
        //     ),
        //     /*Tab(
        //           icon: Image.asset("assets/images/ic_symptoms_tab.png"),
        //           child: Text(
        //             AppLocalizations.of(context).translate("key_symptoms"),
        //             style: TextStyle(
        //               fontSize: 11,
        //             ),
        //           )),*/
        //     Tab(
        //         // icon: Image.asset("assets/images/ic_ailments_tab.png"),
        //         child: Text(
        //       AppLocalizations.of(context).translate("key_history"),
        //       style: TextStyle(
        //         fontSize: 16,
        //       ),
        //     )),
        //   ],
        // ),
      ),
      body: UserInfoTabInappWebview(
        userName: AppPreferences().username,
        departmentName: AppPreferences().deptmentName,
        clientId: AppPreferences().clientId,
      ),
//         body: /* Stack(
//             children: <Widget>[*/
//             TabBarView(
//           physics: ScrollPhysics(parent: PageScrollPhysics()),
//           children: [
//             //User(),
//             UserInformationTabScreen(
//               userBloc,
//               userFormKey,
//               delegate: (newData) => setState(() {
//                 genderSelected = newData;
//               }),
//             ),
//             // SymptomTabDynamicScreen(
//             //   symptomsBloc,
//             //   symptomsFormKey,
//             // ),
//             // AdditionalAilmentTabDynamicScreen(ailmentBloc, ailmentFormKey),
//             /*SymptomTabScreen(
//               symptomsBloc,
//               symptomsFormKey,
//             ),*/
//             HistoryTabScreen(
//               ailmentBloc,
//               ailmentFormKey,
//               onOpen: (isOpen) {
//                 //setState(() {
//                 isHistoryTabOpened = isOpen;
//                 //});
//               },
//               gender: genderSelected,
//             )
// //            AdditionalAilmentTabScreen(ailmentBloc, ailmentFormKey),
//           ],
//         ),
      /* */
      //),
    );
  }

  updateProfileData() async {
    setState(() {});
    try {
      bool symptomFormResult = symptomsFormKey.currentState != null &&
          symptomsFormKey.currentState.validate();
      bool ailmentFormResult = ailmentFormKey.currentState != null &&
          ailmentFormKey.currentState.validate();

      bool userFormResult = (userFormKey.currentState != null &&
          userFormKey.currentState.validate());

      if (userFormResult && ailmentFormResult) {
        ailmentFormKey.currentState.save();
        userFormKey.currentState.save();
        userBloc.actionCallAPI();
        //symptomsBloc.actionCallAPI();
        ailmentBloc.actionCallAPI();
      } else if (userFormResult && AppPreferences().historySaved) {
        if (!isHistoryTabOpened) {
          userFormKey.currentState.save();
          userBloc.actionCallAPI();
        } else {
          if (ailmentFormResult) {
            ailmentFormKey.currentState.save();
            userFormKey.currentState.save();
            userBloc.actionCallAPI();
            ailmentBloc.actionCallAPI();
          } else {
            StringBuffer output = new StringBuffer(
                AppLocalizations.of(context).translate("key_error_msg_title"));
            output.write(
                "\n - ${AppLocalizations.of(context).translate("key_ailments")}, ");
            String finalMsg = output.toString();
            finalMsg = finalMsg.replaceAll("tabs", "tab");
          }
        }
      } else {
        //Need to show error msg
        int i = 0;
        StringBuffer output = new StringBuffer(
            AppLocalizations.of(context).translate("key_error_msg_title"));
        //Alert Message -  Symptoms, Ailments, Physician tabs before clicking update
        if (!userFormResult) {
          output.write(
              "\n - ${AppLocalizations.of(context).translate("key_profile")}, ");
          i++;
          userBloc.validationStateChange();
        }
        if (!ailmentFormResult) {
          i++;
          output.write(
              "\n - ${AppLocalizations.of(context).translate("key_history")} ");
          ailmentBloc.validationStateChange();
        }
        String outStr = output.toString();
        if (1 == i) {
          outStr = outStr.replaceAll("tabs", "tab");
          outStr = outStr.replaceAll(",", "");
        }
        if (!AppPreferences().historySaved || (!ailmentFormResult)) {
          Fluttertoast.showToast(
              msg: "$outStr",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 5,
              gravity: ToastGravity.TOP);
        }
      }
    } catch (_) {
      // print("sdfsdf $_");
    }
  }
}
