import '../ui/tabs/app_localizations.dart';
import '../ui_utils/widget_styles.dart';
import '../utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInCardWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final bool enabled;

  SignInCardWidget(
      {this.usernameController, this.passwordController, this.enabled: true});

  @override
  SignInCardWidgetState createState() => SignInCardWidgetState();
}

class SignInCardWidgetState extends State<SignInCardWidget> {
  TextStyle style = TextStyle();

  bool isLoginSelected = true;

  bool loginPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      enabled: widget.enabled,
      controller: widget.usernameController,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
      ],
      validator: ValidationUtils.usernameValidation,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      decoration: WidgetStyles.decoration(
          AppLocalizations.of(context).translate("key_username")),
    );

    final passwordField = TextFormField(
        enabled: widget.enabled,
        textInputAction:
            isLoginSelected ? TextInputAction.done : TextInputAction.next,
        controller: widget.passwordController,
        obscureText: loginPasswordVisible,
        validator: (String arg) {
          if (arg.length > 0) {
            return null;
          } else {
            return AppLocalizations.of(context)
                .translate("key_passwordcantbeblank");
          }
        },
        maxLines: 1,
        decoration: WidgetStyles.decoration(
            AppLocalizations.of(context).translate("key_password")));

    return Column(
      children: <Widget>[
        SizedBox(height: 14),
        emailField,
        SizedBox(height: 14),
        passwordField
      ],
    );
  }
}
