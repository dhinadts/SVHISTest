import '../ui_utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplitTextItem extends StatefulWidget {
  @override
  SplitTextItemState createState() => SplitTextItemState();
  final String name;
  final ValueChanged<String> onChange;
  final String defValue;
  final String dataType;
  final int maxLines;
  final int maxCount;
  final bool hideRulerLine;
  final bool hideCounterText;
  final bool isCountShow;
  final bool isEnabled;
  final ValueChanged<String> validator;
  final ValueChanged<String> onSaved;
  final InputDecoration decoration;
  final TextEditingController controller;

  SplitTextItem(this.name,
      {this.onChange,
      this.defValue,
      this.dataType,
      this.maxLines,
      this.onSaved,
      this.hideRulerLine: false,
      this.maxCount: 1000,
      this.isCountShow: false,
      this.hideCounterText: false,
      this.isEnabled: true,
      this.decoration,
      this.controller,
      this.validator});
}

class SplitTextItemState extends State<SplitTextItem> {
  InputDecoration decoration;

  @override
  void initState() {
    if (widget.decoration != null) {
      decoration = widget.decoration;
    } else {
      if (widget.hideCounterText) {
        decoration = InputDecoration(
          // contentPadding: EdgeInsets.all(1),
          counterText: widget.isCountShow ? "" : null,
          labelText: "",
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      } else {
        decoration = InputDecoration(
          labelText: "",
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      }
    }

    super.initState();
  }

  void _textAreaValueChanges(String value) {
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      widget.name,
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(8),

                    child: TextFormField(
                      onFieldSubmitted: widget.onSaved,
                      onSaved: widget.onSaved,
                      onTap: () {
                        if (widget.onChange == null) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      controller: widget.controller,
                      keyboardType: widget.dataType != null &&
                              widget.dataType.trim() == "DOUBLE"
                          ? TextInputType.numberWithOptions(decimal: true)
                          : TextInputType.text,
                      initialValue: widget.defValue,
                      minLines: widget.maxLines,
                      maxLength: widget.maxCount,
                      maxLines: null,
                      inputFormatters: widget.dataType != null &&
                              widget.dataType.trim() == "DOUBLE"
                          ? [
                              //Allowed only One dot (.)
                              FilteringTextInputFormatter.deny(
                                  new RegExp('[\\-|\\ ]')),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*')),
                            ]
                          : [],
                      decoration: decoration,
                      readOnly: widget.onChange == null ? true : false,
                      onChanged: widget.onChange == null
                          ? widget.onChange
                          : _textAreaValueChanges,
                      style: widget.onChange == null
                          ? TextStyle(color: AppColors.warmGrey)
                          : TextStyle(
                              fontFamily: "Poppins",
                            ),
                      validator:
                          /*widget.dataType.trim() == "DOUBLE"
                          ? ValidationUtils.isValidDouble
                          :*/
                          widget.validator,
                    ),
                  ),
                ),
              ],
            ),
            if (!widget.hideRulerLine)
              Container(
                width: double.infinity,
                height: 5,
                color: AppColors.borderShadow,
              ),
          ],
        ));
  }
}
