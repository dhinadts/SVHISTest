import '../login/utils/custom_progress_dialog.dart';
import '../login/utils/utils.dart';
import '../model/notice_board_response.dart';
import '../repo/app_env_props_rep.dart';
import '../ui/custom_drawer/navigation_home_screen.dart';
import '../ui/settings_screen.dart';
import '../ui/splash_screen.dart';
import '../ui/tabs/app_localizations.dart';
import '../ui_utils/app_colors.dart';
import '../ui_utils/text_styles.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';

class AlertUtils {
  AlertUtils._();

  static showAlertDialog(BuildContext context, String msg,
      {ValueChanged onChange}) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
      title: Text(
          (AppPreferences().appName == null || AppPreferences().appName.isEmpty)
              ? 'Memberly'
              : AppPreferences().appName),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showAlertNotificationDialog(BuildContext context,
      NewNotification notification, ValueChanged<String> onClick) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        title: Container(
          // color: Colors.pink,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: 250,
                    height: 44,
                    child: Center(
                      child: Text(
                        notification.groupName ??
                            notification.contactName ??
                            notification.userName,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.blueAccent)),
                padding:
                    EdgeInsets.only(top: 0, right: 2, left: 10, bottom: 10),
                // ,
                child: Scrollbar(
                    child: SingleChildScrollView(
                  child: Text(
                      ConversionUtils.parseHtmlString(notification.message)),
                ))),
//    )
//            SizedBox(height: 10,),
            if (notification?.messageStatus != null &&
                notification.messageStatus.trim() == "Change")
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          onTap: () {
                            onClick("NotAcknowledged");
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Not Acknowledge",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor),
                              )))),
                  Center(
                      child: GestureDetector(
                          onTap: () {
                            onClick("Acknowledged");
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text("Acknowledge",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor))))),
                ],
              )
          ],
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100.0), child: alert);
      },
    );
  }

  static String text = "Disclaimer\n" +
      "The information provided by “SiviSoft Inc” on our mobile application is for general informational purposes only.\n All information on our mobile application is provided in good faith, however we make no representation or warranty of any kind, express or implied, regarding the accuracy, adequacy, validity, reliability, availability or completeness of any information on our mobile application.\n" +
      "Under no circumstance shall we have any liability to you for any loss or damage of any kind incurred as a result of the use of our mobile application or reliance on any information provided on our mobile application.\n Your use of our mobile application and your reliance on any information on our mobile application is solely at your own risk. This application is not substitute for medical advice.\n User of this application should consult their healthcare professional before making any health medicine or other decision based on the data contained herein.\n This disclaimer was created using “SiviSoft Inc” organization.";

  static showTermsAndConditionDialog(BuildContext context, String content,
      ValueChanged<bool> onChanged, double height) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate("key_condition"),
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Container(
            height: (height + 90),
            child: Column(
              children: <Widget>[
                Container(
                    height: height,
                    /*margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),*/
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.blueAccent)),
                    child: Scrollbar(
                        child: SingleChildScrollView(
                            reverse: false,
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    content,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: Constants.LatoRegular),
                                  ),
                                )
                              ],
                            )))),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SubmitButton(
                      roundedSide: "left",
                      text:
                          AppLocalizations.of(context).translate("key_decline"),
                      onPress: () {
                        onChanged(false);
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    SubmitButton(
                      text:
                          AppLocalizations.of(context).translate("key_accept"),
                      onPress: () {
                        onChanged(true);
                      },
                    ),
                  ],
                )
              ],
            )));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static logoutAlert(BuildContext context, String name) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate("key_signout"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: () async {
        await AppPreferences.logoutClearPreferences(isWipeCall: false);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            ModalRoute.withName(Routes.splashScreen));
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate("key_successfully"),
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate("key_cancel"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    var fname = "";
    var lname = "";
    if (name.split(', ').length > 1) {
      fname = name.split(', ')[1];
      lname = name.split(', ')[0];
    } else {
      fname = name;
    }

    String clientID = AppPreferences().clientId == 'GNAT' ? 'GNAT' : 'Memberly';
    // print(AppPreferences().appName);
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate("key_confirmsignout"),
        maxLines: 2,
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyleBold
            : TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
      content: Text(
        "${fname + ' ' + lname}, ${AppLocalizations.of(context).translate("key_confirmsignouttext")}"
            .replaceFirst("CLIEN_ID", clientID),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static commonAlertWidget(BuildContext context,
      {String title,
      String body,
      VoidCallback onPositivePress,
      VoidCallback onNegativePress}) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate("key_yes"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: onPositivePress,
    );
    Widget cancelButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate("key_no"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: onNegativePress,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title ?? AppLocalizations.of(context).translate("key_exit_conf"),
        maxLines: 2,
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyleBold
            : TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
      content: Text(
        body ?? AppLocalizations.of(context).translate("key_exit_conf_txt"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static refreshEnvAlert(BuildContext context, String name) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate("key_refresh"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: () async {
        CustomProgressLoader.showLoader(context);
        //await setEnvProps();
        await AppEnvPropRepo.fetchEnvProps();
        CustomProgressLoader.cancelLoader(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg:
                AppLocalizations.of(context).translate("key_refreshsuccessful"),
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
        showMenuGridScreen = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
            ModalRoute.withName(Routes.dashBoard));
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate("key_cancel"),
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate("key_refreshEnv"),
        maxLines: 2,
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyleBold
            : TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
      /* content: Text(
        "$name",
        style: AppPreferences().isLanguageTamil()
            ? TextStyles.tamilStyle
            : TextStyle(fontSize: 15),
      ), */
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showAppUpdateALert(BuildContext context, Version versionObj) {
// set up the button
    Widget okButton = FlatButton(
      child: Text(
        'Update',
        style: TextStyle(fontSize: 15),
      ),
      onPressed: () async {
        if (await canLaunch(versionObj.downloadUrl)) {
          await launch(versionObj.downloadUrl);
        } else {
          debugPrint('Could not launch $versionObj.targetUrl');
        }
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        'Skip',
        style: TextStyle(fontSize: 15),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    print("i Mandetory Update ${versionObj.isMandatoryUpdate}");
// set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        Constants.APP_SCOPE,
        maxLines: 2,
        style: TextStyle(fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
      content: Text(
        versionObj.message,
        style: TextStyle(fontSize: 15),
      ),
      actions: [
        okButton,
        if (versionObj.isMandatoryUpdate) Container() else cancelButton,
      ],
    );

// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
