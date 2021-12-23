import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Memberly/qrModule/qrScanner.dart';
import 'package:Memberly/ui/tabs/user_info_membership_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/gui_settings.dart';

import '../../globals.dart';
import '../../model/notice_board_response.dart';
import '../../model/user_info.dart';
import '../../repo/auth_repository.dart';
// import '../../ui/EventListsHtml.dart';
// import '../../ui/administration/userRequest.dart';
import '../assessment/assessmentInappWebview.dart';
import '../../ui/attendance/attendance_screen.dart';
import '../assessment/assessment_history.dart';
import '../../ui/avatar_bottom_sheet.dart';
import '../../ui/b2c/homeCareNursingPage.dart';
import '../../ui/booking_appointment/appointment_confirmation_list_screen.dart';
import '../../ui/booking_appointment/appointment_history_screen.dart';
import '../../ui/booking_appointment/book_Appointment_Home_Screen.dart';
import '../../ui/booking_appointment/patient_users_list.dart';
import '../../ui/booking_appointment/select_physician_screen.dart';
import '../../ui/campaign/campaign_list_screen.dart';
import '../../ui/check_in_history_screen.dart';
import '../../ui/custom_drawer/newsfeed_inapp_webview_screen.dart';
import '../../ui/custom_drawer/remainders_list_data.dart';
import '../../ui/custom_drawer/remainders_list_view.dart';
import '../../ui/doctor list/doctor_list_screen.dart';
import '../../ui/doctor_schdule_screen.dart';
import '../../ui/donation/donation_list_screen.dart';
import '../../ui/electionpoll_inappwebview.dart';
// import '../../ui/eventTask.dart';
import '../../ui/homeNewsFeed.dart';
import '../../ui/internal_webpage/internal_inapp_webview_screen.dart';
import '../../ui/internal_webpage/internal_inapp_webview_screen_alternate.dart';
import '../../ui/membership/membership_inapp_webview_screen.dart';
import '../../ui/membership/membership_screen.dart';
import '../../ui/newsfeed_screen.dart';
import '../../ui/send_message/send_message_screen.dart';
import '../../ui_utils/app_colors.dart';
import '../../utils/validation_utils.dart';
import '../../widgets/user_list_bottomsheet.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/menu_items_bloc.dart';
import '../../bloc/user_info_validation_bloc.dart';
import '../../login/stateLessWidget/upper_logo_widget.dart';
import '../../model/advertisement.dart';
import '../../model/menu_item.dart';
import '../../repo/common_repository.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_preferences.dart';
import '../../utils/constants.dart';
import '../administration/administration_screen.dart';
import '../advertise/advertise_widget.dart';
import '../advertise/interstitial_ad_widget.dart';
import '../callus.dart';
import '../committees/commitees_list_screen.dart';
import '../diabetes_risk_score/diabetes_risk_score_list_screen.dart';
import '../diabetes_risk_score/tabs/diabetes_riskscore_tab.dart';
import '../events/event_details.dart';
import '../events/event_list.dart';
import '../faq/faq_screen.dart';
import '../hierarchical/ui/hierarchical_membership_widget.dart';
import '../membership/membership_list_screen.dart';
import '../payment/ui/transaction_history_screen.dart';
import '../people_list_page.dart';
import '../prevention/prevention_list_widget.dart';
import '../recent_activity_list_screen.dart';
import '../reset_password_screen.dart';
import '../settings_screen.dart';
import '../smart_note/smart_note_file_list_screen.dart';
import '../subscription/subscription_list_screen.dart';
import '../support_screen.dart';
import '../tabs/app_localizations.dart';
import '../tabs/user_info_tab_inapp_webview.dart';
import '../user_info_inapp_webview_screen.dart';
import 'drawer_theme.dart';
import 'drawer_user_controller.dart';
import '../../ui/custom_drawer/flash_cards_inapp_webview_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  int drawerIndex = Constants.PAGE_ID_HOME;

  final bool fetchMenuFromServer;

  NavigationHomeScreen(
      {this.drawerIndex = Constants.PAGE_ID_HOME,
      this.fetchMenuFromServer: true});

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
  // changeIndex1(int a) => createState().changeIndex(a);
}

// GlobalKey<_NavigationHomeScreenState> _myKey = GlobalKey();

class _NavigationHomeScreenState extends State<NavigationHomeScreen>
    with TickerProviderStateMixin {
  InAppWebViewController webView;

  //int drawerIndex;

  int menu_grid_launcher_icon_id = 0;
  GuiSettings guiSettings;

  UserInfoValidationBloc actionBloc, actionPeopleBloc;

  List<DrawerList> drawerList = [];
  List<DrawerList> gridList = [];
  List<Advertisement> allAdvertisements = [];
  bool isInternalInAppWebViewLoaded = false;
  bool isCheckedAppVersion = false;
  AdmobBannerSize bannerSize;
  InterstitialAd admobInterstitialAd;
  BannerAd bannerAd;
  bool isWebLoading = true;

  // bool isLoading = true;
  bool isNewsFeedExpanded = true;

  // bool isLoading1 = true;
  var wishList = new List();
  int count = 9;
  AnimationController animationController;
  bool isInternalInappWebViewLoaded = false;
  String selectedLabel;
  Widget screenView;
  dynamic setLegacy; // Constants.LEGACY_HOMEPAGE;
  dynamic setNewsFeed;
  dynamic setRemainders;
  bool expanded = false;
  int _current = 0;
  bool seeAll = false;

  static Random random = new Random();

  var showFlashView = false;

  @override
  void initState() {
    print("------>>>>>>>>>>. ${AppPreferences().username}");
    print("------>>>>>>>>>>. ${AppPreferences().role}");
    setGUISettings();
    // widget.drawerIndex = widget.drawerIndex == null || widget.drawerIndex == 100
    //     ? Constants.PAGE_ID_HOME
    //     : widget.drawerIndex;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    actionBloc = UserInfoValidationBloc(context);
    actionPeopleBloc = UserInfoValidationBloc(context);
    // debugPrint(
    //     "AppPreferences().clientId !!!--------------${AppPreferences().clientId}");
    populateDefaultData();
    //ColorUtils.applyTheme();
    // AppPreferences.getEnvProps().then(
    //     (envProps) => AppColors.primaryColor = HexColor(envProps.colorScheme));
    setAppColor();
    if (widget.fetchMenuFromServer) {
      MenuItemsBloc menuItemsBloc = MenuItemsBloc(context);
      menuItemsBloc.getMenuItems();
      menuItemsBloc.menuItemsFetcher.listen((value) async {
        // debugPrint(
        //     "Menu Items fetched !!!--------------${value?.toJson().toString()}");
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;

        double versionDouble = removeDotFromString(version);
        double appMinVersionDouble = removeDotFromString(value.appMinVersion);
        double appMaxVersionDouble = removeDotFromString(value.appMaxVersion);

        if (versionDouble <= appMaxVersionDouble &&
            versionDouble >= appMinVersionDouble) {
          drawerList.clear();
          // debugPrint("inside ...... $value");
          populateDataFromJson(value);
        }
      });
    }
    // getAllAdvertisements();
    super.initState();
    getLegacyHome();
    getNewsFeedAndRemainders();
    // newsFeedUrl();
    // wishes();
    initializeAd();

    showAdmobInterstitialAds();
    setInterstitalAdShowCount();

    checkMembershipAvailability();
  }

  setGUISettings() {
    String settings = json.decode(AppPreferences().guiSettings);
    guiSettings = GuiSettings.fromJson(
        jsonDecode(settings)["sdx.mobile.app.gui.settings"]);
    setState(() {
      menu_grid_launcher_icon_id = guiSettings.menuGridLauncherIconId;
      //AppColors.primaryColor =  Colors.red;
    });
  }

  checkMembershipAvailability() async {
    Map<String, String> header = {};
    header.putIfAbsent('tenant', () => WebserviceConstants.tenant);
    header.putIfAbsent(WebserviceConstants.contentType,
        () => WebserviceConstants.applicationJson);
    header.putIfAbsent(
        WebserviceConstants.username, () => AppPreferences().username);

    String url =
        '${WebserviceConstants.baseAdminURL}/departments/${AppPreferences().promoDeparmentName}?membership=false';

    final response = await http.get(url, headers: header);
    // print("Membership API URL : $url");
    // print("Membership API Body : ${response.body}");
    if (ValidationUtils.isSuccessResponse(response.statusCode)) {
      bool res = json.decode(response.body)['isMembershipApplicable'] ?? false;
      await AppPreferences.setIsMembershipApplicable(res);
      // print(
      // "setted key : " + AppPreferences().isMembershipApplicable.toString());
    }
  }

  setAppColor() async {
    AppColors.primaryColor = HexColor(await AppPreferences.getAppColor());
  }

  wishes() async {
    // debugPrint("WebserviceConstants.baseURL inside wishes");
    // debugPrint(WebserviceConstants.baseURL);
    if (WebserviceConstants.baseURL != null) {
      remaindersListData = await CommonRepository().getWishesList();
      setState(() {});
    }
  }

//********ADMOB******//////

  Future<void> showAdmobInterstitialAds() async {
    //SHow InterStitial Ad in every 5th time user come to the screen
    var prefs = await SharedPreferences.getInstance();
    int count = prefs.containsKey("interStitialAdCountKey")
        ? prefs.getInt("interStitialAdCountKey")
        : 0;
    if (count > 0 && count % 5 == 0) {
      Future.delayed(Duration(milliseconds: 500), () async {
        admobInterstitialAd = (await createInterstitialAd())
          ..load()
          ..show(
            anchorType: AnchorType.bottom,
            anchorOffset: 130.0,
            horizontalCenterOffset: 120.0,
          );
      });
    }
  }

  void initializeAd() async {
    bannerSize = AdmobBannerSize.BANNER;
    var adID = await getAppId();
    Admob.initialize();
    //print("=============================>HOME Ad Id ====== $adID");
    FirebaseAdMob.instance.initialize(appId: adID);
  }

  Future<InterstitialAd> createInterstitialAd() async {
    //final adUnitId = (await AppPreferences.getEnvProps()).interstitialAdUnitId;
    final adUnitData = (await AppPreferences.getAdunit());
    // print("===========================> Ad unit data   $adUnitData");
    // final adUnitId = json.decode(adUnitData)['adunits'][0];
    // print("=============================> Ad Unit Id ====== $adUnitId");
    return InterstitialAd(
      adUnitId: adUnitData,
      listener: (MobileAdEvent event) {
        // print("InterstitialAd event $event");
      },
    );
  }

  Future<String> getAppId() async {
    var adId = await AppPreferences.getAdAppId();
    return adId;
  }

  String getInterstialAdUnitId() {
    return /*AppPreferences().clientId == Constants.GNAT_KEY
        ? "ca-app-pub-6897851980656595~3640643796"
        :*/
        "ca-app-pub-6897851980656595/9163840313";
  }

  // String getInterstialAdUnitId() {
  //   if (Platform.isIOS) {
  //     return 'ca-app-pub-6897851980656595/5125293464'; //ios
  //   } else if (Platform.isAndroid) {
  //     return 'ca-app-pub-6897851980656595/6570059468'; //android
  //   }
  //   return null;
  // }
  //
  // String getAalaquisBannerAdUnitId() {
  //   if (Platform.isIOS) {
  //     return 'ca-app-pub-6897851980656595/8613768871'; //iOS
  //   } else if (Platform.isAndroid) {
  //     return 'ca-app-pub-6897851980656595/9419761696'; //android
  //   }
  //   return null;
  // }
  //
  // String getTatilBannerAdUnitId() {
  //   if (Platform.isIOS) {
  //     return 'ca-app-pub-6897851980656595/7351823948'; //iOS
  //   } else if (Platform.isAndroid) {
  //     return 'ca-app-pub-6897851980656595/1553536504'; //android
  //   }
  //   return null;
  // }
  //
  // String getBlueWaterBannerAdUnitId() {
  //   if (Platform.isIOS) {
  //     return 'ca-app-pub-6897851980656595/8664905611'; //ios
  //   } else if (Platform.isAndroid) {
  //     return 'ca-app-pub-6897851980656595/3604150620'; //android
  //   }
  //   return null;
  // }
  //
  // Widget getBlueWattersAdWidget() {
  //   return AdmobBanner(
  //     adUnitId: getBlueWaterBannerAdUnitId(),
  //     adSize: bannerSize,
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
  //   );
  // }
  //
  // Widget getAalaquisAdWidget() {
  //   return AdmobBanner(
  //     adUnitId: getAalaquisBannerAdUnitId(),
  //     adSize: bannerSize,
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
  //   );
  // }
  //
  // Widget getTatilAdWidget() {
  //   return AdmobBanner(
  //     adUnitId: getTatilBannerAdUnitId(),
  //     adSize: bannerSize,
  //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
  //   );
  // }

  Future<String> getAdBannerProp() async {
    var bannerData = await AppPreferences.getAdUnitBanner();
    var bannerId = bannerData.toString().split(',')[0];
    // print("========================> bannerId $bannerId");
    return bannerId;
  }

  Widget getSivisoftAdWidget() {
    return FutureBuilder(
      future: getAdBannerProp(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data == null) return Container();
        return AdmobBanner(
          adUnitId: snapshot.data,
          adSize: bannerSize,
          listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
        );
      },
    );
  }

  Widget getAdWidgetForScreenIndex() {
    if (
        // widget.drawerIndex == Constants.PAGE_ID_ADD_A_PERSON ||
        // widget.drawerIndex == Constants.PAGE_ID_ADD_FAMILY ||
        //  widget.drawerIndex == Constants.PAGE_ID_PEOPLE_LIST ||
        widget.drawerIndex == Constants.PAGE_ID_SUBSCRIPTION_LIST ||
            widget.drawerIndex == Constants.PAGE_ID_RESERVED_USERS ||
            // widget.drawerIndex == Constants.PAGE_ID_ADD_USER_FAMILY ||
            widget.drawerIndex == Constants.PAGE_ID_MEMBERSHIP ||
            widget.drawerIndex == Constants.PAGE_ID_DIABETES ||
            widget.drawerIndex == Constants.PAGE_ID_SUPPORT ||
            // widget.drawerIndex == Constants.PAGE_PERSONAL_INFORMATION ||
            widget.drawerIndex == Constants.PAGE_ID_COMMITTEES ||
            widget.drawerIndex == Constants.PAGE_ID_DIAGNOSIS ||
            widget.drawerIndex == Constants.PAGE_ID_EVENTS_LIST ||
            widget.drawerIndex == Constants.PAGE_ID_PORT_MONITORING ||
            widget.drawerIndex == Constants.PAGE_ID_SETTINGS ||
            widget.drawerIndex == Constants.PAGE_ID_SMART_NOTE ||
            widget.drawerIndex == Constants.PAGE_ID_COPING ||
            widget.drawerIndex == Constants.PAGE_ID_SEARCH_PEOPLE ||
            widget.drawerIndex == Constants.PAGE_ID_RECENT_ACTIVITY ||
            widget.drawerIndex == Constants.PAGE_ID_FAQ ||
            widget.drawerIndex == Constants.PAGE_ID_TRANSACTION_HISTORY ||
            widget.drawerIndex == Constants.PAGE_ID_PREVENTION ||
            //  widget.drawerIndex == Constants.PAGE_ID_INAPP_WEBVIEW ||
            widget.drawerIndex == Constants.PAGE_ID_SEND_MESSAGE ||
            widget.drawerIndex == Constants.PAGE_ID_Administration ||
            widget.drawerIndex == Constants.PAGE_ID_BOOK_APPOINTMENT ||
            // widget.drawerIndex == Constants.PAGE_ID_Book_Appointments ||
            // widget.drawerIndex == Constants.PAGE_ID_Doctor_Schedule ||
            widget.drawerIndex == Constants.PAGE_ID_Appointment_History ||
            widget.drawerIndex == Constants.PAGE_ID_CAMPAIGN_LIST ||
            // widget.drawerIndex == Constants.PAGE_ID_Doctor_List ||
            widget.drawerIndex == Constants.PAGE_ID_Appointment_Confirmation) {
      return getSivisoftAdWidget();
    }
    return Container();
  }

  Future<List<Advertisement>> getAllAdvertisements() async {
    String url = "${WebserviceConstants.baseURL}/filing/advertisement/all";
    // print("Ad url is --> $url");
    http.Response response = await http.get(url);

    if (response.statusCode == 201 || response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        Map<String, dynamic> jsonMapData = new Map();
        List<dynamic> jsonData;
        try {
          jsonData = jsonDecode(response.body);
          // print("Ad response  --> $url");
          jsonMapData.putIfAbsent("advertiseDataList", () => jsonData);
          // debugPrint("advertiseDataList - ${jsonData.toString()}");
        } catch (_) {
          // debugPrint("" + _);
        }
        allAdvertisements = List()
          ..addAll((jsonMapData["advertiseDataList"] as List ?? [])
              .map((o) => Advertisement.fromJson(o)));
        //check if ad type is home
        if (allAdvertisements.length > 0) {
          showInterstitialAd();
        }
        // print("advertisement is --> $allAdvertisements");
        return allAdvertisements;
      } else {
        // debugPrint("advertisement Response is empty");
      }
    }
    return allAdvertisements;
  }

  Future<void> showInterstitialAd() async {
    //SHow InterStitial Ad in every 5th time user come to the screen
    var prefs = await SharedPreferences.getInstance();
    int count = prefs.containsKey("interStitialAdCountKey")
        ? prefs.getInt("interStitialAdCountKey")
        : 0;
    if (count == 1 || count == 0 || count % 5 == 0) {
      var advertisementObj = getAdForScreen(Constants.PAGE_ID_HOME.toString());

      if (advertisementObj.advertiseType ==
          InterStitialAd.AD_TYPE_INTERSTITIAL) {
        InterStitialAd.showInterstitialDialog(context, advertisementObj);
      }
    }
  }

  Future<void> setInterstitalAdShowCount() async {
    var prefs = await SharedPreferences.getInstance();
    int count = prefs.containsKey("interStitialAdCountKey")
        ? prefs.getInt("interStitialAdCountKey")
        : 0;
    count = count + 1;
    prefs.setInt("interStitialAdCountKey", count);
  }

  Advertisement getAdForScreen(String pageID) {
    List<Advertisement> homeAds = [];
    allAdvertisements.forEach((element) {
      if (element.advDisplayPage == pageID) {
        homeAds.add(element);
      }
    });
    return homeAds.length > 0 ? homeAds.first : null;
  }

  _launchExternalURL(String url) async {
    print("147852369   " + url);
    // print(await canLaunch(url));
    // await canLaunch(url);
    try {
      await launch(url);
    } catch (e) {
      print(e.toString());
    }
    // final a = print("what is a - $a");
    // if (await canLaunch(url)) {
    //   debugPrint(url);
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

// Check from the App Preference

  getLegacyHome() async {
    // AppPreferences.getLegacyFromEnvProps().then((value) => print(value));
    setLegacy = await AppPreferences.getLegacyFromEnvProps();
    // print("setlegacy -- > $setLegacy");
    setNewsFeed = await AppPreferences.getNewsFeedFromEnvProps() ?? false;
    setRemainders = await AppPreferences.getRemaindersFromEnvProps() ?? false;
    // new Random().nextInt(MAX)

    setState(() {
      setLegacy = !setLegacy;
      setNewsFeed = setNewsFeed;
      setRemainders = setRemainders;
    });
    setState(() {});
    // print("setRemainders  " +
    //     setLegacy.toString() +
    //     " " +
    //     setNewsFeed.toString() +
    //     " " +
    //     setRemainders.toString());
  }

  getNewsFeedAndRemainders() async {
    setNewsFeed = await AppPreferences.getNewFeedEnabled();
    setRemainders = await AppPreferences.getRemindersEnabled();
    // print("the follow");
    // print(setNewsFeed);
    // print(setRemainders);
    setState(() {
      setNewsFeed = setNewsFeed;
      setRemainders = !setRemainders;
    });
  }

  //bool showGridMenu = false;

  Scaffold buildHomePageGridView(List<DrawerList> gridList) {
    return Scaffold(
        // appBar: CustomAppBar(
        //     title: AppLocalizations.of(context).translate("key_home"),
        //     pageId: Constants.PAGE_ID_HOME),
        floatingActionButton: setLegacy != null && setLegacy
            ? SizedBox.shrink()
            : FloatingActionButton(
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                elevation: 0.0,
                highlightElevation: 0.0,
                backgroundColor: Colors.transparent,
                child: setLegacy != null && !setLegacy
                    ? Image.asset(
                        "assets/images/menu-button-md.png",
                        fit: BoxFit.cover,
                        // height: 24, width: 24
                      )
                    : SizedBox.shrink(),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    showMenuGridScreen = !showMenuGridScreen;
                    screenView = buildHomePageGridView(gridList);
                    //debugPrint("showMenuGridScreen --> $showMenuGridScreen");
                  });
                },
              ),
        body: SafeArea(
          child: Stack(
            children: [
              // Positioned(
              //     left: 10,
              //     top: 10,
              //     child: IconButton(
              //         icon: Icon(
              //           Icons.menu,
              //           color: Colors.black,
              //         ),
              //         onPressed: null)),
              SingleChildScrollView(
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              GestureDetector(
                                onDoubleTap: () {
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) => UserRequest()));
                                },
                                child: Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: UpperLogoWidget(
                                      home: true,
                                      showPoweredBy: true,
                                      showTitle: AppPreferences().clientId ==
                                          Constants.GNAT_KEY,
                                      showVersion: false,
                                    )),
                              ),
                              SizedBox(height: 10.0),
                              !showMenuGridScreen
                                  ? Container(
                                      child: ListView(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            setRemainders == null ||
                                                    !setRemainders
                                                ? SizedBox.shrink()
                                                : Container(
                                                    height: 200,
                                                    child:
                                                        ShowFlashCardInAppWebViewScreen(
                                                      webViewHeight: 200,
                                                    ),
                                                  ),
                                            // SampleInAppWebView()),
                                            SizedBox(height: 10.0),
                                            // setNewsFeed == null ||
                                            //         !setNewsFeed
                                            //     ? SizedBox.shrink()
                                            //     : Container(
                                            //         child: Column(children: [
                                            //           ConstrainedBox(
                                            //             constraints:
                                            //                 BoxConstraints(
                                            //               maxHeight: MediaQuery.of(
                                            //                           context)
                                            //                       .size
                                            //                       .height *
                                            //                   0.5,
                                            //             ),
                                            //             child:
                                            //                 ShowNewsFeedInAppWebViewScreen(
                                            //               webViewHeight:
                                            //                   MediaQuery.of(
                                            //                               context)
                                            //                           .size
                                            //                           .height *
                                            //                       0.5,
                                            //             ),
                                            //           ),
                                            //           Padding(
                                            //             padding:
                                            //                 const EdgeInsets
                                            //                         .only(
                                            //                     left: 8.0,
                                            //                     right: 8.0,
                                            //                     bottom: 8.0),
                                            //             child: Row(
                                            //               mainAxisAlignment:
                                            //                   MainAxisAlignment
                                            //                       .spaceBetween,
                                            //               children: [
                                            //                 SizedBox(
                                            //                     width: 10.0,
                                            //                     height: 8.0),
                                            //                 InkWell(
                                            //                   onTap: () {
                                            //                     Navigator.push(
                                            //                         context,
                                            //                         MaterialPageRoute(
                                            //                             builder: (context) =>
                                            //                                 NewsFeedScreen()));
                                            //                   },
                                            //                   child: Row(
                                            //                     children: [
                                            //                       Text(
                                            //                           "View More",
                                            //                           style: TextStyle(
                                            //                               fontWeight:
                                            //                                   FontWeight.bold,
                                            //                               color: Colors.blue,
                                            //                               fontSize: 13)),
                                            //                       Icon(
                                            //                           Icons
                                            //                               .arrow_forward_ios,
                                            //                           color: Colors
                                            //                               .blue,
                                            //                           size:
                                            //                               16),
                                            //                     ],
                                            //                   ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           )
                                            //         ]),
                                            //       ),
                                            // ShowNewsFeedCard(
                                            //   setNewsFeed: setNewsFeed,
                                            // ),
                                            // setLegacy ? SizedBox.shrink() : SizedBox(height: 25.0),
                                            // (setRemainders != null && setRemainders) &&
                                            //         (setNewsFeed == null || !setNewsFeed)
                                            //     ? SizedBox(
                                            //         height: 15,
                                            //       )
                                            //     : SizedBox(height: 15.0),

                                            // setRemainders == true && setNewsFeed == false
                                            //     ? SizedBox(height: 15.0)
                                            //     : Container(),
                                            // const SizedBox(
                                            //   height: 8,
                                            // ),
                                            setLegacy != null && setLegacy
                                                ? Container(
                                                    color: Colors.white,
                                                    child: menuGridBuilder())
                                                : Container(),
                                          ]),
                                    )
                                  : Container(),
                              showMenuGridScreen
                                  ? Container(
                                      color: Colors.white,
                                      child: menuGridBuilder())
                                  : SizedBox.shrink(),
                              SizedBox(height: 20)
                            ],
                          ),
                        ),
                      ),

                      /// Show Banner Ad
                      //   getSivisoftAdWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget menuGridBuilder() {
    print(menu_grid_launcher_icon_id);
    switch (menu_grid_launcher_icon_id) {
      case 0:
        return menuBuilderType1();
      case 1:
        return menuBuilderType2();
      case 2:
        return menuBuilderType3();
      case 3:
        return menuBuilderType4();
      case 4:
        return menuBuilderType5();
      default:
        return menuBuilderType1();
    }
  }

  Widget menuBuilderType1() {
    return gridList.length == 1
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    elevation: 5.0,
                    // shadowColor: Colors.grey[800],

                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.width * 0.20,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.white.withOpacity(0.2),
                          //     spreadRadius: 15,
                          //     blurRadius: 10,
                          //     offset: Offset(3, 3),
                          //   ),
                          // ],
                          // border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        // borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          // Navigator.pop(context);
                          // debugPrint(
                          //     'Grid List label name: ${gridList[index].labelName}');
                          // print(gridList[index].externalUrl);
                          selectedLabel = gridList[0].labelName;
                          // print(e.labelName);
                          // print(e.imageName);
                          if (gridList[0].externalUrl == null ||
                              gridList[0].externalUrl == "")
                            changeIndex(gridList[0].index);
                          else
                            await _launchExternalURL(gridList[0].externalUrl);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const SizedBox(
                              height: 15,
                            ),
                            if (gridList[0].imageName != null)
                              getBuilderImage(gridList[0].imageName),
                            Expanded(
                              child: Container(
                                // color: Colors.red,
                                child: Center(
                                  child: Text(gridList[0].labelName,
                                      maxLines: 2,
                                      style: AppPreferences().isLanguageTamil()
                                          ? TextStyle(
                                              fontSize: 12,
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold)
                                          : /* TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Vernada",
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold), */
                                          GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : Center(
            child: Wrap(
                children: gridList.map((e) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 5.0,
                  // shadowColor: Colors.grey[800],

                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.14,
                    width: MediaQuery.of(context).size.width * 0.20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.white.withOpacity(0.2),
                        //     spreadRadius: 15,
                        //     blurRadius: 10,
                        //     offset: Offset(3, 3),
                        //   ),
                        // ],
                        // border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      // borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        // Navigator.pop(context);
                        // debugPrint(
                        //     'Grid List label name: ${gridList[index].labelName}');
                        // print(gridList[index].externalUrl);
                        selectedLabel = e.labelName;
                        // print(e.labelName);
                        // print(e.imageName);
                        if (e.externalUrl == null || e.externalUrl == "")
                          changeIndex(e.index);
                        else
                          await _launchExternalURL(e.externalUrl);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          if (e.imageName != null) getBuilderImage(e.imageName),
                          Expanded(
                            child: Container(
                              // color: Colors.red,
                              child: Center(
                                child: Text(e.labelName,
                                    maxLines: 2,
                                    style: AppPreferences().isLanguageTamil()
                                        ? TextStyle(
                                            fontSize: 12,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold)
                                        : /* TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Vernada",
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold), */
                                        GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold),
                                          ),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList()),
          );
  }

  Widget menuBuilderType2() {
    List<Widget> items = [];
    items.addAll(gridList.map((e) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.14,
        width: MediaQuery.of(context).size.width / 3.8,
        decoration: BoxDecoration(
            color: Colors.white,
            /*boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 15,
                    blurRadius: 10,
                    offset: Offset(3, 3),
                  ),
                ],*/
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(10)),
        child: Material(
          elevation: 0.0,
          // shadowColor: Colors.grey[800],

          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () async {
              // Navigator.pop(context);
              // debugPrint(
              //     'Grid List label name: ${gridList[index].labelName}');
              // print(gridList[index].externalUrl);
              selectedLabel = e.labelName;
              // print(e.labelName);
              // print(e.imageName);
              if (e.externalUrl == null || e.externalUrl == "")
                changeIndex(e.index);
              else
                await _launchExternalURL(e.externalUrl);
            },
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                if (e.imageName != null)
                  getBuilderImage(e.imageName, height: 30.0, width: 30.0),
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Center(
                      child: Text(e.labelName,
                          maxLines: 2,
                          style: AppPreferences().isLanguageTamil()
                              ? TextStyle(
                                  fontSize: 12,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold)
                              : /* TextStyle(
                                  fontSize: 10,
                                  fontFamily: "Vernada",
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold), */
                              GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold),
                                ),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList());
    if (gridList.length % 3 != 0)
      for (var i = gridList.length % 3; i < 3; i++) {
        items.add(Container(
          width: MediaQuery.of(context).size.width / 3.8,
        ));
      }

    return Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 10.0,
        children: items);
  }

  Widget menuBuilderType3() {
    return Center(
      child: Wrap(
          children: gridList.map((e) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.24,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              //color: Colors.white,
              /*boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 15,
                      blurRadius: 10,
                      offset: Offset(3, 3),
                    ),
                  ],*/
              //  border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Material(
            //elevation: 5.0,
            // shadowColor: Colors.grey[800],

            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () async {
                // Navigator.pop(context);
                // debugPrint(
                //     'Grid List label name: ${gridList[index].labelName}');
                // print(gridList[index].externalUrl);
                selectedLabel = e.labelName;
                // print(e.labelName);
                // print(e.imageName);
                if (e.externalUrl == null || e.externalUrl == "")
                  changeIndex(e.index);
                else
                  await _launchExternalURL(e.externalUrl);
              },
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (e.imageName != null)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200]),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(25),
                      child: getBuilderImage(e.imageName),
                    ),
                  Expanded(
                    child: Container(
                      // color: Colors.red,
                      child: Center(
                        child: Text(e.labelName,
                            maxLines: 2,
                            style: AppPreferences().isLanguageTamil()
                                ? TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold)
                                : /* TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Vernada",
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold), */
                                GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold),
                                  ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList()),
    );
  }

  Widget menuBuilderType4() {
    return Center(
      child: Wrap(
          children: gridList.map((e) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.16,
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              //color: Colors.white,
              /*boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 15,
                      blurRadius: 10,
                      offset: Offset(3, 3),
                    ),
                  ],*/
              //  border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Material(
            //elevation: 5.0,
            // shadowColor: Colors.grey[800],

            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () async {
                // Navigator.pop(context);
                // debugPrint(
                //     'Grid List label name: ${gridList[index].labelName}');
                // print(gridList[index].externalUrl);
                selectedLabel = e.labelName;
                // print(e.labelName);
                // print(e.imageName);
                if (e.externalUrl == null || e.externalUrl == "")
                  changeIndex(e.index);
                else
                  await _launchExternalURL(e.externalUrl);
              },
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (e.imageName != null)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200]),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(25),
                      child: getBuilderImage(e.imageName,
                          height: 35.0, width: 35.0),
                    ),
                  Expanded(
                    child: Container(
                      // color: Colors.red,
                      child: Center(
                        child: Text(e.labelName,
                            maxLines: 2,
                            style: AppPreferences().isLanguageTamil()
                                ? TextStyle(
                                    fontSize: 13,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold)
                                : /* TextStyle(
                                    fontSize: 10,
                                    fontFamily: "Vernada",
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold), */
                                GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold),
                                  ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList()),
    );
  }

  List<Color> colorsList = [
    Color(0xffa4e3da),
    Color(0xffa0d69a),
    Color(0xff9ebef1),
    Color(0xfff69fd6),
    Color(0xfff69fd6),
    Color(0xfff88c8c),
    Color(0xff8cdbf9),
    Color(0xffbca1f2),
    Color(0xff8cd5ca),
    Color(0xff997fbc),
    Color(0xffa0d69a),
    Color(0xffffbb94),
    Color(0xffa4e3da),
    Color(0xfffda88b),
    Color(0xff9ebef1)
  ];
  Widget menuBuilderType5() {
    return Center(
      child: Wrap(
          runSpacing: 10.0,
          spacing: 10.0,
          children: gridList.map((e) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.16,
              width: MediaQuery.of(context).size.width * 0.3,
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.white, //colorsList[gridList.indexOf(e)],
                  /*boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 15,
                      blurRadius: 10,
                      offset: Offset(3, 3),
                    ),
                  ],*/
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: Material(
                //elevation: 5.0,
                // shadowColor: Colors.grey[800],

                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  onTap: () async {
                    // Navigator.pop(context);
                    // debugPrint(
                    //     'Grid List label name: ${gridList[index].labelName}');
                    // print(gridList[index].externalUrl);
                    selectedLabel = e.labelName;
                    // print(e.labelName);
                    // print(e.imageName);
                    if (e.externalUrl == null || e.externalUrl == "")
                      changeIndex(e.index);
                    else
                      await _launchExternalURL(e.externalUrl);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      if (e.imageName != null)
                        getBuilderImage(e.imageName, height: 45.0, width: 35.0),
                      Expanded(
                        child: Container(
                          // color: Colors.red,
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(e.labelName,
                                  maxLines: 2,
                                  style: AppPreferences().isLanguageTamil()
                                      ? TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)
                                      : /* TextStyle(
                                      fontSize: 10,
                                      fontFamily: "Vernada",
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold), */
                                      GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getBuilderImage(image, {double height = 25.0, width = 25.0}) {
    return image.startsWith('http')
        ? Image.network(
            image,
            /* width: gridList[index].index ==
                                     Constants.PAGE_ID_PEOPLE_LIST
                                      ? 20
                                      : 20,
                                      height: 20.0, */
            height: height,
            width: width,
            cacheHeight: height.toInt(),
            cacheWidth: width.toInt(),
            // alignment: Alignment.topCenter,
          )
        : Image.asset(
            image,
            /* width: gridList[index].index ==
                                 Constants.PAGE_ID_PEOPLE_LIST
                                  ? 20
                                  : 20,
                                    height: 20.0, */
            height: height, width: width,
            // alignment: Alignment.topCenter,
          );
  }

  Widget adWidget() {
    var advertisementObj = getAdForScreen(widget.drawerIndex.toString());
    return advertisementObj == null
        ? Container(
            width: 0.0,
            height: 0.0,
          )
        :
        // InterStitialAd(advertisementObj);
        AdvertisementWidget(advertisement: advertisementObj);
  }

  void populateDefaultData() async {
    AppPreferences.getMenuItemsData().then((value) async {
      String data = "";
      if (value == null) {
        data = await rootBundle.loadString('assets/menu.json');
        // debugPrint("Local Json from asset--- ${data.toString()}");
      } else {
        data = value;
        // debugPrint("Local Json from shared preference--- ${data.toString()}");
      }
      List<dynamic> jsonData = json.decode(data);
      MenuItems menuItems = MenuItems.fromJson(jsonData[0]);
      populateDataFromJson(menuItems);
    });
  }

  Future<void> populateDataFromJson(MenuItems value) async {
    List<String> roleType =
        await AppPreferences.getPlatformScheduleExposeRoleTypes();

    final isRoleAvailable = roleType.where((element) =>
        element.toLowerCase() == AppPreferences().userCategory?.toLowerCase());

    bool hasLoggedInSupervisor =
        (AppPreferences().role == Constants.supervisorRole);
    UserInfo user = AppPreferences().userInfo;
    // print("User Role:::::");
    // print(user.tempUserSubType);
    for (int i = 0;
        i <
            (hasLoggedInSupervisor
                ? value.menuInfo.sUPERVISOR.length
                : value.menuInfo.uSER.length);
        i++) {
      String assetUrl = (hasLoggedInSupervisor
          ? value.menuInfo.sUPERVISOR[i].icon
          : value.menuInfo.uSER[i].icon);
      if (hasLoggedInSupervisor) {
        if (value.menuInfo.sUPERVISOR[i].status == 'active') {
          drawerList.add(
            DrawerList(
              index: value.menuInfo.sUPERVISOR[i].pageId,
              labelName: value.menuInfo.sUPERVISOR[i].label,
              isAssetsImage: true,
              imageName: assetUrl,
              externalUrl: value.menuInfo.sUPERVISOR[i].externalUrl,
              internalUrl: value.menuInfo.sUPERVISOR[i].internalUrl,
            ),
          );
        }
      } else {
        // print(value.menuInfo.uSER[i].label);
        if (value.menuInfo.uSER[i].status == 'active') {
          if (AppPreferences().userMemberShipType == LIFE &&
              value.menuInfo.uSER[i].pageId == Constants.PAGE_ID_MEMBERSHIP) {
            //Dont add membership menu for membershipType = life for user role = user
          } else {
            if (isRoleAvailable.isNotEmpty &&
                roleType.contains("Doctor".toUpperCase())) {
              if (value.menuInfo.uSER[i].pageId !=
                      Constants.PAGE_ID_Patient_Assessment &&
                  value.menuInfo.uSER[i].pageId !=
                      Constants.PAGE_ID_Book_Appointments)
                drawerList.add(DrawerList(
                  index: value.menuInfo.uSER[i].pageId,
                  labelName: value.menuInfo.uSER[i].label,
                  isAssetsImage: true,
                  imageName: assetUrl,
                  externalUrl: value.menuInfo.uSER[i].externalUrl,
                  internalUrl: value.menuInfo.uSER[i].internalUrl,
                ));
            } else if (isRoleAvailable.isEmpty &&
                roleType.contains("Doctor".toUpperCase())) {
              if (value.menuInfo.uSER[i].pageId !=
                      Constants.PAGE_ID_Doctor_Schedule &&
                  value.menuInfo.uSER[i].pageId !=
                      Constants.PAGE_ID_Appointment_Confirmation) {
                drawerList.add(DrawerList(
                  index: value.menuInfo.uSER[i].pageId,
                  labelName: value.menuInfo.uSER[i].label,
                  isAssetsImage: true,
                  imageName: assetUrl,
                  externalUrl: value.menuInfo.uSER[i].externalUrl,
                  internalUrl: value.menuInfo.uSER[i].internalUrl,
                ));
              }
            } else {
              /* if (user.tempUserSubType == "User" ||
                  user.tempUserSubType == "Registered Nurse") {
                drawerList.add(DrawerList(
                  index: value.menuInfo.uSER[i].pageId,
                  labelName: value.menuInfo.uSER[i].label,
                  isAssetsImage: true,
                  imageName: assetUrl,
                  externalUrl: value.menuInfo.uSER[i].externalUrl,
                  internalUrl: value.menuInfo.uSER[i].internalUrl,
                ));
              } else {
                if (value.menuInfo.uSER[i].pageId !=
                    Constants.PAGE_ID_Home_Nusrsing_Service) { */
              drawerList.add(DrawerList(
                index: value.menuInfo.uSER[i].pageId,
                labelName: value.menuInfo.uSER[i].label,
                isAssetsImage: true,
                imageName: assetUrl,
                externalUrl: value.menuInfo.uSER[i].externalUrl,
                internalUrl: value.menuInfo.uSER[i].internalUrl,
              ));
              // }
              // }
            }
          }
        }
      }
    }
    // drawerList.add(
    //   DrawerList(
    //     index: Constants.PAGE_ID_Attendance,
    //     labelName: dynamicTitleReturn(Constants.PAGE_ID_Attendance),
    //     isAssetsImage: true,
    //     imageName: "assets/images/attendance.png",
    //     externalUrl: null,
    //     internalUrl: null,
    //   ),
    // );
    if (user.tempUserSubType == "User" ||
        user.tempUserSubType == "Registered Nurse") {
    } else {
      drawerList
          .remove(DrawerList(index: Constants.PAGE_ID_Home_Nusrsing_Service));
    }
    // Constants.PAGE_ID_CALLUS:
    // drawerList.remove(DrawerList(index: Constants.PAGE_ID_CALLUS));

    if (Constants.SETTINGS_ENABLED) {
      drawerList.add(
        DrawerList(
          index: Constants.PAGE_ID_SETTINGS,
          labelName: dynamicTitleReturn(Constants.PAGE_ID_SETTINGS),
          isAssetsImage: true,
          imageName: "assets/images/ic_settings.png",
          externalUrl: null,
          internalUrl: null,
        ),
      );
    } else {
      drawerList.add(
        DrawerList(
          index: Constants.PAGE_ID_RESET_PASSWORD,
          labelName: dynamicTitleReturn(Constants.PAGE_ID_RESET_PASSWORD),
          isAssetsImage: true,
          imageName: "assets/images/updatePassword.png",
          externalUrl: null,
          internalUrl: null,
        ),
      );
    }

    gridList.clear();
    gridList.addAll(drawerList);
    if (gridList.isNotEmpty) {
      gridList.removeAt(0);
    }
// Constants.PAGE_ID_CALLUS
    // gridList.removeWhere((ele) => ele.index == Constants.PAGE_ID_CALLUS);
    if (gridList.isNotEmpty) {
      gridList.removeLast();
    }

    changeIndex(widget.drawerIndex);

    setState(() {});
  }

  double removeDotFromString(String ver) {
    double versionDouble = 0.0;
    if (ver.contains(".")) {
      String versionStr = ver.replaceAll(".", "");
      versionDouble = double.parse(versionStr);
    }

    return versionDouble;
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    return Container(
      // key: _myKey,
      color: DrawerTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            if (widget.drawerIndex != Constants.PAGE_ID_HOME) {
              replaceHome();
              return Future.value(false);
            } else {
              AlertUtils.commonAlertWidget(context, onPositivePress: () {
                Navigator.pop(context);
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  exit(0);
                }
              }, onNegativePress: () {
                Navigator.pop(context);
                return Future.value(false);
              });
              return Future.value(false);
            }
          },
          child: Scaffold(
            backgroundColor: DrawerTheme.nearlyWhite,
            body: Stack(
              children: [
                DrawerUserController(
                  drawerIsOpen: (bool isOpen) {
                    //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
                  },

                  screenIndex:
                      widget.drawerIndex == Constants.PAGE_PERSONAL_INFORMATION
                          ? Constants.PAGE_ID_HOME
                          : widget.drawerIndex,
                  drawerWidth: MediaQuery.of(context).size.width * 0.75,
                  onDrawerCall: (int drawerIndexdata) {
                    // debugPrint("Menu tap --> $drawerIndexdata");
                    // debugPrint("Menu screenIndex --> ${widget.drawerIndex}");

                    if (drawerIndexdata == Constants.PAGE_ID_HOME ||
                        drawerIndexdata == Constants.PAGE_ID_SETTINGS) {
                      changeIndex(drawerIndexdata);
                    } else if (drawerIndexdata != null &&
                        drawerIndexdata != 0) {
                      gridList.forEach((element) {
                        if (element.index == drawerIndexdata) {
                          selectedLabel = element.labelName;
                          changeIndex(drawerIndexdata);
                        }
                      });
                    } else {
                      gridList.forEach((element) {
                        if (element.externalUrl != null) {
                          if (element.index == drawerIndexdata) {
                            selectedLabel = element.labelName;
                            _launchExternalURL(element.externalUrl);
                          }
                        }
                      });
                    }
                    //changeIndex(drawerIndexdata);
                    //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
                  },
                  screenView: screenView,
                  drawerList: drawerList,
                  //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
                ),
                showFlashView
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            showFlashView = false;
                          });
                        },
                        child: Container(
                          color: AppColors.transparentBg,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: MediaQuery.of(context).size.height * 0.1,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Colors.white,
                            ),
                            child: InAppWebView(
                              initialUrl: 'https://flutter.io',
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  replaceHome() {
    changeIndex(Constants.PAGE_ID_HOME);
  }

  void changeIndex2(int a) {
    // print(a);
    // print("calllllling");
    changeIndex(a);
  }

  void changeIndex(int drawerIndexData) async {
    widget.drawerIndex = drawerIndexData;
    // print("=================>   ${widget.drawerIndex}");

    switch (widget.drawerIndex) {
      case Constants.PAGE_ID_HOME:
        screenView = buildHomePageGridView(gridList);
        break;
      case Constants.PAGE_ID_ADD_A_PERSON:
        screenView = UserInformationInappWebViewScreen(
          departmentName: AppPreferences().deptmentName,
          clientId: AppPreferences().clientId,
          title: selectedLabel,
        );

        break;
      case Constants.PAGE_ID_ADD_FAMILY:
        break;
      case Constants.PAGE_ID_PEOPLE_LIST:
        screenView = PeopleListPage(
          title: selectedLabel,
          isCameFromCoping: false,
          actionBloc: actionPeopleBloc,
        );
        break;
      case Constants.PAGE_ID_SUBSCRIPTION_LIST:
        screenView = SubscriptionListScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_TRANSACTION_HISTORY:
        screenView = TransactionHistoryScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_RESERVED_USERS:
        /* screenView = ReservedUsersHistoryScreen(
              onRefreshDrawerHomeScreen: (boo) {
               if (boo) replaceHome();
                },
          );*/
        break;
      case Constants.PAGE_ID_SEARCH_PEOPLE:
        break;
      case Constants.PAGE_ID_RECENT_ACTIVITY:
        screenView = RecentActivityScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_PREVENTION:
        screenView =
            PreventionListWidget(title: selectedLabel); //PreventionPage();
        break;
      case Constants.PAGE_ID_SUPPORT:
        screenView = SupportWidget(title: selectedLabel);
        break;
      case Constants.PAGE_ID_TOBEMEMBER:
        UserInfo user = AppPreferences().userInfo;
        UserInfoMemberShipObject obj;
        if (user.membershipEntitlements == null ||
            user.membershipEntitlements.isEmpty ||
            user.membershipEntitlements == {}) {
          obj = null;
        } else {
          obj = UserInfoMemberShipObject(
              membershipId: user.membershipEntitlements["membershipId"],
              membershipStatus: user.membershipEntitlements["membershipStatus"],
              approvedDate: user.membershipEntitlements["approvedDate"],
              gender: user.gender,
              firstName: user.firstName,
              lastName: user.lastName,
              expiryDate: user.membershipEntitlements["expiryDate"]);
        }
        screenView = UserInfoTabInappWebview(
          superProfile: false,
          userName: user.userName,
          departmentName: user.departmentName,
          clientId: AppPreferences().clientId,
          title: selectedLabel,
          membershipInfo: obj,
        );
        break;

      case Constants.PAGE_ID_CALLUS:
        // print(
        //     "${AppPreferences().hostUrl}/sites/${AppPreferences().siteNavigator}/user_member_editorial.html?");
        screenView = CallUs(title: selectedLabel);
        // screenView = FingerprintPage();
        // _launchExternalURL(
        //     "https://qa-memberly.github.io/qa/sites/DATT/ContactUs.html");
        // await call.canLaunch("tel://1868 607 3288");
        break;

      case Constants.PAGE_ID_QRCODE:
        screenView = QRScanPage(
          title: selectedLabel,
        );
        // screenView = CallUs(title: selectedLabel);
        break;

      case Constants.PAGE_PERSONAL_INFORMATION:
        // screenView = PersonalTabbedInfoScreen(
        //   actionBloc: actionBloc,
        // );

        UserInfo user = AppPreferences().userInfo;

        bool superProfile = true;

        UserInfoValidationBloc ailmentBloc;
        ailmentBloc = UserInfoValidationBloc(context);
        var result = await showAvatarModalBottomSheet(
            isRecentActivity: false,
            expand: true,
            context: context,
            enableDrag: false,
            notification: NewNotification(type: "Profile"),
            backgroundColor: Colors.transparent,
            builder: (context) =>
                UserProfileBottomSheet(user, ailmentBloc, superProfile),
            profileImage: user.profileImage);
        break;
      case Constants.PAGE_ID_HIERARCHICAL:
        screenView = HierarchicalMembershipWidget();
        break;
      case Constants.PAGE_ID_DAILY_CHECK_IN:
        if (AppPreferences().role == Constants.supervisorRole) {
          screenView = PeopleListPage(
            actionBloc: actionPeopleBloc,
            title: selectedLabel,
          );
        } else {
          screenView = CheckInHistoryScreen(null, "");
        }
        break;
      case Constants.PAGE_ID_ADD_USER_FAMILY:
        screenView = PeopleListPage(
          actionBloc: actionPeopleBloc,
          title: selectedLabel,
          isCameFromAddUserFamily: true,
        );

        break;
      case Constants.PAGE_ID_USER_PROFILE:
        if (selectedLabel == null) {
          selectedLabel = "Profile";
          screenView = UserInfoTabInappWebview(
              clientId: AppPreferences().clientId,
              departmentName: AppPreferences().deptmentName,
              userName: AppPreferences().username,
              title: selectedLabel);
        } else {
          screenView = UserInfoTabInappWebview(
              clientId: AppPreferences().clientId,
              departmentName: AppPreferences().deptmentName,
              userName: AppPreferences().username,
              title: selectedLabel);
        }
        break;
      case Constants.PAGE_ID_MEMBERSHIP:
        if (AppPreferences().role == Constants.supervisorRole) {
          screenView = MembershipListScreen(title: selectedLabel);
        } else {
          // screenView = MembershipScreen(
          //   membershipId: null,
          // );
          screenView = MembershipInappWebviewScreen(
              departmentName: AppPreferences().deptmentName,
              userName: AppPreferences().username,
              loggedInRole: "user",
              membershipId: null,
              clientId: AppPreferences().clientId,
              title: "Membership Information");
        }
        break;
      case Constants.PAGE_ID_DIABETES:
        if (AppPreferences().role == Constants.supervisorRole) {
          screenView = DiabetesRiskScoreTab(title: selectedLabel);
        } else {
          screenView = DiabetesRiskScoreListScreen(null);
        }
        break;
      case Constants.PAGE_ID_EVENTS_LIST:
        screenView = FeedListScreenNew(title: selectedLabel);
        break;
      case Constants.PAGE_ID_EVENT_DETAILS:
        screenView = EventDetails(title: selectedLabel);
        break;
      case Constants.PAGE_ID_ELECTION_POLL:
        screenView = ElectionPollInAppWebView();
        break;
      case Constants.PAGE_ID_SEND_MESSAGE:
        screenView = SendMessageScreen(title: selectedLabel);
        break;
      // case Constants.PAGE_ID_EVENTS_LIST:
      //   screenView = FeedListScreenNew(title: selectedLabel);
      //   break;
      case Constants.PAGE_ID_CAMPAIGN_LIST:
        screenView = CampaignListScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_SETTINGS:
        /* screenView = SampleInAppWebView(
            showFlashView: () {
              setState(() {
                showFlashView = true;
              });
            },
          );*/
        screenView = SettingsScreen(title: selectedLabel);
        // screenView = SampleInAppWebView();
        break;
      case Constants.PAGE_ID_LOGOUT:
        screenView = SettingsScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_RESET_PASSWORD:
        screenView = ResetPassword(
          title: selectedLabel,
          onRefreshDrawerHomeScreen: (boo) {
            if (boo) replaceHome();
          },
        );
        break;
      case Constants.PAGE_ID_Administration:
        screenView = AdministrationScreen(title: selectedLabel);
        break;
      // case Constants.PAGE_ID_User_Request:
      //   screenView = UserRequest(title: selectedLabel);
      //   break;

      case Constants.PAGE_ID_SMART_NOTE:
        screenView = SmartNoteFileListScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_COMMITTEES:
        screenView = CommitteesListScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_DONATION:
        screenView = DonationListScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_FAQ:
        screenView = FaqScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_BOOK_APPOINTMENT:
        screenView = BookAppointmentHomeScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_Doctor_Schedule:
        // print("category is" + AppPreferences().userCategory);
        AppPreferences().userCategory.toUpperCase() == "DOCTOR" ||
                AppPreferences().userCategory.toUpperCase() == "CONSULTANT"
            ? screenView = DoctorSchedulerScreen(title: selectedLabel)
            : SizedBox.shrink();
        break;
      case Constants.PAGE_ID_Appointment_Confirmation:
        AppPreferences().userCategory.toUpperCase() == "DOCTOR" ||
                AppPreferences().userCategory.toUpperCase() == "CONSULTANT"
            ? screenView =
                AppointmentConfirmationListScreen(title: selectedLabel)
            : SizedBox.shrink();
        break;
      case Constants.PAGE_ID_Appointment_History:
        screenView = AppointmentHistoryScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_Book_Appointments:
        AppPreferences().userCategory == "CONSULTANT"
            ? screenView = PatientUserList()
            : AppPreferences().userCategory.toUpperCase() != "DOCTOR"
                ? screenView = SelectPhysicianScreen(title: selectedLabel)
                : SizedBox.shrink();
        break;
      case Constants.PAGE_ID_Doctor_List:
        screenView = DoctorListScreen(title: selectedLabel);
        break;

      case Constants.PAGE_ID_Attendance:
        screenView = AttendanceScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_NEWSFEED:
        screenView = NewsFeedScreen(title: selectedLabel);
        break;
      case Constants.PAGE_ID_Home_Nusrsing_Service:
        // final _repository = Auth.AuthRepository();
        // debugPrint("OLD Email: ${AppPreferences().email}");
        // _repository
        //     .signInMultipartRequest(AppPreferences().email, "Memberly@123")
        //     .then((response) async {
        //   debugPrint("response.status.toString()");
        //   debugPrint(response.status.toString());
        //   if (response.status == 200) {
        //     AppPreferences.setUserGroup(response.userGroup);
        //     AppPreferences.setToken(response.token);
        //     // AppPreferences.setEmail("jhonmathewsjr@gmail.com");
        //     await AppPreferences().init();
        //   } else {
        //     UserInfo userInfo = await AppPreferences.getUserInfo();
        //     debugPrint("userInfo.tempUserSubType");
        //     debugPrint(userInfo.tempUserSubType);
        //     String userType;
        //     if (userInfo.tempUserSubType == "User") {
        //       userType = "requester";
        //     } else {
        //       userType = "supplier";
        //     }
        //     debugPrint("userType");
        //     debugPrint(userType);
        //     _repository
        //         .signUpMultipartRequest(
        //             AppPreferences().email, "Memberly@123", userType)
        //         .then((response) async {
        //       print("test registration");
        //       print(response.statusCode.toString());
        //       print(response.toJson().toString());
        //       AppPreferences.setUserGroup(response.userGroup);
        //       AppPreferences.setToken(response.token);
        //     });
        //   }
        // });
        screenView = HomeCareNursingPage(
          title: selectedLabel,
        );
        break;

      case Constants.PAGE_ID_Patient_Assessment:
        AppPreferences().userCategory.toUpperCase() != "DOCTOR"
            ? screenView = AssessmentHistory(selectedLabel)
            : SizedBox.shrink();
        /* 
          screenView = MembershipInappWebviewScreen(
                departmentName: AppPreferences().deptmentName,
                userName: AppPreferences().username,
                loggedInRole: "user",
                membershipId: null,
                clientId: AppPreferences().clientId,
                title: "Membership Information");
           */
        break;
      // case Constants.PAGE_ID_ABOUT_US:
      //   screenView = AboutUs();
      // case Constants.PAGE_ID_INAPP_WEBVIEW:
      //   {
      //     drawerList.forEach((element) {
      //       if (element.index == widget.drawerIndex) {
      //         screenView = InternalInappWebviewScreen(
      //           title: element.labelName,
      //           pageURL: element.internalUrl,
      //         );
      //       }
      //     });
      //     break;
      //   }

      /*case Constants.PAGE_ID_Home_Nusrsing_Service:
          screenView = HomeNursingServices(title: selectedLabel);
          break;*/

      default:
        drawerList.forEach((element) {
          if (element.index == widget.drawerIndex &&
              element.internalUrl != null) {
            if (isInternalInAppWebViewLoaded) {
              isInternalInAppWebViewLoaded = false;
              screenView = InternalInappWebviewScreen(
                title: element.labelName,
                pageURL: element.internalUrl,
              );
            } else {
              isInternalInAppWebViewLoaded = true;
              screenView = InternalInappWebviewScreenAlternate(
                title: element.labelName,
                pageURL: element.internalUrl,
              );
            }
          }
        });
        break;
    }
    screenView = Column(
      children: <Widget>[
        Expanded(child: screenView),
        getAdWidgetForScreenIndex()
      ],
    );
    if (drawerIndexData != Constants.PAGE_PERSONAL_INFORMATION) setState(() {});
    //    }
  }

  String dynamicTitleReturn(int selectedPageId) {
    switch (selectedPageId) {
      case Constants.PAGE_ID_HOME:
        return AppLocalizations.of(context).translate("key_home");
      case Constants.PAGE_ID_ADD_A_PERSON:
        return AppLocalizations.of(context).translate("key_addperson");
      case Constants.PAGE_ID_ADD_FAMILY:
        return AppLocalizations.of(context).translate("key_addFamily");
      case Constants.PAGE_ID_PEOPLE_LIST:
        return AppLocalizations.of(context).translate(
            AppPreferences().isTTDEnvironment()
                ? "key_peoplelist_tt"
                : "key_peoplelist");
      case Constants.PAGE_ID_RESERVED_USERS:
        return AppLocalizations.of(context).translate("key_reservedusers");
      case Constants.PAGE_ID_SEARCH_PEOPLE:
        return AppLocalizations.of(context).translate("key_searchpeople");
      case Constants.PAGE_ID_RECENT_ACTIVITY:
        return AppLocalizations.of(context).translate("key_recentactivity");
      case Constants.PAGE_ID_PREVENTION:
        return AppLocalizations.of(context).translate(
            AppPreferences().isTTDEnvironment()
                ? "key_prevention_tt"
                : "key_prevention");
      case Constants.PAGE_ID_SUPPORT:
        return AppLocalizations.of(context).translate("key_support");
      case Constants.PAGE_PERSONAL_INFORMATION:
        return AppLocalizations.of(context)
            .translate("key_personalinformation");
      case Constants.PAGE_ID_DAILY_CHECK_IN:
        return AppLocalizations.of(context).translate(
            AppPreferences().isTTDEnvironment()
                ? "key_dailycheckin_tt"
                : "key_dailycheckin");
      case Constants.PAGE_ID_PORT_MONITORING:
        return AppLocalizations.of(context).translate("key_port_monitoring");
      case Constants.PAGE_ID_RESET_PASSWORD:
        return AppLocalizations.of(context).translate("key_reset");
      case Constants.PAGE_ID_LOGOUT:
        return AppLocalizations.of(context).translate("key_logout");
      case Constants.PAGE_ID_SETTINGS:
        return AppLocalizations.of(context).translate("key_setting");

      case Constants.PAGE_ID_COPING:
        return AppLocalizations.of(context).translate("key_how_are_you_coping");
      case Constants.PAGE_ID_ADD_USER_FAMILY:
        return AppLocalizations.of(context).translate("key_edit_my_family");
      case Constants.PAGE_ID_TRANSACTION_HISTORY:
        return "Transaction History";
      case Constants.PAGE_ID_SMART_NOTE:
        return "Smart Notes";
      case Constants.PAGE_ID_COMMITTEES:
        return "Committee";
      case Constants.PAGE_ID_DONATION:
        return "Tithe";
      case Constants.PAGE_ID_FAQ:
        return "FAQ";
      case Constants.PAGE_ID_BOOK_APPOINTMENT:
        return "BOOK APPOINTMENT";
      case Constants.PAGE_ID_Doctor_List:
        return "Doctor List";
      case Constants.PAGE_ID_Attendance:
        return "Attendance";
      case Constants.PAGE_ID_Home_Nusrsing_Service:
        return "Home Nursing Service";
      case Constants.PAGE_ID_NEWSFEED:
        return "News Feed";

      default:
        return null;
    }
  }

  getpicture(String userName) async {
    AuthRepository _authRepository;
    UserInfo userInfo;
    String imageProfileUrl;
    userInfo = await _authRepository.getUserInfo(userName);

    imageProfileUrl = userInfo.profileImage;

    return imageProfileUrl;

    // return Image.network(imagePath);
  }
}

class ShowReminderFlashCards extends StatefulWidget {
  final setRemainders;
  final remaindersListData;
  ShowReminderFlashCards({this.setRemainders, this.remaindersListData});
  @override
  _ShowReminderFlashCardsState createState() => _ShowReminderFlashCardsState();
}

class _ShowReminderFlashCardsState extends State<ShowReminderFlashCards> {
  bool expanded = true;

  bool isLoading = true;
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return /*widget.setRemainders == null || !widget.setRemainders
        ? SizedBox.shrink()
        : (widget.remaindersListData == null ||
                widget.remaindersListData.length == 0)
            ? SizedBox.shrink()
            : */ /* Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        children: [
                          Text('Flash Cards',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold),
                              )),
                          // remaindersListData.length == 0
                          //     ? Text("")
                          //     : Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: GFBadge(
                          //           child: Text(
                          //             "${remaindersListData.length}",
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //           color: AppColors.arrivedColor,
                          //           shape: GFBadgeShape.pills,
                          //           size: GFSize.SMALL,
                          //         ),
                          //       ),
                          IconButton(
                              icon: Icon(
                                expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 26,
                              ),
                              onPressed: () {
                                setState(() {
                                  expanded = !expanded;
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                  widget.setRemainders == null || !widget.setRemainders
                      ? SizedBox.shrink()
                      : (remaindersListData == null ||
                              remaindersListData.length == 0)
                          ? SizedBox.shrink()
                          : expanded
                              ? Container(
                                  child: FlashCardCarousel(
                                      remaindersListData: remaindersListData),
                                )
                              : SizedBox.shrink(),
                ],
              ); */
        Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Expanded(
              child: Text("Flash Cards",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Transform.translate(
              offset: Offset(5, 0),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 26,
                  ),
                ),
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
          ]
              // trailing: Icon(Icons.arrow_forward),
              ),
        ),
      ),
      !expanded
          ? SizedBox.shrink()
          : ShowFlashCardInAppWebViewScreen(
              webViewHeight: 200.0,
            ),
    ]);
    ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,
        expansionCallback: (index, isExpanded) {
          setState(() {
            expanded = !expanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (index, isExpanded) {
              return Container(
                color: Colors.red,
                // height: 20.0,
                child: Row(
                  children: [
                    Text('Flash Cards',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        )),
                    remaindersListData.length == 0
                        ? Text("")
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFBadge(
                              child: Text(
                                "${remaindersListData.length}",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: AppColors.arrivedColor,
                              shape: GFBadgeShape.pills,
                              size: GFSize.SMALL,
                            ),
                          ),
                  ],
                ),
              );
            },
            body:
/*                          widget.setRemainders == null || !widget.setRemainders
                              ? SizedBox.shrink()
                              : (remaindersListData == null ||
                                      remaindersListData.length == 0)
                                  ? SizedBox.shrink()
                                  : expanded
                                      ? Container(
                                          child: FlashCardCarousel(
                                              remaindersListData:
                                                  remaindersListData),
                                        )
                                      : SizedBox.shrink(),*/
                ShowFlashCardInAppWebViewScreen(
              webViewHeight: 200.0,
            ),
            isExpanded: expanded,
          )
        ]);
  }
}

class FlashCardCarousel extends StatefulWidget {
  final remaindersListData;

  const FlashCardCarousel({Key key, this.remaindersListData}) : super(key: key);

  @override
  _FlashCardCarouselState createState() => _FlashCardCarouselState();
}

class _FlashCardCarouselState extends State<FlashCardCarousel>
    with TickerProviderStateMixin {
  int _current = 0;
  AnimationController animationController;

  final _controller = ScrollController();

  ScrollPhysics _physics;

  double _currentPosition = 0.0;

  double _validPosition(double position) {
    if (position >= widget.remaindersListData.length) return 0;
    if (position < 0) return widget.remaindersListData.length - 1.0;
    return position;
  }

  void _updatePosition(double position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  @override
  initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _controller.addListener(() {
      double currentPage =
          _controller.position.pixels / _controller.position.viewportDimension;
      setState(() {
        if (currentPage > 0.0) {
          _current = (currentPage + 1).toInt();
        } else {
          _current = currentPage.round();
        }
      });
      if (_controller.position.haveDimensions && _physics == null) {
        setState(() {
          var dimension = _controller.position.maxScrollExtent /
              (widget.remaindersListData.length - 1);
          _physics = CustomScrollPhysics(itemDimension: dimension);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 0),
          height: MediaQuery.of(context).size.height * 0.2,
          color: Colors.white,
          child:
              /* CarouselSlider(
              items: getReminderList(widget.remaindersListData),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.2,
                initialPage: 0,
                viewportFraction: 0.63,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                enlargeCenterPage: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              )), */
              ListView(
            controller: _controller,
            physics: _physics,
            children: getReminderList(widget.remaindersListData),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: getListOfDots(),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlashCards(
                              remaindersListData: widget.remaindersListData)));
                },
                child: Row(
                  children: [
                    Text("View More",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 13)),
                    Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  getListOfDots() {
    List<Widget> dotWidgets = [];
    // print(widget.remaindersListData.length);
    widget.remaindersListData.forEach(
      (image) {
        //these two lines
        int index = widget.remaindersListData.indexOf(image); //are changed
        dotWidgets.add(Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4)),
        ));
      },
    ) as List<Widget>;
    return dotWidgets;
  }

  List<Widget> getReminderList(remaindersListData) {
    List<Widget> reminderList = [];
    for (var i = 0; i < remaindersListData.length; i++) {
      final int count =
          remaindersListData.length > 10 ? 10 : remaindersListData.length;
      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * i, 1.0, curve: Curves.fastOutSlowIn)));
      animationController.forward();
      reminderList.add(Container(
        width: MediaQuery.of(context).size.width * 0.80,
        color: Colors.white,
        child: RemaindersView(
          remaindersListData: remaindersListData[i],
          // animation: animation,
          // animationController: animationController,
        ),
      ));
    }
    return reminderList;
  }
}

class ShowNewsFeedCard extends StatefulWidget {
  final setNewsFeed;

  ShowNewsFeedCard({this.setNewsFeed});

  @override
  _ShowNewsFeedCardState createState() => _ShowNewsFeedCardState();
}

class _ShowNewsFeedCardState extends State<ShowNewsFeedCard> {
  bool expanded = true;
  bool isLoading = true;
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return widget.setNewsFeed == null || !widget.setNewsFeed
        ? SizedBox.shrink()
        : Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Expanded(
                    child: Text("News Feed",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Transform.translate(
                    offset: Offset(5, 0),
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          expanded ? Icons.expand_less : Icons.expand_more,
                          size: 26,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    ),
                  ),
                ]
                    // trailing: Icon(Icons.arrow_forward),
                    ),
              ),
            ),
            widget.setNewsFeed == null || !widget.setNewsFeed
                ? SizedBox.shrink()
                : !expanded
                    ? SizedBox.shrink()
                    : Column(children: [
                        ShowNewsFeedInAppWebViewScreen(
                          webViewHeight:
                              MediaQuery.of(context).size.height * 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 10.0, height: 8.0),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsFeedScreen()));
                                },
                                child: Row(
                                  children: [
                                    Text("View More",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: 13)),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.blue, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
          ]);
  }
}
/* Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: Text("View More",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 13)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsFeedScreen()));
                                },
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.blue, size: 16),
                            ],
                          ), */

class DrawerList {
  DrawerList({
    this.isAssetsImage = true,
    this.labelName = '',
    this.icon,
    this.index,
    this.status,
    this.imageName = '',
    this.externalUrl,
    this.internalUrl,
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  int index;
  bool status;
  String externalUrl;
  String internalUrl;
}

class CustomScrollPhysics extends ScrollPhysics {
  final double itemDimension;

  CustomScrollPhysics({this.itemDimension, ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(
        itemDimension: itemDimension, parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position) {
    return position.pixels / itemDimension;
  }

  double _getPixels(double page) {
    return page * itemDimension;
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

/* class menuGridBuilder extends StatefulWidget {
  final List<DrawerList> gridList;
  menuGridBuilder({Key key, this.gridList}) : super(key: key);

  @override
  _menuGridBuilderState createState() => _menuGridBuilderState();
}

class _menuGridBuilderState extends State<menuGridBuilder> {
  bool seeAll = false;
  double settingHeight = 190.0;

  @override
  void initState() {
    super.initState();
    heightSet();
  }

  heightSet() {
    if (widget.gridList.length > 8) {
      if (widget.gridList.length < 13)
        setState(() {
          settingHeight = 190.0 + 95.0;
        });
      else if (widget.gridList.length > 12 && widget.gridList.length < 17)
        setState(() {
          settingHeight = 190.0 + 170.0;
        });
      else if (widget.gridList.length > 16 && widget.gridList.length < 21)
        setState(() {
          settingHeight = 190.0 + 190.0 + 95.0;
        });
      else if (widget.gridList.length > 20 && widget.gridList.length < 25)
        setState(() {
          settingHeight = 190.0 + 190.0 + 190.0;
        });
      else if (widget.gridList.length > 24 && widget.gridList.length < 29)
        setState(() {
          settingHeight = 190.0 + 190.0 + 190.0 + 95.0;
        });
      else if (widget.gridList.length > 28 && widget.gridList.length < 33)
        setState(() {
          settingHeight = 190.0 + 190.0 + 190.0 + 190.0;
        });
      else if (widget.gridList.length > 32 && widget.gridList.length < 37)
        setState(() {
          settingHeight = 190.0 + 190.0 + 190.0 + 190.0 + 95.0;
        });
      else if (widget.gridList.length > 36 && widget.gridList.length < 40)
        setState(() {
          settingHeight = 190.0 + 190.0 + 190.0 + 190.0 + 190.0;
        });
    } else
      setState(() {
        settingHeight = 190.0;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 10),
      onEnd: () {
        setState(() {
          seeAll = !seeAll;
        });
      },
      child: Column(
        children: [
          Container(
              // color: Colors.red,
              height: seeAll
                  ?
                  // if(widget.gridList.length> 12)
                  settingHeight
                  : 190.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children: List.generate(
                      widget.gridList.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              elevation: 2.0,
                              // shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        // spreadRadius: 2,
                                        // blurRadius: 2,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(5)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    print("Dhinakarannnn");
                                    print(settingHeight);
                                    print("widget.gridList[index].index");
                                    print(widget.gridList[index].index);
                                    print("_myKey.currentState.changeIndex");
                                    print(_myKey.currentState);
                                    selectedLabel =
                                        widget.gridList[index].labelName;
                                    if (widget.gridList[index].externalUrl ==
                                            null ||
                                        widget.gridList[index].externalUrl ==
                                            "")
                                      // _myKey.currentState.changeIndex(
                                      //     widget.gridList[index].index);
                                      NavigationHomeScreen().changeIndex1(
                                          widget.gridList[index].index);
                                    // else
                                    //   await _launchExternalURL(
                                    //       widget.gridList[index].externalUrl);
                                  },
                                  child: Ink(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            if (widget.gridList[index]
                                                    .imageName !=
                                                null)
                                              widget.gridList[index].imageName
                                                      .startsWith('http')
                                                  ? Expanded(
                                                      child: Image.network(
                                                        widget.gridList[index]
                                                            .imageName,
                                                        /* width: gridList[index].index ==
                                             Constants.PAGE_ID_PEOPLE_LIST
                                              ? 20
                                              : 20,
                                              height: 20.0, */
                                                        height: 40,
                                                        width: 40,
                                                        cacheHeight: 40,
                                                        cacheWidth: 40,
                                                        alignment:
                                                            Alignment.topCenter,
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: Container(
                                                        // color: Colors.grey,
                                                        child: Image.asset(
                                                          widget.gridList[index]
                                                              .imageName,
                                                          /* width: gridList[index].index ==
                                               Constants.PAGE_ID_PEOPLE_LIST
                                                ? 20
                                                : 20,
                                                  height: 20.0, */
                                                          height: 30.0,
                                                          width: 30.0,
                                                          alignment: Alignment
                                                              .topCenter,
                                                        ),
                                                      ),
                                                    ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                    widget.gridList[index]
                                                        .labelName,
                                                    maxLines: 2,
                                                    style: AppPreferences()
                                                            .isLanguageTamil()
                                                        ? TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.indigo,
                                                            fontWeight:
                                                                FontWeight.bold)
                                                        : /* TextStyle(
                                        fontSize: 10,
                                        fontFamily: "Vernada",
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold), */
                                                        GoogleFonts.raleway(
                                                            textStyle: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey[600],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          )),
                ),
              )),
          GestureDetector(
            onTap: () {
              setState(() {
                seeAll = !seeAll;
              });
            },
            child: widget.gridList.length > 8
                ? Text("${seeAll ? "See Less" : "See More"}")
                : SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
 */
/* Widget menuGridBuilder(gridList: gridList) {
    print("ddddddd");
    print(gridList.length);
    return AnimatedContainer(
      duration: Duration(milliseconds: 1),
      onEnd: () {
        setState(() {
          seeAll = !seeAll;
        });
      },
      child: Container(
          height: seeAll ? 150 : 120,
          width: double.infinity,
          color: seeAll ? Colors.red : Colors.blue,
          child: Column(
            children: [
              Container(
                height: 80,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      seeAll = !seeAll;
                    });
                  },
                  child: Text("${seeAll ? "See Less" : "See All"} "))
            ],
          )),
    );


 */
