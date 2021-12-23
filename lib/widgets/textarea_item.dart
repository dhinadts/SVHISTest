import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';

class TextAreaItem extends StatefulWidget {
  @override
  TextAreaItemState createState() => TextAreaItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final bool hideRulerLine;
  final FormFieldValidator<String> validator;

  TextAreaItem(this.name,
      {this.onChange,
      this.defValue,
      this.hideRulerLine: false,
      this.validator});
}

class TextAreaItemState extends State<TextAreaItem> {
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.centerLeft,
                child: Text(widget.name)),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            initialValue: widget.defValue,
            minLines: 3,
            maxLines: null,
            decoration: InputDecoration(
              labelText: "",
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            readOnly: widget.onChange == null ? true : false,
            onChanged: widget.onChange == null
                ? widget.onChange
                : _textAreaValueChanges,
            style: widget.onChange == null
                ? TextStyle(color: AppColors.warmGrey)
                : TextStyle(
                    fontFamily: "Poppins",
                  ),
            validator: widget.validator,
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
