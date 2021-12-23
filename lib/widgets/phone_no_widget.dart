import '../country_picker_util/country_code_picker.dart';
import '../ui_utils/text_styles.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNoWidget extends StatelessWidget {
  final bool codeReadOnly;
  final bool numberReadOnly;
  final bool mandatory;
  final String countryCode;
  final String country;
  final String hint;
  final EdgeInsets contentPadding;
  final TextEditingController phoneController;
  final ValueChanged<CountryCode> onChanged;
  final ValueChanged<CountryCode> onInitCallback;
  final TextStyle style;
  final InputDecoration inputDecorationCountry, inputDecorationPhone;

  PhoneNoWidget(
      {this.codeReadOnly: false,
      this.phoneController,
      this.onChanged,
      this.style,
      this.mandatory: true,
      this.hint: "Phone",
      this.contentPadding,
      this.inputDecorationCountry,
      this.numberReadOnly: false,
      this.inputDecorationPhone,
      this.countryCode,
      this.onInitCallback,
      this.country});

  /*@override
  PhoneNoWidgetState createState() => new PhoneNoWidgetState();
}

class PhoneNoWidgetState extends State<PhoneNoWidget> {*/
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
//            width: 250,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              TextFormField(
                readOnly: true,
                style: numberReadOnly
                    ? TextStyle(color: Colors.grey)
                    : TextStyles.mlDynamicTextStyle,
                decoration: inputDecorationCountry ??
                    InputDecoration(
                      contentPadding: contentPadding,
                      border: OutlineInputBorder(),
                    ),
              ),
              Center(
                child: CountryCodePicker(
                    onChanged: onChanged,
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    initialSelection:
                        (country == "" || country == null) ? "IN" : country,
                    showFlag: true,
                    showFlagDialog: false,
                    enabled: !codeReadOnly,
                    textStyle: codeReadOnly
                        ? TextStyle(color: Colors.grey)
                        : TextStyles.mlDynamicTextStyle,
                    onInit: onInitCallback),
              ),
            ]),
          )),
          SizedBox(
            width: 3,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.7,
              child: TextFormField(
                readOnly: numberReadOnly,
                controller: phoneController,
                maxLength: 10,
                textInputAction: TextInputAction.next,
                style: numberReadOnly
                    ? TextStyle(color: Colors.grey)
                    : TextStyles.mlDynamicTextStyle,
                decoration: inputDecorationPhone ??
                    InputDecoration(
                        contentPadding: contentPadding,
                        errorMaxLines: 3,
                        border: OutlineInputBorder(),
                        labelText: hint),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                validator: mandatory ? ValidationUtils.mobileValidation : null,
                onSaved: (String value) {
                  // _phone = countryDialCode + value;
                },
              )),
        ]);
  }
}
