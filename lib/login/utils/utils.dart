import '../../utils/app_preferences.dart';
import '../colors/color_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class Utils {
  static String convertDateFormat(date) {
    if (date != null && date != "" && date != "null" && date != "0000-00-00") {
      try {
        return date = new DateFormat("MM-dd-yyyy").format(DateTime.parse(date));
      } catch (e) {
        return date;
      }
    } else
      return date;
  }

  static String convertDateFormat2(date) {
    if (date != null && date != "" && date != "null" && date != "0000-00-00") {
      try {
        return date =
            new DateFormat.yMMMMd("en_US").format(DateTime.parse(date));
      } catch (e) {
        return date;
      }
    } else
      return date;
  }

  static String converttoYYYYMMDD(date) {
    if (date != null && date != "" && date != "null" && date != "0000-00-00") {
      try {
        date = date.toString().replaceAll("-", "/");
        var newDateTimeObj = new DateFormat().add_yMd().parse(date);

        return date = new DateFormat("MM/YY").format(newDateTimeObj);
      } catch (e) {
        return date;
      }
    } else
      return date;
  }

  static Material getRoundedButton(
      BuildContext context, String text, double fontSize) {
    TextStyle style = TextStyle(fontSize: 14.0, color: Colors.white);
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(ColorInfo.SIGNUP_BUTTON_BG_COLOR),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        child: Text(text,
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white, fontSize: fontSize)),
      ),
    );
  }

  static Material getRoundedButtonGrayColor(BuildContext context, String text) {
    TextStyle style = TextStyle(fontSize: 14.0, color: Colors.white);
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(ColorInfo.DARK_GRAY2),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        child: Text(text,
            textAlign: TextAlign.center,
            style: style.copyWith(color: Colors.white, fontSize: 12.0)),
      ),
    );
  }

  static var hintStyleBlack = TextStyle(fontSize: 14.0, color: Colors.black45);

  static var hintStyleWhite = TextStyle(
      fontSize: 14.0, color: new Color(ColorInfo.APP_GRAY).withOpacity(0.5));

  static Future customAlertDialog(
      BuildContext context, String message, bool isNeedToFinish) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${AppPreferences().appName}",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: message,
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static toasterMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP);
  }

  static String getDateDifference(String dob) {
    // print("-----------" + dob);
    try {
      List date = dob.split("-");

      final birthday =
          DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
      final date2 = DateTime.now();
      final difference = date2.difference(birthday).inDays;

      int dobYr = (difference / 365).round();

      return dobYr.toString() + " Yr";
    } catch (error) {
      try {
        List date = dob.split(" ");
        String difference =
            date[0] + " " + date[1] + " " + date[2] + " " + date[3];
        return difference.toString();
      } catch (error) {
        return "NA";
      }
    }
  }
}

class ConversionUtils {
  ConversionUtils._();

  static String inchesToCentimeters(String height) {
    return (double.parse(height) * 2.54).round().toStringAsFixed(2);
  }

  static String centimetersToInches(String height) {
    // print("INCHES ${(double.parse(height) / 2.54).toString()}");
    return (double.parse(height) / 2.54).round().toStringAsFixed(2);
  }

  static String kgsToPounds(String weight) {
    return (double.parse(weight) * 2.20462).round().toStringAsFixed(2);
  }

  static String poundsToKgs(String weight) {
    return (double.parse(weight) / 2.20462).round().toStringAsFixed(2);
  }

  static String parseHtmlString(String string) {
    if (string.contains("<html>")) {
      var document = parse(string);

      String parsedString = parse(document.body.text).documentElement.text;

      return parsedString;
    } else {
      return string;
    }
  }
}
