import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class ToggleItem extends StatefulWidget {
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final List<String> possibleValues;

  ToggleItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.possibleValues});

  @override
  _ToggleItemState createState() => _ToggleItemState();
}

class _ToggleItemState extends State<ToggleItem> {
  String _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.defValue != null ? widget.defValue : "";
  }

  void _switchValueChanges(bool value) {
    setState(() {
      if (value) {
        _switchValue = widget.possibleValues[0];
      } else {
        _switchValue = widget.possibleValues[1];
      }
      widget.onChange(_switchValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Container(
                child: Switch(
                  value:
                      _switchValue == widget.possibleValues[0] ? true : false,
                  onChanged: widget.onChange == null
                      ? widget.onChange
                      : _switchValueChanges,
                  activeColor: Colors.green,
                ),
              ),
            ],
          ),
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
