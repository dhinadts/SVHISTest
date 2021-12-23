import '../ui_utils/app_colors.dart';
import '../ui_utils/icon_utils.dart';
import '../ui_utils/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DropDownItem extends StatefulWidget {
  @override
  DropDownItemState createState() => DropDownItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final List<String> dropDownItems;
  final ValueChanged<String> validator;

  DropDownItem(this.name,
      {this.onChange,
      this.defValue,
      this.dropDownItems,
      this.hideRulerLine: false,
      this.validator});
}

class DropDownItemState extends State<DropDownItem> {
  @override
  void initState() {
    super.initState();
  }

  void _datePickerValueChanges(String value) {
    widget.onChange(value);
  }

  TextEditingController dateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 15, left: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(widget.name, style: TextStyle(fontSize: 16))),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(errorMaxLines: 2),
                      /* validator: (String value) {
                        if (widget.defValue == null) {
                          return AppLocalizations.of(context)
                              .translate("key_select_relation");
                        } else {
                          return null;
                        }
                      },*/
                      validator: widget.validator,
                      isExpanded: true,
                      iconSize: 30,
                      hint: Text(
                          widget.defValue == null || widget.defValue == ""
                              ? "Select"
                              : widget.defValue,
                          style: TextStyle(fontSize: 16)),
                      items: widget.dropDownItems.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child:
                              new Text(value, style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: widget.onChange),
                ),
              )
            ],
          ),
          if (!widget.hideRulerLine)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 15),
              height: 5,
              color: AppColors.borderShadow,
            ),
        ],
      ),
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
