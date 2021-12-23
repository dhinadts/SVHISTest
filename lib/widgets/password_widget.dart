import '../login/colors/color_info.dart';
import '../login/utils.dart';
import '../ui/tabs/app_localizations.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';

class PasswordWidget extends StatefulWidget {
  final TextEditingController passwordController;

  PasswordWidget({this.passwordController});

  @override
  PasswordWidgetState createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {
  TextStyle style = TextStyle(
      fontFamily: Constants.LatoRegular,
      fontSize: 15.0,
      color: Color(ColorInfo.BLACK));
  bool isLoginSelected = true;
  bool _loginSutoValidate = false;
  bool newPasswordVisible = true;
  bool confirmNewPasswordVisible = true;
  bool showValidationDetails = false;

  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  bool isEightChar = false;
  bool isValidPassword = false;

  final myConfirmNewPasswordController = TextEditingController();

  var subscription;
  bool isAnimViewShow = false;

  String SUCCESS = "success", ERROR = "error";

  var enabledBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(15.0)));

  String initalValueForText = "";

  bool isRememberMeChecked = false;
  bool isTermsAndConditionChecked = false;

  @override
  Widget build(BuildContext context) {
    final newPassword = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: TextFormField(
                textInputAction: isLoginSelected
                    ? TextInputAction.done
                    : TextInputAction.next,
                controller: widget.passwordController,
                obscureText: newPasswordVisible,
                style: style,
                validator: validatePassword,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate("key_newpwd"),
                  hintStyle: Utils.hintStyleBlack,
                  errorMaxLines: 3,
                  fillColor: Colors.transparent,
                  filled: true,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(color: Colors.red)),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: enabledBorder,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        newPasswordVisible = !newPasswordVisible;
                      });
                    },
                  ),
                ),
              ))
        ]);
    final confirmNewPassword = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: TextFormField(
                textInputAction: isLoginSelected
                    ? TextInputAction.done
                    : TextInputAction.next,
                controller: myConfirmNewPasswordController,
                obscureText: confirmNewPasswordVisible,
                style: style,
                validator: (String arg) {
                  if (arg.length > 0) {
                    if (arg != widget.passwordController.text) {
                      return AppLocalizations.of(context)
                          .translate("key_match_pass_error");
                    } else {
                      return null;
                    }
                  } else {
                    return AppLocalizations.of(context)
                        .translate("key_confirmpassword");
                  }
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate("key_confirmnewpwd"),
                  hintStyle: Utils.hintStyleBlack,
                  errorMaxLines: 3,
                  fillColor: Colors.transparent,
                  filled: true,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(color: Colors.red)),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: enabledBorder,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      confirmNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        confirmNewPasswordVisible = !confirmNewPasswordVisible;
                      });
                    },
                  ),
                ),
              ))
        ]);

    final resetPasswordPanel = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          newPassword,
          if (showValidationDetails) showValidationsDetailRow(),
          SizedBox(
            height: 5,
          ),
          confirmNewPassword,
        ],
      ),
    );

    // Sign up Container

    // Main View Design
    return resetPasswordPanel;
  }

  Widget showValidationsDetailRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(
                Icons.check_circle,
                size: 20,
                color: isEightChar ? Colors.green : null,
              ),
              title: new Text(
                AppLocalizations.of(context).translate("key_mustbe"),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  size: 20, color: hasDigits ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_aleast"),
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  size: 20, color: hasUppercase ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_capital"),
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  size: 20, color: hasLowercase ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_small"),
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          SizedBox(
            height: 47,
            child: ListTile(
              leading: Icon(Icons.check_circle,
                  size: 20, color: hasSpecialCharacters ? Colors.green : null),
              title: new Text(
                AppLocalizations.of(context).translate("key_special"),
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  validatePasswordCompilance(String password) {
    // print(password);
    if (!password?.isEmpty) {
      // Check if valid special characters are present
      hasSpecialCharacters =
          password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasUppercase = password.contains(new RegExp(r'^(?=.*?[A-Z])'));
      hasLowercase = password.contains(new RegExp(r'^(?=.*?[a-z])'));
      hasDigits = password.contains(new RegExp(r'^(?=.*?[0-9])'));
    } else {
      hasUppercase = false;
      hasDigits = false;
      hasLowercase = false;
      hasSpecialCharacters = false;
    }

    if (password.length >= 8) {
      isEightChar = true;
    } else {
      isEightChar = false;
    }

    if (hasUppercase &&
        hasDigits &&
        hasLowercase &&
        hasSpecialCharacters &&
        isEightChar) {
      isValidPassword = true;
    } else {
      isValidPassword = false;
    }
  }

  String validatePassword(String value) {
    validatePasswordCompilance(value.trim());
    if (value.isEmpty) {
      return AppLocalizations.of(context).translate("key_newpassword");
    } else {
//      validatePasswordCompilance(value.trim());
      if (isValidPassword) {
        showValidationDetails = false;
        return null;
      } else {
        showValidationDetails = true;
        return AppLocalizations.of(context).translate("key_doesntmatch");
      }
    }
  }
}
