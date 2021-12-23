import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../model/drawer_item.dart';
import '../ui/splash_screen.dart';
import '../ui/tabs/AppLanguage.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/ui_dimens.dart';
import '../utils/alert_utils.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'custom_drawer/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  final String title;
  const SettingsScreen({Key key, this.title}) : super(key: key);
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  List<DrawerItem> drawerList = [];
  Future<File> profileImg;
  File profile;
  bool value = false;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      value = AppPreferences().language == "Tamil" ? true : false;
    });
  }

  var appLanguage;

  @override
  void didChangeDependencies() {
    _radioValue = AppPreferences().language;
    drawerList = [
      DrawerItem(
          title: AppLocalizations.of(context).translate("key_reset"),
          assetUrl: "assets/images/updatePassword.png",
          pageId: Constants.PAGE_ID_RESET_PASSWORD),
      DrawerItem(
          title: AppLocalizations.of(context).translate("key_wipe"),
          assetUrl: "assets/images/ic_wipe_data.png",
          pageId: Constants.PAGE_ID_WIPE_DATA),
      DrawerItem(
          title: AppLocalizations.of(context).translate("key_refreshEnv"),
          assetUrl: "assets/images/refresh.png",
          pageId: Constants.PAGE_ID_REFRESH_ENVIRINMENT),
      /* DrawerItem(
          title: AppLocalizations.of(context).translate("key_display_settings"),
          assetUrl: "assets/images/display.png",
          pageId: Constants.PAGE_ID_DISPLAY_SETTINGS),*/
    ];
    // AppPreferences.getRole().then((value) {
    //   if(value == "Supervisor"){
    //     setState(() {
    //       drawerList.add(DrawerItem(
    //           title: "HeathCare Devices",
    //           assetUrl: "assets/images/updatePassword.png",
    //           pageId: Constants.PAGE_ID_ADD_NEW_DEVICE));
    //     });
    //   }
    // });
    if (Constants.LANGUAGE_ENABLED) {
      drawerList.add(DrawerItem(
          title: AppLocalizations.of(context).translate("key_select_language"),
          assetUrl: "assets/images/logout.png"));
    } else {}

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguage>(context);
    return Stack(
      children: [
        Scaffold(
            appBar: CustomAppBar(
                title: AppLocalizations.of(context).translate("key_setting"),
                pageId: Constants.PAGE_ID_SETTINGS),
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                if (false)
                  Stack(
                    children: <Widget>[
                      if (profileImg == null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80.0),
                          child: Image.asset(
                            "assets/images/userInfo.png",
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                      if (profileImg != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80.0),
                          child: Image.file(
                            profile,
                            height: 100.0,
                            width: 100.0,
                          ),
                        ),
                      Positioned(
                          bottom: 10,
                          //left: 10,
                          right: 0,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(80.0),
                              child: InkWell(
                                onTap: () {
                                  profileImg = ImagePicker.pickImage(
                                          source: ImageSource.gallery)
                                      .whenComplete(() {
                                    profileImg.then((onValue) {
                                      setState(() {
                                        profile = onValue;
                                      });
                                    });
                                  });
                                },
                                child: Container(
                                    color: AppColors.accentColor,
                                    height: 35.0,
                                    width: 35.0,
                                    child: Icon(
                                      Icons.edit,
                                    )),
                              )))
                    ],
                  ),
                SizedBox(
                  height: 25,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: drawerList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        buildListTitle(drawerList[index], index, context),
                        if (drawerList[index].title ==
                            AppLocalizations.of(context)
                                .translate("key_select_language"))
                          Padding(
                              padding: EdgeInsets.only(
                                  left: AppUIDimens.paddingXXXXXLarge),
                              child: Column(
                                children: <Widget>[
                                  languageWidget(Constants.ENGLISH_KEY),
                                  languageWidget(Constants.TAMIL_KEY),
                                  languageWidget(Constants.HINDI_KEY),
                                  //languageWidget(Constants.TELUGU_KEY),
                                ],
                              )),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          height: 5,
                          color: AppColors.borderShadow,
                        ),
                      ],
                    );
                  },
                ),
                /* Expanded(
                  child: SampleInAppWebView(
                    showFlashView: () {
                      setState(() {
                        //showFlashView = true;
                        showDialogView(context);
                      });
                    },
                  ),
                ),*/
              ],
            )),
      ],
    );
  }

  String _radioValue = "No";
  String choice;

  void _radioValueChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case Constants.TAMIL_KEY:
          choice = value;
          _radioValue = value;
          break;
        case Constants.ENGLISH_KEY:
          choice = value;
          _radioValue = value;
          break;
        case Constants.HINDI_KEY:
          choice = value;
          _radioValue = value;
          break;
        case Constants.TELUGU_KEY:
          choice = value;
          _radioValue = value;
          break;
        default:
          choice = null;
      }
      onChangedLanguage(value);
      // debugPrint(choice); //Debug the choice in console
    });
  }

  onChangedLanguage(String key) async {
    if (key == "English") {
      // print("English selected");
      appLanguage.changeLanguage(Locale("en"));
    } else if (key == "Tamil") {
      // print("Tamil selected");
      appLanguage.changeLanguage(Locale("ta"));
    } else if (key == "Hindi") {
      // print("Hindi selected");
      appLanguage.changeLanguage(Locale("hi"));
    } else if (key == "Telugu") {
      // print("Telugu selected");
      appLanguage.changeLanguage(Locale("te"));
    }
    await AppPreferences.setLanguage(key);
  }

  Widget languageWidget(String key) {
    String shownText = key;
    if (key == "Tamil") {
      shownText = "தமிழ்";
    } else if (key == "Hindi") {
      shownText = "हिन्दी";
    } else if (key == "Telugu") {
      shownText = "తెలుగు";
    }
    return InkWell(
        onTap: () {
          _radioValueChanges(key);
        },
        child: Row(
          children: <Widget>[
            Radio(
              value: key,
              groupValue: _radioValue,
              onChanged: _radioValueChanges,
            ),
            Text(shownText),
          ],
        ));
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    // print("version = $version");
    await AppPreferences.setVersion(version);
  }

  Container buildListTitle(
      DrawerItem drawerItem, int index, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppUIDimens.paddingMedium),
      //color: Colors.grey,
      child: ListTile(
        leading: SizedBox(
            height: 30.0,
            width: 30.0, // fixed width and height
            child: drawerItem.title ==
                    AppLocalizations.of(context)
                        .translate("key_select_language")
                ? Icon(Icons.language)
                : Image.asset(drawerItem.assetUrl)),
        title: Text(drawerItem.title,
            style: AppPreferences().isLanguageTamil()
                ? TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)
                : TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        subtitle: drawerItem.title ==
                AppLocalizations.of(context).translate("key_wipe")
            ? Text(
                "Reset App Data helps you to delete the existing promo code entered and enter a new promo code",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w400))
            : Container(),
        onTap: () async {
          if (drawerItem.pageId == Constants.PAGE_ID_RESET_PASSWORD) {
            Navigator.pushNamed(context, Routes.resetPasswordScreen);
          } else if (drawerItem.pageId == Constants.PAGE_ID_WIPE_DATA) {
            String name = AppPreferences().fullName;
            AlertUtils.commonAlertWidget(context,
                title: "Confirm Reset App Data",
                body: "Are you sure to reset your application data?",
                onPositivePress: () async {
              await AppPreferences.logoutClearPreferences();
              getVersion();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  ModalRoute.withName(Routes.splashScreen));
              Fluttertoast.showToast(
                  msg: "App data has been reset successfully!",
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_LONG);
            }, onNegativePress: () {
              Navigator.pop(context);
            });
          } else if (drawerItem.title ==
              AppLocalizations.of(context).translate("key_logout")) {
            String name = AppPreferences().fullName;
            AlertUtils.logoutAlert(context, name);
          } else if (drawerItem.title ==
              AppLocalizations.of(context).translate("key_refreshEnv")) {
            AlertUtils.refreshEnvAlert(context, "Environment Property");
          } else if (drawerItem.pageId == Constants.PAGE_ID_ADD_NEW_DEVICE) {
            Navigator.pushNamed(context, Routes.healthcareDevicesScreen);
          }
          /* else if (drawerItem.title ==
              AppLocalizations.of(context).translate("key_display_settings")) {
            Navigator.pushNamed(context, Routes.display_settings);
          }*/
        },
      ),
    );
  }
}
