import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class RadioButtonItem extends StatefulWidget {
  @override
  RadioButtonItemState createState() => RadioButtonItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final List<String> possibleValues;

  RadioButtonItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.possibleValues});
}

class RadioButtonItemState extends State<RadioButtonItem> {
  String _radioValue;
  String choice;

  void _radioValueChanges(String value) {
    setState(() {
      _radioValue = value;
      if (widget.possibleValues[0] == value) {
        choice = value;
        widget.onChange(value);
      } else if (widget.possibleValues[1] == value) {
        choice = value;
        widget.onChange(value);
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  @override
  void initState() {
    super.initState();
    _radioValue = widget.defValue != null ? widget.defValue : "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.name,
                  )),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: widget.possibleValues[0],
                  groupValue: _radioValue,
                  onChanged: widget.onChange == null
                      ? widget.onChange
                      : _radioValueChanges,
                ),
                Text(widget.possibleValues[0]),
                Radio(
                    value: widget.possibleValues[1],
                    groupValue: _radioValue,
                    onChanged: widget.onChange == null
                        ? widget.onChange
                        : _radioValueChanges),
                Text(widget.possibleValues[1]),
              ],
            ))
          ],
        ),
        if (!widget.hideRulerLine)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 5,
            color: AppColors.borderShadow,
          ),
      ],
    );
  }
}
