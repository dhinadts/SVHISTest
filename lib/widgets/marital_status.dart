import '../ui_utils/text_styles.dart';
import 'package:flutter/material.dart';

class MaritalStatusWidget extends StatefulWidget {
  final TextEditingController maritalStatusController;
  final String defValue;
  final bool readOnly;

  MaritalStatusWidget(
      {this.maritalStatusController, this.defValue, this.readOnly: false});

  @override
  MaritalStatusWidgetState createState() => MaritalStatusWidgetState();
}

class MaritalStatusWidgetState extends State<MaritalStatusWidget> {
  String _genderValue = "Single";
  String choice;

  @override
  void initState() {
    if (widget.defValue != null && widget.defValue.isNotEmpty) {
      widget.maritalStatusController.text = widget.defValue ?? _genderValue;
      _genderValue = widget.defValue;
      setState(() {});
    } else {
      widget.maritalStatusController.text = _genderValue;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(7),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width / 3,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Marital Status",
                          style: TextStyles.mlDynamicTextStyle,
                          maxLines: 2,
                        )),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    runSpacing: -15.0,
                    children: [
                      IntrinsicWidth(
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: 'Single',
                              groupValue: _genderValue,
                              onChanged:
                                  widget.readOnly ? null : _radioValueChanges,
                            ),
                            Text(
                              'Single',
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: 'Married',
                              groupValue: _genderValue,
                              onChanged:
                                  widget.readOnly ? null : _radioValueChanges,
                            ),
                            Text(
                              'Married',
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: 'Divorced',
                              groupValue: _genderValue,
                              onChanged:
                                  widget.readOnly ? null : _radioValueChanges,
                            ),
                            Text(
                              'Divorced',
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: 'Not to Disclose',
                              groupValue: _genderValue,
                              onChanged:
                                  widget.readOnly ? null : _radioValueChanges,
                            ),
                            Text(
                              'Not to Disclose',
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  void _radioValueChanges(String value) {
    setState(() {
      _genderValue = value;
      switch (value) {
        case 'Single':
          choice = value;
//widget.onChange(true);
          break;
        case 'Married':
          choice = value;
// widget.onChange(false);
          break;
        case 'Divorced':
          choice = value;
// widget.onChange(false);
          break;
        case 'Not to Disclose':
          choice = value;
// widget.onChange(false);
          break;
        default:
          choice = null;
      }
      widget.maritalStatusController.text = choice;
      debugPrint(choice); //Debug the choice in console
    });
  }
}
