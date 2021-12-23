import '../utils/app_preferences.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_colors.dart';

class IconUtils {
  IconUtils._();

  static const _packagePrefix = 'assets/icons';
  static const backgroundImg = '$_packagePrefix/background_img.png';
  static const logo = '$_packagePrefix/ic_logo.png';
}

class ColorUtils {
  ColorUtils._();
  static applyTheme() {
    if (AppPreferences().environmentCode == Constants.TT_ENV_CODE) {
      AppColors.primaryColor =
          AppColors.primaryColorDark; // AppColors.dattPrimaryColor;
    }
  }

  static Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  static Color brighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }

  static Color hexToColor(String hexColor) {
    if (hexColor == null) {
      return Colors.blueAccent;
    }
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class DateUtils {
  DateUtils._();
  static String defaultDateFormat = AppPreferences().defaultDateFormat == null
      ? 'MM/dd/yyyy'
      : AppPreferences().defaultDateFormat;
  static String defaultTimeFormat =
      AppPreferences().timeformat ? "HH:mm:ss" : "hh:mm:ss";
  static String defaultTimeFormatOnlyHoursAndMinutes =
      AppPreferences().timeformat ? "HH:mm" : "hh:mm";
  static String formatCheckIn = '$defaultDateFormat';
  static String formatDATTDob = '$defaultDateFormat';
  static String formatDOB = 'dd/MM/yyyy';
  static String transactionDateConversion = 'EEE, MMM dd, yyyy';
  static String dateAndTimeFormat = 'MM/dd/yyyy $defaultTimeFormat';
  static String istDateAndTimeFormat = '$defaultDateFormat $defaultTimeFormat';
  static String dateAndTimeFormatCheckIn = 'MM/dd/yyyy\n$defaultTimeFormat';
  static String dateAndTimeFormatApprovedDate = 'MM/dd/yyyy $defaultTimeFormat';
  static String dateAndTimeFormatCheckInList =
      'MM/dd/yyyy $defaultTimeFormatOnlyHoursAndMinutes';
  static String dateAndTimeFormatCheckInSubmit =
      'yyyy-MM-dd $defaultTimeFormat';
  static String timeFormat = '$defaultTimeFormat';
  static String serverMonth = 'MMM';
  static String dateAndTimeFormatSymptomsSubmit =
      'yyyy-MM-dd $defaultTimeFormatOnlyHoursAndMinutes';
  static String serverDate = 'dd';
  static String timeFormatWithAmPm = '$defaultTimeFormatOnlyHoursAndMinutes a';
  static String membershipDateFormat = 'dd MMM yyyy';
  static String istDateAndTimeFormat1 =
      '$defaultDateFormat $defaultTimeFormatOnlyHoursAndMinutes a';

  static init() {
    defaultDateFormat = AppPreferences().defaultDateFormat == null
        ? 'MM/dd/yyyy'
        : AppPreferences().defaultDateFormat;
    defaultTimeFormat = AppPreferences().timeformat ? "HH:mm:ss" : "hh:mm:ss";
    defaultTimeFormatOnlyHoursAndMinutes =
        AppPreferences().timeformat ? "HH:mm" : "hh:mm";

    formatCheckIn = '$defaultDateFormat';
    formatDATTDob = '$defaultDateFormat';
    formatDOB = 'dd/MM/yyyy';
    transactionDateConversion = 'EEE, MMM dd, yyyy';
    dateAndTimeFormat = 'MM/dd/yyyy $defaultTimeFormat';
    istDateAndTimeFormat = '$defaultDateFormat $defaultTimeFormat';
    dateAndTimeFormatCheckIn = 'MM/dd/yyyy\n$defaultTimeFormat';
    dateAndTimeFormatApprovedDate =
        'MM/dd/yyyy $defaultTimeFormatOnlyHoursAndMinutes a';
    dateAndTimeFormatCheckInList =
        'MM/dd/yyyy $defaultTimeFormatOnlyHoursAndMinutes';
    dateAndTimeFormatCheckInSubmit =
        'yyyy-MM-dd $defaultTimeFormatOnlyHoursAndMinutes';
    timeFormat = 'HH:mm';
    serverMonth = 'MMM';
    dateAndTimeFormatSymptomsSubmit = 'yyyy-MM-dd $defaultTimeFormat';
    serverDate = 'dd';
    timeFormatWithAmPm = '$defaultTimeFormatOnlyHoursAndMinutes a';
    membershipDateFormat = 'dd MMM yyyy';
    istDateAndTimeFormat1 =
      '$defaultDateFormat  ${AppPreferences().timeformat ? '$defaultTimeFormat':'$defaultTimeFormatOnlyHoursAndMinutes a'}';
  }

  static String convertUTCToLocalTime(String serverTime) {
    init();
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat(dateAndTimeFormatCheckInSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);

    var dateLocal = dateTime.toLocal();
    var finalString = DateFormat(istDateAndTimeFormat1)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    return finalString.toString();
  }

  static String convertUTCToLocalTimeCheckIn(String serverTime) {
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat(dateAndTimeFormatCheckInSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();
    var finalString = DateFormat(dateAndTimeFormat)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    return finalString.toString();
  }

  static String convertUTCToLocalDate(String serverTime) {
    var dateTimeArray = serverTime.split("T");

    var dateTime = DateFormat(dateAndTimeFormatCheckInSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();

    var finalString = DateFormat(transactionDateConversion)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));

    return finalString.toString();
  }

  static String convertUTCToLocalMembershipFormatDate(String serverTime) {
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat(dateAndTimeFormatSymptomsSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();
    var finalString = DateFormat(membershipDateFormat)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    return finalString.toString();
  }

  static String convertUTCToLocalTimeToDate(String serverTime) {
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat(dateAndTimeFormatCheckInSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();
    var finalString = DateFormat(dateAndTimeFormat)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    return finalString.toString().split(" ")[0];
  }

  static String convertUTCToLocalTimeApprovedDate(String serverTime) {
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat(dateAndTimeFormatCheckInSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();
    var finalString = DateFormat(dateAndTimeFormatApprovedDate)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    return finalString.toString();
  }

  static String convertUTCToLocalTimeRecent(String serverTime) {
    var dateTime =
        DateFormat(dateAndTimeFormatCheckInSubmit).parse(serverTime, true);
//    print("Server time $serverTime");
    var dateLocal = dateTime.toLocal();
//    print("dateLocal time $dateLocal");
    var finalString = DateFormat(dateAndTimeFormat)
        .format(DateTime.parse(dateLocal.toString().replaceFirst(".000", "")));
    return finalString;
  }

  static DateTime getDateTimeFromISOString(String serverTime) {
    print(serverTime);
    var dateTimeArray = serverTime.split("T");
    var dateTime = DateFormat(dateAndTimeFormatCheckInSubmit)
        .parse(dateTimeArray[0] + " " + dateTimeArray[1], true);
    var dateLocal = dateTime.toLocal();
    return DateTime.parse(dateLocal.toString().replaceFirst(".000", ""));
  }

  static String convertUTCToSpecificFormat(String serverTime, String format) {
    var strToDateTime = DateTime.parse(serverTime);
    final convertLocal = strToDateTime.toLocal();
    var newFormat = DateFormat(format);
    return newFormat.format(convertLocal);
  }
}
