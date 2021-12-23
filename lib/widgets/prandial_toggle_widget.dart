import '../ui_utils/icon_utils.dart';
import 'package:flutter/material.dart';

class PrandialToggleItem extends StatefulWidget {
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final List<String> possibleValues;

  PrandialToggleItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.possibleValues});

  @override
  _PrandialToggleItemState createState() => _PrandialToggleItemState();
}

class _PrandialToggleItemState extends State<PrandialToggleItem> {
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
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: ColorUtils.brighten(Colors.grey[600], 80)),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0) //         <--- border radius here
                  ),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ColorUtils.brighten(Colors.grey[600], 80),
                    ColorUtils.brighten(ColorUtils.hexToColor("#F1F1F1"), 50)
                  ])),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: RichText(
          text: TextSpan(
              text: widget.name,
              style: TextStyle(fontSize: 13,color: Colors.black54),
              children: <TextSpan>[
                TextSpan(text: _switchValue == widget.possibleValues[0] ? " YES" : " NO",
                    style: TextStyle(
                        color: _switchValue == widget.possibleValues[0] ? Colors.green : Colors.red, fontSize: 15,fontWeight: FontWeight.w700),
                )
              ]
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
                  /*inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,*/
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
