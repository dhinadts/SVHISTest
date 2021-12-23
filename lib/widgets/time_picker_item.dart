import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../ui_utils/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TimePickerItem extends StatefulWidget {
  @override
  TimePickerItemState createState() => TimePickerItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final ValueChanged<String> validator;

  TimePickerItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.validator});
}

class TimePickerItemState extends State<TimePickerItem> {
  @override
  void initState() {
    super.initState();
    if (widget.defValue != null && widget.defValue.isNotEmpty) {
      timeController.text = widget.defValue;
    }
  }

  void _datePickerValueChanges(String value) {
    widget.onChange(value);
  }

  TextEditingController timeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text(widget.name)),
            Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.only(right: 0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    TextFormField(
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (widget.onChange != null) openDateSelector();
                      },
                      readOnly: true,
                      controller: timeController,
                      validator: widget.onChange == null
                          ? null
                          : (String value) {
                              if (value.trim().length == 0)
                                return "${widget.name} cannot be blank";
                              else
                                return null;
                            },
                      decoration: InputDecoration(
                        labelText: "Select time",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        //fillColor: Colors.green
                      ),
                      keyboardType: TextInputType.text,
                      style: widget.onChange == null
                          ? TextStyle(color: AppColors.warmGrey)
                          : TextStyle(
                              fontFamily: "Poppins",
                            ),
                    ),
                    GestureDetector(
                        onTap: () =>
                            {if (widget.onChange != null) openDateSelector()},
                        child: Container(
                            padding: EdgeInsets.only(right: 5),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.timer)))
                  ],
                ))
            //Icon(Icons.calendar_today)
          ],
        ),
        if (!widget.hideRulerLine)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            height: 5,
            color: AppColors.borderShadow,
          ),
      ]),
    );
  }

  openDateSelector() {
    DatePicker.showTime12hPicker(context,
        showTitleActions: true,
        //minTime: DateTime.now(),
        theme: WidgetStyles.datePickerTheme, onConfirm: (date) {
      // print('confirm $date');

      timeController.text =
          DateFormat(DateUtils.timeFormatWithAmPm).format(date.toLocal());
      widget.onChange(timeController.text);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
