import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/global_configuration_bloc.dart';
import '../bloc/user_info_bloc.dart';
import '../login/constants/api_constants.dart';
import '../login/stateLessWidget/upper_logo_widget.dart';
import '../model/passing_arg.dart';
import '../repo/app_env_props_rep.dart';
import '../repo/common_repository.dart';
import '../ui/app_translations.dart';
import '../ui/application.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'global_config/global_config_tabbed_screen.dart';
import 'global_configuration_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String pageToGo;

  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;
  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
  };

  UserInfoBloc bloc;

  @override
  Future<void> initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setEnabledSystemUIOverlays([]);
    initializeNotification();
    initializeFcm();
    AppPreferences().init();
    AppPreferences().setContext(context);
//    initUniLinks();
    //TODO: Need to put it as a separate class
    //initDeepLinkingConfig(context);
    if (AppPreferences().apiURL == null ||
        AppPreferences().apiURL.trim().isEmpty) {
      print("AppPreferences().apiURL ---> Splash");
      print(AppPreferences().apiURL);
      submitToken(context);
    } else {
      new Future.delayed(const Duration(seconds: 3), () {
        print("object----");
        print(AppPreferences().loginStatus);
        if (!AppPreferences().loginStatus) {
          submitToken(context);

          Navigator.pushReplacementNamed(context, Routes.login);
        } else {
          Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen);
        }
      });
    }
    super.initState();
  }

  loginShare() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.getInt("QRLogin") != 1) {
      await prefs.setInt("QRLogin", 1);
      // logOut = DateTime.now().add(Duration(seconds: 15));
      // await AppPreferences.logoutClearPreferences();
    }
  }

  void submitToken(BuildContext context) {
    GlobalConfigurationBloc _globalConfigurationBloc =
        GlobalConfigurationBloc(context);
    _globalConfigurationBloc.decodeGlobalConfigurationsUsingToken("QA1122",
        isPromoCode: true);

    _globalConfigurationBloc.globalConfigurationDecodeFetcher
        .listen((value) async {
      // print("QA1053");
      if (value.message != null && value.message.isNotEmpty) {
        debugPrint(value.message);
        Fluttertoast.showToast(msg: value.message);
      } else {
        await AppPreferences.setDeptName(value.departmentName);
        await AppPreferences.setPromoDepartmentName(value.departmentName);
        await AppPreferences.setEnvProps(value.envProps);
        await AppPreferences.setEnvironmentShortCode(
            value.environmentShortCode);
        await AppPreferences.setEnvironment(value.environmentCode);
        await AppPreferences().init();
        // debugPrint("value.countryName");
        // debugPrint(value.countryName);
        //
        //

        AppPreferences.setApiUrl(value.apiUrl).then((setUrlResponse) async {
          await AppEnvPropRepo.fetchEnvProps();
        });

        AppPreferences.setCountry(value.countryName).then((setCountryResponse) {
          AppPreferences.setApiUrl(value.apiUrl).then((setUrlResponse) {
            AppPreferences.setTenant(value.keyspace).then((value) async {
              // Fluttertoast.showToast(
              //     msg: "Success",
              //     gravity: ToastGravity.TOP,
              //     toastLength: Toast.LENGTH_LONG);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.login, (Route<dynamic> route) => false);
            });
          });
        });
      }
    });
  }

  StreamSubscription _sub;

  Future<void> initDeepLinkingConfig(BuildContext context) async {
    _sub = getLinksStream().listen((String link) {
      if (this.mounted)
        setState(() {
          deepLinkingURL = link;
        });
      loadWithOutTimer(link);
    }, onError: (err) {});

    try {
      String link = await getInitialLink();
      if (this.mounted)
        setState(() {
          deepLinkingURL = link;
        });
      loadWithOutTimer(link);
//      onLoad(context);
    } catch (err) {
      print('initial link error: $err');
    }
  }

  loadWithOutTimer(String deepLinkingURL) {
    if (deepLinkingURL != null &&
        deepLinkingURL.isNotEmpty &&
        !AppPreferences().loginStatus) {
      print('deepLinkingURLLoadWithoutTimer $deepLinkingURL');
      deepLinkingURL = deepLinkingURL.replaceFirst("global/", "global");
      Uri linkUri = Uri.parse(deepLinkingURL);
      String param = linkUri.queryParameters["token"] ?? "";
      if (param.isNotEmpty) {
        if (Constants.GC_REGISTRATION_ENABLED) {
          Navigator.pushReplacement(
              AppPreferences().context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      GlobalConfigTabbedScreen(token: param)));
        } else {
          Navigator.pushReplacement(
              AppPreferences().context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      GlobalConfigurationPage(token: param)));
        }
      }
    } else {
      new Future.delayed(const Duration(seconds: 3), () {
        if (!AppPreferences().loginStatus) {
          Navigator.pushReplacementNamed(context, Routes.login);
        } else {
          Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen);
        }
      });
    }
  }

  String deepLinkingURL;

  String returnToken(String deepLinkingURL) {
    deepLinkingURL = deepLinkingURL.replaceFirst("global/", "global");
    Uri linkUri = Uri.parse(deepLinkingURL);
    String param = linkUri.queryParameters["token"] ?? "";
    return param;
  }

  onLoad(BuildContext context) async {
    deepLinkingURL = await getInitialLink();
    if (AppPreferences().gcPageIsShowing &&
        deepLinkingURL != null &&
        bloc != null) {
      bloc.countryCodeFetcher.sink.add(returnToken(deepLinkingURL));
    } else {
      new Future.delayed(const Duration(seconds: 3), () {
        if (deepLinkingURL != null &&
            deepLinkingURL.isNotEmpty &&
            !AppPreferences().loginStatus) {
          print('deepLinkingURLOnLoad $deepLinkingURL');
          deepLinkingURL = deepLinkingURL.replaceFirst("global/", "global");
          Uri linkUri = Uri.parse(deepLinkingURL);
          String param = linkUri.queryParameters["token"] ?? "";
          if (param.isNotEmpty && !AppPreferences().loginStatus) {
            bloc = UserInfoBloc(context);
            Navigator.pushReplacementNamed(context, Routes.login);
          } else {
            if (!AppPreferences().loginStatus) {
              Navigator.pushReplacementNamed(
                  context, Routes.globalConfigurationPage);
            } else {
              Navigator.pushReplacementNamed(
                  context, Routes.navigatorHomeScreen);
            }
          }
        } else if (AppPreferences().loginStatus) {
          initializeFcm();
          FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
          _firebaseMessaging
              .getToken()
              .then((value) => sendTokenToServer(value));
          if (pageToGo != null && pageToGo.isNotEmpty) {
            goToSpecificPage();
          } else {
            Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen);
          }
        } else {
          AppPreferences.getApiUrl().then((value) {
            if (value.isEmpty) {
              Navigator.pushReplacementNamed(
                  context, Routes.globalConfigurationPage);
            } else {
              Navigator.pushReplacementNamed(context, Routes.login);
            }
          });
        }
      });
    }
  }

  void goToSpecificPage() async {
    if (pageToGo == Routes.noticeBoardScreen) {
      Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen,
          arguments: Args(drawerIndex: Constants.PAGE_ID_RECENT_ACTIVITY));
    } else if (pageToGo == Routes.dashBoard) {
      Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen,
          arguments: Args(drawerIndex: Constants.PAGE_ID_HOME));
    } else if (pageToGo == Routes.supportScreen) {
      Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen,
          arguments: Args(drawerIndex: Constants.PAGE_ID_SUPPORT));
    } else if (pageToGo == Routes.peopleListScreen) {
      Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen,
          arguments: Args(drawerIndex: Constants.PAGE_ID_PEOPLE_LIST));
    } else {
      Navigator.pushReplacementNamed(context, Routes.navigatorHomeScreen,
          arguments: Args(drawerIndex: Constants.PAGE_ID_HOME));
    }
  }

  int notificationId = 0;

  void initializeFcm() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) => sendTokenToServer(value));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("FCM----- onMessage: $message");
        String title = message["notification"]["title"];
        String body = message["notification"]["body"];
        String page = message["data"]["route"];
        pageToGo = page;
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'channelId', 'ChannelNameDATT', 'DATT Notifications',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            notificationId++, title, body, platformChannelSpecifics,
            payload: 'item x');
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint("FCM----- onLaunch: $message");
        String page = message["data"]["route"];
        pageToGo = page;
        debugPrint("page to go---" + pageToGo);
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint("FCM----- onResume: $message");
        String page = message["data"]["page"];
        pageToGo = page;
        debugPrint("page to go---" + pageToGo);
      },
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      debugPrint('pagetogo: ' + pageToGo);
      goToSpecificPage();
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
              debugPrint("notification pressed ios");
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setContext(context);
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.end,
//                    crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.55,
          ),
          Expanded(child: UpperLogoWidget()),
          Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 0, bottom: 20),
                child: LinearPercentIndicator(
                  // width: MediaQuery.of(context).size.width,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 3000,
                  percent: 0.9,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.blue,
                  backgroundColor: Colors.white10,
                ),
              )),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Powered By",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(left: 30, bottom: 10),
                  child: Image.asset(
                    'assets/images/sivisoft_logo.png',
                    width: 130,
                    height: 50,
                  ),
                )
              ],
            ),
          ),
        ]));
  }

  void initializeNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  sendTokenToServer(String token) {
    debugPrint("FCM Device token---------------$token");
    UserInfoBloc userInfoBloc = new UserInfoBloc(context);
    userInfoBloc.updateUserFcmToken(token);
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

_checkVersionUpdateAPICall(String version) async {
  String platForm = Platform.operatingSystem.toUpperCase();
  String appName =
      (AppPreferences().appName == null || AppPreferences().appName.isEmpty)
          ? 'Memberly'
          : AppPreferences().appName;
  //If base URL is there then only we should call the APi ese it will throw error
  if (WebserviceConstants.baseURL != null &&
      WebserviceConstants.baseURL.length > 0) {
    String urlParam = 'app_name=$appName&platform=$platForm&version=$version';

    final response = await http
        .get(WebserviceConstants.baseURL + ApiConstants.APP_VERSION + urlParam);
    debugPrint('Version Update:' +
        WebserviceConstants.baseURL +
        ApiConstants.APP_VERSION +
        urlParam);
    if (response.statusCode > 199 && response.statusCode < 299) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.body.length > 0) {
        // print(response.body.toString());
        Version versionObj = Version.fromJson(json.decode(response.body));
        if (versionObj != null && versionObj.isUpdateAvailable) {
          Future.delayed(const Duration(milliseconds: 5000), () {
// Here you can write your code

            AlertUtils.showAppUpdateALert(AppPreferences().context, versionObj);
          });
        } else {
          //no update required
        }
      } else {
        // If the server did not return a 200 OK response,
        //no need of alert message
      }
    }
  }
}

class Version {
  String createdOn;
  String createdBy;
  String modifiedOn;
  String modifiedBy;
  String guid;
  String appName;
  String version;
  String platform;
  String priority;
  String status;
  String downloadUrl;
  String launchDate;
  String nextVersion;
  String message;
  bool isUpdateAvailable;
  bool isMandatoryUpdate;

  Version(
      {this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy,
      this.guid,
      this.appName,
      this.version,
      this.platform,
      this.priority,
      this.status,
      this.downloadUrl,
      this.launchDate,
      this.nextVersion,
      this.message,
      this.isUpdateAvailable,
      this.isMandatoryUpdate});

  Version.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    guid = json['guid'];
    appName = json['appName'];
    version = json['version'];
    platform = json['platform'];
    priority = json['priority'];
    status = json['status'];
    downloadUrl = json['downloadUrl'];
    launchDate = json['launchDate'];
    nextVersion = json['nextVersion'];
    message = json['message'];
    isUpdateAvailable = json['isUpdateAvailable'];
    isMandatoryUpdate = json['isMandatoryUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedBy'] = this.modifiedBy;
    data['guid'] = this.guid;
    data['appName'] = this.appName;
    data['version'] = this.version;
    data['platform'] = this.platform;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['downloadUrl'] = this.downloadUrl;
    data['launchDate'] = this.launchDate;
    data['nextVersion'] = this.nextVersion;
    data['message'] = this.message;
    data['isUpdateAvailable'] = this.isUpdateAvailable;
    data['isMandatoryUpdate'] = this.isMandatoryUpdate;
    return data;
  }
}
