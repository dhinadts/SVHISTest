import '../../ui/custom_drawer/navigation_home_screen.dart';
import '../../ui/diabetes_risk_score/tabs/diabetes_riskscore_tab.dart';
import '../../utils/routes.dart';
import '../../widgets/people_list_item.dart';

import '../../login/utils/custom_progress_dialog.dart';
import '../../model/people.dart';
import '../../model/user_info.dart';
import '../../repo/auth_repository.dart';
import '../../ui/advertise/adWidget.dart';
import '../../ui/custom_drawer/custom_app_bar.dart';
import '../../ui/diabetes_risk_score/bloc/diabetes_risk_score_bloc.dart';
import '../../ui/diabetes_risk_score/bloc/diabetes_risk_score_event.dart';
import '../../ui/diabetes_risk_score/bloc/diabetes_risk_score_state.dart';
import '../../ui/diabetes_risk_score/diabetes_risk_score_screen.dart';
import '../../ui/diabetes_risk_score/widgets/diabetes_risk_score_list_wiget.dart';
import '../../ui/tabs/app_localizations.dart';
import '../../ui_utils/app_colors.dart';
import '../../ui_utils/ui_dimens.dart';
import '../../ui_utils/widget_styles.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../../widgets/loading_widget.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiabetesRiskScoreListScreen extends StatefulWidget {
  final People people;

  DiabetesRiskScoreListScreen(this.people);

  @override
  _DiabetesRiskScoreListScreenState createState() =>
      new _DiabetesRiskScoreListScreenState();
}

class _DiabetesRiskScoreListScreenState
    extends State<DiabetesRiskScoreListScreen> {
  DiabetesRiskScoreBloc _diabetesRiskScoreBloc;
  TextEditingController nameController = TextEditingController();
  var isDataLoaded = false;

  AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _diabetesRiskScoreBloc = DiabetesRiskScoreBloc();
    _authRepository = new AuthRepository();
    initializeData();
  }

  void initializeData() {
    if (widget.people != null) {
      _diabetesRiskScoreBloc
          .add(GetHealthScoreHistoryList(widget.people.userName));
    } else {
      People people = People();
      people.userName = AppPreferences().username;
      _diabetesRiskScoreBloc.add(GetHealthScoreHistoryList(people.userName));
    }

    /// Initialize Ad
    initializeAd();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // return Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => DiabetesRiskScoreTab(
        //             title: "Diabetes Risk Score",
        //           )),
        // );
        if (widget.people == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationHomeScreen(
                        drawerIndex: Constants.PAGE_ID_HOME,
                      )),
              ModalRoute.withName(Routes.navigatorHomeScreen));
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigationHomeScreen(
                        drawerIndex: Constants.PAGE_ID_DIABETES,
                      )),
              ModalRoute.withName(Routes.navigatorHomeScreen));
        }
      },
      child: BlocProvider(
        create: (context) => DiabetesRiskScoreBloc(),
        child: Scaffold(
          appBar: CustomAppBar(
              title: "Diabetes Risk Score History",
              pageId: Constants.PAGE_ID_DIABETES),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: AppUIDimens.paddingXMedium),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: WidgetStyles.cardBoxShadow),
                            child: Column(
                              children: <Widget>[
                                _userTitleText(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      BlocBuilder<DiabetesRiskScoreBloc,
                              DiabetesRiskScoreState>(
                          bloc: _diabetesRiskScoreBloc,
                          builder: (BuildContext context,
                              DiabetesRiskScoreState state) {
                            if (state.isLoading) {
                              return ListLoading();
                            }
                            if (state.hasError) {
                              return Center(
                                child: Text('Error'),
                              );
                            }
                            if (state.healthScoreList.isNotEmpty) {
                              return DiabetesRiskScoreListWidget(
                                people: widget.people,
                                healthScore: state.healthScoreList,
                              );
                            }
                            return Center(
                              child: Text(AppLocalizations.of(context)
                                  .translate("key_no_data_found")),
                            );
                          }),
                      // getSivisoftAdWidget(),
                    ],
                  ),
                ),
              ),

              /// Show Banner ad
              getSivisoftAdWidget(),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FloatingActionButton.extended(
              label: Text("Take the test here"),
              onPressed: () async {
                CustomProgressLoader.showLoader(context);
                UserInfo userInfo;
                if (AppPreferences().role == Constants.supervisorRole) {
                  userInfo =
                      await _authRepository.getUserInfo(widget.people.userName);
                }
                bool refresh = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiabetesRiskScoreScreen(
                      userInfo: userInfo,
                    ),
                  ),
                );
                if (refresh ?? false) {
                  initializeData();
                }
                CustomProgressLoader.cancelLoader(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _userTitleText() {
    String name = "";

    if (widget.people != null) {
      final String firstName = widget.people?.firstName ?? "";
      final String lastName = widget.people?.lastName ?? "";
      // name = "$lastName, $firstName";
      name = lastName.length > 0 ? "$firstName $lastName" : "$firstName";
      if (name.isEmpty) {
        name = AppPreferences().fullName2.length > 0
            ? AppPreferences().fullName2
            : AppPreferences().username;
      }
    } else {
      name = AppPreferences().fullName2.length > 0
          ? AppPreferences().fullName2
          : AppPreferences().username;
    }

    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: AppColors.arrivedColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            )),
        child: SizedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 7,
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 25),
                    child: Text(
                      AppPreferences().role == Constants.supervisorRole
                          ? AppPreferences().isLanguageTamil()
                              ? AppLocalizations.of(context)
                                  .translate("key_name")
                              : AppLocalizations.of(context)
                                  .translate("key_user_name")
                          : AppPreferences().isLanguageTamil()
                              ? AppLocalizations.of(context)
                                  .translate("key_name")
                              : AppLocalizations.of(context)
                                  .translate("key_name"),
                      style: AppPreferences().isLanguageTamil()
                          ? TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)
                          : TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
            Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15, right: 25),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
            SizedBox(
              height: 7,
            ),
          ],
        )),
      ),
    );
  }
}
