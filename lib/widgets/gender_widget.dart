import '../ui/tabs/app_localizations.dart';
import '../ui_utils/text_styles.dart';
import 'package:flutter/material.dart';

class GenderWidget extends StatefulWidget {
  final TextEditingController genderController;

  GenderWidget({this.genderController});

  @override
  GenderWidgetState createState() => GenderWidgetState();
}

class GenderWidgetState extends State<GenderWidget> {
  String _genderValue = "Male";
  String choice;

  // .subtract(Duration(days:

  @override
  void initState() {
    widget.genderController.text = _genderValue;
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
                          AppLocalizations.of(context).translate("key_gender"),
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
                              value: 'Male',
                              groupValue: _genderValue,
                              onChanged: _radioValueChanges,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("key_male"),
                              style: TextStyles.mlDynamicTextStyle,
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: 'Female',
                              groupValue: _genderValue,
                              onChanged: _radioValueChanges,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("key_female"),
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
                              onChanged: _radioValueChanges,
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
        case 'Male':
          choice = value;
//widget.onChange(true);
          break;
        case 'Female':
          choice = value;
// widget.onChange(false);
          break;
        default:
          choice = null;
      }
      widget.genderController.text = choice;
      debugPrint(choice); //Debug the choice in console
    });
  }
}
