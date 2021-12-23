import '../ui/tabs/app_localizations.dart';
import '../ui_utils/icon_utils.dart';
import '../ui_utils/text_styles.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AgeWidget extends StatefulWidget {
  final TextEditingController dateController;
  final TextEditingController ageController;
  final InputDecoration inputAgeDecoration;
  final InputDecoration inputDateDecoration;

  AgeWidget(
      {this.dateController,
      this.ageController,
      this.inputAgeDecoration,
      this.inputDateDecoration});

  @override
  AgeWidgetState createState() => AgeWidgetState();
}

class AgeWidgetState extends State<AgeWidget> {
  double screenWidth;
  DateTime basicDate;

  @override
  void initState() {
    basicDate = DateTime.now().subtract(Duration(days: 5490));
    // print("BasicDate ${basicDate}");
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppPreferences().setGlobalContext(context);
    screenWidth = MediaQuery.of(context).size.width;
    return Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    AppLocalizations.of(context).translate("key_dob"),
                    style: TextStyles.mlDynamicTextStyle,
                  )),
                  Container(
                    width: screenWidth / 2.2,
                    padding: EdgeInsets.only(right: 0),
                    child: TextFormField(
                        style: TextStyles.mlDynamicTextStyle,
                        focusNode: null,
                        //validator: validateDOB,
                        readOnly: true,
                        controller: widget.dateController,
                        decoration: widget.inputDateDecoration.copyWith(
                            contentPadding: EdgeInsets.only(left: 20.0),
                            suffixIcon: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  openDateSelector();
                                },
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Colors.black87,
                                    )),
                              ),
                            )),
                        keyboardType: TextInputType.text,
                        validator: (args) {
                          if (args == null || args.isEmpty) {
                            return "Date of birth cannot be blank";
                          } else {
                            return null;
                          }
                        }),
                  ),
//Icon(Icons.calendar_today)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    AppLocalizations.of(context).translate("key_age"),
                    style: TextStyles.mlDynamicTextStyle,
                  )),
                  Container(
                      width: screenWidth / 2.2,
                      padding: EdgeInsets.only(right: 0),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          FocusScope(
                              node: null,
                              child: TextFormField(
                                style: TextStyles.mlDynamicTextStyle,
                                controller: widget.ageController,
                                readOnly: true,
                                enableInteractiveSelection: false,
                                decoration: widget.inputAgeDecoration,
                                keyboardType: TextInputType.number,
                                validator: (args) {
                                  if (args == null || args.isEmpty) {
                                    return "Age cannot be blank";
                                  } else {
                                    return null;
                                  }
                                },
                                /*style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                            ),*/
                              )),
                        ],
                      ))
//Icon(Icons.calendar_today)
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  openDateSelector() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now().subtract(Duration(days: 5490)),
        minTime: DateTime.now().subtract(Duration(days: 43830)),
        theme: WidgetStyles.datePickerTheme, onChanged: (date) {
      // print('change $date in time zone ' +
      // date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      // print('confirm $date');

      setState(() {
        widget.dateController.text =
            DateFormat(DateUtils.formatDOB).format(date.toLocal());
        widget.ageController.text = getUserAge(date).toString();
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    // locale:
    //     AppPreferences().isLanguageTamil() ? LocaleType.ta : LocaleType.en);
  }

  getUserAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
