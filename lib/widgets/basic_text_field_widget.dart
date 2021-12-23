import '../ui_utils/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle textStyle;
  final String hint;
  final bool readOnly;
  final int maxLine;
  final GestureTapCallback onTap;
  final FormFieldValidator<String> validator;

  BasicTextField(
      {this.controller,
      this.validator,
      this.hint,
      this.textStyle,
      this.maxLine = 1,
      this.onTap,
      this.readOnly: false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: TextFormField(
          readOnly: readOnly,
          onTap: onTap,
          controller: controller,
          autocorrect: false,
          textInputAction: TextInputAction.next,
          validator: validator,
          onSaved: (String val) {},
          obscureText: false,
          maxLines: maxLine,
          keyboardType: TextInputType.emailAddress,
          style: textStyle,
          decoration: WidgetStyles.decoration(hint),
          inputFormatters: hint == "Username"
              ? [BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))]
              : null,
        ));
  }
}
