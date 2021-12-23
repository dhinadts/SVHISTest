import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../ui_utils/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DatePickerItem extends StatefulWidget {
  @override
  DatePickerItemState createState() => DatePickerItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final ValueChanged<String> validator;

  DatePickerItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.validator});
}

class DatePickerItemState extends State<DatePickerItem> {
  @override
  void initState() {
    super.initState();
    if (widget.defValue != null && widget.defValue.isNotEmpty) {
      dateController.text = widget.defValue;
    }
  }

  void _datePickerValueChanges(String value) {
    widget.onChange(value);
  }

  TextEditingController dateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                      },
                      readOnly: true,
                      controller: dateController,
                      validator: widget.onChange == null
                          ? null
                          : (String value) {
                              if (value.trim().length == 0)
                                return "Date cannot be blank";
                              else
                                return null;
                            },
                      decoration: InputDecoration(
                        labelText: "Select date",
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
                            child: Icon(Icons.calendar_today)))
                  ],
                ))
            //Icon(Icons.calendar_today)
          ],
        ),
        if (!widget.hideRulerLine)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 15),
            height: 5,
            color: AppColors.borderShadow,
          ),
      ]),
    );
  }

  openDateSelector() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        theme: WidgetStyles.datePickerTheme, onConfirm: (date) {
      // print('confirm $date');
      setState(() {
        dateController.text =
            DateFormat(DateUtils.formatCheckIn).format(date.toLocal());
      });
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
