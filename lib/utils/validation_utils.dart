import '../ui/tabs/app_localizations.dart';
import '../utils/app_preferences.dart';
import '../utils/constants.dart';

class ValidationUtils {
  static bool isEmail(String email) {
    String passwordValidationRule =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(passwordValidationRule);
    return regExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    String passwordValidationRule =
        "^(?=.*[A-Z])(?=.*[a-z])^(?=.*[0-9\\!\\@\\.\\<\\>\\-_#\$%\\^&\\*])(?=.{8,})";

    RegExp regExp = RegExp(passwordValidationRule);
    return regExp.hasMatch(password);
  }

  static bool isValidName(String name) {
    RegExp regExpOne = RegExp(r'[~`@!#\$\^%&*()+=\[\]\\\\;,\/\{\}\|\":<>\?]');
    bool isMatched = regExpOne.hasMatch(name);
    RegExp regExpTwo = RegExp('[0-9]');
    bool isNumeric = regExpTwo.hasMatch(name);
    return isMatched || isNumeric;
  }

  static bool isAlphaNumeric(String value) {
    String nameValidationRule = "^[a-zA-Z0-9]+\$";
    RegExp regExp = RegExp(nameValidationRule);
    return regExp.hasMatch(value);
  }

  static bool isAlphabet(String value) {
    String nameValidationRule = "[~`@!#\$\^%&*()+=\[\]\\\\;,\/\{\}\|\":<>\?]";
    RegExp regExp = RegExp(nameValidationRule);
    return !regExp.hasMatch(value);
  }

  static bool isNumeric(String value) {
    String nameValidationRule = "[0-9]";
    RegExp regExp = RegExp(nameValidationRule);
    return regExp.hasMatch(value);
  }

  static bool zipCodeValidation(String value) {
    String nameValidationRule;
    if (value.length == 5 || value.length == 9) {
      nameValidationRule = "^[0-9]*\$";
      RegExp regExp = RegExp(nameValidationRule);
      return regExp.hasMatch(value);
    } else {
      return false;
    }
  }

  static bool zipCodeValidationFamilytree(String value) {
    String nameValidationRule;
    if (value.length >= 5) {
      nameValidationRule = "^[0-9]*\$";
      RegExp regExp = RegExp(nameValidationRule);
      return regExp.hasMatch(value);
    } else {
      return false;
    }
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    String mobileNoValidationRule;
    if (phoneNumber.length == 10) {
      mobileNoValidationRule = "^[0-9]*\$";
      RegExp regExp = RegExp(mobileNoValidationRule);
      return regExp.hasMatch(phoneNumber);
    } else {
      return false;
    }
  }

  static String validationDate(String value) {
    if (value.trim().length == 0)
      return 'Birth date is required ';
    else
      return null;
  }

  static bool isName(String em) {
    return RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(em);
  }

  static String firstNameValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validfirstname");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_firstnamecantbeblank");
    }
  }

  static String nameValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validname");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_firstnamecantbeblank");
    }
  }

  static String lastNameValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validlastname");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_lastnamecantbeblank");
    }
  }

  static String addressValidation(String arg) {
    if (arg.trim().length > 0) {
      return null;
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_addresscantbeblank");
    }
  }

  static String cityValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_valid_city");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_citycantbeblank");
    }
  }

  static String countyValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
                .translate("key_valid_county") +
            AppPreferences().countyLabelDonation;
    } else {
      return AppPreferences().countyLabelDonation +
          AppLocalizations.of(AppPreferences().mContext)
              .translate("key_countycantbeblank");
    }
  }

  static String stateValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_valid_state");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_statecantbeblank");
    }
  }

  static String stateValidationFamilyTree(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_valid_state");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_stateerror");
      ;
    }
  }

  static String countryValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_entervalidcountry");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_countrycannotblank");
    }
  }

  static String emailValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isEmail(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validemail");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_emailcantbrblank");
    }
  }

  static String streetValidation(String value) {
    if (value.length == 0)
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_addresscantbeblank");
    else
      return null;
  }

  static String mobileValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isValidPhoneNumber(arg)) {
        return null;
      } else {
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validphonenumber");
      }
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_phonenumbercantbeblank");
    }
  }

  static String usernameValidation(String arg) {
    if (arg.trim().length > 0) {
      if (RegExp(onlyAlphaNumeric).hasMatch(arg) &&
          RegExp(onlyAlphabets).hasMatch(arg[0]) &&
          arg.length > 1) {
        // REG EXP to avoid symbols and space
        return null;
      } else {
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validusername");
      }
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_usernamecantbeblank");
      ;
    }
  }

  static bool isNullEmptyOrFalse(String o) =>
      o == null || false == o || "" == o;

  static bool isNullEmptyFalseOrZero(Object o) =>
      o == null || false == o || 0 == o || "" == o;

  static bool isSuccessResponse(int statusCode) =>
      statusCode > 199 && statusCode < 300;

  static String secondaryPhoneNumberValidation(String value) {
    if (value.isEmpty)
      return null;
    else if (ValidationUtils.isValidPhoneNumber(value.trim()))
      return null;
    else
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_validphonenumber");
  }

  static String dynamicFieldsValidator(String arg,
      {String errorMessage: "Field cannot be blank"}) {
    if (arg.trim().length > 0) {
      return null;
    } else {
      return errorMessage;
    }
  }

  static String secondaryEmailValidation(String value) {
    if (value.isEmpty)
      return null;
    else if (ValidationUtils.isEmail(value.trim()))
      return null;
    else
      return Constants.VALIDATION_VALID_EMAIL;
  }

  static String atLeastOneCharacter = '.*[A-Za-z].*';
  static String onlyAlphabets = r'^[a-zA-Z]+$';
  static String onlyAlphaNumeric = r'^[a-zA-Z0-9]+$';

  static String physicianNameValidation(String arg) {
    if (arg.trim().length > 0) {
      if (isName(arg.trim()))
        return null;
      else
        return AppLocalizations.of(AppPreferences().mContext)
            .translate("key_validphysicianname");
    } else {
      return AppLocalizations.of(AppPreferences().mContext)
          .translate("key_physicianname");
    }
  }

  static String secondMobileValidation(String arg) {
    if (arg.trim().isEmpty) {
      return null;
    } else {
      if (isValidPhoneNumber(arg)) {
        return null;
      } else {
        return "Enter valid cell number";
      }
    }
  }

  static String receiptNoValidation(String arg) {
    if (arg.trim().length > 0) {
      if (RegExp(onlyAlphaNumeric).hasMatch(arg)) {
        // REG EXP to avoid symbols and space
        if (arg.trim().length < 6)
          return "Receipt number should be above 5 characters";
        else
          return null;
      } else {
        return "Please enter valid receipt number";
      }
    } else {
      if (arg.trim().length == 0)
        return "Receipt number cannot be blank";
      else
        return null;
    }
  }

  static String committeeTitleValidation(String arg) {
    if (arg.trim().length > 0) {
      return null;
    } else {
      if (arg.trim().length == 0) return "Title cannot be blank";
    }
  }

  static String dynamicSliderTextFieldsValidator(String arg,
      {String errorMessage: "Field cannot be blank", double lcl, double ucl}) {
    if (arg.trim().length > 0) {
      if (arg[0] == ".") {
        arg = "0" + arg;
      }
      if (double.parse(arg.trim()) >= lcl && double.parse(arg.trim()) <= ucl) {
        return null;
      } else {
        return "Value should be between $lcl and $ucl";
      }
    } else {
      return errorMessage;
    }
  }

  static bool validStringOrNot(String str) {
    return str == null || str.isEmpty || str == "null";
  }
}
