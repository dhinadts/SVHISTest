import '../ui_utils/app_colors.dart';
import '../widgets/mode_tag.dart';
import '../widgets/status_tag.dart';
import 'package:flutter/material.dart';

class TextItemOption extends StatefulWidget {
  @override
  TextItemOptionState createState() => TextItemOptionState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final ValueChanged<String> validator;

  TextItemOption(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.validator});
}

class TextItemOptionState extends State<TextItemOption> {
  @override
  void initState() {
    super.initState();
  }

  void _textAreaValueChanges(String value) {
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 2.4,
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 25),
                //alignment: Alignment.centerLeft,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Text(
                        widget.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                      Text(":")
                    ])),
            if (widget.name != "Transaction Status" &&
                widget.name != "Transaction Mode")
              Container(
                width: MediaQuery.of(context).size.width / 2.1,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text(
                  widget.defValue,
                  maxLines: 3,
                ),
              ),
            if (widget.name == "Transaction Status") StatusTag(widget.defValue),
            if (widget.name == "Transaction Mode") ModeTag(widget.defValue)
          ],
        ),
        if (!widget.hideRulerLine)
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.borderLine,
          ),
        if (!widget.hideRulerLine)
          Container(
            width: double.infinity,
            height: 3,
            color: AppColors.borderShadow,
          ),
      ],
    );
  }
}
