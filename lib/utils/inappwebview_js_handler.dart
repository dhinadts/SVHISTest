import '../ui/events/event_details.dart';
import '../ui/events/user_event.dart';
import 'package:flutter/material.dart';
import '../ui/donation/donation_screen.dart';
import '../ui/events/event_details.dart';
import '../ui/log_reports/details_screen.dart';
import '../ui/events/user_event.dart';
import '../ui/donation/donation_list_screen.dart';
import '../ui/check_in_screen.dart';
import '../model/check_in_dynamic.dart';
import '../ui/tabs/user_info_tab_inapp_webview.dart';
import 'app_preferences.dart';
import '../utils/alert_utils.dart';
import '../ui/test_inappwebview/sample_inappwebview_alert.dart';
import '../ui/homeNewsFeed.dart';
import '../ui/custom_drawer/remainders_list_data.dart';
import '../repo/common_repository.dart';

void handleJavascriptEvents({
  @required BuildContext context,
  @required Map<String, dynamic> handlerData,
}) async {
  String pageRoute = handlerData['route'];
  Map<String, dynamic> args = handlerData['args'];
  switch (pageRoute) {
    case "EVENT":
      UserEvent userEvent = UserEvent();
      userEvent.eventName = args["eventName"];

      userEvent.eventDepartmentName = "GNAT";
      userEvent.sessionName = "DUMMY_SESSION";
      userEvent.registrationType = "Entire Event";
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventDetails(event: userEvent),
        ),
      );
      break;
    case "LOGBOOK":
      CheckInDynamic model;
      try {
        model = CheckInDynamic.fromJson(args);
      } catch (e) {
        print(e);
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckInScreen(
            true,
            userFullName: model.userName,
            checkInDynamic: model,
            username: model.userName,
            departmentName: model.departmentName,
          ),
        ),
      );
      break;
    case "PROFILE":
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserInfoTabInappWebview(
            userName: AppPreferences().username,
            clientId: AppPreferences().clientId,
            departmentName: AppPreferences().deptmentName,
            title: "Profile",
          ),
        ),
      );
      break;
    case "DONATION":
      print(args.toString());
      Donation model;
      try {
        model = Donation.fromJson(args);
      } catch (e) {
        print(e);
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DonationScreen(
            title: "Donation",
            dObj: model,
            callbackForDonationUpdate: (isDonationUpdated) {},
          ),
        ),
      );
      break;
    case 'FLASH':
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => SampleInAppWebViewAlertBox(
                  link: args['link'],
                )),
      );
      break;
    case 'WISHES':
      var reminders = await wishes();
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => FlashCards(
                  remaindersListData: reminders,
                )),
      );
      break;
    default:
      break;
  }
}

Future<List<RemaindersListData>> wishes() async {
  debugPrint("WebserviceConstants.baseURL inside wishes");
  debugPrint(WebserviceConstants.baseURL);
  if (WebserviceConstants.baseURL != null) {
    var remaindersListData = await CommonRepository().getWishesList();
    return remaindersListData;
  }
}
